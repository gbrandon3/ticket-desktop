# CONTEXTO TÉCNICO Y ARQUITECTURA DEL SISTEMA — SANTI INC

**Sistema Integral de Gestión de Mantenimiento y Soporte Técnico de Equipos de Cómputo**  
*Versión:* 1.0.0 (Release)  
*Plataformas:* Windows Desktop (x64) y Web SPA (HTML5/CanvasKit/WASM)

---

## 1. Visión General del Proyecto

**Santi Inc — Tickets App** es una solución informática integral diseñada para laboratorios de soporte técnico, talleres de reparación y departamentos de TI. Permite gestionar el ciclo de vida completo de órdenes de servicio técnico: desde la radicación de la incidencia, diagnóstico inicial y control de evidencias fotográficas, hasta la ejecución de bitácoras de trabajo, pruebas de control de calidad (QA/diagnóstico pre-entrega), emisión de actas de entrega con garantía y consulta pública en vivo para los clientes.

### Actores del Sistema
- **Administrador:** Acceso completo al sistema, configuración corporativa, gestión de credenciales SMTP, catálogo de fallas, usuarios y métricas de rendimiento/SLA.
- **Operador / Trabajador de Recepción:** Radicación de incidencias, alta de clientes y equipos, consulta de órdenes y emisión de actas de entrega.
- **Técnico de Laboratorio:** Diagnóstico de equipos (OT), registro de actividades y bitácoras, consumo de insumos y repuestos, pruebas de estrés y calidad, registro de evidencias fotográficas y cierre técnico.
- **Cliente / Solicitante:** Acceso sin necesidad de autenticación a través del portal de **Consulta Pública** (`/#/consulta`) mediante su código de orden para ver el progreso, procedimientos, pruebas de diagnóstico y fotografías en tiempo real.

---

## 2. Arquitectura y Stack Tecnológico

```
                  +----------------------------------------------+
                  |               CLIENTES / USUARIOS            |
                  +----------------------+-----------------------+
                                         |
            +----------------------------+----------------------------+
            |                                                         |
  [Windows Desktop (x64)]                                    [Navegador Web (SPA)]
  Flutter Desktop Runner                                     Flutter Web (HTML5/WASM)
  - Portable EXE + DLLs                                      - Compatible PC / Móviles
  - Soporte Impresión Térmica / PDF                          - Rutas limpias GoRouter
            |                                                         |
            +----------------------------+----------------------------+
                                         |
                                   HTTP / REST JSON
                                         |
                                         v
                  +----------------------------------------------+
                  |         SERVIDOR CENTRAL (server.js)         |
                  |             Node.js + Express 5              |
                  +----------------------+-----------------------+
                  | - Servidor Web Estático (SPA Flutter Web)     |
                  | - API REST Unificada (/api/*)                 |
                  | - Motor de Notificaciones SMTP (Nodemailer)   |
                  +----------------------+-----------------------+
                                         |
                                         v
                  +----------------------------------------------+
                  |         BASE DE DATOS RELACIONAL             |
                  |             SQLite (better-sqlite3)          |
                  |           data/tickets.sqlite                |
                  +----------------------------------------------+
```

### Componentes Técnicos
1. **Frontend (Flutter / Dart ^3.13.4):**
   - **Gestión de Estado:** `flutter_riverpod: ^3.4.3` (Inyección de dependencias modular y reactiva).
   - **Enrutamiento:** `go_router: ^14.8.1` con soporte SPA Hash/Path (`/#/login`, `/#/consulta`, `/#/home`).
   - **Impresión y Documentos Oficiales:** `pdf: ^3.13.1` y `printing: ^5.15.1` para generación de comprobantes y actas oficiales en PDF de alta fidelidad.
   - **Persistencia Local y Caché:** `drift: ^2.35.0` con compatibilidad multiplataforma SQLite/WASM.
   - **Manejo de Imágenes:** `image_picker: ^1.2.3` con soporte Web y Desktop.
2. **Backend (Node.js & Express 5):**
   - **Motor de Base de Datos:** `better-sqlite3` (síncrono, de alto rendimiento y cero dependencias externas de bases de datos pesadas).
   - **Servidor Web Híbrido:** Si existe la carpeta `build/web`, `server.js` entrega automáticamente el frontend Flutter y las APIs REST en el mismo puerto (`3000`).
   - **Servicio de Correo Transaccional:** `nodemailer` con conexión segura SSL/TLS (Gmail / SMTP institucional) para confirmaciones de ingreso y actas de entrega.

