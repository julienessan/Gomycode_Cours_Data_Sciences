/*==============================================================*/
/* Partie II : Questions SQL                                 */
/*==============================================================*/

/*=======================*/
## Niveau 1 (SELECT)
/*=======================*/

### Question 1: Afficher tous les employés.
SELECT * FROM sql_hr.employees;

### Question 2: Afficher uniquement le prénom et le salaire des employés.
SELECT first_name, salary FROM sql_hr.employees;

### Question 3: Afficher tous les produits disponibles.
SELECT * FROM sql_inventory.products;

### Question 4: Afficher tous les clients.
SELECT * FROM store.customers;

### Question 5: Afficher les factures.
SELECT * FROM invoicing.invoices;

/*=======================*/
## Niveau 2 (WHERE)
/*=======================*/

### Question 6: Afficher les employés dont le salaire dépasse 90 000.
SELECT * FROM sql_hr.employees
WHERE salary > 90000;

### Question 7: Afficher les employés travaillant dans le bureau numéro 3.
SELECT * FROM sql_hr.employees
WHERE office_id = 3;


### Question 8: Afficher les produits dont le prix est supérieur à 3 dollars.
SELECT * FROM store.products
WHERE unit_price > 3;


### Question 9: Afficher les clients habitant dans l'État **CA**.
SELECT * FROM invoicing.clients
WHERE state ='CA';

### Question 10: Afficher les commandes passées après le 1 janvier 2018.
SELECT * FROM store.orders
WHERE order_date > '2018-01-01';


/*=======================*/
## Niveau 3 (ORDER BY)
/*=======================*/

### Question 11: Afficher les employés du plus grand salaire au plus petit.
SELECT * FROM sql_hr.employees
ORDER BY salary DESC;

### Question 12: Afficher les produits classés par prix croissant.
SELECT * FROM store.products
ORDER BY unit_price ASC;

### Question 13: Afficher les clients classés par nombre de points décroissant.
SELECT * FROM store.customers
ORDER BY points DESC;

/*=======================*/
## Niveau 4 (LIMIT)
/*=======================*/

### Question 14: Afficher les 5 employés les mieux payés.
SELECT * FROM sql_hr.employees
ORDER BY salary DESC
LIMIT 5;

### Question 15: Afficher les 3 produits les moins chers.
SELECT * FROM store.products
ORDER BY unit_price ASC
LIMIT 3;


/*====================================*/
## Niveau 5 (Fonctions d'agrégation)
/*====================================*/

### Question 16: Quel est le salaire moyen des employés ?
SELECT AVG(salary) AS Salaire_Moyen FROM sql_hr.employees;

### Question 17:Quel est le salaire maximal ?
SELECT MAX(salary) AS Salaire_Maximal FROM sql_hr.employees;


### Question 18: Quel est le salaire minimal ?
SELECT MIN(salary) AS Salaire_Maximal FROM sql_hr.employees;


### Question 19: Combien y a-t-il d'employés ?
SELECT COUNT(*) AS Nombre_Employees FROM sql_hr.employees;

### Question 20: Quelle est la valeur totale du stock ? *(quantité × prix)*
SELECT SUM(quantity_in_stock * unit_price) AS Valeur_Total_Stock FROM sql_inventory.products;

/*====================================*/
## Niveau 6 (GROUP BY)
/*====================================*/

### Question 21: Calculer le salaire moyen par bureau.
SELECT office_id, AVG(salary) AS Salaire_Moyen 
FROM sql_hr.employees
GROUP BY office_id;

### Question 22: Compter le nombre d'employés par bureau.
SELECT office_id, COUNT(*) AS Nb_Employés 
FROM sql_hr.employees
GROUP BY office_id;


### Question 23: Compter le nombre de clients par État.
SELECT state, COUNT(*) AS Nb_Clients
FROM store.customers
GROUP BY state;


### Question 24: Calculer le montant total facturé par client.
SELECT client_id, SUM(payment_total) Montant_total_Facture
FROM invoicing.invoices
GROUP BY client_id;


### Question 25: Calculer le nombre de commandes par client.
SELECT customer_id, COUNT(*) AS Nb_Commande
FROM store.orders
GROUP BY customer_id;

/*====================================*/
## Niveau 7 (HAVING)
/*====================================*/

### Question 26: Afficher les bureaux possédant plus de deux employés.
SELECT office_id, COUNT(*) AS Nb_Employés 
FROM sql_hr.employees
GROUP BY office_id
HAVING COUNT(*) >2;


### Question 27: Afficher les clients ayant plus d'une facture.
SELECT customer_id, COUNT(*) AS Nb_Commande
FROM store.orders
GROUP BY customer_id
HAVING COUNT(*) > 1 ;


