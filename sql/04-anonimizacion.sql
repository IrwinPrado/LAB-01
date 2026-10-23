-- ============================================================
-- LAB-01: Protección y Privacidad de Datos
-- Script: 04-anonimizacion.sql
-- Estudiante: Irwin Gabriel Martinez Prado
-- Descripción: Aplicación de técnicas de anonimización (generalización,
--              agregación, supresión de grupos pequeños y reducción de riesgo).
-- ============================================================

-- 12.1 Generalizar la edad mediante agrupamiento en rangos
SELECT 
    CASE 
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+' 
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes 
GROUP BY 1;

-- 12.2 Generalizar la región reduciendo el detalle del código postal
SELECT 
    LEFT(codigo_postal, 2) AS region, 
    COUNT(*) AS total
FROM clientes 
GROUP BY 1;

-- 12.3 Combinar atributos generalizados (edad y región)
SELECT 
    CASE 
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+' 
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes 
GROUP BY 1, 2;

-- 12.4 Suprimir grupos pequeños (ejercicio didáctico de k-anonimato con umbral >= 5)
SELECT 
    CASE 
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+' 
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes 
GROUP BY 1, 2 
HAVING COUNT(*) >= 5;

-- 13. Reto: Consulta modificada para reducir aún más el riesgo de reidentificación
-- Se amplían los rangos de edad y se omite el desglose regional especifico
SELECT 
    CASE 
        WHEN edad BETWEEN 18 AND 40 THEN '18-40'
        ELSE '41+' 
    END AS rango_edad_amplio,
    COUNT(*) AS total
FROM clientes 
GROUP BY 1;