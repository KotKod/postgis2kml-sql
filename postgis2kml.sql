SELECT '<?xml version="1.0" encoding="UTF-8"?>' || E'\n' ||
              '<kml xmlns="http://www.opengis.net/kml/2.2">' || E'\n' ||
              '<Document>' || E'\n' ||
              '<name>' ||'sample name' || '</name>' || E'\n' ||
              '<description>' || 'sample description' || '</description>' || E'\n\n' ||
              '<Style id="defaultStyle">' || E'\n' ||
              '  <LineStyle>' || E'\n' ||
              '    <color>ff00ff00</color>' || E'\n' ||
              '    <width>1</width>' || E'\n' ||
              '  </LineStyle>' || E'\n' ||
              '  <PolyStyle>' || E'\n' ||
              '    <color>5f00ff00</color>' || E'\n' ||
              '  </PolyStyle>' || E'\n' ||
              '</Style>' || E'\n\n' AS xml
UNION ALL
SELECT '<Placemark>' || E'\n' || 
              '<styleUrl>#defaultStyle</styleUrl>' || E'\n' || 
              ST_AsKML(column_name_with_geometry) || E'\n\n' ||
              '</Placemark>' || E'\n\n' AS xml 
              FROM table_name_with_geometry
UNION ALL                  
SELECT        '</Document>' || E'\n' || 
              '</kml>' AS xml
