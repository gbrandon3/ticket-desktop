# GUÍA DE TRABAJO: CÓMO ELABORAR EL MANUAL DE USUARIO
## Sistema de Gestión de Incidencias y Mantenimiento — Santi Inc

Esta guía contiene la ruta completa y explicada de **todas las funcionalidades de la plataforma**, los datos de prueba, las capturas que deben tomar y las instrucciones exactas de **lo que ustedes como aprendices deben redactar y explicar en su documento de Microsoft Word**.

---

## 📌 ANTES DE EMPEZAR
1. Crear una carpeta en su computador llamada `capturas_manual`.
2. Cada vez que se indique **CAPTURAR**, usar la combinación: `Windows + Shift + S`.
3. Guardar cada imagen con el nombre exacto indicado (ej: `01_setup_empresa.png`).
4. Abrir un documento en **Microsoft Word** e ir pegando las imágenes en orden, redactando la explicación de cómo funciona cada pantalla y para qué sirve cada botón.

---

## BLOQUE 1 — Configuración Inicial (Setup Wizard)
*(Hacer esto con la base de datos limpia al abrir la app por primera vez)*

### 1.1 Datos de la Empresa
* **Qué hace:** Registra la identidad legal de Santi Inc para los membretes de las actas y comprobantes en PDF.
* **Campos a diligenciar:**
  * **Nombre:** `Santi Inc - Taller de Soporte Técnico`
  * **Slogan:** `Servicio Técnico y Mantenimiento Especializado`
  * **NIT:** `901876543-2`
  * **Correo:** `taller@santi-inc.com` | **Teléfono:** `3109876543`
  * **Dirección:** `Cra. 45 # 12 - 34, Laboratorio de Cómputo`
* 👉 **CAPTURAR y guardar como:** `01_setup_empresa.png`
* ✍️ *En su Word:* Explicar qué es el Asistente Inicial (Setup Wizard), para qué sirve cada campo y por qué es obligatorio registrar la empresa antes de iniciar operaciones.

### 1.2 Cuenta del Administrador Principal
* **Qué hace:** Crea la cuenta raíz con control total sobre los módulos del taller.
* **Campos a diligenciar:** Nombre completo, Cédula (`1020345678`), Correo (`admin@santi.com`) y Contraseña (`Admin1234*`).
* 👉 **CAPTURAR y guardar como:** `02_setup_admin.png`
* ✍️ *En su Word:* Describir qué privilegios tiene el rol Administrador y por qué sus credenciales deben protegerse.

### 1.3 Personal Inicial (Técnico y Operador)
* **Qué hace:** Activa de inmediato los puestos de ventanilla y mesa de trabajo sin tener que crearlos después uno por uno.
* **Procedimiento:**
  * Activar switch **"Crear Técnico"**: Nombre: `Carlos Técnico`, Cédula: `987654321`, Correo: `tecnico@santi.com`.
  * Activar switch **"Crear Operador"**: Nombre: `Laura Operadora`, Cédula: `112233445`, Correo: `operador@santi.com`.
* 👉 **CAPTURAR y guardar como:** `03_setup_personal.png`
* Clic en **Completar Configuración**.
* ✍️ *En su Word:* Explicar la diferencia entre el rol de Técnico (diagnóstico y banco de trabajo) y el rol de Operador (recepción de clientes y entrega).

---

## BLOQUE 2 — Pantalla de Login y Autenticación
* **Qué hace:** Valida la identidad del usuario y restringe el acceso según su rol (`admin`, `tecnico`, `operador`). También da acceso al portal público para clientes.
* **Procedimiento:** Cerrar sesión desde el botón superior para regresar a la pantalla de Login.
* 👉 **CAPTURAR y guardar como:** `04_login.png`
* ✍️ *En su Word:* Explicar cómo funciona el inicio de sesión, cómo se validan las contraseñas y qué opción tienen los clientes que no poseen cuenta (enlace inferior de consulta pública).

---

## BLOQUE 3 — Catálogo de Fallas & Diagnósticos (Correctivo y Preventivo)
*(Ubicación: Iniciar sesión como Admin ➔ Menú Configuración ➔ Pestaña "Fallas & Diagnósticos")*

