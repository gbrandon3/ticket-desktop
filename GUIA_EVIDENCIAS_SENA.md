# 📘 MANUAL DE LABORATORIO Y GUÍA DE EVIDENCIAS — SENA
## Operación y Gestión de Taller de Servicio Técnico en Plataforma Santi Inc

```
  ╔════════════════════════════════════════════════════════════════════════════════════════╗
  ║  GUÍA DE TRABAJO EN EQUIPO (3 APRENDICES POR MESA)                                     ║
  ║  • Aprendiz 1: Rol Administrador (Gestión, Catálogos, Control y Auditoría)             ║
  ║  • Aprendiz 2: Rol Operador (Atención al Cliente, Recepción, Inventario y Entrega)     ║
  ║  • Aprendiz 3: Rol Técnico (Mesa de Taller, Diagnóstico, Repuestos y Cierre Técnico)   ║
  ╚════════════════════════════════════════════════════════════════════════════════════════╝
```

---

## 🧭 MAPA DE RUTA DE LA PRÁCTICA

```
 [1. Setup Inicial] ──► [2. Crear Usuarios] ──► [3. Catálogo Fallas] ──► [4. Clientes] ──► [5. Inventario]
        │
        ▼
 [6. Radicar 3 Incidencias] ──► [7. Flujo Técnico de Taller] ──► [8. Dashboard Admin] ──► [9. Consulta Pública]
```

---

## 🚀 PASO 1: Primer Inicio y Configuración de Empresa (Setup Wizard)
* **¿Quién lo hace?:** Aprendiz 1 (Administrador).  
* **Objetivo:** Inicializar la base de datos con los datos oficiales de Santi Inc.

### 📍 Instrucciones paso a paso:
1. Ejecuta la aplicación. Como la base de datos está limpia, aparecerá automáticamente el **Asistente de Configuración (Setup Wizard)**.
2. En la sección **Datos de la Empresa**, copia y pega la siguiente información:
   * **Nombre / Razón Social:** `Santi Inc - Taller de Soporte Técnico`
   * **NIT / Documento:** `901876543-2`
   * **Teléfono:** `3109876543`
   * **Dirección:** `Cra. 45 # 12 - 34, Laboratorio de Cómputo`
   * **Email:** `taller@santi-inc.com`
3. En la sección **Cuenta Administrador**, define los datos del Aprendiz 1:
   * **Nombre Completo:** *(Tu nombre completo)*
   * **Documento:** *(Tu número de cédula o TI)*
   * **Teléfono:** `3001112233`
   * **Correo electrónico:** `admin@santi.com`
   * **Contraseña:** `Admin1234*` *(o una que recuerdes fácilmente)*
4. **NO des clic en finalizar todavía**. Toma la primera captura:

---
> ### 📸 CAPTURA 1: Pantalla del Asistente (Setup Wizard) Diligenciado
> *Asegúrate de que se vean los campos llenos con los datos de Santi Inc antes de guardar.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

5. Ahora sí, haz clic en el botón azul **"Finalizar y Comenzar"**. El sistema guardará los datos e iniciará sesión automáticamente en el Dashboard.

---

## 👥 PASO 2: Creación de Usuarios y Asignación de Roles
* **¿Quién lo hace?:** Aprendiz 1 (Administrador).  
* **Objetivo:** Dar de alta a los compañeros de grupo con sus roles estrictos en el sistema.

