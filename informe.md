# Informe de Laboratorio — Protección y Privacidad de Datos (LAB-01)

**Estudiante:** Irwin Gabriel Martinez Prado  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** II — Seguridad, privacidad y control de acceso  
**Tema:** 2.3 — Datos sensibles, privacidad y protección de la información  
**Motor de Base de Datos:** PostgreSQL 16  

---

## 1. Clasificación de Datos

### 1.1 Matriz de Clasificación

| Campo | ¿Identifica directamente? | ¿Puede contribuir a identificar? | ¿Requiere protección? | Justificación |
| :--- | :---: | :---: | :---: | :--- |
| `id` | No | Sí | No / Interno | Clave primaria técnica sin significado externo directo, pero vincula registros. |
| `nombre` | **Sí** | Sí | **Sí** | Identificador directo de la persona física. |
| `correo` | **Sí** | Sí | **Sí** | Identificador directo y medio de contacto personal. |
| `telefono` | **Sí** | Sí | **Sí** | Identificador directo de contacto. |
| `rfc` | **Sí** | Sí | **Sí** | Identificador tributario oficial de persona física. |
| `edad` | No | **Sí** | **Sí** | Cuasi-identificador; combinado con ubicación permite diferenciar individuos. |
| `ciudad` | No | **Sí** | **Sí** | Cuasi-identificador de ubicación geográfica. |
| `codigo_postal` | No | **Sí** | **Sí** | Cuasi-identificador geográfico de alta precisión. |
| `fecha_alta` | No | **Sí** | No / Bajo | Dato operativo de auditoría. |

### 1.2 Análisis de Clasificación
* **Identificadores directos:** `nombre`, `correo`, `telefono` y `rfc`.
* **Cuasi-identificadores:** `edad`, `ciudad` y `codigo_postal`.
* **Riesgo de reidentificación:** La combinación de `edad` + `codigo_postal` + `ciudad` reduce significativamente el tamaño del grupo en una zona pequeña, lo que puede permitir reidentificar a un titular.
* **Aspecto normativo/jurídico:** No todos los datos que requieren protección son datos personales sensibles. Los identificadores directos requieren protección por confidencialidad, mientras que los datos sensibles son aquellos que pueden ocasionar discriminación o riesgos graves para el titular (ej. salud, religión, datos biométricos).

---

## 2. Enmascaramiento (Masking)

* **Información ocultada:** Los primeros caracteres del correo (manteniendo dominio), los primeros 6 dígitos del teléfono y los primeros 9 caracteres del RFC.
* **Destinatario:** Rol de `soporte`.
* **Propósito:** Permitir al área de soporte validar o corroborar la identidad de un usuario sin exponer los datos sensibles completos en pantalla.
* **Mecanismo utilizado:** Creación de una vista (`v_clientes_soporte`) con funciones de concatenación y extracción de cadenas (`CONCAT`, `LEFT`, `RIGHT`, `SUBSTRING`), revocando el acceso directo a la tabla base `public.clientes` y concediendo únicamente permisos `SELECT` sobre la vista.

---

## 3. Seudonimización (Pseudonymization)

* **Generación de tokens:** Se utilizó la extensión `pgcrypto` mediante la función `gen_random_uuid()` para asignar un UUID único e irreversible por cálculo directo a cada cliente.
* **Ubicación del mapa de correspondencia:** En el esquema protegido `pii.mapa_cliente`.
* **Acceso restringido:** Únicamente administradores de BD autorizados. Se revocó el acceso a este esquema al rol `analista`.
* **Separación de funciones:** El rol `analista` tiene acceso exclusivo al esquema `analitica` (`analitica.clientes`). Al no tener privilegios sobre `pii.mapa_cliente` ni `public.clientes`, se evita que el analista pueda vincular los patrones de análisis con la identidad real del titular.

---

## 4. Anonimización (Anonymization)

* **Identificadores eliminados:** `nombre`, `correo`, `telefono` y `rfc`.
* **Atributos generalizados:** La edad se transformó en rangos (`18-30`, `31-45`, `46+`) y el código postal se redujo a nivel de región geográfica (`LEFT(codigo_postal, 2)`).
* **Grupos suprimidos:** Aquellos con un conteo inferior al umbral de k-anonimato establecido (`HAVING COUNT(*) >= 5`).
* **Riesgo de reidentificación remanente:** Persiste el riesgo de ataques de homologación o de cruce con fuentes de datos externas cuando los atributos generalizados no son lo suficientemente amplios o el tamaño de la población es reducido.

---

## 5. Retención de Datos

* **Criterio utilizado:** Periodo de conservación límite de 5 años desde la fecha de alta (`fecha_alta < CURRENT_DATE - INTERVAL '5 years'`).
* **Información conservada/depurada:** Registros activos deben mantenerse; registros que superen el periodo deben ser identificados para depuración o archivo seguro.
* **Controles previos:** Validación de inexistencia de obligaciones legales o fiscales vigentes, autorización por parte de la dirección o área legal, respaldo previo y registro en bitácora de auditoría.

---

## 6. Conclusiones y Preguntas de Reflexión

1. **¿Qué técnica utilizarías para un área de soporte?**  
   Enmascaramiento dinámico a través de vistas, ya que necesitan validar ciertos datos en la atención diaria sin consultar el dato completo.
2. **¿Qué técnica utilizarías para un área de analítica?**  
   Seudonimización con separación de funciones, pues permite dar seguimiento individualizado a través de tokens sin exponer la identidad real.
3. **¿Qué técnica utilizarías para publicar estadísticas?**  
   Anonimización mediante agregación, generalización y supresión de grupos pequeños.
4. **¿Por qué ninguna de estas técnicas sustituye al control de acceso?**  
   Porque las técnicas de transformación modifican la presentación o estructura del dato, pero si no se aplican roles, `GRANT` y `REVOKE` adecuados, cualquier usuario no autorizado podría acceder a la información original o revertir las transformaciones.