/*CREADO POR: Grupo 2
FECHA: 20/03/2025
PROYECTO FINAL: Avance 02 con el Esquema ABBOTT*/ 

-- Creacion del usuario desarrollador de la BD para el esquema
SELECT name, value 
FROM v$parameter 
WHERE name = 'common_user_prefix';

-- CREATE USER C##ABBOTT IDENTIFIED BY 1234;
CREATE USER ABBOTT IDENTIFIED BY 123;

ALTER SYSTEM SET common_user_prefix = '' scope = spfile;

-- Asignacion de privilegios
GRANT CREATE SESSION TO ABBOTT;

GRANT DBA TO ABBOTT;
GRANT RESOURCE TO ABBOTT;

GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO ABBOTT;