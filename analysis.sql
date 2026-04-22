USE leitstelle_ovharov_oleksandr;

-- ------------------------------------------------------------------------
-- ------------------------Beispielabfragen--------------------------------
-- ------------------------------------------------------------------------
-- Frage 1:
-- Wie viele Einsatze wurden pro Tag, Woche und Monat durchgeführt
-- (Analyse des Einsatzaufkommens im Zeitverlauf)
SELECT
  DATE(eingangszeit) AS datum,
  COUNT(*) AS anzahl_einsaetze
FROM einsatz
GROUP BY DATE(eingangszeit);

-- Frage 2:
-- Wie verteilen sich die Einsatze nach Einsatzart und Prioritat?
-- (Auswertung der Art und Dringlichkeit der Einsatze)
SELECT
	ea.bezeichnung AS einsatzart,
	p.stufe AS prioritaet,
	COUNT(e.einsatz_id) AS anzahl_einsaetze
FROM Einsatz e
JOIN Einsatzart ea USING (einsatzart_id)
JOIN Prioritat p USING (prioritat_id)
GROUP BY
	ea.bezeichnung,
	p.stufe
ORDER BY
	ea.bezeichnung,
	p.stufe;

-- Frage 3:
-- Bei wie vielen Einsatzen wurden mehr als ein Fahrzeug eingesetzt?
-- (Identifikation von komplexeren Einsatzlagen)
SELECT
	einsatz_id,
	COUNT(fahrzeug_id) AS mehr_1_Fahrzeug
FROM einsatz_fahrzeug
GROUP BY einsatz_id
HAVING COUNT(fahrzeug_id) > 1;

-- Frage 4:
-- Welche Wache ist am starksten ausgelastet basierend auf der Anzahl der Fahrzeugeinsatze?
-- (Auslastung der Rettungswachen über die eingesetzten Fahrzeuge)
SELECT
	w.wache_id, w.adresse, w.name,
    COUNT(ef.einsatz_id) AS anzahl_fahrzeugeinsaetze
FROM wache AS w 
	JOIN fahrzeug AS f USING(wache_id)
    JOIN einsatz_fahrzeug AS ef USING(fahrzeug_id)
GROUP BY w.wache_id, w.adresse, w.name
ORDER BY anzahl_fahrzeugeinsaetze DESC
LIMIT 1;

-- Frage 5:
-- Wie viele Einsatze wurden insgesamt von jeder Wache abgewickelt?
-- (Vergleich der Einsatzverteilung zwischen den Wachen)
SELECT
	w.wache_id, w.adresse, w.name,
    COUNT(DISTINCT ef.einsatz_id) AS anzahl_einsatze
FROM wache AS w 
	JOIN fahrzeug AS f USING(wache_id)
    JOIN einsatz_fahrzeug AS ef USING(fahrzeug_id)
GROUP BY w.wache_id, w.adresse, w.name;

-- Frage 6:
-- Welche Fahrzeuge wurden am haufigsten eingesetzt?
-- (Nutzung und Belastung einzelner Fahrzeuge)
SELECT
	fahrzeug_id, bezeichnung,
    COUNT(ef.einsatz_id) AS anzahl_einsaetze
FROM fahrzeug
	JOIN einsatz_fahrzeug AS ef USING(fahrzeug_id)
GROUP BY fahrzeug_id, bezeichnung
ORDER BY COUNT(ef.einsatz_id) DESC
LIMIT 1;

-- Frage 7:
-- In welche Krankenhauser werden Patienten am haufigsten transportiert?
-- (Analyse der Transportziele)
SELECT
	k.krankenhaus_id, k.name, k.adresse,
    COUNT(t.krankenhaus_id) AS anzahl_transporte
FROM krankenhaus AS k
	JOIN transport AS t USING(krankenhaus_id)
GROUP BY k.krankenhaus_id, k.name, k.adresse
ORDER BY anzahl_transporte DESC
LIMIT 1;

-- Frage 8:
-- Wie viele Einsatze enden ohne einen Transport in ein Krankenhaus?
-- (Ermittlung von Einsatzen ohne Hospitalisierung)
SELECT
	COUNT(DISTINCT einsatz_id) AS cnt_ohne_Transport
FROM einsatz_fahrzeug
	LEFT JOIN transport AS t USING(einsatz_id)
    WHERE t.einsatz_id IS NULL;
    
	
-- Frage 9:
-- Wie hoch ist die durchschnittliche Anfahrtszeit (von Alarmierung bis Ankunft) in Abhangigkeit von der Prioritat?
-- (Bewertung der Reaktionsgeschwindigkeit)
SELECT
	p.stufe,
    ROUND(
    AVG(TIMESTAMPDIFF(MINUTE, ef.alarmierungszeit, ef.ankunftszeit)), 
    2
    ) AS durchschnittliche_Anfahrtszeit
FROM prioritat AS p
	JOIN einsatz AS e USING(prioritat_id)
    JOIN einsatz_fahrzeug AS ef USING (einsatz_id)
GROUP BY p.stufe;

-- Frage 10:
-- Wie lang ist die durchschnittliche Einsatzdauer (von Alarmierung bis Rückmeldung) in Abhangigkeit von Wache UND Prioritat?
-- (Analyse der Einsatzdauer und Arbeitsbelastung)
SELECT
	w.name AS wache,
	p.stufe AS prioritaet,
	ROUND(
		AVG(TIMESTAMPDIFF(MINUTE, ef.alarmierungszeit, ef.rückmeldezeit)),
		2
	) AS durchschnittliche_einsatzdauer
FROM wache w
JOIN fahrzeug f USING (wache_id)
JOIN einsatz_fahrzeug ef USING (fahrzeug_id)
JOIN einsatz e USING (einsatz_id)
JOIN prioritat p USING (prioritat_id)
GROUP BY w.name, p.stufe
ORDER BY w.name, p.stufe;


-- Frage 11:
-- Wie viele Fahrzeuge waren gleichzeitig bei Einsatzen gebunden (z. B. pro Zeitraum oder Tag)?
-- (Abschatzung der gleichzeitigen Ressourcenauslastung)
SELECT
	DATE(alarmierungszeit) AS datum,
    COUNT(fahrzeug_id) AS Fahrzeuge
FROM einsatz_fahrzeug
GROUP BY DATE(alarmierungszeit)
ORDER BY datum DESC;

-- Frage 12:
-- Gibt es Einsatze, bei denen überdurchschnittlich viele Fahrzeuge oder überdurchschnittlich lange Einsatzzeiten auftraten?
SELECT *
FROM (
	SELECT
		einsatz_id,
		AVG(TIMESTAMPDIFF(MINUTE, alarmierungszeit, rückmeldezeit)) AS dauer,
		COUNT(fahrzeug_id) AS fahrzeuge_anzahl
	FROM einsatz_fahrzeug
	GROUP BY einsatz_id
	) t
WHERE 
	fahrzeuge_anzahl >
	(
		SELECT AVG(cnt_f)
		FROM (
			SELECT COUNT(fahrzeug_id) as cnt_f
			FROM einsatz_fahrzeug
			GROUP BY einsatz_id
			) q
		) OR
	dauer >
	(
		SELECT AVG(d)
		FROM (
			SELECT AVG(TIMESTAMPDIFF(MINUTE, alarmierungszeit, rückmeldezeit)) AS d
			FROM einsatz_fahrzeug
			GROUP BY einsatz_id
			) b
		);