### Question 28: Afficher les États ayant au moins deux clients.
SELECT state, COUNT(*) AS Nb_Clients
FROM store.customers
GROUP BY state
HAVING COUNT(*) >= 2;

/*====================================*/
## Niveau 8 (Jointures)
/*====================================*/

### Question 29
/*Afficher :
- prénom
- nom
- ville du bureau */

SELECT e.first_name as prénom, e.last_name as nom, o.city as ville_du_bureau
FROM sql_hr.employees e
LEFT JOIN sql_hr.offices o
ON e.office_id = o.office_id;

### Question 30
/*Afficher :
- nom du client
- numéro de commande
- date de commande */
SELECT c.first_name as nom_du_client, c.last_name as numéro_de_commande, o.order_id, o.order_date as date_de_commande
FROM store.orders o
LEFT JOIN store.customers c
ON o.customer_id = c.customer_id;

### Question 31
/* Afficher :
- numéro de commande
- nom du produit
- quantité */

SELECT oi.order_id as numéro_de_commande, p.name as nom_du_produit, oi.quantity as nom_du_produit
FROM store.order_items oi
LEFT JOIN store.products p
ON oi.product_id = p.product_id ;

### Question 32
/* Afficher :
- numéro de facture
- nom du client
- montant de la facture */
SELECT i.number as numéro_de_facture, c.name as nom_du_client, i.invoice_total as montant_de_la_facture
FROM invoicing.invoices i
LEFT JOIN invoicing.clients c
ON c.client_id = i.client_id;


### Question 33
/*Afficher :
- paiement
- méthode de paiement
- nom du client */
SELECT p.payment_id, pm.name as méthode_de_paiement, c.name as nom_du_client
FROM invoicing.payments p
LEFT JOIN  invoicing.payment_methods pm
ON pm.payment_method_id = p.payment_method
LEFT JOIN  invoicing.clients c
ON c.client_id = p.client_id;


### Question 34: Afficher le nom du manager de chaque employé.
SELECT e.first_name as prénom_employé, e.last_name as nom_employé, m.first_name as prénom_manager, m.last_name as nom_manager
FROM sql_hr.employees e
LEFT JOIN sql_hr.employees m
ON e.reports_to = m.employee_id;

/*====================================*/
## Niveau 9 (LEFT JOIN)
/*====================================*/

### Question 35: Afficher tous les clients, même ceux qui n'ont jamais passé de commande.
SELECT c.first_name, c.last_name, o.order_date
FROM store.customers c
LEFT JOIN store.orders o ON c.customer_id  = o.customer_id;  


### Question 36: Afficher tous les produits, même ceux jamais commandés.
SELECT p.name, p.quantity_in_stock, p.unit_price, COUNT(oi.order_id) AS order_count
FROM store.products p
LEFT JOIN store.order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id;


### Question 37: Afficher tous les bureaux, même sans employé.
SELECT o.address, o.city, o.state, COUNT(e.employee_id) AS employee_count
FROM sql_hr.offices o
LEFT JOIN sql_hr.employees e ON o.office_id = e.office_id
GROUP BY o.office_id;

/*====================================*/
## Niveau 10 (Sous-requêtes)
/*====================================*/

### Question 38: Afficher les employés gagnant plus que le salaire moyen.
SELECT first_name, last_name, salary
FROM sql_hr.employees
WHERE salary > (SELECT AVG(salary) FROM sql_hr.employees);


### Question 39: Afficher le produit le plus cher
SELECT name, unit_price
FROM sql_inventory.products
WHERE unit_price = (SELECT MAX(unit_price) FROM sql_inventory.products);

### Question 40: Afficher les clients ayant dépensé plus que la moyenne.
SELECT c.name Nom_Client, SUM(i.invoice_total) AS total_dépensé
FROM invoicing.clients c 
JOIN invoicing.invoices i ON c.client_id = i.client_id
GROUP BY c.client_id
HAVING SUM(i.invoice_total) > (SELECT AVG(total_dépensé) FROM (SELECT client_id, SUM(invoice_total) AS total_dépensé FROM invoicing.invoices GROUP BY client_id) AS dépenses_moyennes);


### Question 41: Afficher les employés travaillant dans le même bureau que l'employé **Yovonnda Magrannell**.
SELECT e.first_name, e.last_name, e.office_id
FROM sql_hr.employees e
WHERE e.office_id = (SELECT office_id FROM sql_hr.employees WHERE first_name = 'Yovonnda' AND last_name = 'Magrannell') AND (e.first_name != 'Yovonnda' OR e.last_name != 'Magrannell');

/*====================================*/
## Niveau 11 (INSERT)
/*====================================*/

### Question 42: Ajouter un nouveau produit.
INSERT INTO store.products (name, quantity_in_stock, unit_price) VALUES ('Attiéké', 100, 9.99);


