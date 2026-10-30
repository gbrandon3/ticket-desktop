CREATE TABLE "auditoria_cambios" (
	"id" serial PRIMARY KEY,
	"usuario_id" integer,
	"usuario_nombre" text NOT NULL,
	"metodo" text NOT NULL,
	"ruta" text NOT NULL,
	"fecha" text DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "clientes" (
	"id" serial PRIMARY KEY,
	"tipo_documento" text NOT NULL,
	"numero_documento" text NOT NULL,
	"nombre_completo" text NOT NULL,
	"telefono" text NOT NULL,
	"email" text,
	"direccion" text NOT NULL,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "configuracion_empresa" (
	"id" serial PRIMARY KEY,
	"nombre_empresa" text DEFAULT 'Santi Inc' NOT NULL,
	"slogan" text,
	"nit" text,
	"telefono" text,
	"email" text,
	"direccion" text,
	"ciudad" text,
	"logo_base64" text,
	"smtp_host" text DEFAULT 'smtp.gmail.com',
	"smtp_port" integer DEFAULT 465,
	"smtp_user" text,
	"smtp_pass" text,
	"smtp_api_url" text,
	"portal_host_url" text DEFAULT 'http://localhost:3000',
	"color_primario" text DEFAULT '#0F172A',
	"color_secundario" text DEFAULT '#0284C7',
	"is_setup_completed" boolean DEFAULT false
);

CREATE TABLE "equipos" (
	"id" serial PRIMARY KEY,
	"cliente_id" integer NOT NULL,
	"tipo_equipo" text NOT NULL,
	"marca" text NOT NULL,
	"modelo" text NOT NULL,
	"numero_serie" text NOT NULL,
	"sistema_operativo" text,
	"procesador" text,
	"memoria_ram" text,
	"almacenamiento" text,
	"tarjeta_grafica" text,
	"estado_equipo" text DEFAULT 'OPERATIVO',
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "formato_acta_entrega" (
	"id" serial PRIMARY KEY,
	"orden_id" integer NOT NULL,
	"estado_operatividad" text DEFAULT 'OPERATIVO' NOT NULL,
	"observaciones" text,
	"recomendaciones_cuidado" text,
	"garantia_dias" integer DEFAULT 30,
	"persona_recibe_nombre" text NOT NULL,
	"persona_recibe_documento" text NOT NULL,
	"check_conformidad" boolean DEFAULT false,
	"firma_digital_base64" text,
	"fecha_entrega" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "formato_actividades" (
	"id" serial PRIMARY KEY,
	"orden_id" integer NOT NULL,
	"procedimientos_realizados" text,
	"pasta_termica" boolean DEFAULT false,
	"alcohol_isopropilico" boolean DEFAULT false,
	"sopleteado_contactos" boolean DEFAULT false,
	"brocha_antiestatica" boolean DEFAULT false,
	"pano_microfibra" boolean DEFAULT false,
	"depuracion_temporales" boolean DEFAULT false,
	"optimizacion_inicio" boolean DEFAULT false,
	"escaneo_malware" boolean DEFAULT false,
	"actualizacion_drivers" boolean DEFAULT false,
	"comprobacion_disco" boolean DEFAULT false,
	"qa_estres_termico" boolean DEFAULT false,
	"qa_puertos" boolean DEFAULT false,
	"qa_conectividad" boolean DEFAULT false,
	"qa_bateria" boolean DEFAULT false,
	"qa_teclado_touchpad" boolean DEFAULT false,
	"costo_mano_obra" double precision DEFAULT 0,
	"fecha_actividad" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "formato_ot" (
	"id" serial PRIMARY KEY,
	"orden_id" integer NOT NULL,
	"diagnostico_preliminar" text,
	"herramientas_chips" text DEFAULT '[]',
	"tiempo_estimado_entrega" text,
	"accesorio_cargador" boolean DEFAULT false,
	"accesorio_cable_poder" boolean DEFAULT false,
	"accesorio_mouse" boolean DEFAULT false,
	"accesorio_maletin" boolean DEFAULT false,
	"encendido_inicial" boolean DEFAULT true,
	"estado_carcasa" text,
	"pin_contrasena" text
);

CREATE TABLE "fotos_evidencia" (
	"id" serial PRIMARY KEY,
	"orden_id" integer NOT NULL,
	"etapa" text NOT NULL,
	"ruta_o_bytes_base64" text NOT NULL,
	"nota_tecnica" text,
	"fecha_captura" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "notificaciones_auditoria" (
	"id" serial PRIMARY KEY,
	"destinatario" text NOT NULL,
	"asunto" text NOT NULL,
	"evento" text NOT NULL,
	"estado" text NOT NULL,
	"fecha_envio" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "ordenes" (
	"id" serial PRIMARY KEY,
	"codigo_orden" text NOT NULL,
	"cliente_id" integer NOT NULL,
	"equipo_id" integer NOT NULL,
	"tecnico_id" integer,
	"solicitante_id" integer,
	"tipo_servicio" text NOT NULL,
	"categoria_falla" text NOT NULL,
	"prioridad" text NOT NULL,
	"titulo" text NOT NULL,
	"descripcion" text NOT NULL,
	"estado" text DEFAULT 'RECIBIDO',
	"fecha_ingreso" text DEFAULT CURRENT_TIMESTAMP,
	"fecha_limite_sla" text,
	"fecha_cierre" text
);

CREATE TABLE "repuestos_orden" (
	"id" serial PRIMARY KEY,
	"orden_id" integer NOT NULL,
	"referencia" text NOT NULL,
	"cantidad" integer DEFAULT 1 NOT NULL,
	"precio_unitario" double precision DEFAULT 0 NOT NULL,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "tipos_falla" (
	"id" serial PRIMARY KEY,
	"tipo_servicio" text NOT NULL,
	"nombre" text NOT NULL,
	"descripcion" text,
	"activo" boolean DEFAULT true,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "usuarios" (
	"id" serial PRIMARY KEY,
	"nombre" text NOT NULL,
	"email" text NOT NULL,
	"password" text NOT NULL,
	"documento" text NOT NULL,
	"telefono" text NOT NULL,
	"rol" text NOT NULL,
	"activo" boolean DEFAULT true NOT NULL,
	"created_at" text DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX "idx_auditoria_fecha" ON "auditoria_cambios" ("fecha");
CREATE UNIQUE INDEX "clientes_documento_unique" ON "clientes" ("numero_documento");
CREATE UNIQUE INDEX "ordenes_codigo_unique" ON "ordenes" ("codigo_orden");
CREATE UNIQUE INDEX "tipos_falla_nombre_unique" ON "tipos_falla" ("nombre");
CREATE UNIQUE INDEX "usuarios_email_unique" ON "usuarios" ("email");
ALTER TABLE "auditoria_cambios" ADD CONSTRAINT "auditoria_cambios_usuario_id_usuarios_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE SET NULL;
ALTER TABLE "equipos" ADD CONSTRAINT "equipos_cliente_id_clientes_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "clientes"("id") ON DELETE CASCADE;
ALTER TABLE "formato_acta_entrega" ADD CONSTRAINT "formato_acta_entrega_orden_id_ordenes_id_fkey" FOREIGN KEY ("orden_id") REFERENCES "ordenes"("id") ON DELETE CASCADE;
ALTER TABLE "formato_actividades" ADD CONSTRAINT "formato_actividades_orden_id_ordenes_id_fkey" FOREIGN KEY ("orden_id") REFERENCES "ordenes"("id") ON DELETE CASCADE;
ALTER TABLE "formato_ot" ADD CONSTRAINT "formato_ot_orden_id_ordenes_id_fkey" FOREIGN KEY ("orden_id") REFERENCES "ordenes"("id") ON DELETE CASCADE;
ALTER TABLE "fotos_evidencia" ADD CONSTRAINT "fotos_evidencia_orden_id_ordenes_id_fkey" FOREIGN KEY ("orden_id") REFERENCES "ordenes"("id") ON DELETE CASCADE;
ALTER TABLE "ordenes" ADD CONSTRAINT "ordenes_cliente_id_clientes_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "clientes"("id");
ALTER TABLE "ordenes" ADD CONSTRAINT "ordenes_equipo_id_equipos_id_fkey" FOREIGN KEY ("equipo_id") REFERENCES "equipos"("id");
ALTER TABLE "ordenes" ADD CONSTRAINT "ordenes_tecnico_id_usuarios_id_fkey" FOREIGN KEY ("tecnico_id") REFERENCES "usuarios"("id");
ALTER TABLE "ordenes" ADD CONSTRAINT "ordenes_solicitante_id_usuarios_id_fkey" FOREIGN KEY ("solicitante_id") REFERENCES "usuarios"("id");
ALTER TABLE "repuestos_orden" ADD CONSTRAINT "repuestos_orden_orden_id_ordenes_id_fkey" FOREIGN KEY ("orden_id") REFERENCES "ordenes"("id") ON DELETE CASCADE;