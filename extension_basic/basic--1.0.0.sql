-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION basic" to load this file. \quit

CREATE FUNCTION basic(integer)
    RETURNS integer
    AS 'basic'
    LANGUAGE C IMMUTABLE STRICT;