### 📍 Instrucciones paso a paso:
1. En el menú lateral o superior, haz clic en **Configuración**.
2. Desplázate a la pestaña o sección **Gestión de Usuarios**.
3. Haz clic en el botón verde **"+ Nuevo Usuario"**:
   * **Usuario 1 (Para el Aprendiz 2 - Operador):**
     * **Nombre:** *(Nombre del Aprendiz 2)*
     * **Documento:** *(Cédula del Aprendiz 2)*
     * **Email:** `operador@santi.com`
     * **Contraseña:** `Operador123*`
     * **Rol:** Selecciona en la lista desplegable `Operador`
     * Clic en **Guardar Usuario**.
   * **Usuario 2 (Para el Aprendiz 3 - Técnico):**
     * **Nombre:** *(Nombre del Aprendiz 3)*
     * **Documento:** *(Cédula del Aprendiz 3)*
     * **Email:** `tecnico@santi.com`
     * **Contraseña:** `Tecnico123*`
     * **Rol:** Selecciona en la lista desplegable `Técnico`
     * Clic en **Guardar Usuario**.

---
> ### 📸 CAPTURA 2: Tabla de Usuarios con los 3 Roles Creados
> *Debe verse la tabla con las 3 filas: Administrador, Operador y Técnico con sus etiquetas de rol.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

---

## 🏷️ PASO 3: Catálogo de Tipos de Falla
* **¿Quién lo hace?:** Aprendiz 1 (Administrador).  
* **Objetivo:** Definir las categorías de fallas que se usarán en el taller.

### 📍 Instrucciones paso a paso:
1. Dentro de la pantalla de **Configuración**, haz clic en la pestaña **Catálogo de Fallas**.
2. Haz clic en **"+ Nuevo Tipo de Falla"** y crea las siguientes:
   * **Falla 1:**
     * **Nombre:** `Falla de Hardware y Pantalla`
     * **Categoría:** `Hardware`
     * **Descripción:** `Problemas de encendido, pantalla rota o sin señal de video.`
   * **Falla 2:**
     * **Nombre:** `Mantenimiento Preventivo y Limpieza`
     * **Categoría:** `Preventivo`
     * **Descripción:** `Limpieza física, soplado de polvo y cambio de pasta térmica.`
   * **Falla 3:**
     * **Nombre:** `Falla de Disco y Sistema Operativo`
     * **Categoría:** `Software`
     * **Descripción:** `Pantallazos azules, lentitud extrema o sectores defectuosos.`

---
> ### 📸 CAPTURA 3: Catálogo con los Tipos de Falla Activos
> *Debe verse la lista con los 3 tipos de falla creados en la tabla.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

---

## 👤 PASO 4: Registrar Clientes en el Sistema
* **¿Quién lo hace?:** Aprendiz 2 (Operador) o Aprendiz 1 (Admin).  
* **Objetivo:** Registrar las personas o dependencias dueñas de los equipos.

### 📍 Instrucciones paso a paso:
1. En el menú, dirígete al módulo de **Clientes** (o dentro de la opción de crear clientes).
2. Haz clic en **"+ Nuevo Cliente"** y registra los siguientes 3 clientes de prueba:
   * **Cliente 1:**
     * **Nombre:** `María García`
     * **Cédula / Documento:** `1020345678`
     * **Teléfono:** `3001234567`
     * **Email:** `maria.garcia@gmail.com`
     * **Dirección / Ubicación:** `Sala de Sistemas 2`
   * **Cliente 2:**
     * **Nombre:** `Carlos Pérez`
     * **Cédula / Documento:** `987654321`
     * **Teléfono:** `3118765432`
     * **Email:** `carlos.perez@rectoria.edu.co`
     * **Dirección / Ubicación:** `Oficina de Rectoría`
   * **Cliente 3:**
     * **Nombre / Razón Social:** `Empresa XYZ S.A.S.`
     * **NIT:** `900123456-1`
     * **Teléfono:** `3205559988`
     * **Email:** `soporte@xyz.com`
     * **Dirección / Ubicación:** `Área de Contabilidad - Piso 3`

