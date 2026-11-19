# MANUAL DE USUARIO DEL SISTEMA
## Plataforma Integral de Gestión de Tickets, Taller y Soporte Técnico

| Atributo del Documento | Detalle Oficial |
| :--- | :--- |
| **Sistema de Información** | Plataforma Integral de Gestión de Tickets, Taller y Mantenimiento de Equipos |
| **Versión de Producción** | 1.0.0 Oficial (Windows Desktop x64 & Web SPA) |
| **Arquitectura del Sistema** | Plataforma configurable multi-empresa (Servidor Node.js + SQLite Relacional) |
| **Base de Datos y Motor** | SQLite Relacional con Respaldos Automáticos y Almacenamiento en Disco |
| **Alcance del Manual** | Guía de operación para Administradores, Operadores de Mesa de Ayuda, Técnicos y Clientes |

---

# 1. Introducción, Alcance y Perfiles de Usuario

El presente **Manual de Usuario** describe de manera detallada el funcionamiento operativo de la **Plataforma de Gestión de Tickets, Taller y Soporte Técnico**. El software ha sido diseñado para estandarizar y controlar de principio a fin el flujo de trabajo en centros de soporte, departamentos de TI y laboratorios de mantenimiento de cómputo: desde el registro inicial de clientes y activos de hardware, pasando por el diagnóstico técnico, bitácora de procedimientos, pruebas de control de calidad pre-entrega (QA) y evidencias fotográficas, hasta la generación del Acta Oficial de Entrega en formato PDF y el envío de notificaciones automáticas por correo electrónico.

## 1.1 Perfiles y Roles Operativos del Sistema

El control de acceso de la plataforma aplica permisos diferenciados según el perfil asignado a cada cuenta de usuario:

| Rol en el Sistema | Responsabilidades y Alcance Operativo | Módulos Habilitados |
| :--- | :--- | :--- |
| **Administrador (`ADMIN`)** | Supervisión global del laboratorio, gestión de identidad corporativa, alta y control de usuarios, parametrización del catálogo de fallas, configuración SMTP, copias de seguridad y auditoría de cambios. | Todos los módulos, Dashboard SLA, Configuración, Usuarios, Respaldos e Historial. |
| **Operador / Mesa de Ayuda (`OPERADOR`)** | Atención en ventanilla, recepción de equipos, alta de clientes e inventario, radicación de incidencias correctivas o preventivas, asignación de técnicos y entrega formal al cliente. | Bandeja General, Nueva Incidencia, Clientes, Inventario, Taller y Consulta. |
| **Técnico Especialista (`TECNICO`)** | Inspección diagnóstica en mesa de trabajo (OT), documentación de bitácora, aplicación de insumos y repuestos, ejecución de protocolo de pruebas de calidad (QA), carga de fotos y cierre técnico. | Bandeja de Órdenes Asignadas, Mesa de Taller (3 pestañas), Inventario. |
| **Cliente Externo (`PÚBLICO`)** | Consulta en línea del estado de su orden de servicio mediante el código único asignado, sin requerir usuario ni contraseña. | Portal de Consulta Pública (`/consulta`). |

## 1.2 Ciclo de Vida de una Orden de Servicio

Toda orden radicada en el sistema transita por estados controlados que garantizan la trazabilidad técnica y administrativa:

1. **`RECIBIDO`:** La orden ha sido radicada en recepción y el equipo ingresa formalmente al inventario del taller.
2. **`EN DIAGNÓSTICO`:** El técnico especialista evalúa el equipo y diligencia la Orden de Trabajo (OT) preliminar junto con la inspección física y fotografías de recepción.
3. **`EN TALLER`:** Se ejecutan las labores de reparación o mantenimiento preventivo, consumo de insumos/repuestos y pruebas de control de calidad (QA).
4. **`LISTO PARA ENTREGA`:** El equipo ha superado las pruebas de diagnóstico pre-entrega y se encuentra disponible para ser retirado por el titular.
5. **`ENTREGADO / CERRADO`:** Se emite el Acta Oficial de Entrega con garantía y conformidad del cliente, bloqueando la orden en modo solo lectura y actualizando el estado del equipo en inventario (`OPERATIVO` o `DE_BAJA`).

