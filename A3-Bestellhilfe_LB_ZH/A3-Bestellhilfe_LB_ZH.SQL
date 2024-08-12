SELECT
   a.r1_artikelnummer as Artikelnummer,
   REPLACE (
      REPLACE (a.r1_bezeichnung, CHAR(13), CHAR(32)),
      CHAR(10),
      ''
   ) as Bezeichnung,
   IsNull (
      (
         SELECT
            Sum(lb1_bestand)
         FROM
            lager_bestand
         WHERE
            lb1_lager_platz_id = 2
            AND lb1_lager_status = 'l'
            AND lb1_artikel_id = a.r1_artikel_id
      ),
      0.00
   ) as Lager_ZH,
   IsNull (
      (
         SELECT
            Sum(lb1_bestand)
         FROM
            lager_bestand
         WHERE
            lb1_lager_platz_id = 2
            AND lb1_lager_status = 'd'
            AND lb1_artikel_id = a.r1_artikel_id
      ),
      0.00
   ) as Disponiert_ZH,
   IsNull (
      (
         SELECT
            Sum(b.p1_menge)
         FROM
            art_proto b
         WHERE
            (
               b.p2_lagerort = 2
               AND b.p1_lieferdatum >= DATEADD (mm, -03, getdate ())
            )
            AND b.p1_text = 'Ausgang automatisch'
            AND b.p1_artikelnummer = a.r1_artikelnummer
            AND b.p1_adress_id Not In (7782, 1969)
      ),
      0.00
   ) as DreiMonate,
   IsNull (
      (
         SELECT
            Sum(b.p1_menge)
         FROM
            art_proto b
         WHERE
            (
               b.p2_lagerort = 2
               AND b.p1_lieferdatum >= DATEADD (mm, -12, getdate ())
            )
            AND b.p1_text = 'Ausgang automatisch'
            AND b.p1_artikelnummer = a.r1_artikelnummer
            AND b.p1_adress_id Not In (7782, 1969)
      ),
      0.00
   ) as ZwoelfMonate,
   IsNull (
      (
         SELECT
            ape1_preis
         FROM
            artikel_preis_einstand
         WHERE
            ape1_aktuell = 'j'
            AND ape1_artikel_id = a.r1_artikel_id
      ),
      0.00
   ) as Einkaufspreis
FROM
   artikel a,
WHERE
   a.r1_gruppe In (99, 80)
   AND 16841 = IsNull (
      (
         SELECT
            a1_adressnummer
         FROM
            adresse ad,
            artikel_lieferant al
         where
            a.r1_artikel_id = al.al2_artikel_id
            AND al.al2_adress_id = ad.a1_adress_id
      ),
      0.00
   )
   AND a.r1_gesperrt = 'n'
GROUP BY
   a.r1_artikelnummer,
   a.r1_bezeichnung,
   a.r2_disponiert,
   a.r1_gruppe,
   a.r2_einstand,
   a.r1_artikel_id,
   a.r1_gesperrt,
   a.r2_adressnummer_1
ORDER BY
   a.r1_gruppe,
   a.r1_artikelnummer
   ----------------------------------------------------------------------------
SELECT
   Artikel.r1_artikelnummer,
   Artikel.r1_bezeichnung,
   art_proto.p1_menge,
   art_proto.p2_lagerort,
   art_proto.p1_lieferdatum,
   art_proto.p1_text,
   art_proto.p1_adress_id
FROM
   org.art_proto art_proto,
   org.Artikel Artikel
WHERE
   art_proto.p1_artikelnummer = Artikel.r1_artikelnummer
   AND (
      (Artikel.r1_gruppe = 80)
      AND (Artikel.r1_artikelnummer Like 'CO%')
      AND (Artikel.r1_gesperrt = 'n')
   )