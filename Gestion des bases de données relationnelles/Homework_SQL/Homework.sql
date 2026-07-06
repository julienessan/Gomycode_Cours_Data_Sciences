/*==============================================================*/
/* Partie II : Questions SQL                                 */
/*==============================================================*/

## Niveau 1 (SELECT)

### Question 1: Afficher tous les employés.
SELECT * FROM sql_hr.employees;
---

### Question 2: Afficher uniquement le prénom et le salaire des employés.
SELECT first_name, salary FROM sql_hr.employees;

### Question 3: Afficher tous les produits disponibles.
SELECT * FROM sql_inventory.products;

### Question 4: Afficher tous les clients.


SELECT * FROM invoicing.clients;

### Question 34: Afficher le nom du manager de chaque employé.
SELECT e.first_name AS employee_first_name, e.last_name AS employee_last_name, m.first_name AS manager_first_name, m.last_name AS manager_last_name
FROM sql_hr.employees e 
LEFT JOIN sql_hr.employees m ON e.reports_to = m.employee_id;   

/*====================================*/
## Niveau 9 (LEFT JOIN)
/*====================================*/

### Question 35: Afficher tous les clients, même ceux qui n'ont jamais passé de commande.
SELECT c.first_name, c.last_name, o.order_date
FROM store.customers c
LEFT JOIN store.orders o ON c.customer_id  = o.customer_id;  



### Question 36: Afficher tous les produits, même ceux jamais commandés
SELECT p.name, p.quantity_in_stock, p.unit_price, COUNT(oi.order_id) AS order_count
FROM store.products p
LEFT JOIN store.order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id;

### Question 37: Afficher tous les bureaux, même sans employé
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