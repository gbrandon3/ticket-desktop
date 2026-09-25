# MANUAL DE USUARIO EXHAUSTIVO DEL SISTEMA
## PLATAFORMA INTEGRAL DE GESTIÓN DE TALLER, SOPORTE TÉCNICO E INCIDENCIAS
### Santi Inc — Laboratorio de Mantenimiento de Cómputo y Redes

---

```
  ╔═══════════════════════════════════════════════════════════════════════════════════════════╗
  ║                                                                                           ║
  ║  SERVICIO NACIONAL DE APRENDIZAJE — SENA                                                  ║
  ║  Centro de Tecnologías de la Información y las Comunicaciones                             ║
  ║  Programa de Formación: Técnico / Tecnólogo en Sistemas / ADSO                            ║
  ║  Módulo de Entrega: Documentación Técnica de Software (Manual de Operación de Usuario)   ║
  ║  Sistema: Taller de Mantenimiento y Gestión de Tickets Santi Inc                          ║
  ║  Versión: 1.0.0 Oficial                                                                   ║
  ║                                                                                           ║
  ╚═══════════════════════════════════════════════════════════════════════════════════════════╝
```

---

# ÍNDICE GENERAL DEL MANUAL
1. [Generalidades, Arquitectura de Roles y Flujo de Trabajo](#1-generalidades-arquitectura-de-roles-y-flujo-de-trabajo)
2. [Bloque 1: Configuración Inicial de la Empresa (Setup Wizard)](#bloque-1-configuración-inicial-de-la-empresa-setup-wizard)
   - [1.1 Identidad y Datos Generales de la Empresa](#11-identidad-y-datos-generales-de-la-empresa)
   - [1.2 Parametrización de la Cuenta del Administrador Principal](#12-parametrización-de-la-cuenta-del-administrador-principal)
   - [1.3 Alta de Personal Base (Técnico y Operador)](#13-alta-de-personal-base-técnico-y-operador)
3. [Bloque 2: Módulo de Autenticación y Control de Acceso (Login)](#bloque-2-módulo-de-autenticación-y-control-de-acceso-login)
4. [Bloque 3: Módulo de Gestión y Administración de Clientes](#bloque-3-módulo-de-gestión-y-administración-de-clientes)
   - [3.1 Formulario de Registro de Nuevo Cliente](#31-formulario-de-registro-de-nuevo-cliente)
   - [3.2 Directorio Centralizado y Consulta de Clientes](#32-directorio-centralizado-y-consulta-de-clientes)
5. [Bloque 4: Inventario Técnico y Hojas de Vida de Equipos](#bloque-4-inventario-técnico-y-hojas-de-vida-de-equipos)
   - [4.1 Formulario de Ficha Técnica de Equipos](#41-formulario-de-ficha-técnica-de-equipos)
   - [4.2 Directorio General de Inventario](#42-directorio-general-de-inventario)
   - [4.3 Modal de Hoja de Vida y Trazabilidad Histórica](#43-modal-de-hoja-de-vida-y-trazabilidad-histórica)
6. [Bloque 5: Radicación de Incidencias Correctivas (Asistente de 4 Pasos)](#bloque-5-radicación-de-incidencias-correctivas-asistente-de-4-pasos)
   - [5.1 Paso 1: Solicitante, Categoría y Prioridad](#51-paso-1-solicitante-categoría-y-prioridad)
   - [5.2 Paso 2: Asociación de Equipo y Síntomas de la Falla](#52-paso-2-asociación-de-equipo-y-síntomas-de-la-falla)
   - [5.3 Paso 3: Inspección Física, Accesorios y Evidencia Fotográfica](#53-paso-3-inspección-física-accesorios-y-evidencia-fotográfica)
   - [5.4 Paso 4: Resumen, Asignación de Técnico y Emisión de Orden](#54-paso-4-resumen-asignación-de-técnico-y-emisión-de-orden)
7. [Bloque 6: Radicación de Incidencias Preventivas (Mantenimiento Programado)](#bloque-6-radicación-de-incidencias-preventivas-mantenimiento-programado)
8. [Bloque 7: Mesa de Trabajo y Gestión Técnica de Taller (Rol Técnico)](#bloque-7-mesa-de-trabajo-y-gestión-técnica-de-taller-rol-técnico)
   - [7.1 Bandeja de Órdenes Asignadas al Técnico](#71-bandeja-de-órdenes-asignadas-al-técnico)
   - [7.2 Pestaña 1: Orden de Trabajo (OT) y Diagnóstico](#72-pestaña-1-orden-de-trabajo-ot-y-diagnóstico)
   - [7.3 Pestaña 2: Bitácora de Actividades y Consumo de Repuestos](#73-pestaña-2-bitácora-de-actividades-y-consumo-de-repuestos)
   - [7.4 Protocolo de Pruebas y Checklists de Control de Calidad](#74-protocolo-de-pruebas-y-checklists-de-control-de-calidad)
   - [7.5 Pestaña 3: Galería de Evidencias Fotográficas (Antes y Después)](#75-pestaña-3-galería-de-evidencias-fotográficas-antes-y-después)
   - [7.6 Pestaña 4: Acta de Entrega, Garantía y Cierre de Servicio](#76-pestaña-4-acta-de-entrega-garantía-y-cierre-de-servicio)
   - [7.7 Visor del Documento Oficial de Entrega en PDF](#77-visor-del-documento-oficial-de-entrega-en-pdf)
9. [Bloque 8: Panel Administrativo y Métricas Operativas (Dashboard Admin)](#bloque-8-panel-administrativo-y-métricas-operativas-dashboard-admin)
   - [8.1 Tarjetas de Cumplimiento de Acuerdos de Nivel de Servicio (SLA)](#81-tarjetas-de-cumplimiento-de-acuerdos-de-nivel-de-servicio-sla)
   - [8.2 Distribución y Balance de Carga Técnica](#82-distribución-y-balance-de-carga-técnica)
   - [8.3 Matriz Multi-Estado de Órdenes de Trabajo](#83-matriz-multi-estado-de-órdenes-de-trabajo)
10. [Bloque 9: Módulo de Configuración Integral del Sistema](#bloque-9-módulo-de-configuración-integral-del-sistema)
    - [9.1 Pestaña de Perfil y Credenciales de Usuario](#91-pestaña-de-perfil-y-credenciales-de-usuario)
    - [9.2 Pestaña de Identidad Corporativa y Marca](#92-pestaña-de-identidad-corporativa-y-marca)
    - [9.3 Pestaña de Gestión y Control de Roles de Usuario](#93-pestaña-de-gestión-y-control-de-roles-de-usuario)
    - [9.4 Pestaña de Parámetros del Servidor de Correo Saliente (SMTP)](#94-pestaña-de-parámetros-del-servidor-de-correo-saliente-smtp)
11. [Bloque 10: Portal de Consulta Pública de Estados (Acceso Sin Login)](#bloque-10-portal-de-consulta-pública-de-estados-acceso-sin-login)
12. [Tabla Maestra de Referencia Cruzada de Figuras](#tabla-maestra-de-referencia-cruzada-de-figuras)
13. [Glosario de Términos](#glosario-de-términos)

---

# 1. GENERALIDADES, ARQUITECTURA DE ROLES Y FLUJO DE TRABAJO

### 1.1 Introducción
La plataforma **Santi Inc** es un sistema de información diseñado para la gestión integral de órdenes de servicio técnico, trazabilidad de hardware y control de garantías en talleres de cómputo. Su arquitectura garantiza que ninguna orden de mantenimiento sea ejecutada sin un registro fotográfico de recepción, un diagnóstico técnico sustentado, un control de repuestos consumidos y una constancia formal de entrega.

### 1.2 Estructura y Responsabilidad por Roles
El sistema delimita estrictamente las funciones operativas en tres perfiles:

```
┌─────────────────────────┬─────────────────────────────────────────────────────────────────────────┐
│ ROL                     │ RESPONSABILIDADES Y PRIVILEGIOS                                         │
├─────────────────────────┼─────────────────────────────────────────────────────────────────────────┤
│ Administrador (admin)   │ Configuración global, alta/baja de usuarios, supervisión de SLA,        │
│                         │ consulta de auditoría inmutable y modificación de identidad de empresa. │
├─────────────────────────┼─────────────────────────────────────────────────────────────────────────┤
│ Operador (operador)     │ Recepción en ventanilla, registro de nuevos clientes, inventario físico │
│                         │ de equipos, radicación de órdenes y entrega de equipos al cliente.     │
├─────────────────────────┼─────────────────────────────────────────────────────────────────────────┤
│ Técnico (tecnico)       │ Diagnóstico en mesa de taller, registro de procedimientos en bitácora,  │
│                         │ cargo de insumos/repuestos, ejecución de checklists y cierre técnico.   │
└─────────────────────────┴─────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Ciclo de Vida del Servicio
```
 [ 1. RECEPCIÓN ]          [ 2. ASIGNACIÓN ]          [ 3. TALLER ]             [ 4. CIERRE ]
   (Operador)               (Sistema/Admin)             (Técnico)                (Operador)
 ┌──────────────┐          ┌──────────────┐          ┌──────────────┐          ┌──────────────┐
 │ • Datos      │          │ • Cola de    │          │ • OT y Diag. │          │ • Firma      │
 │ • Fotos      │ ───────► │   Trabajo    │ ───────► │ • Bitácora   │ ───────► │ • Acta PDF   │
 │ • Accesorios │          │ • Prioridad  │          │ • Repuestos  │          │ • Garantía   │
 └──────────────┘          └──────────────┘          └──────────────┘          └──────────────┘
```

---

# BLOQUE 1: CONFIGURACIÓN INICIAL DE LA EMPRESA (SETUP WIZARD)

El asistente de puesta en marcha se despliega de forma exclusiva la primera vez que se ejecuta la aplicación cuando la base de datos se encuentra completamente vacía. Su objetivo es recolectar los datos fundacionales del taller para parametrizar los reportes contables y el usuario administrador raíz.

---

### 1.1 Identidad y Datos Generales de la Empresa

#### Propósito:
Registrar los datos jurídicos y comerciales de **Santi Inc**, los cuales encabezarán todos los documentos en PDF que emita el software.

#### Descripción de Campos y Controles:
| Control / Campo | Tipo de Dato | Obligatorio | Validación / Regla | Valor de Ejemplo |
| :--- | :--- | :---: | :--- | :--- |
| **Nombre de la Empresa** | Texto | SÍ | Mínimo 3 caracteres, alfanumérico | `Santi Inc - Taller de Soporte Técnico` |
| **Lema / Slogan** | Texto | NO | Texto descriptivo de la actividad | `Servicio Técnico y Mantenimiento Especializado` |
| **NIT / Identificación** | Alfanumérico | SÍ | Formato tributario estándar | `901876543-2` |
| **Correo Electrónico** | Email | SÍ | Sintaxis estándar con `@` y dominio | `taller@santi-inc.com` |
| **Teléfono de Contacto** | Numérico | SÍ | 7 a 10 dígitos | `3109876543` |
| **Dirección de Sede** | Texto | SÍ | Ubicación física del taller | `Cra. 45 # 12 - 34, Laboratorio de Cómputo` |

#### Procedimiento de Operación:
1. Iniciar el ejecutable de la aplicación. El sistema detecta la ausencia de registros e inicializa en la pantalla `SetupWizardScreen`.
2. En la sección **Datos de la Empresa**, digitar exactamente los datos del cuadro anterior.
3. Verificar que no queden campos obligatorios en rojo.
4. **Tomar la captura de pantalla antes de pasar al siguiente apartado**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `01_setup_empresa.png`]**  
> *Figura 1: Sección 1 del Asistente de Configuración Inicial con la información institucional de Santi Inc diligenciada.*

---

### 1.2 Parametrización de la Cuenta del Administrador Principal

#### Propósito:
Crear el primer usuario con credenciales de superusuario para administrar el taller y gestionar los accesos.

#### Descripción de Campos y Controles:
| Control / Campo | Tipo de Dato | Obligatorio | Validación / Regla | Valor de Ejemplo |
| :--- | :--- | :---: | :--- | :--- |
| **Nombre Completo** | Texto | SÍ | Nombre y apellidos del aprendiz admin | *(Tu Nombre Completo)* |
| **Cédula / Documento** | Numérico | SÍ | Documento de identidad | `1020345678` |
| **Correo Administrativo**| Email | SÍ | Será el usuario de acceso | `admin@santi.com` |
| **Contraseña** | Clave | SÍ | Mínimo 6 caracteres | `Admin1234*` |

#### Procedimiento de Operación:
1. Desplazarse a la sección **Cuenta del Administrador** dentro del mismo asistente.
2. Ingresar el nombre, documento, correo institucional y contraseña de acceso.
3. Comprobar que los datos coincidan con las credenciales que se utilizarán durante las prácticas.

> 📷 **[INSERTAR AQUÍ IMAGEN: `02_setup_admin.png`]**  
> *Figura 2: Sección 2 del Asistente Inicial con la creación de la cuenta administrativa.*

---

### 1.3 Alta de Personal Base (Técnico y Operador)

#### Propósito:
Permitir que el taller inicie su operación de inmediato habilitando los puestos de trabajo para el área técnica y el área de recepción de clientes.

#### Descripción de Campos y Controles:
* **Interruptor "Crear Técnico":** Al activarse, despliega los campos para el técnico:
  * *Nombre:* `Carlos Técnico` | *Cédula:* `987654321` | *Correo:* `tecnico@santi.com`
* **Interruptor "Crear Operador":** Al activarse, despliega los campos para el operador:
  * *Nombre:* `Laura Operadora` | *Cédula:* `112233445` | *Correo:* `operador@santi.com`
* **Botón "Completar Configuración":** Valida todos los formularios del wizard, guarda la información en SQLite y realiza el inicio de sesión automático.

#### Procedimiento de Operación:
1. Activar los switches de creación de personal inicial.
2. Ingresar la información de los compañeros de equipo en sus respectivos bloques.
3. Tomar la captura de la pantalla mostrando ambos bloques activos.
4. Presionar el botón azul **"Completar Configuración"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `03_setup_personal.png`]**  
> *Figura 3: Sección 3 del Asistente Inicial con el personal técnico y operativo configurado.*

---

# BLOQUE 2: MÓDULO DE AUTENTICACIÓN Y CONTROL DE ACCESO (LOGIN)

### Propósito:
Controlar el acceso a los diferentes módulos de la aplicación, restringiendo las operaciones no autorizadas y validando la identidad del usuario contra la base de datos local cifrada.

```
┌────────────────────────────────────────────────────────────────────────┐
│  PANTALLA DE ACCESO AL SISTEMA (LOGIN)                                 │
│                                                                        │
│  [ Logotipo Santi Inc ]                                                │
│  Correo Electrónico: [_________________________]                       │
│  Contraseña:         [_________________________] [👁️]                  │
│                                                                        │
│  [ BOTÓN: INICIAR SESIÓN ]                                             │
│                                                                        │
│  🔗 ¿Quieres consultar el estado de tu equipo? Consulta pública       │
└────────────────────────────────────────────────────────────────────────┘
```

#### Descripción de Campos y Controles:
* **Campo Correo Electrónico:** Input de texto con validación de sintaxis de email.
* **Campo Contraseña:** Input de texto protegido con botón para alternar visibilidad.
* **Botón "Iniciar Sesión":** Ejecuta la autenticación y redirige al dashboard según el rol detectado.
* **Enlace "¿Quieres consultar el estado de tu equipo? Consulta pública":** Redirige a la pantalla pública para clientes sin requerir credenciales.

#### Procedimiento de Operación:
1. Si se encuentra dentro del sistema, hacer clic en el botón de cerrar sesión en la esquina superior derecha.
2. En la pantalla de login, verificar que el nombre de la empresa "Santi Inc" sea visible en el encabezado.
3. Dejar los campos limpios o con el correo a autenticar y tomar la captura.

> 📷 **[INSERTAR AQUÍ IMAGEN: `04_login.png`]**  
> *Figura 4: Pantalla de inicio de sesión del sistema con identidad de Santi Inc y acceso a consulta pública.*

---

# BLOQUE 3: MÓDULO DE GESTIÓN Y ADMINISTRACIÓN DE CLIENTES

El módulo de clientes mantiene centralizada la información de los usuarios que poseen contratos o solicitan servicios de reparación, permitiendo un histórico claro de intervenciones.

---

### 3.1 Formulario de Registro de Nuevo Cliente

#### Propósito:
Dar de alta en la base de datos a un nuevo cliente para asociarle posteriormente órdenes de trabajo o equipos en inventario.

#### Procedimiento de Operación:
1. Iniciar sesión con la cuenta de **Administrador** (`admin@santi.com`).
2. Dirigirse al menú de navegación y hacer clic en **Clientes** (o presionar el botón `+ Nuevo Cliente` dentro del paso 1 de radicación).
3. Diligenciar el formulario con el primer cliente propuesto:
   * **Tipo de Documento:** Seleccionar `Cédula de Ciudadanía`.
   * **Número de Documento:** `1020111222`.
   * **Nombre Completo:** `María García López`.
   * **Correo Electrónico:** `maria.garcia@correo.com`.
   * **Teléfono:** `3109876543`.
   * **Dirección / Ubicación:** `Sala de Sistemas - Piso 2`.
4. Tomar la captura del formulario diligenciado antes de presionar guardar.
5. Hacer clic en **"Guardar Cliente"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `05_cliente_nuevo.png`]**  
> *Figura 5: Formulario de creación de cliente con la información de María García López.*

---

### 3.2 Directorio Centralizado y Consulta de Clientes

#### Propósito:
Consultar la base de datos de clientes, verificar sus canales de notificación y administrar su información.

#### Procedimiento de Operación:
1. Repetir el proceso de registro para los otros dos clientes:
   * **Cliente 2:** Cédula: `98765432` | Nombre: `Carlos Pérez Rodríguez` | Correo: `carlos.perez@correo.com` | Teléfono: `3205554433` | Ubicación: `Rectoría - Piso 3`.
   * **Cliente 3:** NIT: `900123456-1` | Nombre: `Empresa XYZ S.A.S` | Correo: `contacto@xyz.com` | Teléfono: `6017001234` | Ubicación: `Calle 80 #20-30, Bogotá`.
2. Dirigirse a la tabla de clientes y comprobar que los tres registros se visualicen correctamente.

> 📷 **[INSERTAR AQUÍ IMAGEN: `06_clientes_tabla.png`]**  
> *Figura 6: Directorio centralizado mostrando la tabla con los 3 clientes de prueba registrados.*

---

# BLOQUE 4: INVENTARIO TÉCNICO Y HOJAS DE VIDA DE EQUIPOS

Este módulo actúa como el expediente técnico de los activos de hardware atendidos en el taller, permitiendo conocer su configuración interna y su historial de fallas.

---

### 4.1 Formulario de Ficha Técnica de Equipos

#### Propósito:
Registrar la configuración física y componentes internos de un equipo de cómputo para asociarlo a su propietario.

#### Descripción de Campos Técnicos:
* **Tipo de Equipo:** Selector desplegable (Portátil, PC de Mesa, All-in-One, Servidor).
* **Marca y Modelo:** Fabricante y referencia comercial exacta.
* **Número de Serie:** Código alfanumérico único grabado en el chasis.
* **Especificaciones:** Sistema Operativo, Procesador, Memoria RAM y Capacidad de Almacenamiento.
* **Propietario:** Selector enlazado a la base de clientes.

#### Procedimiento de Operación:
1. En el menú de navegación, hacer clic en **Inventario de Equipos**.
2. Presionar el botón superior **"+ Nuevo Equipo"**.
3. Diligenciar los campos para el **Portátil HP**:
   * *Tipo:* `Portátil` | *Marca:* `HP` | *Modelo:* `EliteBook 840 G8`.
   * *Serie:* `HP-ELITE-840-001` | *Ubicación:* `Sala de Sistemas`.
   * *SO:* `Windows 11` | *CPU:* `Intel Core i7` | *RAM:* `16GB` | *Almacenamiento:* `SSD 512GB`.
   * *Cliente:* `María García López`.
4. Tomar la captura del formulario diligenciado y hacer clic en **"Guardar Equipo"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `07_equipo_portatil.png`]**  
> *Figura 7: Formulario de registro de equipo portátil en inventario con ficha técnica completa.*

---

### 4.2 Directorio General de Inventario

#### Propósito:
Permitir a los operadores y técnicos buscar cualquier equipo por serial, marca o propietario.

#### Procedimiento de Operación:
1. Registrar los dos equipos restantes:
   * **Equipo 2 (PC de Mesa):** Serie: *(automático / dejar vacío)* | Nombre: `CPU Contabilidad` | Tipo: `PC de Mesa` | RAM: `8GB` | Disco: `HDD 1TB` | Propietario: `Empresa XYZ S.A.S`.
   * **Equipo 3 (All-in-One):** Serie: `DELL-AIO-3280-005` | Nombre: `OptiPlex 3280` | Tipo: `All-in-One` | RAM: `8GB` | Propietario: `Carlos Pérez Rodríguez`.
2. Visualizar la tabla de inventario donde aparezcan los tres activos de hardware.

> 📷 **[INSERTAR AQUÍ IMAGEN: `08_inventario_tabla.png`]**  
> *Figura 8: Tabla de inventario general consolidando los tres tipos de equipos registrados.*

---

### 4.3 Modal de Hoja de Vida y Trazabilidad Histórica

#### Propósito:
Consultar la hoja de vida de un activo específico con el historial de mantenimientos recibidos en el taller.

#### Procedimiento de Operación:
1. En la fila del `Portátil HP (HP-ELITE-840-001)`, hacer clic en el botón de opciones o en **"Hoja de Vida"**.
2. El sistema desplegará un modal emergente con las características técnicas y la sección de historial de servicios.

> 📷 **[INSERTAR AQUÍ IMAGEN: `09_hoja_de_vida.png`]**  
> *Figura 9: Ventana modal de la Hoja de Vida Técnica del equipo portátil HP.*

---

# BLOQUE 5: RADICACIÓN DE INCIDENCIAS CORRECTIVAS (ASISTENTE DE 4 PASOS)

El módulo de radicación cuenta con un asistente interactivo tipo *stepper* de 4 pasos que guía al operador para levantar toda la información técnica y física necesaria antes de ingresar el equipo al taller.

---

### 5.1 Paso 1: Solicitante, Categoría y Prioridad

#### Propósito:
Identificar al solicitante, definir el nivel de urgencia y seleccionar el tipo de mantenimiento.

#### Procedimiento de Operación:
1. En el menú principal, hacer clic en **"Radicar / Crear Incidencia"**.
2. En el **Paso 1**:
   * *Cliente:* Seleccionar a `María García López`.
   * *Modalidad:* Seleccionar botón **Correctivo**.
   * *Categoría:* Seleccionar `Hardware`.
   * *Título del Ticket:* Escribir `Falla pantalla`.
   * *Prioridad:* Marcar `Alta` (por tratarse de un equipo de trabajo principal).
3. Tomar la captura correspondiente al Paso 1 y presionar **"Siguiente"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `10_radicar_paso1.png`]**  
> *Figura 10: Paso 1 del asistente de radicación con selección de cliente, naturaleza correctiva y prioridad alta.*

---

### 5.2 Paso 2: Asociación de Equipo y Síntomas de la Falla

#### Propósito:
Vincular el equipo específico del inventario del cliente y detallar la sintomatología manifestada por el usuario.

#### Procedimiento de Operación:
1. En el **Paso 2**:
   * *Equipo:* Seleccionar el `Portátil HP EliteBook 840 G8 (HP-ELITE-840-001)`.
   * *Descripción Detallada:* Escribir: `El usuario manifiesta que al presionar el botón de encendido las luces y ventiladores operan normalmente, pero el panel LCD permanece completamente negro sin retroiluminación ni imagen.`
2. Tomar la captura y presionar **"Siguiente"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `11_radicar_paso2.png`]**  
> *Figura 11: Paso 2 del asistente con selección de la máquina y descripción del problema manifestado.*

---

### 5.3 Paso 3: Inspección Física, Accesorios y Evidencia Fotográfica

#### Propósito:
Dejar constancia pericial del estado cosmético de la máquina y los accesorios que quedan bajo custodia del taller para prevenir reclamos infundados.

#### Procedimiento de Operación:
1. En el **Paso 3**:
   * Marcar casillas de accesorios: `[X] Cargador original con cable de poder`, `[X] Estuche / Funda de transporte`.
   * Subir una fotografía de ingreso que muestre el equipo en recepción.
2. Tomar la captura mostrando las casillas marcadas y la foto previsualizada.
3. Presionar **"Siguiente"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `12_radicar_paso3.png`]**  
> *Figura 12: Paso 3 del asistente evidenciando accesorios recibidos y fotografía de recepción.*

---

### 5.4 Paso 4: Resumen, Asignación de Técnico y Emisión de Orden

#### Propósito:
Revisar el resumen consolidado de la orden y asignar al especialista que se encargará del banco de trabajo.

#### Procedimiento de Operación:
1. En el **Paso 4**:
   * *Técnico Asignado:* Seleccionar en el desplegable a `Carlos Técnico`.
   * Verificar en el panel lateral el resumen de datos del cliente, equipo y prioridad.
2. Tomar la captura previa a la creación formal.
3. Hacer clic en el botón verde **"Crear y Radicar Incidencia"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `13_radicar_paso4.png`]**  
> *Figura 13: Paso 4 del asistente con el resumen global de la orden y asignación al técnico.*

---

# BLOQUE 6: RADICACIÓN DE INCIDENCIAS PREVENTIVAS (MANTENIMIENTO PROGRAMADO)

### Propósito:
Evidenciar la capacidad adaptativa del formulario cuando se trata de una rutina periódica de mantenimiento que no obedece a una avería puntual.

#### Procedimiento de Operación:
1. Iniciar un nuevo proceso de radicación desde el botón **"Radicar / Crear Incidencia"**.
2. Seleccionar como cliente a `Carlos Pérez Rodríguez`.
3. En el tipo de servicio, hacer clic sobre la opción **Preventivo**.
4. Notar cómo la interfaz oculta los campos de falla crítica y despliega un banner o texto automático con la rutina de mantenimiento preventivo.
5. Tomar la captura de pantalla destacando esta variación visual.

> 📷 **[INSERTAR AQUÍ IMAGEN: `14_radicar_preventivo.png`]**  
> *Figura 14: Formulario de radicación preventiva con adaptación dinámica para rutinas de inspección.*

---

# BLOQUE 7: MESA DE TRABAJO Y GESTIÓN TÉCNICA DE TALLER (ROL TÉCNICO)

En este bloque se describe el flujo completo de intervención en taller, desde el diagnóstico hasta el cierre formal mediante acta de entrega.

---

### 7.1 Bandeja de Órdenes Asignadas al Técnico

#### Propósito:
Permitir que el técnico consulte su carga de trabajo diaria y acceda a las órdenes que tiene bajo su responsabilidad.

#### Procedimiento de Operación:
1. Cerrar sesión de Administrador/Operador.
2. Iniciar sesión con la cuenta de técnico: `tecnico@santi.com` | Clave: `Tecnico123*`.
3. El sistema carga automáticamente el dashboard de taller mostrando las órdenes pendientes.
4. Ubicar la orden recién creada para el Portátil HP de María García.

> 📷 **[INSERTAR AQUÍ IMAGEN: `15_dashboard_tecnico.png`]**  
> *Figura 15: Bandeja de entrada del Técnico con las órdenes de trabajo asignadas a su nombre.*

---

### 7.2 Pestaña 1: Orden de Trabajo (OT) y Diagnóstico

#### Propósito:
Registrar la hipótesis técnica y los instrumentos de banco necesarios tras la apertura e inspección física del equipo.

#### Procedimiento de Operación:
1. En la orden seleccionada, hacer clic en el botón azul **"Gestionar Mantenimiento"**.
2. En la pestaña **OT (Orden de Trabajo)**:
   * *Diagnóstico Preliminar:* Escribir: `Se realiza desarme de panel superior y medición de líneas de voltaje en el conector LVDS/eDP. Se detectan 19V presentes pero línea de backlight abierta en el circuito impreso del panel LCD. Panel defectuoso que requiere sustitución.`
   * *Herramientas:* Marcar `Multímetro digital`, `Kit de destornilladores de precisión`, `Pinzas antiestáticas`.
   * *Estado Físico:* `Chasis en buen estado general con desgaste normal por uso.`
3. Presionar el botón **"Guardar Cambios de OT"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `16_orden_trabajo.png`]**  
> *Figura 16: Pestaña OT con diagnóstico técnico detallado y herramientas de laboratorio registradas.*

---

### 7.3 Pestaña 2: Bitácora de Actividades y Consumo de Repuestos

#### Propósito:
Llevar la bitácora minuciosa de los procedimientos ejecutados y asentar el costo de los repuestos consumidos con impacto en la liquidación final.

#### Procedimiento de Operación:
1. Hacer clic en la pestaña **Bitácora**.
2. En el área de texto de **Procedimientos Realizados**, registrar:
   * `1. Desconexión de batería interna y descarga residual de capacitores.`
   * `2. Desmontaje del marco de pantalla y extracción de panel dañado.`
   * `3. Instalación de nuevo panel LCD 14.0" FHD IPS mate.`
   * `4. Conexión segura de arnés de video eDP y aislamiento térmico.`
   * `5. Encendido de prueba y verificación de brillo y balance de color.`
3. En la sección **Repuestos Utilizados**, hacer clic en **"+ Agregar Repuesto"**:
   * *Descripción:* `Pantalla LCD 14.0" FHD IPS` | *Cantidad:* `1` | *Costo Unitario:* `$180.000`.
   * Guardar el repuesto para que se sume al balance de la orden.

> 📷 **[INSERTAR AQUÍ IMAGEN: `17_bitacora_repuestos.png`]**  
> *Figura 17: Pestaña Bitácora con actividades cronológicas y repuesto LCD de $180.000 cargado a la orden.*

---

### 7.4 Protocolo de Pruebas y Checklists de Control de Calidad

#### Propósito:
Garantizar que el equipo reparado no abandone el taller sin superar pruebas estrictas de funcionalidad.

#### Procedimiento de Operación:
1. En la misma pestaña de Bitácora, desplazarse hacia la sección de **Control de Calidad**.
2. Marcar las casillas correspondientes:
   * `[X] Prueba de video y ajuste de brillo superada`.
   * `[X] Ensamblaje y sujeción de bisagras verificado`.
   * `[X] Limpieza externa de pantalla y teclado realizada`.
3. Presionar **"Guardar Bitácora"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `18_pruebas_calidad.png`]**  
> *Figura 18: Lista de chequeo de pruebas de control de calidad y validación funcional completadas.*

---

### 7.5 Pestaña 3: Galería de Evidencias Fotográficas (Antes y Después)

#### Propósito:
Garantizar la transparencia técnica mostrando fotográficamente el componente defectuoso frente al componente nuevo instalado.

#### Procedimiento de Operación:
1. Desplazarse a la pestaña **Fotos / Evidencias**.
2. En la sección **Fotos de Ingreso (Antes)**, subir la imagen del panel roto o apagado.
3. Tomar la captura `19_fotos_ingreso.png`.
4. En la sección **Fotos del Proceso (Después)**, subir la imagen del equipo encendido y reparado.
5. Tomar la captura `20_fotos_proceso.png`.

> 📷 **[INSERTAR AQUÍ IMAGEN: `19_fotos_ingreso.png`]**  
> *Figura 19: Pestaña Fotos — Registro visual del estado de daño previo a la intervención.*

> 📷 **[INSERTAR AQUÍ IMAGEN: `20_fotos_proceso.png`]**  
> *Figura 20: Pestaña Fotos — Registro visual del equipo completamente operativo tras la reparación.*

---

### 7.6 Pestaña 4: Acta de Entrega, Garantía y Cierre de Servicio

#### Propósito:
Formalizar el dictamen técnico final, fijar el periodo de garantía legal y asentar la entrega conforme al cliente.

#### Procedimiento de Operación:
1. Dirigirse a la pestaña **Acta de Entrega**.
2. Configurar los campos de cierre:
   * *Estado Final del Equipo:* Seleccionar **Operativo**.
   * *Garantía Otorgada:* `30 días sobre el repuesto instalado`.
   * *Recomendaciones Técnicas:* `Evitar cerrar la tapa sujetándola por una sola esquina. No limpiar el panel con líquidos corrosivos; utilizar únicamente paño de microfibra seco.`
   * *Receptor Conforme:* `María García López`.
   * Marcar la casilla `[X] El cliente manifiesta su total conformidad con la reparación y entrega del equipo`.
3. Tomar la captura del formulario listo.
4. Presionar el botón verde **"Cerrar Incidencia y Generar Acta"**.

> 📷 **[INSERTAR AQUÍ IMAGEN: `21_acta_entrega.png`]**  
> *Figura 21: Formulario de cierre técnico y preparación del acta de entrega con cláusula de garantía.*

---

### 7.7 Visor del Documento Oficial de Entrega en PDF

#### Propósito:
Emitir el acta legal vinculante en formato PDF estándar que respalda la transacción y sirve de comprobante para el cliente.

#### Procedimiento de Operación:
1. Tras cerrar la orden, hacer clic en el botón azul **"Ver Documento Oficial"**.
2. El sistema despliega el visor del documento PDF con membrete corporativo, firmas digitales, desglose de costos y código de barras.

> 📷 **[INSERTAR AQUÍ IMAGEN: `22_documento_oficial.png`]**  
> *Figura 22: Documento Oficial de Entrega en formato PDF generado por el sistema con firmas y garantías.*

---

# BLOQUE 8: PANEL ADMINISTRATIVO Y MÉTRICAS OPERATIVAS (DASHBOARD ADMIN)

Este módulo provee al Administrador una torre de control analítica para evaluar la productividad del taller y la salud operativa del negocio.

---

### 8.1 Tarjetas de Cumplimiento de Acuerdos de Nivel de Servicio (SLA)

#### Propósito:
Medir en tiempo real el porcentaje de tickets que se resolvieron antes del vencimiento del tiempo límite contractual.

#### Procedimiento de Operación:
1. Cerrar sesión de Técnico e iniciar sesión como **Administrador** (`admin@santi.com`).
2. En la pantalla principal (**Dashboard**), observar las tarjetas métricas superiores con los porcentajes de cumplimiento de SLA para prioridades Alta, Media y Baja.

> 📷 **[INSERTAR AQUÍ IMAGEN: `23_dashboard_admin_sla.png`]**  
> *Figura 23: Dashboard Administrativo — Tarjetas de indicadores de cumplimiento de acuerdos de nivel de servicio (SLA).*

---

### 8.2 Distribución y Balance de Carga Técnica

#### Propósito:
Supervisar el reparto equitativo del trabajo entre los técnicos para prevenir demoras o sobrecargas operativas.

#### Procedimiento de Operación:
1. Desplazarse en el Dashboard al panel **Carga Técnica**.
2. Observar la gráfica y los contadores que indican cuántas órdenes abiertas, en proceso o finalizadas tiene asignadas `Carlos Técnico`.

> 📷 **[INSERTAR AQUÍ IMAGEN: `24_dashboard_tecnicos.png`]**  
> *Figura 24: Panel de carga técnica mostrando la cantidad de órdenes asignadas por especialista.*

---

### 8.3 Matriz Multi-Estado de Órdenes de Trabajo

#### Propósito:
Monitorear de forma global la ubicación y el estado de todos los equipos presentes en las instalaciones del taller.

#### Procedimiento de Operación:
1. Visualizar la tabla principal de incidencias del Dashboard.
2. Comprobar que coexistan tickets en diferentes estados operativos (*Abierta*, *En Diagnóstico*, *Esperando Repuesto*, *Reparado / Cerrado*).

> 📷 **[INSERTAR AQUÍ IMAGEN: `25_dashboard_tabla.png`]**  
> *Figura 25: Tabla general de incidencias del taller mostrando órdenes en diferentes fases de atención.*

---

# BLOQUE 9: MÓDULO DE CONFIGURACIÓN INTEGRAL DEL SISTEMA

Ubicado en la ruta **Configuración**, este módulo administra los parámetros estructurales de la plataforma mediante 4 pestañas especializadas.

---

### 9.1 Pestaña de Perfil y Credenciales de Usuario
Permite al usuario autenticado actualizar su nombre, correo y contraseña de acceso al sistema.

> 📷 **[INSERTAR AQUÍ IMAGEN: `26_config_perfil.png`]**  
> *Figura 26: Pestaña de Configuración — Perfil de usuario y seguridad de cuenta.*

---

### 9.2 Pestaña de Identidad Corporativa y Marca
Permite modificar los datos que encabezan los documentos legales (Razón Social, NIT, teléfono, dirección física y logotipo corporativo).

> 📷 **[INSERTAR AQUÍ IMAGEN: `27_config_identidad.png`]**  
> *Figura 27: Pestaña de Configuración — Datos de identidad corporativa y marca de Santi Inc.*

---

### 9.3 Pestaña de Gestión y Control de Roles de Usuario
Permite al Administrador dar de alta nuevo personal, restablecer contraseñas o modificar los roles asignados (`admin`, `tecnico`, `operador`).

> 📷 **[INSERTAR AQUÍ IMAGEN: `28_config_usuarios.png`]**  
> *Figura 28: Pestaña de Configuración — Administración de usuarios y asignación de roles.*

---

### 9.4 Pestaña de Parámetros del Servidor de Correo Saliente (SMTP)
Configuración de las credenciales del servidor de mensajería (servidor, puerto, usuario y contraseña de aplicación) para el despacho automático de correos a los clientes cuando su orden avance de fase.

> 📷 **[INSERTAR AQUÍ IMAGEN: `29_config_smtp.png`]**  
> *Figura 29: Pestaña de Configuración — Parametrización del servidor de correo saliente SMTP.*

---

# BLOQUE 10: PORTAL DE CONSULTA PÚBLICA DE ESTADOS (ACCESO SIN LOGIN)

### Propósito:
Brindar a los clientes finales la posibilidad de conocer el estado de su equipo en cualquier momento desde su celular o navegador web, sin requerir usuario ni exponer información interna del taller.

#### Procedimiento de Operación:
1. Cerrar sesión completamente para situarse en la pantalla de Login.
2. Hacer clic en el enlace inferior **"¿Quieres consultar el estado de tu equipo? Consulta pública"**.
3. En el formulario de búsqueda pública ingresar:
   * **Código de Ticket:** Digitar el código de la orden cerrada (Ej: `TICK-0001` o el código generado).
   * **Número de Documento del Cliente:** `1020111222` (Cédula de María García).
4. Presionar el botón **"Buscar / Consultar Estado"**.
5. El sistema despliega la línea de tiempo visual con todas las etapas cumplidas: fecha de recepción, diagnóstico emitido, repuestos aplicados y estado final de entrega.

> 📷 **[INSERTAR AQUÍ IMAGEN: `30_consulta_publica.png`]**  
> *Figura 30: Resultado de la consulta pública con la línea de tiempo interactiva del servicio prestado.*

---

# TABLA MAESTRA DE REFERENCIA CRUZADA DE FIGURAS

Esta matriz permite validar que todas las capturas de pantalla tomadas correspondan exactamente al archivo y descripción del manual:

| # | Archivo de Imagen Requerido | Descripción de la Interfaz a Mostrar |
| :-: | :--- | :--- |
| **01** | `01_setup_empresa.png` | Wizard — Datos de empresa diligenciados con NIT y dirección |
| **02** | `02_setup_admin.png` | Wizard — Cuenta de administrador principal con credenciales |
| **03** | `03_setup_personal.png` | Wizard — Personal inicial con interruptores de técnico y operador activos |
| **04** | `04_login.png` | Pantalla de inicio de sesión con identidad visual de Santi Inc |
| **05** | `05_cliente_nuevo.png` | Formulario de captura de cliente diligenciado con datos de María García |
| **06** | `06_clientes_tabla.png` | Directorio de clientes con los 3 registros creados visibles |
| **07** | `07_equipo_portatil.png` | Formulario de inventario diligenciado con ficha técnica de Portátil HP |
| **08** | `08_inventario_tabla.png` | Directorio general de inventario mostrando Portátil, PC y All-in-One |
| **09** | `09_hoja_de_vida.png` | Modal emergente con la Hoja de Vida técnica del portátil |
| **10** | `10_radicar_paso1.png` | Asistente de radicación — Paso 1 (Cliente, correctivo y prioridad) |
| **11** | `11_radicar_paso2.png` | Asistente de radicación — Paso 2 (Asociación de equipo y síntomas) |
| **12** | `12_radicar_paso3.png` | Asistente de radicación — Paso 3 (Checklist de accesorios y foto ingreso) |
| **13** | `13_radicar_paso4.png` | Asistente de radicación — Paso 4 (Resumen y asignación a Carlos Técnico) |
| **14** | `14_radicar_preventivo.png` | Formulario dinámico adaptado para radicación de servicio preventivo |
| **15** | `15_dashboard_tecnico.png` | Dashboard de Técnico con las órdenes de trabajo asignadas a su cola |
| **16** | `16_orden_trabajo.png` | Pestaña OT con diagnóstico técnico detallado e instrumental seleccionado |
| **17** | `17_bitacora_repuestos.png` | Pestaña Bitácora con procedimientos cronológicos y repuesto LCD ($180.000) |
| **18** | `18_pruebas_calidad.png` | Pestaña Bitácora con lista de chequeo de pruebas de calidad superadas |
| **19** | `19_fotos_ingreso.png` | Pestaña Fotos con la imagen del estado averiado antes de la reparación |
| **20** | `20_fotos_proceso.png` | Pestaña Fotos con la imagen del equipo reparado y ensamblado |
| **21** | `21_acta_entrega.png` | Pestaña Acta de Entrega diligenciada con garantía de 30 días y conformidad |
| **22** | `22_documento_oficial.png` | Visor del Documento Oficial de Entrega generado en PDF con firmas |
| **23** | `23_dashboard_admin_sla.png` | Dashboard Admin con tarjetas métricas de cumplimiento de SLA |
| **24** | `24_dashboard_tecnicos.png` | Dashboard Admin con panel de balance de carga técnica por especialista |
| **25** | `25_dashboard_tabla.png` | Dashboard Admin con tabla de órdenes en diferentes fases de atención |
| **26** | `26_config_perfil.png` | Módulo Configuración — Pestaña Perfil y credenciales de usuario |
| **27** | `27_config_identidad.png` | Módulo Configuración — Pestaña Identidad corporativa de Santi Inc |
| **28** | `28_config_usuarios.png` | Módulo Configuración — Pestaña Gestión y control de roles de usuario |
| **29** | `29_config_smtp.png` | Módulo Configuración — Pestaña Parámetros del servidor de correo SMTP |
| **30** | `30_consulta_publica.png` | Portal Público con la línea de tiempo interactiva de trazabilidad de orden |

---

# GLOSARIO DE TÉRMINOS
* **Acta de Entrega:** Documento probatorio legal emitido en PDF donde consta la devolución formal del equipo reparado al cliente, el estado funcional y los términos de garantía aplicables.
* **Bitácora de Mantenimiento:** Registro cronológico donde el técnico asienta cada una de las intervenciones físicas o lógicas efectuadas sobre el equipo.
* **Control de Calidad:** Protocolo de validación que somete al equipo reparado a pruebas de estrés, temperatura y verificación de periféricos antes de autorizar su salida.
* **Hoja de Vida:** Expediente digital donde se conservan las especificaciones técnicas de un activo y el historial de todas las órdenes de servicio en las que ha participado.
* **Mantenimiento Correctivo:** Acción técnica orientada a reparar una falla ya existente que inhabilita el uso regular del dispositivo.
* **Mantenimiento Preventivo:** Rutina periódica de inspección, limpieza y lubricación programada para prevenir contingencias y alargar la vida útil del hardware.
* **Orden de Trabajo (OT):** Mandato técnico donde se especifican las instrucciones de diagnóstico, instrumental y materiales requeridos para una labor de taller.
* **SLA (Service Level Agreement):** Métrica de gestión que determina el lapso máximo tolerable para dar solución técnica a una incidencia según su severidad pactada.
