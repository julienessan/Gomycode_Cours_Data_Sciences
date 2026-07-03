/* 3 - Affichez par ordre décroissant d’ancienneté les employés masculins dont le salaire net (salaire + commission) est supérieur ou égal à 8000. 
Le tableau résultant doit inclure les colonnes suivantes : 
Numéro d’employé, Prénom et Nom, Âge et Ancienneté. */


SELECT EMPLOYEES.LAST_NAME AS Prénom, EMPLOYEES.FIRST_NAME AS Nom, FLOOR(DATEDIFF(DAY, BIRTH_DATE, '2026-07-01')/365.25) AS Age, EMPLOYEES.HIRE_DATE AS Ancienneté,  (SALARY + ISNULL(COMMISSION,0)) AS Salaire_Net
FROM EMPLOYEES
WHERE (SALARY + ISNULL(COMMISSION,0)) >= 8000
ORDER BY Ancienneté DESC;

/* 4- Affichez les produits qui répondent aux critères suivants : (C1) la quantité est conditionnée en bouteille(s), 
(C2) le troisième caractère du nom du produit est 't' ou 'T', (C3) fournis par les fournisseurs 1, 2 ou 3, (C4) 
le prix unitaire est compris entre 70 et 200, et (C5) les unités commandées sont spécifiées (non nulles). 
Le tableau résultant doit inclure les colonnes suivantes : numéro de produit, nom du produit, numéro du 
fournisseur, unités commandées et prix unitaire. */

SELECT PRODUCTS.PRODUCT_REF AS Numéro_produit, PRODUCTS.PRODUCT_NAME AS Nom_produit, PRODUCTS.SUPPLIER_int AS  numéro_fournisseur, PRODUCTS.UNITS_ON_ORDER AS unités_commandées, PRODUCTS.UNIT_PRICE AS prix_unitaire
FROM PRODUCTS
WHERE PRODUCTS.QUANTITY LIKE '%bottles%'
	  AND PRODUCTS.PRODUCT_NAME LIKE '__[tT]%'
	  AND PRODUCTS.SUPPLIER_int IN (1,2, 3)
	  AND PRODUCTS.UNIT_PRICE BETWEEN 70 AND 200
	  AND PRODUCTS.UNITS_ON_ORDER IS NOT NULL;

/* 5 - Affichez les clients qui résident dans la même région que le fournisseur 1, c’est-à-dire qui partagent le même pays,
la même ville et les trois derniers chiffres du code postal. La requête doit utiliser une seule sous-requête. Le tableau 
résultant doit inclure toutes les colonnes de la table client. */

SELECT c.*
FROM CUSTOMERS c
INNER JOIN (
    SELECT COUNTRY, CITY, RIGHT(POSTAL_CODE, 3) AS POSTAL3
    FROM SUPPLIERS
    WHERE SUPPLIER_int = 1
) s
    ON c.COUNTRY = s.COUNTRY
   AND c.CITY = s.CITY
   AND RIGHT(c.POSTAL_CODE, 3) = s.POSTAL3;

/* 6- Pour chaque numéro de commande entre 10998 et 11003, faites ce qui suit : 
- Affichez le nouveau taux de remise, qui doit être de 0% si le montant total de 
   la commande avant remise (prix unitaire * quantité) est compris entre 0 et 2000, 
   5% s’il est entre 2001 et 10000, 10% s’il est entre 10001 et 40000, 15% s’il est entre 40001 et 80000, et 20% sinon.
- Affichez le message "appliquer l’ancien taux de remise" si le numéro de commande est compris entre 10000 et 10999, 
  et "appliquer le nouveau taux de remise" sinon. Le tableau résultant doit afficher les colonnes : numéro de commande,
  nouveau taux de remise et note d’application du taux de remise. */

SELECT o.ORDER_NUMBER,
CASE 
    WHEN (scm.prix_unitaire * scm.quantity) BETWEEN 0 AND 2000 THEN '0%'
    WHEN (scm.prix_unitaire * scm.quantity) BETWEEN 2001 AND 10000 THEN '2%'
    WHEN (scm.prix_unitaire * scm.quantity) BETWEEN 10001 AND 40000 THEN '10%'
    WHEN (scm.prix_unitaire * scm.quantity) BETWEEN 40001 AND 80000 THEN '15%'
    ELSE '20%'
END AS nouveau_taux_de_remise,
CASE 
    WHEN o.ORDER_NUMBER BETWEEN 10000 AND 10999 THEN 'appliquer l’ancien taux de remise'
    ELSE 'appliquer le nouveau taux de remise'
END AS note_application_du_taux_de_remise
FROM ORDERS o
INNER JOIN (
    SELECT ORDER_DETAILS.ORDER_NUMBER AS numéro_commande, SUM(ORDER_DETAILS.UNIT_PRICE) AS prix_unitaire, SUM(ORDER_DETAILS.QUANTITY) AS quantity 
  FROM ORDER_DETAILS
  GROUP BY ORDER_DETAILS.ORDER_NUMBER
) scm
    ON o.ORDER_NUMBER = scm.numéro_commande
  WHERE o.ORDER_NUMBER BETWEEN 10998 AND 11003;


