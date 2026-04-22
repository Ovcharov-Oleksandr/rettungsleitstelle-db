-- ------------------------------------------------------------------------
-- ----------------------INSERT-------------------------------------------
-- ------------------------------------------------------------------------
INSERT INTO einsatzart (bezeichnung) VALUES
('Brand'),
('Verkehrsunfall'),
('Medizinischer Notfall');

INSERT INTO einsatz_status (bezeichnung) VALUES
('offen'),
('in Bearbeitung'),
('abgeschlossen');

INSERT INTO Prioritat (stufe) VALUES
('hoch'),
('mittel'),
('niedrig');

INSERT INTO Fahrzeug_status (bezeichnung) VALUES
('verfügbar'),
('im Einsatz'),
('außer Betrieb');

INSERT INTO Wache (name, adresse) VALUES
('Wache Bochum Mitte', 'Universitatsstraße 150, 44789 Bochum'),
('Wache Bochum Nord', 'Herner Straße 299, 44809 Bochum');

INSERT INTO Krankenhaus (name, adresse) VALUES
('St. Josef Hospital', 'Gudrunstraße 56, Bochum'),
('Knappschaftskrankenhaus', 'In der Schornau 23, Bochum'),
('Bergmannsheil', 'Bürkle-de-la-Camp-Platz 1, Bochum'),
('Augusta-Kranken-Anstalt', 'Bergstraße 26, Bochum'),
('St. Elisabeth Hospital', 'Bleichstraße 15, Bochum');

INSERT INTO Fahrzeug (bezeichnung, fahrzeugstatus_id, wache_id) VALUES
('RTW 1', 1, 1),
('RTW 2', 1, 1),
('RTW 3', 2, 1),
('KTW 1', 1, 1),
('KTW 2', 1, 2),
('KTW 3', 1, 2),
('NEF 1', 2, 2),
('NEF 2', 1, 2),
('LF 1', 1, 1),
('LF 2', 1, 2),
('DLK 1', 1, 1),
('GW 1', 1, 2),
('RTW 4', 1, 1),
('KTW 4', 1, 2),
('NEF 3', 1, 1);

INSERT INTO Einsatz
(einsatzart_id, einsatz_status_id, prioritat_id, adresse, beschreibung)
VALUES
(1, 3, 1, 'Hauptstraße 12, Bochum', 'Wohnungsbrand'),
(3, 2, 1, 'Bahnhofstraße 7, Bochum', 'Bewusstlose Person'),
(2, 3, 2, 'Herner Straße 88, Bochum', 'Verkehrsunfall'),
(3, 3, 2, 'Universitatsstraße 99, Bochum', 'Atemnot'),
(1, 3, 1, 'Castroper Straße 145, Bochum', 'Brandmeldeanlage'),
(3, 2, 2, 'Wittener Straße 200, Bochum', 'Sturz'),
(2, 3, 2, 'Dorstener Straße 54, Bochum', 'Auffahrunfall'),
(3, 3, 3, 'Kortumstraße 10, Bochum', 'Kreislaufprobleme'),
(1, 3, 1, 'Hattinger Straße 33, Bochum', 'Kellerbrand'),
(3, 3, 2, 'Alleestraße 5, Bochum', 'Schwindel'),
(2, 3, 2, 'Riemker Straße 21, Bochum', 'Fahrradunfall'),
(3, 3, 3, 'Ostring 66, Bochum', 'Unterzuckerung'),
(1, 3, 1, 'Harpener Hellweg 90, Bochum', 'Rauchentwicklung'),
(3, 2, 2, 'Springorumallee 8, Bochum', 'Brustschmerzen'),
(2, 3, 2, 'Westenfelder Straße 120, Bochum', 'PKW vs Fußganger');

UPDATE Einsatz
SET eingangszeit = '2025-01-28 08:30'
WHERE einsatz_id BETWEEN 1 AND 5;

UPDATE Einsatz
SET eingangszeit = '2025-01-29 10:15'
WHERE einsatz_id BETWEEN 6 AND 10;

UPDATE Einsatz
SET eingangszeit = '2025-02-01 14:00'
WHERE einsatz_id BETWEEN 11 AND 15;

INSERT INTO Transport
(einsatz_id, krankenhaus_id, transport_startzeit, transport_endzeit)
VALUES
(2,  1, '2025-01-28 09:40', '2025-01-28 10:05'),
(4,  3, '2025-01-28 11:40', '2025-01-28 12:00'),
(6,  2, '2025-01-29 13:40', '2025-01-29 14:05'),
(8,  4, '2025-01-29 15:40', '2025-01-29 16:05'),
(10, 5, '2025-01-29 17:40', '2025-01-29 18:00'),
(12, 1, '2025-02-01 19:40', '2025-02-01 20:05'),
(14, 2, '2025-02-01 21:40', '2025-02-01 22:05'),
(3,  3, '2025-01-28 10:40', '2025-01-28 11:00'),
(7,  4, '2025-01-29 14:40', '2025-01-29 15:05'),
(15, 5, '2025-02-01 22:40', '2025-02-01 23:00');


INSERT INTO Einsatz_Fahrzeug
(einsatz_id, fahrzeug_id, alarmierungszeit, ausrückzeit, ankunftszeit, rückmeldezeit)
VALUES
(1, 9,  '2025-01-28 08:00', '2025-01-28 08:05', '2025-01-28 08:15', '2025-01-28 09:10'),
(1, 11, '2025-01-28 08:00', '2025-01-28 08:06', '2025-01-28 08:18', '2025-01-28 09:15'),
(2, 1,  '2025-01-28 09:10', '2025-01-28 09:15', '2025-01-28 09:25', '2025-01-28 10:05'),
(2, 7,  '2025-01-28 09:10', '2025-01-28 09:17', '2025-01-28 09:30', '2025-01-28 10:10'),
(3, 2,  '2025-01-28 10:00', '2025-01-28 10:06', '2025-01-28 10:20', '2025-01-28 11:00'),
(4, 3,  '2025-01-28 11:00', '2025-01-28 11:05', '2025-01-28 11:18', '2025-01-28 12:00'),
(5, 9,  '2025-01-28 12:30', '2025-01-28 12:35', '2025-01-28 12:50', '2025-01-28 13:40'),
(6, 4,  '2025-01-29 13:10', '2025-01-29 13:15', '2025-01-29 13:28', '2025-01-29 14:05'),
(7, 5,  '2025-01-29 14:00', '2025-01-29 14:05', '2025-01-29 14:22', '2025-01-29 15:05'),
(8, 6,  '2025-01-29 15:00', '2025-01-29 15:06', '2025-01-29 15:20', '2025-01-29 16:05'),
(9, 10, '2025-01-29 16:00', '2025-01-29 16:05', '2025-01-29 16:25', '2025-01-29 17:10'),
(10, 12,'2025-01-29 17:00', '2025-01-29 17:06', '2025-01-29 17:30', '2025-01-29 18:20'),
(11, 13,'2025-02-01 18:00', '2025-02-01 18:05', '2025-02-01 18:19', '2025-02-01 19:00'),
(12, 14,'2025-02-01 19:00', '2025-02-01 19:06', '2025-02-01 19:25', '2025-02-01 20:05'),
(13, 15,'2025-02-01 20:00', '2025-02-01 20:05', '2025-02-01 20:18', '2025-02-01 21:00'),
(14, 1, '2025-02-01 21:00', '2025-02-01 21:06', '2025-02-01 21:22', '2025-02-01 22:10'),
(15, 2, '2025-02-01 22:00', '2025-02-01 22:05', '2025-02-01 22:20', '2025-02-01 23:00');