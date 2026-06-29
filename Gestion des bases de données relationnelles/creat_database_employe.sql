CREATE DATABASE salaries;
USE salaries;

CREATE TABLE Departement (
	Num_S INT PRIMARY KEY,
	Libelle VARCHAR(225),
	Nom_du_manager VARCHAR(225));

CREATE TABLE employes (
	Num_E INT PRIMARY KEY,
	Nom VARCHAR(225),
	Position VARCHAR(225),
	Salaire DECIMAL(10, 2),
	Departement_Num_S INT FOREIGN KEY  REFERENCES Departement (Num_S));

CREATE TABLE projet (
	Num_P INT PRIMARY KEY,
	Titre VARCHAR(225),
	Date_de_debut DATE,
	Date_fin DATE,
	Departement_Num_S INT FOREIGN KEY  REFERENCES Departement (Num_S));

CREATE TABLE Employe_Projet (
	Employes_Num_E INT FOREIGN KEY  REFERENCES employes (Num_E),
	Departement_Num_S INT FOREIGN KEY  REFERENCES Departement (Num_S),
	Participation INT PRIMARY KEY (Employes_Num_E, Departement_Num_S),
	Rôle VARCHAR(225) );