---

# 2. Módulo 1: Asistente de Configuración Inicial (Setup Wizard)

Cuando la plataforma se ejecuta por primera vez sobre una base de datos limpia, el sistema despliega de manera automática el **Asistente de Configuración Inicial**. Este flujo guiado de tres pasos permite registrar la identidad jurídica del taller, crear la cuenta raíz del Administrador Principal y habilitar opcionalmente el personal base de operación.

## 2.1 Paso 1: Datos de la Empresa o Taller

En esta primera sección se establece la razón social y los datos de contacto oficiales que encabezarán los membretes de todas las órdenes de trabajo, comprobantes de recepción, actas de entrega en PDF y notificaciones enviadas por correo electrónico.

| Campo del Formulario | Obligatorio | Descripción y Uso en el Sistema | Ejemplo Configurado |
| :--- | :---: | :--- | :--- |
| **Nombre de la Empresa o Proyecto** | Sí | Razón social o nombre comercial que aparece en el encabezado general y documentos PDF. | `SANTI INC` |
| **NIT / RUT / ID Fiscal** | Sí | Identificación tributaria de la empresa o laboratorio técnico. | `922348710` |
| **Teléfono Móvil o WhatsApp** | Sí | Línea de atención al cliente impresa en las actas de servicio. | `+57 3053633737` |
| **Correo Electrónico de Soporte** | Sí | Dirección oficial de contacto del laboratorio. | `SantiINC@gmail.com` |
| **Ciudad y País** | Sí | Ubicación geográfica principal de operación del taller. | `Monteria, Cordoba` |
| **Dirección Física del Taller** | Sí | Domicilio físico para recepción y retiro de equipos. | `Dg. 23, Montería, Córdoba` |

> *Figura 1: Paso 1 del Asistente de Configuración Inicial con los datos de la empresa o taller (incluida en `MANUAL_DE_USUARIO_SISTEMA_TICKETS.docx`).*

**Operación en pantalla:** Una vez completados todos los campos obligatorios marcados con asterisco (`*`), presione el botón azul **"Continuar al Siguiente Paso"** para avanzar a la configuración del administrador.

## 2.2 Paso 2: Cuenta del Administrador Principal

El segundo paso crea la cuenta principal con privilegios globales de administración. Por seguridad, la contraseña ingresada se almacena utilizando derivación criptográfica (`scrypt`) y nunca se expone en texto plano.

| Campo del Formulario | Obligatorio | Descripción Funcional | Ejemplo en Captura |
| :--- | :---: | :--- | :--- |
| **Nombre Completo del Administrador** | Sí | Nombre y apellidos del responsable general del sistema. | `Santiago Matias Ojeda Cuadrado` |
| **Cédula / Documento de Identidad** | Sí | Número de identificación del administrador. | `1068423488` |
| **Teléfono Móvil** | Sí | Número de contacto directo del administrador. | `3053633737` |
| **Correo Electrónico de Acceso** | Sí | Credencial única de usuario para iniciar sesión en la plataforma. | `matiasOjeda1803@gmail.com` |
| **Contraseña de Acceso** | Sí | Clave secreta de autenticación (incluye botón de visualización para verificar su escritura). | `Admin123` |

> *Figura 2: Paso 2 del Asistente de Configuración Inicial con la parametrización del Administrador Principal (incluida en `MANUAL_DE_USUARIO_SISTEMA_TICKETS.docx`).*

> **Nota de Seguridad:** El rol Administrador posee permisos exclusivos sobre la configuración de correo SMTP, gestión de cuentas de personal, descarga/restauración de respaldos de base de datos y consulta del historial de auditoría. Se recomienda resguardar estas credenciales de forma segura.

## 2.3 Paso 3: Registro de Personal Inicial Opcional

El tercer paso permite dar de alta de forma inmediata al primer Operador de Mesa de Ayuda y al primer Técnico Especialista sin necesidad de crearlos posteriormente desde el panel de configuración:

