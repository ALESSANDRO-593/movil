--
-- PostgreSQL database dump
--

\restrict 1IksHpzXOcQ86r47S3O4gPm5XKDukzBd2Bo2sMCY4ZJkj9xp1iDn9ttfRctu2fy

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adjuntos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adjuntos (
    id integer NOT NULL,
    tipo character varying(30) NOT NULL,
    ruta character varying(300) NOT NULL,
    mime character varying(60) NOT NULL,
    tamano_bytes integer NOT NULL,
    hash character varying(64),
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT adjuntos_mime_check CHECK (((mime)::text = ANY ((ARRAY['image/jpeg'::character varying, 'image/png'::character varying])::text[]))),
    CONSTRAINT adjuntos_tamano_bytes_check CHECK ((tamano_bytes <= 5242880))
);


--
-- Name: adjuntos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.adjuntos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adjuntos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.adjuntos_id_seq OWNED BY public.adjuntos.id;


--
-- Name: alerta_historial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alerta_historial (
    id integer NOT NULL,
    alerta_id bigint NOT NULL,
    estado_anterior character varying(15),
    estado_nuevo character varying(15) NOT NULL,
    observacion text,
    usuario_id bigint,
    creado_en timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: alerta_historial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alerta_historial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alerta_historial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alerta_historial_id_seq OWNED BY public.alerta_historial.id;


--
-- Name: alertas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alertas (
    id integer NOT NULL,
    codigo character varying(15),
    laboratorio_id bigint NOT NULL,
    descripcion text NOT NULL,
    adjunto_id bigint,
    profesor_id bigint NOT NULL,
    estado character varying(15) DEFAULT 'Pendiente'::character varying NOT NULL,
    responsable_id bigint,
    ticket_id bigint,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT alertas_estado_check CHECK (((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'En revisión'::character varying, 'Resuelta'::character varying])::text[])))
);


--
-- Name: alertas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alertas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alertas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alertas_id_seq OWNED BY public.alertas.id;