/* 7- Affichez les fournisseurs de produits de boissons. Le tableau résultant doit afficher les colonnes : 
numéro du fournisseur, société, adresse et numéro de téléphone. */
SELECT SUPPLIERS.SUPPLIER_int AS Numéro_du_fournisseur,  SUPPLIERS.COMPANY AS Société,  SUPPLIERS.ADDRESS AS Adresse, SUPPLIERS.PHONE AS numéro_de_téléphone
FROM SUPPLIERS
INNER JOIN (SELECT * FROM PRODUCTS WHERE PRODUCTS.CATEGORY_CODE = 1) AS P
ON P.SUPPLIER_int = SUPPLIERS.SUPPLIER_int
GROUP BY SUPPLIERS.SUPPLIER_int, SUPPLIERS.COMPANY, SUPPLIERS.ADDRESS, SUPPLIERS.PHONE;

/* 8- Affichez les clients de Berlin ayant commandé au plus 1 (0 ou 1) produit dessert. Le tableau résultant 
doit afficher la colonne : code client. */

SELECT ORDERS.CUSTOMER_CODE AS code_client
FROM ORDERS
LEFT JOIN CUSTOMERS
ON ORDERS.CUSTOMER_CODE = CUSTOMERS.CUSTOMER_CODE
LEFT JOIN ( SELECT ORDER_DETAILS.ORDER_NUMBER, COUNT(ORDER_DETAILS.PRODUCT_REF) AS Nb_cmd_prod_dessert
FROM ORDER_DETAILS
iNNER JOIN (SELECT PRODUCTS.PRODUCT_REF, PRODUCTS.CATEGORY_CODE FROM PRODUCTS
            WHERE PRODUCTS.CATEGORY_CODE = 3) AS P
ON ORDER_DETAILS.PRODUCT_REF = P.PRODUCT_REF
GROUP BY ORDER_DETAILS.ORDER_NUMBER) cmd
ON ORDERS.ORDER_NUMBER = cmd.ORDER_NUMBER
WHERE cmd.Nb_cmd_prod_dessert <= 1
      AND CUSTOMERS.CITY = 'Berlin';

/*9- Affichez les clients résidant en France et le montant total des commandes qu’ils ont 
passées chaque lundi d’avril 1998 (en tenant compte des clients n’ayant pas encore passé de commande). 
Le tableau résultant doit afficher les colonnes : numéro client, nom de la société, numéro de téléphone, 
montant total et pays. */

SELECT CUSTOMERS.CUSTOMER_CODE AS numéro_client, CUSTOMERS.COMPANY AS nom_de_la_société, CUSTOMERS.PHONE AS numéro_de_téléphone, MT.montant_total, CUSTOMERS.COUNTRY AS Pays
FROM CUSTOMERS
LEFT JOIN ORDERS
ON ORDERS.CUSTOMER_CODE = CUSTOMERS.CUSTOMER_CODE
LEFT JOIN (SELECT  ORDER_DETAILS.ORDER_NUMBER, SUM((ORDER_DETAILS.QUANTITY * ORDER_DETAILS.UNIT_PRICE)) AS montant_total 
            FROM ORDER_DETAILS
            GROUP BY ORDER_DETAILS.ORDER_NUMBER) AS MT
ON MT.ORDER_NUMBER = ORDERS.ORDER_NUMBER
WHERE CUSTOMERS.COUNTRY = 'France'
      AND ORDERS.ORDER_DATE BETWEEN '1998-04-01' AND '1998-04-30'
      AND DATENAME(dw, ORDERS.ORDER_DATE) IN ('Monday', 'Lundi');

/* 10- Affichez les clients ayant commandé tous les produits. Le tableau résultant doit afficher les colonnes : 
code client, nom de la société et numéro de téléphone. */

SELECT c.CUSTOMER_CODE AS code_client,
       c.COMPANY       AS nom_de_la_société,
       c.PHONE         AS numéro_de_téléphone
FROM CUSTOMERS c
JOIN ORDERS o
    ON o.CUSTOMER_CODE = c.CUSTOMER_CODE
JOIN ORDER_DETAILS od
    ON od.ORDER_NUMBER = o.ORDER_NUMBER
GROUP BY c.CUSTOMER_CODE, c.COMPANY, c.PHONE
HAVING COUNT(DISTINCT od.PRODUCT_REF) = (
    SELECT COUNT(*)
    FROM PRODUCTS
);


/* 11- Affichez pour chaque client de France le nombre de commandes qu’il a passées. Le tableau résultant doit afficher les colonnes : 
code client et nombre de commandes. */
SELECT ORDERS.CUSTOMER_CODE, COUNT(ORDERS.ORDER_NUMBER) AS nombre_de_commandes 
FROM ORDERS
GROUP BY ORDERS.CUSTOMER_CODE;


/* 12- Affichez le nombre de commandes passées en 1996, le nombre de commandes passées en 1997, et la différence entre ces deux nombres. 
Le tableau résultant doit afficher les colonnes : commandes en 1996, commandes en 1997 et Différence. */

SELECT
    COUNT(CASE WHEN YEAR(ORDER_DATE) = 1996 THEN 1 END) AS commandes_en_1996,
    COUNT(CASE WHEN YEAR(ORDER_DATE) = 1997 THEN 1 END) AS [commandes_en_1997],
    COUNT(CASE WHEN YEAR(ORDER_DATE) = 1997 THEN 1 END)  - COUNT(CASE WHEN YEAR(ORDER_DATE) = 1996 THEN 1 END) AS Différence
FROM ORDERS;