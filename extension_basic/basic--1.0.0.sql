-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION basic" to load this file. \quit

CREATE FUNCTION foobar(integer)
    RETURNS integer
    AS 'foobar'
    LANGUAGE C IMMUTABLE STRICT;
