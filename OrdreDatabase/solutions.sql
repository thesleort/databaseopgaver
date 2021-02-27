SELECT SUM(antal)
FROM vare
JOIN ordrelinje ON vare.vare_id = ordrelinje.vare_id
WHERE betegnelse="Gipsplade";

# Total omsætning af produkt
SELECT SUM(antal) * vare.pris
FROM vare JOIN ordrelinje
ON vare.vare_id = ordrelinje.vare_id
WHERE betegnelse="Gipsplade"
GROUP BY pris;

# Total omsætning
SELECT SUM(antal * vare.pris)
FROM vare
JOIN ordrelinje ON vare.vare_id = ordrelinje.vare_id;

# Find alle kunder fra Snekkersten
SELECT COUNT(ordre_id)
FROM ordre
JOIN kunde      ON ordre.kunde_id   = kunde.kunde_id
JOIN postnummer ON kunde.postnr     = postnummer.postnummer_id
WHERE postnummer.bynavn = "Snekkersten";

# Alle kunder med mindst en boltsaks
SELECT navn
FROM kunde
JOIN ordre      ON kunde.kunde_id       = ordre.kunde_id
JOIN ordrelinje ON ordre.ordre_id       = ordrelinje.ordre_id
JOIN vare       ON ordrelinje.vare_id   = vare.vare_id
WHERE EXISTS (
    SELECT NULL
    FROM vare ordrelinje
    WHERE vare.betegnelse = "boltsaks"
);

# Hvilken by har ingen kunder
SELECT bynavn
FROM postnummer
WHERE bynavn NOT IN (
    SELECT bynavn
    FROM postnummer
    JOIN kunde ON kunde.postnr = postnummer.postnummer_id
);

# Hvilken by har har ingen ordre
SELECT bynavn
FROM postnummer
WHERE bynavn NOT IN (
    SELECT bynavn
    FROM postnummer
    JOIN kunde ON kunde.postnr = postnummer.postnummer_id
    JOIN ordre ON ordre.kunde_id = kunde.kunde_id
);


