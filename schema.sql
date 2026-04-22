DROP DATABASE IF EXISTS leitstelle_ovcharov_oleksandr;
CREATE DATABASE leitstelle_ovcharov_oleksandr;
USE leitstelle_ovcharov_oleksandr;

-- ------------------------------------------------------------------------
-- ----------------------CREATE--------------------------------------------
-- ------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Einsatz_Fahrzeug` (
	`einsatz_id` INTEGER NOT NULL,
	`fahrzeug_id` INTEGER NOT NULL,
	`alarmierungszeit` DATETIME NOT NULL,
	`ausrückzeit` DATETIME NOT NULL,
	`ankunftszeit` DATETIME NOT NULL,
	`rückmeldezeit` DATETIME NOT NULL,
	PRIMARY KEY(`einsatz_id`, `fahrzeug_id`)
);


CREATE TABLE IF NOT EXISTS `Fahrzeug` (
	`fahrzeug_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`bezeichnung` VARCHAR(255) NOT NULL UNIQUE,
	`fahrzeugstatus_id` INTEGER NOT NULL,
	`wache_id` INTEGER NOT NULL,
	PRIMARY KEY(`fahrzeug_id`)
);


CREATE TABLE IF NOT EXISTS `Einsatz` (
	`einsatz_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`einsatzart_id` INTEGER NOT NULL,
	`einsatz_status_id` INTEGER NOT NULL,
	`prioritat_id` INTEGER NOT NULL,
	`eingangszeit` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`adresse` VARCHAR(255) NOT NULL,
	`beschreibung` TEXT(65535) NOT NULL,
	PRIMARY KEY(`einsatz_id`)
);


CREATE TABLE IF NOT EXISTS `Einsatzart` (
	`einsatzart_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`bezeichnung` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY(`einsatzart_id`)
);


CREATE TABLE IF NOT EXISTS `Einsatz_status` (
	`einsatz_status_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`bezeichnung` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY(`einsatz_status_id`)
);


CREATE TABLE IF NOT EXISTS `prioritat` (
	`prioritat_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`stufe` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY(`prioritat_id`)
);


CREATE TABLE IF NOT EXISTS `Krankenhaus` (
	`krankenhaus_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`name` VARCHAR(255) NOT NULL UNIQUE,
	`adresse` VARCHAR(255) NOT NULL,
	PRIMARY KEY(`krankenhaus_id`)
);


CREATE TABLE IF NOT EXISTS `Transport` (
	`transport_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`einsatz_id` INTEGER NOT NULL,
	`krankenhaus_id` INTEGER NOT NULL,
	`transport_startzeit` DATETIME NOT NULL,
	`transport_endzeit` DATETIME NOT NULL,
	PRIMARY KEY(`transport_id`)
);


CREATE TABLE IF NOT EXISTS `Fahrzeug_status` (
	`fahrzeugstatus_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`bezeichnung` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY(`fahrzeugstatus_id`)
);


CREATE TABLE IF NOT EXISTS `Wache` (
	`wache_id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`adresse` VARCHAR(255) NOT NULL UNIQUE,
	`name` VARCHAR(255) NOT NULL UNIQUE,
	PRIMARY KEY(`wache_id`)
);

-- ------------------------------------------------------------------------
-- ---------------------Fremdschlüssel-------------------------------------
-- ------------------------------------------------------------------------

-- Die Fremdschlüssel wurden nach der Befüllung der Tabellen hinzugefügt, um Fehler durch fehlende Datensatze zu vermeiden.
-- FOREIGN KEY für Einsatz
ALTER TABLE einsatz
ADD CONSTRAINT fk_einsatz_einsatzart
FOREIGN KEY (einsatzart_id)
REFERENCES einsatzart(einsatzart_id);

ALTER TABLE einsatz
ADD CONSTRAINT fk_einsatz_prioritat
FOREIGN KEY (prioritat_id)
REFERENCES prioritat(prioritat_id);