---

## 3. Estructura de la Base de Datos (`data/tickets.sqlite`)

La base de datos se almacena en el archivo local `data/tickets.sqlite`. Se inicializa automáticamente con tablas, índices e información por defecto si no existe.

| Tabla | Propósito |
|---|---|
| `usuarios` | Cuentas del sistema con contraseñas encriptadas SHA-256 (`ADMIN`, `OPERADOR`, `TECNICO`). |
| `clientes` | Directorio de clientes (nombre, documento, teléfono, dirección, email). |
| `equipos` | Equipos registrados (tipo, marca, modelo, número de serie, procesador, RAM, disco, etc.). |
| `ordenes` | Tickets de servicio técnico (código, cliente, equipo, técnico asignado, SLA, estado). |
| `formato_ot` | Diagnóstico inicial, motivo de ingreso, accesorios recibidos, estado de encendido. |
| `formato_actividades` | Bitácora técnica, insumos aplicados, optimizaciones lógicas y valor de mano de obra. |
| `formato_acta_entrega` | Acta formal de entrega, operatividad final, recomendaciones, observaciones y garantía. |
| `repuestos` | Piezas y repuestos asociados a la orden con costos y cantidades. |
| `fotos_evidencia` | Registro de fotografías en Base64 o URLs asociadas a cada orden y etapa. |
| `notificaciones_auditoria` | Historial de auditoría de correos electrónicos enviados y su estado (ENVIADO / FALLIDO). |
| `empresa_config` | Parámetros de la empresa (nombre, NIT, teléfono, credenciales SMTP, URL del portal). |
| `catalogo_fallas` | Catálogo de tipos de fallas y diagnósticos predefinidos para agilizar la radicación. |

### Ciclo de Estados de una Orden
```
[ RECIBIDO ] ---> [ EN_DIAGNOSTICO ] ---> [ EN_TALLER ] ---> [ LISTO_ENTREGA ] ---> [ ENTREGADO_CERRADO ]
```

---

## 4. Módulos y Funcionalidades Principales

### 4.1. Radicación de Incidencias (`CrearIncidenciaScreen`)
- Selección o creación rápida de cliente y equipo.
- Especificaciones técnicas completas (procesador, memoria RAM, almacenamiento, tarjeta gráfica, serial).
- Cálculo automático de SLA según prioridad (`BAJA`: 72h, `MEDIA`: 48h, `ALTA`: 24h, `CRITICA`: 8h).
- Envío automático de correo al cliente con el código radicado y enlace limpio de seguimiento (`$baseUrl/#/consulta`).

### 4.2. Taller de Servicio Técnico (`DetalleTallerScreen`)
- **Pestaña 1 (OT & Evidencias):** Diagnóstico preliminar, checklist de accesorios (cargador, cable de poder, mouse, maletín), estado de encendido y galería de fotos de evidencia del estado físico de recepción.
- **Pestaña 2 (Bitácora & Procedimientos):** Labores realizadas, insumos de laboratorio utilizados (pasta térmica, alcohol isopropílico, sopleteado, brocha antiestática, paño microfibra), procedimientos de mantenimiento lógico (limpieza de temporales, optimización de inicio, análisis de malware, actualización de controladores), repuestos instalados y cotización de mano de obra.
- **Pestaña 3 (Control de Calidad & Diagnóstico Pre-entrega):**
  - Protocolo de pruebas de estrés térmico (HWMonitor / AIDA64).
  - Estado de salud de discos SMART (CrystalDiskInfo).
  - Verificación de memoria RAM (MemTest86).
  - Comprobación de puertos USB / HDMI / conectores de video.
  - Conectividad de red Wi-Fi y Ethernet.
  - Estado de batería y teclado / touchpad.
- **Cierre y Acta Oficial de Entrega:**
  - Registro de persona que retira (nombre y documento) y verificación de conformidad.
  - Configuración de garantía (ej. 30 días, 60 días, 90 días).
  - Recomendaciones de cuidado personalizadas.
  - Bloqueo de la orden a modo solo lectura (`ENTREGADO_CERRADO`).
  - **Notificación por correo al cliente:** Despacha automáticamente un correo formal con el resumen técnico, garantía, recomendaciones y enlace de consulta.

