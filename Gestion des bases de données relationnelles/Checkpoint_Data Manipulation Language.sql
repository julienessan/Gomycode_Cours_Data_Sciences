/* 1- Insection des enregistrements */

/* Table Departement */
INSERT INTO Departement VALUES
(1, 'IT', 'Alice Johnson'),
(2, 'HR', 'Bob Smith'),
(3, 'Marketing', 'Clara Bennett');

/* Table Employé */
INSERT INTO employes VALUES
(101, 'John Doe', 'Développeur',  60000.00, 1),
(102, 'Jane Smith', 'Analyste',  55000.00, 2),
(103, 'Mike Brown', 'Concepteur',  50000.00, 3),
(104, 'Sarah Johnson', 'Data Scientist',  70000.00, 1),
(105, 'Emma Wilson', 'HR Specialist',  52000.00, 2);

/* Table Projet */
INSERT INTO projet VALUES
(201, 'Refonte du site web', '2024-01-15',  '2024-06-30', 1),
(202, 'Onboarding des employés', '2024-03-01',  '2024-09-01', 2),
(203, 'Market Research', '2024-02-01',  '2024-07-31', 3),
(204, 'IT Infrastructure Setup', '2024-04-01',  '2024-12-31', 1);

/* Table Employé_Projet */
INSERT INTO Employe_Projet VALUES
(101, 201,'Développeur Frontend'),
(104, 201,'Développeur Backend'),
(102, 202,'Formateur'),
(105, 202,'Coordinateur'),
(103, 203,'Responsable de la recherche'),
(101, 204,'Spécialiste réseau');

/* 2- Mise à jour enregistrement */
UPDATE Employe_Projet
SET Rôle = 'Full Stack Developer' WHERE Employes_Num_E = 101;

/* 3- Suppression enregistrement */
DELETE FROM Employe_Projet WHERE Employes_Num_E = 103;
DELETE FROM employes WHERE Num_E = 103;