ALTER TABLE einsatz
ADD CONSTRAINT fk_einsatz_einsatz_status
FOREIGN KEY (einsatz_status_id)
REFERENCES einsatz_status(einsatz_status_id);



-- FOREIGN KEY für Fahrzeug
ALTER TABLE fahrzeug
ADD CONSTRAINT fk_fahrzeug_fahrzeug_status
FOREIGN KEY (fahrzeugstatus_id)
REFERENCES fahrzeug_status(fahrzeugstatus_id);

ALTER TABLE fahrzeug
ADD CONSTRAINT fk_fahrzeug_wache
FOREIGN KEY (wache_id)
REFERENCES wache(wache_id);


-- FOREIGN KEY für Transport
ALTER TABLE transport
ADD CONSTRAINT fk_transport_einsatz
FOREIGN KEY (einsatz_id)
REFERENCES einsatz(einsatz_id);

ALTER TABLE transport
ADD CONSTRAINT fk_transport_krankenhaus
FOREIGN KEY (krankenhaus_id)
REFERENCES krankenhaus(krankenhaus_id);


-- FOREIGN KEY für Transport
ALTER TABLE einsatz_fahrzeug
ADD CONSTRAINT fk_einsatz_fahrzeug_einsatz
FOREIGN KEY (einsatz_id)
REFERENCES einsatz(einsatz_id);

ALTER TABLE einsatz_fahrzeug
ADD CONSTRAINT fk_einsatz_fahrzeug_fahrzeug
FOREIGN KEY (fahrzeug_id)
REFERENCES fahrzeug(fahrzeug_id);

-- ------------------------------------------------------------------------
-- ---------------------------Benutzerrollen-------------------------------
-- ------------------------------------------------------------------------
  
-- Rollen
CREATE ROLE admin;
CREATE ROLE disponent;
CREATE ROLE auswerter;
CREATE ROLE gast;

-- Rechte: Admin
GRANT ALL PRIVILEGES ON leitstelle_ovcharov_oleksandr.* TO admin;

-- Rechte: Disponent
GRANT SELECT, INSERT, UPDATE ON leitstelle_ovcharov_oleksandr.einsatz TO disponent;
GRANT SELECT, INSERT, UPDATE ON leitstelle_ovcharov_oleksandr.einsatz_fahrzeug TO disponent;
GRANT SELECT ON leitstelle_ovcharov_oleksandr.fahrzeug TO disponent;

-- Rechte: Auswerter
GRANT SELECT ON leitstelle_ovcharov_oleksandr.einsatz TO auswerter;
GRANT SELECT ON leitstelle_ovcharov_oleksandr.einsatz_fahrzeug TO auswerter;
GRANT SELECT ON leitstelle_ovcharov_oleksandr.fahrzeug TO auswerter;

-- Rechte: Gast
GRANT SELECT ON leitstelle_ovcharov_oleksandr.* TO gast;


-- CREATE USERS
DROP USER IF EXISTS 'user1'@'%';
CREATE USER 'user1'@'%' IDENTIFIED BY 'pass123';
GRANT gast TO 'user1'@'%';
SET DEFAULT ROLE gast FOR 'user1'@'%';

DROP USER IF EXISTS 'user2'@'localhost';
CREATE USER 'user2'@'localhost' IDENTIFIED BY 'localhost1234';
GRANT disponent TO 'user2'@'localhost';
SET DEFAULT ROLE disponent FOR 'user2'@'localhost';

DROP USER IF EXISTS 'user2'@'192.168.1.24';
CREATE USER 'user2'@'192.168.1.24' IDENTIFIED BY 'pass12345';
GRANT disponent TO 'user2'@'192.168.1.24';
SET DEFAULT ROLE disponent FOR 'user2'@'192.168.1.24';

DROP USER IF EXISTS 'user3'@'192.168.1.25';
CREATE USER 'user3'@'192.168.1.25' IDENTIFIED BY 'pass1234';
GRANT auswerter TO 'user3'@'192.168.1.25';
SET DEFAULT ROLE auswerter FOR 'user3'@'192.168.1.25';