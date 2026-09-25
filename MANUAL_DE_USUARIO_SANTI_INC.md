# 📖 MANUAL DE USUARIO — PLATAFORMA DE GESTIÓN DE TALLER SANTI INC
## Documento Guía Oficial para la Operación del Sistema

```
  ╔════════════════════════════════════════════════════════════════════════════════════════╗
  ║  SERVICIO NACIONAL DE APRENDIZAJE - SENA                                               ║
  ║  Documento de Entrega: Manual de Usuario del Software                                  ║
  ║  Proyecto: Sistema de Gestión de Órdenes y Soporte Técnico — Santi Inc                 ║
  ║  Versión del Sistema: 1.0.0 (Producción)                                               ║
  ║  Elaborado por (Aprendices): ________________________________________________________  ║
  ║  Ficha: ____________________   Fecha: ______ / ______ / 202X                           ║
  ╚════════════════════════════════════════════════════════════════════════════════════════╝
```

---

## 📑 TABLA DE CONTENIDO
1. [Introducción y Alcance](#1-introducción-y-alcance)
2. [Requisitos y Acceso a la Plataforma](#2-requisitos-y-acceso-a-la-plataforma)
3. [Capítulo 1: Configuración Inicial de la Empresa (Setup Wizard)](#capítulo-1-configuración-inicial-de-la-empresa-setup-wizard)
4. [Capítulo 2: Módulo de Seguridad y Gestión de Usuarios](#capítulo-2-módulo-de-seguridad-y-gestión-de-usuarios)
5. [Capítulo 3: Catálogo de Tipos de Falla](#capítulo-3-catálogo-de-tipos-de-falla)
6. [Capítulo 4: Gestión de Clientes](#capítulo-4-gestión-de-clientes)
7. [Capítulo 5: Inventario y Ficha Técnica de Equipos](#capítulo-5-inventario-y-ficha-técnica-de-equipos)
8. [Capítulo 6: Radicación de Incidencias y Órdenes de Servicio](#capítulo-6-radicación-de-incidencias-y-órdenes-de-servicio)
9. [Capítulo 7: Mesa de Trabajo y Gestión Técnica de Taller](#capítulo-7-mesa-de-trabajo-y-gestión-técnica-de-taller)
10. [Capítulo 8: Panel Administrativo y Métricas de Rendimiento](#capítulo-8-panel-administrativo-y-métricas-de-rendimiento)
11. [Capítulo 9: Portal de Consulta Pública de Estados](#capítulo-9-portal-de-consulta-pública-de-estados)
12. [Glosario de Términos](#glosario-de-términos)

---

## 1. INTRODUCCIÓN Y ALCANCE
El presente **Manual de Usuario** tiene como finalidad orientar a los usuarios en la operación diaria de la plataforma de soporte y servicio técnico de **Santi Inc**. Describe de manera gráfica y detallada cada pantalla, botón, formulario y flujo operativo, garantizando una atención estandarizada desde la recepción del equipo hasta su entrega final.

### Roles del Sistema:
* **Administrador (`admin`):** Control total de la empresa, usuarios, catálogos, métricas de SLA y auditoría.
* **Operador (`operador`):** Recepción de clientes, registro de equipos en inventario, radicación de incidencias y entrega formal.
* **Técnico (`tecnico`):** Diagnóstico en banco de trabajo, registro de bitácoras, aplicación de repuestos y cierre técnico.

---

## 2. REQUISITOS Y ACCESO A LA PLATAFORMA
* **Sistema Operativo:** Windows 10 / 11, Linux o macOS.
* **Conectividad:** Funciona de manera 100% autónoma y local (base de datos SQLite embebida). No requiere internet para operar en el taller.
* **Inicio de la Aplicación:** Ejecutar el archivo de la aplicación `tickets_app.exe`.

---

## CAPÍTULO 1: CONFIGURACIÓN INICIAL DE LA EMPRESA (SETUP WIZARD)

### 1.1 Descripción de la Pantalla
Al ejecutar la aplicación por primera vez en un equipo nuevo o con base de datos limpia, el sistema presenta automáticamente el **Asistente de Puesta en Marcha (Setup Wizard)**. Esta interfaz permite registrar la identidad corporativa y la cuenta del Administrador principal.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 1.1: Pantalla del Asistente de Configuración Inicial ]       │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DEL ASISTENTE INICIAL DILIGENCIADO <<        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Campos y Funcionalidades
1. **Razón Social / Nombre Comercial:** Nombre del taller o empresa (Ej: `Santi Inc - Taller de Soporte Técnico`).
2. **NIT / Documento:** Identificación fiscal de la empresa (Ej: `901876543-2`).
3. **Dirección y Teléfono:** Datos de contacto que aparecerán impresos en todos los comprobantes y actas PDF generados.
4. **Cuenta Administrador:**
   * *Nombre completo y Cédula:* Datos del administrador del sistema.
   * *Correo y Contraseña:* Credenciales con las que se iniciará sesión por primera vez.
5. **Botón "Finalizar y Comenzar":** Guarda la configuración en la base de datos local y redirige al Dashboard principal.

---

## CAPÍTULO 2: MÓDULO DE SEGURIDAD Y GESTIÓN DE USUARIOS

### 2.1 Descripción de la Pantalla
Ubicada en **Configuración > Gestión de Usuarios**. Permite al Administrador dar de alta, consultar y administrar los permisos del personal del taller.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 2.1: Tabla de Usuarios Registrados y Formulario de Alta ]    │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DE LA TABLA CON ROLES ADMIN, TÉCNICO Y OP << │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Procedimiento para Crear un Nuevo Usuario
1. Dirigirse al menú **Configuración** y seleccionar la pestaña **Usuarios**.
2. Hacer clic en el botón superior **"+ Nuevo Usuario"**.
3. Diligenciar los campos obligatorios:
   * **Nombre Completo:** Nombre del empleado o técnico.
   * **Documento:** Cédula de ciudadanía.
   * **Correo Electrónico:** Correo institucional que servirá como usuario de acceso.
   * **Contraseña:** Clave de acceso al sistema.
   * **Rol:** Seleccionar estrictamente entre **Administrador**, **Técnico** u **Operador**.
4. Hacer clic en **"Guardar Usuario"**. El nuevo usuario aparecerá inmediatamente listado en la tabla.

---

## CAPÍTULO 3: CATÁLOGO DE TIPOS DE FALLA

### 3.1 Descripción de la Pantalla
Ubicada en **Configuración > Catálogo de Fallas**. Permite tipificar las averías frecuentes atendidas en el taller para agilizar la radicación y generar estadísticas precisas.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 3.1: Catálogo de Tipos de Falla Activos ]                    │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DEL CATÁLOGO DE FALLAS CREADAS <<            │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Procedimiento para Registrar una Falla
1. En la pestaña **Catálogo de Fallas**, hacer clic en **"+ Nuevo Tipo de Falla"**.
2. Ingresar:
   * **Nombre de la Falla:** (Ej: `Falla de Hardware y Pantalla`, `Mantenimiento Preventivo`).
   * **Categoría:** Seleccionar entre *Hardware*, *Software* o *Preventivo*.
   * **Descripción:** Breve detalle técnico de los síntomas habituales.
3. Guardar el registro. La falla quedará disponible en el selector del formulario de radicación.

---

## CAPÍTULO 4: GESTIÓN DE CLIENTES

### 4.1 Descripción de la Pantalla
Permite registrar y mantener la base de datos de personas naturales o empresas que solicitan servicios en el taller.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 4.1: Módulo de Clientes — Formulario y Listado ]             │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DEL FORMULARIO Y TABLA DE CLIENTES <<        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Procedimiento para Registrar un Cliente
1. Ir al módulo **Clientes** y presionar **"+ Nuevo Cliente"**.
2. Registrar los datos del solicitante:
   * **Nombre / Razón Social:** (Ej: *María García*, *Carlos Pérez*, *Empresa XYZ S.A.S.*).
   * **Número de Documento (CC / NIT):** Documento con el que el cliente podrá consultar el estado de su orden.
   * **Teléfono y Correo:** Canales para envío de comprobantes y notificaciones.
   * **Dependencia / Ubicación:** Oficina o departamento de procedencia (Ej: *Sala de Sistemas*, *Rectoría*, *Contabilidad*).
3. Presionar **"Guardar Cliente"**.

---

## CAPÍTULO 5: INVENTARIO Y FICHA TÉCNICA DE EQUIPOS

### 5.1 Descripción de la Pantalla
Ubicada en el menú **Inventario de Equipos**. Mantiene la hoja de vida técnica de cada máquina ingresada al taller.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 5.1: Inventario de Equipos con Ficha Técnica Detallada ]     │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DE LA TABLA DE EQUIPOS REGISTRADOS <<        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 5.2 Procedimiento de Alta de Equipo
1. Hacer clic en **"+ Nuevo Equipo"**.
2. Completar las especificaciones físicas y de hardware:
   * **Tipo:** Portátil, PC de Mesa (Torre), All-in-One, etc.
   * **Marca y Modelo:** (Ej: `HP Pavilion 15-dw1024`, `Dell Inspiron 24`).
   * **Número de Serie:** Serial del fabricante (si no posee, marcar como sin serie visible).
   * **Hardware:** Procesador, memoria RAM y capacidad de almacenamiento.
   * **Propietario:** Asociar al cliente registrado previamente.
3. Guardar. El equipo queda enlazado para futuras órdenes de servicio sin necesidad de volver a digitar sus especificaciones.

---

## CAPÍTULO 6: RADICACIÓN DE INCIDENCIAS Y ÓRDENES DE SERVICIO

### 6.1 Asistente de Radicación Paso a Paso
El proceso de radicación se realiza a través de un asistente guiado de 4 pasos para garantizar que no falte información técnica ni legal:

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURAS 6.1 - 6.4: Asistente de 4 Pasos de Creación de Incidencia ] │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURAS DE LOS PASOS 1, 2, 3 Y 4 DEL ASISTENTE <<  │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Paso 1 — Solicitante y Modalidad:**
   * Selección del cliente y tipo de mantenimiento (**Correctivo** o **Preventivo**).
   * Asignación de prioridad (*Baja, Media, Alta, Crítica*).
2. **Paso 2 — Selección del Equipo y Falla:**
   * Selección del equipo desde el inventario del cliente.
   * Descripción clara del problema reportado por el usuario.
3. **Paso 3 — Estado Físico y Accesorios:**
   * Checklist de elementos recibidos (cargador, cables, fundas, adaptadores).
   * Carga de fotografías de recepción para evidenciar rayones, golpes o roturas previas.
4. **Paso 4 — Asignación y Comprobante:**
   * Asignación del **Técnico Responsable**.
   * Generación automática del **Comprobante de Ingreso en PDF** para entrega al cliente.

---

## CAPÍTULO 7: MESA DE TRABAJO Y GESTIÓN TÉCNICA DE TALLER

### 7.1 Panel de Detalle Técnico (Rol Técnico)
Al ingresar con cuenta de **Técnico**, el usuario accede a las órdenes asignadas y presiona **"Gestionar Mantenimiento"**. El panel se divide en 4 pestañas especializadas:

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 7.1: Pestaña OT y Diagnóstico de Taller ]                    │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DE LA PESTAÑA OT CON DIAGNÓSTICO <<          │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

#### A. Pestaña Orden de Trabajo (OT):
* Registro del diagnóstico preliminar de laboratorio.
* Selección de herramientas especializadas utilizadas.
* Estado físico del equipo durante la intervención.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 7.2: Pestaña Bitácora — Procedimientos, Repuestos y Checklists]│
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DE BITÁCORA CON REPUESTO Y CHECKLISTS <<     │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

#### B. Pestaña Bitácora de Actividades:
* Detalle cronológico de los procedimientos técnicos realizados.
* **Carga de Repuestos / Materiales:** Registro de piezas sustituidas con cantidad y costo (Ej: `Pasta térmica Cooler Master - $8.000`).
* **Checklists de Control de Calidad:** Verificación de pruebas térmicas, limpieza y puertos funcionales.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 7.3: Galería Fotográfica de Evidencias (Antes y Después) ]   │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DE LAS FOTOS CARGADAS EN EL TALLER <<        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

#### C. Pestaña Evidencias Fotográficas:
* Registro fotográfico del estado inicial del componente averiado vs el componente reparado o sustituido.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 7.4: Pestaña Acta de Entrega y Cierre Oficial ]              │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DEL ACTA DE ENTREGA Y PDF GENERADO <<        │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

#### D. Pestaña Acta de Entrega y Cierre:
1. Marcación del estado final del equipo (**Operativo**).
2. Recomendaciones de cuidado al usuario.
3. Registro de la persona que recibe a conformidad.
4. Clic en **"Cerrar Incidencia y Generar Acta"**.
5. Clic en **"Ver Documento Oficial"**: Despliega el PDF formal con membrete de Santi Inc, firmas digitales y condiciones de garantía.

---

## CAPÍTULO 8: PANEL ADMINISTRATIVO Y MÉTRICAS DE RENDIMIENTO

### 8.1 Descripción de la Pantalla
El **Dashboard de Administrador** consolida en tiempo real la operación global del taller de soporte.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 8.1: Dashboard Principal con Indicadores SLA y Carga ]       │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DEL DASHBOARD CON LAS ÓRDENES ACTIVAS <<     │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 8.2 Componentes del Tablero
1. **Tarjetas Métricas de SLA:** Porcentaje de tickets resueltos a tiempo según su nivel de prioridad.
2. **Panel de Carga Técnica:** Balance de órdenes asignadas por cada técnico para evitar sobrecargas de trabajo.
3. **Tabla General de Órdenes:** Filtro rápido por estados (*Abierta, En Revisión, Esperando Repuesto, Reparada, Cerrada*).
4. **Módulo de Auditoría:** Historial inmutable con fecha, hora y usuario que ejecutó cada acción en el sistema.

---

## CAPÍTULO 9: PORTAL DE CONSULTA PÚBLICA DE ESTADOS

### 9.1 Descripción y Acceso
Permite a cualquier cliente consultar el avance de su equipo en cualquier momento sin necesidad de contar con usuario o contraseña del sistema.

```
┌────────────────────────────────────────────────────────────────────────┐
│  [ FIGURA 9.1: Formulario de Consulta Pública y Resultado Visual ]     │
│                                                                        │
│  >> INSERTAR AQUÍ CAPTURA DEL BUSCADOR PÚBLICO Y LA LÍNEA DE TIEMPO << │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### 9.2 Instrucciones para el Cliente
1. Ingresar a la pantalla de bienvenida / login de la aplicación.
2. Hacer clic en el enlace inferior **"¿Quieres consultar el estado de tu equipo? Consulta pública"**.
3. Ingresar:
   * **Código de la Orden / Ticket:** (Ej: `TK-2026-0003`).
   * **Documento del Cliente:** Cédula o NIT registrado en la recepción.
4. Presionar **"Consultar"**.
5. La plataforma mostrará una línea de tiempo interactiva con la fase actual del equipo, fecha de ingreso, diagnóstico preliminar y constancia de si está listo para entrega.

---

## 📚 GLOSARIO DE TÉRMINOS
* **OT (Orden de Trabajo):** Documento digital técnico que guía las labores de reparación en el banco de trabajo.
* **SLA (Service Level Agreement):** Acuerdo de nivel de servicio que define el tiempo límite establecido para solucionar una incidencia.
* **Acta de Entrega:** Documento oficial vinculante generado en PDF que certifica la devolución a satisfacción del equipo al cliente.
* **Mantenimiento Correctivo:** Acción técnica destinada a reparar una falla ya presentada en el equipo.
* **Mantenimiento Preventivo:** Rutina periódica de limpieza, revisión y optimización para prevenir fallas futuras.