### Question 43: Ajouter un nouveau client.
INSERT INTO invoicing.clients (name, address, city, state, phone) VALUES ('Essan Julien', '123 Abidjan cocody', 'Abidjan', 'CD', '075-795-521');


### Question 44: Ajouter un nouvel employé.
INSERT INTO sql_hr.employees (first_name, last_name, job_title, salary, reports_to ,office_id) VALUES ('Ano', 'ESSAN', 'informaticien', 5000000, 37270, 3);


/*====================================*/
## Niveau 12 (UPDATE)
/*====================================*/

### Question 45: Augmenter de 10 % le salaire des employés du bureau 2.
UPDATE sql_hr.employees
SET salary = salary * 1.10
WHERE office_id = 2;


### Question 46: Ajouter 500 points aux clients de Californie.
update store.customers
set points = points + 500
where state = 'CA';


### Question 47: Modifier le prix d'un produit.
UPDATE store.products
SET unit_price = 9.9
WHERE name = 'Island Oasis - Raspberry';

/*====================================*/
## Niveau 13 (DELETE)
/*====================================*/

### Question 48: Supprimer un produit.
DELETE FROM store.products
WHERE product_id = 10;


### Question 49: Supprimer un client sans facture.
DELETE FROM invoicing.clients
WHERE client_id NOT IN (SELECT DISTINCT client_id FROM invoicing.invoices);


### Question 50: Supprimer un employé qui n'est le manager de personne.
DELETE FROM sql_hr.employees
WHERE employee_id NOT IN (SELECT DISTINCT reports_to FROM sql_hr.employees WHERE reports_to IS NOT NULL);


/*====================================*/
# Partie III : Défis (Bonus)
/*====================================*/

### Défi 1: Calculer le chiffre d'affaires total réalisé par chaque client.
SELECT c.name AS Nom_client, SUM(i.invoice_total) AS total_revenue
FROM invoicing.clients c
JOIN invoicing.invoices i ON c.client_id = i.client_id
GROUP BY c.client_id;


### Défi 2: Trouver le client ayant effectué le plus de commandes.
SELECT c.name AS Nom_client, COUNT(i.invoice_id) AS total_orders
FROM invoicing.clients c
JOIN invoicing.invoices i ON c.client_id = i.client_id
GROUP BY c.client_id
ORDER BY total_orders DESC
LIMIT 1;


### Défi 3: Trouver les 5 produits les plus vendus.
SELECT p.name AS nom_du_produit, SUM(oi.quantity) AS quantité_totale_vendue
FROM store.products p
JOIN store.order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY quantité_totale_vendue DESC
LIMIT 5;


### Défi 4: Trouver les employés ayant un salaire supérieur à celui de leur manager.
SELECT e.first_name AS prénom_employé, e.last_name AS nom_employé, e.salary AS salaire_employé, m.first_name AS prénom_manager, m.last_name AS nom_manager, m.salary AS salaire_manager
FROM sql_hr.employees e
JOIN sql_hr.employees m ON e.reports_to = m.employee_id
WHERE e.salary > m.salary;


### Défi 5: Afficher les commandes dont la valeur totale dépasse 100 $.
select o.order_id, SUM(oi.quantity * oi.unit_price) AS valeur_totale_de_la_commande
from store.orders o
join store.order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING valeur_totale_de_la_commande > 100;


### Défi 6: Afficher les bureaux classés selon leur masse salariale totale
SELECT o.office_id, o.address, o.city, o.state, SUM(e.salary) AS masse_salariale_totale
FROM sql_hr.offices o
JOIN sql_hr.employees e ON o.office_id = e.office_id
GROUP BY o.office_id, o.address, o.city, o.state
ORDER BY masse_salariale_totale DESC;

### Défi 7: Calculer le panier moyen des commandes.
SELECT AVG(order_total) AS panier_moyen
FROM (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM store.orders o
    JOIN store.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS order_totals;  



### Défi 8: Trouver les clients qui n'ont jamais payé une facture.
SELECT c.name AS Nom_client
FROM invoicing.clients c
LEFT JOIN invoicing.invoices i ON c.client_id = i.client_id
WHERE i.client_id IS NULL;


### Défi 9: Afficher le montant restant à payer pour chaque facture (`invoice_total - payment_total`)
SELECT i.invoice_id, (i.invoice_total - i.payment_total) AS montant_restant_à_payer
FROM invoicing.invoices i;


### Défi 10: Créer une vue SQL nommée `top_customers` qui affiche les clients dont les achats dépassent 500 $.
CREATE VIEW top_customers AS
SELECT c.name AS Nom_client, SUM(i.invoice_total) AS total_achats
FROM invoicing.clients c
JOIN invoicing.invoices i ON c.client_id = i.client_id
GROUP BY c.client_id, c.name
HAVING total_achats > 500;