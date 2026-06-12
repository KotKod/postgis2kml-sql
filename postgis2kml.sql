WITH params AS (
    SELECT
        'sample name'::text        AS doc_name,
        'sample description'::text AS doc_description
),
src AS (
    SELECT
        row_number() OVER (ORDER BY id) AS rn,  -- replace id with stable sorting column
        CASE
            WHEN ST_SRID(column_name_with_geometry) = 4326
                THEN column_name_with_geometry
            ELSE
                ST_Transform(column_name_with_geometry, 4326)
        END AS geom
    FROM table_name_with_geometry
    WHERE column_name_with_geometry IS NOT NULL
),
parts AS (
    SELECT
        0 AS part,
        0::bigint AS rn,
        '<?xml version="1.0" encoding="UTF-8"?>' || E'\n' ||
        '<kml xmlns="http://www.opengis.net/kml/2.2">' || E'\n' ||
        '<Document>' || E'\n' ||
        xmlelement(name "name", p.doc_name)::text || E'\n' ||
        xmlelement(name "description", p.doc_description)::text || E'\n\n' ||
        '<Style id="defaultStyle">' || E'\n' ||
        '  <LineStyle>' || E'\n' ||
        '    <color>ff00ff00</color>' || E'\n' ||
        '    <width>1</width>' || E'\n' ||
        '  </LineStyle>' || E'\n' ||
        '  <PolyStyle>' || E'\n' ||
        '    <color>5f00ff00</color>' || E'\n' ||
        '  </PolyStyle>' || E'\n' ||
        '</Style>' || E'\n\n' AS xml
    FROM params p

    UNION ALL

    SELECT
        1 AS part,
        s.rn,
        '<Placemark>' || E'\n' ||
        '  <styleUrl>#defaultStyle</styleUrl>' || E'\n' ||
        ST_AsKML(s.geom, 6) || E'\n' ||
        '</Placemark>' || E'\n\n' AS xml
    FROM src s

    UNION ALL

    SELECT
        2 AS part,
        0::bigint AS rn,
        '</Document>' || E'\n' ||
        '</kml>' || E'\n' AS xml
)
SELECT xml
FROM parts
ORDER BY part, rn;