---
> ### 📸 CAPTURA 4.1: Formulario de Registro de Cliente Lleno
> *Captura mientras estás registrando a María García antes de guardar.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```

> ### 📸 CAPTURA 4.2: Tabla del Módulo de Clientes con los 3 Registrados
> *Debe verse la tabla con María García, Carlos Pérez y Empresa XYZ.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

---

## 💻 PASO 5: Registrar Equipos en Inventario
* **¿Quién lo hace?:** Aprendiz 2 (Operador).  
* **Objetivo:** Asociar los equipos a sus respectivos propietarios en la base de datos.

### 📍 Instrucciones paso a paso:
1. En el menú de navegación, haz clic en **Inventario de Equipos**.
2. Haz clic en el botón superior **"+ Nuevo Equipo"** y crea estos 3 equipos:
   * **Equipo 1 (Portátil HP):**
     * **Tipo:** `Portátil`
     * **Marca:** `HP`
     * **Modelo:** `Pavilion 15-dw1024`
     * **Número de Serie:** `HP-998877`
     * **Procesador / RAM:** `Intel Core i5 11va Gen / 16 GB DDR4`
     * **Almacenamiento:** `512 GB SSD NVMe`
     * **Cliente Asignado:** Selecciona a `María García`
   * **Equipo 2 (PC de Mesa):**
     * **Tipo:** `PC de Mesa (Torre)`
     * **Marca:** `Genérico / Clon`
     * **Modelo / Nombre del equipo:** `CPU Contabilidad`
     * **Número de Serie:** *(Déjalo vacío o pon S/N)*
     * **Procesador / RAM:** `AMD Ryzen 5 4600G / 8 GB RAM`
     * **Cliente Asignado:** Selecciona a `Empresa XYZ`
   * **Equipo 3 (All-in-One):**
     * **Tipo:** `All-in-One`
     * **Marca:** `Dell`
     * **Modelo:** `Inspiron 24 5400 AIO`
     * **Número de Serie:** `DELL-AIO-4433`
     * **Procesador / RAM:** `Intel Core i7 1165G7 / 16 GB RAM`
     * **Cliente Asignado:** Selecciona a `Carlos Pérez`

---
> ### 📸 CAPTURA 5.1: Formulario de Nuevo Equipo Diligenciado
> *Captura mientras estás registrando el Portátil HP antes de guardar.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```

> ### 📸 CAPTURA 5.2: Tabla de Inventario con los 3 Equipos
> *Debe verse la tabla de inventario mostrando el Portátil, el PC de Mesa y el All-in-One.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

---

## 📋 PASO 6: Radicar 3 Incidencias en la Plataforma
* **¿Quién lo hace?:** Aprendiz 2 (Operador).  
* **Objetivo:** Simular la recepción en ventanilla de 3 órdenes con diferentes naturalezas de servicio.

### 🔴 Caso A: Incidencia 1 — Correctiva (Falla de Hardware)
1. Haz clic en el botón principal **"Radicar / Crear Incidencia"**.
2. **Paso 1 del Asistente:**
   * Selecciona Cliente: `María García`.
   * Tipo de Mantenimiento: Haz clic en **Correctivo**.
   * Categoría: `Hardware`.
   * Título: `Pantalla no enciende`.
   * Prioridad: `Alta`.
   * 👉 *Toma la Captura 6.1 aquí*.
3. Haz clic en **Siguiente** ➔ **Paso 2:**
   * Selecciona el equipo de María: `Portátil HP (HP-998877)`.
   * En "Descripción de la Falla": `El equipo enciende las luces del teclado pero la pantalla se queda completamente en negro. No da video externo por HDMI.`
   * 👉 *Toma la Captura 6.2 aquí*.
4. Haz clic en **Siguiente** ➔ **Paso 3:**
   * Marca los accesorios recibidos: `[X] Cargador original`, `[X] Cable de poder`, `[X] Funda`.
   * Adjunta una foto del equipo en recepción (cualquier imagen de prueba de tu equipo).
   * 👉 *Toma la Captura 6.3 aquí*.
5. Haz clic en **Siguiente** ➔ **Paso 4:**
   * En "Asignar Técnico Responsable", selecciona al **Técnico** (Aprendiz 3).
   * Revisa el resumen general.
   * 👉 *Toma la Captura 6.4 aquí*.
