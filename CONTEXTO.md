# Contexto técnico — Santi Inc

## Propósito y plataformas

Sistema de órdenes de mantenimiento y soporte de equipos: ingreso, diagnóstico, bitácora, repuestos, evidencias, pruebas de calidad, entrega, PDF y consulta pública. Frontend Flutter para Windows y web; servidor central HTTP en el puerto 3000 por defecto.

## Stack real

- Flutter 3.47.5 y Dart 3.13.4 verificados localmente.
- Riverpod ^3.4.3, go_router ^18.0.1, drift ^2.35.0, pdf ^3.13.1, printing ^5.15.1 e image_picker ^1.2.3.
- Express ^5.2.1, cors ^2.8.6 y Nodemailer ^6.9.15.
- SQLite mediante node:sqlite / DatabaseSync; no utiliza better-sqlite3. Node.js mínimo 22.13; recomendado 24.

## Arquitectura y archivos

server.js inicia el proceso. server/app.js configura Express y monta módulos legibles en server/routes/. server/db.js crea el esquema y habilita claves foráneas y WAL. La base es data/tickets.sqlite.

server/security.js aplica sesiones Bearer de ocho horas, permisos y limitación de intentos. server/validation.js valida entradas, transiciones y órdenes cerradas; las escrituras síncronas usan transacciones con rollback ante error. server/secrets.js cifra SMTP con AES-256-GCM. server/change-audit.js registra usuario, operación y fecha de cambios exitosos sin almacenar contraseñas ni cuerpos de solicitudes. Flutter centraliza el token en lib/core/services/api_session.dart.

Tablas: usuarios, clientes, equipos, ordenes, formato_ot, formato_actividades, repuestos_orden, formato_acta_entrega, fotos_evidencia, configuracion_empresa, notificaciones_auditoria, tipos_falla y auditoria_cambios.

## Roles y acceso

- admin: administración y operación completa.
- solicitante: operador de recepción; registra clientes y órdenes, consulta el taller y actualiza su perfil.
- tecnico: trabaja sobre órdenes asignadas; no registra ingresos ni administra configuración o cuentas.
- público: consulta mediante código exacto de orden, sin sesión.

El setup se cierra después de completarlo. Las contraseñas se almacenan con scrypt y sal; las existentes se migran al arrancar. Las respuestas no contienen contraseñas. El cliente recibe ******** como marcador de SMTP configurado; el envío usa la credencial real exclusivamente en el servidor. La clave de cifrado es data/smtp.key o TICKETS_SECRET_KEY_FILE.

## Flujo

RECIBIDO → EN_DIAGNOSTICO → EN_TALLER → LISTO_ENTREGA → ENTREGADO_CERRADO.

El servidor exige avance secuencial. Para cerrar debe existir estado LISTO_ENTREGA, receptor identificado y conformidad en el acta. Las órdenes entregadas quedan bloqueadas en la API y la interfaz.

El taller contiene tres pestañas: OT y evidencias; bitácora e insumos (incluye pruebas); acta de entrega. Las pruebas de hardware se registran como checklist, no se ejecutan automáticamente desde la aplicación.

## API principal

| Método | Ruta | Acceso |
|---|---|---|
| POST | /api/auth/login | Público, limitado |
| POST | /api/auth/logout | Sesión |
| GET | /api/setup/status | Público |
| POST | /api/setup | Solo antes del primer setup |
| GET | /api/config | Público con datos SMTP limitados; admin con configuración sin secreto |
| POST | /api/config | Admin |
| GET / POST / PUT / DELETE | /api/usuarios y subrutas | Admin; excepciones de perfil y listado de técnicos |
| GET / POST | /api/clientes | Sesión y permisos |
| GET | /api/equipos | Sesión |
| GET / POST | /api/ordenes | Sesión y permisos |
| GET | /api/ordenes/:id | Sesión; técnico asignado |
| PUT | /api/ordenes/:id/estado | Transición validada |
| PUT | /api/ordenes/:id/tecnico | Sesión y permisos |
| GET / POST | /api/ordenes/:id/ot | Sesión y permisos |
| GET / POST | /api/ordenes/:id/actividades | Sesión y permisos |
| GET / POST | /api/ordenes/:id/repuestos | Sesión y permisos |
| GET / POST | /api/ordenes/:id/fotos | Sesión y permisos |
| GET / POST | /api/ordenes/:id/acta | Sesión; cierre validado |
| GET | /api/consulta-publica?q=CODIGO | Público; código exacto |
| GET | /api/historial-cambios | Admin |
| GET | /api/backups/status | Admin |
| POST | /api/backups | Admin; descarga SQLite |
| POST | /api/send-email | Sesión; SMTP del servidor |
| GET / POST / DELETE | /api/tipos-falla y subrutas | Lectura con sesión; cambios admin |
| GET | /api/metrics/dashboard | Sesión |
| GET | /api/metrics/admin | Admin |
| GET / POST | /api/auditoria | Lectura admin; registro con sesión |

