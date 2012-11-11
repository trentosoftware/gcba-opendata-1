INSERT INTO autocomplete_search(results, text)
SELECT conteo, upper(unaccent_string(texto)) as text from
((
(select tipo2 as texto, count(tipo2) as conteo
from parcelas_data where smp in (select smp from parcelas_geometries)
and length(tipo2) > 2 group by tipo2)
UNION
(select nombre as texto, count(nombre) as conteo
from parcelas_data where smp in (select smp from parcelas_geometries)
and length(nombre) > 2 group by nombre))) as tabla;
