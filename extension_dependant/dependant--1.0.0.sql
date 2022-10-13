-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION dependant" to load this file. \quit

CREATE FUNCTION dependant(integer)
    RETURNS integer
    AS 'dependant'
    LANGUAGE C IMMUTABLE STRICT;