* **Primer Operador o Mesa de Ayuda:** Perfil orientado a la recepción de clientes, consulta de directorio, registro de equipos y radicación de tickets (*Ejemplo en captura:* `Celeste Azul Luna Palmera` — `lunapalmera@gmail.com` — Tel: `3124698356`).
* **Primer Técnico Especialista:** Perfil orientado al banco de trabajo, diagnóstico de hardware/software, registro de bitácoras y pruebas de control de calidad (*Ejemplo en captura:* `Santiago Andres Quintana Martinez` — `Quitana16@gmail.com` — Tel: `3244275335`).

> *Figura 3: Paso 3 del Asistente de Configuración Inicial con el alta del Operador de Mesa de Ayuda y Técnico Especialista (incluida en `MANUAL_DE_USUARIO_SISTEMA_TICKETS.docx`).*

**Finalización del Asistente:** Al pulsar el botón **"Finalizar e Ingresar"**, el sistema guarda de forma atómica la configuración institucional y las cuentas creadas, iniciando sesión automáticamente en el panel principal.

---

# 3. Módulo 2: Inicio de Sesión y Control de Acceso (Login)

La pantalla de autenticación constituye la puerta de enlace a la plataforma operativa. Verifica las credenciales del funcionario contra la base de datos central y establece una sesión autenticada mediante token.

## 3.1 Controles y Opciones de la Pantalla de Acceso
* **Correo Electrónico:** Campo de entrada para el correo registrado del Administrador, Operador o Técnico.
* **Contraseña:** Campo protegido con opción de alternar visibilidad (icono de ojo) para confirmar la clave antes de ingresar.
* **Botón "Iniciar Sesión":** Valida las credenciales. Si son correctas, redirige al usuario a su entorno de trabajo correspondiente; si son inválidas, despliega una alerta explícita indicando el error de autenticación.
* **Acceso a Consulta Pública de Equipos:** En la parte inferior de la tarjeta de inicio de sesión se dispone del botón de acceso directo al **Portal Público (`/consulta`)**, diseñado para que los clientes verifiquen el estado de sus órdenes sin necesidad de credenciales.

> **Resiliencia de Conexión:** En caso de interrupción temporal de la comunicación con el servidor central, la pantalla informa el estado de conexión con opción de reintento inmediato sin redirigir erróneamente al asistente de instalación.

---

# 4. Módulo 3: Catálogo de Fallas y Diagnósticos

Disponible para el perfil Administrador desde el menú lateral **Configuración > pestaña "Fallas & Diagnósticos"**. Este módulo permite estandarizar las categorías de servicio que los operadores seleccionarán al momento de radicar nuevas incidencias, evitando errores de digitación y facilitando las métricas operativas.

## 4.1 Estructura del Catálogo por Modalidad de Servicio
La interfaz organiza los motivos de ingreso en dos tarjetas independientes con contadores dinámicos de elementos activos:

1. **Tipos de Falla — Mantenimiento Correctivo:** Agrupa averías, fallos eléctricos, daños físicos o errores de software reportados en equipos que presentan mal funcionamiento (*Ejemplos:* `"Falla de Pantalla / Video"`, `"Falla de Disco / Almacenamiento"`).
2. **Tipos de Falla — Mantenimiento Preventivo:** Agrupa rutinas programadas de preservación, limpieza interna y optimización destinadas a prevenir fallos futuros (*Ejemplos:* `"Mantenimiento Preventivo Semestral"`, `"Limpieza Física y Cambio de Pasta Térmica"`).

## 4.2 Procedimiento para Agregar o Eliminar Tipos de Falla
1. Iniciar sesión con perfil Administrador y dirigirse a **Configuración > Fallas & Diagnósticos**.
2. En la tarjeta correspondiente (Correctivo o Preventivo), hacer clic en el botón **"+ Agregar"**.
3. Digitar el nombre descriptivo de la falla o servicio y confirmar el guardado. El indicador superior actualizará de inmediato el número de registros activos.
4. Para retirar una categoría en desuso, presionar el icono de eliminación junto al elemento deseado.

---

# 5. Módulo 4: Gestión de Clientes y Directorio

