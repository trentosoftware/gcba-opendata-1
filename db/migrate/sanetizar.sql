
--BORRO TUPLAS CON SECCIONES MAL FORMADAS (parcelas_data, 5 tuplas)
delete from parcelas_data where char_length(seccion) != 2;

--BORRO TUPLAS CON PROBLEMAS DE ENCODING (parcelas_geometry, 56 tuplas)
delete from parcelas_geometries where char_length(substring(parcela from '[^\w]+')) > 0 or char_length(substring(manzana from '[^\w]+')) > 0;

--BORRO TUPLAS DONDE NO COINCIDE SMP con SECCIONES, PARCELA, MANZANA (parcelas_data, 29 tuplas)
delete from parcelas_data where substring(smp from '[^-]+$') != parcela and manzana != substring(substring(smp from '-[^-]+-') from '[^-]+') and seccion != substring(smp from '^[^-]+');

--BORRO LAS TUPLAS DONDE NO SE RESPETA EL LARGO DE SECCION (1 tupla)
DELETE from parcelas_geometries where char_length(seccion) != 3;

--BORRO LAS TUPLAS DONDE NO SE RESPETA EL CONTENIDO DE MANZANA
delete from parcelas_data where char_length(manzana) > 4 or char_length(manzana) < 3; 

--BORRO LAS TUPLAS DONDE PARCELAS TIENEN MAS DE UNA PARCELA
DELETE from parcelas_data where char_length(substring(parcela from '\+')) > 0;

--BORRO LAS TUPLAS QUE TIENEN SMP REPETIDO (437 tuplas)
delete from parcelas_geometries where smp in (select smp from parcelas_geometries group by smp having count(smp) > 1);

--LLEVO A PARCELAS_DATA AL MISMO CASE QUE PARCELAS_GEOMETRY
update parcelas_data set smp = lower(smp), parcela = lower(parcela), manzana=lower(manzana);

--SE ACTUALIZAN SECCIONES DE PARCELAS_DATA
--update parcelas_data set seccion = concat('0',seccion), smp = concat('0', smp);








