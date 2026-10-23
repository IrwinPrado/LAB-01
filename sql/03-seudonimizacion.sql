-- ============================================================
-- LAB-01: Protección y Privacidad de Datos
-- Script: 03-seudonimizacion.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Creación de esquemas (pii, analitica), generación
--              de tokens con UUID, tabla de correspondencia y
--              control de acceso para el rol analista.
-- ============================================================

-- 9.1 Crear los esquemas para separar mapa de correspondencia y datos de analítica
CREATE SCHEMA pii;
CREATE SCHEMA analitica;

-- 9.2 Crear la tabla de correspondencia (mapa de seudonimización)
CREATE TABLE pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE REFERENCES public.clientes(id)
);

-- 9.3 Habilitar la extensión pgcrypto y generar tokens UUID únicos
CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO pii.mapa_cliente (token, cliente_id)
SELECT gen_random_uuid(), id FROM clientes;

-- Verificar los tokens generados
SELECT * FROM pii.mapa_cliente;

-- 10. Crear el conjunto de datos seudonimizado para el área de analítica
CREATE TABLE analitica.clientes AS 
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente m
JOIN clientes c ON c.id = m.cliente_id;

-- Verificar conjunto de datos analítico
SELECT * FROM analitica.clientes;

-- 11. Crear el rol analista y aplicar separación de funciones
CREATE ROLE analista NOLOGIN;

-- Conceder acceso exclusivo al esquema y tabla de analítica
GRANT USAGE ON SCHEMA analitica TO analista;
GRANT SELECT ON analitica.clientes TO analista;

-- 11.1 Verificación de permisos del rol analista
-- Consulta permitida:
SELECT * FROM analitica.clientes;

-- Consultas restringidas (deben denegarse para garantizar separación de funciones):
SELECT * FROM pii.mapa_cliente;
SELECT * FROM public.clientes;