El sistema administra un directorio centralizado de personas naturales, dependencias internas y empresas que solicitan servicios en el laboratorio. El registro de clientes puede realizarse tanto desde el módulo de búsqueda/directorio como de forma integrada durante la radicación de una incidencia.

## 5.1 Información Registrada por Cliente

| Campo del Cliente | Obligatorio | Propósito Operativo y Administrativo |
| :--- | :---: | :--- |
| **Tipo de Documento** | Sí | Permite distinguir entre Cédula de Ciudadanía (CC), NIT empresarial, Cédula de Extranjería o Pasaporte. |
| **Número de Documento / NIT** | Sí | Identificador único del titular para búsquedas rápidas y asociación de equipos en inventario. |
| **Nombre Completo / Razón Social** | Sí | Nombre del titular o entidad que figurará en los comprobantes de ingreso y Actas de Entrega. |
| **Correo Electrónico** | Recomendado | Canal utilizado por el servidor SMTP para enviar automáticamente la confirmación de radicación y el acta de cierre. |
| **Teléfono de Contacto** | Sí | Número telefónico para notificaciones urgentes o coordinación de entrega. |
| **Dirección / Ubicación** | Sí | Dirección física, sede o dependencia a la que pertenece el cliente. |

---

# 6. Módulo 5: Inventario Técnico y Hoja de Vida de Equipos

El módulo de **Inventario de Equipos** permite llevar el control detallado del parque computacional atendido por el taller, vinculando cada máquina a su propietario legítimo y conservando su expediente histórico de intervenciones.

## 6.1 Ficha Técnica del Equipo
Al registrar un equipo nuevo (ya sea desde Inventario o al radicar una orden), se documentan sus especificaciones de hardware:
* **Datos de Identificación:** Tipo de equipo (`Portátil`, `PC de Escritorio`, `All-in-One`, `Impresora / Periférico`), Marca, Modelo y Número de Serie (Serial único).
* **Especificaciones Internas:** Procesador (CPU), Capacidad y tipo de Memoria RAM, Almacenamiento principal (SSD/HDD), Tarjeta Gráfica (GPU) y Sistema Operativo instalado.
* **Estado en Inventario:** Indica la condición actual del activo: `OPERATIVO` (en uso normal), `EN_TALLER` (actualmente bajo intervención técnica) o `DE_BAJA` (retirado por daño irreparable).

## 6.2 Consulta de Hoja de Vida y Trazabilidad Histórica
Desde la tabla general de inventario, al seleccionar la opción **"Hoja de Vida"** sobre cualquier equipo, el sistema despliega una ventana modal con su expediente completo: especificaciones de fábrica, propietario asociado y el listado cronológico de todas las órdenes de mantenimiento (preventivas y correctivas) que se le han practicado, permitiendo detectar reincidencias de fallas o verificar garantías vigentes.

---

# 7. Módulo 6: Radicación de Incidencias (Correctivas y Preventivas)

El módulo **"+ Nueva Incidencia"** permite a los Operadores y Administradores registrar el ingreso de un equipo al taller mediante un formulario adaptable de alta productividad.

## 7.1 Flujo de Radicación de una Orden de Servicio
1. **Identificación del Titular:** Se busca al cliente por su número de documento o nombre. Si el cliente es nuevo, se completan sus datos de contacto directamente en la sección de solicitante.
2. **Selección del Tipo de Servicio y Prioridad:** Se define si la orden corresponde a un **Mantenimiento Correctivo** (reparación de falla) o **Mantenimiento Preventivo** (limpieza y preservación). Al elegir el nivel de prioridad (`Baja`, `Media`, `Alta` o `Crítica`), el sistema calcula automáticamente la fecha y hora límite del Acuerdo de Nivel de Servicio (SLA).
3. **Asociación del Equipo y Reglas de Integridad:** Se selecciona un equipo existente del cliente o se registra uno nuevo digitando su serial, marca, modelo y especificaciones. El sistema valida automáticamente dos reglas de negocio críticas:
   * No permite abrir una nueva orden a un equipo que ya tenga otra orden abierta en curso.
   * Impide reasignar accidentalmente un serial existente a otro propietario distinto.