6. Haz clic en **"Crear y Radicar Orden"**.

---
> ### 📸 CAPTURAS 6.1 a 6.4: Los 4 Pasos del Asistente de Radicación
> 
> **Paso 1: Datos y Tipo Correctivo**  
> `[ PEGA AQUÍ CAPTURA 6.1 ]`  
> 
> **Paso 2: Selección de Equipo y Detalle de Falla**  
> `[ PEGA AQUÍ CAPTURA 6.2 ]`  
> 
> **Paso 3: Accesorios y Fotografía de Ingreso**  
> `[ PEGA AQUÍ CAPTURA 6.3 ]`  
> 
> **Paso 4: Resumen y Asignación de Técnico**  
> `[ PEGA AQUÍ CAPTURA 6.4 ]`  
---

### 🟡 Caso B: Incidencia 2 — Preventiva (Mantenimiento Programado)
1. Haz clic de nuevo en **"Radicar / Crear Incidencia"**.
2. Selecciona Cliente: `Carlos Pérez`.
3. Tipo de Mantenimiento: Haz clic en **Preventivo**.
   * *💡 Observa cómo la interfaz cambia y genera el título de rutina preventiva automáticamente.*
4. Selecciona el equipo: `All-in-One Dell (DELL-AIO-4433)`.
5. Asigna al Técnico y haz clic en **"Crear y Radicar Orden"**.

---
> ### 📸 CAPTURA 6.5: Formulario de Incidencia Preventiva
> *Demuestra que en Preventivo el formulario adapta los campos para rutinas de mantenimiento.*
> 
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

### 🟢 Caso C: Incidencia 3 — Orden para Taller y Cierre Técnico
1. Haz clic en **"Radicar / Crear Incidencia"**.
2. Cliente: `Empresa XYZ S.A.S.`
3. Tipo: **Correctivo**.
4. Equipo: `PC de Mesa - CPU Contabilidad`.
5. Título: `Lentitud extrema y apagado por sobrecalentamiento`.
6. Prioridad: `Media`.
7. Asigna al Técnico y haz clic en **"Crear y Radicar Orden"**.

---

## 🔧 PASO 7: Atender la Incidencia 3 como Técnico (Flujo Completo)
* **¿Quién lo hace?:** Aprendiz 3 (Técnico).  
* **Objetivo:** Diagnosticar, ejecutar el mantenimiento, registrar evidencias y generar el acta oficial de entrega.

### 📍 Instrucciones paso a paso:
1. Cierra sesión de Administrador/Operador.
2. Inicia sesión con la cuenta de Técnico:
   * **Email:** `tecnico@santi.com`
   * **Contraseña:** `Tecnico123*`
3. En la pantalla verás las órdenes asignadas a ti. Localiza la **Incidencia 3 (CPU Contabilidad)**.
4. Haz clic en el botón azul **"Gestionar Mantenimiento"** (o entrar a la orden de taller).

---

### 📌 Pestaña 1: OT (Orden de Trabajo)
1. En **Diagnóstico Técnico Preliminar**, escribe:  
   `Disipador de calor completamente tupido de polvo. Pasta térmica del microprocesador reseca y endurecida. La CPU alcanza 92°C y se apaga por protección térmica.`
2. En **Herramientas utilizadas**, marca: *Kit de destornilladores, Soplador antiestático, Alcohol isopropílico*.
3. En **Estado físico del equipo**, marca: *Equipo con rayones leves en la tapa lateral*.
4. Haz clic en el botón **"Guardar Cambios de OT"**.

---
> ### 📸 CAPTURA 7.1: Pestaña OT con Diagnóstico y Herramientas Llenas
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

