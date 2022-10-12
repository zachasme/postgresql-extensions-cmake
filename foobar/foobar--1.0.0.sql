CREATE FUNCTION foobar(integer)
    RETURNS integer
    AS 'foobar'
    LANGUAGE C IMMUTABLE STRICT;