4. **Categoría del Catálogo y Descripción del Motivo:** El operador selecciona la categoría de falla o alcance preventivo desde el selector alimentado por el Catálogo de Fallas, y detalla los síntomas reportados o requerimientos específicos del servicio.
5. **Asignación de Técnico y Emisión:** Se selecciona al Técnico Especialista responsable (o se deja en bandeja general por asignar) y se pulsa el botón de radicación.

## 7.2 Código de Seguimiento y Notificación Automática por Correo
Al confirmar la creación de la orden, la plataforma ejecuta de inmediato tres acciones:
* **Generación de Código Único con Sufijo de Seguridad:** Se emite el código oficial del ticket y se presenta en un cuadro de confirmación con botón de copiado rápido al portapapeles.
* **Actualización de Inventario:** El equipo asociado pasa automáticamente al estado `EN_TALLER`.
* **Despacho de Correo Electrónico al Cliente:** Si el cliente cuenta con correo electrónico registrado y el servidor SMTP está activo, el sistema envía automáticamente un mensaje formal con el resumen de recepción y el enlace directo al Portal de Consulta Pública.

---

# 8. Módulo 7: Mesa de Trabajo y Gestión Técnica de Taller

Cuando el Técnico Especialista inicia sesión, accede a su bandeja personalizada de órdenes asignadas. Al hacer clic sobre cualquier orden, se abre la pantalla **Detalle de Taller**, la cual organiza todo el trabajo técnico en un encabezado informativo (con acceso para copiar el código completo y selector de estado) y **tres (3) pestañas operativas**.

## 8.1 Pestaña 1: Orden de Trabajo (OT) y Evidencias Fotográficas
Esta primera pestaña documenta las condiciones físicas en las que se recibe el equipo, el diagnóstico técnico inicial y el registro fotográfico de respaldo:
* **Diagnóstico Preliminar e Instrumental:** Campo para detallar el dictamen técnico inicial, selector de fecha estimada de entrega y etiquetas interactivas (chips) para registrar las herramientas e instrumentos de medición utilizados (ej. Multímetro digital, Fuente regulada, Alcohol isopropílico, Destornilladores de precisión).
* **Inspección Física y Accesorios Recibidos:** Casillas de verificación para dejar constancia de si el equipo enciende al ingresar y qué accesorios entrega el cliente (`Cargador`, `Cable de poder`, `Mouse`, `Maletín/Funda`), además del estado físico de la carcasa y el PIN o contraseña de desbloqueo proporcionado para pruebas.
* **Galería de Evidencias Fotográficas Integrada:** Permite subir fotografías clasificadas por etapa (`RECEPCION`, `PROCESO`, `ENTREGA`). Las imágenes se comprimen automáticamente y se almacenan en el directorio físico del servidor (`data/uploads/`) para mantener el máximo rendimiento de la base de datos.

## 8.2 Pestaña 2: Bitácora, Repuestos y Control de Calidad (QA)
En la segunda pestaña el técnico registra todos los procedimientos ejecutados sobre la máquina, los materiales empleados, las pruebas de validación pre-entrega y los costos asociados:
* **Procedimientos y Labores Realizadas:** Descripción exhaustiva del trabajo técnico efectuado (reparación de componentes, desensamble, limpieza ultrasónica, reemplazo de piezas, etc.).
* **Insumos Físicos y Mantenimiento Lógico:** Checklists dedicados para marcar los insumos aplicados en laboratorio (*Pasta térmica de alto rendimiento, Alcohol isopropílico, Sopleteado/aire comprimido, Brocha antiestática, Paño de microfibra*) y las optimizaciones de software (*Depuración de archivos temporales, Optimización de arranque, Escaneo de malware/seguridad y Actualización de drivers/BIOS*).
* **Protocolo de Pruebas de Diagnóstico Pre-Entrega (Control de Calidad QA):** Conjunto de verificaciones técnicas obligatorias antes de dar por terminado el servicio:
  1. Estrés Térmico CPU/GPU (*HWMonitor*).
  2. Salud de Disco SMART (*CrystalDiskInfo*).
  3. Diagnóstico de Memoria RAM (*MemTest*).
  4. Verificación de Puertos USB/HDMI/Audio.
  5. Conectividad Wi-Fi y Ethernet RJ45.
  6. Ciclos y Carga de Batería.
  7. Respuesta de Teclado y Touchpad.
  *(Cada prueba permite adjuntar su respectiva captura de pantalla como evidencia).*
