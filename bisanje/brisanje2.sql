## Zadaca:
#### Napraviti Upite na bazi podataka "knjiznica"
1. Navedite sve članove koji su posudili knjige, zajedno s naslovima knjiga koje su posudili.
2. Pronađite članove koji imaju zakašnjele knjige.
3. Pronađite sve žanrove i broj dostupnih knjiga u svakom žanru.
- kreirajte novo korisnika u MySQL-u i dajte mu povlastice samo za bazu videoteka

```sql
DROP DATABASE IF EXISTS knjiznica;
CREATE DATABASE IF NOT EXISTS knjiznica DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE knjiznica;

CREATE TABLE IF NOT EXISTS clanovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ime VARCHAR(100) NOT NULL,
    prezime VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    datum_rodjenja DATE,
    datum_clanstva DATE NOT NULL DEFAULT (CURDATE())
);

CREATE TABLE IF NOT EXISTS zanrovi (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naziv VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS knjige (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    naslov VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    zanr_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (zanr_id) REFERENCES zanrovi(id)
);

CREATE TABLE IF NOT EXISTS kopija (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    knjiga_id INT UNSIGNED NOT NULL,
    barkod VARCHAR(50) NOT NULL,
    dostupna BOOLEAN DEFAULT TRUE,
    UNIQUE (knjiga_id, barkod),
    FOREIGN KEY (knjiga_id) REFERENCES knjige(id)
);

CREATE TABLE IF NOT EXISTS posudbe (
    id INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    clan_id INT UNSIGNED NOT NULL,
    kopija_id INT UNSIGNED NOT NULL,
    datum_posudbe DATE NOT NULL DEFAULT (CURDATE()),
    datum_povrata DATE,
    zakasnina DECIMAL(5, 2),
    FOREIGN KEY (clan_id) REFERENCES clanovi(id),
    FOREIGN KEY (kopija_id) REFERENCES kopija(id)
);

INSERT INTO clanovi (ime, prezime, email, datum_rodjenja, datum_clanstva) VALUES
('Ivan', 'Horvat', 'ivan.horvat@example.com', '1980-01-15', '2023-01-01'),
('Ana', 'Marić', 'ana.maric@example.com', '1990-05-10', '2023-02-15'),
('Petar', 'Novak', 'petar.novak@example.com', '1975-08-20', '2023-03-01'),
('Maja', 'Kovač', 'maja.kovac@example.com', '1985-12-25', '2023-04-10');

INSERT INTO zanrovi (naziv) VALUES
('Znanstvena fantastika'),
('Ljubavni roman'),
('Kriminalistički roman'),
('Biografija');

INSERT INTO knjige (naslov, autor, isbn, zanr_id) VALUES
('Dina', 'Frank Herbert', '978-3-16-148410-0', 1),
('Ponos i predrasude', 'Jane Austen', '978-0-14-143951-8', 2),
('Umorstva u Ulici Morgue', 'Edgar Allan Poe', '978-1-85326-015-5', 3),
('Steve Jobs', 'Walter Isaacson', '978-1-4516-4853-9', 4);

INSERT INTO kopija (knjiga_id, barkod, dostupna) VALUES
(1, '1234567890123', TRUE),
(1, '1234567890124', TRUE),
(2, '1234567890125', TRUE),
(2, '1234567890126', FALSE),
(3, '1234567890127', TRUE),
(4, '1234567890128', TRUE);

INSERT INTO posudbe (clan_id, kopija_id, datum_posudbe, datum_povrata, zakasnina) VALUES
(1, 1, '2023-06-01', '2023-06-15', NULL),
(2, 3, '2023-06-05', '2023-06-20', NULL),
(3, 4, '2023-06-10', '2023-06-25', 10.00),  -- Zakasnina zbog kašnjenja
(4, 6, '2023-06-15', NULL, NULL);

INSERT INTO posudbe (clan_id, kopija_id, datum_posudbe) VALUES (1, 3, '2023-06-05');
```

``
- Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
- Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (barcode) kako bi se mogla pratiti
- Clan od jednom moze posuditi vise od jednog filma


```

brisanja.sql

- Brisanja iz baze Knjiznica

-- brisanje pojedinog zapisa (redka) u tablici 
DELETE FROM clanovi WHERE clanovi.id = 4;

-- brisanje atributa (column) iz posojece tablice
ALTER TABLE clanovi DROP COLUMN datum_rodjenja;

-- brisanje indeksa u tablici
ALTER TABLE clanovi DROP INDEX email;

-- brisanje cijele tablice 
DROP TABLE clanovi;

-- brisanje cijele baze
DROP DATABASE knjiznica;

-- isprazniti tablicu posudbe
TRUNCATE posudbe;

-- obrisati strani kljuc
ALTER TABLE knjige DROP FOREIGN KEY knjige_ibfk_1;

-- kreiranje starnog kljuca sa uvjetom ON DELETE CASCADE
ALTER TABLE knjige ADD FOREIGN KEY (zanr_id) REFERENCES zanrovi(id) ON DELETE CASCADE;

-- promjena vrijednosti u postojecim zapisima
UPDATE clanovi SET prezime = 'Dobrinic', ime = 'Aleks' WHERE id = 8;
UPDATE clanovi SET datum_clanstva = CURDATE() WHERE id = 8;
  5 changes: 5 additions & 0 deletions5  
videoteka/videoteka_select.sql
Original file line number	Diff line number	Diff line change
@@ -129,3 +129,8 @@ SELECT c.*, datediff(p.datum_povrata, p.datum_posudbe)-1 AS 'Zakasnina'
    from posudba p 
    JOIN clanovi c ON c.id = p.clan_id
WHERE datediff(p.datum_povrata, p.datum_posudbe) > 1 OR (p.datum_povrata IS NULL AND datediff(CURRENT_DATE, p.datum_posudbe) > 1);

-- dohvati sve iz filmova, preskoci prva dva zapisa, dohvati sveukupno 3 zapisa
SELECT * from filmovi LIMIT 2 OFFSET 2;

-- dohvati prosjecnu cijenu filmova s obzirom na ukupnu zalihu filmova 
  4 changes: 3 additions & 1 deletion4  
zadaca_videoteka.md
Original file line number	Diff line number	Diff line change
@@ -7,6 +7,8 @@
- Film se posđuje na rok od jednog dana I ako ga član ne vrati u navedeno vrijeme, zaračunava mu se zakasnina.

### Dopuna zadace
- kreirajte novo korisnika u MySQL-u i dajte mu povlastice samo za bazu videoteka

- Svaki film ima zalihu dostupnih kopija po mediju za koji je dostupan
- Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (barcode) kako bi se mogla pratiti
- Svaka fizicka kopija filma ima svoj jedinstveni identifikacijski broj (s/n) kako bi se mogla pratiti
- Clan od jednom moze posuditi vise od jednog filma