### 3.1 Administración de Tipos de Falla
* **Qué hace:** Permite al Administrador parametrizar las averías y servicios disponibles para que luego los operadores puedan seleccionarlos al radicar órdenes.
* **La pantalla tiene dos tarjetas independientes:**
  1. 🔴 **Tipos de Falla - Mantenimiento Correctivo:** Para registrar averías y daños reportados en equipos descompuestos.
  2. 🔵 **Tipos de Falla - Mantenimiento Preventivo:** Para registrar procedimientos de limpieza, optimización y mantenimiento periódico programado.

### 3.2 Crear Tipos de Falla en el Catálogo:
1. **En la tarjeta de Mantenimiento Correctivo:**
   * Hacer clic en el botón rojo **"+ Agregar"**.
   * Escribir: `Falla de Pantalla / Video` y guardar.
   * Hacer clic en **"+ Agregar"** de nuevo y escribir: `Falla de Disco / Almacenamiento` y guardar.
   * *💡 Observa cómo el contador cambia de "0 activos" a "2 activos".*
2. **En la tarjeta de Mantenimiento Preventivo:**
   * Hacer clic en el botón azul **"+ Agregar"**.
   * Escribir: `Mantenimiento Preventivo Semestral` y guardar.
   * Hacer clic en **"+ Agregar"** de nuevo y escribir: `Limpieza Física y Cambio de Pasta Térmica` y guardar.
   * *💡 Observa cómo el contador cambia a "2 activos".*
* 👉 **CAPTURAR la pantalla con las dos secciones y sus fallas creadas como:** `04_catalogo_fallas.png`
* ✍️ *En su Word:* Explicar detalladamente:
  * Para qué sirve el catálogo de fallas y diagnósticos.
  * Por qué están separados los tipos de falla en dos secciones: **Correctivo** (averías) y **Preventivo** (rutinas de mantenimiento).
  * Cómo se usa el botón `+ Agregar` en cada tarjeta y qué indica el badge de "activos".

---

## BLOQUE 4 — Módulo de Clientes
* **Qué hace:** Directorio centralizado de usuarios, dependencias y empresas que solicitan servicios técnicos.

### 4.1 Registrar Clientes:
1. Ir a **Clientes** (o dentro de radicación) y hacer clic en **+ Nuevo Cliente**.
2. Registrar estos 3 clientes de prueba:
   * **Cliente 1:** Cédula `1020111222` | `María García López` | `maria.garcia@correo.com` | Tel: `3109876543` | `Sala de Sistemas - Piso 2`. Guardar.  
     👉 **CAPTURAR formulario lleno:** `05_cliente_nuevo.png`
   * **Cliente 2:** Cédula `98765432` | `Carlos Pérez Rodríguez` | `carlos.perez@correo.com` | Tel: `3205554433` | `Rectoría - Piso 3`.
   * **Cliente 3:** NIT `900123456-1` | `Empresa XYZ S.A.S` | `contacto@xyz.com` | Tel: `6017001234` | `Calle 80 #20-30`.
3. Ir a la tabla general de clientes donde se listen los 3 registros.  
   👉 **CAPTURAR tabla:** `06_clientes_tabla.png`
4. ✍️ *En su Word:* Explicar los campos obligatorios del cliente (nombre, documento, teléfono, correo) y por qué son necesarios para el envío de notificaciones y la consulta pública.

---

## BLOQUE 5 — Inventario Técnico y Hojas de Vida de Equipos
* **Qué hace:** Administra los activos de hardware, sus especificaciones técnicas y su historial de reparaciones.

### 5.1 Registrar Equipos en Inventario:
1. Ir a **Inventario de Equipos > + Nuevo Equipo**.
2. Registrar estos 3 equipos vinculándolos a sus clientes:
   * **Equipo 1 (Portátil):** Serie: `HP-ELITE-840-001`, Modelo: `EliteBook 840 G8`, Marca: `HP`, Ubicación: `Sala de Sistemas`, SO: `Windows 11`, Procesador: `i7`, RAM: `16GB`, SSD: `512GB`, Cliente: `María García`.  
     👉 **CAPTURAR formulario lleno:** `07_equipo_portatil.png`
   * **Equipo 2 (PC de Mesa):** Serie: *(automático)*, Nombre: `CPU Contabilidad`, Tipo: `PC de Mesa`, RAM: `8GB`, HDD: `1TB`, Cliente: `Empresa XYZ`.
   * **Equipo 3 (All-in-One):** Serie: `DELL-AIO-3280-005`, Nombre: `OptiPlex 3280`, RAM: `8GB`, Cliente: `Carlos Pérez`.
