-- ============================================================
-- LAB-01: Protección y Privacidad de Datos
-- Script: 02-enmascaramiento.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Creación del rol soporte, vista enmascarada v_clientes_soporte
--              y asignación de permisos según principio de mínimo privilegio.
-- ============================================================

-- 8.1 Crear el rol de soporte
CREATE ROLE soporte NOLOGIN;

-- 8.2 Crear la vista de acceso restringido con datos parcialmente ocultos
CREATE VIEW v_clientes_soporte AS 
SELECT
    id,
    nombre,
    CONCAT(LEFT(correo, 2), '*****', SUBSTRING(correo FROM POSITION('@' IN correo))) AS correo,
    CONCAT('******', RIGHT(telefono, 4)) AS telefono,
    CONCAT('*********', RIGHT(rfc, 4)) AS rfc
FROM clientes;

-- Consultar la vista con usuario administrador para verificar el enmascaramiento
SELECT * FROM v_clientes_soporte;

-- 8.3 Conceder acceso a la vista al rol soporte
GRANT USAGE ON SCHEMA public TO soporte;
GRANT SELECT ON v_clientes_soporte TO soporte;

-- Revocar el acceso directo a la tabla principal para el rol soporte
REVOKE ALL ON clientes FROM soporte;

-- 8.4 Pruebas de verificación de permisos
-- Consulta permitida a la vista:
SELECT * FROM v_clientes_soporte;

-- Consulta denegada a la tabla principal (demuestra restricción de acceso):
SELECT * FROM clientes;