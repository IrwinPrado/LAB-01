# LAB-01: Protección y Privacidad de Datos

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** II — Seguridad, privacidad y control de acceso  
**Motor:** PostgreSQL 16  

## Estructura del Repositorio

```text
LAB-01/
├── README.md
├── informe.md
├── sql/
│   ├── 01-clasificacion.sql
│   ├── 02-enmascaramiento.sql
│   ├── 03-seudonimizacion.sql
│   ├── 04-anonimizacion.sql
│   └── 05-retencion.sql
└── evidencias/
    ├── 01-clasificacion.pdf
    ├── 02-enmascaramiento.pdf
    ├── 03-seudonimizacion.pdf
    ├── 04-anonimizacion.pdf
    └── 05-retencion.pdf
```

## Descripción de Scripts SQL

1. `01-clasificacion.sql`: Estructura inicial de la tabla `clientes` e inserción de datos de prueba.
2. `02-enmascaramiento.sql`: Creación del rol `soporte` y la vista `v_clientes_soporte` con enmascaramiento de datos.
3. `03-seudonimizacion.sql`: Implementación del mapa de correspondencia con UUIDs (`pii.mapa_cliente`), tabla analítica y rol `analista`.
4. `04-anonimizacion.sql`: Consultas de agregación, generalización por rangos de edad, región y supresión con `HAVING COUNT(*) >= 5`.
5. `05-retencion.sql`: Consulta de identificación de registros que sobrepasan el periodo de conservación de 5 años.

## Ejecución

Para ejecutar los scripts en orden desde el cliente interactivo `psql` de PostgreSQL:

```sql
\i sql/01-clasificacion.sql
\i sql/02-enmascaramiento.sql
\i sql/03-seudonimizacion.sql
\i sql/04-anonimizacion.sql
\i sql/05-retencion.sql
```