### 📌 Pestaña 2: Bitácora de Actividades y Repuestos
1. En el campo de **Procedimientos Realizados**, escribe:  
   `1. Desmontaje completo de la fuente y placa madre.`  
   `2. Soplado y limpieza de polvo en ventiladores y disipador.`  
   `3. Retiro de pasta térmica vieja con alcohol isopropílico.`  
   `4. Aplicación de pasta térmica Cooler Master MasterGel Pro.`  
   `5. Ensamblaje y prueba de estrés térmico durante 45 minutos (temperatura máxima estable en 64°C).`
2. En la sección **Repuestos / Insumos Utilizados**, haz clic en **"+ Agregar Repuesto"**:
   * **Repuesto:** `Pasta Térmica Cooler Master MasterGel`
   * **Cantidad:** `1`
   * **Costo Unitario:** `8000`
   * Clic en **Agregar a la orden**.
3. En la sección de **Checklists de Control de Calidad**, marca las casillas:
   * `[X] Limpieza interna y externa completada`
   * `[X] Pruebas de estrés y temperatura superadas`
   * `[X] Puertos USB y audio verificados`
4. Haz clic en **"Guardar Bitácora"**.

---
> ### 📸 CAPTURA 7.2: Pestaña Bitácora con Procedimientos, Repuesto ($8.000) y Checklists
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

### 📌 Pestaña 3: Galería de Fotos de Evidencia
1. En la sección **Fotos de Ingreso (Antes)**: Sube 1 foto que simule el equipo sucio o desarmado.
2. En la sección **Fotos del Trabajo (Después)**: Sube 1 foto que simule el equipo limpio o funcionando.

---
> ### 📸 CAPTURA 7.3: Galería de Fotos con las Evidencias Técnicas Cargadas
> ```
> ┌────────────────────────────────────────────────────────┐
> │                                                        │
> │             [ PEGA AQUÍ TU CAPTURA DE PANTALLA ]       │
> │                                                        │
> └────────────────────────────────────────────────────────┘
> ```
---

### 📌 Pestaña 4: Acta de Entrega y Cierre Oficial
1. En **Estado Final del Equipo**, selecciona: **Operativo**.
2. En **Recomendaciones al Cliente**, escribe:  
   `Ubicar la torre a mínimo 15 cm de la pared para garantizar flujo de aire. No colocar sobre alfombras. Programar próximo mantenimiento preventivo en 6 meses.`
3. En **Nombre de quien recibe a conformidad**, escribe: `Lic. Roberto Méndez - Jefe de Contabilidad`.
4. Marca la casilla: `[X] El cliente manifiesta su total conformidad con el servicio recibido`.
5. Haz clic en el botón verde grande **"Cerrar Incidencia y Generar Acta"**.
6. Luego haz clic en el botón azul **"Ver Documento Oficial"**.

---
> ### 📸 CAPTURA 7.4: Formulario de Cierre de Acta Listo
> `[ PEGA AQUÍ CAPTURA 7.4 ]`
> 
> ### 📸 CAPTURA 7.5: Documento Oficial en Pantalla
> `[ PEGA AQUÍ CAPTURA 7.5 ]`
> 
> ### 📸 CAPTURA 7.6: Vista Previa del PDF Oficial Generado para Impresión
> `[ PEGA AQUÍ CAPTURA 7.6 ]`
---

---

## 📊 PASO 8: Capturar el Dashboard de Administrador con Datos Vivos
* **¿Quién lo hace?:** Aprendiz 1 (Administrador).  
* **Objetivo:** Demostrar el impacto de la operación en los indicadores de gestión.

### 📍 Instrucciones paso a paso:
1. Cierra sesión de Técnico.
2. Inicia sesión con la cuenta de Administrador (`admin@santi.com`).
3. Ve a la pantalla principal (**Dashboard**).
4. Verifica que se visualicen los indicadores:
   * Tarjetas métricas de cumplimiento de SLA y tickets resueltos.
   * Carga de trabajo por técnico (el técnico tiene tickets asignados).
   * Tabla con las 3 incidencias en diferentes estados: una *Abierta/Pendiente*, una *En Diagnóstico* y una *Cerrada*.