3. 👉 **CAPTURAR tabla de inventario con los 3 equipos listados:** `08_inventario_tabla.png`
4. Clic en **Hoja de Vida** del portátil HP.  
   👉 **CAPTURAR modal de hoja de vida:** `09_hoja_de_vida.png`
5. ✍️ *En su Word:* Describir qué datos componen la ficha técnica de un equipo y qué ventajas ofrece tener una hoja de vida histórica para cada máquina del taller.

---

## BLOQUE 6 — Crear Incidencia 1 (Correctiva — Flujo Completo)
* **Qué hace:** Asistente interactivo de 4 pasos para radicar la entrada de un equipo dañado al taller.

### 6.1 Procedimiento de Radicación:
1. Hacer clic en **"Radicar / Crear Incidencia"**.
2. **Paso 1 (Solicitante y Tipo):**
   * Seleccionar Cliente: `María García López`.
   * Tipo de Mantenimiento: Seleccionar **Correctivo**.
   * Categoría / Tipo de Falla: *Seleccionar la falla correctiva creada en el catálogo (`Falla de Pantalla / Video`)*.
   * Título: `Falla pantalla`. Prioridad: `Alta`.  
   👉 **CAPTURAR:** `10_radicar_paso1.png`
3. **Paso 2 (Equipo y Falla):**
   * Seleccionar el equipo de María: `Portátil HP (HP-ELITE-840-001)`.
   * Describir la falla: *El equipo enciende pero la pantalla no da video*.  
   👉 **CAPTURAR:** `11_radicar_paso2.png`
4. **Paso 3 (Inspección y Fotos):**
   * Marcar accesorios recibidos: `Cargador original`, `Funda`.
   * Adjuntar foto del equipo en recepción.  
   👉 **CAPTURAR:** `12_radicar_paso3.png`
5. **Paso 4 (Asignación):**
   * Seleccionar a `Carlos Técnico`.  
   👉 **CAPTURAR antes de asignar:** `13_radicar_paso4.png`
   * Clic en **Crear y Radicar**.
6. ✍️ *En su Word:* Explicar detalladamente cada uno de los 4 pasos del asistente y justificar por qué es indispensable fotografiar el equipo y registrar los accesorios en la recepción.

---

## BLOQUE 7 — Crear Incidencia 2 (Preventiva — Uso del Catálogo Preventivo)
* **Qué hace:** Demuestra cómo el sistema se adapta automáticamente cuando no hay una avería, sino una rutina de mantenimiento preventivo.

### 7.1 Procedimiento:
1. Clic en **"Radicar Incidencia"**.
2. Seleccionar a `Carlos Pérez`.
3. En Tipo de Servicio, seleccionar **Preventivo**.
   * *💡 Observa que el campo "Tipo / Alcance del Servicio" ahora carga automáticamente los tipos preventivos creados en el catálogo (`Mantenimiento Preventivo Semestral`, `Limpieza Física y Cambio de Pasta Térmica`).*
4. Seleccionar el equipo `All-in-One Dell`.
5. Asignar al técnico y radicar.
6. 👉 **CAPTURAR el formulario preventivo con su alcance y aviso automático:** `14_radicar_preventivo.png`
7. ✍️ *En su Word:* Explicar con precisión cómo cambia la interfaz cuando se elige "Preventivo" vs "Correctivo" y cómo el catálogo de fallas preventivas alimenta esta selección.

---

## BLOQUE 8 — Atender Incidencia 1 como Técnico (Mesa de Taller)
* **Qué hace:** Módulo operativo donde el técnico diagnostica, repara, carga repuestos, ejecuta pruebas de calidad y emite el acta oficial de entrega.

