--PROCEDURE NECESARIO PARA LAS BUSQUEDAS
CREATE OR REPLACE FUNCTION unaccent_string(text)
RETURNS text
IMMUTABLE
STRICT
LANGUAGE SQL
AS $$
SELECT translate(
    $1,
    'áâãäåāăąÁÂÃÄÅĀĂĄèééêëēĕėęěÉĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮñÑ',
    'aaaaaaaaaaaaaaaaeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuunn'
);
$$;