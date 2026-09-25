# GUÍA DE CAPTURAS PARA EL MANUAL DE USUARIO
## Sistema de Gestión de Incidencias y Mantenimiento — Santi Inc

---

## 📌 ANTES DE EMPEZAR
* Usar la aplicación en pantalla maximizada para que se aprecien todos los componentes.
* Tener el sistema iniciado con la base de datos limpia.
* Cada vez que se indique **CAPTURAR**, tomar la pantalla con `Windows + Shift + S`.
* Guardar cada captura con el nombre indicado en una carpeta llamada `capturas_manual`.
* **Objetivo:** Tomar las **30 capturas** en este orden para luego pegarlas directamente en el documento de Word del Manual de Usuario.

---

## BLOQUE 1 — Configuración Inicial (Setup Wizard)
*(Hacer esto solo si la base de datos está vacía. Si ya se configuró, saltar al Bloque 2)*

1. Abrir el sistema por primera vez (se activa automáticamente el Asistente de Configuración).
2. **Paso 1 — Datos de la Empresa:**
   * a. **Nombre:** `Santi Inc - Taller de Soporte Técnico`
   * b. **Slogan:** `Servicio Técnico y Mantenimiento Especializado`
   * c. **NIT:** `901876543-2`
   * d. **Correo:** `taller@santi-inc.com`
   * e. **Teléfono:** `3109876543`
   * f. **Dirección:** `Cra. 45 # 12 - 34, Laboratorio de Cómputo`
   * g. 👉 **CAPTURAR y guardar como:** `01_setup_empresa.png`
3. **Paso 2 — Cuenta del Administrador:**
   * a. **Nombre:** *(Nombre del Administrador)*
   * b. **Cédula:** `1020345678`
   * c. **Correo:** `admin@santi.com`
   * d. **Contraseña:** `Admin1234*`
   * e. 👉 **CAPTURAR y guardar como:** `02_setup_admin.png`
4. **Paso 3 — Personal Inicial:**
   * a. Activar **"Crear Técnico"**: Nombre: `Carlos Técnico`, Cédula: `987654321`, Correo: `tecnico@santi.com`
   * b. Activar **"Crear Operador"**: Nombre: `Laura Operadora`, Cédula: `112233445`, Correo: `operador@santi.com`
   * c. 👉 **CAPTURAR y guardar como:** `03_setup_personal.png`
5. Clic en **Completar Configuración**.

---

## BLOQUE 2 — Pantalla de Login
1. Cerrar sesión si están dentro del sistema.
2. 👉 **CAPTURAR la pantalla de login con el nombre de la empresa visible y guardar como:** `04_login.png`.

---

## BLOQUE 3 — Registrar Clientes
1. Iniciar sesión como **Administrador** (`admin@santi.com`).
2. Ir a **Radicar Incidencia** (o módulo de Clientes).
3. En el Paso 1, hacer clic en **+ Nuevo Cliente** y registrar estos 3:
   * a. **Cliente 1:** Tipo: `Cédula` | Número: `1020111222`, Nombre: `María García López`, Correo: `maria.garcia@correo.com`, Teléfono: `3109876543`, Dirección: `Sala de Sistemas - Piso 2`. Guardar.  
     👉 **CAPTURAR formulario lleno como:** `05_cliente_nuevo.png`
   * b. **Cliente 2:** Tipo: `Cédula` | Número: `98765432`, Nombre: `Carlos Pérez Rodríguez`, Correo: `carlos.perez@correo.com`, Teléfono: `3205554433`, Dirección: `Rectoría - Piso 3`. Guardar.
   * c. **Cliente 3:** Tipo: `NIT` | Número: `900123456-1`, Nombre: `Empresa XYZ S.A.S`, Correo: `contacto@xyz.com`, Teléfono: `6017001234`, Dirección: `Calle 80 #20-30, Bogotá`. Guardar.
4. 👉 **CAPTURAR la tabla con los 3 clientes listados como:** `06_clientes_tabla.png`.

---