### 8.1 Procedimiento en Taller:
1. Iniciar sesión como Técnico: `tecnico@santi.com` | `Tecnico123*`.
2. 👉 **CAPTURAR dashboard del técnico con sus órdenes:** `15_dashboard_tecnico.png`
3. Clic en **Gestionar Mantenimiento** en la orden de María García:
   * **Pestaña OT (Orden de Trabajo):** Llenar diagnóstico técnico preliminar y herramientas a utilizar. Clic en Guardar.  
     👉 **CAPTURAR:** `16_orden_trabajo.png`
   * **Pestaña Bitácora:** Describir la intervención realizada, agregar repuesto `Pantalla LCD` por valor de `$180.000` y marcar las casillas del checklist de calidad.  
     👉 **CAPTURAR bitácora y repuesto cargado:** `17_bitacora_repuestos.png`  
     👉 **CAPTURAR checklists de pruebas marcados:** `18_pruebas_calidad.png`
   * **Pestaña Fotos:** Subir foto de ingreso del equipo y foto del trabajo terminado.  
     👉 **CAPTURAR foto de ingreso:** `19_fotos_ingreso.png`  
     👉 **CAPTURAR foto de proceso final:** `20_fotos_proceso.png`
   * **Pestaña Acta de Entrega:** Seleccionar estado `Operativo`, garantía `30 días`, escribir recomendaciones al cliente, ingresar el nombre de quien recibe y marcar conformidad.  
     👉 **CAPTURAR formulario de acta listo:** `21_acta_entrega.png`  
     Hacer clic en **Cerrar Incidencia y Generar Acta**. Luego clic en **Ver Documento Oficial**.  
     👉 **CAPTURAR el documento oficial PDF en pantalla:** `22_documento_oficial.png`
4. ✍️ *En su Word:* Explicar cada una de las 4 pestañas de taller (OT, Bitácora, Fotos y Acta) y la validez legal del documento PDF generado.

---

## BLOQUE 9 — Dashboard Administrativo con Datos Vivos
* **Qué hace:** Panel de supervisión en tiempo real con indicadores de rendimiento, tiempos de respuesta y control de tickets.

### 9.1 Procedimiento:
1. Iniciar sesión como Administrador (`admin@santi.com`).
2. En la pantalla principal:
   * 👉 **CAPTURAR tarjetas métricas de SLA:** `23_dashboard_admin_sla.png`
   * 👉 **CAPTURAR gráfica / panel de carga técnica:** `24_dashboard_tecnicos.png`
   * 👉 **CAPTURAR tabla general con las órdenes en distintos estados:** `25_dashboard_tabla.png`
3. ✍️ *En su Word:* Explicar qué es el SLA (Acuerdo de Nivel de Servicio), cómo se interpreta el panel de carga de los técnicos y por qué es importante monitorear los estados de las órdenes.

---

## BLOQUE 10 — Módulo de Configuración Integral (Las 6 Pestañas)
* **Qué hace:** Centro de control administrativo donde se parametriza toda la plataforma.

### 10.1 Procedimiento:
1. Dirigirse al menú **Configuración** y tomar las capturas de sus pestañas clave:
   * Pestaña **Mi Perfil:** Actualización de datos del usuario autenticado.  
     👉 **CAPTURAR:** `26_config_perfil.png`
   * Pestaña **Identidad Corporativa:** Razón social, NIT, teléfono y dirección del taller.  
     👉 **CAPTURAR:** `27_config_identidad.png`
   * Pestaña **Gestión de Usuarios:** Creación, cambio de rol y control de accesos (`admin`, `tecnico`, `operador`).  
     👉 **CAPTURAR:** `28_config_usuarios.png`
   * Pestaña **Servidor SMTP:** Configuración del correo para envío automático de alertas.  
     👉 **CAPTURAR:** `29_config_smtp.png`
   * Pestaña **Tema Visual:** Cambio entre modo Claro/Oscuro y paletas de color. *(Opcional)*
   * Pestaña **Fallas & Diagnósticos:** *(Ya capturada en el Bloque 3 como `04_catalogo_fallas.png`)*.
2. ✍️ *En su Word:* Describir brevemente qué función cumple cada pestaña del módulo de configuración.

---

## BLOQUE 11 — Portal de Consulta Pública (Trazabilidad Sin Login)
* **Qué hace:** Permite que cualquier cliente consulte el estado de su equipo por internet sin necesidad de iniciar sesión ni tener usuario.

### 11.1 Procedimiento:
1. Cerrar sesión completamente para situarse en la pantalla de Login.
2. Hacer clic en el enlace inferior **"¿Quieres consultar el estado de tu equipo? Consulta pública"**.
3. Ingresar el código del ticket de María García y su cédula `1020111222`.
4. Clic en **"Buscar / Consultar"**.
5. 👉 **CAPTURAR la pantalla de trazabilidad pública con la línea de tiempo:** `30_consulta_publica.png`
6. ✍️ *En su Word:* Explicar los beneficios de la consulta pública: transparencia, ahorro de tiempo para el taller (menos llamadas preguntando por el equipo) y satisfacción del cliente.

---

## 📋 MATRIZ MAESTRA DE LAS CAPTURAS

