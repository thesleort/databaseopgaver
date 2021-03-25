-- Opgave 1
SELECT kunde.navn FROM kunde 
JOIN bil ON kunde.kunde_id = bil.kunde_id 
JOIN reparation ON reparation.bil_id = bil.bil_id 
JOIN mekaniker ON mekaniker.mekaniker_id = reparation.mekaniker_id 
WHERE mekaniker.navn = "Palle";
+-------------------+
| navn              |
+-------------------+
| Henrik Hemmingsen |
| Asger Johansen    |
+-------------------+


-- Opgave 2
SELECT navn FROM reservedel 
LEFT OUTER JOIN resrep ON resrep.reservedel_id = reservedel.reservedel_id 
WHERE resrep.reservedel_id IS NULL;
+---------+
| navn    |
+---------+
| Bremser |
| Tandrem |
+---------+

-- Opgave 3
SELECT navn FROM kunde 
JOIN bil ON kunde.kunde_id = bil.kunde_id 
GROUP BY navn 
HAVING COUNT(*) > 1;
+----------------+
| navn           |
+----------------+
| Asger Johansen |
| Rasmus Iversen |
+----------------+


-- Opgave 4
SELECT registreringsnr,model FROM bil 
JOIN reparation ON reparation.bil_id = bil.bil_id 
WHERE YEAR(dato) = 2019;
+-----------------+-------------+
| registreringsnr | model       |
+-----------------+-------------+
| MA45647         | Renault 4CV |
| MH40136         | Opel Kadett |
| XP37918         | VW Up!      |
+-----------------+-------------+


-- Opgave 5
UPDATE reservedel 
SET pris = pris * 1.07;
+---------------+------------------+------+
| reservedel_id | navn             | pris |
+---------------+------------------+------+
|             1 | Udstoedningsroer | 1391 |
|             2 | Baathorn         |  642 |
|             3 | Daek             |  321 |
|             4 | Bremser          | 1017 |
|             5 | Tandrem          | 6420 |
|             6 | Olie             |  321 |
+---------------+------------------+------+


-- Opgave 6
SELECT model FROM bil 
GROUP BY model 
HAVING COUNT(*) > 1;
+-------------+
| model       |
+-------------+
| Opel Kadett |
+-------------+

-- Opgave 7
SELECT navn,COUNT(*) 
FROM reparation 
JOIN mekaniker ON reparation.mekaniker_id = mekaniker.mekaniker_id 
JOIN bil ON bil.bil_id = reparation.bil_id 
WHERE aargang < 2021 - 25 
GROUP BY navn 
ORDER BY navn DESC LIMIT 1;
+------+
| navn |
+------+
| Poul |
+------+

-- Opgave 8
-- Nogle reparationer koster ikke noget i form af nye dele.
-- Priserne er efter prisstigningen på 7%
SELECT model,AVG(pris) FROM (
  SELECT model,IFNULL(pris,0) as pris,resrep_id FROM bil 
  LEFT OUTER JOIN reparation ON bil.bil_id = reparation.bil_id 
  LEFT OUTER JOIN resrep ON resrep.reparation_id = reparation.reparation_id 
  LEFT OUTER JOIN reservedel ON reservedel.reservedel_id = resrep.reservedel_id 
  GROUP BY model,pris,resrep_id) 
sub GROUP BY 1;
+------------------+-----------+
| model            | AVG(pris) |
+------------------+-----------+
| Renault Clio     |    0.0000 |
| Opel Kadett      |  695.5000 |
| Renault 4CV      |  535.0000 |
| VW Up!           |  321.0000 |
| Aston Martin DBS |  321.0000 |
+------------------+-----------+

-- Opgave 9
SELECT mekaniker.navn,SUM(pris) as indtjening FROM mekaniker 
JOIN reparation ON mekaniker.mekaniker_id = reparation.mekaniker_id 
JOIN resrep ON resrep.reparation_id = reparation.reparation_id 
JOIN reservedel ON reservedel.reservedel_id = resrep.reservedel_id 
GROUP BY navn 
ORDER BY indtjening DESC LIMIT 1;
+-------+------------+
| navn  | indtjening |
+-------+------------+
| Per   |       1391 |
| Poul  |       1284 |
| Palle |        963 |
+-------+------------+

-- Opgave 10
SELECT mekaniker.navn,SUM(PRIS) as "Samlet indtjent",COUNT(dato) as "Antal arbejde" FROM mekaniker 
JOIN reparation ON mekaniker.mekaniker_id = reparation.mekaniker_id 
JOIN resrep ON resrep.reparation_id = reparation.reparation_id 
JOIN reservedel ON resrep.reservedel_id = reservedel.reservedel_id 
WHERE (QUARTER(dato) = 1 OR QUARTER(dato) = 4) AND mekaniker.navn != "Poul"
GROUP BY navn;
+-------+-----------------+---------------+
| navn  | Samlet indtjent | Antal arbejde |
+-------+-----------------+---------------+
| Palle |             963 |             2 |
| Per   |            1391 |             1 |
+-------+-----------------+---------------+


