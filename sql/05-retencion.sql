-- ============================================================
-- LAB-01: Protección y Privacidad de Datos
-- Script: 05-retencion.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Identificación de registros que exceden el periodo de
--              retención establecido (5 años) para cumplimiento de políticas.
-- ============================================================

-- 14. Identificación de registros sujetos a depuración (antigüedad > 5 años)
-- Nota: La consulta únicamente identifica registros, no ejecuta DELETE sobre la tabla.
SELECT * 
FROM clientes 
WHERE fecha_alta < CURRENT_DATE - INTERVAL '5 years';