# Santi Inc — Tickets App

Gestión de ingreso, diagnóstico, mantenimiento y entrega de equipos. Flutter para Windows y web; API Express con SQLite integrado en Node.js.

## Ejecutar

Requiere Node.js 22.13 o superior (recomendado Node.js 24) y npm. Para desarrollo se verificó Flutter 3.47.5 con Dart 3.13.4.

```powershell
npm ci
npm start
```

El servidor escucha en http://localhost:3000. Si existe build/web, sirve la aplicación web. La base se crea en data/tickets.sqlite. Complete el asistente inicial una sola vez; las contraseñas nuevas requieren entre 8 y 256 caracteres.

Para compilar y probar el frontend:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build web
flutter build windows
```

## Configuración del servidor

- PORT: puerto HTTP, predeterminado 3000.
- CORS_ORIGINS: orígenes web permitidos separados por comas, por ejemplo https://taller.example. Localhost HTTP y clientes sin cabecera Origin están permitidos.
- TICKETS_DB_PATH: ruta SQLite alternativa; :memory: se usa en pruebas.
- BACKUP_INTERVAL_HOURS: intervalo automático en horas; 24 por defecto y 0 para desactivar. Se ejecuta al iniciar y mientras el servidor siga encendido.
- TICKETS_BACKUP_DIR: directorio de respaldos; predeterminado backups/.
- TICKETS_SECRET_KEY_FILE: archivo de clave de 32 bytes para cifrado SMTP; predeterminado data/smtp.key. Se genera al guardar o migrar un secreto.

Esta entrega está orientada a uso escolar local mediante HTTP; HTTPS no se configuró por decisión del proyecto. Windows utiliza localhost:3000 de forma predeterminada; configurar otra URL requiere pasar baseUrl al repositorio API. Las sesiones se mantienen en memoria por ocho horas: reiniciar el servidor exige volver a iniciar sesión.

## Seguridad y flujo

Las rutas internas requieren Authorization: Bearer TOKEN. El login devuelve el token y datos del usuario sin contraseña. La API aplica permisos de administrador y restringe al técnico a órdenes asignadas. Contraseñas antiguas se migran a scrypt con sal al iniciar; SMTP se cifra con AES-256-GCM y nunca se devuelve al cliente. El valor ******** indica que existe una credencial guardada; guardarlo o dejar el campo vacío conserva la anterior.

El flujo permite avanzar un estado a la vez: RECIBIDO → EN_DIAGNOSTICO → EN_TALLER → LISTO_ENTREGA. El cierre exige acta, receptor y conformidad. Una orden ENTREGADO_CERRADO no acepta cambios. La consulta pública admite únicamente un código de orden exacto y omite identidad de cliente, técnico y PIN del equipo. Las órdenes nuevas incluyen un sufijo aleatorio de 128 bits en su código; las antiguas conservan su código previo. Trate el código completo como una credencial de consulta.

## Pruebas del backend

```powershell
npm test
# Alternativa sin npm en PATH:
node --test server/tests/api.test.js
```

Para ejecutar la verificación local completa en PowerShell: `./scripts/validar.ps1`. Agregue `-GenerarPdf` para guardar documentos de demostración en output/pdf/. El workflow .github/workflows/pruebas.yml ejecutará las verificaciones al subir cambios a GitHub; no se ejecutó remotamente en esta revisión.

Las pruebas usan SQLite en memoria o archivos temporales y no modifican la base real. Cubren setup, login, permisos, cierre, consulta pública, rollback, cifrado SMTP y apertura de respaldos.

## Respaldar y restaurar

```powershell
npm run backup
# Alternativa:
node server/backup.js
```

El respaldo consistente se guarda en backups/. La copia local crea un archivo .sqlite.key junto al respaldo cuando existe una clave SMTP. Conserve ambos archivos juntos. Guarde también data/smtp.key (o TICKETS_SECRET_KEY_FILE) en un lugar protegido; sin esa clave no podrá recuperar el secreto SMTP. Un respaldo previo a la migración puede contener contraseñas en texto plano.

Para restaurar: detenga el servidor, conserve una copia de la base actual, sustituya data/tickets.sqlite por el respaldo elegido y retire los archivos tickets.sqlite-wal y tickets.sqlite-shm de la base anterior con el servidor detenido. Restaure la clave SMTP correspondiente (copie el archivo .sqlite.key elegido como data/smtp.key) y vuelva a iniciar. No sobrescriba una base en uso. Verifique login y consulta de órdenes después de restaurar.

El servidor genera un respaldo al iniciar y cada 24 horas mientras está encendido. No elimina automáticamente copias anteriores. Configuración → Respaldo & Datos permite descargar una copia SQLite; el JSON de esa pantalla es una exportación de datos y no sustituye el respaldo restaurable.

## Código

- server.js: inicio y cierre del proceso.
- server/app.js: Express, CORS y montaje de rutas.
- server/routes/: configuración, usuarios, clientes, equipos, órdenes, taller, métricas, consulta, auditoría, catálogo y correo.
- server/security.js: contraseñas, sesiones y permisos.
- server/validation.js: validaciones, estados y transacciones.
- server/secrets.js: cifrado SMTP.
- server/change-audit.js: historial de modificaciones exitosas, visible en Configuración → Historial de Cambios.
- server/backup-scheduler.js: copias automáticas y estado.
- server/db.js: esquema e inicialización SQLite.
- lib/: aplicación Flutter.

Consulte CONTEXTO.md para el estado técnico del proyecto.

## Entrega escolar

Los paquetes finales se encuentran en releases/: tickets_app_windows_x64.zip, tickets_app_web_release.zip y tickets_app_backend.zip. El backend incluye la web compilada y dependencias de Node, pero no contiene bases de datos ni credenciales. Descomprímalo en una carpeta y ejecute `node server.js` con Node.js 24. Abra http://localhost:3000 o ejecute tickets_app.exe desde el paquete Windows. Complete el setup si usa una carpeta nueva.

Las pruebas de correo usan SMTP simulado; la entrega real de correo requiere configurar su cuenta en la aplicación. La impresión física requiere una impresora disponible. Los PDF de demostración se revisaron visualmente y no contienen datos reales.

Para volver a generar los ZIP después de compilar: `./scripts/empaquetar.ps1`. Los ZIP antiguos de la raíz no son la entrega actual; utilice los de releases/.

Para generar únicamente el release web con backend y dependencias incluidos: `./scripts/empaquetar_web.ps1`.
Descomprima `releases/tickets_app_web_release.zip` y ejecute `npm start` en esa carpeta: sirve la API y el frontend juntos en http://localhost:3000. También puede abrir `iniciar_web.cmd` en Windows. No requiere Flutter ni instalar dependencias en el equipo de destino; requiere Node.js 22.13 o superior.