* **Consumo de Repuestos y Mano de Obra:** Tabla para agregar repuestos instalados (referencia, cantidad y precio unitario) junto con el valor de la mano de obra técnica. El sistema calcula el total económico de forma automática.

## 8.3 Pestaña 3: Acta Oficial de Entrega, Garantía y Cierre
La tercera pestaña formaliza la devolución del equipo al cliente y el cierre definitivo del expediente técnico:

> **Validación Estricta de Cierre:** El sistema impide cerrar una orden de forma accidental: para emitir el Acta Oficial de Entrega, la orden debe encontrarse en estado `LISTO_ENTREGA`, contar con el Diagnóstico Inicial (OT) y la Bitácora de Procedimientos previamente guardados, registrar los datos de quien recibe y marcar la casilla de conformidad.

* **Estado de Operatividad Final:** Define si el equipo se entrega `OPERATIVO` o `IRREPARABLE / SIN REPARACIÓN`. Al cerrar el acta, el inventario del equipo se sincroniza automáticamente a `OPERATIVO` o `DE_BAJA` según corresponda.
* **Vigencia de Garantía y Observaciones:** Permite establecer el periodo de cobertura otorgado (ej. Sin garantía, 30 días, 60 días, 90 días), las observaciones técnicas de salida y las **Recomendaciones de Cuidado y Uso** para el cliente.
* **Datos del Receptor y Conformidad:** Registra el nombre completo y documento de identidad de la persona que retira el equipo, junto con la casilla de verificación de entrega a satisfacción.
* **Notificación Automática de Cierre y Documento Oficial PDF:** Al pulsar **"Finalizar Servicio y Emitir Acta Oficial"**, la orden queda archivada en modo solo lectura, se envía automáticamente un correo electrónico al cliente con el resumen de entrega, garantía y recomendaciones, y se habilita el visor para imprimir o exportar el **Documento Oficial en PDF** con membrete corporativo y espacios de firma.

---

# 9. Módulo 8: Panel Administrativo y Métricas Operativas (SLA)

El **Dashboard Administrativo** ofrece a la gerencia del laboratorio una vista ejecutiva en tiempo real sobre el desempeño del taller y el cumplimiento de los tiempos prometidos a los clientes:
* **Indicadores de Cumplimiento SLA:** Tarjetas superiores que contabilizan el total de órdenes activas, órdenes cerradas, órdenes sin asignar y alertas de tickets con SLA vencido.
* **Balance de Carga por Técnico Especialista:** Gráfico comparativo que muestra cuántas órdenes activas y cuántas finalizadas tiene cada técnico del laboratorio, facilitando la asignación equitativa de nuevos ingresos.
* **Matriz Maestra Multi-Estado:** Tabla interactiva con filtros rápidos por estado (*Recibido, En Diagnóstico, En Taller, Listo para Entrega, Entregado/Cerrado*) y buscador instantáneo por código, cliente o equipo.

---

# 10. Módulo 9: Configuración Integral, SMTP, Respaldos y Auditoría

Desde el módulo de **Configuración**, el Administrador gestiona los parámetros críticos de operación, seguridad y continuidad de negocio:

| Sección de Configuración | Función y Capacidades Principales |
| :--- | :--- |
| **Identidad Corporativa** | Actualización de razón social, NIT, teléfonos, dirección física y URL del host del portal público para los enlaces enviados por correo. |
| **Gestión de Usuarios y Roles** | Creación de nuevos operadores o técnicos, edición de datos de contacto, activación/inactivación de cuentas y restablecimiento seguro de contraseñas. |
| **Servidor de Correo Saliente (SMTP)** | Configuración del host SMTP (ej. `smtp.gmail.com`), puerto (`465`/`587`), cuenta emisora y contraseña de aplicación (almacenada con cifrado autenticado en el servidor), incluyendo botón de prueba de envío en vivo. |
| **Respaldos de Base de Datos (Backups)** | Panel de mantenimiento que muestra el estado del programador automático de copias (ejecutado al iniciar y cada 24 horas mediante SQLite `VACUUM INTO`) y permite descargar o restaurar instantáneamente un archivo `.sqlite` consistente. |
| **Historial de Cambios y Auditoría** | Registro inmutable de las operaciones críticas realizadas en el servidor (usuario, fecha, hora, ruta afectada y acción) junto con la bitácora de correos electrónicos despachados. |

