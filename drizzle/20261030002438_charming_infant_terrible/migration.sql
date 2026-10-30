CREATE TABLE `auditoria_cambios` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`usuario_id` integer,
	`usuario_nombre` text NOT NULL,
	`metodo` text NOT NULL,
	`ruta` text NOT NULL,
	`fecha` text DEFAULT (datetime('now')) NOT NULL,
	CONSTRAINT `fk_auditoria_cambios_usuario_id_usuarios_id_fk` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE SET NULL
);
--> statement-breakpoint
CREATE TABLE `clientes` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`tipo_documento` text NOT NULL,
	`numero_documento` text NOT NULL,
	`nombre_completo` text NOT NULL,
	`telefono` text NOT NULL,
	`email` text,
	`direccion` text NOT NULL,
	`created_at` text DEFAULT (datetime('now'))
);
--> statement-breakpoint
CREATE TABLE `configuracion_empresa` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`nombre_empresa` text DEFAULT 'Santi Inc' NOT NULL,
	`slogan` text,
	`nit` text,
	`telefono` text,
	`email` text,
	`direccion` text,
	`ciudad` text,
	`logo_base64` text,
	`smtp_host` text DEFAULT 'smtp.gmail.com',
	`smtp_port` integer DEFAULT 465,
	`smtp_user` text,
	`smtp_pass` text,
	`smtp_api_url` text,
	`portal_host_url` text DEFAULT 'http://localhost:3000',
	`color_primario` text DEFAULT '#0F172A',
	`color_secundario` text DEFAULT '#0284C7',
	`is_setup_completed` integer DEFAULT false
);
--> statement-breakpoint
CREATE TABLE `equipos` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`cliente_id` integer NOT NULL,
	`tipo_equipo` text NOT NULL,
	`marca` text NOT NULL,
	`modelo` text NOT NULL,
	`numero_serie` text NOT NULL,
	`sistema_operativo` text,
	`procesador` text,
	`memoria_ram` text,
	`almacenamiento` text,
	`tarjeta_grafica` text,
	`estado_equipo` text DEFAULT 'OPERATIVO',
	`created_at` text DEFAULT (datetime('now')),
	CONSTRAINT `fk_equipos_cliente_id_clientes_id_fk` FOREIGN KEY (`cliente_id`) REFERENCES `clientes`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `formato_acta_entrega` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`orden_id` integer NOT NULL,
	`estado_operatividad` text DEFAULT 'OPERATIVO' NOT NULL,
	`observaciones` text,
	`recomendaciones_cuidado` text,
	`garantia_dias` integer DEFAULT 30,
	`persona_recibe_nombre` text NOT NULL,
	`persona_recibe_documento` text NOT NULL,
	`check_conformidad` integer DEFAULT false,
	`firma_digital_base64` text,
	`fecha_entrega` text DEFAULT (datetime('now')),
	CONSTRAINT `fk_formato_acta_entrega_orden_id_ordenes_id_fk` FOREIGN KEY (`orden_id`) REFERENCES `ordenes`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `formato_actividades` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`orden_id` integer NOT NULL,
	`procedimientos_realizados` text,
	`pasta_termica` integer DEFAULT false,
	`alcohol_isopropilico` integer DEFAULT false,
	`sopleteado_contactos` integer DEFAULT false,
	`brocha_antiestatica` integer DEFAULT false,
	`pano_microfibra` integer DEFAULT false,
	`depuracion_temporales` integer DEFAULT false,
	`optimizacion_inicio` integer DEFAULT false,
	`escaneo_malware` integer DEFAULT false,
	`actualizacion_drivers` integer DEFAULT false,
	`comprobacion_disco` integer DEFAULT false,
	`qa_estres_termico` integer DEFAULT false,
	`qa_puertos` integer DEFAULT false,
	`qa_conectividad` integer DEFAULT false,
	`qa_bateria` integer DEFAULT false,
	`qa_teclado_touchpad` integer DEFAULT false,
	`costo_mano_obra` real DEFAULT 0,
	`fecha_actividad` text DEFAULT (datetime('now')),
	CONSTRAINT `fk_formato_actividades_orden_id_ordenes_id_fk` FOREIGN KEY (`orden_id`) REFERENCES `ordenes`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `formato_ot` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`orden_id` integer NOT NULL,
	`diagnostico_preliminar` text,
	`herramientas_chips` text DEFAULT '[]',
	`tiempo_estimado_entrega` text,
	`accesorio_cargador` integer DEFAULT false,
	`accesorio_cable_poder` integer DEFAULT false,
	`accesorio_mouse` integer DEFAULT false,
	`accesorio_maletin` integer DEFAULT false,
	`encendido_inicial` integer DEFAULT true,
	`estado_carcasa` text,
	`pin_contrasena` text,
	CONSTRAINT `fk_formato_ot_orden_id_ordenes_id_fk` FOREIGN KEY (`orden_id`) REFERENCES `ordenes`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `fotos_evidencia` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`orden_id` integer NOT NULL,
	`etapa` text NOT NULL,
	`ruta_o_bytes_base64` text NOT NULL,
	`nota_tecnica` text,
	`fecha_captura` text DEFAULT (datetime('now')),
	CONSTRAINT `fk_fotos_evidencia_orden_id_ordenes_id_fk` FOREIGN KEY (`orden_id`) REFERENCES `ordenes`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `notificaciones_auditoria` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`destinatario` text NOT NULL,
	`asunto` text NOT NULL,
	`evento` text NOT NULL,
	`estado` text NOT NULL,
	`fecha_envio` text DEFAULT (datetime('now'))
);
--> statement-breakpoint
CREATE TABLE `ordenes` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`codigo_orden` text NOT NULL,
	`cliente_id` integer NOT NULL,
	`equipo_id` integer NOT NULL,
	`tecnico_id` integer,
	`solicitante_id` integer,
	`tipo_servicio` text NOT NULL,
	`categoria_falla` text NOT NULL,
	`prioridad` text NOT NULL,
	`titulo` text NOT NULL,
	`descripcion` text NOT NULL,
	`estado` text DEFAULT 'RECIBIDO',
	`fecha_ingreso` text DEFAULT (datetime('now')),
	`fecha_limite_sla` text,
	`fecha_cierre` text,
	CONSTRAINT `fk_ordenes_cliente_id_clientes_id_fk` FOREIGN KEY (`cliente_id`) REFERENCES `clientes`(`id`),
	CONSTRAINT `fk_ordenes_equipo_id_equipos_id_fk` FOREIGN KEY (`equipo_id`) REFERENCES `equipos`(`id`),
	CONSTRAINT `fk_ordenes_tecnico_id_usuarios_id_fk` FOREIGN KEY (`tecnico_id`) REFERENCES `usuarios`(`id`),
	CONSTRAINT `fk_ordenes_solicitante_id_usuarios_id_fk` FOREIGN KEY (`solicitante_id`) REFERENCES `usuarios`(`id`)
);
--> statement-breakpoint
CREATE TABLE `repuestos_orden` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`orden_id` integer NOT NULL,
	`referencia` text NOT NULL,
	`cantidad` integer DEFAULT 1 NOT NULL,
	`precio_unitario` real DEFAULT 0 NOT NULL,
	`created_at` text DEFAULT (datetime('now')),
	CONSTRAINT `fk_repuestos_orden_orden_id_ordenes_id_fk` FOREIGN KEY (`orden_id`) REFERENCES `ordenes`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `tipos_falla` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`tipo_servicio` text NOT NULL,
	`nombre` text NOT NULL,
	`descripcion` text,
	`activo` integer DEFAULT true,
	`created_at` text DEFAULT (datetime('now'))
);
--> statement-breakpoint
CREATE TABLE `usuarios` (
	`id` integer PRIMARY KEY AUTOINCREMENT,
	`nombre` text NOT NULL,
	`email` text NOT NULL,
	`password` text NOT NULL,
	`documento` text NOT NULL,
	`telefono` text NOT NULL,
	`rol` text NOT NULL,
	`activo` integer DEFAULT true NOT NULL,
	`created_at` text DEFAULT (datetime('now'))
);
--> statement-breakpoint
CREATE INDEX `idx_auditoria_fecha` ON `auditoria_cambios` (`fecha`);--> statement-breakpoint
CREATE UNIQUE INDEX `clientes_documento_unique` ON `clientes` (`numero_documento`);--> statement-breakpoint
CREATE UNIQUE INDEX `ordenes_codigo_unique` ON `ordenes` (`codigo_orden`);--> statement-breakpoint
CREATE UNIQUE INDEX `tipos_falla_nombre_unique` ON `tipos_falla` (`nombre`);--> statement-breakpoint
CREATE UNIQUE INDEX `usuarios_email_unique` ON `usuarios` (`email`);