--
-- Name: asignaciones_responsables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.asignaciones_responsables (
    id integer NOT NULL,
    tipo_solicitud_id bigint NOT NULL,
    carrera_id bigint,
    usuario_id bigint NOT NULL,
    vigente boolean DEFAULT true NOT NULL,
    semestre character varying(20),
    creado_en timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: asignaciones_responsables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.asignaciones_responsables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asignaciones_responsables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.asignaciones_responsables_id_seq OWNED BY public.asignaciones_responsables.id;


--
-- Name: carreras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carreras (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(150) NOT NULL
);


--
-- Name: carreras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.carreras_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carreras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.carreras_id_seq OWNED BY public.carreras.id;


--
-- Name: certificados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificados (
    id integer NOT NULL,
    estudiante_id bigint NOT NULL,
    tipo character varying(40) DEFAULT 'CERT_MATRICULA'::character varying NOT NULL,
    qr_id bigint NOT NULL,
    pdf_path character varying(300),
    fecha date DEFAULT CURRENT_DATE NOT NULL,
    hora time without time zone DEFAULT CURRENT_TIME NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    periodo_lectivo_codigo character varying(10),
    periodo_lectivo_nombre character varying(60),
    modalidad character varying(20),
    periodo_ingreso_codigo character varying(10),
    periodo_ingreso_nombre character varying(60),
    nivel_ingreso character varying(30),
    firmante_nombre character varying(150),
    firmante_cargo character varying(100)
);


--
-- Name: certificados_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificados_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificados_id_seq OWNED BY public.certificados.id;


--
-- Name: configuracion_sistema; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configuracion_sistema (
    id integer NOT NULL,
    clave character varying(60) NOT NULL,
    valor character varying(200) NOT NULL,
    descripcion character varying(200),
    actualizado_por character varying(50),
    actualizado_en timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: configuracion_sistema_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configuracion_sistema_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configuracion_sistema_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configuracion_sistema_id_seq OWNED BY public.configuracion_sistema.id;


--
-- Name: docentes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.docentes (
    id integer NOT NULL,
    cedula character varying(10) NOT NULL,
    nombre_docente character varying(150) NOT NULL,
    correo character varying(150) NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT docentes_cedula_check CHECK (((cedula)::text ~ '^[0-9]{10}$'::text))
);


--
-- Name: docentes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.docentes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: docentes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.docentes_id_seq OWNED BY public.docentes.id;


--
-- Name: estudiantes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estudiantes (
    id integer NOT NULL,
    cedula character varying(10) NOT NULL,
    nombres character varying(150) NOT NULL,
    carrera_id bigint NOT NULL,
    nivel character varying(30) NOT NULL,
    paralelo character varying(20) NOT NULL,
    estado_matricula character varying(20) NOT NULL,
    correo character varying(150) NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp with time zone DEFAULT now() NOT NULL,
    modalidad character varying(20) DEFAULT 'PRESENCIAL'::character varying NOT NULL,
    periodo_ingreso_id bigint,
    nivel_ingreso character varying(30) DEFAULT 'Primer nivel'::character varying NOT NULL,
    CONSTRAINT estudiantes_cedula_check CHECK (((cedula)::text ~ '^[0-9]{10}$'::text)),
    CONSTRAINT estudiantes_estado_matricula_check CHECK (((estado_matricula)::text = ANY ((ARRAY['MATRICULADO'::character varying, 'RETIRADO'::character varying, 'REPROBADO'::character varying, 'APROBADO'::character varying])::text[]))),
    CONSTRAINT estudiantes_modalidad_check CHECK (((modalidad)::text = ANY ((ARRAY['PRESENCIAL'::character varying, 'DUAL'::character varying, 'EN LINEA'::character varying, 'SEMIPRESENCIAL'::character varying])::text[])))
);


--
-- Name: estudiantes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estudiantes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estudiantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estudiantes_id_seq OWNED BY public.estudiantes.id;


--
-- Name: eventos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eventos (
    id integer NOT NULL,
    tipo character varying(50) NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    origen character varying(50),
    procesado boolean DEFAULT false NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: eventos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eventos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eventos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eventos_id_seq OWNED BY public.eventos.id;


--
-- Name: laboratorios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.laboratorios (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(100) NOT NULL,
    cantidad_equipos integer DEFAULT 0 NOT NULL
);


--
-- Name: laboratorios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.laboratorios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: laboratorios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.laboratorios_id_seq OWNED BY public.laboratorios.id;


--
-- Name: otp_codigos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.otp_codigos (
    id integer NOT NULL,
    cedula character varying(10) NOT NULL,
    correo character varying(150),
    codigo_hash character varying(255) NOT NULL,
    canal character varying(20) NOT NULL,
    expira_en timestamp with time zone NOT NULL,
    usado boolean DEFAULT false NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT otp_codigos_canal_check CHECK (((canal)::text = ANY ((ARRAY['chatbot'::character varying, 'panel_recovery'::character varying])::text[])))
);


--
-- Name: otp_codigos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.otp_codigos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: otp_codigos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.otp_codigos_id_seq OWNED BY public.otp_codigos.id;


--
-- Name: periodos_academicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.periodos_academicos (
    id integer NOT NULL,
    codigo character varying(10) NOT NULL,
    nombre character varying(60) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    vigente boolean DEFAULT false NOT NULL
);


--
-- Name: periodos_academicos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.periodos_academicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: periodos_academicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.periodos_academicos_id_seq OWNED BY public.periodos_academicos.id;


--
-- Name: qr_codigos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.qr_codigos (
    id integer NOT NULL,
    identificador uuid DEFAULT gen_random_uuid() NOT NULL,
    estudiante_id bigint NOT NULL,
    certificado_id bigint,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    verificaciones integer DEFAULT 0 NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: qr_codigos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.qr_codigos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: qr_codigos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.qr_codigos_id_seq OWNED BY public.qr_codigos.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    codigo character varying(40) NOT NULL,
    nombre character varying(80) NOT NULL,
    descripcion character varying(200)
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tickets (
    id integer NOT NULL,
    codigo character varying(15),
    tipo_solicitud_id bigint NOT NULL,
    estudiante_id bigint NOT NULL,
    carrera_id bigint NOT NULL,
    nivel character varying(30) NOT NULL,
    paralelo character varying(20) NOT NULL,
    descripcion text,
    estado character varying(15) DEFAULT 'Pendiente'::character varying NOT NULL,
    responsable_id bigint,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT tickets_estado_check CHECK (((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'En Proceso'::character varying, 'Resuelto'::character varying])::text[])))
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: tipos_solicitud; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipos_solicitud (
    id integer NOT NULL,
    codigo character varying(40) NOT NULL,
    nombre character varying(100) NOT NULL,
    genera_ticket boolean NOT NULL,
    ambito character varying(20) NOT NULL,
    CONSTRAINT tipos_solicitud_ambito_check CHECK (((ambito)::text = ANY ((ARRAY['carrera'::character varying, 'vinculacion'::character varying, 'laboratorio'::character varying, 'ninguno'::character varying])::text[])))
);


--
-- Name: tipos_solicitud_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tipos_solicitud_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tipos_solicitud_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tipos_solicitud_id_seq OWNED BY public.tipos_solicitud.id;


--
-- Name: usuarios_panel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios_panel (
    id integer NOT NULL,
    cedula character varying(10) NOT NULL,
    nombres character varying(150) NOT NULL,
    correo character varying(150) NOT NULL,
    password_hash character varying(255) NOT NULL,
    rol_id bigint NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    creado_en timestamp with time zone DEFAULT now() NOT NULL,
    actualizado_en timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT usuarios_panel_cedula_check CHECK (((cedula)::text ~ '^[0-9]{10}$'::text))
);


--
-- Name: usuarios_panel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuarios_panel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuarios_panel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuarios_panel_id_seq OWNED BY public.usuarios_panel.id;


--
-- Name: adjuntos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adjuntos ALTER COLUMN id SET DEFAULT nextval('public.adjuntos_id_seq'::regclass);


--
-- Name: alerta_historial id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_historial ALTER COLUMN id SET DEFAULT nextval('public.alerta_historial_id_seq'::regclass);


--
-- Name: alertas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas ALTER COLUMN id SET DEFAULT nextval('public.alertas_id_seq'::regclass);


--
-- Name: asignaciones_responsables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignaciones_responsables ALTER COLUMN id SET DEFAULT nextval('public.asignaciones_responsables_id_seq'::regclass);


--
-- Name: carreras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carreras ALTER COLUMN id SET DEFAULT nextval('public.carreras_id_seq'::regclass);


--
-- Name: certificados id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificados ALTER COLUMN id SET DEFAULT nextval('public.certificados_id_seq'::regclass);


--
-- Name: configuracion_sistema id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_sistema ALTER COLUMN id SET DEFAULT nextval('public.configuracion_sistema_id_seq'::regclass);


--
-- Name: docentes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docentes ALTER COLUMN id SET DEFAULT nextval('public.docentes_id_seq'::regclass);


--
-- Name: estudiantes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes ALTER COLUMN id SET DEFAULT nextval('public.estudiantes_id_seq'::regclass);


--
-- Name: eventos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventos ALTER COLUMN id SET DEFAULT nextval('public.eventos_id_seq'::regclass);


--
-- Name: laboratorios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.laboratorios ALTER COLUMN id SET DEFAULT nextval('public.laboratorios_id_seq'::regclass);


--
-- Name: otp_codigos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.otp_codigos ALTER COLUMN id SET DEFAULT nextval('public.otp_codigos_id_seq'::regclass);


--
-- Name: periodos_academicos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.periodos_academicos ALTER COLUMN id SET DEFAULT nextval('public.periodos_academicos_id_seq'::regclass);


--
-- Name: qr_codigos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qr_codigos ALTER COLUMN id SET DEFAULT nextval('public.qr_codigos_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: tipos_solicitud id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipos_solicitud ALTER COLUMN id SET DEFAULT nextval('public.tipos_solicitud_id_seq'::regclass);


--
-- Name: usuarios_panel id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios_panel ALTER COLUMN id SET DEFAULT nextval('public.usuarios_panel_id_seq'::regclass);


--
-- Data for Name: adjuntos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.adjuntos (id, tipo, ruta, mime, tamano_bytes, hash, creado_en) FROM stdin;
\.


--
-- Data for Name: alerta_historial; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alerta_historial (id, alerta_id, estado_anterior, estado_nuevo, observacion, usuario_id, creado_en) FROM stdin;
\.


--
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alertas (id, codigo, laboratorio_id, descripcion, adjunto_id, profesor_id, estado, responsable_id, ticket_id, creado_en, actualizado_en) FROM stdin;
\.


--
-- Data for Name: asignaciones_responsables; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.asignaciones_responsables (id, tipo_solicitud_id, carrera_id, usuario_id, vigente, semestre, creado_en) FROM stdin;
1	2	1	1	t	2026-1	2026-08-07 10:26:35.495597-05
2	2	2	1	t	2026-1	2026-08-07 10:26:35.495597-05
3	2	3	1	t	2026-1	2026-08-07 10:26:35.495597-05
4	2	4	1	t	2026-1	2026-08-07 10:26:35.495597-05
5	2	5	1	t	2026-1	2026-08-07 10:26:35.495597-05
6	4	1	1	t	2026-1	2026-08-07 10:26:35.495597-05
7	4	2	1	t	2026-1	2026-08-07 10:26:35.495597-05
8	4	3	1	t	2026-1	2026-08-07 10:26:35.495597-05
9	4	4	1	t	2026-1	2026-08-07 10:26:35.495597-05
10	4	5	1	t	2026-1	2026-08-07 10:26:35.495597-05
11	3	\N	2	t	2026-1	2026-08-07 10:26:35.495597-05
12	5	\N	3	t	2026-1	2026-08-07 10:26:35.495597-05
13	6	\N	4	t	2026-1	2026-08-07 10:26:35.495597-05
14	1	\N	5	t	2026-1	2026-08-07 10:26:35.495597-05
\.


--
-- Data for Name: carreras; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.carreras (id, codigo, nombre) FROM stdin;
1	ACE	Arte Culinario Ecuatoriano
2	DSW	Desarrollo de Software
3	DMO	Diseño de Modas
4	GNT	Guía Nacional de Turismo
5	MKD	Marketing Digital
\.


--
-- Data for Name: certificados; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.certificados (id, estudiante_id, tipo, qr_id, pdf_path, fecha, hora, creado_en, periodo_lectivo_codigo, periodo_lectivo_nombre, modalidad, periodo_ingreso_codigo, periodo_ingreso_nombre, nivel_ingreso, firmante_nombre, firmante_cargo) FROM stdin;
1	1	CERT_MATRICULA	1	\N	2026-08-07	12:56:36.020454	2026-08-07 10:35:53.320701-05	2026-I	mayo-septiembre 2026	PRESENCIAL	2026-I	mayo-septiembre 2026	Primer nivel	Mtr. Alexandra Gordon M.	Secretaria General (s)
\.


--
-- Data for Name: configuracion_sistema; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.configuracion_sistema (id, clave, valor, descripcion, actualizado_por, actualizado_en) FROM stdin;
1	institucion.nombre_oficial	Instituto Superior Tecnológico de Turismo y Patrimonio "YAVIRAC"	Razón social completa para documentos oficiales	\N	2026-08-06 16:45:49.424837-05
2	institucion.ciudad_emision	Quito	Ciudad que aparece en la frase de emisión del certificado	\N	2026-08-06 16:45:49.424837-05
3	firma.nombre	Mtr. Alexandra Gordon M.	Nombre de quien firma los certificados generados	\N	2026-08-06 16:45:49.424837-05
4	firma.cargo	Secretaria General (s)	Cargo de quien firma los certificados generados	\N	2026-08-06 16:45:49.424837-05
\.


--
-- Data for Name: docentes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.docentes (id, cedula, nombre_docente, correo, creado_en, actualizado_en) FROM stdin;
1	1710000101	MIGUEL ANDRADE VEGA	miguel.andrade.test@yavirac.edu.ec	2026-08-07 10:19:02.241813-05	2026-08-07 10:19:02.241813-05
2	1710000102	LAURA CARRILLO MENA	laura.carrillo.test@yavirac.edu.ec	2026-08-07 10:19:02.241813-05	2026-08-07 10:19:02.241813-05
3	1710000103	DIEGO SALAZAR RIOS	diego.salazar.test@yavirac.edu.ec	2026-08-07 10:19:02.241813-05	2026-08-07 10:19:02.241813-05
4	1710000104	PAOLA MORALES VELEZ	paola.morales.test@yavirac.edu.ec	2026-08-07 10:19:02.241813-05	2026-08-07 10:19:02.241813-05
5	1710000105	CARLOS ZAMBRANO LOPEZ	carlos.zambrano.test@yavirac.edu.ec	2026-08-07 10:19:02.241813-05	2026-08-07 10:19:02.241813-05
\.


--
-- Data for Name: estudiantes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.estudiantes (id, cedula, nombres, carrera_id, nivel, paralelo, estado_matricula, correo, creado_en, actualizado_en, modalidad, periodo_ingreso_id, nivel_ingreso) FROM stdin;
1	1700000001	ANDRES VERA MENDOZA	2	Sexto	A	MATRICULADO	andres.vera.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	PRESENCIAL	2	Primer nivel
2	1700000002	MELANIE TORRES RUIZ	2	Cuarto	B	APROBADO	melanie.torres.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	DUAL	2	Primer nivel
3	1700000003	DANIELA LOPEZ MORA	1	Segundo	A	MATRICULADO	daniela.lopez.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	PRESENCIAL	2	Primer nivel
4	1700000004	JOSE MENDOZA CRUZ	1	Quinto	A	RETIRADO	jose.mendoza.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	PRESENCIAL	2	Primer nivel
5	1700000005	VALENTINA RIVERA PAZ	3	Tercero	B	MATRICULADO	valentina.rivera.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	SEMIPRESENCIAL	2	Primer nivel
6	1700000006	CAMILA PONCE DIAZ	3	Sexto	A	REPROBADO	camila.ponce.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	PRESENCIAL	2	Primer nivel
7	1700000007	MATEO CHAVEZ LEON	4	Cuarto	A	MATRICULADO	mateo.chavez.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	DUAL	2	Primer nivel
8	1700000008	SOFIA HIDALGO VEGA	4	Segundo	B	APROBADO	sofia.hidalgo.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	PRESENCIAL	2	Primer nivel
9	1700000009	NICOLAS CASTRO ORTIZ	5	Tercero	A	MATRICULADO	nicolas.castro.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	EN LINEA	2	Primer nivel
10	1700000010	ISABELLA REYES SOTO	5	Quinto	B	RETIRADO	isabella.reyes.test@yavirac.edu.ec	2026-08-07 10:16:41.083183-05	2026-08-07 10:16:41.083183-05	SEMIPRESENCIAL	2	Primer nivel
\.


--
-- Data for Name: eventos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.eventos (id, tipo, payload, origen, procesado, creado_en) FROM stdin;
1	TicketCreado	{"tipo": "ANULACION_MATRICULA", "codigo": "TK-000001", "ticket_id": "1"}	chatbot	f	2026-08-07 10:39:37.322239-05
2	TicketAsignado	{"ticket_id": "1", "responsable_id": "1"}	chatbot	f	2026-08-07 10:39:37.333182-05
\.


--
-- Data for Name: laboratorios; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.laboratorios (id, codigo, nombre, cantidad_equipos) FROM stdin;
1	LAB-01	Laboratorio de Tolouse	20
2	LAB-02	Laboratorio de Xian	25
3	LAB-03	Laboratorio de Yasuni	15
4	LAB-04	Laboratorio de Ninive	18
5	LAB-05	Laboratorio de Sarasota	20
\.


--
-- Data for Name: otp_codigos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.otp_codigos (id, cedula, correo, codigo_hash, canal, expira_en, usado, creado_en) FROM stdin;
1	1700000001	andres.vera.test@yavirac.edu.ec	0f3667b92071aa471842d3744d507037fcccb990d2ea1bf96c74f8c15e7dcf70	chatbot	2026-08-07 10:43:29.429027-05	t	2026-08-07 10:33:29.429027-05
2	1700000001	andres.vera.test@yavirac.edu.ec	4105843597b694901782db3a58d0f12c0d095b197bfb21eb0ed9410028ebe30f	chatbot	2026-08-07 13:06:13.201552-05	t	2026-08-07 12:56:13.201552-05
\.


--
-- Data for Name: periodos_academicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.periodos_academicos (id, codigo, nombre, fecha_inicio, fecha_fin, vigente) FROM stdin;
1	2025-II	agosto 2025-febrero 2026	2025-08-01	2026-02-28	f
2	2026-I	mayo-septiembre 2026	2026-05-01	2026-09-30	t
\.


--
-- Data for Name: qr_codigos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.qr_codigos (id, identificador, estudiante_id, certificado_id, payload, verificaciones, creado_en) FROM stdin;
1	5fbd695e-4302-41f4-aa9d-711483ad1711	1	\N	{"tipo": "CERT_MATRICULA"}	13	2026-08-07 10:35:53.301814-05
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (id, codigo, nombre, descripcion) FROM stdin;
1	PROFESOR	Profesor	Reporta incidencias de laboratorio
2	COORDINADOR	Coordinador de Carrera	Atiende tickets académicos de sus carreras
3	RESP_VINCULACION	Responsable de Vinculación	Atiende certificados de vinculación
4	RESP_LABORATORIOS	Responsable de Laboratorios	Gestiona alertas de laboratorio
5	RESP_CERTIFICADOS	Responsable de Certificados	Recibe aviso cuando se emite un certificado de matrícula
6	SOPORTE_TI	Soporte Técnico / TI	Gestiona reseteos de contraseña de correo institucional
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tickets (id, codigo, tipo_solicitud_id, estudiante_id, carrera_id, nivel, paralelo, descripcion, estado, responsable_id, creado_en, actualizado_en) FROM stdin;
1	TK-000001	4	1	2	Sexto	A	\N	Pendiente	1	2026-08-07 10:39:37.271193-05	2026-08-07 10:39:37.271193-05
\.


--
-- Data for Name: tipos_solicitud; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tipos_solicitud (id, codigo, nombre, genera_ticket, ambito) FROM stdin;
1	CERT_MATRICULA	Certificado de Matrícula	f	ninguno
2	RECORD_ACADEMICO	Récord Académico	t	carrera
3	CERT_VINCULACION	Certificado de Vinculación	t	vinculacion
4	ANULACION_MATRICULA	Anulación de Matrícula	t	carrera
5	ALERTA_LAB	Alerta de Laboratorio	t	laboratorio
6	RESET_CORREO_LEGACY_DEPRECADO	Reseteo de Contraseña de Correo Institucional (obsoleto, ver workflow automático)	t	ninguno
\.


--
-- Data for Name: usuarios_panel; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usuarios_panel (id, cedula, nombres, correo, password_hash, rol_id, activo, creado_en, actualizado_en) FROM stdin;
1	1710000001	Juan Pérez	juan.perez@yavirac.edu.ec	$2b$10$0QtCdZxm3aIiCJaDJjQmbeF1PofnoarFzwmhE8JMR4gBEiCvEwvW.	2	t	2026-08-06 16:45:49.430524-05	2026-08-06 16:45:49.430524-05
2	1710000002	María López	maria.lopez@yavirac.edu.ec	$2b$10$0QtCdZxm3aIiCJaDJjQmbeF1PofnoarFzwmhE8JMR4gBEiCvEwvW.	3	t	2026-08-06 16:45:49.430524-05	2026-08-06 16:45:49.430524-05
3	1710000003	Carlos Ruiz	carlos.ruiz@yavirac.edu.ec	$2b$10$0QtCdZxm3aIiCJaDJjQmbeF1PofnoarFzwmhE8JMR4gBEiCvEwvW.	4	t	2026-08-06 16:45:49.430524-05	2026-08-06 16:45:49.430524-05
4	1710000004	PENDIENTE ASIGNAR (Soporte TI)	soporte.ti@yavirac.edu.ec	$2b$10$0QtCdZxm3aIiCJaDJjQmbeF1PofnoarFzwmhE8JMR4gBEiCvEwvW.	6	t	2026-08-06 16:45:49.430524-05	2026-08-06 16:45:49.430524-05
5	1710000005	PENDIENTE ASIGNAR (Certificados 1)	certificados1@yavirac.edu.ec	$2b$10$0QtCdZxm3aIiCJaDJjQmbeF1PofnoarFzwmhE8JMR4gBEiCvEwvW.	5	t	2026-08-06 16:45:49.430524-05	2026-08-06 16:45:49.430524-05
6	1710000006	PENDIENTE ASIGNAR (Certificados 2)	certificados2@yavirac.edu.ec	$2b$10$0QtCdZxm3aIiCJaDJjQmbeF1PofnoarFzwmhE8JMR4gBEiCvEwvW.	5	t	2026-08-06 16:45:49.430524-05	2026-08-06 16:45:49.430524-05
9	1710000101	MIGUEL ANDRADE VEGA	miguel.andrade.test@yavirac.edu.ec	.	1	t	2026-08-07 10:22:34.69563-05	2026-08-07 10:22:34.69563-05
10	1710000102	LAURA CARRILLO MENA	laura.carrillo.test@yavirac.edu.ec	.	1	t	2026-08-07 10:22:34.69563-05	2026-08-07 10:22:34.69563-05
11	1710000103	DIEGO SALAZAR RIOS	diego.salazar.test@yavirac.edu.ec	.	1	t	2026-08-07 10:22:34.69563-05	2026-08-07 10:22:34.69563-05
12	1710000104	PAOLA MORALES VELEZ	paola.morales.test@yavirac.edu.ec	.	1	t	2026-08-07 10:22:34.69563-05	2026-08-07 10:22:34.69563-05
13	1710000105	CARLOS ZAMBRANO LOPEZ	carlos.zambrano.test@yavirac.edu.ec	.	1	t	2026-08-07 10:22:34.69563-05	2026-08-07 10:22:34.69563-05
\.


--
-- Name: adjuntos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.adjuntos_id_seq', 1, false);


--
-- Name: alerta_historial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alerta_historial_id_seq', 1, false);


--
-- Name: alertas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alertas_id_seq', 1, false);


--
-- Name: asignaciones_responsables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.asignaciones_responsables_id_seq', 14, true);


--
-- Name: carreras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.carreras_id_seq', 5, true);


--
-- Name: certificados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.certificados_id_seq', 1, true);


--
-- Name: configuracion_sistema_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.configuracion_sistema_id_seq', 33, true);


--
-- Name: docentes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.docentes_id_seq', 5, true);


--
-- Name: estudiantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.estudiantes_id_seq', 10, true);


--
-- Name: eventos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eventos_id_seq', 2, true);


--
-- Name: laboratorios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.laboratorios_id_seq', 5, true);


--
-- Name: otp_codigos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.otp_codigos_id_seq', 2, true);


--
-- Name: periodos_academicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.periodos_academicos_id_seq', 2, true);


--
-- Name: qr_codigos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.qr_codigos_id_seq', 1, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_id_seq', 6, true);


--
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tickets_id_seq', 1, true);


--
-- Name: tipos_solicitud_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tipos_solicitud_id_seq', 6, true);


--
-- Name: usuarios_panel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuarios_panel_id_seq', 13, true);


--
-- Name: adjuntos adjuntos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adjuntos
    ADD CONSTRAINT adjuntos_pkey PRIMARY KEY (id);


--
-- Name: alerta_historial alerta_historial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_historial
    ADD CONSTRAINT alerta_historial_pkey PRIMARY KEY (id);


--
-- Name: alertas alertas_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_codigo_key UNIQUE (codigo);


--
-- Name: alertas alertas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_pkey PRIMARY KEY (id);


--
-- Name: asignaciones_responsables asignaciones_responsables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignaciones_responsables
    ADD CONSTRAINT asignaciones_responsables_pkey PRIMARY KEY (id);


--
-- Name: carreras carreras_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carreras
    ADD CONSTRAINT carreras_codigo_key UNIQUE (codigo);


--
-- Name: carreras carreras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carreras
    ADD CONSTRAINT carreras_pkey PRIMARY KEY (id);


--
-- Name: certificados certificados_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_pkey PRIMARY KEY (id);


--
-- Name: certificados certificados_qr_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_qr_id_key UNIQUE (qr_id);


--
-- Name: configuracion_sistema configuracion_sistema_clave_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_sistema
    ADD CONSTRAINT configuracion_sistema_clave_key UNIQUE (clave);


--
-- Name: configuracion_sistema configuracion_sistema_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configuracion_sistema
    ADD CONSTRAINT configuracion_sistema_pkey PRIMARY KEY (id);


--
-- Name: docentes docentes_cedula_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docentes
    ADD CONSTRAINT docentes_cedula_key UNIQUE (cedula);


--
-- Name: docentes docentes_correo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docentes
    ADD CONSTRAINT docentes_correo_key UNIQUE (correo);


--
-- Name: docentes docentes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.docentes
    ADD CONSTRAINT docentes_pkey PRIMARY KEY (id);


--
-- Name: estudiantes estudiantes_cedula_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT estudiantes_cedula_key UNIQUE (cedula);


--
-- Name: estudiantes estudiantes_correo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT estudiantes_correo_key UNIQUE (correo);


--
-- Name: estudiantes estudiantes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT estudiantes_pkey PRIMARY KEY (id);


--
-- Name: eventos eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_pkey PRIMARY KEY (id);


--
-- Name: laboratorios laboratorios_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.laboratorios
    ADD CONSTRAINT laboratorios_codigo_key UNIQUE (codigo);


--
-- Name: laboratorios laboratorios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.laboratorios
    ADD CONSTRAINT laboratorios_pkey PRIMARY KEY (id);


--
-- Name: otp_codigos otp_codigos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.otp_codigos
    ADD CONSTRAINT otp_codigos_pkey PRIMARY KEY (id);


--
-- Name: periodos_academicos periodos_academicos_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.periodos_academicos
    ADD CONSTRAINT periodos_academicos_codigo_key UNIQUE (codigo);


--
-- Name: periodos_academicos periodos_academicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.periodos_academicos
    ADD CONSTRAINT periodos_academicos_pkey PRIMARY KEY (id);


--
-- Name: qr_codigos qr_codigos_identificador_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qr_codigos
    ADD CONSTRAINT qr_codigos_identificador_key UNIQUE (identificador);


--
-- Name: qr_codigos qr_codigos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qr_codigos
    ADD CONSTRAINT qr_codigos_pkey PRIMARY KEY (id);


--
-- Name: roles roles_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_codigo_key UNIQUE (codigo);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: tickets tickets_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_codigo_key UNIQUE (codigo);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: tipos_solicitud tipos_solicitud_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipos_solicitud
    ADD CONSTRAINT tipos_solicitud_codigo_key UNIQUE (codigo);


--
-- Name: tipos_solicitud tipos_solicitud_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipos_solicitud
    ADD CONSTRAINT tipos_solicitud_pkey PRIMARY KEY (id);


--
-- Name: usuarios_panel usuarios_panel_cedula_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios_panel
    ADD CONSTRAINT usuarios_panel_cedula_key UNIQUE (cedula);


--
-- Name: usuarios_panel usuarios_panel_correo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios_panel
    ADD CONSTRAINT usuarios_panel_correo_key UNIQUE (correo);


--
-- Name: usuarios_panel usuarios_panel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios_panel
    ADD CONSTRAINT usuarios_panel_pkey PRIMARY KEY (id);


--
-- Name: certificados ux_certificado_estudiante_periodo; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT ux_certificado_estudiante_periodo UNIQUE (estudiante_id, periodo_lectivo_codigo);


--
-- Name: ix_alertas_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_alertas_estado ON public.alertas USING btree (estado);


--
-- Name: ix_alertas_profesor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_alertas_profesor ON public.alertas USING btree (profesor_id);


--
-- Name: ix_estudiantes_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_estudiantes_estado ON public.estudiantes USING btree (estado_matricula);


--
-- Name: ix_eventos_pendientes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_eventos_pendientes ON public.eventos USING btree (procesado) WHERE (NOT procesado);


--
-- Name: ix_otp_cedula; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_otp_cedula ON public.otp_codigos USING btree (cedula, canal);


--
-- Name: ix_tickets_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_tickets_estado ON public.tickets USING btree (estado);


--
-- Name: ix_tickets_estudiante; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_tickets_estudiante ON public.tickets USING btree (estudiante_id);


--
-- Name: ix_tickets_responsable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_tickets_responsable ON public.tickets USING btree (responsable_id);


--
-- Name: ux_asignacion_vigente; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_asignacion_vigente ON public.asignaciones_responsables USING btree (tipo_solicitud_id, COALESCE(carrera_id, ('-1'::integer)::bigint)) WHERE vigente;


--
-- Name: ux_periodo_vigente; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_periodo_vigente ON public.periodos_academicos USING btree (vigente) WHERE vigente;


--
-- Name: ux_ticket_estudiante_tipo_activo; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ux_ticket_estudiante_tipo_activo ON public.tickets USING btree (estudiante_id, tipo_solicitud_id) WHERE ((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'En Proceso'::character varying])::text[]));


--
-- Name: alerta_historial alerta_historial_alerta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_historial
    ADD CONSTRAINT alerta_historial_alerta_id_fkey FOREIGN KEY (alerta_id) REFERENCES public.alertas(id) ON DELETE CASCADE;


--
-- Name: alerta_historial alerta_historial_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta_historial
    ADD CONSTRAINT alerta_historial_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios_panel(id);


--
-- Name: alertas alertas_adjunto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_adjunto_id_fkey FOREIGN KEY (adjunto_id) REFERENCES public.adjuntos(id);


--
-- Name: alertas alertas_laboratorio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_laboratorio_id_fkey FOREIGN KEY (laboratorio_id) REFERENCES public.laboratorios(id);


--
-- Name: alertas alertas_profesor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_profesor_id_fkey FOREIGN KEY (profesor_id) REFERENCES public.usuarios_panel(id);


--
-- Name: alertas alertas_responsable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_responsable_id_fkey FOREIGN KEY (responsable_id) REFERENCES public.usuarios_panel(id);


--
-- Name: alertas alertas_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_ticket_id_fkey FOREIGN KEY (ticket_id) REFERENCES public.tickets(id);


--
-- Name: asignaciones_responsables asignaciones_responsables_carrera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignaciones_responsables
    ADD CONSTRAINT asignaciones_responsables_carrera_id_fkey FOREIGN KEY (carrera_id) REFERENCES public.carreras(id);


--
-- Name: asignaciones_responsables asignaciones_responsables_tipo_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignaciones_responsables
    ADD CONSTRAINT asignaciones_responsables_tipo_solicitud_id_fkey FOREIGN KEY (tipo_solicitud_id) REFERENCES public.tipos_solicitud(id);


--
-- Name: asignaciones_responsables asignaciones_responsables_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asignaciones_responsables
    ADD CONSTRAINT asignaciones_responsables_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios_panel(id);


--
-- Name: certificados certificados_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.estudiantes(id);


--
-- Name: certificados certificados_qr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_qr_id_fkey FOREIGN KEY (qr_id) REFERENCES public.qr_codigos(id);


--
-- Name: estudiantes estudiantes_carrera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT estudiantes_carrera_id_fkey FOREIGN KEY (carrera_id) REFERENCES public.carreras(id);


--
-- Name: estudiantes estudiantes_periodo_ingreso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estudiantes
    ADD CONSTRAINT estudiantes_periodo_ingreso_id_fkey FOREIGN KEY (periodo_ingreso_id) REFERENCES public.periodos_academicos(id);


--
-- Name: qr_codigos fk_qr_certificado; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qr_codigos
    ADD CONSTRAINT fk_qr_certificado FOREIGN KEY (certificado_id) REFERENCES public.certificados(id);


--
-- Name: qr_codigos qr_codigos_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.qr_codigos
    ADD CONSTRAINT qr_codigos_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.estudiantes(id);


--
-- Name: tickets tickets_carrera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_carrera_id_fkey FOREIGN KEY (carrera_id) REFERENCES public.carreras(id);


--
-- Name: tickets tickets_estudiante_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_estudiante_id_fkey FOREIGN KEY (estudiante_id) REFERENCES public.estudiantes(id);


--
-- Name: tickets tickets_responsable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_responsable_id_fkey FOREIGN KEY (responsable_id) REFERENCES public.usuarios_panel(id);


--
-- Name: tickets tickets_tipo_solicitud_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_tipo_solicitud_id_fkey FOREIGN KEY (tipo_solicitud_id) REFERENCES public.tipos_solicitud(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 1IksHpzXOcQ86r47S3O4gPm5XKDukzBd2Bo2sMCY4ZJkj9xp1iDn9ttfRctu2fy