---

# 11. Módulo 10: Portal de Consulta Pública para Clientes

El **Portal de Consulta Pública (`/consulta`)** permite a cualquier cliente verificar en línea el avance real de su equipo desde su computador o teléfono móvil, utilizando el enlace recibido por correo electrónico o accediendo desde la pantalla principal.

## 11.1 Privacidad y Búsqueda por Código Exacto
Para proteger la privacidad de la información, el buscador público exige digitar el **código exacto de la orden de servicio** y omite datos sensibles como el documento de identidad, teléfono del propietario o el PIN de desbloqueo del equipo.

## 11.2 Información Desplegada al Cliente en Tiempo Real
1. **Estado Actual y Datos del Equipo:** Insignia visual del estado de la orden (*En Proceso / Finalizado*), tipo de servicio, marca, modelo y número de serie.
2. **Diagnóstico Inicial de Recepción (OT):** Dictamen preliminar emitido por el laboratorio y checklist del estado físico y accesorios registrados al ingreso.
3. **Bitácora Técnica y Resultados de Tests de Calidad (QA):** Detalle de los procedimientos realizados, insumos aplicados y el estado de aprobación de las 10 pruebas de control de calidad (*Estrés térmico, Salud de disco SMART, Puertos, Conectividad, Batería, Teclado/Touchpad, Malware, Drivers, Inicio y Temporales*).
4. **Repuestos Instalados:** Listado transparente de componentes o piezas reemplazadas durante el servicio.
5. **Acta de Entrega, Garantía y Recomendaciones de Cuidado:** Estado operativo de salida, vigencia de la garantía otorgada, observaciones finales y pautas recomendadas para preservar la vida útil del equipo.
6. **Galería Fotográfica de Evidencias:** Miniaturas interactivas de las fotos tomadas en recepción, taller y pruebas, con visor modal de ampliación en alta resolución.

---

# 12. Glosario de Términos Técnicos y Operativos

| Término / Sigla | Definición en el Contexto de la Plataforma de Gestión de Tickets |
| :--- | :--- |
| **Acta de Entrega Oficial** | Documento formal en PDF generado al finalizar una orden, que certifica los trabajos realizados, la garantía otorgada y la conformidad del cliente. |
| **Bitácora Técnica** | Registro pormenorizado de los procedimientos de hardware y software, insumos consumidos y repuestos instalados durante la intervención en taller. |
| **Hoja de Vida del Equipo** | Expediente histórico asociado al número de serie de una máquina que recopila todas sus especificaciones y mantenimientos previos. |
| **Mantenimiento Correctivo** | Servicio técnico orientado a diagnosticar y reparar una falla, avería o mal funcionamiento existente en un equipo. |
| **Mantenimiento Preventivo** | Servicio periódico programado de limpieza física interna, recambio de pasta térmica y optimización lógica para evitar fallas futuras. |
| **Orden de Trabajo (OT)** | Formato técnico inicial donde se documenta el diagnóstico preliminar, el estado físico de recepción y los accesorios entregados por el cliente. |
| **Protocolo QA (Quality Assurance)** | Conjunto de pruebas diagnósticas pre-entrega (temperatura, salud SMART de disco, memoria, periféricos y red) que validan el óptimo funcionamiento del equipo. |
| **SLA (Service Level Agreement)** | Acuerdo de Nivel de Servicio que define el tiempo máximo objetivo para resolver una incidencia según su nivel de prioridad (Baja, Media, Alta o Crítica). |
| **SMTP** | Protocolo estándar de red configurado en la plataforma para el envío automático de notificaciones por correo electrónico al radicar y cerrar órdenes. |