La consulta pública omite identidad de cliente, técnico y PIN; ya no busca por documento, serial ni fragmentos. Las órdenes nuevas incluyen un sufijo aleatorio de 128 bits en su código. Las órdenes antiguas conservan su código; estos códigos previos pueden ser consecutivos.

## Operación y verificación

README.md contiene instalación, variables de entorno, compilación y respaldo/restauración. La entrega escolar usa HTTP local; HTTPS se excluyó por solicitud del usuario. node server/backup.js genera una copia consistente mediante VACUUM INTO; hay respaldos automáticos al iniciar y cada 24 horas mientras el servidor está encendido. BACKUP_INTERVAL_HOURS=0 los desactiva. Conservar la clave SMTP separadamente.

Hay 18 pruebas de widgets y flujos, dos pruebas de generación de PDF y siete pruebas del backend (API, cifrado, copia/restauración, programación de copias, correo simulado y descarga/restauración por API). scripts/validar.ps1 ejecuta la verificación local completa. .github/workflows/pruebas.yml prepara CI para GitHub; no se ejecutó remotamente en esta revisión.

Los PDF usan fuentes Roboto incorporadas con licencia Apache 2.0 para evitar símbolos faltantes y no requieren descargas de fuentes. El encabezado limita nombres y códigos largos; se añadió numeración de páginas. La exportación web usa package:web y dart:js_interop.

Los paquetes recompilados se guardan en releases/. El backend distribuido incluye build/web y node_modules; excluye data/, respaldos y credenciales. Windows se conecta al servidor local por defecto.

## Límites de la verificación

Correo SMTP real e impresión física dependen de una cuenta y una impresora disponibles; se verificaron preparación de correo sin envíos reales y generación/renderizado de PDF. Las sesiones en memoria se pierden al reiniciar. Las órdenes antiguas conservan sus códigos previos; no se alteraron datos históricos. No se desplegó el proyecto en internet ni se habilitó HTTPS.

Verificación local final: 20 pruebas de Flutter (incluye 2 PDF), 7 de backend y análisis sin avisos ni errores. Los PDF de demostración se revisaron en todas sus páginas.

## Correcciones de flujo e interfaz

La caída del backend muestra un error de conexión con reintento y no redirige al setup. Las órdenes no admiten equipos con otra orden abierta ni el cambio implícito de propietario por serial. La OT exige diagnóstico, la bitácora exige procedimientos y costo no negativo, y el cierre exige ambos formatos, receptor, conformidad y estado LISTO_ENTREGA. La entrega sincroniza el inventario: OPERATIVO o DE_BAJA según el acta. Los botones de taller explican los rechazos sin avanzar falsamente.

Crear incidencia conserva un único aviso SMTP en AppShell. El formulario tiene ancho máximo de 1120 px, filas adaptables, una sola entrada de categoría con catálogo y mensajes neutrales en la búsqueda de equipos. El diálogo de éxito permite seleccionar/copiar códigos largos sin desbordarse. test/ui_flow_test.dart verifica el registro completo y ventanas estrechas; GENERATE_UI_EVIDENCE=1 genera capturas en output/ui/ sin tocar la base real. Las últimas correcciones están en el código fuente; los ZIP de releases/ requieren recompilación para incorporarlas.
El taller usa un encabezado blanco con el consecutivo visible y acceso para copiar el código completo. La recepción se organiza en tarjetas de diagnóstico/herramientas e inspección; cambia de dos columnas a una en ventanas estrechas. Las tres pestañas tienen ancho máximo de 1120 px. Las pruebas verifican escritorio, ventana estrecha y bloqueo de órdenes cerradas.