## BLOQUE 4 — Registrar Equipos en Inventario
1. Ir a **Inventario de Equipos**.
2. Hacer clic en **+ Nuevo Equipo** y registrar estos 3:
   * a. **Equipo 1 — Portátil:** Serie: `HP-ELITE-840-001`, Modelo: `EliteBook 840 G8`, Marca: `HP`, Ubicación: `Sala de Sistemas`, SO: `Windows 11`, Procesador: `i7`, RAM: `16GB`, SSD: `512GB`.  
     👉 **CAPTURAR formulario lleno como:** `07_equipo_portatil.png`
   * b. **Equipo 2 — PC de Mesa:** Serie: *(automático / sin serie)*, Nombre: `CPU Contabilidad`, Tipo: `PC de Mesa`, RAM: `8GB`, HDD: `1TB`. Guardar.
   * c. **Equipo 3 — All-in-One:** Serie: `DELL-AIO-3280-005`, Nombre: `OptiPlex 3280`, RAM: `8GB`. Guardar.
3. 👉 **CAPTURAR la tabla del inventario con los 3 equipos como:** `08_inventario_tabla.png`.
4. Hacer clic en **Hoja de Vida** del portátil HP.  
   👉 **CAPTURAR el modal / vista de hoja de vida como:** `09_hoja_de_vida.png`.

---

## BLOQUE 5 — Crear Incidencia 1 (Correctiva — Flujo Completo)
1. Ir a **Radicar Incidencia**. Paso 1: Seleccionar a `María García López`.  
   👉 **CAPTURAR como:** `10_radicar_paso1.png`.
2. Paso 2: Seleccionar `Correctivo`, Categoría: `Hardware`, Título: `Falla pantalla`, Prioridad: `Alta`.  
   👉 **CAPTURAR formulario lleno como:** `11_radicar_paso2.png`.
3. Paso 3: Seleccionar `Portátil HP` y adjuntar evidencia fotográfica y accesorios.  
   👉 **CAPTURAR como:** `12_radicar_paso3.png`.
4. Paso 4: Seleccionar a `Carlos Técnico`.  
   👉 **CAPTURAR antes de asignar como:** `13_radicar_paso4.png`.

---

## BLOQUE 6 — Crear Incidencia 2 (Preventiva)
1. Repetir proceso de radicación con `Carlos Pérez`. Tipo: `Preventivo`.  
   👉 **CAPTURAR el formulario preventivo (notar el aviso o título automático) como:** `14_radicar_preventivo.png`.

---

## BLOQUE 7 — Atender Incidencia 1 como Técnico
1. Iniciar sesión con la cuenta de técnico (`tecnico@santi.com`).  
   👉 **CAPTURAR el dashboard de técnico como:** `15_dashboard_tecnico.png`.
2. Clic en **Gestionar Mantenimiento** (Incidencia 1). Pestaña **OT**: Llenar diagnóstico técnico y herramientas.  
   👉 **CAPTURAR como:** `16_orden_trabajo.png`.
3. Pestaña **Bitácora**: Describir la reparación, agregar repuesto `Pantalla LCD` (`$180.000`) y marcar checklists de calidad.  
   👉 **CAPTURAR Bitácora y Repuestos como:** `17_bitacora_repuestos.png`.  
   👉 **CAPTURAR Checklists marcados como:** `18_pruebas_calidad.png`.
4. Pestaña **Fotos**:
   * Subir foto de ingreso ➔ 👉 **CAPTURAR:** `19_fotos_ingreso.png`.
   * Subir foto de trabajo realizado ➔ 👉 **CAPTURAR:** `20_fotos_proceso.png`.
5. Pestaña **Acta de Entrega**: Estado: `Operativo`, garantía: `30 días`.  
   👉 **CAPTURAR formulario de entrega como:** `21_acta_entrega.png`.  
   Cerrar la orden y presionar en Ver Documento Oficial ➔ 👉 **CAPTURAR el documento final en pantalla como:** `22_documento_oficial.png`.

---

## BLOQUE 8 — Dashboard Admin con Datos Completos
1. Iniciar sesión nuevamente como **Administrador**.
2. 👉 **CAPTURAR métricas SLA como:** `23_dashboard_admin_sla.png`.
3. 👉 **CAPTURAR panel de carga técnica (técnicos con tickets) como:** `24_dashboard_tecnicos.png`.
4. 👉 **CAPTURAR tabla general de incidencias con los tickets en distintos estados como:** `25_dashboard_tabla.png`.

---