### 4.3. Portal de Consulta Pública (`ConsultaPublicaScreen` - `/#/consulta`)
- Permite a los clientes consultar en cualquier momento su equipo mediante el código de orden o ticket.
- Muestra el diagnóstico inicial, bitácora de labores, insumos y repuestos aplicados, resultados de las pruebas de control de calidad, observaciones y recomendaciones de cuidado, además de la galería fotográfica de evidencias.

### 4.4. Generación de Documentos Oficiales en PDF (`DocumentoOficialScreen`)
- Generación de Actas de Entrega y Comprobantes de Servicio con membrete corporativo, datos del cliente, especificaciones del equipo, desglose económico, firmas de conformidad y términos legales.
- Soporte para previsualización e impresión directa en papel o guardado en PDF.

---

## 5. API REST — Endpoints Principales (`server.js`)

| Método | Endpoint | Descripción |
|---|---|---|
| `POST` | `/api/auth/login` | Autenticación de usuarios por usuario y contraseña. |
| `GET` | `/api/ordenes` | Listado general de órdenes con filtros de estado y búsqueda. |
| `POST` | `/api/ordenes` | Creación de una nueva orden de servicio técnico. |
| `GET` | `/api/ordenes/:id` | Detalle completo de una orden con sus relaciones. |
| `PUT` | `/api/ordenes/:id/estado` | Actualización de estado en el flujo de trabajo. |
| `POST` | `/api/ordenes/:id/acta-entrega`| Cierre de orden con acta de entrega oficial. |
| `GET` | `/api/consulta-publica` | Consulta pública de tickets (incluye OT, bitácora, pruebas QA y fotos). |
| `POST` | `/api/send-email` | Despacho de correos transaccionales vía Nodemailer/SMTP. |
| `GET` | `/api/configuracion` | Obtención de parámetros de la empresa y portal. |
| `PUT` | `/api/configuracion` | Actualización de datos de empresa y credenciales SMTP. |
| `GET` | `/api/catalogo-fallas` | Catálogo de tipos de fallas y diagnósticos frecuentes. |

---

## 6. Distribución y Paquetes Release

Los ejecutables y compilaciones de producción se encuentran empaquetados en la carpeta **`releases/`**:

1. **Aplicación de Escritorio Windows (x64):**
   - **Ruta:** `releases/tickets_app_windows_x64.zip`
   - **Ejecutable principal:** `tickets_app.exe`
   - **Características:** Aplicación nativa portable con todas las DLLs requeridas (`sqlite3.dll`, `flutter_windows.dll`, `pdfium.dll`, `printing_plugin.dll`, etc.). No requiere instalación de Flutter ni herramientas de desarrollo.
2. **Aplicación Web (SPA):**
   - **Ruta:** `releases/tickets_app_web_release.zip`
   - **Directorio compilado:** `build/web/`
   - **Características:** Aplicación web optimizada para producción con WebAssembly, CanvasKit e index.html listo para despliegue.

---

## 7. Guía de Ejecución y Puesta en Marcha

### Requisitos Previos
- **Node.js:** Versión 18 o superior instalada.
- **Flutter SDK:** Versión ^3.13 (solo requerido si se desea compilar o desarrollar; no es necesario para ejecutar los releases).

### Ejecutar el Sistema Completo (Servidor Unificado: Backend + Web)
En la carpeta raíz del proyecto, ejecutar:
```bash
node server.js
```
El servidor realizará lo siguiente:
- Conectará o inicializará la base de datos `data/tickets.sqlite`.
- Iniciará la API REST y el servicio de correos en el puerto `3000`.
- Servirá automáticamente la aplicación web Flutter en **`http://localhost:3000`**.

### Ejecutar la Aplicación de Escritorio Windows
1. Descomprimir el archivo `releases/tickets_app_windows_x64.zip`.
2. Ejecutar `tickets_app.exe`.
3. La aplicación se comunicará directamente con el servidor `http://localhost:3000` (o la IP configurada en la red local).

### Ejecución de Pruebas Automatizadas
Para verificar la integridad del código y todas las suites de prueba:
```bash
flutter test
```
*Todas las 15 suites de pruebas funcionales y de componentes pasan satisfactoriamente.*
