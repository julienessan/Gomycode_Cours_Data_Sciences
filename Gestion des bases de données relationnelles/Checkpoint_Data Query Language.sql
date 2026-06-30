/* 1- Nom des Employés qui sont affectés à plus d'un projet, y compris le nombre total de projets pour chaque employé */
SELECT employes.Nom, COUNT(*) AS nbprojet
FROM Employe_Projet 
LEFT JOIN employes
ON Employe_Projet.Employes_Num_E = employes.Num_E
GROUP BY Employes_Num_E, employes.Nom
HAVING COUNT(*) > 1;

/* 2- liste des projets gérés par chaque département */
SELECT projet.Titre AS Projet, Departement.Libelle AS Departement, Departement.Nom_du_manager
FROM projet
LEFT JOIN Departement
ON projet.Departement_Num_S = Departement.Num_S
ORDER BY Departement;

/* 3- récupérer les noms des employés travaillant sur le projet "Website Redesign */

SELECT employes.Nom, Employe_Projet.Rôle, projet.Titre AS Projet
FROM Employe_Projet
LEFT JOIN employes
ON Employe_Projet.Employes_Num_E = employes.Num_E
LEFT JOIN projet
ON Employe_Projet.Projet_Num_P = projet.Num_P
WHERE Employe_Projet.Projet_Num_P = 201;

/* 4 - récupérer le département ayant le plus grand nombre d'employés, y compris le libellé du département, le nom du responsable et le nombre total d'employés. */

SELECT TOP 1 Departement.Libelle, Departement.Nom_du_manager, COUNT(employes.Departement_Num_S) As Nb_employes
FROM Departement
LEFT JOIN employes
ON Departement.Num_S = employes.Departement_Num_S
GROUP BY Departement.Libelle, Departement.Nom_du_manager
ORDER BY Nb_employes DESC;


/* 5 - récupérer les noms et postes des employés percevant un salaire supérieur à 60 000, y compris le nom de leur département. */

SELECT employes.Nom, employes.Position,employes.Salaire, Departement.Libelle AS Departement
FROM employes
LEFT JOIN Departement
ON employes.Departement_Num_S = Departement.Num_S
WHERE employes.Salaire > 60000;

/* 6 - récupérer le nombre d'employés affectés à chaque projet, y compris le titre du projet. */
SELECT projet.Titre, COUNT(Employe_Projet.Employes_Num_E) AS nb_employes
FROM Employe_Projet
LEFT JOIN projet
ON projet.Num_P = Employe_Projet.Projet_Num_P
GROUP BY Employe_Projet.Projet_Num_P, projet.Titre;

/* 7 - récupérer un résumé des rôles que les employés occupent dans différents projets, y compris le nom de l'employé, le titre du projet et le rôle */

SELECT employes.Nom, projet.Titre, Employe_Projet.Rôle
FROM Employe_Projet
LEFT JOIN projet
ON projet.Num_P = Employe_Projet.Projet_Num_P
LEFT JOIN employes
ON employes.Num_E = Employe_Projet.Employes_Num_E;

/* 8- récupérer la dépense salariale totale pour chaque département, y compris le libellé du département et le nom du responsable */
SELECT Departement.Libelle AS Departement, Departement.Nom_du_manager, SUM(employes.Salaire) AS Salaire
FROM employes
LEFT JOIN Departement
ON Departement.Num_S = employes.Departement_Num_S
GROUP BY Departement.Libelle, Departement.Nom_du_manager;
