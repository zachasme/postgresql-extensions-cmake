CREATE FUNCTION dependant(integer)
  RETURNS integer
  AS 'dependant'
  LANGUAGE C IMMUTABLE STRICT;