| # | Archivo | Dónde se toma en el sistema | Qué debe mostrar |
| :-: | :--- | :--- | :--- |
| **01** | `01_setup_empresa.png` | Wizard inicial — Paso 1 | Datos de la empresa diligenciados con NIT y dirección |
| **02** | `02_setup_admin.png` | Wizard inicial — Paso 2 | Creación de cuenta del Administrador principal |
| **03** | `03_setup_personal.png` | Wizard inicial — Paso 3 | Creación de personal con Técnico y Operador activos |
| **04** | `04_login.png` | Pantalla de Login | Login con nombre de Santi Inc y enlace público |
| **05** | `04_catalogo_fallas.png` | Configuración > Fallas & Diagnósticos | Tarjetas de fallas Correctivas y Preventivas creadas |
| **06** | `05_cliente_nuevo.png` | Módulo Clientes > + Nuevo | Formulario de cliente diligenciado con María García |
| **07** | `06_clientes_tabla.png` | Módulo Clientes | Tabla general con los 3 clientes registrados |
| **08** | `07_equipo_portatil.png` | Inventario > + Nuevo Equipo | Formulario de Portátil HP con ficha técnica completa |
| **09** | `08_inventario_tabla.png` | Inventario de Equipos | Tabla con Portátil, PC de Mesa y All-in-One |
| **10** | `09_hoja_de_vida.png` | Inventario > Hoja de Vida | Modal con el expediente técnico del equipo |
| **11** | `10_radicar_paso1.png` | Radicación — Paso 1 | Cliente, tipo correctivo, falla del catálogo y prioridad |
| **12** | `11_radicar_paso2.png` | Radicación — Paso 2 | Selección del equipo y descripción de la avería |
| **13** | `12_radicar_paso3.png` | Radicación — Paso 3 | Checklist de accesorios y foto de recepción |
| **14** | `13_radicar_paso4.png` | Radicación — Paso 4 | Resumen y asignación formal a Carlos Técnico |
| **15** | `14_radicar_preventivo.png` | Radicación (Preventivo) | Formulario preventivo cargando el tipo del catálogo |
| **16** | `15_dashboard_tecnico.png` | Inicio con rol Técnico | Bandeja de órdenes asignadas en taller |
| **17** | `16_orden_trabajo.png` | Gestión Mantenimiento > OT | Diagnóstico técnico detallado e instrumental seleccionado |
| **18** | `17_bitacora_repuestos.png` | Gestión Mantenimiento > Bitácora | Procedimientos cronológicos y repuesto LCD ($180.000) |
| **19** | `18_pruebas_calidad.png` | Gestión Mantenimiento > Bitácora | Checklists de pruebas de calidad y temperatura validados |
| **20** | `19_fotos_ingreso.png` | Gestión Mantenimiento > Fotos | Foto del equipo dañado al ingresar al taller |
| **21** | `20_fotos_proceso.png` | Gestión Mantenimiento > Fotos | Foto del equipo reparado y operativo |
| **22** | `21_acta_entrega.png` | Gestión Mantenimiento > Acta | Formulario de cierre con garantía de 30 días y conformidad |
| **23** | `22_documento_oficial.png` | Visor de Acta en PDF | Documento Oficial de Entrega generado con firmas |
| **24** | `23_dashboard_admin_sla.png` | Inicio con rol Admin | Tarjetas métricas de cumplimiento de SLA |
| **25** | `24_dashboard_tecnicos.png` | Inicio con rol Admin | Gráfica de balance de carga técnica por especialista |
| **26** | `25_dashboard_tabla.png` | Inicio con rol Admin | Tabla de tickets en diferentes fases de atención |
| **27** | `26_config_perfil.png` | Configuración > Mi Perfil | Datos de perfil y seguridad del usuario |
| **28** | `27_config_identidad.png` | Configuración > Identidad | Datos corporativos de Santi Inc |
| **29** | `28_config_usuarios.png` | Configuración > Usuarios | Tabla de administración de usuarios y roles |
| **30** | `29_config_smtp.png` | Configuración > Servidor SMTP | Parámetros del servidor de correos salientes |
| **31** | `30_consulta_publica.png` | Consulta Pública sin login | Línea de tiempo interactiva con la trazabilidad del ticket |

---

💡 **Instrucción de entrega:** Cada aprendiz del grupo toma sus capturas, abre Microsoft Word, crea los títulos correspondientes y redacta la explicación de cada pantalla siguiendo las pautas marcadas con el lápiz (✍️ *En su Word*).