## BLOQUE 9 — Módulo de Configuración
1. En **Configuración**, tomar las siguientes 4 capturas:
   * Pestaña Perfil / Cuenta ➔ 👉 **CAPTURAR como:** `26_config_perfil.png`.
   * Pestaña Identidad / Datos Empresa ➔ 👉 **CAPTURAR como:** `27_config_identidad.png`.
   * Pestaña Gestión de Usuarios ➔ 👉 **CAPTURAR como:** `28_config_usuarios.png`.
   * Pestaña Servidor de Correo (SMTP) ➔ 👉 **CAPTURAR como:** `29_config_smtp.png`.

---

## BLOQUE 10 — Consulta Pública
1. Cerrar sesión (ir a la pantalla de login).
2. Hacer clic en **"Consultar estado sin iniciar sesión"**.
3. Consultar la orden de María García (`TICK-0001` o el código generado) con su cédula `1020111222`.  
   👉 **CAPTURAR la pantalla de trazabilidad pública como:** `30_consulta_publica.png`.

---

## 📋 RESUMEN DE LAS 30 CAPTURAS

| # | Nombre de Archivo | Qué debe mostrar la captura |
| :-: | :--- | :--- |
| **01** | `01_setup_empresa.png` | Wizard — Datos de la empresa diligenciados |
| **02** | `02_setup_admin.png` | Wizard — Cuenta de administrador |
| **03** | `03_setup_personal.png` | Wizard — Personal inicial (Técnico y Operador activos) |
| **04** | `04_login.png` | Pantalla de Login con el nombre del taller visible |
| **05** | `05_cliente_nuevo.png` | Formulario de registro de nuevo cliente diligenciado |
| **06** | `06_clientes_tabla.png` | Tabla con los 3 clientes registrados |
| **07** | `07_equipo_portatil.png` | Formulario de nuevo equipo (Portátil HP) lleno |
| **08** | `08_inventario_tabla.png` | Tabla de inventario con los 3 equipos registrados |
| **09** | `09_hoja_de_vida.png` | Modal / vista de Hoja de Vida del equipo |
| **10** | `10_radicar_paso1.png` | Asistente de radicación — Paso 1 (Selección de cliente) |
| **11** | `11_radicar_paso2.png` | Asistente de radicación — Paso 2 (Falla y mantenimiento correctivo) |
| **12** | `12_radicar_paso3.png` | Asistente de radicación — Paso 3 (Equipo, accesorios y foto) |
| **13** | `13_radicar_paso4.png` | Asistente de radicación — Paso 4 (Asignación a técnico) |
| **14** | `14_radicar_preventivo.png` | Formulario de radicación preventiva con aviso/título auto |
| **15** | `15_dashboard_tecnico.png` | Dashboard del Técnico con órdenes asignadas |
| **16** | `16_orden_trabajo.png` | Pestaña OT con diagnóstico preliminar y herramientas |
| **17** | `17_bitacora_repuestos.png` | Pestaña Bitácora con actividades y repuesto LCD (\$180.000) |
| **18** | `18_pruebas_calidad.png` | Pestaña Bitácora con checklists de calidad marcados |
| **19** | `19_fotos_ingreso.png` | Pestaña Fotos con fotografía de ingreso del equipo |
| **20** | `20_fotos_proceso.png` | Pestaña Fotos con fotografía del trabajo realizado |
| **21** | `21_acta_entrega.png` | Pestaña Acta de Entrega diligenciada lista para cierre |
| **22** | `22_documento_oficial.png` | Documento Oficial de Entrega generado en pantalla |
| **23** | `23_dashboard_admin_sla.png` | Dashboard Admin — Tarjetas métricas de SLA |
| **24** | `24_dashboard_tecnicos.png` | Dashboard Admin — Gráfica / Panel de carga técnica |
| **25** | `25_dashboard_tabla.png` | Dashboard Admin — Tabla con tickets en distintos estados |
| **26** | `26_config_perfil.png` | Configuración — Pestaña de Perfil / Cuenta |
| **27** | `27_config_identidad.png` | Configuración — Pestaña de Identidad de Empresa |
| **28** | `28_config_usuarios.png` | Configuración — Pestaña de Gestión de Usuarios |
| **29** | `29_config_smtp.png` | Configuración — Pestaña de Servidor de Correo (SMTP) |
| **30** | `30_consulta_publica.png` | Resultado de Consulta Pública sin login con trazabilidad |

---

> 💡 **Tip final para los aprendices:** Una vez tomadas las 30 capturas en la carpeta `capturas_manual`, abrir su plantilla de **Microsoft Word** e ir insertando cada imagen en el mismo orden de esta lista con su respectiva explicación de uso.