---
> ### 📸 CAPTURA 8.1: Dashboard Principal con Gráficas y Métricas SLA
> `[ PEGA AQUÍ CAPTURA 8.1 ]`
> 
> ### 📸 CAPTURA 8.2: Tabla General de Incidencias mostrando los 3 Estados
> `[ PEGA AQUÍ CAPTURA 8.2 ]`
---

---

## 🔍 PASO 9: Portal de Consulta Pública (Trazabilidad para el Cliente)
* **¿Quién lo hace?:** Aprendiz 2 (Operador) o cualquiera del equipo.  
* **Objetivo:** Comprobar que cualquier cliente puede consultar el estado de su equipo por internet sin tener usuario en el sistema.

### 📍 Instrucciones paso a paso:
1. Cierra sesión completamente para regresar a la pantalla de **Login**.
2. En la parte inferior de la pantalla de Login, haz clic en el enlace:  
   👉 **"¿Quieres consultar el estado de tu equipo? Consulta pública"** (o "Consultar sin iniciar sesión").
3. En el formulario de búsqueda ingresa:
   * **Código de la Orden:** Ingresa el código de la Incidencia 3 (ejemplo: `TK-0003` o el número que le haya asignado el sistema).
   * **Número de Documento / NIT del Cliente:** `900123456-1`
4. Haz clic en el botón **"Buscar / Consultar Estado"**.
5. Observa cómo el sistema despliega la línea de tiempo completa del servicio: desde la recepción, el paso por el banco de trabajo, la solución y la fecha de entrega.

---
> ### 📸 CAPTURA 9.1: Formulario de Consulta Pública con los Datos Ingresados
> `[ PEGA AQUÍ CAPTURA 9.1 ]`
> 
> ### 📸 CAPTURA 9.2: Resultado de la Consulta Pública con la Trazabilidad del Equipo
> `[ PEGA AQUÍ CAPTURA 9.2 ]`
---

---

## ✅ MATRIZ DE CHEQUEO FINAL PARA CALIFICACIÓN

| # | Ítem Evaluado | Cumple (SÍ / NO) | Firma del Aprendiz Responsable |
| :-: | :--- | :---: | :---: |
| 1 | Setup Wizard de Santi Inc completado sin valores quemados | [  ] | _______________________ |
| 2 | Creación de roles estrictos: Admin, Operador y Técnico | [  ] | _______________________ |
| 3 | Catálogo con al menos 3 fallas técnicas | [  ] | _______________________ |
| 4 | Registro de los 3 clientes propuestos | [  ] | _______________________ |
| 5 | Registro de Portátil HP, PC de Mesa y All-in-One Dell | [  ] | _______________________ |
| 6 | Radicación de Orden Correctiva (con sus 4 capturas de paso) | [  ] | _______________________ |
| 7 | Radicación de Orden Preventiva (diferenciación de formulario) | [  ] | _______________________ |
| 8 | Bitácora técnica con procedimientos y repuesto de \$8.000 | [  ] | _______________________ |
| 9 | Galería fotográfica con evidencias de antes y después | [  ] | _______________________ |
| 10 | Cierre con Acta de Entrega y Documento Oficial generado | [  ] | _______________________ |
| 11 | Dashboard Admin con métricas de SLA actualizadas | [  ] | _______________________ |
| 12 | Consulta pública exitosa con código de ticket y documento | [  ] | _______________________ |

---

## ✍️ FIRMAS DE ENTREGA DE EVIDENCIA

___________________________________________              ___________________________________________  
**Firma Aprendiz 1 (Administrador)**                     **Firma Aprendiz 2 (Operador)**  
Doc:                                                     Doc:  

___________________________________________              ___________________________________________  
**Firma Aprendiz 3 (Técnico)**                          **Firma Instructor SENA Evaluador**  
Doc:                                                     Juicio: **APROBADO [  ] / NO APROBADO [  ]**  
