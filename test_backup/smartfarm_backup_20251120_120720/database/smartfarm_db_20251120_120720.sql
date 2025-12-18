--
-- PostgreSQL database dump
--

\restrict vrO89Zm7P2aysvhHFOS78NcFAik8xBCBOuKi2izcNLF7FAnGJMGDkdFPQmpZV6o

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    id bigint NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    farm_id bigint,
    field_id bigint,
    role character varying(50) DEFAULT 'FARMER'::character varying NOT NULL,
    address character varying(200),
    phone character varying(20),
    CONSTRAINT account_role_check CHECK (((role)::text = ANY (ARRAY[('ADMIN'::character varying)::text, ('FARMER'::character varying)::text, ('TECHNICIAN'::character varying)::text, ('FARM_OWNER'::character varying)::text])))
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_id_seq OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- Name: account_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_roles (
    account_id bigint NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE public.account_roles OWNER TO postgres;

--
-- Name: alert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alert (
    id bigint NOT NULL,
    field_id bigint,
    message character varying(255) NOT NULL,
    status character varying(255),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    owner_id bigint,
    sensor_id bigint,
    group_type character varying(255),
    type character varying(255),
    value double precision,
    threshold_min double precision,
    threshold_max double precision
);


ALTER TABLE public.alert OWNER TO postgres;

--
-- Name: alert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alert_id_seq OWNER TO postgres;

--
-- Name: alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alert_id_seq OWNED BY public.alert.id;


--
-- Name: coordinates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordinates (
    id bigint NOT NULL,
    field_id bigint NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    point_order integer NOT NULL
);


ALTER TABLE public.coordinates OWNER TO postgres;

--
-- Name: coordinates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coordinates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coordinates_id_seq OWNER TO postgres;

--
-- Name: coordinates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coordinates_id_seq OWNED BY public.coordinates.id;


--
-- Name: crop_growth_stage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crop_growth_stage (
    id bigint NOT NULL,
    plant_id bigint,
    stage_name character varying(255) NOT NULL,
    min_day integer NOT NULL,
    max_day integer NOT NULL,
    description character varying(255)
);


ALTER TABLE public.crop_growth_stage OWNER TO postgres;

--
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crop_growth_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crop_growth_stage_id_seq OWNER TO postgres;

--
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crop_growth_stage_id_seq OWNED BY public.crop_growth_stage.id;


--
-- Name: crop_season; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crop_season (
    id bigint NOT NULL,
    field_id bigint,
    plant_id bigint,
    season_name character varying(255),
    planting_date date NOT NULL,
    expected_harvest_date date,
    actual_harvest_date date,
    note character varying(255)
);


ALTER TABLE public.crop_season OWNER TO postgres;

--
-- Name: crop_season_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crop_season_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crop_season_id_seq OWNER TO postgres;

--
-- Name: crop_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crop_season_id_seq OWNED BY public.crop_season.id;


--
-- Name: farm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farm (
    id bigint NOT NULL,
    farm_name character varying(255) NOT NULL,
    owner_id bigint,
    lat double precision,
    lng double precision,
    area double precision,
    region character varying(255)
);


ALTER TABLE public.farm OWNER TO postgres;

--
-- Name: farm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farm_id_seq OWNER TO postgres;

--
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farm_id_seq OWNED BY public.farm.id;


--
-- Name: fertilization_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fertilization_history (
    id bigint NOT NULL,
    field_id bigint,
    fertilizer_type character varying(255) NOT NULL,
    fertilizer_amount double precision NOT NULL,
    fertilization_date date NOT NULL
);


ALTER TABLE public.fertilization_history OWNER TO postgres;

--
-- Name: fertilization_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fertilization_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fertilization_history_id_seq OWNER TO postgres;

--
-- Name: fertilization_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fertilization_history_id_seq OWNED BY public.fertilization_history.id;


--
-- Name: field; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.field (
    id bigint NOT NULL,
    farm_id bigint NOT NULL,
    field_name character varying(255) NOT NULL,
    date_created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'Active'::character varying,
    area double precision,
    region character varying(255),
    crop_season_id bigint
);


ALTER TABLE public.field OWNER TO postgres;

--
-- Name: field_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.field_id_seq OWNER TO postgres;

--
-- Name: field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.field_id_seq OWNED BY public.field.id;


--
-- Name: harvest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.harvest (
    id bigint NOT NULL,
    crop_season_id bigint,
    yield_kg double precision NOT NULL,
    harvest_date date NOT NULL,
    quality character varying(50),
    notes character varying(255)
);


ALTER TABLE public.harvest OWNER TO postgres;

--
-- Name: harvest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.harvest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harvest_id_seq OWNER TO postgres;

--
-- Name: harvest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.harvest_id_seq OWNED BY public.harvest.id;


--
-- Name: irrigation_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irrigation_history (
    id bigint NOT NULL,
    field_id bigint,
    action character varying(255) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT irrigation_history_action_check CHECK (((action)::text = ANY (ARRAY[('Start'::character varying)::text, ('Stop'::character varying)::text])))
);


ALTER TABLE public.irrigation_history OWNER TO postgres;

--
-- Name: irrigation_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.irrigation_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.irrigation_history_id_seq OWNER TO postgres;

--
-- Name: irrigation_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.irrigation_history_id_seq OWNED BY public.irrigation_history.id;


--
-- Name: plant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plant (
    id bigint NOT NULL,
    plant_name character varying(255) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.plant OWNER TO postgres;

--
-- Name: plant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plant_id_seq OWNER TO postgres;

--
-- Name: plant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plant_id_seq OWNED BY public.plant.id;


--
-- Name: sensor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensor (
    id bigint NOT NULL,
    field_id bigint,
    sensor_name character varying(255) NOT NULL,
    lat double precision NOT NULL,
    lng double precision NOT NULL,
    type character varying(255),
    installation_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'Active'::character varying,
    point_order integer,
    farm_id bigint,
    CONSTRAINT sensor_status_check CHECK (((status)::text = ANY (ARRAY[('Active'::character varying)::text, ('Inactive'::character varying)::text, ('Under_Maintenance'::character varying)::text]))),
    CONSTRAINT sensor_type_check CHECK (((type)::text = ANY (ARRAY[('Temperature'::character varying)::text, ('Humidity'::character varying)::text, ('Soil Moisture'::character varying)::text, ('Light'::character varying)::text])))
);


ALTER TABLE public.sensor OWNER TO postgres;

--
-- Name: sensor_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensor_data (
    id bigint NOT NULL,
    sensor_id bigint,
    value double precision NOT NULL,
    "time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sensor_data OWNER TO postgres;

--
-- Name: sensor_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensor_data_id_seq OWNER TO postgres;

--
-- Name: sensor_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_data_id_seq OWNED BY public.sensor_data.id;


--
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensor_id_seq OWNER TO postgres;

--
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_id_seq OWNED BY public.sensor.id;


--
-- Name: sensor_node; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sensor_node (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    field_id bigint,
    note text
);


ALTER TABLE public.sensor_node OWNER TO postgres;

--
-- Name: sensor_node_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensor_node_id_seq OWNER TO postgres;

--
-- Name: sensor_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_node_id_seq OWNED BY public.sensor_node.id;


--
-- Name: warning_threshold; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warning_threshold (
    id bigint NOT NULL,
    crop_season_id bigint,
    min_temperature double precision,
    max_temperature double precision,
    min_humidity double precision,
    max_humidity double precision,
    min_soil_moisture double precision,
    max_soil_moisture double precision,
    group_type character varying(255)
);


ALTER TABLE public.warning_threshold OWNER TO postgres;

--
-- Name: warning_threshold_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.warning_threshold_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warning_threshold_id_seq OWNER TO postgres;

--
-- Name: warning_threshold_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.warning_threshold_id_seq OWNED BY public.warning_threshold.id;


--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- Name: alert id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert ALTER COLUMN id SET DEFAULT nextval('public.alert_id_seq'::regclass);


--
-- Name: coordinates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates ALTER COLUMN id SET DEFAULT nextval('public.coordinates_id_seq'::regclass);


--
-- Name: crop_growth_stage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_growth_stage ALTER COLUMN id SET DEFAULT nextval('public.crop_growth_stage_id_seq'::regclass);


--
-- Name: crop_season id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season ALTER COLUMN id SET DEFAULT nextval('public.crop_season_id_seq'::regclass);


--
-- Name: farm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm ALTER COLUMN id SET DEFAULT nextval('public.farm_id_seq'::regclass);


--
-- Name: fertilization_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fertilization_history ALTER COLUMN id SET DEFAULT nextval('public.fertilization_history_id_seq'::regclass);


--
-- Name: field id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field ALTER COLUMN id SET DEFAULT nextval('public.field_id_seq'::regclass);


--
-- Name: harvest id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest ALTER COLUMN id SET DEFAULT nextval('public.harvest_id_seq'::regclass);


--
-- Name: irrigation_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irrigation_history ALTER COLUMN id SET DEFAULT nextval('public.irrigation_history_id_seq'::regclass);


--
-- Name: plant id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant ALTER COLUMN id SET DEFAULT nextval('public.plant_id_seq'::regclass);


--
-- Name: sensor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor ALTER COLUMN id SET DEFAULT nextval('public.sensor_id_seq'::regclass);


--
-- Name: sensor_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_data ALTER COLUMN id SET DEFAULT nextval('public.sensor_data_id_seq'::regclass);


--
-- Name: sensor_node id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_node ALTER COLUMN id SET DEFAULT nextval('public.sensor_node_id_seq'::regclass);


--
-- Name: warning_threshold id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warning_threshold ALTER COLUMN id SET DEFAULT nextval('public.warning_threshold_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account (id, full_name, email, password, date_created, farm_id, field_id, role, address, phone) FROM stdin;
2	Le Thi B_Update	farmer@example.com	hashedpassword2	2025-05-17 13:19:11.472416	\N	\N	FARMER	\N	\N
1	Nguyen Van A	admin@example.com	hashedpassword1	2025-05-17 13:19:11.472416	\N	\N	FARMER	\N	\N
3	Tran Van C	owner@example.com	hashedpassword3	2025-05-17 13:19:11.472416	\N	\N	FARMER	\N	\N
4	Pham Thi D	tech@example.com	hashedpassword4	2025-05-17 13:19:11.472416	\N	\N	FARMER	\N	\N
7	Nguyễn Thị Kim Ngân	ngan@example.com	$2a$10$XWiyRvBz/hLjXss0J9Nva.OQBMV8IclmnMX3sVY5ZS6VOPOTFz.nO	2025-06-22 18:03:02.172213	\N	\N	FARMER	\N	\N
9	Nguyễn Thị Kim Ngân	ngan1@gmail.com	$2a$10$qUceHI4klelevHFwq3qyNOrXq.oBJOtW8TKgK.QHh5cxrx82LMnA2	2025-06-23 16:14:29.17928	\N	\N	FARMER	\N	\N
10	DANG LE HOANG	coi31052004@gmail.com	coi31052004@	2025-07-27 14:24:39.521011	\N	\N	FARMER	Sai Gon	0905290338
42	Nguyễn Kim Ngân	lovengan040@gmail.com	123456	2025-09-30 18:05:42.816261	\N	\N	FARMER	\N	\N
44	Admin	admin@smartfarm.com	admin123	2025-10-28 18:36:23.069709	\N	\N	FARMER	\N	\N
46	Test	test@test.com	$2a$10$uQfoBi7kc1GdqQQ.PYSNjOzC3AseE4mo/55KQTGZRdqIZrprgrnoi	2025-10-29 09:30:08.263841	\N	\N	FARMER	\N	\N
47	Kim Ngân	lovengan007@gmail.com	$2a$10$n94KmNK2vZVqSZ0J90QgUueItP2pflicJTWkuAolfLtGSByfVPZ3q	2025-10-29 09:31:33.149098	\N	\N	FARMER	\N	\N
48	NGUYEN THI KIM NGAN	lovengan0407@gmail.com	$2a$10$jQgyc0J.otq1sTwyNtZoG.csg1EBgDoWK0pxYZ5jmrYfooxgp4M.u	2025-10-29 10:27:21.676095	\N	\N	FARMER	\N	\N
49	Admin Nguyen	admin.nguyen@smartfarm.com	$2a$10$Twv4Vbu7yC03HbP3.0BXUu6jqfEhCtzZlAaynBa09/HetluKeQ6VG	2025-10-29 10:41:14.719526	\N	\N	FARMER	\N	\N
50	bo	trancongbo14@gmail.com	$2a$10$B9Nn.fIRxvhZ/UoEFc9PzejImyjNddDxzIkJOFXsZIw40W4aMHki2	2025-11-08 08:30:19.335486	\N	\N	FARMER	\N	\N
51	 Nhân Nguyễn	HackathonPioneDream@gmail.com	$2a$10$xzhpnFPjAn8JCS65HH0YE.HQeKY/DxR07Ed82YcOuumHTlNo4LOee	2025-11-11 02:00:08.460601	\N	\N	FARMER	\N	\N
52	admin123	ntkngan.040703@gmail.com	$2a$10$c0lnIz4sQPQW/oqfLz7wceqSToXAwjPQdbAq67nig66PSI.5JKlNG	2025-11-20 09:08:53.760585	\N	\N	FARMER	\N	\N
\.


--
-- Data for Name: account_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_roles (account_id, role) FROM stdin;
1	FARMER
2	FARMER
3	ADMIN
4	FARMER
7	FARM_OWNER
9	FARMER
42	FARMER
44	ADMIN
46	ADMIN
47	FARMER
48	FARMER
49	ADMIN
50	ADMIN
51	ADMIN
52	ADMIN
\.


--
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type, type, value, threshold_min, threshold_max) FROM stdin;
18	1	Alert for sensorTemperatureWARNING	WARNING	2025-05-31 10:21:32.052776	2	2	s	\N	\N	\N	\N
19	1	Alert for sensorTemperatureGOOD	GOOD	2025-06-04 22:51:36.408297	1	1	s	\N	\N	\N	\N
20	1	Alert for sensorTemperatureGOOD	GOOD	2025-06-04 22:51:36.458432	2	2	s	\N	\N	\N	\N
22	1	Alert for sensorTemperatureWARNING	WARNING	2025-06-04 22:51:47.353129	2	2	s	\N	\N	\N	\N
23	1	Alert for sensorTemperatureGOOD	GOOD	2025-06-04 22:59:33.284056	2	2	s	\N	\N	\N	\N
24	1	Alert for sensor TemperatureGood	Good	2025-06-05 21:57:43.545642	1	1	s	\N	\N	\N	\N
26	2	Alert for sensor Critical	Critical	2025-06-05 21:57:43.605329	4	4	s	\N	\N	\N	\N
27	1	Alert for sensor TemperatureGood	Good	2025-06-05 21:58:19.893495	2	2	s	\N	\N	\N	\N
28	1	Alert for sensor TemperatureGood	Good	2025-06-05 22:00:46.454003	2	2	s	\N	\N	\N	\N
29	1	Alert for sensor  TemperatureGood	Good	2025-06-05 22:18:26.205603	2	2	s	\N	\N	\N	\N
30	2	Alert for sensor S oil MoistureCritical	Critical	2025-06-05 22:22:44.693884	3	3	s	\N	\N	\N	\N
32	2	Alert for sensor S oil MoistureCritical	Critical	2025-06-05 22:24:37.407266	3	3	s	\N	\N	\N	\N
33	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:26:24.570458	3	3	s	\N	\N	\N	\N
34	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:28:59.791779	3	3	s	\N	\N	\N	\N
35	1	Alert for sensor  TemperatureGood	Good	2025-06-05 22:28:59.792285	1	1	s	\N	\N	\N	\N
36	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:28:59.709524	3	3	s	\N	\N	\N	\N
37	1	Alert for sensor  TemperatureCritical	Critical	2025-06-05 22:28:59.930776	2	2	s	\N	\N	\N	\N
38	2	Alert for sensor Soil MoistureWarning	Warning	2025-06-05 22:28:59.949628	3	3	s	\N	\N	\N	\N
39	2	Alert for sensor  HumidityGood	Good	2025-06-05 22:28:59.966555	4	4	s	\N	\N	\N	\N
40	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:30:10.322927	3	3	s	\N	\N	\N	\N
41	2	Alert for sensor  HumidityCritical	Critical	2025-06-05 22:32:18.333995	4	4	s	\N	\N	\N	\N
42	1	Alert for sensor  TemperatureWarning	Warning	2025-06-06 12:34:45.510961	1	1	s	\N	\N	\N	\N
44	2	Alert for sensor Soil MoistureGood	Good	2025-06-06 12:34:45.5843	3	3	s	\N	\N	\N	\N
45	2	Alert for sensor  HumidityGood	Good	2025-06-06 12:34:45.599635	4	4	s	\N	\N	\N	\N
46	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:40:12.922566	4	4	s	\N	\N	\N	\N
47	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:40:12.81058	4	4	s	\N	\N	\N	\N
48	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:40:12.996812	2	2	s	\N	\N	\N	\N
49	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:41:10.528842	4	4	s	\N	\N	\N	\N
50	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:41:10.617894	2	2	s	\N	\N	\N	\N
52	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:42:05.413432	4	4	s	\N	\N	\N	\N
51	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:42:05.444744	2	2	s	\N	\N	\N	\N
53	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:42:05.513976	2	2	s	\N	\N	\N	\N
54	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:44:31.839941	2	2	s	\N	\N	\N	\N
55	1	Alert for sensor TemperatureCritical	Critical	2025-06-06 14:41:35.571902	1	1	s	\N	\N	\N	\N
56	1	Alert for sensor TemperatureCritical	Critical	2025-06-06 14:41:35.618206	2	2	s	\N	\N	\N	\N
57	2	Alert for sensor Soil MoistureWarning	Warning	2025-06-06 14:41:35.631796	3	3	s	\N	\N	\N	\N
58	2	Alert for sensor HumidityWarning	Warning	2025-06-06 14:41:35.645794	4	4	s	\N	\N	\N	\N
59	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 13:45:03.923527	1	1	s	\N	\N	\N	\N
60	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 13:45:04.124461	2	2	s	\N	\N	\N	\N
61	2	Alert for sensor Soil MoistureGood	Good	2025-07-27 13:45:04.240589	3	3	s	\N	\N	\N	\N
62	2	Alert for sensor HumidityCritical	Critical	2025-07-27 13:45:04.351232	4	4	s	\N	\N	\N	\N
63	1	Alert for sensor TemperatureGood	Good	2025-07-27 13:45:09.416416	1	1	s	\N	\N	\N	\N
64	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 13:45:09.489988	2	2	s	\N	\N	\N	\N
65	2	Alert for sensor Soil MoistureGood	Good	2025-07-27 13:45:09.609743	3	3	s	\N	\N	\N	\N
66	2	Alert for sensor HumidityGood	Good	2025-07-27 13:45:09.800696	4	4	s	\N	\N	\N	\N
67	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:15:09.43563	1	1	s	\N	\N	\N	\N
68	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:15:09.60618	2	2	s	\N	\N	\N	\N
69	2	Alert for sensor Soil MoistureWarning	Warning	2025-07-27 14:15:09.71393	3	3	s	\N	\N	\N	\N
70	2	Alert for sensor HumidityGood	Good	2025-07-27 14:15:09.86324	4	4	s	\N	\N	\N	\N
71	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:45:09.428353	1	1	s	\N	\N	\N	\N
72	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:45:09.526081	2	2	s	\N	\N	\N	\N
73	2	Alert for sensor Soil MoistureGood	Good	2025-07-27 14:45:09.625255	3	3	s	\N	\N	\N	\N
74	2	Alert for sensor HumidityCritical	Critical	2025-07-27 14:45:09.686711	4	4	s	\N	\N	\N	\N
43	1	Alert for sensor  TemperatureCritical	GOOD	2025-06-06 12:34:45.568661	2	2	s	\N	\N	\N	\N
17	1	Alert for sensorTemperatureCRITICAL	GOOD	2025-05-31 10:21:31.941154	1	1	s	\N	\N	\N	\N
21	1	Alert for sensorTemperatureCRITICAL	GOOD	2025-06-04 22:51:47.338007	1	1	s	\N	\N	\N	\N
75	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:31:18.627568	1	1	s	\N	\N	\N	\N
76	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:31:18.778288	2	2	s	\N	\N	\N	\N
77	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 08:31:18.806752	3	3	s	\N	\N	\N	\N
78	2	Alert for sensor HumidityCritical	Critical	2025-11-20 08:31:18.83439	4	4	s	\N	\N	\N	\N
25	1	Alert for sensor TemperatureCritical	GOOD	2025-06-05 21:57:43.589244	2	2	s	\N	\N	\N	\N
79	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:36:18.23009	1	1	s	\N	\N	\N	\N
80	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:36:18.248111	2	2	s	\N	\N	\N	\N
81	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 08:36:18.263233	3	3	s	\N	\N	\N	\N
82	2	Alert for sensor HumidityCritical	Critical	2025-11-20 08:36:18.276981	4	4	s	\N	\N	\N	\N
83	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:41:18.252841	1	1	s	\N	\N	\N	\N
84	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:41:18.28581	2	2	s	\N	\N	\N	\N
85	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 08:41:18.300123	3	3	s	\N	\N	\N	\N
86	2	Alert for sensor HumidityCritical	Critical	2025-11-20 08:41:18.310954	4	4	s	\N	\N	\N	\N
31	2	Alert for sensor S oil MoistureCritical	GOOD	2025-06-05 22:23:57.753667	3	3	s	\N	\N	\N	\N
87	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:48:19.266082	1	1	s	Temperature	27.1906681060791	10	25
88	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:48:19.396397	2	2	s	Temperature	32.40660095214844	10	25
89	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 08:48:19.423441	3	3	s	Soil Moisture	44.786231994628906	25	55
90	2	Alert for sensor HumidityCritical	Critical	2025-11-20 08:48:19.447595	4	4	s	Humidity	78.6529769897461	45	75
91	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:53:18.845145	1	1	s	Temperature	27.1906681060791	10	25
92	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:53:18.868921	2	2	s	Temperature	32.40660095214844	10	25
93	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 08:53:18.880454	3	3	s	Soil Moisture	44.786231994628906	25	55
94	2	Alert for sensor HumidityCritical	Critical	2025-11-20 08:53:18.890482	4	4	s	Humidity	78.6529769897461	45	75
95	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:58:18.855039	1	1	s	Temperature	27.1906681060791	10	25
96	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 08:58:18.876399	2	2	s	Temperature	32.40660095214844	10	25
97	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 08:58:18.892346	3	3	s	Soil Moisture	44.786231994628906	25	55
98	2	Alert for sensor HumidityCritical	Critical	2025-11-20 08:58:18.906084	4	4	s	Humidity	78.6529769897461	45	75
99	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:03:38.865584	1	1	s	Temperature	27.1906681060791	10	25
100	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:03:39.005349	2	2	s	Temperature	32.40660095214844	10	25
101	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:03:39.03614	3	3	s	Soil Moisture	44.786231994628906	25	55
102	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:03:39.060477	4	4	s	Humidity	78.6529769897461	45	75
103	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:08:38.391775	1	1	s	Temperature	27.1906681060791	10	25
104	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:08:38.412585	2	2	s	Temperature	32.40660095214844	10	25
105	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:08:38.432051	3	3	s	Soil Moisture	44.786231994628906	25	55
106	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:08:38.44815	4	4	s	Humidity	78.6529769897461	45	75
107	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:13:38.395931	1	1	s	Temperature	27.1906681060791	10	25
108	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:13:38.412998	2	2	s	Temperature	32.40660095214844	10	25
109	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:13:38.429744	3	3	s	Soil Moisture	44.786231994628906	25	55
110	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:13:38.442871	4	4	s	Humidity	78.6529769897461	45	75
111	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:18:38.383645	1	1	s	Temperature	27.1906681060791	10	25
112	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:18:38.399061	2	2	s	Temperature	32.40660095214844	10	25
113	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:18:38.413121	3	3	s	Soil Moisture	44.786231994628906	25	55
114	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:18:38.425595	4	4	s	Humidity	78.6529769897461	45	75
115	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:23:38.383427	1	1	s	Temperature	27.1906681060791	10	25
116	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:23:38.398638	2	2	s	Temperature	32.40660095214844	10	25
117	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:23:38.413164	3	3	s	Soil Moisture	44.786231994628906	25	55
118	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:23:38.425533	4	4	s	Humidity	78.6529769897461	45	75
119	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:28:38.380935	1	1	s	Temperature	27.1906681060791	10	25
120	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:28:38.396228	2	2	s	Temperature	32.40660095214844	10	25
121	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:28:38.414819	3	3	s	Soil Moisture	44.786231994628906	25	55
122	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:28:38.429264	4	4	s	Humidity	78.6529769897461	45	75
123	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:33:38.490425	1	1	s	Temperature	27.1906681060791	10	25
124	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:33:38.5179	2	2	s	Temperature	32.40660095214844	10	25
125	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:33:38.541044	3	3	s	Soil Moisture	44.786231994628906	25	55
126	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:33:38.560243	4	4	s	Humidity	78.6529769897461	45	75
127	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:38:38.389634	1	1	s	Temperature	27.1906681060791	10	25
128	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:38:38.4059	2	2	s	Temperature	32.40660095214844	10	25
129	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:38:38.421652	3	3	s	Soil Moisture	44.786231994628906	25	55
130	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:38:38.4332	4	4	s	Humidity	78.6529769897461	45	75
131	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:43:38.379702	1	1	s	Temperature	27.1906681060791	10	25
133	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:43:38.408381	3	3	s	Soil Moisture	44.786231994628906	25	55
134	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:43:38.418427	4	4	s	Humidity	78.6529769897461	45	75
135	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:48:38.389324	1	1	s	Temperature	27.1906681060791	10	25
137	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:48:38.416682	3	3	s	Soil Moisture	44.786231994628906	25	55
138	2	Alert for sensor HumidityCritical	GOOD	2025-11-20 09:48:38.426933	4	4	s	Humidity	78.6529769897461	45	75
136	1	Alert for sensor TemperatureCritical	GOOD	2025-11-20 09:48:38.404795	2	2	s	Temperature	32.40660095214844	10	25
139	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:53:38.377259	1	1	s	Temperature	27.1906681060791	10	25
140	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:53:38.389753	2	2	s	Temperature	32.40660095214844	10	25
141	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:53:38.401376	3	3	s	Soil Moisture	44.786231994628906	25	55
142	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:53:38.412464	4	4	s	Humidity	78.6529769897461	45	75
132	1	Alert for sensor TemperatureCritical	GOOD	2025-11-20 09:43:38.394589	2	2	s	Temperature	32.40660095214844	10	25
143	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:58:38.378117	1	1	s	Temperature	27.1906681060791	10	25
144	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 09:58:38.388355	2	2	s	Temperature	32.40660095214844	10	25
145	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 09:58:38.397443	3	3	s	Soil Moisture	44.786231994628906	25	55
146	2	Alert for sensor HumidityCritical	Critical	2025-11-20 09:58:38.404915	4	4	s	Humidity	78.6529769897461	45	75
147	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:03:38.500943	1	1	s	Temperature	27.1906681060791	10	25
148	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:03:38.525747	2	2	s	Temperature	32.40660095214844	10	25
149	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 10:03:38.546148	3	3	s	Soil Moisture	44.786231994628906	25	55
150	2	Alert for sensor HumidityCritical	Critical	2025-11-20 10:03:38.565405	4	4	s	Humidity	78.6529769897461	45	75
151	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:08:38.40515	1	1	s	Temperature	27.1906681060791	10	25
152	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:08:38.428261	2	2	s	Temperature	32.40660095214844	10	25
153	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 10:08:38.444206	3	3	s	Soil Moisture	44.786231994628906	25	55
154	2	Alert for sensor HumidityCritical	Critical	2025-11-20 10:08:38.458587	4	4	s	Humidity	78.6529769897461	45	75
155	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:13:38.37758	1	1	s	Temperature	27.1906681060791	10	25
156	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:13:38.390055	2	2	s	Temperature	32.40660095214844	10	25
157	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 10:13:38.401503	3	3	s	Soil Moisture	44.786231994628906	25	55
158	2	Alert for sensor HumidityCritical	Critical	2025-11-20 10:13:38.409945	4	4	s	Humidity	78.6529769897461	45	75
159	1	Alert for sensor TemperatureCritical	Critical	2025-11-20 10:18:38.382613	1	1	s	Temperature	27.1906681060791	10	25
161	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 10:18:38.404183	3	3	s	Soil Moisture	44.786231994628906	25	55
165	2	Alert for sensor Soil MoistureGood	Good	2025-11-20 10:23:38.4107	3	3	s	Soil Moisture	44.786231994628906	25	55
166	2	Alert for sensor HumidityCritical	GOOD	2025-11-20 10:23:38.422308	4	4	s	Humidity	78.6529769897461	45	75
164	1	Alert for sensor TemperatureCritical	GOOD	2025-11-20 10:23:38.397419	2	2	s	Temperature	32.40660095214844	10	25
163	1	Alert for sensor TemperatureCritical	GOOD	2025-11-20 10:23:38.381659	1	1	s	Temperature	27.1906681060791	10	25
162	2	Alert for sensor HumidityCritical	GOOD	2025-11-20 10:18:38.412664	4	4	s	Humidity	78.6529769897461	45	75
160	1	Alert for sensor TemperatureCritical	GOOD	2025-11-20 10:18:38.394236	2	2	s	Temperature	32.40660095214844	10	25
\.


--
-- Data for Name: coordinates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coordinates (id, field_id, lat, lng, point_order) FROM stdin;
1	1	12.0357138	108.5200374	1
2	1	12.0271514	108.5039013	2
3	1	12.0125443	108.5090511	3
4	1	12.0303413	108.5433834	4
5	1	12.0357138	108.5200374	5
6	2	12.0148528	108.5021847	1
7	2	11.9958793	108.4989231	2
8	2	11.9789196	108.4985798	3
9	2	11.9784158	108.5181492	4
10	2	12.0148528	108.5021847	5
11	3	12.0094799	108.5090511	1
12	3	11.9809347	108.5214107	2
13	3	11.9923531	108.5409801	3
14	3	12.0138454	108.5193508	4
15	3	12.0094799	108.5090511	5
16	4	12.0153565	108.5236423	1
17	4	12.0123343	108.5284488	2
18	4	11.9943681	108.5430401	3
19	4	12.0079688	108.5612362	4
20	4	12.025934	108.557288	5
21	4	12.0314745	108.5488765	6
22	4	12.0153565	108.5236423	7
23	5	11.9903381	108.5416668	1
24	5	11.9764007	108.5183208	2
25	5	11.9681723	108.5511081	3
26	5	11.9782479	108.5632961	4
27	5	11.9903381	108.5416668	5
28	6	11.992521	108.5437267	1
29	6	11.980263	108.5662143	2
30	6	11.9948718	108.578574	3
31	6	12.0111589	108.5694759	4
32	6	11.992689	108.5454433	5
33	6	11.992521	108.5437267	6
\.


--
-- Data for Name: crop_growth_stage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crop_growth_stage (id, plant_id, stage_name, min_day, max_day, description) FROM stdin;
1	1	Germination	1	7	Seed begins to sprout.
2	1	Vegetative	8	30	Leaf and root growth.
3	2	Flowering	31	45	Flowers start forming.
4	2	Fruiting	46	75	Tomatoes grow and ripen.
\.


--
-- Data for Name: crop_season; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crop_season (id, field_id, plant_id, season_name, planting_date, expected_harvest_date, actual_harvest_date, note) FROM stdin;
1	1	1	Spring Season	2025-03-01	2025-05-15	\N	First lettuce season
2	2	2	Summer Season	2025-06-01	2025-08-20	\N	Tomato summer season
51	3	1	Spring Season 2025	2025-01-15	2025-05-15	\N	Rice spring season
52	4	2	Summer Season 2025	2025-03-01	2025-07-01	\N	Corn summer season
53	5	7	Winter Season 2025	2025-04-01	2025-06-01	\N	Vegetable winter season
54	6	8	Fall Season 2025	2025-05-01	2025-08-01	\N	Soybean fall season
55	2	10	Soybean Summer 2025	2025-05-01	2025-09-01	\N	Soybean in Field 2
56	1	2	Tomato in Field 1 2025	2025-01-01	2025-12-31	\N	Tomato season for Field 1
57	1	7	Rice in Field 1 2025	2025-01-01	2025-12-31	\N	Rice season for Field 1
58	1	8	Corn in Field 1 2025	2025-01-01	2025-12-31	\N	Corn season for Field 1
59	1	9	Vegetable in Field 1 2025	2025-01-01	2025-12-31	\N	Vegetable season for Field 1
60	1	10	Soybean in Field 1 2025	2025-01-01	2025-12-31	\N	Soybean season for Field 1
61	2	1	Lettuce in Field 2 2025	2025-01-01	2025-12-31	\N	Lettuce season for Field 2
62	2	7	Rice in Field 2 2025	2025-01-01	2025-12-31	\N	Rice season for Field 2
63	2	8	Corn in Field 2 2025	2025-01-01	2025-12-31	\N	Corn season for Field 2
64	2	9	Vegetable in Field 2 2025	2025-01-01	2025-12-31	\N	Vegetable season for Field 2
65	3	2	Tomato in Field 3 2025	2025-01-01	2025-12-31	\N	Tomato season for Field 3
66	3	7	Rice in Field 3 2025	2025-01-01	2025-12-31	\N	Rice season for Field 3
67	3	8	Corn in Field 3 2025	2025-01-01	2025-12-31	\N	Corn season for Field 3
68	3	9	Vegetable in Field 3 2025	2025-01-01	2025-12-31	\N	Vegetable season for Field 3
69	3	10	Soybean in Field 3 2025	2025-01-01	2025-12-31	\N	Soybean season for Field 3
70	4	1	Lettuce in Field 4 2025	2025-01-01	2025-12-31	\N	Lettuce season for Field 4
71	4	7	Rice in Field 4 2025	2025-01-01	2025-12-31	\N	Rice season for Field 4
72	4	8	Corn in Field 4 2025	2025-01-01	2025-12-31	\N	Corn season for Field 4
73	4	9	Vegetable in Field 4 2025	2025-01-01	2025-12-31	\N	Vegetable season for Field 4
74	4	10	Soybean in Field 4 2025	2025-01-01	2025-12-31	\N	Soybean season for Field 4
75	5	1	Lettuce in Field 5 2025	2025-01-01	2025-12-31	\N	Lettuce season for Field 5
76	5	2	Tomato in Field 5 2025	2025-01-01	2025-12-31	\N	Tomato season for Field 5
77	5	8	Corn in Field 5 2025	2025-01-01	2025-12-31	\N	Corn season for Field 5
78	5	9	Vegetable in Field 5 2025	2025-01-01	2025-12-31	\N	Vegetable season for Field 5
79	5	10	Soybean in Field 5 2025	2025-01-01	2025-12-31	\N	Soybean season for Field 5
80	6	1	Lettuce in Field 6 2025	2025-01-01	2025-12-31	\N	Lettuce season for Field 6
81	6	2	Tomato in Field 6 2025	2025-01-01	2025-12-31	\N	Tomato season for Field 6
82	6	7	Rice in Field 6 2025	2025-01-01	2025-12-31	\N	Rice season for Field 6
83	6	9	Vegetable in Field 6 2025	2025-01-01	2025-12-31	\N	Vegetable season for Field 6
84	6	10	Soybean in Field 6 2025	2025-01-01	2025-12-31	\N	Soybean season for Field 6
\.


--
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farm (id, farm_name, owner_id, lat, lng, area, region) FROM stdin;
1	Green Farm	3	10.762622	106.660172	5	TP. Đà Lạt
3	Sunny Farm	3	10.56432	106.34256	8	TP. Tuy Hòa
2	Farm Demo1 bo	3	\N	\N	7.5	Khu vực B
\.


--
-- Data for Name: fertilization_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fertilization_history (id, field_id, fertilizer_type, fertilizer_amount, fertilization_date) FROM stdin;
1	1	Nitrogen	10.5	2025-03-15
2	2	Phosphorus	8	2025-06-10
3	1	NPK 20-20-15	2.5	2025-05-17
\.


--
-- Data for Name: field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.field (id, farm_id, field_name, date_created, status, area, region, crop_season_id) FROM stdin;
1	1	Field 1	2025-05-20 22:20:31.155285	CRITICAL	5.33	TP Đà Lạt	\N
2	1	Field 2	2025-05-20 22:20:31.155285	WARNING	4.57	TP Đà Lạt	\N
3	1	Field 3	2025-05-20 22:20:31.155285	GOOD	6.15	TP Đà Lạt	\N
4	1	Field 4	2025-05-20 22:20:31.155285	CRITICAL	9.24	TP Đà Lạt	\N
5	1	Field 5	2025-05-20 22:20:31.155285	WARNING	6.15	TP Đà Lạt	\N
6	1	Field 6	2025-05-20 22:20:31.155285	GOOD	6.31	TP Đà Lạt	\N
\.


--
-- Data for Name: harvest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.harvest (id, crop_season_id, yield_kg, harvest_date, quality, notes) FROM stdin;
26	52	1200	2025-08-30	\N	\N
30	1	22222	2025-07-28	\N	\N
23	1	500	2025-07-27	\N	\N
31	1	2222	2025-07-17	\N	\N
32	1	2222	2025-07-17	\N	\N
33	1	11111	2025-07-27	\N	\N
24	60	5002	2025-07-28	\N	\N
\.


--
-- Data for Name: irrigation_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irrigation_history (id, field_id, action, "timestamp") FROM stdin;
1	1	Start	2025-03-20 08:00:00
2	2	Stop	2025-06-12 07:30:00
\.


--
-- Data for Name: plant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plant (id, plant_name, description) FROM stdin;
1	Lettuce	A leafy green vegetable.
2	Tomato	A fruit commonly used as a vegetable.
7	Rice	Rice plant for spring season
8	Corn	Corn plant for summer season
9	Vegetable	Vegetable plant for winter season
10	Soybean	Soybean plant for fall season
\.


--
-- Data for Name: sensor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sensor (id, field_id, sensor_name, lat, lng, type, installation_date, status, point_order, farm_id) FROM stdin;
1	1	Temp Sensor 1	12.025	108.518	Temperature	2025-05-21 13:16:18.788444	Active	\N	\N
2	1	TempSensorA_Update	12.0225	108.5145	Temperature	2025-05-17 10:00:00	Active	1	\N
3	2	Soil Moisture Sensor 1	12.0005	108.504	Soil Moisture	2025-05-21 13:16:18.788444	Active	\N	\N
4	2	Humidity Sensor 1	11.99	108.508	Humidity	2025-05-21 13:16:18.788444	Active	\N	\N
5	3	Temp Sensor 2	11.9975	108.52	Temperature	2025-05-21 13:16:18.788444	Active	\N	\N
6	3	Humidity Sensor 2	12.002	108.528	Humidity	2025-05-21 13:16:18.788444	Active	\N	\N
7	4	Temperature Sensor 3	12.012	108.532	Temperature	2025-05-25 08:00:00	Active	\N	\N
8	5	Humidity Sensor 3	11.991	108.527	Humidity	2025-05-25 08:30:00	Active	\N	\N
9	6	Soil Moisture Sensor 3	11.993	108.529	Soil Moisture	2025-05-25 09:00:00	Active	\N	\N
10	1	Light Sensor - Node 1	10.762622	106.660172	Light	2025-10-25 16:03:15.312336	Active	4	1
\.


--
-- Data for Name: sensor_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sensor_data (id, sensor_id, value, "time") FROM stdin;
1	1	28.5	2025-05-21 08:00:00
2	2	60	2025-05-21 08:05:00
3	3	12.5	2025-05-21 08:10:00
4	4	450	2025-05-21 08:15:00
5	5	30	2025-05-21 08:20:00
6	6	65	2025-05-21 08:25:00
7	1	23.353743958749924	2025-05-25 21:44:40.852336
8	2	25.026078438097894	2025-05-25 21:44:41.184584
9	3	36.47557006288455	2025-05-25 21:44:41.216305
10	4	76.13227440299875	2025-05-25 21:44:41.232196
11	5	19.003908591475337	2025-05-25 21:44:41.248402
12	6	83.68900688499683	2025-05-25 21:44:41.264444
13	7	25.35549022499506	2025-05-25 21:44:41.287587
14	8	83.02294488751834	2025-05-25 21:44:41.305179
15	9	55.245441913758135	2025-05-25 21:44:41.317668
16	1	14.005367990716428	2025-05-26 12:51:06.553137
17	2	44.58958306367216	2025-05-26 12:51:08.095423
18	3	27.79479465511999	2025-05-26 12:51:08.135642
19	4	66.64448354193914	2025-05-26 12:51:08.166383
20	5	24.87781276520279	2025-05-26 12:51:08.192973
21	6	47.37294154550737	2025-05-26 12:51:08.222796
22	7	17.136314240334244	2025-05-26 12:51:08.245452
23	8	60.187044479267186	2025-05-26 12:51:08.269601
24	9	56.24504494298732	2025-05-26 12:51:08.290648
25	1	31.702287728360087	2025-05-26 17:18:40.462723
26	2	39.3585288615657	2025-05-26 17:18:41.000281
27	3	54.25687094696799	2025-05-26 17:18:41.038213
28	4	61.3324544135249	2025-05-26 17:18:41.054204
29	5	31.303691095236626	2025-05-26 17:18:41.066376
30	6	36.448755433419784	2025-05-26 17:18:41.082569
31	7	27.265018811282275	2025-05-26 17:18:41.102749
32	8	57.53685243651269	2025-05-26 17:18:41.138264
33	9	41.72147357461073	2025-05-26 17:18:41.1687
34	1	23.7676194071299	2025-05-26 17:48:40.455457
35	2	32.63746423724663	2025-05-26 17:48:41.185371
36	3	53.479173370395564	2025-05-26 17:48:41.234325
37	4	83.7832360678923	2025-05-26 17:48:41.283226
38	5	40.25358505552043	2025-05-26 17:48:41.326797
39	6	32.40547331839507	2025-05-26 17:48:41.37756
40	7	41.4262816338387	2025-05-26 17:48:41.404589
41	8	60.566946012473004	2025-05-26 17:48:41.456247
42	9	49.956017697007326	2025-05-26 17:48:41.515498
43	1	27.464323766047308	2025-05-27 22:05:06.887135
44	2	14.593004673841545	2025-05-27 22:05:11.567698
45	3	57.11907013632357	2025-05-27 22:05:11.680262
46	4	73.80713784582915	2025-05-27 22:05:11.753515
47	5	25.934829950773327	2025-05-27 22:05:11.788793
48	6	63.0889743023159	2025-05-27 22:05:11.823642
49	7	37.80529746796469	2025-05-27 22:05:11.88023
50	8	50.11658242612323	2025-05-27 22:05:11.936943
51	9	15.31975072730116	2025-05-27 22:05:12.00221
52	1	22.192961002877574	2025-05-27 22:35:06.789831
53	2	20.994573046636358	2025-05-27 22:35:07.40061
54	3	54.83672227210881	2025-05-27 22:35:07.429478
55	4	43.738844541900605	2025-05-27 22:35:07.463824
56	5	22.79050979325872	2025-05-27 22:35:07.518315
57	6	88.87758652107678	2025-05-27 22:35:07.545481
58	7	32.7625599230196	2025-05-27 22:35:07.573183
59	8	57.274169463805315	2025-05-27 22:35:07.605538
60	9	48.36862692607831	2025-05-27 22:35:07.63243
61	1	13.864638086778768	2025-05-28 22:54:27.758351
62	2	19.845262629393353	2025-05-28 22:54:27.758351
63	3	15.413060913951236	2025-05-28 22:54:27.758351
64	4	46.79221341950705	2025-05-28 22:54:27.758351
65	5	16.97780193550583	2025-05-28 22:54:27.758351
66	6	66.53371195184216	2025-05-28 22:54:27.758351
67	7	18.10824361605385	2025-05-28 22:54:27.758351
68	8	30.44194818747749	2025-05-28 22:54:27.758351
69	9	26.282292588599617	2025-05-28 22:54:27.758351
70	1	32.37044046076449	2025-05-30 21:45:43.636876
71	2	19.88800198595589	2025-05-30 21:45:43.637712
72	3	26.373255841817137	2025-05-30 21:45:43.637712
73	4	33.15353829114332	2025-05-30 21:45:43.637712
74	5	44.19910586703239	2025-05-30 21:45:43.637712
75	6	35.326002924006545	2025-05-30 21:45:43.637712
76	7	12.115235578280537	2025-05-30 21:45:43.637712
77	8	80.73297780255388	2025-05-30 21:45:43.637712
78	9	52.763432281223544	2025-05-30 21:45:43.637712
79	1	20.315432677911286	2025-05-30 22:01:04.618571
80	2	13.71947170879351	2025-05-30 22:01:04.618571
81	3	35.53340576739955	2025-05-30 22:01:04.618571
82	4	88.15470951648106	2025-05-30 22:01:04.618571
83	5	38.2664003365788	2025-05-30 22:01:04.618571
84	6	91.17743006708898	2025-05-30 22:01:04.618571
85	7	28.1531226322043	2025-05-30 22:01:04.618571
86	8	47.791878720242366	2025-05-30 22:01:04.618571
87	9	18.367437258081942	2025-05-30 22:01:04.618571
88	1	24.53342738703342	2025-06-04 22:51:35.775006
89	2	19.073877590899762	2025-06-04 22:51:35.776234
90	3	21.666891296499635	2025-06-04 22:51:35.776234
91	4	57.07133629709347	2025-06-04 22:51:35.776234
92	5	23.2680071056066	2025-06-04 22:51:35.776234
93	6	66.48664185129749	2025-06-04 22:51:35.776234
94	7	22.221276205838073	2025-06-04 22:51:35.776234
95	8	84.77647080668592	2025-06-04 22:51:35.776234
96	9	20.08990819814067	2025-06-04 22:51:35.776234
97	1	35.827261214156586	2025-06-05 21:55:47.544176
98	2	43.7278820517257	2025-06-05 21:55:47.546182
99	3	58.09375666616697	2025-06-05 21:55:47.546182
100	4	93.77869954439976	2025-06-05 21:55:47.546182
101	5	27.050820019134537	2025-06-05 21:55:47.546182
102	6	74.8452008183411	2025-06-05 21:55:47.546182
103	7	37.67731168004456	2025-06-05 21:55:47.546182
104	8	78.7637781454817	2025-06-05 21:55:47.546182
105	9	35.04279164991864	2025-06-05 21:55:47.546182
106	1	21.529583819530686	2025-06-05 21:57:09.211321
107	2	29.73681616253637	2025-06-05 21:57:09.214528
108	3	46.00276883927812	2025-06-05 21:57:09.214528
109	4	89.65401615262817	2025-06-05 21:57:09.214528
110	5	36.71373027424771	2025-06-05 21:57:09.214528
111	6	76.27082045469264	2025-06-05 21:57:09.214528
112	7	29.86914042834081	2025-06-05 21:57:09.214528
113	8	53.25861446290021	2025-06-05 21:57:09.214528
114	9	24.536049427407693	2025-06-05 21:57:09.214528
115	1	13.710465321175086	2025-06-05 21:57:43.067783
116	2	28.309620648932675	2025-06-05 21:57:43.06879
117	3	44.215362686623195	2025-06-05 21:57:43.06879
118	4	81.1157986759824	2025-06-05 21:57:43.06879
119	5	12.68959969911508	2025-06-05 21:57:43.06879
120	6	74.59552222313624	2025-06-05 21:57:43.06879
121	7	10.154192417229348	2025-06-05 21:57:43.06879
122	8	62.0895612724473	2025-06-05 21:57:43.06879
123	9	48.74654676508508	2025-06-05 21:57:43.06879
124	1	14.948769201736447	2025-06-05 22:27:43.046039
125	2	34.703152663442026	2025-06-05 22:27:43.049037
126	3	22.003073042216407	2025-06-05 22:27:43.049037
127	4	63.91499298027906	2025-06-05 22:27:43.049037
128	5	27.39730072742294	2025-06-05 22:27:43.049037
129	6	66.07785258679891	2025-06-05 22:27:43.049037
130	7	36.703437495621785	2025-06-05 22:27:43.049037
131	8	61.394723541830686	2025-06-05 22:27:43.049037
132	9	55.32316148330894	2025-06-05 22:27:43.049037
133	1	26.409847930546626	2025-06-06 12:34:44.894607
134	2	44.58538852607228	2025-06-06 12:34:44.895609
135	3	54.62905289083724	2025-06-06 12:34:44.895609
136	4	49.69355722698063	2025-06-06 12:34:44.895609
137	5	15.575100621865346	2025-06-06 12:34:44.895609
138	6	78.39943436505826	2025-06-06 12:34:44.895609
139	7	26.09742720469921	2025-06-06 12:34:44.895609
140	8	65.62133004536051	2025-06-06 12:34:44.895609
141	9	25.248427712119515	2025-06-06 12:34:44.895609
142	1	33.02088305944111	2025-06-06 13:04:44.78008
143	2	16.11054707264528	2025-06-06 13:04:44.782104
144	3	57.52581051464586	2025-06-06 13:04:44.782104
145	4	43.92504853813517	2025-06-06 13:04:44.782104
146	5	36.85787866644558	2025-06-06 13:04:44.782104
147	6	33.4473350148552	2025-06-06 13:04:44.782104
148	7	19.893471749992436	2025-06-06 13:04:44.782104
149	8	68.96986987002185	2025-06-06 13:04:44.782104
150	9	50.6089960500069	2025-06-06 13:04:44.782104
151	1	23.980730454262083	2025-06-06 13:34:44.964612
152	2	41.5579725000475	2025-06-06 13:34:44.964612
153	3	20.664879079151504	2025-06-06 13:34:44.964612
154	4	57.7844879849349	2025-06-06 13:34:44.964612
155	5	44.22804692301433	2025-06-06 13:34:44.964612
156	6	43.10627749744498	2025-06-06 13:34:44.964612
157	7	15.236706479225912	2025-06-06 13:34:44.964612
158	8	87.94784573480366	2025-06-06 13:34:44.966618
159	9	29.677206683321124	2025-06-06 13:34:44.966618
160	1	10.975943565130889	2025-06-06 14:06:22.403507
161	2	17.459301840414817	2025-06-06 14:06:22.403507
162	3	51.3891871154256	2025-06-06 14:06:22.403507
163	4	42.142674941384655	2025-06-06 14:06:22.403507
164	5	25.367157484391036	2025-06-06 14:06:22.403507
165	6	50.87575788884752	2025-06-06 14:06:22.403507
166	7	22.309051813456772	2025-06-06 14:06:22.403507
167	8	85.84995899084836	2025-06-06 14:06:22.403507
168	9	27.268417716490276	2025-06-06 14:06:22.403507
169	1	44.506314572108224	2025-06-06 14:34:45.453825
170	2	38.838791830906786	2025-06-06 14:34:45.457671
171	3	54.04577414750813	2025-06-06 14:34:45.457671
172	4	86.60026993452828	2025-06-06 14:34:45.457671
173	5	43.77709974860575	2025-06-06 14:34:45.457671
174	6	76.94603328948972	2025-06-06 14:34:45.457671
175	7	35.170811987810154	2025-06-06 14:34:45.457671
176	8	49.96415898532775	2025-06-06 14:34:45.457671
177	9	49.185221415959695	2025-06-06 14:34:45.457671
178	1	12.380446033128553	2025-06-06 14:41:18.046606
179	2	44.57697636258617	2025-06-06 14:41:18.047878
180	3	46.26372467492749	2025-06-06 14:41:18.047878
181	4	81.35868793600517	2025-06-06 14:41:18.047878
182	5	44.21301304232326	2025-06-06 14:41:18.047878
183	6	74.69268200558263	2025-06-06 14:41:18.047878
184	7	34.672777759915036	2025-06-06 14:41:18.047878
185	8	31.12934481370139	2025-06-06 14:41:18.047878
186	9	36.030919397150335	2025-06-06 14:41:18.047878
187	1	28.960725228406357	2025-06-06 14:41:35.031828
188	2	41.07786654073587	2025-06-06 14:41:35.032834
189	3	57.1154910754277	2025-06-06 14:41:35.032834
190	4	76.8346383025397	2025-06-06 14:41:35.032834
191	5	14.098521686153285	2025-06-06 14:41:35.032834
192	6	71.54722482055047	2025-06-06 14:41:35.032834
193	7	14.883471897512475	2025-06-06 14:41:35.032834
194	8	61.82416536796057	2025-06-06 14:41:35.032834
195	9	47.09889564119066	2025-06-06 14:41:35.032834
196	1	19.186251556463752	2025-06-24 07:27:46.165504
197	2	12.951173278359619	2025-06-24 07:27:46.166163
198	3	58.166748714207145	2025-06-24 07:27:46.166163
199	4	38.96230024284197	2025-06-24 07:27:46.166163
200	5	34.69617529911979	2025-06-24 07:27:46.166163
201	6	70.47946554531332	2025-06-24 07:27:46.166163
202	7	17.055033258022917	2025-06-24 07:27:46.166163
203	8	42.71595426116823	2025-06-24 07:27:46.166163
204	9	27.106716745651703	2025-06-24 07:27:46.166163
205	1	29.73978795318139	2025-06-24 07:30:59.299194
206	2	26.16625001022261	2025-06-24 07:30:59.301201
207	3	44.21013609972114	2025-06-24 07:30:59.301201
208	4	38.52594092975916	2025-06-24 07:30:59.301201
209	5	33.850012069940306	2025-06-24 07:30:59.301201
210	6	50.94061464983828	2025-06-24 07:30:59.301201
211	7	23.610427615774434	2025-06-24 07:30:59.301201
212	8	83.80622585069284	2025-06-24 07:30:59.301201
213	9	46.07743438269284	2025-06-24 07:30:59.301201
214	1	12.96282471844205	2025-06-24 08:00:59.29258
215	2	41.1132323935407	2025-06-24 08:00:59.29258
216	3	21.2692181983955	2025-06-24 08:00:59.29258
217	4	74.8614708930834	2025-06-24 08:00:59.29258
218	5	42.89826962506898	2025-06-24 08:00:59.29258
219	6	48.15229699563203	2025-06-24 08:00:59.29258
220	7	34.458858034393636	2025-06-24 08:00:59.29258
221	8	62.14703101627736	2025-06-24 08:00:59.29258
222	9	51.7450796250313	2025-06-24 08:00:59.29258
223	1	10.549746061410014	2025-06-24 08:19:52.520557
224	2	32.43325010367869	2025-06-24 08:19:52.523071
225	3	16.728450455795095	2025-06-24 08:19:52.523071
226	4	50.32072504161838	2025-06-24 08:19:52.523071
227	5	37.634549068864374	2025-06-24 08:19:52.523071
228	6	37.33965773423582	2025-06-24 08:19:52.523071
229	7	12.04760434096642	2025-06-24 08:19:52.527586
230	8	88.28490419161423	2025-06-24 08:19:52.527586
231	9	28.0758626757925	2025-06-24 08:19:52.527586
232	1	36.654847278410216	2025-07-11 20:41:21.369068
233	2	37.36587951940467	2025-07-11 20:41:21.369068
234	3	39.632069984463385	2025-07-11 20:41:21.369068
235	4	72.41419261478013	2025-07-11 20:41:21.369068
236	5	14.133718268632064	2025-07-11 20:41:21.369068
237	6	80.48562440230077	2025-07-11 20:41:21.369068
238	7	33.816868848873966	2025-07-11 20:41:21.369068
239	8	46.29642199907068	2025-07-11 20:41:21.369068
240	9	50.34689955522914	2025-07-11 20:41:21.369068
241	1	32.00518246722238	2025-07-27 13:35:09.851299
242	2	36.412304494774624	2025-07-27 13:35:09.852415
243	3	32.572651405705244	2025-07-27 13:35:09.852415
244	4	81.13549682380726	2025-07-27 13:35:09.852415
245	5	22.55318031817565	2025-07-27 13:35:09.852415
246	6	79.28877775241757	2025-07-27 13:35:09.852415
247	7	41.847397558808964	2025-07-27 13:35:09.852415
248	8	91.01316498965386	2025-07-27 13:35:09.852415
249	9	42.029673082383134	2025-07-27 13:35:09.852415
250	1	41.23562527184555	2025-07-27 13:44:33.816657
251	2	26.619638644136717	2025-07-27 13:44:33.817749
252	3	46.1855326279892	2025-07-27 13:44:33.817749
253	4	68.75103323395427	2025-07-27 13:44:33.817749
254	5	18.32922738284698	2025-07-27 13:44:33.817749
255	6	64.51724857895192	2025-07-27 13:44:33.819311
256	7	41.330002272183194	2025-07-27 13:44:33.819311
257	8	81.47907628860504	2025-07-27 13:44:33.819311
258	9	43.79748614473793	2025-07-27 13:44:33.819311
259	1	29.55139660260423	2025-07-27 13:45:02.590883
260	2	27.40153391443635	2025-07-27 13:45:02.590883
261	3	48.042999547035656	2025-07-27 13:45:02.591456
262	4	93.60338580679218	2025-07-27 13:45:02.591456
263	5	36.16129870728939	2025-07-27 13:45:02.591456
264	6	65.48119010859756	2025-07-27 13:45:02.591456
265	7	17.19792797992993	2025-07-27 13:45:02.591456
266	8	89.0853152723824	2025-07-27 13:45:02.591456
267	9	34.92882325804801	2025-07-27 13:45:02.591456
268	1	15.466753945305332	2025-07-27 13:45:09.281155
269	2	43.96281197127531	2025-07-27 13:45:09.281155
270	3	44.96572204464091	2025-07-27 13:45:09.281155
271	4	65.29204444707452	2025-07-27 13:45:09.281155
272	5	12.261778423953064	2025-07-27 13:45:09.281155
273	6	67.36234740742537	2025-07-27 13:45:09.281155
274	7	20.743884963301532	2025-07-27 13:45:09.281155
275	8	76.06301859889302	2025-07-27 13:45:09.281155
276	9	21.820453886815358	2025-07-27 13:45:09.281155
277	1	30.197198372252274	2025-07-27 14:15:09.229192
278	2	37.86371806484947	2025-07-27 14:15:09.229192
279	3	57.92229804144363	2025-07-27 14:15:09.229192
280	4	55.42251965370633	2025-07-27 14:15:09.229192
281	5	17.954152618490312	2025-07-27 14:15:09.229192
282	6	47.04684420085428	2025-07-27 14:15:09.229192
283	7	17.825699722824346	2025-07-27 14:15:09.229192
284	8	55.33970531637175	2025-07-27 14:15:09.229192
285	9	17.28538602790046	2025-07-27 14:15:09.229192
286	1	27.190668513226253	2025-07-27 14:45:09.301335
287	2	32.406599115428634	2025-07-27 14:45:09.301335
288	3	44.78623101085574	2025-07-27 14:45:09.301335
289	4	78.65297990844996	2025-07-27 14:45:09.301335
290	5	17.276470640292782	2025-07-27 14:45:09.301335
291	6	42.86908679562629	2025-07-27 14:45:09.301335
292	7	11.904720288071207	2025-07-27 14:45:09.301335
293	8	50.88156134421544	2025-07-27 14:45:09.301335
294	9	59.566432572216094	2025-07-27 14:45:09.301335
295	7	28	2024-10-28 20:50:56
296	8	58	2024-10-28 20:50:56
297	9	100	2024-10-28 20:50:56
298	10	23	2024-10-28 20:50:56
299	7	28	2024-10-28 20:50:56
300	8	58	2024-10-28 20:50:56
301	9	100	2024-10-28 20:50:56
302	10	23	2024-10-28 20:50:56
303	7	26.7	1970-01-01 07:00:00
304	8	61	1970-01-01 07:00:00
305	9	100	1970-01-01 07:00:00
306	10	18	1970-01-01 07:00:00
307	7	26.7	1970-01-01 07:00:05
308	8	61	1970-01-01 07:00:05
309	9	100	1970-01-01 07:00:05
310	10	18	1970-01-01 07:00:05
311	7	26.7	1970-01-01 07:00:10
312	8	61	1970-01-01 07:00:10
313	9	100	1970-01-01 07:00:10
314	10	18	1970-01-01 07:00:10
315	7	26.7	1970-01-01 07:00:15
316	8	61	1970-01-01 07:00:15
317	9	99	1970-01-01 07:00:15
318	10	18	1970-01-01 07:00:15
319	7	26.7	1970-01-01 07:00:20
320	8	61	1970-01-01 07:00:20
321	9	100	1970-01-01 07:00:20
322	10	18	1970-01-01 07:00:20
323	7	28	2024-10-28 20:50:56
324	8	58	2024-10-28 20:50:56
325	9	100	2024-10-28 20:50:56
326	10	23	2024-10-28 20:50:56
327	7	28.37	2024-10-27 03:33:20
328	8	61.2	2024-10-27 03:33:20
329	9	44	2024-10-27 03:33:20
330	10	82	2024-10-27 03:33:20
331	7	28.37	2024-10-27 03:33:20
332	8	61.2	2024-10-27 03:33:20
333	9	44	2024-10-27 03:33:20
334	10	82	2024-10-27 03:33:20
335	7	28.37	2024-10-27 03:33:20
336	8	61.2	2024-10-27 03:33:20
337	9	44	2024-10-27 03:33:20
338	10	82	2024-10-27 03:33:20
339	7	28.37	2024-10-27 03:33:20
340	8	61.2	2024-10-27 03:33:20
341	9	44	2024-10-27 03:33:20
342	10	82	2024-10-27 03:33:20
343	7	28.8	2024-10-27 03:33:20
344	8	60.5	2024-10-27 03:33:20
345	9	42	2024-10-27 03:33:20
346	10	55	2024-10-27 03:33:20
347	7	31.8	2025-11-08 16:12:40
348	8	39	2025-11-08 16:12:40
349	9	0	2025-11-08 16:12:40
350	10	77	2025-11-08 16:12:40
351	7	31.8	2025-11-08 16:12:51
352	8	39	2025-11-08 16:12:51
353	9	0	2025-11-08 16:12:51
354	10	78	2025-11-08 16:12:51
355	7	31.8	2025-11-08 16:13:04
356	8	39	2025-11-08 16:13:04
357	9	0	2025-11-08 16:13:04
358	10	78	2025-11-08 16:13:04
359	7	31.8	2025-11-08 16:13:16
360	8	39	2025-11-08 16:13:16
361	9	0	2025-11-08 16:13:16
362	10	78	2025-11-08 16:13:16
363	7	30.2	2025-11-08 16:13:27
364	8	37	2025-11-08 16:13:27
365	9	0	2025-11-08 16:13:27
366	10	76	2025-11-08 16:13:27
367	7	30.2	2025-11-08 16:13:39
368	8	37	2025-11-08 16:13:39
369	9	0	2025-11-08 16:13:39
370	10	76	2025-11-08 16:13:39
371	7	30.2	2025-11-08 16:13:50
372	8	37	2025-11-08 16:13:50
373	9	0	2025-11-08 16:13:50
374	10	76	2025-11-08 16:13:50
375	7	30.8	2025-11-08 16:14:10
376	8	36	2025-11-08 16:14:10
377	9	0	2025-11-08 16:14:10
378	10	76	2025-11-08 16:14:10
379	7	30.8	2025-11-08 16:14:26
380	8	36	2025-11-08 16:14:26
381	9	0	2025-11-08 16:14:26
382	10	76	2025-11-08 16:14:26
383	7	30.8	2025-11-08 16:14:41
384	8	36	2025-11-08 16:14:41
385	9	0	2025-11-08 16:14:41
386	10	76	2025-11-08 16:14:41
387	7	30.8	2025-11-08 16:14:55
388	8	36	2025-11-08 16:14:55
389	9	0	2025-11-08 16:14:55
390	10	77	2025-11-08 16:14:55
391	7	30.8	2025-11-08 16:15:26
392	8	36	2025-11-08 16:15:26
393	9	0	2025-11-08 16:15:26
394	10	76	2025-11-08 16:15:26
395	7	30.8	2025-11-08 16:15:40
396	8	36	2025-11-08 16:15:40
397	9	0	2025-11-08 16:15:40
398	10	76	2025-11-08 16:15:40
399	7	30.8	2025-11-08 16:15:55
400	8	36	2025-11-08 16:15:55
401	9	0	2025-11-08 16:15:55
402	10	76	2025-11-08 16:15:55
403	7	30.8	2025-11-08 16:16:10
404	8	36	2025-11-08 16:16:10
405	9	0	2025-11-08 16:16:10
406	10	76	2025-11-08 16:16:10
407	7	30.8	2025-11-08 16:21:13
408	8	34	2025-11-08 16:21:13
409	9	0	2025-11-08 16:21:13
410	10	77	2025-11-08 16:21:13
411	7	30.8	2025-11-08 16:21:29
412	8	34	2025-11-08 16:21:29
413	9	0	2025-11-08 16:21:29
414	10	77	2025-11-08 16:21:29
415	7	30.8	2025-11-08 16:21:45
416	8	33	2025-11-08 16:21:45
417	9	0	2025-11-08 16:21:45
418	10	77	2025-11-08 16:21:45
419	7	30.8	2025-11-08 16:21:56
420	8	33	2025-11-08 16:21:56
421	9	0	2025-11-08 16:21:56
422	10	77	2025-11-08 16:21:56
423	7	30.8	2025-11-08 16:22:10
424	8	33	2025-11-08 16:22:10
425	9	0	2025-11-08 16:22:10
426	10	77	2025-11-08 16:22:10
427	7	30.8	2025-11-08 16:22:26
428	8	33	2025-11-08 16:22:26
429	9	0	2025-11-08 16:22:26
430	10	77	2025-11-08 16:22:26
431	7	30.8	2025-11-08 16:22:41
432	8	34	2025-11-08 16:22:41
433	9	0	2025-11-08 16:22:41
434	10	77	2025-11-08 16:22:41
435	7	30.8	2025-11-08 16:22:56
436	8	34	2025-11-08 16:22:56
437	9	0	2025-11-08 16:22:56
438	10	77	2025-11-08 16:22:56
439	7	30.8	2025-11-08 16:23:16
440	8	34	2025-11-08 16:23:16
441	9	0	2025-11-08 16:23:16
442	10	77	2025-11-08 16:23:16
443	7	30.8	2025-11-08 16:23:25
444	8	34	2025-11-08 16:23:25
445	9	0	2025-11-08 16:23:25
446	10	77	2025-11-08 16:23:25
447	7	30.8	2025-11-08 16:23:40
448	8	33	2025-11-08 16:23:40
449	9	0	2025-11-08 16:23:40
450	10	77	2025-11-08 16:23:40
451	7	30.8	2025-11-08 16:24:00
452	8	33	2025-11-08 16:24:00
453	9	0	2025-11-08 16:24:00
454	10	77	2025-11-08 16:24:00
455	7	25.5	2025-11-09 06:49:41
456	8	60	2025-11-09 06:49:41
457	9	45	2025-11-09 06:49:41
458	10	50	2025-11-09 06:49:41
459	7	23.8	2025-11-19 02:15:17
460	8	29	2025-11-19 02:15:17
461	9	0	2025-11-19 02:15:17
462	10	16	2025-11-19 02:15:17
463	7	23.8	2025-11-19 02:15:32
464	8	29	2025-11-19 02:15:32
465	9	0	2025-11-19 02:15:32
466	10	16	2025-11-19 02:15:32
467	7	23.8	2025-11-19 02:15:47
468	8	29	2025-11-19 02:15:47
469	9	0	2025-11-19 02:15:47
470	10	16	2025-11-19 02:15:47
471	7	23.8	2025-11-19 02:16:03
472	8	29	2025-11-19 02:16:03
473	9	0	2025-11-19 02:16:03
474	10	16	2025-11-19 02:16:03
475	7	23.8	2025-11-19 02:16:14
476	8	29	2025-11-19 02:16:14
477	9	0	2025-11-19 02:16:14
478	10	16	2025-11-19 02:16:14
479	7	23.8	2025-11-19 02:16:30
480	8	29	2025-11-19 02:16:30
481	9	0	2025-11-19 02:16:30
482	10	16	2025-11-19 02:16:30
483	7	23.8	2025-11-19 02:16:39
484	8	29	2025-11-19 02:16:39
485	9	0	2025-11-19 02:16:39
486	10	16	2025-11-19 02:16:39
487	7	23.8	2025-11-19 02:16:48
488	8	29	2025-11-19 02:16:48
489	9	0	2025-11-19 02:16:48
490	10	16	2025-11-19 02:16:48
491	7	23.8	2025-11-19 02:17:05
492	8	29	2025-11-19 02:17:05
493	9	0	2025-11-19 02:17:05
494	10	16	2025-11-19 02:17:05
495	7	23.8	2025-11-19 02:17:20
496	8	29	2025-11-19 02:17:20
497	9	0	2025-11-19 02:17:20
498	10	16	2025-11-19 02:17:20
499	7	23.8	2025-11-19 02:17:35
500	8	29	2025-11-19 02:17:35
501	9	0	2025-11-19 02:17:35
502	10	16	2025-11-19 02:17:35
503	7	23.8	2025-11-19 02:17:49
504	8	29	2025-11-19 02:17:49
505	9	0	2025-11-19 02:17:49
506	10	16	2025-11-19 02:17:49
507	7	23.8	2025-11-19 02:18:04
508	8	29	2025-11-19 02:18:04
509	9	0	2025-11-19 02:18:04
510	10	16	2025-11-19 02:18:04
511	7	23.8	2025-11-19 02:18:18
512	8	29	2025-11-19 02:18:18
513	9	0	2025-11-19 02:18:18
514	10	16	2025-11-19 02:18:18
515	7	23.8	2025-11-19 02:18:28
516	8	29	2025-11-19 02:18:28
517	9	0	2025-11-19 02:18:28
518	10	16	2025-11-19 02:18:28
519	7	23.8	2025-11-19 02:18:42
520	8	29	2025-11-19 02:18:42
521	9	0	2025-11-19 02:18:42
522	10	16	2025-11-19 02:18:42
523	7	23.8	2025-11-19 02:18:57
524	8	29	2025-11-19 02:18:57
525	9	0	2025-11-19 02:18:57
526	10	16	2025-11-19 02:18:57
527	7	23.8	2025-11-19 02:19:07
528	8	29	2025-11-19 02:19:07
529	9	0	2025-11-19 02:19:07
530	10	16	2025-11-19 02:19:07
531	7	23.8	2025-11-19 02:19:21
532	8	29	2025-11-19 02:19:21
533	9	0	2025-11-19 02:19:21
534	10	16	2025-11-19 02:19:21
535	7	23.8	2025-11-19 02:19:30
536	8	29	2025-11-19 02:19:30
537	9	0	2025-11-19 02:19:30
538	10	16	2025-11-19 02:19:30
539	7	23.8	2025-11-19 02:19:46
540	8	29	2025-11-19 02:19:46
541	9	0	2025-11-19 02:19:46
542	10	16	2025-11-19 02:19:46
543	7	23.8	2025-11-19 02:20:00
544	8	29	2025-11-19 02:20:00
545	9	0	2025-11-19 02:20:00
546	10	16	2025-11-19 02:20:00
547	7	23.8	2025-11-19 02:20:14
548	8	29	2025-11-19 02:20:14
549	9	0	2025-11-19 02:20:14
550	10	16	2025-11-19 02:20:14
551	7	23.8	2025-11-19 02:20:29
552	8	29	2025-11-19 02:20:29
553	9	0	2025-11-19 02:20:29
554	10	16	2025-11-19 02:20:29
555	7	23.8	2025-11-19 02:20:45
556	8	29	2025-11-19 02:20:45
557	9	0	2025-11-19 02:20:45
558	10	16	2025-11-19 02:20:45
559	7	23.8	2025-11-19 02:20:54
560	8	29	2025-11-19 02:20:54
561	9	0	2025-11-19 02:20:54
562	10	16	2025-11-19 02:20:54
563	7	23.8	2025-11-19 02:21:10
564	8	29	2025-11-19 02:21:10
565	9	0	2025-11-19 02:21:10
566	10	16	2025-11-19 02:21:10
567	7	23.8	2025-11-19 02:21:37
568	8	29	2025-11-19 02:21:37
569	9	0	2025-11-19 02:21:37
570	10	16	2025-11-19 02:21:37
571	7	23.8	2025-11-19 02:21:51
572	8	29	2025-11-19 02:21:51
573	9	0	2025-11-19 02:21:51
574	10	15	2025-11-19 02:21:51
575	7	23.8	2025-11-19 02:22:08
576	8	29	2025-11-19 02:22:08
577	9	0	2025-11-19 02:22:08
578	10	16	2025-11-19 02:22:08
579	7	23.8	2025-11-19 02:22:23
580	8	29	2025-11-19 02:22:23
581	9	0	2025-11-19 02:22:23
582	10	15	2025-11-19 02:22:23
583	7	23.8	2025-11-19 02:22:34
584	8	29	2025-11-19 02:22:34
585	9	0	2025-11-19 02:22:34
586	10	16	2025-11-19 02:22:34
587	7	23.8	2025-11-19 02:22:49
588	8	29	2025-11-19 02:22:49
589	9	0	2025-11-19 02:22:49
590	10	15	2025-11-19 02:22:49
591	7	23.8	2025-11-19 02:23:10
592	8	29	2025-11-19 02:23:10
593	9	0	2025-11-19 02:23:10
594	10	15	2025-11-19 02:23:10
595	7	23.8	2025-11-19 02:23:26
596	8	29	2025-11-19 02:23:26
597	9	0	2025-11-19 02:23:26
598	10	15	2025-11-19 02:23:26
599	7	23.8	2025-11-19 02:23:41
600	8	29	2025-11-19 02:23:41
601	9	0	2025-11-19 02:23:41
602	10	16	2025-11-19 02:23:41
603	7	23.8	2025-11-19 02:23:55
604	8	29	2025-11-19 02:23:55
605	9	0	2025-11-19 02:23:55
606	10	15	2025-11-19 02:23:55
607	7	23.8	2025-11-19 02:24:13
608	8	29	2025-11-19 02:24:13
609	9	0	2025-11-19 02:24:13
610	10	16	2025-11-19 02:24:13
611	7	23.8	2025-11-19 02:24:30
612	8	29	2025-11-19 02:24:30
613	9	0	2025-11-19 02:24:30
614	10	15	2025-11-19 02:24:30
615	7	23.8	2025-11-19 02:24:40
616	8	29	2025-11-19 02:24:40
617	9	0	2025-11-19 02:24:40
618	10	16	2025-11-19 02:24:40
619	9	0	2025-11-19 08:59:43
620	10	12	2025-11-19 08:59:43
621	9	0	2025-11-19 08:59:58
622	10	12	2025-11-19 08:59:58
623	7	25.8	2025-11-19 09:01:22
624	8	64	2025-11-19 09:01:22
625	9	0	2025-11-19 09:01:22
626	10	10	2025-11-19 09:01:22
627	7	25.8	2025-11-19 09:01:36
628	8	64	2025-11-19 09:01:36
629	9	0	2025-11-19 09:01:36
630	10	10	2025-11-19 09:01:36
631	7	25.8	2025-11-19 09:01:46
632	8	64	2025-11-19 09:01:46
633	9	0	2025-11-19 09:01:46
634	10	10	2025-11-19 09:01:46
635	7	25.8	2025-11-19 09:02:00
636	8	64	2025-11-19 09:02:00
637	9	0	2025-11-19 09:02:00
638	10	10	2025-11-19 09:02:00
639	7	25.8	2025-11-19 09:02:09
640	8	64	2025-11-19 09:02:09
641	9	0	2025-11-19 09:02:09
642	10	10	2025-11-19 09:02:09
643	7	25.8	2025-11-19 09:02:24
644	8	64	2025-11-19 09:02:24
645	9	0	2025-11-19 09:02:24
646	10	10	2025-11-19 09:02:24
647	7	25.8	2025-11-19 09:02:33
648	8	64	2025-11-19 09:02:33
649	9	0	2025-11-19 09:02:33
650	10	10	2025-11-19 09:02:33
651	7	25.8	2025-11-19 09:02:47
652	8	64	2025-11-19 09:02:47
653	9	0	2025-11-19 09:02:47
654	10	10	2025-11-19 09:02:47
655	7	25.8	2025-11-19 09:02:57
656	8	64	2025-11-19 09:02:57
657	9	0	2025-11-19 09:02:57
658	10	10	2025-11-19 09:02:57
659	7	25.8	2025-11-19 09:03:06
660	8	64	2025-11-19 09:03:06
661	9	0	2025-11-19 09:03:06
662	10	10	2025-11-19 09:03:06
663	7	25.8	2025-11-19 09:03:21
664	8	64	2025-11-19 09:03:21
665	9	0	2025-11-19 09:03:21
666	10	10	2025-11-19 09:03:21
667	7	26.2	2025-11-19 09:03:34
668	8	64	2025-11-19 09:03:34
669	9	0	2025-11-19 09:03:34
670	10	10	2025-11-19 09:03:34
671	7	26.2	2025-11-19 09:03:48
672	8	64	2025-11-19 09:03:48
673	9	0	2025-11-19 09:03:48
674	10	10	2025-11-19 09:03:48
675	7	26.2	2025-11-19 09:03:58
676	8	64	2025-11-19 09:03:58
677	9	0	2025-11-19 09:03:58
678	10	10	2025-11-19 09:03:58
679	7	26.2	2025-11-19 09:04:12
680	8	64	2025-11-19 09:04:12
681	9	0	2025-11-19 09:04:12
682	10	10	2025-11-19 09:04:12
683	7	26.2	2025-11-19 09:04:22
684	8	64	2025-11-19 09:04:22
685	9	0	2025-11-19 09:04:22
686	10	10	2025-11-19 09:04:22
687	7	26.2	2025-11-19 09:04:36
688	8	64	2025-11-19 09:04:36
689	9	0	2025-11-19 09:04:36
690	10	10	2025-11-19 09:04:36
691	7	26.2	2025-11-19 09:04:46
692	8	64	2025-11-19 09:04:46
693	9	0	2025-11-19 09:04:46
694	10	10	2025-11-19 09:04:46
695	7	26.2	2025-11-19 09:05:00
696	8	64	2025-11-19 09:05:00
697	9	0	2025-11-19 09:05:00
698	10	10	2025-11-19 09:05:00
699	7	26.2	2025-11-19 09:05:09
700	8	64	2025-11-19 09:05:09
701	9	0	2025-11-19 09:05:09
702	10	10	2025-11-19 09:05:09
703	7	26.2	2025-11-19 09:05:18
704	8	64	2025-11-19 09:05:18
705	9	0	2025-11-19 09:05:18
706	10	10	2025-11-19 09:05:18
707	7	26.2	2025-11-19 09:05:28
708	8	64	2025-11-19 09:05:28
709	9	0	2025-11-19 09:05:28
710	10	10	2025-11-19 09:05:28
711	7	26.2	2025-11-19 09:05:41
712	8	64	2025-11-19 09:05:41
713	9	0	2025-11-19 09:05:41
714	10	10	2025-11-19 09:05:41
715	7	26.2	2025-11-19 09:05:55
716	8	64	2025-11-19 09:05:55
717	9	0	2025-11-19 09:05:55
718	10	10	2025-11-19 09:05:55
719	7	26.2	2025-11-19 09:06:10
720	8	64	2025-11-19 09:06:10
721	9	0	2025-11-19 09:06:10
722	10	10	2025-11-19 09:06:10
723	7	26.2	2025-11-19 09:06:24
724	8	64	2025-11-19 09:06:24
725	9	0	2025-11-19 09:06:24
726	10	10	2025-11-19 09:06:24
727	7	26.2	2025-11-19 09:06:33
728	8	64	2025-11-19 09:06:33
729	9	0	2025-11-19 09:06:33
730	10	10	2025-11-19 09:06:33
731	7	26.2	2025-11-19 09:06:48
732	8	64	2025-11-19 09:06:48
733	9	0	2025-11-19 09:06:48
734	10	10	2025-11-19 09:06:48
735	7	26.2	2025-11-19 09:06:57
736	8	64	2025-11-19 09:06:57
737	9	0	2025-11-19 09:06:57
738	10	10	2025-11-19 09:06:57
739	7	26.2	2025-11-19 09:07:06
740	8	64	2025-11-19 09:07:06
741	9	0	2025-11-19 09:07:06
742	10	10	2025-11-19 09:07:06
743	7	26.2	2025-11-19 09:07:21
744	8	64	2025-11-19 09:07:21
745	9	0	2025-11-19 09:07:21
746	10	10	2025-11-19 09:07:21
747	7	26.2	2025-11-19 09:07:31
748	8	63	2025-11-19 09:07:31
749	9	0	2025-11-19 09:07:31
750	10	10	2025-11-19 09:07:31
751	7	26.2	2025-11-19 09:07:45
752	8	63	2025-11-19 09:07:45
753	9	0	2025-11-19 09:07:45
754	10	10	2025-11-19 09:07:45
755	7	26.2	2025-11-19 09:08:00
756	8	63	2025-11-19 09:08:00
757	9	0	2025-11-19 09:08:00
758	10	10	2025-11-19 09:08:00
759	7	26.2	2025-11-19 09:08:14
760	8	63	2025-11-19 09:08:14
761	9	0	2025-11-19 09:08:14
762	10	10	2025-11-19 09:08:14
763	7	26.2	2025-11-19 09:08:24
764	8	63	2025-11-19 09:08:24
765	9	0	2025-11-19 09:08:24
766	10	10	2025-11-19 09:08:24
767	7	26.2	2025-11-19 09:08:34
768	8	63	2025-11-19 09:08:34
769	9	0	2025-11-19 09:08:34
770	10	10	2025-11-19 09:08:34
771	7	26.2	2025-11-19 09:08:48
772	8	63	2025-11-19 09:08:48
773	9	0	2025-11-19 09:08:48
774	10	10	2025-11-19 09:08:48
775	7	26.2	2025-11-19 09:08:57
776	8	63	2025-11-19 09:08:57
777	9	0	2025-11-19 09:08:57
778	10	10	2025-11-19 09:08:57
779	7	26.2	2025-11-19 09:09:12
780	8	63	2025-11-19 09:09:12
781	9	0	2025-11-19 09:09:12
782	10	10	2025-11-19 09:09:12
783	7	26.2	2025-11-19 09:09:22
784	8	63	2025-11-19 09:09:22
785	9	0	2025-11-19 09:09:22
786	10	10	2025-11-19 09:09:22
787	7	26.2	2025-11-19 09:09:35
788	8	63	2025-11-19 09:09:35
789	9	0	2025-11-19 09:09:35
790	10	10	2025-11-19 09:09:35
791	7	26.2	2025-11-19 09:09:45
792	8	63	2025-11-19 09:09:45
793	9	0	2025-11-19 09:09:45
794	10	10	2025-11-19 09:09:45
795	7	26.2	2025-11-19 09:09:54
796	8	63	2025-11-19 09:09:54
797	9	0	2025-11-19 09:09:54
798	10	10	2025-11-19 09:09:54
799	7	26.2	2025-11-19 09:10:03
800	8	63	2025-11-19 09:10:03
801	9	0	2025-11-19 09:10:03
802	10	10	2025-11-19 09:10:03
803	7	26.2	2025-11-19 09:10:12
804	8	63	2025-11-19 09:10:12
805	9	0	2025-11-19 09:10:12
806	10	10	2025-11-19 09:10:12
807	7	26.2	2025-11-19 09:10:21
808	8	63	2025-11-19 09:10:21
809	9	0	2025-11-19 09:10:21
810	10	10	2025-11-19 09:10:21
811	7	26.2	2025-11-19 09:10:36
812	8	63	2025-11-19 09:10:36
813	9	0	2025-11-19 09:10:36
814	10	10	2025-11-19 09:10:36
815	7	26.2	2025-11-19 09:10:45
816	8	63	2025-11-19 09:10:45
817	9	0	2025-11-19 09:10:45
818	10	10	2025-11-19 09:10:45
819	7	26.2	2025-11-19 09:11:00
820	8	63	2025-11-19 09:11:00
821	9	0	2025-11-19 09:11:00
822	10	10	2025-11-19 09:11:00
823	7	26.2	2025-11-19 09:11:15
824	8	63	2025-11-19 09:11:15
825	9	0	2025-11-19 09:11:15
826	10	10	2025-11-19 09:11:15
827	7	26.2	2025-11-19 09:11:24
828	8	63	2025-11-19 09:11:24
829	9	0	2025-11-19 09:11:24
830	10	10	2025-11-19 09:11:24
831	7	26.2	2025-11-19 09:11:34
832	8	63	2025-11-19 09:11:34
833	9	0	2025-11-19 09:11:34
834	10	10	2025-11-19 09:11:34
835	7	26.2	2025-11-19 09:11:48
836	8	63	2025-11-19 09:11:48
837	9	0	2025-11-19 09:11:48
838	10	10	2025-11-19 09:11:48
839	7	26.2	2025-11-19 09:11:57
840	8	63	2025-11-19 09:11:57
841	9	0	2025-11-19 09:11:57
842	10	10	2025-11-19 09:11:57
843	7	26.2	2025-11-19 09:12:06
844	8	63	2025-11-19 09:12:06
845	9	0	2025-11-19 09:12:06
846	10	10	2025-11-19 09:12:06
847	7	26.2	2025-11-19 09:12:15
848	8	63	2025-11-19 09:12:15
849	9	0	2025-11-19 09:12:15
850	10	10	2025-11-19 09:12:15
851	7	26.2	2025-11-19 09:12:24
852	8	63	2025-11-19 09:12:24
853	9	0	2025-11-19 09:12:24
854	10	10	2025-11-19 09:12:24
855	7	26.2	2025-11-19 09:12:33
856	8	63	2025-11-19 09:12:33
857	9	0	2025-11-19 09:12:33
858	10	10	2025-11-19 09:12:33
859	7	26.2	2025-11-19 09:12:48
860	8	63	2025-11-19 09:12:48
861	9	0	2025-11-19 09:12:48
862	10	10	2025-11-19 09:12:48
863	7	26.2	2025-11-19 09:12:57
864	8	63	2025-11-19 09:12:57
865	9	0	2025-11-19 09:12:57
866	10	10	2025-11-19 09:12:57
867	7	26.2	2025-11-19 09:13:12
868	8	63	2025-11-19 09:13:12
869	9	0	2025-11-19 09:13:12
870	10	10	2025-11-19 09:13:12
871	7	26.2	2025-11-19 09:13:25
872	8	63	2025-11-19 09:13:25
873	9	0	2025-11-19 09:13:25
874	10	10	2025-11-19 09:13:25
875	7	26.2	2025-11-19 09:13:40
876	8	63	2025-11-19 09:13:40
877	9	0	2025-11-19 09:13:40
878	10	10	2025-11-19 09:13:40
879	7	26.2	2025-11-19 09:13:54
880	8	63	2025-11-19 09:13:54
881	9	0	2025-11-19 09:13:54
882	10	10	2025-11-19 09:13:54
883	7	26.2	2025-11-19 09:14:03
884	8	63	2025-11-19 09:14:03
885	9	0	2025-11-19 09:14:03
886	10	10	2025-11-19 09:14:03
887	7	26.2	2025-11-19 09:14:18
888	8	63	2025-11-19 09:14:18
889	9	0	2025-11-19 09:14:18
890	10	10	2025-11-19 09:14:18
891	7	26.2	2025-11-19 09:14:32
892	8	63	2025-11-19 09:14:32
893	9	0	2025-11-19 09:14:32
894	10	10	2025-11-19 09:14:32
895	7	26.2	2025-11-19 09:14:46
896	8	63	2025-11-19 09:14:46
897	9	0	2025-11-19 09:14:46
898	10	10	2025-11-19 09:14:46
899	7	26.2	2025-11-19 09:15:00
900	8	63	2025-11-19 09:15:00
901	9	0	2025-11-19 09:15:00
902	10	10	2025-11-19 09:15:00
903	7	26.2	2025-11-19 09:15:09
904	8	63	2025-11-19 09:15:09
905	9	0	2025-11-19 09:15:09
906	10	10	2025-11-19 09:15:09
907	7	26.2	2025-11-19 09:15:24
908	8	63	2025-11-19 09:15:24
909	9	0	2025-11-19 09:15:24
910	10	10	2025-11-19 09:15:24
911	7	26.2	2025-11-19 09:15:33
912	8	63	2025-11-19 09:15:33
913	9	0	2025-11-19 09:15:33
914	10	10	2025-11-19 09:15:33
915	7	26.2	2025-11-19 09:15:43
916	8	63	2025-11-19 09:15:43
917	9	0	2025-11-19 09:15:43
918	10	10	2025-11-19 09:15:43
919	7	26.2	2025-11-19 09:15:57
920	8	63	2025-11-19 09:15:57
921	9	0	2025-11-19 09:15:57
922	10	10	2025-11-19 09:15:57
923	7	26.2	2025-11-19 09:16:06
924	8	63	2025-11-19 09:16:06
925	9	0	2025-11-19 09:16:06
926	10	10	2025-11-19 09:16:06
927	7	26.2	2025-11-19 09:16:16
928	8	63	2025-11-19 09:16:16
929	9	0	2025-11-19 09:16:16
930	10	10	2025-11-19 09:16:16
931	7	26.2	2025-11-19 09:16:31
932	8	63	2025-11-19 09:16:31
933	9	0	2025-11-19 09:16:31
934	10	10	2025-11-19 09:16:31
935	7	26.2	2025-11-19 09:16:45
936	8	63	2025-11-19 09:16:45
937	9	0	2025-11-19 09:16:45
938	10	10	2025-11-19 09:16:45
939	7	26.2	2025-11-19 09:16:54
940	8	63	2025-11-19 09:16:54
941	9	0	2025-11-19 09:16:54
942	10	10	2025-11-19 09:16:54
943	7	26.2	2025-11-19 09:17:09
944	8	63	2025-11-19 09:17:09
945	9	0	2025-11-19 09:17:09
946	10	10	2025-11-19 09:17:09
947	7	26.2	2025-11-19 09:17:22
948	8	62	2025-11-19 09:17:22
949	9	0	2025-11-19 09:17:22
950	10	10	2025-11-19 09:17:22
951	7	26.2	2025-11-19 09:17:36
952	8	62	2025-11-19 09:17:36
953	9	0	2025-11-19 09:17:36
954	10	10	2025-11-19 09:17:36
955	7	26.2	2025-11-19 09:17:45
956	8	62	2025-11-19 09:17:45
957	9	0	2025-11-19 09:17:45
958	10	10	2025-11-19 09:17:45
959	7	26.2	2025-11-19 09:17:59
960	8	62	2025-11-19 09:17:59
961	9	0	2025-11-19 09:17:59
962	10	10	2025-11-19 09:17:59
963	7	26.2	2025-11-19 09:18:12
964	8	62	2025-11-19 09:18:12
965	9	0	2025-11-19 09:18:12
966	10	10	2025-11-19 09:18:12
967	7	26.2	2025-11-19 09:18:27
968	8	62	2025-11-19 09:18:27
969	9	0	2025-11-19 09:18:27
970	10	10	2025-11-19 09:18:27
971	7	26.2	2025-11-19 09:18:42
972	8	62	2025-11-19 09:18:42
973	9	0	2025-11-19 09:18:42
974	10	10	2025-11-19 09:18:42
975	7	26.2	2025-11-19 09:18:57
976	8	62	2025-11-19 09:18:57
977	9	0	2025-11-19 09:18:57
978	10	10	2025-11-19 09:18:57
979	7	26.3	2025-11-19 09:19:11
980	8	62	2025-11-19 09:19:11
981	9	0	2025-11-19 09:19:11
982	10	10	2025-11-19 09:19:11
983	7	26.3	2025-11-19 09:19:21
984	8	62	2025-11-19 09:19:21
985	9	0	2025-11-19 09:19:21
986	10	10	2025-11-19 09:19:21
987	7	26.4	2025-11-19 09:19:37
988	8	62	2025-11-19 09:19:37
989	9	0	2025-11-19 09:19:37
990	10	10	2025-11-19 09:19:37
991	7	26.4	2025-11-19 09:19:52
992	8	62	2025-11-19 09:19:52
993	9	0	2025-11-19 09:19:52
994	10	10	2025-11-19 09:19:52
995	7	26.6	2025-11-19 09:20:09
996	8	62	2025-11-19 09:20:09
997	9	0	2025-11-19 09:20:09
998	10	10	2025-11-19 09:20:09
999	7	26.6	2025-11-19 09:20:18
1000	8	62	2025-11-19 09:20:18
1001	9	0	2025-11-19 09:20:18
1002	10	10	2025-11-19 09:20:18
1003	7	26.7	2025-11-19 09:20:27
1004	8	62	2025-11-19 09:20:27
1005	9	0	2025-11-19 09:20:27
1006	10	10	2025-11-19 09:20:27
1007	7	26.7	2025-11-19 09:20:42
1008	8	62	2025-11-19 09:20:42
1009	9	0	2025-11-19 09:20:42
1010	10	10	2025-11-19 09:20:42
1011	7	26.7	2025-11-19 09:20:56
1012	8	62	2025-11-19 09:20:56
1013	9	0	2025-11-19 09:20:56
1014	10	10	2025-11-19 09:20:56
1015	7	26.7	2025-11-19 09:21:10
1016	8	62	2025-11-19 09:21:10
1017	9	0	2025-11-19 09:21:10
1018	10	10	2025-11-19 09:21:10
1019	7	26.7	2025-11-19 09:21:24
1020	8	62	2025-11-19 09:21:24
1021	9	0	2025-11-19 09:21:24
1022	10	10	2025-11-19 09:21:24
1023	7	26.7	2025-11-19 09:21:39
1024	8	62	2025-11-19 09:21:39
1025	9	0	2025-11-19 09:21:39
1026	10	10	2025-11-19 09:21:39
1027	7	26.7	2025-11-19 09:21:49
1028	8	62	2025-11-19 09:21:49
1029	9	0	2025-11-19 09:21:49
1030	10	10	2025-11-19 09:21:49
1031	7	26.7	2025-11-19 09:22:03
1032	8	62	2025-11-19 09:22:03
1033	9	0	2025-11-19 09:22:03
1034	10	10	2025-11-19 09:22:03
1035	7	26.7	2025-11-19 09:22:12
1036	8	62	2025-11-19 09:22:12
1037	9	0	2025-11-19 09:22:12
1038	10	10	2025-11-19 09:22:12
1039	7	26.7	2025-11-19 09:22:27
1040	8	62	2025-11-19 09:22:27
1041	9	0	2025-11-19 09:22:27
1042	10	10	2025-11-19 09:22:27
1043	7	26.7	2025-11-19 09:22:40
1044	8	62	2025-11-19 09:22:40
1045	9	0	2025-11-19 09:22:40
1046	10	10	2025-11-19 09:22:40
1047	7	26.7	2025-11-19 09:22:55
1048	8	62	2025-11-19 09:22:55
1049	9	0	2025-11-19 09:22:55
1050	10	10	2025-11-19 09:22:55
1051	7	26.7	2025-11-19 09:23:10
1052	8	62	2025-11-19 09:23:10
1053	9	0	2025-11-19 09:23:10
1054	10	10	2025-11-19 09:23:10
1055	7	26.7	2025-11-19 09:23:24
1056	8	62	2025-11-19 09:23:24
1057	9	0	2025-11-19 09:23:24
1058	10	10	2025-11-19 09:23:24
1059	7	26.7	2025-11-19 09:23:39
1060	8	62	2025-11-19 09:23:39
1061	9	0	2025-11-19 09:23:39
1062	10	10	2025-11-19 09:23:39
1063	7	26.7	2025-11-19 09:23:48
1064	8	62	2025-11-19 09:23:48
1065	9	0	2025-11-19 09:23:48
1066	10	10	2025-11-19 09:23:48
1067	7	26.7	2025-11-19 09:24:03
1068	8	62	2025-11-19 09:24:03
1069	9	0	2025-11-19 09:24:03
1070	10	12	2025-11-19 09:24:03
1071	7	26.7	2025-11-19 09:24:17
1072	8	62	2025-11-19 09:24:17
1073	9	0	2025-11-19 09:24:17
1074	10	13	2025-11-19 09:24:17
1075	7	26.7	2025-11-19 09:24:32
1076	8	62	2025-11-19 09:24:32
1077	9	0	2025-11-19 09:24:32
1078	10	13	2025-11-19 09:24:32
1079	7	26.7	2025-11-19 09:24:46
1080	8	62	2025-11-19 09:24:46
1081	9	0	2025-11-19 09:24:46
1082	10	12	2025-11-19 09:24:46
1083	7	26.7	2025-11-19 09:25:00
1084	8	62	2025-11-19 09:25:00
1085	9	0	2025-11-19 09:25:00
1086	10	13	2025-11-19 09:25:00
1087	7	26.7	2025-11-19 09:25:09
1088	8	62	2025-11-19 09:25:09
1089	9	0	2025-11-19 09:25:09
1090	10	14	2025-11-19 09:25:09
1091	7	26.7	2025-11-19 09:25:24
1092	8	62	2025-11-19 09:25:24
1093	9	0	2025-11-19 09:25:24
1094	10	14	2025-11-19 09:25:24
1095	7	26.7	2025-11-19 09:25:34
1096	8	62	2025-11-19 09:25:34
1097	9	0	2025-11-19 09:25:34
1098	10	14	2025-11-19 09:25:34
1099	7	26.7	2025-11-19 09:25:49
1100	8	62	2025-11-19 09:25:49
1101	9	0	2025-11-19 09:25:49
1102	10	14	2025-11-19 09:25:49
1103	7	26.7	2025-11-19 09:26:03
1104	8	62	2025-11-19 09:26:03
1105	9	0	2025-11-19 09:26:03
1106	10	14	2025-11-19 09:26:03
1107	7	26.7	2025-11-19 09:26:18
1108	8	63	2025-11-19 09:26:18
1109	9	0	2025-11-19 09:26:18
1110	10	14	2025-11-19 09:26:18
1111	7	26.7	2025-11-19 09:26:28
1112	8	63	2025-11-19 09:26:28
1113	9	0	2025-11-19 09:26:28
1114	10	14	2025-11-19 09:26:28
1115	7	26.7	2025-11-19 09:26:42
1116	8	63	2025-11-19 09:26:42
1117	9	0	2025-11-19 09:26:42
1118	10	14	2025-11-19 09:26:42
1119	7	26.7	2025-11-19 09:26:51
1120	8	63	2025-11-19 09:26:51
1121	9	0	2025-11-19 09:26:51
1122	10	14	2025-11-19 09:26:51
1123	7	27.1	2025-11-19 09:27:00
1124	8	57	2025-11-19 09:27:00
1125	9	92	2025-11-19 09:27:00
1126	10	12	2025-11-19 09:27:00
1127	7	27.1	2025-11-19 09:27:15
1128	8	57	2025-11-19 09:27:15
1129	9	92	2025-11-19 09:27:15
1130	10	11	2025-11-19 09:27:15
1131	7	27.1	2025-11-19 09:27:30
1132	8	57	2025-11-19 09:27:30
1133	9	0	2025-11-19 09:27:30
1134	10	26	2025-11-19 09:27:30
1135	7	27.1	2025-11-19 09:27:40
1136	8	57	2025-11-19 09:27:40
1137	9	0	2025-11-19 09:27:40
1138	10	18	2025-11-19 09:27:40
1139	7	27.1	2025-11-19 09:27:54
1140	8	57	2025-11-19 09:27:54
1141	9	0	2025-11-19 09:27:54
1142	10	14	2025-11-19 09:27:54
1143	7	27.1	2025-11-19 09:28:09
1144	8	57	2025-11-19 09:28:09
1145	9	0	2025-11-19 09:28:09
1146	10	11	2025-11-19 09:28:09
1147	7	27.1	2025-11-19 09:28:19
1148	8	57	2025-11-19 09:28:19
1149	9	0	2025-11-19 09:28:19
1150	10	11	2025-11-19 09:28:19
1151	7	27.1	2025-11-19 09:28:34
1152	8	57	2025-11-19 09:28:34
1153	9	0	2025-11-19 09:28:34
1154	10	11	2025-11-19 09:28:34
1155	7	27.1	2025-11-19 09:28:48
1156	8	57	2025-11-19 09:28:48
1157	9	0	2025-11-19 09:28:48
1158	10	11	2025-11-19 09:28:48
1159	7	27.1	2025-11-19 09:29:03
1160	8	57	2025-11-19 09:29:03
1161	9	0	2025-11-19 09:29:03
1162	10	11	2025-11-19 09:29:03
1163	7	27.1	2025-11-19 09:29:13
1164	8	57	2025-11-19 09:29:13
1165	9	0	2025-11-19 09:29:13
1166	10	11	2025-11-19 09:29:13
1167	7	27.1	2025-11-19 09:29:27
1168	8	57	2025-11-19 09:29:27
1169	9	0	2025-11-19 09:29:27
1170	10	11	2025-11-19 09:29:27
1171	7	27.1	2025-11-19 09:29:42
1172	8	57	2025-11-19 09:29:42
1173	9	0	2025-11-19 09:29:42
1174	10	11	2025-11-19 09:29:42
1175	7	27.1	2025-11-19 09:29:57
1176	8	57	2025-11-19 09:29:57
1177	9	0	2025-11-19 09:29:57
1178	10	11	2025-11-19 09:29:57
1179	7	27.1	2025-11-19 09:30:06
1180	8	57	2025-11-19 09:30:06
1181	9	0	2025-11-19 09:30:06
1182	10	11	2025-11-19 09:30:06
1183	7	27.1	2025-11-19 09:30:21
1184	8	57	2025-11-19 09:30:21
1185	9	0	2025-11-19 09:30:21
1186	10	11	2025-11-19 09:30:21
1187	7	27.1	2025-11-19 09:30:36
1188	8	57	2025-11-19 09:30:36
1189	9	0	2025-11-19 09:30:36
1190	10	11	2025-11-19 09:30:36
1191	7	27.1	2025-11-19 09:30:45
1192	8	57	2025-11-19 09:30:45
1193	9	0	2025-11-19 09:30:45
1194	10	11	2025-11-19 09:30:45
1195	7	27.1	2025-11-19 09:31:00
1196	8	57	2025-11-19 09:31:00
1197	9	0	2025-11-19 09:31:00
1198	10	11	2025-11-19 09:31:00
1199	7	27.1	2025-11-19 09:31:10
1200	8	57	2025-11-19 09:31:10
1201	9	0	2025-11-19 09:31:10
1202	10	11	2025-11-19 09:31:10
1203	7	27.1	2025-11-19 09:31:25
1204	8	57	2025-11-19 09:31:25
1205	9	0	2025-11-19 09:31:25
1206	10	11	2025-11-19 09:31:25
1207	7	27.1	2025-11-19 09:31:39
1208	8	57	2025-11-19 09:31:39
1209	9	0	2025-11-19 09:31:39
1210	10	11	2025-11-19 09:31:39
1211	7	27.1	2025-11-19 09:31:48
1212	8	57	2025-11-19 09:31:48
1213	9	0	2025-11-19 09:31:48
1214	10	11	2025-11-19 09:31:48
1215	7	27.1	2025-11-19 09:31:57
1216	8	57	2025-11-19 09:31:57
1217	9	0	2025-11-19 09:31:57
1218	10	11	2025-11-19 09:31:57
1219	7	27.1	2025-11-19 09:32:07
1220	8	57	2025-11-19 09:32:07
1221	9	0	2025-11-19 09:32:07
1222	10	11	2025-11-19 09:32:07
1223	7	27.1	2025-11-19 09:32:20
1224	8	57	2025-11-19 09:32:20
1225	9	0	2025-11-19 09:32:20
1226	10	11	2025-11-19 09:32:20
1227	7	27.1	2025-11-19 09:32:34
1228	8	57	2025-11-19 09:32:34
1229	9	0	2025-11-19 09:32:34
1230	10	11	2025-11-19 09:32:34
1231	7	27.1	2025-11-19 09:32:49
1232	8	57	2025-11-19 09:32:49
1233	9	0	2025-11-19 09:32:49
1234	10	11	2025-11-19 09:32:49
1235	7	27.1	2025-11-19 09:32:57
1236	8	57	2025-11-19 09:32:57
1237	9	0	2025-11-19 09:32:57
1238	10	11	2025-11-19 09:32:57
1239	7	27.1	2025-11-19 09:33:12
1240	8	57	2025-11-19 09:33:12
1241	9	0	2025-11-19 09:33:12
1242	10	11	2025-11-19 09:33:12
1243	7	27.1	2025-11-19 09:33:21
1244	8	57	2025-11-19 09:33:21
1245	9	0	2025-11-19 09:33:21
1246	10	11	2025-11-19 09:33:21
1247	7	27.1	2025-11-19 09:33:36
1248	8	57	2025-11-19 09:33:36
1249	9	0	2025-11-19 09:33:36
1250	10	11	2025-11-19 09:33:36
1251	7	27.1	2025-11-19 09:33:45
1252	8	57	2025-11-19 09:33:45
1253	9	0	2025-11-19 09:33:45
1254	10	11	2025-11-19 09:33:45
1255	7	27.1	2025-11-19 09:33:59
1256	8	57	2025-11-19 09:33:59
1257	9	0	2025-11-19 09:33:59
1258	10	11	2025-11-19 09:33:59
1259	7	27.1	2025-11-19 09:34:13
1260	8	57	2025-11-19 09:34:13
1261	9	0	2025-11-19 09:34:13
1262	10	11	2025-11-19 09:34:13
1263	7	27.1	2025-11-19 09:34:28
1264	8	54	2025-11-19 09:34:28
1265	9	0	2025-11-19 09:34:28
1266	10	11	2025-11-19 09:34:28
1267	7	27.1	2025-11-19 09:34:42
1268	8	54	2025-11-19 09:34:42
1269	9	0	2025-11-19 09:34:42
1270	10	11	2025-11-19 09:34:42
1271	7	27.1	2025-11-19 09:34:51
1272	8	54	2025-11-19 09:34:51
1273	9	0	2025-11-19 09:34:51
1274	10	11	2025-11-19 09:34:51
1275	7	27.1	2025-11-19 09:35:00
1276	8	54	2025-11-19 09:35:00
1277	9	0	2025-11-19 09:35:00
1278	10	11	2025-11-19 09:35:00
1279	7	27.1	2025-11-19 09:35:15
1280	8	54	2025-11-19 09:35:15
1281	9	0	2025-11-19 09:35:15
1282	10	11	2025-11-19 09:35:15
1283	7	27.1	2025-11-19 09:35:24
1284	8	54	2025-11-19 09:35:24
1285	9	0	2025-11-19 09:35:24
1286	10	11	2025-11-19 09:35:24
1287	7	27.1	2025-11-19 09:35:34
1288	8	54	2025-11-19 09:35:34
1289	9	0	2025-11-19 09:35:34
1290	10	11	2025-11-19 09:35:34
1291	7	27.1	2025-11-19 09:35:48
1292	8	54	2025-11-19 09:35:48
1293	9	0	2025-11-19 09:35:48
1294	10	11	2025-11-19 09:35:48
1295	7	27.1	2025-11-19 09:36:03
1296	8	54	2025-11-19 09:36:03
1297	9	0	2025-11-19 09:36:03
1298	10	11	2025-11-19 09:36:03
1299	7	27.1	2025-11-19 09:36:18
1300	8	54	2025-11-19 09:36:18
1301	9	0	2025-11-19 09:36:18
1302	10	12	2025-11-19 09:36:18
1303	7	27.1	2025-11-19 09:36:27
1304	8	54	2025-11-19 09:36:27
1305	9	0	2025-11-19 09:36:27
1306	10	12	2025-11-19 09:36:27
1307	7	27.1	2025-11-19 09:36:42
1308	8	54	2025-11-19 09:36:42
1309	9	0	2025-11-19 09:36:42
1310	10	12	2025-11-19 09:36:42
1311	7	27.1	2025-11-19 09:36:57
1312	8	54	2025-11-19 09:36:57
1313	9	0	2025-11-19 09:36:57
1314	10	13	2025-11-19 09:36:57
1315	7	27.1	2025-11-19 09:37:06
1316	8	54	2025-11-19 09:37:06
1317	9	0	2025-11-19 09:37:06
1318	10	13	2025-11-19 09:37:06
1319	7	27.1	2025-11-19 09:37:15
1320	8	54	2025-11-19 09:37:15
1321	9	0	2025-11-19 09:37:15
1322	10	13	2025-11-19 09:37:15
1323	7	27.1	2025-11-19 09:37:30
1324	8	54	2025-11-19 09:37:30
1325	9	0	2025-11-19 09:37:30
1326	10	13	2025-11-19 09:37:30
1327	7	27.1	2025-11-19 09:37:39
1328	8	54	2025-11-19 09:37:39
1329	9	0	2025-11-19 09:37:39
1330	10	13	2025-11-19 09:37:39
1331	7	27.1	2025-11-19 09:37:49
1332	8	55	2025-11-19 09:37:49
1333	9	0	2025-11-19 09:37:49
1334	10	13	2025-11-19 09:37:49
1335	7	27.1	2025-11-19 09:38:03
1336	8	55	2025-11-19 09:38:03
1337	9	0	2025-11-19 09:38:03
1338	10	13	2025-11-19 09:38:03
1339	7	27.1	2025-11-19 09:38:18
1340	8	56	2025-11-19 09:38:18
1341	9	0	2025-11-19 09:38:18
1342	10	13	2025-11-19 09:38:18
1343	7	27.1	2025-11-19 09:38:27
1344	8	56	2025-11-19 09:38:27
1345	9	0	2025-11-19 09:38:27
1346	10	13	2025-11-19 09:38:27
1347	7	27.1	2025-11-19 09:38:37
1348	8	57	2025-11-19 09:38:37
1349	9	0	2025-11-19 09:38:37
1350	10	12	2025-11-19 09:38:37
1351	7	27.1	2025-11-19 09:38:51
1352	8	57	2025-11-19 09:38:51
1353	9	0	2025-11-19 09:38:51
1354	10	12	2025-11-19 09:38:51
1355	7	27.1	2025-11-19 09:39:06
1356	8	58	2025-11-19 09:39:06
1357	9	0	2025-11-19 09:39:06
1358	10	14	2025-11-19 09:39:06
1359	7	27.1	2025-11-19 09:39:15
1360	8	58	2025-11-19 09:39:15
1361	9	0	2025-11-19 09:39:15
1362	10	13	2025-11-19 09:39:15
1363	7	27.1	2025-11-19 09:39:24
1364	8	58	2025-11-19 09:39:24
1365	9	0	2025-11-19 09:39:24
1366	10	13	2025-11-19 09:39:24
1367	7	27.1	2025-11-19 09:39:33
1368	8	58	2025-11-19 09:39:33
1369	9	0	2025-11-19 09:39:33
1370	10	13	2025-11-19 09:39:33
1371	7	27.1	2025-11-19 09:39:48
1372	8	58	2025-11-19 09:39:48
1373	9	0	2025-11-19 09:39:48
1374	10	13	2025-11-19 09:39:48
1375	7	27.1	2025-11-19 09:39:57
1376	8	58	2025-11-19 09:39:57
1377	9	0	2025-11-19 09:39:57
1378	10	13	2025-11-19 09:39:57
1379	7	27.1	2025-11-19 09:40:06
1380	8	58	2025-11-19 09:40:06
1381	9	0	2025-11-19 09:40:06
1382	10	13	2025-11-19 09:40:06
1383	7	27.1	2025-11-19 09:40:15
1384	8	58	2025-11-19 09:40:15
1385	9	0	2025-11-19 09:40:15
1386	10	13	2025-11-19 09:40:15
1387	7	27.1	2025-11-19 09:40:30
1388	8	57	2025-11-19 09:40:30
1389	9	0	2025-11-19 09:40:30
1390	10	13	2025-11-19 09:40:30
1391	7	27.1	2025-11-19 09:40:39
1392	8	57	2025-11-19 09:40:39
1393	9	0	2025-11-19 09:40:39
1394	10	13	2025-11-19 09:40:39
1395	7	25.8	2025-11-19 09:40:54
1396	8	49	2025-11-19 09:40:54
1397	9	0	2025-11-19 09:40:54
1398	10	13	2025-11-19 09:40:54
1399	7	25.8	2025-11-19 09:41:03
1400	8	49	2025-11-19 09:41:03
1401	9	0	2025-11-19 09:41:03
1402	10	14	2025-11-19 09:41:03
1403	7	25.8	2025-11-19 09:41:12
1404	8	49	2025-11-19 09:41:12
1405	9	0	2025-11-19 09:41:12
1406	10	14	2025-11-19 09:41:12
1407	7	25.8	2025-11-19 09:41:27
1408	8	49	2025-11-19 09:41:27
1409	9	0	2025-11-19 09:41:27
1410	10	13	2025-11-19 09:41:27
1411	7	25.8	2025-11-19 09:41:41
1412	8	49	2025-11-19 09:41:41
1413	9	0	2025-11-19 09:41:41
1414	10	13	2025-11-19 09:41:41
1415	7	25.8	2025-11-19 09:41:56
1416	8	49	2025-11-19 09:41:56
1417	9	0	2025-11-19 09:41:56
1418	10	13	2025-11-19 09:41:56
1419	7	25.8	2025-11-19 09:42:10
1420	8	50	2025-11-19 09:42:10
1421	9	0	2025-11-19 09:42:10
1422	10	13	2025-11-19 09:42:10
1423	7	25.8	2025-11-19 09:42:24
1424	8	50	2025-11-19 09:42:24
1425	9	0	2025-11-19 09:42:24
1426	10	12	2025-11-19 09:42:24
1427	7	25.8	2025-11-19 09:42:33
1428	8	50	2025-11-19 09:42:33
1429	9	0	2025-11-19 09:42:33
1430	10	13	2025-11-19 09:42:33
1431	7	25.8	2025-11-19 09:42:42
1432	8	50	2025-11-19 09:42:42
1433	9	0	2025-11-19 09:42:42
1434	10	13	2025-11-19 09:42:42
1435	7	25.8	2025-11-19 09:42:51
1436	8	50	2025-11-19 09:42:51
1437	9	0	2025-11-19 09:42:51
1438	10	12	2025-11-19 09:42:51
1439	7	25.8	2025-11-19 09:43:00
1440	8	50	2025-11-19 09:43:00
1441	9	0	2025-11-19 09:43:00
1442	10	12	2025-11-19 09:43:00
1443	7	25.8	2025-11-19 09:43:15
1444	8	50	2025-11-19 09:43:15
1445	9	0	2025-11-19 09:43:15
1446	10	12	2025-11-19 09:43:15
1447	7	25.8	2025-11-19 09:43:25
1448	8	50	2025-11-19 09:43:25
1449	9	0	2025-11-19 09:43:25
1450	10	13	2025-11-19 09:43:25
1451	7	25.8	2025-11-19 09:43:42
1452	8	50	2025-11-19 09:43:42
1453	9	0	2025-11-19 09:43:42
1454	10	13	2025-11-19 09:43:42
1455	7	25.8	2025-11-19 09:43:52
1456	8	50	2025-11-19 09:43:52
1457	9	0	2025-11-19 09:43:52
1458	10	13	2025-11-19 09:43:52
1459	7	25.8	2025-11-19 09:44:06
1460	8	50	2025-11-19 09:44:06
1461	9	0	2025-11-19 09:44:06
1462	10	13	2025-11-19 09:44:06
1463	7	25.8	2025-11-19 09:44:21
1464	8	50	2025-11-19 09:44:21
1465	9	0	2025-11-19 09:44:21
1466	10	13	2025-11-19 09:44:21
1467	7	25.8	2025-11-19 09:44:30
1468	8	50	2025-11-19 09:44:30
1469	9	0	2025-11-19 09:44:30
1470	10	13	2025-11-19 09:44:30
1471	7	25.8	2025-11-19 09:44:45
1472	8	50	2025-11-19 09:44:45
1473	9	0	2025-11-19 09:44:45
1474	10	13	2025-11-19 09:44:45
1475	7	25.8	2025-11-19 09:44:53
1476	8	50	2025-11-19 09:44:53
1477	9	0	2025-11-19 09:44:53
1478	10	13	2025-11-19 09:44:53
1479	7	25.8	2025-11-19 09:45:06
1480	8	50	2025-11-19 09:45:06
1481	9	0	2025-11-19 09:45:06
1482	10	13	2025-11-19 09:45:06
1483	7	25.8	2025-11-19 09:45:21
1484	8	50	2025-11-19 09:45:21
1485	9	0	2025-11-19 09:45:21
1486	10	13	2025-11-19 09:45:21
1487	7	25.8	2025-11-19 09:45:30
1488	8	50	2025-11-19 09:45:30
1489	9	0	2025-11-19 09:45:30
1490	10	13	2025-11-19 09:45:30
1491	7	25.8	2025-11-19 09:45:45
1492	8	50	2025-11-19 09:45:45
1493	9	0	2025-11-19 09:45:45
1494	10	13	2025-11-19 09:45:45
1495	7	25.8	2025-11-19 09:45:59
1496	8	50	2025-11-19 09:45:59
1497	9	0	2025-11-19 09:45:59
1498	10	13	2025-11-19 09:45:59
1499	7	25.8	2025-11-19 09:46:13
1500	8	50	2025-11-19 09:46:13
1501	9	0	2025-11-19 09:46:13
1502	10	13	2025-11-19 09:46:13
1503	7	25.8	2025-11-19 09:46:28
1504	8	50	2025-11-19 09:46:28
1505	9	0	2025-11-19 09:46:28
1506	10	13	2025-11-19 09:46:28
1507	7	25.8	2025-11-19 09:46:42
1508	8	50	2025-11-19 09:46:42
1509	9	0	2025-11-19 09:46:42
1510	10	13	2025-11-19 09:46:42
1511	7	25.8	2025-11-19 09:46:51
1512	8	50	2025-11-19 09:46:51
1513	9	0	2025-11-19 09:46:51
1514	10	13	2025-11-19 09:46:51
1515	7	25.8	2025-11-19 09:47:00
1516	8	50	2025-11-19 09:47:00
1517	9	0	2025-11-19 09:47:00
1518	10	13	2025-11-19 09:47:00
1519	7	25.8	2025-11-19 09:47:10
1520	8	50	2025-11-19 09:47:10
1521	9	0	2025-11-19 09:47:10
1522	10	13	2025-11-19 09:47:10
1523	7	25.8	2025-11-19 09:47:25
1524	8	50	2025-11-19 09:47:25
1525	9	0	2025-11-19 09:47:25
1526	10	13	2025-11-19 09:47:25
1527	7	25.8	2025-11-19 09:47:39
1528	8	50	2025-11-19 09:47:39
1529	9	0	2025-11-19 09:47:39
1530	10	13	2025-11-19 09:47:39
1531	7	26.2	2025-11-19 09:47:48
1532	8	58	2025-11-19 09:47:48
1533	9	0	2025-11-19 09:47:48
1534	10	14	2025-11-19 09:47:48
1535	7	26.2	2025-11-19 09:47:57
1536	8	58	2025-11-19 09:47:57
1537	9	0	2025-11-19 09:47:57
1538	10	14	2025-11-19 09:47:57
1539	7	26.2	2025-11-19 09:48:06
1540	8	58	2025-11-19 09:48:06
1541	9	0	2025-11-19 09:48:06
1542	10	14	2025-11-19 09:48:06
1543	7	26.2	2025-11-19 09:48:21
1544	8	58	2025-11-19 09:48:21
1545	9	0	2025-11-19 09:48:21
1546	10	14	2025-11-19 09:48:21
1547	7	26.2	2025-11-19 09:48:31
1548	8	58	2025-11-19 09:48:31
1549	9	0	2025-11-19 09:48:31
1550	10	14	2025-11-19 09:48:31
1551	7	26.2	2025-11-19 09:48:45
1552	8	58	2025-11-19 09:48:45
1553	9	0	2025-11-19 09:48:45
1554	10	14	2025-11-19 09:48:45
1555	7	26.2	2025-11-19 09:48:53
1556	8	58	2025-11-19 09:48:53
1557	9	0	2025-11-19 09:48:53
1558	10	14	2025-11-19 09:48:53
1559	7	26.2	2025-11-19 09:49:07
1560	8	58	2025-11-19 09:49:07
1561	9	0	2025-11-19 09:49:07
1562	10	14	2025-11-19 09:49:07
1563	7	26.2	2025-11-19 09:49:21
1564	8	58	2025-11-19 09:49:21
1565	9	0	2025-11-19 09:49:21
1566	10	14	2025-11-19 09:49:21
1567	7	26.2	2025-11-19 09:49:30
1568	8	58	2025-11-19 09:49:30
1569	9	0	2025-11-19 09:49:30
1570	10	14	2025-11-19 09:49:30
1571	7	26.2	2025-11-19 09:49:39
1572	8	58	2025-11-19 09:49:39
1573	9	0	2025-11-19 09:49:39
1574	10	14	2025-11-19 09:49:39
1575	7	26.2	2025-11-19 09:49:54
1576	8	58	2025-11-19 09:49:54
1577	9	0	2025-11-19 09:49:54
1578	10	14	2025-11-19 09:49:54
1579	7	26.2	2025-11-19 09:50:04
1580	8	58	2025-11-19 09:50:04
1581	9	0	2025-11-19 09:50:04
1582	10	14	2025-11-19 09:50:04
1583	7	26.2	2025-11-19 09:50:18
1584	8	58	2025-11-19 09:50:18
1585	9	0	2025-11-19 09:50:18
1586	10	14	2025-11-19 09:50:18
1587	7	26.2	2025-11-19 09:50:33
1588	8	58	2025-11-19 09:50:33
1589	9	0	2025-11-19 09:50:33
1590	10	14	2025-11-19 09:50:33
1591	7	26.2	2025-11-19 09:50:42
1592	8	58	2025-11-19 09:50:42
1593	9	0	2025-11-19 09:50:42
1594	10	14	2025-11-19 09:50:42
1595	7	26.2	2025-11-19 09:50:51
1596	8	58	2025-11-19 09:50:51
1597	9	0	2025-11-19 09:50:51
1598	10	14	2025-11-19 09:50:51
1599	7	26.2	2025-11-19 09:51:01
1600	8	58	2025-11-19 09:51:01
1601	9	0	2025-11-19 09:51:01
1602	10	14	2025-11-19 09:51:01
1603	7	26.2	2025-11-19 09:51:14
1604	8	58	2025-11-19 09:51:14
1605	9	0	2025-11-19 09:51:14
1606	10	14	2025-11-19 09:51:14
1607	7	26.2	2025-11-19 09:51:24
1608	8	58	2025-11-19 09:51:24
1609	9	0	2025-11-19 09:51:24
1610	10	14	2025-11-19 09:51:24
1611	7	26.2	2025-11-19 09:51:33
1612	8	58	2025-11-19 09:51:33
1613	9	0	2025-11-19 09:51:33
1614	10	14	2025-11-19 09:51:33
1615	7	26.2	2025-11-19 09:51:42
1616	8	58	2025-11-19 09:51:42
1617	9	0	2025-11-19 09:51:42
1618	10	14	2025-11-19 09:51:42
1619	7	26.2	2025-11-19 09:51:57
1620	8	58	2025-11-19 09:51:57
1621	9	0	2025-11-19 09:51:57
1622	10	14	2025-11-19 09:51:57
1623	7	26.2	2025-11-19 09:52:06
1624	8	58	2025-11-19 09:52:06
1625	9	0	2025-11-19 09:52:06
1626	10	14	2025-11-19 09:52:06
1627	7	26.2	2025-11-19 09:52:15
1628	8	58	2025-11-19 09:52:15
1629	9	0	2025-11-19 09:52:15
1630	10	14	2025-11-19 09:52:15
1631	7	26.2	2025-11-19 09:52:30
1632	8	58	2025-11-19 09:52:30
1633	9	0	2025-11-19 09:52:30
1634	10	14	2025-11-19 09:52:30
1635	7	26.2	2025-11-19 09:52:39
1636	8	58	2025-11-19 09:52:39
1637	9	0	2025-11-19 09:52:39
1638	10	14	2025-11-19 09:52:39
1639	7	26.2	2025-11-19 09:52:54
1640	8	58	2025-11-19 09:52:54
1641	9	0	2025-11-19 09:52:54
1642	10	14	2025-11-19 09:52:54
1643	7	26.2	2025-11-19 09:53:03
1644	8	58	2025-11-19 09:53:03
1645	9	0	2025-11-19 09:53:03
1646	10	14	2025-11-19 09:53:03
1647	7	26.2	2025-11-19 09:53:18
1648	8	58	2025-11-19 09:53:18
1649	9	0	2025-11-19 09:53:18
1650	10	14	2025-11-19 09:53:18
1651	7	26.2	2025-11-19 09:53:27
1652	8	58	2025-11-19 09:53:27
1653	9	0	2025-11-19 09:53:27
1654	10	14	2025-11-19 09:53:27
1655	7	26.2	2025-11-19 09:53:42
1656	8	58	2025-11-19 09:53:42
1657	9	0	2025-11-19 09:53:42
1658	10	14	2025-11-19 09:53:42
1659	7	26.2	2025-11-19 09:53:51
1660	8	58	2025-11-19 09:53:51
1661	9	0	2025-11-19 09:53:51
1662	10	14	2025-11-19 09:53:51
1663	7	26.7	2025-11-19 09:54:07
1664	8	59	2025-11-19 09:54:07
1665	9	0	2025-11-19 09:54:07
1666	10	14	2025-11-19 09:54:07
1667	7	26.7	2025-11-19 09:54:22
1668	8	59	2025-11-19 09:54:22
1669	9	0	2025-11-19 09:54:22
1670	10	15	2025-11-19 09:54:22
1671	7	26.7	2025-11-19 09:54:37
1672	8	59	2025-11-19 09:54:37
1673	9	0	2025-11-19 09:54:37
1674	10	15	2025-11-19 09:54:37
1675	7	26.7	2025-11-19 09:54:52
1676	8	59	2025-11-19 09:54:52
1677	9	0	2025-11-19 09:54:52
1678	10	15	2025-11-19 09:54:52
1679	7	26.7	2025-11-19 09:55:37
1680	8	59	2025-11-19 09:55:37
1681	9	0	2025-11-19 09:55:37
1682	10	15	2025-11-19 09:55:37
1683	7	26.7	2025-11-19 09:55:51
1684	8	59	2025-11-19 09:55:51
1685	9	0	2025-11-19 09:55:51
1686	10	15	2025-11-19 09:55:51
1687	7	26.7	2025-11-19 09:56:01
1688	8	59	2025-11-19 09:56:01
1689	9	0	2025-11-19 09:56:01
1690	10	15	2025-11-19 09:56:01
1691	7	26.7	2025-11-19 09:56:10
1692	8	59	2025-11-19 09:56:10
1693	9	0	2025-11-19 09:56:10
1694	10	15	2025-11-19 09:56:10
1695	7	26.7	2025-11-19 09:56:42
1696	8	59	2025-11-19 09:56:42
1697	9	0	2025-11-19 09:56:42
1698	10	15	2025-11-19 09:56:42
1699	7	26.7	2025-11-19 09:56:57
1700	8	59	2025-11-19 09:56:57
1701	9	0	2025-11-19 09:56:57
1702	10	15	2025-11-19 09:56:57
1703	7	26.7	2025-11-19 09:57:07
1704	8	59	2025-11-19 09:57:07
1705	9	0	2025-11-19 09:57:07
1706	10	15	2025-11-19 09:57:07
1707	7	26.7	2025-11-19 09:57:21
1708	8	59	2025-11-19 09:57:21
1709	9	0	2025-11-19 09:57:21
1710	10	15	2025-11-19 09:57:21
1711	7	26.7	2025-11-19 09:57:30
1712	8	59	2025-11-19 09:57:30
1713	9	0	2025-11-19 09:57:30
1714	10	15	2025-11-19 09:57:30
1715	7	26.7	2025-11-19 09:57:45
1716	8	59	2025-11-19 09:57:45
1717	9	0	2025-11-19 09:57:45
1718	10	15	2025-11-19 09:57:45
1719	7	26.7	2025-11-19 09:58:00
1720	8	59	2025-11-19 09:58:00
1721	9	0	2025-11-19 09:58:00
1722	10	15	2025-11-19 09:58:00
1723	7	26.7	2025-11-19 09:58:10
1724	8	59	2025-11-19 09:58:10
1725	9	0	2025-11-19 09:58:10
1726	10	15	2025-11-19 09:58:10
1727	7	26.7	2025-11-19 09:58:24
1728	8	59	2025-11-19 09:58:24
1729	9	0	2025-11-19 09:58:24
1730	10	15	2025-11-19 09:58:24
1731	7	26.7	2025-11-19 09:58:39
1732	8	59	2025-11-19 09:58:39
1733	9	0	2025-11-19 09:58:39
1734	10	15	2025-11-19 09:58:39
1735	7	26.7	2025-11-19 09:58:53
1736	8	59	2025-11-19 09:58:53
1737	9	0	2025-11-19 09:58:53
1738	10	15	2025-11-19 09:58:53
1739	7	26.7	2025-11-19 09:59:07
1740	8	59	2025-11-19 09:59:07
1741	9	0	2025-11-19 09:59:07
1742	10	16	2025-11-19 09:59:07
1743	7	26.7	2025-11-19 09:59:22
1744	8	59	2025-11-19 09:59:22
1745	9	0	2025-11-19 09:59:22
1746	10	16	2025-11-19 09:59:22
1747	7	26.7	2025-11-19 09:59:37
1748	8	59	2025-11-19 09:59:37
1749	9	0	2025-11-19 09:59:37
1750	10	16	2025-11-19 09:59:37
1751	7	26.7	2025-11-19 09:59:52
1752	8	59	2025-11-19 09:59:52
1753	9	0	2025-11-19 09:59:52
1754	10	16	2025-11-19 09:59:52
1755	7	26.7	2025-11-19 10:00:06
1756	8	59	2025-11-19 10:00:06
1757	9	0	2025-11-19 10:00:06
1758	10	15	2025-11-19 10:00:06
1759	7	26.7	2025-11-19 10:00:16
1760	8	59	2025-11-19 10:00:16
1761	9	0	2025-11-19 10:00:16
1762	10	15	2025-11-19 10:00:16
1763	7	26.7	2025-11-19 10:00:32
1764	8	59	2025-11-19 10:00:32
1765	9	0	2025-11-19 10:00:32
1766	10	15	2025-11-19 10:00:32
1767	7	26.7	2025-11-19 10:00:47
1768	8	59	2025-11-19 10:00:47
1769	9	0	2025-11-19 10:00:47
1770	10	15	2025-11-19 10:00:47
1771	7	26.7	2025-11-19 10:01:05
1772	8	59	2025-11-19 10:01:05
1773	9	0	2025-11-19 10:01:05
1774	10	15	2025-11-19 10:01:05
1775	7	26.7	2025-11-19 10:01:20
1776	8	59	2025-11-19 10:01:20
1777	9	0	2025-11-19 10:01:20
1778	10	15	2025-11-19 10:01:20
1779	7	26.7	2025-11-19 10:01:30
1780	8	59	2025-11-19 10:01:30
1781	9	0	2025-11-19 10:01:30
1782	10	15	2025-11-19 10:01:30
1783	7	26.7	2025-11-19 10:01:45
1784	8	59	2025-11-19 10:01:45
1785	9	0	2025-11-19 10:01:45
1786	10	15	2025-11-19 10:01:45
1787	7	26.7	2025-11-19 10:02:00
1788	8	59	2025-11-19 10:02:00
1789	9	0	2025-11-19 10:02:00
1790	10	15	2025-11-19 10:02:00
1791	7	26.7	2025-11-19 10:02:11
1792	8	59	2025-11-19 10:02:11
1793	9	0	2025-11-19 10:02:11
1794	10	15	2025-11-19 10:02:11
1795	7	26.7	2025-11-19 10:02:25
1796	8	57	2025-11-19 10:02:25
1797	9	0	2025-11-19 10:02:25
1798	10	15	2025-11-19 10:02:25
1799	7	26.7	2025-11-19 10:02:39
1800	8	57	2025-11-19 10:02:39
1801	9	0	2025-11-19 10:02:39
1802	10	15	2025-11-19 10:02:39
1803	7	26.7	2025-11-19 10:02:48
1804	8	57	2025-11-19 10:02:48
1805	9	0	2025-11-19 10:02:48
1806	10	15	2025-11-19 10:02:48
1807	7	26.7	2025-11-19 10:02:57
1808	8	57	2025-11-19 10:02:57
1809	9	0	2025-11-19 10:02:57
1810	10	15	2025-11-19 10:02:57
1811	7	26.7	2025-11-19 10:03:13
1812	8	57	2025-11-19 10:03:13
1813	9	0	2025-11-19 10:03:13
1814	10	15	2025-11-19 10:03:13
1815	7	26.7	2025-11-19 10:03:30
1816	8	57	2025-11-19 10:03:30
1817	9	0	2025-11-19 10:03:30
1818	10	15	2025-11-19 10:03:30
1819	7	26.7	2025-11-19 10:03:40
1820	8	57	2025-11-19 10:03:40
1821	9	0	2025-11-19 10:03:40
1822	10	15	2025-11-19 10:03:40
1823	7	26.7	2025-11-19 10:03:55
1824	8	57	2025-11-19 10:03:55
1825	9	0	2025-11-19 10:03:55
1826	10	15	2025-11-19 10:03:55
1827	7	26.7	2025-11-19 10:04:11
1828	8	57	2025-11-19 10:04:11
1829	9	0	2025-11-19 10:04:11
1830	10	15	2025-11-19 10:04:11
1831	7	26.7	2025-11-19 10:04:25
1832	8	57	2025-11-19 10:04:25
1833	9	0	2025-11-19 10:04:25
1834	10	15	2025-11-19 10:04:25
1835	7	26.7	2025-11-19 10:04:41
1836	8	57	2025-11-19 10:04:41
1837	9	0	2025-11-19 10:04:41
1838	10	15	2025-11-19 10:04:41
1839	7	26.7	2025-11-19 10:04:52
1840	8	57	2025-11-19 10:04:52
1841	9	0	2025-11-19 10:04:52
1842	10	15	2025-11-19 10:04:52
1843	7	26.7	2025-11-19 10:05:07
1844	8	57	2025-11-19 10:05:07
1845	9	0	2025-11-19 10:05:07
1846	10	15	2025-11-19 10:05:07
1847	7	26.7	2025-11-19 10:05:23
1848	8	57	2025-11-19 10:05:23
1849	9	0	2025-11-19 10:05:23
1850	10	15	2025-11-19 10:05:23
1851	7	26.7	2025-11-19 10:05:36
1852	8	57	2025-11-19 10:05:36
1853	9	0	2025-11-19 10:05:36
1854	10	15	2025-11-19 10:05:36
1855	7	26.7	2025-11-19 10:05:50
1856	8	57	2025-11-19 10:05:50
1857	9	0	2025-11-19 10:05:50
1858	10	15	2025-11-19 10:05:50
1859	7	26.7	2025-11-19 10:06:05
1860	8	57	2025-11-19 10:06:05
1861	9	0	2025-11-19 10:06:05
1862	10	15	2025-11-19 10:06:05
1863	7	26.7	2025-11-19 10:06:24
1864	8	57	2025-11-19 10:06:24
1865	9	0	2025-11-19 10:06:24
1866	10	16	2025-11-19 10:06:24
1867	7	26.7	2025-11-19 10:06:36
1868	8	57	2025-11-19 10:06:36
1869	9	0	2025-11-19 10:06:36
1870	10	16	2025-11-19 10:06:36
1871	7	26.7	2025-11-19 10:06:51
1872	8	57	2025-11-19 10:06:51
1873	9	0	2025-11-19 10:06:51
1874	10	16	2025-11-19 10:06:51
1875	7	26.7	2025-11-19 10:07:00
1876	8	57	2025-11-19 10:07:00
1877	9	0	2025-11-19 10:07:00
1878	10	16	2025-11-19 10:07:00
1879	7	26.7	2025-11-19 10:07:15
1880	8	57	2025-11-19 10:07:15
1881	9	0	2025-11-19 10:07:15
1882	10	16	2025-11-19 10:07:15
1883	7	26.7	2025-11-19 10:07:28
1884	8	57	2025-11-19 10:07:28
1885	9	0	2025-11-19 10:07:28
1886	10	16	2025-11-19 10:07:28
1887	7	26.7	2025-11-19 10:07:42
1888	8	57	2025-11-19 10:07:42
1889	9	0	2025-11-19 10:07:42
1890	10	16	2025-11-19 10:07:42
1891	7	26.7	2025-11-19 10:07:56
1892	8	57	2025-11-19 10:07:56
1893	9	0	2025-11-19 10:07:56
1894	10	17	2025-11-19 10:07:56
1895	7	26.7	2025-11-19 10:08:07
1896	8	57	2025-11-19 10:08:07
1897	9	0	2025-11-19 10:08:07
1898	10	16	2025-11-19 10:08:07
1899	7	26.7	2025-11-19 10:08:23
1900	8	57	2025-11-19 10:08:23
1901	9	0	2025-11-19 10:08:23
1902	10	16	2025-11-19 10:08:23
1903	7	26.7	2025-11-19 10:08:38
1904	8	57	2025-11-19 10:08:38
1905	9	0	2025-11-19 10:08:38
1906	10	16	2025-11-19 10:08:38
1907	7	26.7	2025-11-19 10:08:53
1908	8	57	2025-11-19 10:08:53
1909	9	0	2025-11-19 10:08:53
1910	10	16	2025-11-19 10:08:53
1911	7	26.7	2025-11-19 10:09:07
1912	8	57	2025-11-19 10:09:07
1913	9	0	2025-11-19 10:09:07
1914	10	16	2025-11-19 10:09:07
1915	7	26.7	2025-11-19 10:09:22
1916	8	57	2025-11-19 10:09:22
1917	9	0	2025-11-19 10:09:22
1918	10	16	2025-11-19 10:09:22
1919	7	26.7	2025-11-19 10:09:37
1920	8	57	2025-11-19 10:09:37
1921	9	0	2025-11-19 10:09:37
1922	10	15	2025-11-19 10:09:37
1923	7	26.7	2025-11-19 10:09:51
1924	8	57	2025-11-19 10:09:51
1925	9	0	2025-11-19 10:09:51
1926	10	15	2025-11-19 10:09:51
1927	7	27.1	2025-11-19 10:10:01
1928	8	55	2025-11-19 10:10:01
1929	9	0	2025-11-19 10:10:01
1930	10	15	2025-11-19 10:10:01
1931	7	27.1	2025-11-19 10:10:15
1932	8	55	2025-11-19 10:10:15
1933	9	0	2025-11-19 10:10:15
1934	10	15	2025-11-19 10:10:15
1935	7	27.1	2025-11-19 10:10:31
1936	8	55	2025-11-19 10:10:31
1937	9	0	2025-11-19 10:10:31
1938	10	15	2025-11-19 10:10:31
1939	7	27.1	2025-11-19 10:10:45
1940	8	55	2025-11-19 10:10:45
1941	9	0	2025-11-19 10:10:45
1942	10	16	2025-11-19 10:10:45
1943	7	27.1	2025-11-19 10:10:55
1944	8	55	2025-11-19 10:10:55
1945	9	0	2025-11-19 10:10:55
1946	10	15	2025-11-19 10:10:55
1947	7	27.1	2025-11-19 10:11:10
1948	8	55	2025-11-19 10:11:10
1949	9	0	2025-11-19 10:11:10
1950	10	16	2025-11-19 10:11:10
1951	7	27.1	2025-11-19 10:11:25
1952	8	55	2025-11-19 10:11:25
1953	9	0	2025-11-19 10:11:25
1954	10	16	2025-11-19 10:11:25
1955	7	27.1	2025-11-19 10:11:39
1956	8	55	2025-11-19 10:11:39
1957	9	0	2025-11-19 10:11:39
1958	10	15	2025-11-19 10:11:39
1959	7	27.1	2025-11-19 10:11:54
1960	8	55	2025-11-19 10:11:54
1961	9	0	2025-11-19 10:11:54
1962	10	14	2025-11-19 10:11:54
1963	7	27.1	2025-11-19 10:12:03
1964	8	55	2025-11-19 10:12:03
1965	9	0	2025-11-19 10:12:03
1966	10	14	2025-11-19 10:12:03
1967	7	27.1	2025-11-19 10:12:12
1968	8	55	2025-11-19 10:12:12
1969	9	0	2025-11-19 10:12:12
1970	10	15	2025-11-19 10:12:12
1971	7	27.1	2025-11-19 10:12:27
1972	8	55	2025-11-19 10:12:27
1973	9	0	2025-11-19 10:12:27
1974	10	27	2025-11-19 10:12:27
1975	7	27.1	2025-11-19 10:12:38
1976	8	55	2025-11-19 10:12:38
1977	9	0	2025-11-19 10:12:38
1978	10	26	2025-11-19 10:12:38
1979	7	27.1	2025-11-19 10:12:52
1980	8	55	2025-11-19 10:12:52
1981	9	0	2025-11-19 10:12:52
1982	10	16	2025-11-19 10:12:52
1983	7	27.1	2025-11-19 10:13:10
1984	8	55	2025-11-19 10:13:10
1985	9	0	2025-11-19 10:13:10
1986	10	15	2025-11-19 10:13:10
1987	7	27.1	2025-11-19 10:13:29
1988	8	55	2025-11-19 10:13:29
1989	9	0	2025-11-19 10:13:29
1990	10	15	2025-11-19 10:13:29
1991	7	27.1	2025-11-19 10:13:45
1992	8	55	2025-11-19 10:13:45
1993	9	0	2025-11-19 10:13:45
1994	10	15	2025-11-19 10:13:45
1995	7	27.1	2025-11-19 10:13:55
1996	8	55	2025-11-19 10:13:55
1997	9	0	2025-11-19 10:13:55
1998	10	15	2025-11-19 10:13:55
1999	7	27.1	2025-11-19 10:14:10
2000	8	55	2025-11-19 10:14:10
2001	9	0	2025-11-19 10:14:10
2002	10	16	2025-11-19 10:14:10
2003	7	27.1	2025-11-19 10:14:25
2004	8	55	2025-11-19 10:14:25
2005	9	0	2025-11-19 10:14:25
2006	10	15	2025-11-19 10:14:25
2007	7	27.1	2025-11-19 10:14:40
2008	8	55	2025-11-19 10:14:40
2009	9	0	2025-11-19 10:14:40
2010	10	16	2025-11-19 10:14:40
2011	7	27.1	2025-11-19 10:14:49
2012	8	55	2025-11-19 10:14:49
2013	9	0	2025-11-19 10:14:49
2014	10	16	2025-11-19 10:14:49
2015	7	27.1	2025-11-19 10:15:04
2016	8	55	2025-11-19 10:15:04
2017	9	0	2025-11-19 10:15:04
2018	10	15	2025-11-19 10:15:04
2019	7	27.1	2025-11-19 10:15:19
2020	8	55	2025-11-19 10:15:19
2021	9	0	2025-11-19 10:15:19
2022	10	15	2025-11-19 10:15:19
2023	7	27.1	2025-11-19 10:15:35
2024	8	55	2025-11-19 10:15:35
2025	9	0	2025-11-19 10:15:35
2026	10	15	2025-11-19 10:15:35
2027	7	27.1	2025-11-19 10:15:50
2028	8	55	2025-11-19 10:15:50
2029	9	0	2025-11-19 10:15:50
2030	10	15	2025-11-19 10:15:50
2031	7	27.1	2025-11-19 10:16:04
2032	8	55	2025-11-19 10:16:04
2033	9	0	2025-11-19 10:16:04
2034	10	15	2025-11-19 10:16:04
2035	7	27.1	2025-11-19 10:16:19
2036	8	55	2025-11-19 10:16:19
2037	9	0	2025-11-19 10:16:19
2038	10	15	2025-11-19 10:16:19
2039	7	27.1	2025-11-19 10:16:34
2040	8	55	2025-11-19 10:16:34
2041	9	0	2025-11-19 10:16:34
2042	10	15	2025-11-19 10:16:34
2043	7	27.1	2025-11-19 10:16:49
2044	8	55	2025-11-19 10:16:49
2045	9	0	2025-11-19 10:16:49
2046	10	15	2025-11-19 10:16:49
2047	7	27.1	2025-11-19 10:17:03
2048	8	55	2025-11-19 10:17:03
2049	9	0	2025-11-19 10:17:03
2050	10	15	2025-11-19 10:17:03
2051	7	27.1	2025-11-19 10:17:18
2052	8	55	2025-11-19 10:17:18
2053	9	0	2025-11-19 10:17:18
2054	10	15	2025-11-19 10:17:18
2055	7	27.1	2025-11-19 10:17:27
2056	8	55	2025-11-19 10:17:27
2057	9	0	2025-11-19 10:17:27
2058	10	17	2025-11-19 10:17:27
2059	9	0	2025-11-19 10:17:36
2060	10	32	2025-11-19 10:17:36
2061	9	0	2025-11-19 10:17:51
2062	10	34	2025-11-19 10:17:51
2063	9	100	2025-11-19 10:18:06
2064	10	0	2025-11-19 10:18:06
2065	9	100	2025-11-19 10:18:21
2066	10	0	2025-11-19 10:18:21
2067	9	0	2025-11-19 10:18:36
2068	10	67	2025-11-19 10:18:36
2069	9	0	2025-11-19 10:18:45
2070	10	65	2025-11-19 10:18:45
2071	7	29.8	2025-11-19 10:19:00
2072	8	52	2025-11-19 10:19:00
2073	9	0	2025-11-19 10:19:00
2074	10	93	2025-11-19 10:19:00
2075	7	29.8	2025-11-19 10:19:16
2076	8	52	2025-11-19 10:19:16
2077	9	0	2025-11-19 10:19:16
2078	10	65	2025-11-19 10:19:16
2079	9	100	2025-11-19 10:19:31
2080	10	0	2025-11-19 10:19:31
2081	9	0	2025-11-19 10:19:46
2082	10	67	2025-11-19 10:19:46
2083	7	29.8	2025-11-19 10:20:01
2084	8	52	2025-11-19 10:20:01
2085	9	0	2025-11-19 10:20:01
2086	10	68	2025-11-19 10:20:01
2087	7	29.8	2025-11-19 10:20:15
2088	8	52	2025-11-19 10:20:15
2089	9	0	2025-11-19 10:20:15
2090	10	73	2025-11-19 10:20:15
2091	7	29.8	2025-11-19 10:20:25
2092	8	52	2025-11-19 10:20:25
2093	9	0	2025-11-19 10:20:25
2094	10	66	2025-11-19 10:20:25
2095	7	29.8	2025-11-19 10:20:39
2096	8	52	2025-11-19 10:20:39
2097	9	0	2025-11-19 10:20:39
2098	10	68	2025-11-19 10:20:39
2099	7	29.8	2025-11-19 10:20:54
2100	8	52	2025-11-19 10:20:54
2101	9	0	2025-11-19 10:20:54
2102	10	68	2025-11-19 10:20:54
2103	7	29.8	2025-11-19 10:21:04
2104	8	52	2025-11-19 10:21:04
2105	9	100	2025-11-19 10:21:04
2106	10	0	2025-11-19 10:21:04
2107	9	0	2025-11-19 10:21:19
2108	10	67	2025-11-19 10:21:19
2109	9	0	2025-11-19 10:21:34
2110	10	67	2025-11-19 10:21:34
2111	9	0	2025-11-19 10:21:48
2112	10	68	2025-11-19 10:21:48
2113	9	0	2025-11-19 10:22:03
2114	10	67	2025-11-19 10:22:03
2115	9	0	2025-11-19 10:22:17
2116	10	55	2025-11-19 10:22:17
2117	9	100	2025-11-19 10:22:31
2118	10	0	2025-11-19 10:22:31
2119	9	0	2025-11-19 10:22:45
2120	10	59	2025-11-19 10:22:45
2121	9	0	2025-11-19 10:22:55
2122	10	53	2025-11-19 10:22:55
2123	7	29.8	2025-11-19 10:23:10
2124	8	51	2025-11-19 10:23:10
2125	9	0	2025-11-19 10:23:10
2126	10	52	2025-11-19 10:23:10
2127	7	29.8	2025-11-19 10:23:19
2128	8	51	2025-11-19 10:23:19
2129	9	0	2025-11-19 10:23:19
2130	10	51	2025-11-19 10:23:19
2131	7	29.8	2025-11-19 10:23:33
2132	8	51	2025-11-19 10:23:33
2133	9	0	2025-11-19 10:23:33
2134	10	54	2025-11-19 10:23:33
2135	7	29.8	2025-11-19 10:23:48
2136	8	51	2025-11-19 10:23:48
2137	9	0	2025-11-19 10:23:48
2138	10	63	2025-11-19 10:23:48
2139	7	29.8	2025-11-19 10:24:03
2140	8	51	2025-11-19 10:24:03
2141	9	0	2025-11-19 10:24:03
2142	10	94	2025-11-19 10:24:03
2143	7	29.8	2025-11-19 10:24:16
2144	8	51	2025-11-19 10:24:16
2145	9	0	2025-11-19 10:24:16
2146	10	64	2025-11-19 10:24:16
2147	7	29.8	2025-11-19 10:24:31
2148	8	51	2025-11-19 10:24:31
2149	9	0	2025-11-19 10:24:31
2150	10	65	2025-11-19 10:24:31
2151	7	29.8	2025-11-19 10:24:46
2152	8	51	2025-11-19 10:24:46
2153	9	0	2025-11-19 10:24:46
2154	10	63	2025-11-19 10:24:46
2155	7	29.8	2025-11-19 10:25:01
2156	8	51	2025-11-19 10:25:01
2157	9	0	2025-11-19 10:25:01
2158	10	61	2025-11-19 10:25:01
2159	7	29.8	2025-11-19 10:25:17
2160	8	51	2025-11-19 10:25:17
2161	9	0	2025-11-19 10:25:17
2162	10	63	2025-11-19 10:25:17
2163	7	29.8	2025-11-19 10:25:27
2164	8	51	2025-11-19 10:25:27
2165	9	0	2025-11-19 10:25:27
2166	10	60	2025-11-19 10:25:27
2167	7	29.8	2025-11-19 10:25:37
2168	8	51	2025-11-19 10:25:37
2169	9	0	2025-11-19 10:25:37
2170	10	61	2025-11-19 10:25:37
2171	7	29.8	2025-11-19 10:25:51
2172	8	51	2025-11-19 10:25:51
2173	9	0	2025-11-19 10:25:51
2174	10	61	2025-11-19 10:25:51
2175	7	29.8	2025-11-19 10:26:05
2176	8	51	2025-11-19 10:26:05
2177	9	0	2025-11-19 10:26:05
2178	10	61	2025-11-19 10:26:05
2179	7	29.8	2025-11-19 10:26:20
2180	8	51	2025-11-19 10:26:20
2181	9	0	2025-11-19 10:26:20
2182	10	61	2025-11-19 10:26:20
2183	7	29.8	2025-11-19 10:26:34
2184	8	51	2025-11-19 10:26:34
2185	9	0	2025-11-19 10:26:34
2186	10	61	2025-11-19 10:26:34
2187	7	29.8	2025-11-19 10:26:48
2188	8	52	2025-11-19 10:26:48
2189	9	0	2025-11-19 10:26:48
2190	10	61	2025-11-19 10:26:48
2191	7	29.8	2025-11-19 10:26:57
2192	8	52	2025-11-19 10:26:57
2193	9	0	2025-11-19 10:26:57
2194	10	62	2025-11-19 10:26:57
2195	7	29.8	2025-11-19 10:27:07
2196	8	52	2025-11-19 10:27:07
2197	9	0	2025-11-19 10:27:07
2198	10	61	2025-11-19 10:27:07
2199	7	29.8	2025-11-19 10:27:21
2200	8	52	2025-11-19 10:27:21
2201	9	0	2025-11-19 10:27:21
2202	10	61	2025-11-19 10:27:21
2203	7	29.8	2025-11-19 10:27:31
2204	8	52	2025-11-19 10:27:31
2205	9	0	2025-11-19 10:27:31
2206	10	54	2025-11-19 10:27:31
2207	7	29.8	2025-11-19 10:27:46
2208	8	52	2025-11-19 10:27:46
2209	9	0	2025-11-19 10:27:46
2210	10	54	2025-11-19 10:27:46
2211	7	29.8	2025-11-19 10:28:01
2212	8	52	2025-11-19 10:28:01
2213	9	0	2025-11-19 10:28:01
2214	10	53	2025-11-19 10:28:01
2215	7	29.8	2025-11-19 10:28:22
2216	8	52	2025-11-19 10:28:22
2217	9	0	2025-11-19 10:28:22
2218	10	51	2025-11-19 10:28:22
2219	7	29.8	2025-11-19 10:28:36
2220	8	51	2025-11-19 10:28:36
2221	9	0	2025-11-19 10:28:36
2222	10	51	2025-11-19 10:28:36
2223	7	29.8	2025-11-19 10:28:51
2224	8	51	2025-11-19 10:28:51
2225	9	0	2025-11-19 10:28:51
2226	10	51	2025-11-19 10:28:51
2227	7	29.8	2025-11-19 10:29:00
2228	8	51	2025-11-19 10:29:00
2229	9	100	2025-11-19 10:29:00
2230	10	71	2025-11-19 10:29:00
2231	7	29.8	2025-11-19 10:29:09
2232	8	51	2025-11-19 10:29:09
2233	9	0	2025-11-19 10:29:09
2234	10	55	2025-11-19 10:29:09
2235	7	29.8	2025-11-19 10:29:24
2236	8	51	2025-11-19 10:29:24
2237	9	100	2025-11-19 10:29:24
2238	10	42	2025-11-19 10:29:24
2239	9	0	2025-11-19 10:29:38
2240	10	58	2025-11-19 10:29:38
2241	9	100	2025-11-19 10:29:52
2242	10	0	2025-11-19 10:29:52
2243	9	0	2025-11-19 10:30:07
2244	10	35	2025-11-19 10:30:07
2245	9	0	2025-11-19 10:30:52
2246	10	53	2025-11-19 10:30:52
2247	9	0	2025-11-19 10:31:06
2248	10	61	2025-11-19 10:31:06
2249	9	5	2025-11-19 10:31:21
2250	10	50	2025-11-19 10:31:21
2251	9	0	2025-11-19 10:31:36
2252	10	47	2025-11-19 10:31:36
2253	9	0	2025-11-19 10:31:45
2254	10	53	2025-11-19 10:31:45
2255	9	0	2025-11-19 10:31:55
2256	10	54	2025-11-19 10:31:55
2257	9	0	2025-11-19 10:32:09
2258	10	57	2025-11-19 10:32:09
2259	9	100	2025-11-19 10:32:18
2260	10	0	2025-11-19 10:32:18
2261	9	0	2025-11-19 10:32:27
2262	10	59	2025-11-19 10:32:27
2263	9	0	2025-11-19 10:32:42
2264	10	59	2025-11-19 10:32:42
2265	9	0	2025-11-19 10:32:51
2266	10	59	2025-11-19 10:32:51
2267	7	29.8	2025-11-19 10:33:06
2268	8	51	2025-11-19 10:33:06
2269	9	0	2025-11-19 10:33:06
2270	10	54	2025-11-19 10:33:06
2271	7	31.3	2025-11-19 10:33:15
2272	8	45	2025-11-19 10:33:15
2273	9	0	2025-11-19 10:33:15
2274	10	10	2025-11-19 10:33:15
2275	7	31.3	2025-11-19 10:33:22
2276	8	45	2025-11-19 10:33:22
2277	9	0	2025-11-19 10:33:22
2278	10	10	2025-11-19 10:33:22
2279	7	31.3	2025-11-19 10:33:36
2280	8	45	2025-11-19 10:33:36
2281	9	0	2025-11-19 10:33:36
2282	10	10	2025-11-19 10:33:36
2283	7	31.3	2025-11-19 10:33:45
2284	8	45	2025-11-19 10:33:45
2285	9	0	2025-11-19 10:33:45
2286	10	10	2025-11-19 10:33:45
2287	7	31.3	2025-11-19 10:33:56
2288	8	45	2025-11-19 10:33:56
2289	9	0	2025-11-19 10:33:56
2290	10	10	2025-11-19 10:33:56
2291	7	31.3	2025-11-19 10:34:11
2292	8	45	2025-11-19 10:34:11
2293	9	0	2025-11-19 10:34:11
2294	10	10	2025-11-19 10:34:11
2295	7	31.3	2025-11-19 10:34:24
2296	8	45	2025-11-19 10:34:24
2297	9	0	2025-11-19 10:34:24
2298	10	10	2025-11-19 10:34:24
2299	7	31.3	2025-11-19 10:34:30
2300	8	45	2025-11-19 10:34:30
2301	9	0.2932551319648127	2025-11-19 10:34:30
2302	10	10	2025-11-19 10:34:30
2303	7	31.3	2025-11-19 10:34:45
2304	8	45	2025-11-19 10:34:45
2305	9	0.2932551319648127	2025-11-19 10:34:45
2306	10	10	2025-11-19 10:34:45
2307	7	31.3	2025-11-19 10:34:55
2308	8	45	2025-11-19 10:34:55
2309	9	0.2932551319648127	2025-11-19 10:34:55
2310	10	10	2025-11-19 10:34:55
2311	7	31.3	2025-11-19 10:35:09
2312	8	45	2025-11-19 10:35:09
2313	9	0.2932551319648127	2025-11-19 10:35:09
2314	10	10	2025-11-19 10:35:09
2315	7	31.3	2025-11-19 10:35:24
2316	8	45	2025-11-19 10:35:24
2317	9	0.2932551319648127	2025-11-19 10:35:24
2318	10	10	2025-11-19 10:35:24
2319	7	31.3	2025-11-19 10:35:33
2320	8	45	2025-11-19 10:35:33
2321	9	0.2932551319648127	2025-11-19 10:35:33
2322	10	10	2025-11-19 10:35:33
2323	7	31.3	2025-11-19 10:35:48
2324	8	45	2025-11-19 10:35:48
2325	9	0.2932551319648127	2025-11-19 10:35:48
2326	10	10	2025-11-19 10:35:48
2327	7	31.3	2025-11-19 10:36:04
2328	8	45	2025-11-19 10:36:04
2329	9	0.3910068426197455	2025-11-19 10:36:04
2330	10	10	2025-11-19 10:36:04
2331	7	31.3	2025-11-19 10:36:18
2332	8	45	2025-11-19 10:36:18
2333	9	0.3910068426197455	2025-11-19 10:36:18
2334	10	10	2025-11-19 10:36:18
2335	7	31.3	2025-11-19 10:36:32
2336	8	45	2025-11-19 10:36:32
2337	9	0.3910068426197455	2025-11-19 10:36:32
2338	10	10	2025-11-19 10:36:32
2339	7	31.3	2025-11-19 10:36:46
2340	8	45	2025-11-19 10:36:46
2341	9	0.2932551319648127	2025-11-19 10:36:46
2342	10	10	2025-11-19 10:36:46
2343	7	31.3	2025-11-19 10:37:00
2344	8	45	2025-11-19 10:37:00
2345	9	0.2932551319648127	2025-11-19 10:37:00
2346	10	10	2025-11-19 10:37:00
2347	7	31.3	2025-11-19 10:37:14
2348	8	45	2025-11-19 10:37:14
2349	9	0.2932551319648127	2025-11-19 10:37:14
2350	10	10	2025-11-19 10:37:14
2351	7	31.3	2025-11-19 10:37:28
2352	8	45	2025-11-19 10:37:28
2353	9	0.3910068426197455	2025-11-19 10:37:28
2354	10	10	2025-11-19 10:37:28
2355	7	31.3	2025-11-19 10:37:42
2356	8	45	2025-11-19 10:37:42
2357	9	0.3910068426197455	2025-11-19 10:37:42
2358	10	10	2025-11-19 10:37:42
2359	7	31.3	2025-11-19 10:37:51
2360	8	45	2025-11-19 10:37:51
2361	9	0.3910068426197455	2025-11-19 10:37:51
2362	10	10	2025-11-19 10:37:51
2363	7	31.3	2025-11-19 10:38:00
2364	8	45	2025-11-19 10:38:00
2365	9	0.2932551319648127	2025-11-19 10:38:00
2366	10	10	2025-11-19 10:38:00
2367	7	31.3	2025-11-19 10:38:15
2368	8	45	2025-11-19 10:38:15
2369	9	0.2932551319648127	2025-11-19 10:38:15
2370	10	10	2025-11-19 10:38:15
2371	7	31.3	2025-11-19 10:38:24
2372	8	45	2025-11-19 10:38:24
2373	9	0.2932551319648127	2025-11-19 10:38:24
2374	10	10	2025-11-19 10:38:24
2375	7	31.3	2025-11-19 10:38:33
2376	8	45	2025-11-19 10:38:33
2377	9	0.3910068426197455	2025-11-19 10:38:33
2378	10	10	2025-11-19 10:38:33
2379	7	31.3	2025-11-19 10:38:42
2380	8	45	2025-11-19 10:38:42
2381	9	0.2932551319648127	2025-11-19 10:38:42
2382	10	10	2025-11-19 10:38:42
2383	7	31.3	2025-11-19 10:38:57
2384	8	45	2025-11-19 10:38:57
2385	9	0.2932551319648127	2025-11-19 10:38:57
2386	10	10	2025-11-19 10:38:57
2387	7	31.3	2025-11-19 10:39:10
2388	8	45	2025-11-19 10:39:10
2389	9	0.2932551319648127	2025-11-19 10:39:10
2390	10	10	2025-11-19 10:39:10
2391	7	31.3	2025-11-19 10:39:25
2392	8	45	2025-11-19 10:39:25
2393	9	0.3910068426197455	2025-11-19 10:39:25
2394	10	10	2025-11-19 10:39:25
2395	7	31.3	2025-11-19 10:39:39
2396	8	45	2025-11-19 10:39:39
2397	9	0.2932551319648127	2025-11-19 10:39:39
2398	10	10	2025-11-19 10:39:39
2399	7	31.3	2025-11-19 10:39:49
2400	8	45	2025-11-19 10:39:49
2401	9	0.3910068426197455	2025-11-19 10:39:49
2402	10	10	2025-11-19 10:39:49
2403	7	31.3	2025-11-19 10:40:04
2404	8	45	2025-11-19 10:40:04
2405	9	0.2932551319648127	2025-11-19 10:40:04
2406	10	10	2025-11-19 10:40:04
2407	7	31.3	2025-11-19 10:40:13
2408	8	45	2025-11-19 10:40:13
2409	9	0.2932551319648127	2025-11-19 10:40:13
2410	10	10	2025-11-19 10:40:13
2411	7	31.3	2025-11-19 10:40:27
2412	8	45	2025-11-19 10:40:27
2413	9	0.2932551319648127	2025-11-19 10:40:27
2414	10	10	2025-11-19 10:40:27
2415	7	31.3	2025-11-19 10:40:42
2416	8	45	2025-11-19 10:40:42
2417	9	0.2932551319648127	2025-11-19 10:40:42
2418	10	10	2025-11-19 10:40:42
2419	7	31.3	2025-11-19 10:40:55
2420	8	45	2025-11-19 10:40:55
2421	9	0.2932551319648127	2025-11-19 10:40:55
2422	10	10	2025-11-19 10:40:55
2423	7	31.3	2025-11-19 10:41:10
2424	8	45	2025-11-19 10:41:10
2425	9	0.2932551319648127	2025-11-19 10:41:10
2426	10	10	2025-11-19 10:41:10
2427	7	31.3	2025-11-19 10:41:24
2428	8	45	2025-11-19 10:41:24
2429	9	0.2932551319648127	2025-11-19 10:41:24
2430	10	10	2025-11-19 10:41:24
2431	7	31.3	2025-11-19 10:41:33
2432	8	45	2025-11-19 10:41:33
2433	9	0.2932551319648127	2025-11-19 10:41:33
2434	10	10	2025-11-19 10:41:33
2435	7	31.3	2025-11-19 10:41:48
2436	8	45	2025-11-19 10:41:48
2437	9	0.3910068426197455	2025-11-19 10:41:48
2438	10	10	2025-11-19 10:41:48
2439	7	31.3	2025-11-19 10:41:58
2440	8	45	2025-11-19 10:41:58
2441	9	0.2932551319648127	2025-11-19 10:41:58
2442	10	10	2025-11-19 10:41:58
2443	7	31.3	2025-11-19 10:42:12
2444	8	45	2025-11-19 10:42:12
2445	9	0.2932551319648127	2025-11-19 10:42:12
2446	10	10	2025-11-19 10:42:12
2447	7	31.3	2025-11-19 10:42:21
2448	8	45	2025-11-19 10:42:21
2449	9	0.3910068426197455	2025-11-19 10:42:21
2450	10	10	2025-11-19 10:42:21
2451	7	31.3	2025-11-19 10:42:30
2452	8	45	2025-11-19 10:42:30
2453	9	0.2932551319648127	2025-11-19 10:42:30
2454	10	10	2025-11-19 10:42:30
2455	7	31.3	2025-11-19 10:42:39
2456	8	45	2025-11-19 10:42:39
2457	9	0.3910068426197455	2025-11-19 10:42:39
2458	10	10	2025-11-19 10:42:39
2459	7	31.3	2025-11-19 10:42:54
2460	8	45	2025-11-19 10:42:54
2461	9	0.2932551319648127	2025-11-19 10:42:54
2462	10	10	2025-11-19 10:42:54
2463	7	31.3	2025-11-19 10:43:04
2464	8	45	2025-11-19 10:43:04
2465	9	0.2932551319648127	2025-11-19 10:43:04
2466	10	10	2025-11-19 10:43:04
2467	7	31.3	2025-11-19 10:43:12
2468	8	45	2025-11-19 10:43:12
2469	9	0.2932551319648127	2025-11-19 10:43:12
2470	10	10	2025-11-19 10:43:12
2471	7	31.3	2025-11-19 10:43:27
2472	8	45	2025-11-19 10:43:27
2473	9	0.2932551319648127	2025-11-19 10:43:27
2474	10	10	2025-11-19 10:43:27
2475	7	31.3	2025-11-19 10:43:42
2476	8	45	2025-11-19 10:43:42
2477	9	0.2932551319648127	2025-11-19 10:43:42
2478	10	10	2025-11-19 10:43:42
2479	7	31.3	2025-11-19 10:43:57
2480	8	45	2025-11-19 10:43:57
2481	9	0.3910068426197455	2025-11-19 10:43:57
2482	10	10	2025-11-19 10:43:57
2483	7	31.3	2025-11-19 10:44:07
2484	8	45	2025-11-19 10:44:07
2485	9	0.2932551319648127	2025-11-19 10:44:07
2486	10	10	2025-11-19 10:44:07
2487	7	31.3	2025-11-19 10:44:21
2488	8	45	2025-11-19 10:44:21
2489	9	0.3910068426197455	2025-11-19 10:44:21
2490	10	10	2025-11-19 10:44:21
2491	7	31.3	2025-11-19 10:44:36
2492	8	45	2025-11-19 10:44:36
2493	9	0.2932551319648127	2025-11-19 10:44:36
2494	10	10	2025-11-19 10:44:36
2495	7	31.3	2025-11-19 10:44:45
2496	8	45	2025-11-19 10:44:45
2497	9	0.3910068426197455	2025-11-19 10:44:45
2498	10	10	2025-11-19 10:44:45
2499	7	31.3	2025-11-19 10:45:00
2500	8	45	2025-11-19 10:45:00
2501	9	0.2932551319648127	2025-11-19 10:45:00
2502	10	10	2025-11-19 10:45:00
2503	7	31.3	2025-11-19 10:45:16
2504	8	45	2025-11-19 10:45:16
2505	9	0.3910068426197455	2025-11-19 10:45:16
2506	10	10	2025-11-19 10:45:16
2507	7	31.3	2025-11-19 10:45:30
2508	8	45	2025-11-19 10:45:30
2509	9	0.2932551319648127	2025-11-19 10:45:30
2510	10	10	2025-11-19 10:45:30
2511	7	31.3	2025-11-19 10:45:39
2512	8	45	2025-11-19 10:45:39
2513	9	0.3910068426197455	2025-11-19 10:45:39
2514	10	10	2025-11-19 10:45:39
2515	7	31.3	2025-11-19 10:45:54
2516	8	45	2025-11-19 10:45:54
2517	9	0.2932551319648127	2025-11-19 10:45:54
2518	10	10	2025-11-19 10:45:54
2519	7	31.3	2025-11-19 10:46:09
2520	8	45	2025-11-19 10:46:09
2521	9	0.3910068426197455	2025-11-19 10:46:09
2522	10	10	2025-11-19 10:46:09
2523	7	31.3	2025-11-19 10:46:18
2524	8	45	2025-11-19 10:46:18
2525	9	0.3910068426197455	2025-11-19 10:46:18
2526	10	10	2025-11-19 10:46:18
2527	7	31.3	2025-11-19 10:46:33
2528	8	45	2025-11-19 10:46:33
2529	9	0.2932551319648127	2025-11-19 10:46:33
2530	10	10	2025-11-19 10:46:33
2531	7	31.3	2025-11-19 10:46:48
2532	8	45	2025-11-19 10:46:48
2533	9	0.3910068426197455	2025-11-19 10:46:48
2534	10	10	2025-11-19 10:46:48
2535	7	31.3	2025-11-19 10:46:57
2536	8	45	2025-11-19 10:46:57
2537	9	0.3910068426197455	2025-11-19 10:46:57
2538	10	10	2025-11-19 10:46:57
2539	7	31.3	2025-11-19 10:47:12
2540	8	45	2025-11-19 10:47:12
2541	9	0.3910068426197455	2025-11-19 10:47:12
2542	10	10	2025-11-19 10:47:12
2543	7	31.3	2025-11-19 10:47:21
2544	8	45	2025-11-19 10:47:21
2545	9	0.2932551319648127	2025-11-19 10:47:21
2546	10	10	2025-11-19 10:47:21
2547	7	31.3	2025-11-19 10:47:36
2548	8	45	2025-11-19 10:47:36
2549	9	0.3910068426197455	2025-11-19 10:47:36
2550	10	10	2025-11-19 10:47:36
2551	7	31.3	2025-11-19 10:47:50
2552	8	45	2025-11-19 10:47:50
2553	9	0.2932551319648127	2025-11-19 10:47:50
2554	10	10	2025-11-19 10:47:50
2555	7	31.3	2025-11-19 10:48:04
2556	8	45	2025-11-19 10:48:04
2557	9	0.2932551319648127	2025-11-19 10:48:04
2558	10	10	2025-11-19 10:48:04
2559	7	31.3	2025-11-19 10:48:18
2560	8	45	2025-11-19 10:48:18
2561	9	0.3910068426197455	2025-11-19 10:48:18
2562	10	10	2025-11-19 10:48:18
2563	7	31.3	2025-11-19 10:48:27
2564	8	45	2025-11-19 10:48:27
2565	9	0.2932551319648127	2025-11-19 10:48:27
2566	10	10	2025-11-19 10:48:27
2567	7	31.3	2025-11-19 10:48:37
2568	8	45	2025-11-19 10:48:37
2569	9	0.3910068426197455	2025-11-19 10:48:37
2570	10	10	2025-11-19 10:48:37
2571	7	31.3	2025-11-19 10:48:51
2572	8	45	2025-11-19 10:48:51
2573	9	0.2932551319648127	2025-11-19 10:48:51
2574	10	10	2025-11-19 10:48:51
2575	7	31.3	2025-11-19 10:49:00
2576	8	45	2025-11-19 10:49:00
2577	9	0.2932551319648127	2025-11-19 10:49:00
2578	10	10	2025-11-19 10:49:00
2579	7	31.3	2025-11-19 10:49:09
2580	8	45	2025-11-19 10:49:09
2581	9	0.2932551319648127	2025-11-19 10:49:09
2582	10	10	2025-11-19 10:49:09
2583	7	31.3	2025-11-19 10:49:19
2584	8	45	2025-11-19 10:49:19
2585	9	0.3910068426197455	2025-11-19 10:49:19
2586	10	10	2025-11-19 10:49:19
2587	7	31.3	2025-11-19 10:49:33
2588	8	45	2025-11-19 10:49:33
2589	9	0.2932551319648127	2025-11-19 10:49:33
2590	10	10	2025-11-19 10:49:33
2591	7	31.3	2025-11-19 10:49:43
2592	8	45	2025-11-19 10:49:43
2593	9	0.2932551319648127	2025-11-19 10:49:43
2594	10	10	2025-11-19 10:49:43
2595	7	31.3	2025-11-19 10:50:07
2596	8	45	2025-11-19 10:50:07
2597	9	0.19550342130987985	2025-11-19 10:50:07
2598	10	10	2025-11-19 10:50:07
2599	7	31.3	2025-11-19 10:50:22
2600	8	45	2025-11-19 10:50:22
2601	9	0.3910068426197455	2025-11-19 10:50:22
2602	10	10	2025-11-19 10:50:22
2603	7	31.3	2025-11-19 10:50:36
2604	8	45	2025-11-19 10:50:36
2605	9	0.2932551319648127	2025-11-19 10:50:36
2606	10	10	2025-11-19 10:50:36
2607	7	31.2	2025-11-19 10:50:51
2608	8	45	2025-11-19 10:50:51
2609	9	0.3910068426197455	2025-11-19 10:50:51
2610	10	10	2025-11-19 10:50:51
2611	7	31.2	2025-11-19 10:51:01
2612	8	45	2025-11-19 10:51:01
2613	9	0.2932551319648127	2025-11-19 10:51:01
2614	10	10	2025-11-19 10:51:01
2615	7	30.8	2025-11-19 10:51:15
2616	8	45	2025-11-19 10:51:15
2617	9	0.2932551319648127	2025-11-19 10:51:15
2618	10	10	2025-11-19 10:51:15
2619	7	30.8	2025-11-19 10:51:25
2620	8	45	2025-11-19 10:51:25
2621	9	0.2932551319648127	2025-11-19 10:51:25
2622	10	10	2025-11-19 10:51:25
2623	7	30.8	2025-11-19 10:51:38
2624	8	45	2025-11-19 10:51:38
2625	9	0.3910068426197455	2025-11-19 10:51:38
2626	10	10	2025-11-19 10:51:38
2627	7	30.8	2025-11-19 10:51:48
2628	8	45	2025-11-19 10:51:48
2629	9	0.2932551319648127	2025-11-19 10:51:48
2630	10	10	2025-11-19 10:51:48
2631	7	30.8	2025-11-19 10:51:57
2632	8	45	2025-11-19 10:51:57
2633	9	0.2932551319648127	2025-11-19 10:51:57
2634	10	10	2025-11-19 10:51:57
2635	7	30.8	2025-11-19 10:52:12
2636	8	45	2025-11-19 10:52:12
2637	9	0.2932551319648127	2025-11-19 10:52:12
2638	10	10	2025-11-19 10:52:12
2639	7	30.8	2025-11-19 10:52:27
2640	8	45	2025-11-19 10:52:27
2641	9	0.2932551319648127	2025-11-19 10:52:27
2642	10	10	2025-11-19 10:52:27
2643	7	30.8	2025-11-19 10:52:37
2644	8	45	2025-11-19 10:52:37
2645	9	0.2932551319648127	2025-11-19 10:52:37
2646	10	10	2025-11-19 10:52:37
2647	7	30.8	2025-11-19 10:52:51
2648	8	45	2025-11-19 10:52:51
2649	9	0.3910068426197455	2025-11-19 10:52:51
2650	10	10	2025-11-19 10:52:51
2651	7	30.8	2025-11-19 10:53:06
2652	8	45	2025-11-19 10:53:06
2653	9	0.2932551319648127	2025-11-19 10:53:06
2654	10	10	2025-11-19 10:53:06
2655	7	30.8	2025-11-19 10:53:15
2656	8	45	2025-11-19 10:53:15
2657	9	0.2932551319648127	2025-11-19 10:53:15
2658	10	10	2025-11-19 10:53:15
2659	7	30.8	2025-11-19 10:53:28
2660	8	45	2025-11-19 10:53:28
2661	9	0.2932551319648127	2025-11-19 10:53:28
2662	10	10	2025-11-19 10:53:28
2663	7	30.8	2025-11-19 10:53:43
2664	8	45	2025-11-19 10:53:43
2665	9	0.2932551319648127	2025-11-19 10:53:43
2666	10	10	2025-11-19 10:53:43
2667	7	30.8	2025-11-19 10:53:57
2668	8	45	2025-11-19 10:53:57
2669	9	0.2932551319648127	2025-11-19 10:53:57
2670	10	10	2025-11-19 10:53:57
2671	7	30.8	2025-11-19 10:54:12
2672	8	45	2025-11-19 10:54:12
2673	9	0.2932551319648127	2025-11-19 10:54:12
2674	10	10	2025-11-19 10:54:12
2675	7	30.8	2025-11-19 10:54:26
2676	8	45	2025-11-19 10:54:26
2677	9	0.2932551319648127	2025-11-19 10:54:26
2678	10	10	2025-11-19 10:54:26
2679	7	30.8	2025-11-19 10:54:41
2680	8	45	2025-11-19 10:54:41
2681	9	0.3910068426197455	2025-11-19 10:54:41
2682	10	10	2025-11-19 10:54:41
2683	7	30.8	2025-11-19 10:54:55
2684	8	45	2025-11-19 10:54:55
2685	9	0.2932551319648127	2025-11-19 10:54:55
2686	10	10	2025-11-19 10:54:55
2687	7	30.8	2025-11-19 10:55:10
2688	8	45	2025-11-19 10:55:10
2689	9	0.3910068426197455	2025-11-19 10:55:10
2690	10	10	2025-11-19 10:55:10
2691	7	30.8	2025-11-19 10:55:24
2692	8	45	2025-11-19 10:55:24
2693	9	0.2932551319648127	2025-11-19 10:55:24
2694	10	10	2025-11-19 10:55:24
2695	7	30.8	2025-11-19 10:55:33
2696	8	45	2025-11-19 10:55:33
2697	9	0.2932551319648127	2025-11-19 10:55:33
2698	10	10	2025-11-19 10:55:33
2699	7	30.8	2025-11-19 10:55:43
2700	8	45	2025-11-19 10:55:43
2701	9	0.2932551319648127	2025-11-19 10:55:43
2702	10	10	2025-11-19 10:55:43
2703	7	30.8	2025-11-19 10:55:57
2704	8	45	2025-11-19 10:55:57
2705	9	0.3910068426197455	2025-11-19 10:55:57
2706	10	10	2025-11-19 10:55:57
2707	7	30.8	2025-11-19 10:56:06
2708	8	45	2025-11-19 10:56:06
2709	9	0.2932551319648127	2025-11-19 10:56:06
2710	10	10	2025-11-19 10:56:06
2711	7	30.8	2025-11-19 10:56:15
2712	8	45	2025-11-19 10:56:15
2713	9	0.2932551319648127	2025-11-19 10:56:15
2714	10	10	2025-11-19 10:56:15
2715	7	30.8	2025-11-19 10:56:25
2716	8	45	2025-11-19 10:56:25
2717	9	0.2932551319648127	2025-11-19 10:56:25
2718	10	10	2025-11-19 10:56:25
2719	7	30.8	2025-11-19 10:56:39
2720	8	45	2025-11-19 10:56:39
2721	9	0.3910068426197455	2025-11-19 10:56:39
2722	10	10	2025-11-19 10:56:39
2723	7	30.8	2025-11-19 10:56:49
2724	8	45	2025-11-19 10:56:49
2725	9	0.2932551319648127	2025-11-19 10:56:49
2726	10	10	2025-11-19 10:56:49
2727	7	30.8	2025-11-19 10:57:03
2728	8	45	2025-11-19 10:57:03
2729	9	0.2932551319648127	2025-11-19 10:57:03
2730	10	10	2025-11-19 10:57:03
2731	7	30.8	2025-11-19 10:57:12
2732	8	45	2025-11-19 10:57:12
2733	9	0.2932551319648127	2025-11-19 10:57:12
2734	10	10	2025-11-19 10:57:12
2735	7	30.8	2025-11-19 10:57:21
2736	8	45	2025-11-19 10:57:21
2737	9	0.3910068426197455	2025-11-19 10:57:21
2738	10	10	2025-11-19 10:57:21
2739	7	30.8	2025-11-19 10:57:36
2740	8	45	2025-11-19 10:57:36
2741	9	0.2932551319648127	2025-11-19 10:57:36
2742	10	10	2025-11-19 10:57:36
2743	7	30.8	2025-11-19 10:57:45
2744	8	45	2025-11-19 10:57:45
2745	9	0.2932551319648127	2025-11-19 10:57:45
2746	10	10	2025-11-19 10:57:45
2747	7	30.8	2025-11-19 10:57:55
2748	8	45	2025-11-19 10:57:55
2749	9	0.2932551319648127	2025-11-19 10:57:55
2750	10	10	2025-11-19 10:57:55
2751	7	30.8	2025-11-19 10:58:11
2752	8	45	2025-11-19 10:58:11
2753	9	0.2932551319648127	2025-11-19 10:58:11
2754	10	10	2025-11-19 10:58:11
2755	7	30.8	2025-11-19 10:58:25
2756	8	45	2025-11-19 10:58:25
2757	9	0.3910068426197455	2025-11-19 10:58:25
2758	10	10	2025-11-19 10:58:25
2759	7	29.8	2025-11-19 10:58:39
2760	8	35	2025-11-19 10:58:39
2761	9	0.2932551319648127	2025-11-19 10:58:39
2762	10	30	2025-11-19 10:58:39
2763	7	29.8	2025-11-19 10:58:53
2764	8	35	2025-11-19 10:58:53
2765	9	0.2932551319648127	2025-11-19 10:58:53
2766	10	29	2025-11-19 10:58:53
2767	7	29.8	2025-11-19 10:59:08
2768	8	35	2025-11-19 10:59:08
2769	9	0.19550342130987985	2025-11-19 10:59:08
2770	10	14	2025-11-19 10:59:08
2771	7	29.8	2025-11-19 10:59:23
2772	8	34	2025-11-19 10:59:23
2773	9	0.19550342130987985	2025-11-19 10:59:23
2774	10	14	2025-11-19 10:59:23
2775	7	29.8	2025-11-19 10:59:37
2776	8	34	2025-11-19 10:59:37
2777	9	0.19550342130987985	2025-11-19 10:59:37
2778	10	14	2025-11-19 10:59:37
2779	7	29.8	2025-11-19 10:59:51
2780	8	34	2025-11-19 10:59:51
2781	9	0.2932551319648127	2025-11-19 10:59:51
2782	10	14	2025-11-19 10:59:51
2783	7	29.8	2025-11-19 11:00:00
2784	8	34	2025-11-19 11:00:00
2785	9	0.2932551319648127	2025-11-19 11:00:00
2786	10	14	2025-11-19 11:00:00
2787	7	29.8	2025-11-19 11:00:15
2788	8	33	2025-11-19 11:00:15
2789	9	0.2932551319648127	2025-11-19 11:00:15
2790	10	14	2025-11-19 11:00:15
2791	7	29.8	2025-11-19 11:00:25
2792	8	33	2025-11-19 11:00:25
2793	9	0.19550342130987985	2025-11-19 11:00:25
2794	10	14	2025-11-19 11:00:25
2795	7	29.8	2025-11-19 11:00:40
2796	8	33	2025-11-19 11:00:40
2797	9	0.2932551319648127	2025-11-19 11:00:40
2798	10	14	2025-11-19 11:00:40
2799	7	29.8	2025-11-19 11:00:54
2800	8	33	2025-11-19 11:00:54
2801	9	0.2932551319648127	2025-11-19 11:00:54
2802	10	24	2025-11-19 11:00:54
2803	7	29.8	2025-11-19 11:01:09
2804	8	33	2025-11-19 11:01:09
2805	9	0.2932551319648127	2025-11-19 11:01:09
2806	10	14	2025-11-19 11:01:09
2807	7	29.8	2025-11-19 11:01:22
2808	8	33	2025-11-19 11:01:22
2809	9	0.2932551319648127	2025-11-19 11:01:22
2810	10	14	2025-11-19 11:01:22
2811	7	29.8	2025-11-19 11:01:36
2812	8	33	2025-11-19 11:01:36
2813	9	0.2932551319648127	2025-11-19 11:01:36
2814	10	14	2025-11-19 11:01:36
2815	7	29.8	2025-11-19 11:01:46
2816	8	33	2025-11-19 11:01:46
2817	9	0.2932551319648127	2025-11-19 11:01:46
2818	10	14	2025-11-19 11:01:46
2819	7	29.5	2025-11-19 11:02:00
2820	8	32	2025-11-19 11:02:00
2821	9	0.3910068426197455	2025-11-19 11:02:00
2822	10	15	2025-11-19 11:02:00
2823	7	29.5	2025-11-19 11:02:15
2824	8	32	2025-11-19 11:02:15
2825	9	0.2932551319648127	2025-11-19 11:02:15
2826	10	14	2025-11-19 11:02:15
2827	7	29.3	2025-11-19 11:02:34
2828	8	32	2025-11-19 11:02:34
2829	9	0.2932551319648127	2025-11-19 11:02:34
2830	10	14	2025-11-19 11:02:34
2831	7	29.3	2025-11-19 11:02:49
2832	8	32	2025-11-19 11:02:49
2833	9	0.2932551319648127	2025-11-19 11:02:49
2834	10	14	2025-11-19 11:02:49
2835	7	29.3	2025-11-19 11:03:04
2836	8	32	2025-11-19 11:03:04
2837	9	0.2932551319648127	2025-11-19 11:03:04
2838	10	14	2025-11-19 11:03:04
2839	7	29.3	2025-11-19 11:03:18
2840	8	32	2025-11-19 11:03:18
2841	9	0.2932551319648127	2025-11-19 11:03:18
2842	10	14	2025-11-19 11:03:18
2843	7	29.3	2025-11-19 11:03:27
2844	8	32	2025-11-19 11:03:27
2845	9	0.3910068426197455	2025-11-19 11:03:27
2846	10	14	2025-11-19 11:03:27
2847	7	29.3	2025-11-19 11:03:42
2848	8	32	2025-11-19 11:03:42
2849	9	0.2932551319648127	2025-11-19 11:03:42
2850	10	14	2025-11-19 11:03:42
2851	7	29.3	2025-11-19 11:03:57
2852	8	31	2025-11-19 11:03:57
2853	9	0.2932551319648127	2025-11-19 11:03:57
2854	10	14	2025-11-19 11:03:57
2855	7	29.3	2025-11-19 11:04:07
2856	8	31	2025-11-19 11:04:07
2857	9	0.19550342130987985	2025-11-19 11:04:07
2858	10	14	2025-11-19 11:04:07
2859	7	29.3	2025-11-19 11:04:21
2860	8	31	2025-11-19 11:04:21
2861	9	0.2932551319648127	2025-11-19 11:04:21
2862	10	14	2025-11-19 11:04:21
2863	7	29.3	2025-11-19 11:04:36
2864	8	31	2025-11-19 11:04:36
2865	9	0.19550342130987985	2025-11-19 11:04:36
2866	10	14	2025-11-19 11:04:36
2867	7	29.3	2025-11-19 11:04:46
2868	8	31	2025-11-19 11:04:46
2869	9	0.2932551319648127	2025-11-19 11:04:46
2870	10	14	2025-11-19 11:04:46
2871	7	29.3	2025-11-19 11:05:00
2872	8	31	2025-11-19 11:05:00
2873	9	0.19550342130987985	2025-11-19 11:05:00
2874	10	14	2025-11-19 11:05:00
2875	7	29.3	2025-11-19 11:05:15
2876	8	31	2025-11-19 11:05:15
2877	9	0.2932551319648127	2025-11-19 11:05:15
2878	10	14	2025-11-19 11:05:15
2879	7	29.3	2025-11-19 11:05:24
2880	8	31	2025-11-19 11:05:24
2881	9	0.19550342130987985	2025-11-19 11:05:24
2882	10	14	2025-11-19 11:05:24
2883	7	29.3	2025-11-19 11:05:39
2884	8	31	2025-11-19 11:05:39
2885	9	0.2932551319648127	2025-11-19 11:05:39
2886	10	19	2025-11-19 11:05:39
2887	7	29.3	2025-11-19 11:05:47
2888	8	31	2025-11-19 11:05:47
2889	9	0.2932551319648127	2025-11-19 11:05:47
2890	10	13	2025-11-19 11:05:47
2891	7	29.3	2025-11-19 11:05:57
2892	8	31	2025-11-19 11:05:57
2893	9	0.3910068426197455	2025-11-19 11:05:57
2894	10	15	2025-11-19 11:05:57
2895	7	26.7	2025-11-19 11:06:06
2896	8	32	2025-11-19 11:06:06
2897	9	0.3910068426197455	2025-11-19 11:06:06
2898	10	14	2025-11-19 11:06:06
2899	7	26.7	2025-11-19 11:06:15
2900	8	32	2025-11-19 11:06:15
2901	9	0.2932551319648127	2025-11-19 11:06:15
2902	10	14	2025-11-19 11:06:15
2903	7	26.7	2025-11-19 11:06:24
2904	8	32	2025-11-19 11:06:24
2905	9	0.2932551319648127	2025-11-19 11:06:24
2906	10	14	2025-11-19 11:06:24
2907	7	26.7	2025-11-19 11:06:38
2908	8	32	2025-11-19 11:06:38
2909	9	0.2932551319648127	2025-11-19 11:06:38
2910	10	14	2025-11-19 11:06:38
2911	7	26.7	2025-11-19 11:06:52
2912	8	32	2025-11-19 11:06:52
2913	9	0.3910068426197455	2025-11-19 11:06:52
2914	10	18	2025-11-19 11:06:52
2915	7	26.7	2025-11-19 11:07:07
2916	8	32	2025-11-19 11:07:07
2917	9	0.2932551319648127	2025-11-19 11:07:07
2918	10	14	2025-11-19 11:07:07
2919	7	26.7	2025-11-19 11:07:21
2920	8	32	2025-11-19 11:07:21
2921	9	0.2932551319648127	2025-11-19 11:07:21
2922	10	14	2025-11-19 11:07:21
2923	7	26.7	2025-11-19 11:07:30
2924	8	32	2025-11-19 11:07:30
2925	9	0.2932551319648127	2025-11-19 11:07:30
2926	10	14	2025-11-19 11:07:30
2927	7	26.7	2025-11-19 11:07:45
2928	8	32	2025-11-19 11:07:45
2929	9	0.2932551319648127	2025-11-19 11:07:45
2930	10	14	2025-11-19 11:07:45
2931	7	26.7	2025-11-19 11:08:00
2932	8	32	2025-11-19 11:08:00
2933	9	0.2932551319648127	2025-11-19 11:08:00
2934	10	13	2025-11-19 11:08:00
2935	7	26.7	2025-11-19 11:08:09
2936	8	32	2025-11-19 11:08:09
2937	9	0.2932551319648127	2025-11-19 11:08:09
2938	10	23	2025-11-19 11:08:09
2939	7	26.7	2025-11-19 11:08:23
2940	8	32	2025-11-19 11:08:23
2941	9	0.2932551319648127	2025-11-19 11:08:23
2942	10	15	2025-11-19 11:08:23
2943	7	26.7	2025-11-19 11:08:38
2944	8	32	2025-11-19 11:08:38
2945	9	0.2932551319648127	2025-11-19 11:08:38
2946	10	13	2025-11-19 11:08:38
2947	7	26.7	2025-11-19 11:08:53
2948	8	32	2025-11-19 11:08:53
2949	9	0.2932551319648127	2025-11-19 11:08:53
2950	10	13	2025-11-19 11:08:53
2951	7	26.7	2025-11-19 11:09:07
2952	8	32	2025-11-19 11:09:07
2953	9	0.2932551319648127	2025-11-19 11:09:07
2954	10	14	2025-11-19 11:09:07
2955	7	26.7	2025-11-19 11:09:21
2956	8	32	2025-11-19 11:09:21
2957	9	0.2932551319648127	2025-11-19 11:09:21
2958	10	13	2025-11-19 11:09:21
2959	7	27	2025-11-19 11:09:30
2960	8	32	2025-11-19 11:09:30
2961	9	0.3910068426197455	2025-11-19 11:09:30
2962	10	13	2025-11-19 11:09:30
2963	7	27	2025-11-19 11:09:45
2964	8	32	2025-11-19 11:09:45
2965	9	0.3910068426197455	2025-11-19 11:09:45
2966	10	13	2025-11-19 11:09:45
2967	7	27.1	2025-11-19 11:09:54
2968	8	32	2025-11-19 11:09:54
2969	9	0.3910068426197455	2025-11-19 11:09:54
2970	10	13	2025-11-19 11:09:54
2971	7	27.1	2025-11-19 11:10:03
2972	8	32	2025-11-19 11:10:03
2973	9	0.2932551319648127	2025-11-19 11:10:03
2974	10	13	2025-11-19 11:10:03
2975	7	27.1	2025-11-19 11:10:17
2976	8	32	2025-11-19 11:10:17
2977	9	0.2932551319648127	2025-11-19 11:10:17
2978	10	14	2025-11-19 11:10:17
2979	7	27.1	2025-11-19 11:10:27
2980	8	32	2025-11-19 11:10:27
2981	9	0.2932551319648127	2025-11-19 11:10:27
2982	10	16	2025-11-19 11:10:27
2983	7	27.1	2025-11-19 11:10:42
2984	8	32	2025-11-19 11:10:42
2985	9	0.3910068426197455	2025-11-19 11:10:42
2986	10	10	2025-11-19 11:10:42
2987	7	27.1	2025-11-19 11:10:55
2988	8	32	2025-11-19 11:10:55
2989	9	0.2932551319648127	2025-11-19 11:10:55
2990	10	12	2025-11-19 11:10:55
2991	7	27.1	2025-11-19 11:11:09
2992	8	32	2025-11-19 11:11:09
2993	9	0.3910068426197455	2025-11-19 11:11:09
2994	10	11	2025-11-19 11:11:09
2995	7	27.1	2025-11-19 11:11:24
2996	8	32	2025-11-19 11:11:24
2997	9	0.2932551319648127	2025-11-19 11:11:24
2998	10	13	2025-11-19 11:11:24
2999	7	27.1	2025-11-19 11:11:34
3000	8	32	2025-11-19 11:11:34
3001	9	0.3910068426197455	2025-11-19 11:11:34
3002	10	6	2025-11-19 11:11:34
3003	7	27.1	2025-11-19 11:11:49
3004	8	32	2025-11-19 11:11:49
3005	9	0.3910068426197455	2025-11-19 11:11:49
3006	10	18	2025-11-19 11:11:49
3007	7	27.1	2025-11-19 11:12:04
3008	8	32	2025-11-19 11:12:04
3009	9	0.4887585532746783	2025-11-19 11:12:04
3010	10	9	2025-11-19 11:12:04
3011	7	27.1	2025-11-19 11:12:13
3012	8	32	2025-11-19 11:12:13
3013	9	0.2932551319648127	2025-11-19 11:12:13
3014	10	10	2025-11-19 11:12:13
3015	7	27.1	2025-11-19 11:12:27
3016	8	32	2025-11-19 11:12:27
3017	9	0.2932551319648127	2025-11-19 11:12:27
3018	10	10	2025-11-19 11:12:27
3019	7	27.1	2025-11-19 11:12:41
3020	8	32	2025-11-19 11:12:41
3021	9	0.2932551319648127	2025-11-19 11:12:41
3022	10	8	2025-11-19 11:12:41
3023	7	27.1	2025-11-19 11:12:51
3024	8	32	2025-11-19 11:12:51
3025	9	0.3910068426197455	2025-11-19 11:12:51
3026	10	13	2025-11-19 11:12:51
3027	7	27.1	2025-11-19 11:13:01
3028	8	32	2025-11-19 11:13:01
3029	9	0.2932551319648127	2025-11-19 11:13:01
3030	10	7	2025-11-19 11:13:01
3031	7	27.1	2025-11-19 11:13:15
3032	8	32	2025-11-19 11:13:15
3033	9	0.2932551319648127	2025-11-19 11:13:15
3034	10	6	2025-11-19 11:13:15
3035	7	27.1	2025-11-19 11:13:30
3036	8	32	2025-11-19 11:13:30
3037	9	0.2932551319648127	2025-11-19 11:13:30
3038	10	6	2025-11-19 11:13:30
3039	7	27.1	2025-11-19 11:13:44
3040	8	32	2025-11-19 11:13:44
3041	9	0.2932551319648127	2025-11-19 11:13:44
3042	10	6	2025-11-19 11:13:44
3043	7	27.1	2025-11-19 11:13:55
3044	8	32	2025-11-19 11:13:55
3045	9	0.2932551319648127	2025-11-19 11:13:55
3046	10	6	2025-11-19 11:13:55
3047	7	27.1	2025-11-19 11:14:09
3048	8	32	2025-11-19 11:14:09
3049	9	0.2932551319648127	2025-11-19 11:14:09
3050	10	6	2025-11-19 11:14:09
3051	7	27.1	2025-11-19 11:14:25
3052	8	32	2025-11-19 11:14:25
3053	9	0.19550342130987985	2025-11-19 11:14:25
3054	10	6	2025-11-19 11:14:25
3055	7	27.1	2025-11-19 11:14:40
3056	8	32	2025-11-19 11:14:40
3057	9	0.2932551319648127	2025-11-19 11:14:40
3058	10	6	2025-11-19 11:14:40
3059	7	27.1	2025-11-19 11:14:53
3060	8	32	2025-11-19 11:14:53
3061	9	0.19550342130987985	2025-11-19 11:14:53
3062	10	6	2025-11-19 11:14:53
3063	7	27.1	2025-11-19 11:15:07
3064	8	32	2025-11-19 11:15:07
3065	9	0.2932551319648127	2025-11-19 11:15:07
3066	10	6	2025-11-19 11:15:07
3067	7	27.1	2025-11-19 11:15:21
3068	8	32	2025-11-19 11:15:21
3069	9	0.19550342130987985	2025-11-19 11:15:21
3070	10	6	2025-11-19 11:15:21
3071	7	27.1	2025-11-19 11:15:36
3072	8	32	2025-11-19 11:15:36
3073	9	0.2932551319648127	2025-11-19 11:15:36
3074	10	6	2025-11-19 11:15:36
3075	7	27.1	2025-11-19 11:15:51
3076	8	32	2025-11-19 11:15:51
3077	9	0.19550342130987985	2025-11-19 11:15:51
3078	10	6	2025-11-19 11:15:51
3079	7	27.1	2025-11-19 11:16:00
3080	8	32	2025-11-19 11:16:00
3081	9	0.2932551319648127	2025-11-19 11:16:00
3082	10	6	2025-11-19 11:16:00
3083	7	27.1	2025-11-19 11:16:15
3084	8	32	2025-11-19 11:16:15
3085	9	0.19550342130987985	2025-11-19 11:16:15
3086	10	6	2025-11-19 11:16:15
3087	7	27.1	2025-11-19 11:16:24
3088	8	32	2025-11-19 11:16:24
3089	9	0.19550342130987985	2025-11-19 11:16:24
3090	10	6	2025-11-19 11:16:24
3091	7	27.1	2025-11-19 11:16:38
3092	8	32	2025-11-19 11:16:38
3093	9	0.19550342130987985	2025-11-19 11:16:38
3094	10	6	2025-11-19 11:16:38
3095	7	27.1	2025-11-19 11:16:48
3096	8	32	2025-11-19 11:16:48
3097	9	0.2932551319648127	2025-11-19 11:16:48
3098	10	6	2025-11-19 11:16:48
3099	7	27.1	2025-11-19 11:16:57
3100	8	32	2025-11-19 11:16:57
3101	9	0.19550342130987985	2025-11-19 11:16:57
3102	10	6	2025-11-19 11:16:57
3103	7	27.1	2025-11-19 11:17:06
3104	8	32	2025-11-19 11:17:06
3105	9	0.2932551319648127	2025-11-19 11:17:06
3106	10	6	2025-11-19 11:17:06
3107	7	27.1	2025-11-19 11:17:21
3108	8	32	2025-11-19 11:17:21
3109	9	0.19550342130987985	2025-11-19 11:17:21
3110	10	6	2025-11-19 11:17:21
3111	7	27.1	2025-11-19 11:17:31
3112	8	32	2025-11-19 11:17:31
3113	9	0.2932551319648127	2025-11-19 11:17:31
3114	10	6	2025-11-19 11:17:31
3115	7	27.1	2025-11-19 11:17:45
3116	8	32	2025-11-19 11:17:45
3117	9	0.19550342130987985	2025-11-19 11:17:45
3118	10	6	2025-11-19 11:17:45
3119	7	27.1	2025-11-19 11:18:00
3120	8	32	2025-11-19 11:18:00
3121	9	0.2932551319648127	2025-11-19 11:18:00
3122	10	6	2025-11-19 11:18:00
3123	7	27.1	2025-11-19 11:18:15
3124	8	32	2025-11-19 11:18:15
3125	9	0.2932551319648127	2025-11-19 11:18:15
3126	10	6	2025-11-19 11:18:15
3127	7	27.1	2025-11-19 11:18:30
3128	8	32	2025-11-19 11:18:30
3129	9	0.2932551319648127	2025-11-19 11:18:30
3130	10	6	2025-11-19 11:18:30
3131	7	27.1	2025-11-19 11:18:39
3132	8	32	2025-11-19 11:18:39
3133	9	0.2932551319648127	2025-11-19 11:18:39
3134	10	6	2025-11-19 11:18:39
3135	7	27.1	2025-11-19 11:18:48
3136	8	32	2025-11-19 11:18:48
3137	9	0.2932551319648127	2025-11-19 11:18:48
3138	10	6	2025-11-19 11:18:48
3139	7	27.1	2025-11-19 11:18:57
3140	8	32	2025-11-19 11:18:57
3141	9	0.19550342130987985	2025-11-19 11:18:57
3142	10	6	2025-11-19 11:18:57
3143	7	27.1	2025-11-19 11:19:06
3144	8	32	2025-11-19 11:19:06
3145	9	0.2932551319648127	2025-11-19 11:19:06
3146	10	6	2025-11-19 11:19:06
3147	7	27.1	2025-11-19 11:19:15
3148	8	32	2025-11-19 11:19:15
3149	9	0.2932551319648127	2025-11-19 11:19:15
3150	10	6	2025-11-19 11:19:15
3151	7	27.1	2025-11-19 11:19:29
3152	8	32	2025-11-19 11:19:29
3153	9	0.2932551319648127	2025-11-19 11:19:29
3154	10	6	2025-11-19 11:19:29
3155	7	27.1	2025-11-19 11:19:39
3156	8	32	2025-11-19 11:19:39
3157	9	0.19550342130987985	2025-11-19 11:19:39
3158	10	6	2025-11-19 11:19:39
3159	7	27.1	2025-11-19 11:19:54
3160	8	32	2025-11-19 11:19:54
3161	9	0.2932551319648127	2025-11-19 11:19:54
3162	10	6	2025-11-19 11:19:54
3163	7	27.1	2025-11-19 11:20:03
3164	8	32	2025-11-19 11:20:03
3165	9	0.2932551319648127	2025-11-19 11:20:03
3166	10	6	2025-11-19 11:20:03
3167	7	26.7	2025-11-19 11:20:12
3168	8	33	2025-11-19 11:20:12
3169	9	4.692082111436946	2025-11-19 11:20:12
3170	10	6	2025-11-19 11:20:12
3171	7	26.7	2025-11-19 11:20:21
3172	8	33	2025-11-19 11:20:21
3173	9	3.4213098729227767	2025-11-19 11:20:21
3174	10	6	2025-11-19 11:20:21
3175	7	26.7	2025-11-19 11:20:36
3176	8	33	2025-11-19 11:20:36
3177	9	4.594330400782013	2025-11-19 11:20:36
3178	10	6	2025-11-19 11:20:36
3179	7	26.7	2025-11-19 11:20:46
3180	8	33	2025-11-19 11:20:46
3181	9	3.4213098729227767	2025-11-19 11:20:46
3182	10	6	2025-11-19 11:20:46
3183	7	26.7	2025-11-19 11:21:00
3184	8	33	2025-11-19 11:21:00
3185	9	4.594330400782013	2025-11-19 11:21:00
3186	10	6	2025-11-19 11:21:00
3187	7	26.7	2025-11-19 11:21:15
3188	8	33	2025-11-19 11:21:15
3189	9	3.4213098729227767	2025-11-19 11:21:15
3190	10	6	2025-11-19 11:21:15
3191	7	26.7	2025-11-19 11:21:30
3192	8	33	2025-11-19 11:21:30
3193	9	4.887585532746826	2025-11-19 11:21:30
3194	10	6	2025-11-19 11:21:30
3195	7	26.7	2025-11-19 11:21:39
3196	8	33	2025-11-19 11:21:39
3197	9	3.7145650048875893	2025-11-19 11:21:39
3198	10	6	2025-11-19 11:21:39
3199	7	26.7	2025-11-19 11:21:48
3200	8	33	2025-11-19 11:21:48
3201	9	5.0830889540566915	2025-11-19 11:21:48
3202	10	5	2025-11-19 11:21:48
3203	7	26.7	2025-11-19 11:22:02
3204	8	33	2025-11-19 11:22:02
3205	9	3.6168132942326423	2025-11-19 11:22:02
3206	10	6	2025-11-19 11:22:02
3207	7	26.7	2025-11-19 11:22:16
3208	8	33	2025-11-19 11:22:16
3209	9	5.0830889540566915	2025-11-19 11:22:16
3210	10	6	2025-11-19 11:22:16
3211	7	26.7	2025-11-19 11:22:31
3212	8	33	2025-11-19 11:22:31
3213	9	3.7145650048875893	2025-11-19 11:22:31
3214	10	6	2025-11-19 11:22:31
3215	7	26.7	2025-11-19 11:22:46
3216	8	33	2025-11-19 11:22:46
3217	9	4.985337243401759	2025-11-19 11:22:46
3218	10	6	2025-11-19 11:22:46
3219	7	26.7	2025-11-19 11:23:01
3220	8	33	2025-11-19 11:23:01
3221	9	3.7145650048875893	2025-11-19 11:23:01
3222	10	6	2025-11-19 11:23:01
3223	7	26.7	2025-11-19 11:23:14
3224	8	33	2025-11-19 11:23:14
3225	9	5.0830889540566915	2025-11-19 11:23:14
3226	10	6	2025-11-19 11:23:14
3227	7	26.7	2025-11-19 11:23:28
3228	8	33	2025-11-19 11:23:28
3229	9	4.105571847507335	2025-11-19 11:23:28
3230	10	6	2025-11-19 11:23:28
3231	7	26.7	2025-11-19 11:23:42
3232	8	33	2025-11-19 11:23:42
3233	9	5.474095796676437	2025-11-19 11:23:42
3234	10	5	2025-11-19 11:23:42
3235	7	26.7	2025-11-19 11:23:50
3236	8	33	2025-11-19 11:23:50
3237	9	1.7595307917888618	2025-11-19 11:23:50
3238	10	6	2025-11-19 11:23:50
3239	7	26.7	2025-11-19 11:24:04
3240	8	33	2025-11-19 11:24:04
3241	9	2.443792766373406	2025-11-19 11:24:04
3242	10	6	2025-11-19 11:24:04
3243	7	26.7	2025-11-19 11:24:19
3244	8	33	2025-11-19 11:24:19
3245	9	1.8572825024437947	2025-11-19 11:24:19
3246	10	6	2025-11-19 11:24:19
3247	7	26.7	2025-11-19 11:24:33
3248	8	33	2025-11-19 11:24:33
3249	9	2.541544477028353	2025-11-19 11:24:33
3250	10	6	2025-11-19 11:24:33
3251	7	26.7	2025-11-19 11:24:42
3252	8	33	2025-11-19 11:24:42
3253	9	1.9550342130987275	2025-11-19 11:24:42
3254	10	6	2025-11-19 11:24:42
3255	7	26.7	2025-11-19 11:24:51
3256	8	33	2025-11-19 11:24:51
3257	9	2.6392961876832857	2025-11-19 11:24:51
3258	10	6	2025-11-19 11:24:51
3259	7	26.7	2025-11-19 11:25:00
3260	8	33	2025-11-19 11:25:00
3261	9	2.24828934506354	2025-11-19 11:25:00
3262	10	6	2025-11-19 11:25:00
3263	7	26.7	2025-11-19 11:25:09
3264	8	33	2025-11-19 11:25:09
3265	9	3.030303030303031	2025-11-19 11:25:09
3266	10	6	2025-11-19 11:25:09
3267	7	26.7	2025-11-19 11:25:24
3268	8	33	2025-11-19 11:25:24
3269	9	2.8347996089931513	2025-11-19 11:25:24
3270	10	6	2025-11-19 11:25:24
3271	7	26.7	2025-11-19 11:25:33
3272	8	33	2025-11-19 11:25:33
3273	9	4.203323558162268	2025-11-19 11:25:33
3274	10	6	2025-11-19 11:25:33
3275	7	26.7	2025-11-19 11:25:47
3276	8	33	2025-11-19 11:25:47
3277	9	4.3010752688172005	2025-11-19 11:25:47
3278	10	6	2025-11-19 11:25:47
3279	7	26.7	2025-11-19 11:25:57
3280	8	33	2025-11-19 11:25:57
3281	9	6.451612903225808	2025-11-19 11:25:57
3282	10	5	2025-11-19 11:25:57
3283	7	26.7	2025-11-19 11:26:07
3284	8	33	2025-11-19 11:26:07
3285	9	3.225806451612897	2025-11-19 11:26:07
3286	10	6	2025-11-19 11:26:07
3287	7	26.7	2025-11-19 11:26:21
3288	8	33	2025-11-19 11:26:21
3289	9	4.887585532746826	2025-11-19 11:26:21
3290	10	6	2025-11-19 11:26:21
3291	7	26.7	2025-11-19 11:26:30
3292	8	33	2025-11-19 11:26:30
3293	9	5.1808406647116385	2025-11-19 11:26:30
3294	10	5	2025-11-19 11:26:30
3295	7	26.7	2025-11-19 11:26:39
3296	8	33	2025-11-19 11:26:39
3297	9	5.9628543499511295	2025-11-19 11:26:39
3298	10	5	2025-11-19 11:26:39
3299	7	26.7	2025-11-19 11:26:54
3300	8	33	2025-11-19 11:26:54
3301	9	5.278592375366571	2025-11-19 11:26:54
3302	10	5	2025-11-19 11:26:54
3303	7	26	2025-11-19 11:27:03
3304	9	91.00684261974584	2025-11-19 11:27:16
3305	10	0	2025-11-19 11:27:16
3306	9	91.00684261974584	2025-11-19 11:27:31
3307	10	0	2025-11-19 11:27:31
3308	9	91.00684261974584	2025-11-19 11:27:45
3309	10	0	2025-11-19 11:27:45
3310	9	91.00684261974584	2025-11-19 11:27:55
3311	10	0	2025-11-19 11:27:55
3312	9	91.00684261974584	2025-11-19 11:28:09
3313	10	0	2025-11-19 11:28:09
3314	9	91.00684261974584	2025-11-19 11:28:23
3315	10	0	2025-11-19 11:28:23
3316	9	91.00684261974584	2025-11-19 11:28:33
3317	10	0	2025-11-19 11:28:33
3318	9	91.00684261974584	2025-11-19 11:28:48
3319	10	0	2025-11-19 11:28:48
3320	9	91.00684261974584	2025-11-19 11:29:03
3321	10	0	2025-11-19 11:29:03
3322	9	91.00684261974584	2025-11-19 11:29:17
3323	10	0	2025-11-19 11:29:17
3324	9	91.00684261974584	2025-11-19 11:29:31
3325	10	0	2025-11-19 11:29:31
3326	9	91.00684261974584	2025-11-19 11:29:46
3327	10	0	2025-11-19 11:29:46
3328	9	91.00684261974584	2025-11-19 11:30:02
3329	10	0	2025-11-19 11:30:02
3330	9	91.00684261974584	2025-11-19 11:30:16
3331	10	0	2025-11-19 11:30:16
3332	9	91.00684261974584	2025-11-19 11:30:29
3333	10	0	2025-11-19 11:30:29
3334	9	91.00684261974584	2025-11-19 11:30:39
3335	10	0	2025-11-19 11:30:39
3336	9	91.00684261974584	2025-11-19 11:30:48
3337	10	0	2025-11-19 11:30:48
3338	9	91.00684261974584	2025-11-19 11:30:58
3339	10	0	2025-11-19 11:30:58
3340	9	91.00684261974584	2025-11-19 11:31:12
3341	10	0	2025-11-19 11:31:12
3342	9	91.00684261974584	2025-11-19 11:31:21
3343	10	0	2025-11-19 11:31:21
3344	9	91.00684261974584	2025-11-19 11:31:30
3345	10	0	2025-11-19 11:31:30
3346	9	91.00684261974584	2025-11-19 11:31:39
3347	10	0	2025-11-19 11:31:39
3348	9	91.00684261974584	2025-11-19 11:31:49
3349	10	0	2025-11-19 11:31:49
3350	9	91.00684261974584	2025-11-19 11:32:03
3351	10	0	2025-11-19 11:32:03
3352	9	91.00684261974584	2025-11-19 11:32:12
3353	10	0	2025-11-19 11:32:12
3354	9	91.00684261974584	2025-11-19 11:32:27
3355	10	0	2025-11-19 11:32:27
3356	9	91.00684261974584	2025-11-19 11:32:42
3357	10	0	2025-11-19 11:32:42
3358	9	91.00684261974584	2025-11-19 11:32:51
3359	10	0	2025-11-19 11:32:51
3360	9	91.00684261974584	2025-11-19 11:33:06
3361	10	0	2025-11-19 11:33:06
3362	9	91.00684261974584	2025-11-19 11:33:15
3363	10	0	2025-11-19 11:33:15
3364	9	91.00684261974584	2025-11-19 11:33:29
3365	10	0	2025-11-19 11:33:29
3366	9	91.00684261974584	2025-11-19 11:33:39
3367	10	0	2025-11-19 11:33:39
3368	9	91.00684261974584	2025-11-19 11:33:48
3369	10	0	2025-11-19 11:33:48
3370	9	91.00684261974584	2025-11-19 11:33:56
3371	10	0	2025-11-19 11:33:56
3372	9	91.00684261974584	2025-11-19 11:34:11
3373	10	0	2025-11-19 11:34:11
3374	9	91.00684261974584	2025-11-19 11:34:25
3375	10	0	2025-11-19 11:34:25
3376	9	91.00684261974584	2025-11-19 11:34:40
3377	10	0	2025-11-19 11:34:40
3378	9	91.00684261974584	2025-11-19 11:34:54
3379	10	0	2025-11-19 11:34:54
3380	9	91.00684261974584	2025-11-19 11:35:03
3381	10	0	2025-11-19 11:35:03
3382	9	91.00684261974584	2025-11-19 11:35:13
3383	10	0	2025-11-19 11:35:13
3384	9	91.00684261974584	2025-11-19 11:35:27
3385	10	0	2025-11-19 11:35:27
3386	9	91.00684261974584	2025-11-19 11:35:42
3387	10	0	2025-11-19 11:35:42
3388	9	91.00684261974584	2025-11-19 11:35:57
3389	10	0	2025-11-19 11:35:57
3390	9	91.00684261974584	2025-11-19 11:36:12
3391	10	0	2025-11-19 11:36:12
3392	9	91.00684261974584	2025-11-19 11:36:21
3393	10	0	2025-11-19 11:36:21
3394	9	91.00684261974584	2025-11-19 11:36:31
3395	10	0	2025-11-19 11:36:31
3396	9	91.00684261974584	2025-11-19 11:36:45
3397	10	0	2025-11-19 11:36:45
3398	9	91.00684261974584	2025-11-19 11:36:59
3399	10	0	2025-11-19 11:36:59
3400	9	91.00684261974584	2025-11-19 11:37:13
3401	10	0	2025-11-19 11:37:13
3402	9	91.00684261974584	2025-11-19 11:37:28
3403	10	0	2025-11-19 11:37:28
3404	9	91.00684261974584	2025-11-19 11:37:42
3405	10	0	2025-11-19 11:37:42
3406	9	91.00684261974584	2025-11-19 11:37:56
3407	10	0	2025-11-19 11:37:56
3408	9	91.00684261974584	2025-11-19 11:38:10
3409	10	0	2025-11-19 11:38:10
3410	9	91.00684261974584	2025-11-19 11:38:25
3411	10	0	2025-11-19 11:38:25
3412	9	91.00684261974584	2025-11-19 11:38:39
3413	10	0	2025-11-19 11:38:39
3414	9	91.00684261974584	2025-11-19 11:38:48
3415	10	0	2025-11-19 11:38:48
3416	9	91.00684261974584	2025-11-19 11:38:58
3417	10	0	2025-11-19 11:38:58
3418	9	90.9090909090909	2025-11-19 11:39:12
3419	10	0	2025-11-19 11:39:12
3420	9	91.00684261974584	2025-11-19 11:39:26
3421	10	0	2025-11-19 11:39:26
3422	9	91.00684261974584	2025-11-19 11:39:36
3423	10	0	2025-11-19 11:39:36
3424	9	91.00684261974584	2025-11-19 11:39:51
3425	10	0	2025-11-19 11:39:51
3426	9	91.00684261974584	2025-11-19 11:40:00
3427	10	0	2025-11-19 11:40:00
3428	9	90.9090909090909	2025-11-19 11:40:14
3429	10	0	2025-11-19 11:40:14
3430	9	90.9090909090909	2025-11-19 11:40:29
3431	10	0	2025-11-19 11:40:29
3432	9	91.00684261974584	2025-11-19 11:40:43
3433	10	0	2025-11-19 11:40:43
3434	9	90.9090909090909	2025-11-19 11:40:57
3435	10	0	2025-11-19 11:40:57
3436	9	91.00684261974584	2025-11-19 11:41:11
3437	10	0	2025-11-19 11:41:11
3438	9	91.00684261974584	2025-11-19 11:41:21
3439	10	0	2025-11-19 11:41:21
3440	9	91.00684261974584	2025-11-19 11:41:31
3441	10	0	2025-11-19 11:41:31
3442	9	91.00684261974584	2025-11-19 11:41:45
3443	10	0	2025-11-19 11:41:45
3444	9	91.00684261974584	2025-11-19 11:42:00
3445	10	0	2025-11-19 11:42:00
3446	9	91.00684261974584	2025-11-19 11:42:13
3447	10	0	2025-11-19 11:42:13
3448	9	91.00684261974584	2025-11-19 11:42:28
3449	10	0	2025-11-19 11:42:28
3450	9	91.00684261974584	2025-11-19 11:42:43
3451	10	0	2025-11-19 11:42:43
3452	9	91.00684261974584	2025-11-19 11:42:58
3453	10	0	2025-11-19 11:42:58
3454	9	91.00684261974584	2025-11-19 11:43:13
3455	10	0	2025-11-19 11:43:13
3456	9	91.00684261974584	2025-11-19 11:43:29
3457	10	0	2025-11-19 11:43:29
3458	9	90.9090909090909	2025-11-19 11:43:42
3459	10	0	2025-11-19 11:43:42
3460	9	90.9090909090909	2025-11-19 11:43:57
3461	10	0	2025-11-19 11:43:57
3462	9	91.00684261974584	2025-11-19 11:44:06
3463	10	0	2025-11-19 11:44:06
3464	9	91.00684261974584	2025-11-19 11:44:15
3465	10	0	2025-11-19 11:44:15
3466	9	91.00684261974584	2025-11-19 11:44:25
3467	10	0	2025-11-19 11:44:25
3468	9	91.00684261974584	2025-11-19 11:44:39
3469	10	0	2025-11-19 11:44:39
3470	9	91.00684261974584	2025-11-19 11:44:48
3471	10	0	2025-11-19 11:44:48
3472	9	90.9090909090909	2025-11-19 11:44:57
3473	10	0	2025-11-19 11:44:57
3474	9	91.00684261974584	2025-11-19 11:45:06
3475	10	0	2025-11-19 11:45:06
3476	9	91.00684261974584	2025-11-19 11:45:15
3477	10	0	2025-11-19 11:45:15
3478	9	91.00684261974584	2025-11-19 11:45:24
3479	10	0	2025-11-19 11:45:24
3480	9	91.00684261974584	2025-11-19 11:45:33
3481	10	0	2025-11-19 11:45:33
3482	9	91.00684261974584	2025-11-19 11:45:48
3483	10	0	2025-11-19 11:45:48
3484	9	91.00684261974584	2025-11-19 11:45:57
3485	10	0	2025-11-19 11:45:57
3486	9	91.00684261974584	2025-11-19 11:46:06
3487	10	0	2025-11-19 11:46:06
3488	9	91.00684261974584	2025-11-19 11:46:21
3489	10	0	2025-11-19 11:46:21
3490	9	91.00684261974584	2025-11-19 11:46:31
3491	10	0	2025-11-19 11:46:31
3492	9	91.00684261974584	2025-11-19 11:46:45
3493	10	0	2025-11-19 11:46:45
3494	9	91.00684261974584	2025-11-19 11:47:00
3495	10	0	2025-11-19 11:47:00
3496	9	91.00684261974584	2025-11-19 11:47:09
3497	10	0	2025-11-19 11:47:09
3498	9	91.00684261974584	2025-11-19 11:47:18
3499	10	0	2025-11-19 11:47:18
3500	9	91.00684261974584	2025-11-19 11:47:28
3501	10	0	2025-11-19 11:47:28
3502	9	91.00684261974584	2025-11-19 11:47:42
3503	10	0	2025-11-19 11:47:42
3504	9	91.00684261974584	2025-11-19 11:47:57
3505	10	0	2025-11-19 11:47:57
3506	9	91.00684261974584	2025-11-19 11:48:06
3507	10	0	2025-11-19 11:48:06
3508	9	91.00684261974584	2025-11-19 11:48:21
3509	10	0	2025-11-19 11:48:21
3510	9	91.00684261974584	2025-11-19 11:48:30
3511	10	0	2025-11-19 11:48:30
3512	9	91.00684261974584	2025-11-19 11:48:45
3513	10	0	2025-11-19 11:48:45
3514	9	91.00684261974584	2025-11-19 11:48:54
3515	10	0	2025-11-19 11:48:54
3516	9	91.00684261974584	2025-11-19 11:49:07
3517	10	0	2025-11-19 11:49:07
3518	9	90.9090909090909	2025-11-19 11:49:22
3519	10	0	2025-11-19 11:49:22
3520	9	91.00684261974584	2025-11-19 11:49:36
3521	10	0	2025-11-19 11:49:36
3522	9	91.00684261974584	2025-11-19 11:49:50
3523	10	0	2025-11-19 11:49:50
3524	9	91.00684261974584	2025-11-19 11:50:00
3525	10	0	2025-11-19 11:50:00
3526	9	91.00684261974584	2025-11-19 11:50:09
3527	10	0	2025-11-19 11:50:09
3528	9	91.00684261974584	2025-11-19 11:50:18
3529	10	0	2025-11-19 11:50:18
3530	9	90.9090909090909	2025-11-19 11:50:32
3531	10	0	2025-11-19 11:50:32
3532	9	90.9090909090909	2025-11-19 11:50:42
3533	10	0	2025-11-19 11:50:42
3534	9	91.00684261974584	2025-11-19 11:50:51
3535	10	0	2025-11-19 11:50:51
3536	9	91.00684261974584	2025-11-19 11:51:06
3537	10	0	2025-11-19 11:51:06
3538	9	91.00684261974584	2025-11-19 11:51:15
3539	10	0	2025-11-19 11:51:15
3540	9	91.00684261974584	2025-11-19 11:51:29
3541	10	0	2025-11-19 11:51:29
3542	9	91.00684261974584	2025-11-19 11:51:39
3543	10	0	2025-11-19 11:51:39
3544	9	91.00684261974584	2025-11-19 11:51:48
3545	10	0	2025-11-19 11:51:48
3546	9	91.00684261974584	2025-11-19 11:52:03
3547	10	0	2025-11-19 11:52:03
3548	9	91.00684261974584	2025-11-19 11:52:13
3549	10	0	2025-11-19 11:52:13
3550	9	91.00684261974584	2025-11-19 11:52:28
3551	10	0	2025-11-19 11:52:28
3552	9	91.00684261974584	2025-11-19 11:52:42
3553	10	0	2025-11-19 11:52:42
3554	9	91.00684261974584	2025-11-19 11:52:57
3555	10	0	2025-11-19 11:52:57
3556	9	91.00684261974584	2025-11-19 11:53:12
3557	10	0	2025-11-19 11:53:12
3558	9	91.00684261974584	2025-11-19 11:53:21
3559	10	0	2025-11-19 11:53:21
3560	9	91.00684261974584	2025-11-19 11:53:35
3561	10	0	2025-11-19 11:53:35
3562	9	91.00684261974584	2025-11-19 11:53:45
3563	10	0	2025-11-19 11:53:45
3564	9	91.00684261974584	2025-11-19 11:53:54
3565	10	0	2025-11-19 11:53:54
3566	9	91.00684261974584	2025-11-19 11:54:03
3567	10	0	2025-11-19 11:54:03
3568	9	91.00684261974584	2025-11-19 11:54:12
3569	10	0	2025-11-19 11:54:12
3570	9	91.00684261974584	2025-11-19 11:54:27
3571	10	0	2025-11-19 11:54:27
3572	9	91.00684261974584	2025-11-19 11:54:42
3573	10	0	2025-11-19 11:54:42
3574	9	91.00684261974584	2025-11-19 11:54:51
3575	10	0	2025-11-19 11:54:51
3576	9	91.00684261974584	2025-11-19 11:55:00
3577	10	0	2025-11-19 11:55:00
3578	9	91.00684261974584	2025-11-19 11:55:14
3579	10	0	2025-11-19 11:55:14
3580	9	91.00684261974584	2025-11-19 11:55:28
3581	10	0	2025-11-19 11:55:28
3582	9	91.00684261974584	2025-11-19 11:55:43
3583	10	0	2025-11-19 11:55:43
3584	9	91.00684261974584	2025-11-19 11:55:56
3585	10	0	2025-11-19 11:55:56
3586	9	91.00684261974584	2025-11-19 11:56:06
3587	10	0	2025-11-19 11:56:06
3588	9	91.00684261974584	2025-11-19 11:56:15
3589	10	0	2025-11-19 11:56:15
3590	9	91.00684261974584	2025-11-19 11:56:23
3591	10	0	2025-11-19 11:56:23
3592	9	91.00684261974584	2025-11-19 11:56:38
3593	10	0	2025-11-19 11:56:38
3594	9	91.00684261974584	2025-11-19 11:56:52
3595	10	0	2025-11-19 11:56:52
3596	9	91.00684261974584	2025-11-19 11:57:06
3597	10	0	2025-11-19 11:57:06
3598	9	91.00684261974584	2025-11-19 11:57:15
3599	10	0	2025-11-19 11:57:15
3600	9	91.00684261974584	2025-11-19 11:57:24
3601	10	0	2025-11-19 11:57:24
3602	9	91.00684261974584	2025-11-19 11:57:39
3603	10	0	2025-11-19 11:57:39
3604	9	91.00684261974584	2025-11-19 11:57:49
3605	10	0	2025-11-19 11:57:49
3606	9	91.00684261974584	2025-11-19 11:58:04
3607	10	0	2025-11-19 11:58:04
3608	9	91.00684261974584	2025-11-19 11:58:18
3609	10	0	2025-11-19 11:58:18
3610	9	91.00684261974584	2025-11-19 11:58:27
3611	10	0	2025-11-19 11:58:27
3612	9	91.00684261974584	2025-11-19 11:58:42
3613	10	0	2025-11-19 11:58:42
3614	9	91.00684261974584	2025-11-19 11:58:51
3615	10	0	2025-11-19 11:58:51
3616	9	91.00684261974584	2025-11-19 11:59:01
3617	10	0	2025-11-19 11:59:01
3618	9	91.00684261974584	2025-11-19 11:59:16
3619	10	0	2025-11-19 11:59:16
3620	9	91.00684261974584	2025-11-19 11:59:30
3621	10	0	2025-11-19 11:59:30
3622	9	91.00684261974584	2025-11-19 11:59:39
3623	10	0	2025-11-19 11:59:39
3624	9	91.00684261974584	2025-11-19 11:59:49
3625	10	0	2025-11-19 11:59:49
3626	9	91.00684261974584	2025-11-19 12:00:04
3627	10	0	2025-11-19 12:00:04
3628	9	91.00684261974584	2025-11-19 12:00:19
3629	10	0	2025-11-19 12:00:19
3630	9	91.00684261974584	2025-11-19 12:00:33
3631	10	0	2025-11-19 12:00:33
3632	9	91.00684261974584	2025-11-19 12:00:48
3633	10	0	2025-11-19 12:00:48
3634	9	91.00684261974584	2025-11-19 12:01:03
3635	10	0	2025-11-19 12:01:03
3636	9	91.00684261974584	2025-11-19 12:01:12
3637	10	0	2025-11-19 12:01:12
3638	9	91.00684261974584	2025-11-19 12:01:27
3639	10	0	2025-11-19 12:01:27
3640	9	91.00684261974584	2025-11-19 12:01:42
3641	10	0	2025-11-19 12:01:42
3642	9	91.00684261974584	2025-11-19 12:01:53
3643	10	0	2025-11-19 12:01:53
3644	9	91.00684261974584	2025-11-19 12:02:07
3645	10	0	2025-11-19 12:02:07
3646	9	91.00684261974584	2025-11-19 12:02:22
3647	10	0	2025-11-19 12:02:22
3648	9	91.00684261974584	2025-11-19 12:02:36
3649	10	0	2025-11-19 12:02:36
3650	9	91.00684261974584	2025-11-19 12:02:51
3651	10	0	2025-11-19 12:02:51
3652	9	91.00684261974584	2025-11-19 12:03:00
3653	10	0	2025-11-19 12:03:00
3654	9	91.00684261974584	2025-11-19 12:03:15
3655	10	0	2025-11-19 12:03:15
3656	9	91.00684261974584	2025-11-19 12:03:24
3657	10	0	2025-11-19 12:03:24
3658	9	91.00684261974584	2025-11-19 12:03:33
3659	10	0	2025-11-19 12:03:33
3660	9	91.00684261974584	2025-11-19 12:03:43
3661	10	0	2025-11-19 12:03:43
3662	9	91.00684261974584	2025-11-19 12:03:57
3663	10	0	2025-11-19 12:03:57
3664	9	91.00684261974584	2025-11-19 12:04:12
3665	10	0	2025-11-19 12:04:12
3666	9	91.00684261974584	2025-11-19 12:04:22
3667	10	0	2025-11-19 12:04:22
3668	9	91.00684261974584	2025-11-19 12:04:37
3669	10	0	2025-11-19 12:04:37
3670	9	91.00684261974584	2025-11-19 12:04:51
3671	10	0	2025-11-19 12:04:51
3672	9	91.00684261974584	2025-11-19 12:05:06
3673	10	0	2025-11-19 12:05:06
3674	9	91.00684261974584	2025-11-19 12:05:16
3675	10	0	2025-11-19 12:05:16
3676	9	91.00684261974584	2025-11-19 12:05:30
3677	10	0	2025-11-19 12:05:30
3678	9	91.00684261974584	2025-11-19 12:05:45
3679	10	0	2025-11-19 12:05:45
3680	9	91.00684261974584	2025-11-19 12:05:54
3681	10	0	2025-11-19 12:05:54
3682	9	91.00684261974584	2025-11-19 12:06:03
3683	10	0	2025-11-19 12:06:03
3684	9	91.00684261974584	2025-11-19 12:06:18
3685	10	0	2025-11-19 12:06:18
3686	9	91.00684261974584	2025-11-19 12:06:27
3687	10	0	2025-11-19 12:06:27
3688	9	91.00684261974584	2025-11-19 12:06:41
3689	10	0	2025-11-19 12:06:41
3690	9	91.00684261974584	2025-11-19 12:06:55
3691	10	0	2025-11-19 12:06:55
3692	9	91.00684261974584	2025-11-19 12:07:10
3693	10	0	2025-11-19 12:07:10
3694	9	91.00684261974584	2025-11-19 12:07:26
3695	10	0	2025-11-19 12:07:26
3696	9	91.00684261974584	2025-11-19 12:07:40
3697	10	0	2025-11-19 12:07:40
3698	9	90.9090909090909	2025-11-19 12:07:54
3699	10	0	2025-11-19 12:07:54
3700	9	91.00684261974584	2025-11-19 12:08:09
3701	10	0	2025-11-19 12:08:09
3702	9	91.00684261974584	2025-11-19 12:08:20
3703	10	0	2025-11-19 12:08:20
3704	9	91.00684261974584	2025-11-19 12:08:34
3705	10	0	2025-11-19 12:08:34
3706	9	91.00684261974584	2025-11-19 12:08:49
3707	10	0	2025-11-19 12:08:49
3708	9	91.00684261974584	2025-11-19 12:09:03
3709	10	0	2025-11-19 12:09:03
3710	9	91.00684261974584	2025-11-19 12:09:13
3711	10	0	2025-11-19 12:09:13
3712	9	91.00684261974584	2025-11-19 12:09:27
3713	10	0	2025-11-19 12:09:27
3714	9	91.00684261974584	2025-11-19 12:09:46
3715	10	0	2025-11-19 12:09:46
3716	9	91.00684261974584	2025-11-19 12:10:01
3717	10	0	2025-11-19 12:10:01
3718	9	91.00684261974584	2025-11-19 12:10:10
3719	10	0	2025-11-19 12:10:10
3720	9	91.00684261974584	2025-11-19 12:10:24
3721	10	0	2025-11-19 12:10:24
3722	9	91.00684261974584	2025-11-19 12:10:39
3723	10	0	2025-11-19 12:10:39
3724	9	91.00684261974584	2025-11-19 12:10:48
3725	10	0	2025-11-19 12:10:48
3726	9	91.00684261974584	2025-11-19 12:10:57
3727	10	0	2025-11-19 12:10:57
3728	9	91.00684261974584	2025-11-19 12:11:12
3729	10	0	2025-11-19 12:11:12
3730	9	91.00684261974584	2025-11-19 12:11:27
3731	10	0	2025-11-19 12:11:27
3732	9	91.00684261974584	2025-11-19 12:11:36
3733	10	0	2025-11-19 12:11:36
3734	9	91.00684261974584	2025-11-19 12:11:46
3735	10	0	2025-11-19 12:11:46
3736	9	91.00684261974584	2025-11-19 12:12:00
3737	10	0	2025-11-19 12:12:00
3738	9	91.00684261974584	2025-11-19 12:12:09
3739	10	0	2025-11-19 12:12:09
3740	9	91.00684261974584	2025-11-19 12:12:24
3741	10	0	2025-11-19 12:12:24
3742	9	91.00684261974584	2025-11-19 12:12:39
3743	10	0	2025-11-19 12:12:39
3744	9	91.00684261974584	2025-11-19 12:12:48
3745	10	0	2025-11-19 12:12:48
3746	9	91.00684261974584	2025-11-19 12:13:03
3747	10	0	2025-11-19 12:13:03
3748	9	91.00684261974584	2025-11-19 12:13:18
3749	10	0	2025-11-19 12:13:18
3750	9	91.00684261974584	2025-11-19 12:13:33
3751	10	0	2025-11-19 12:13:33
3752	9	91.00684261974584	2025-11-19 12:13:42
3753	10	0	2025-11-19 12:13:42
3754	9	91.00684261974584	2025-11-19 12:13:52
3755	10	0	2025-11-19 12:13:52
3756	9	91.00684261974584	2025-11-19 12:14:06
3757	10	0	2025-11-19 12:14:06
3758	9	91.00684261974584	2025-11-19 12:14:15
3759	10	0	2025-11-19 12:14:15
3760	9	91.00684261974584	2025-11-19 12:14:24
3761	10	0	2025-11-19 12:14:24
3762	9	91.00684261974584	2025-11-19 12:14:39
3763	10	0	2025-11-19 12:14:39
3764	9	91.00684261974584	2025-11-19 12:14:54
3765	10	0	2025-11-19 12:14:54
3766	9	91.00684261974584	2025-11-19 12:15:02
3767	10	0	2025-11-19 12:15:02
3768	9	91.00684261974584	2025-11-19 12:15:16
3769	10	0	2025-11-19 12:15:16
3770	9	91.00684261974584	2025-11-19 12:15:30
3771	10	0	2025-11-19 12:15:30
3772	9	91.00684261974584	2025-11-19 12:15:45
3773	10	0	2025-11-19 12:15:45
3774	9	91.00684261974584	2025-11-19 12:15:54
3775	10	0	2025-11-19 12:15:54
3776	9	91.00684261974584	2025-11-19 12:16:03
3777	10	0	2025-11-19 12:16:03
3778	9	91.00684261974584	2025-11-19 12:16:13
3779	10	0	2025-11-19 12:16:13
3780	9	91.00684261974584	2025-11-19 12:16:27
3781	10	0	2025-11-19 12:16:27
3782	9	91.00684261974584	2025-11-19 12:16:42
3783	10	0	2025-11-19 12:16:42
3784	9	91.00684261974584	2025-11-19 12:16:51
3785	10	0	2025-11-19 12:16:51
3786	9	91.00684261974584	2025-11-19 12:17:00
3787	10	0	2025-11-19 12:17:00
3788	9	91.00684261974584	2025-11-19 12:17:15
3789	10	0	2025-11-19 12:17:15
3790	9	91.00684261974584	2025-11-19 12:17:24
3791	10	0	2025-11-19 12:17:24
3792	9	91.00684261974584	2025-11-19 12:17:33
3793	10	0	2025-11-19 12:17:33
3794	9	91.00684261974584	2025-11-19 12:17:48
3795	10	0	2025-11-19 12:17:48
3796	9	91.00684261974584	2025-11-19 12:17:58
3797	10	0	2025-11-19 12:17:58
3798	9	91.00684261974584	2025-11-19 12:18:12
3799	10	0	2025-11-19 12:18:12
3800	9	91.00684261974584	2025-11-19 12:18:22
3801	10	0	2025-11-19 12:18:22
3802	9	91.00684261974584	2025-11-19 12:18:36
3803	10	0	2025-11-19 12:18:36
3804	9	91.00684261974584	2025-11-19 12:18:46
3805	10	0	2025-11-19 12:18:46
3806	9	91.00684261974584	2025-11-19 12:19:01
3807	10	0	2025-11-19 12:19:01
3808	9	91.00684261974584	2025-11-19 12:19:15
3809	10	0	2025-11-19 12:19:15
3810	9	91.00684261974584	2025-11-19 12:19:30
3811	10	0	2025-11-19 12:19:30
3812	9	91.00684261974584	2025-11-19 12:19:40
3813	10	0	2025-11-19 12:19:40
3814	9	91.00684261974584	2025-11-19 12:19:54
3815	10	0	2025-11-19 12:19:54
3816	9	91.00684261974584	2025-11-19 12:20:03
3817	10	0	2025-11-19 12:20:03
3818	9	91.00684261974584	2025-11-19 12:20:18
3819	10	0	2025-11-19 12:20:18
3820	9	91.00684261974584	2025-11-19 12:20:27
3821	10	0	2025-11-19 12:20:27
3822	9	91.00684261974584	2025-11-19 12:20:36
3823	10	0	2025-11-19 12:20:36
3824	9	91.10459433040079	2025-11-19 12:20:51
3825	10	0	2025-11-19 12:20:51
3826	9	91.00684261974584	2025-11-19 12:21:00
3827	10	0	2025-11-19 12:21:00
3828	9	91.00684261974584	2025-11-19 12:21:09
3829	10	0	2025-11-19 12:21:09
3830	9	91.00684261974584	2025-11-19 12:21:24
3831	10	0	2025-11-19 12:21:24
3832	9	91.00684261974584	2025-11-19 12:21:33
3833	10	0	2025-11-19 12:21:33
3834	9	91.00684261974584	2025-11-19 12:21:42
3835	10	0	2025-11-19 12:21:42
3836	9	91.00684261974584	2025-11-19 12:21:51
3837	10	0	2025-11-19 12:21:51
3838	9	91.00684261974584	2025-11-19 12:22:00
3839	10	0	2025-11-19 12:22:00
3840	9	91.00684261974584	2025-11-19 12:22:10
3841	10	0	2025-11-19 12:22:10
3842	9	91.00684261974584	2025-11-19 12:22:19
3843	10	0	2025-11-19 12:22:19
3844	9	91.00684261974584	2025-11-19 12:22:34
3845	10	0	2025-11-19 12:22:34
3846	9	91.00684261974584	2025-11-19 12:22:48
3847	10	0	2025-11-19 12:22:48
3848	9	91.00684261974584	2025-11-19 12:23:04
3849	10	0	2025-11-19 12:23:04
3850	9	91.00684261974584	2025-11-19 12:23:18
3851	10	0	2025-11-19 12:23:18
3852	9	91.00684261974584	2025-11-19 12:23:27
3853	10	0	2025-11-19 12:23:27
3854	9	91.00684261974584	2025-11-19 12:23:42
3855	10	0	2025-11-19 12:23:42
3856	9	91.00684261974584	2025-11-19 12:23:51
3857	10	0	2025-11-19 12:23:51
3858	9	91.00684261974584	2025-11-19 12:24:00
3859	10	0	2025-11-19 12:24:00
3860	9	91.00684261974584	2025-11-19 12:24:19
3861	10	0	2025-11-19 12:24:19
3862	9	91.00684261974584	2025-11-19 12:24:33
3863	10	0	2025-11-19 12:24:33
3864	9	91.00684261974584	2025-11-19 12:24:42
3865	10	0	2025-11-19 12:24:42
3866	9	91.00684261974584	2025-11-19 12:24:57
3867	10	0	2025-11-19 12:24:57
3868	9	91.00684261974584	2025-11-19 12:25:06
3869	10	0	2025-11-19 12:25:06
3870	9	91.00684261974584	2025-11-19 12:25:15
3871	10	0	2025-11-19 12:25:15
3872	9	91.00684261974584	2025-11-19 12:25:25
3873	10	0	2025-11-19 12:25:25
3874	9	91.00684261974584	2025-11-19 12:25:33
3875	10	0	2025-11-19 12:25:33
3876	9	91.00684261974584	2025-11-19 12:25:48
3877	10	0	2025-11-19 12:25:48
3878	9	91.00684261974584	2025-11-19 12:25:57
3879	10	0	2025-11-19 12:25:57
3880	9	91.00684261974584	2025-11-19 12:26:12
3881	10	0	2025-11-19 12:26:12
3882	9	91.00684261974584	2025-11-19 12:26:27
3883	10	0	2025-11-19 12:26:27
3884	9	91.00684261974584	2025-11-19 12:26:36
3885	10	0	2025-11-19 12:26:36
3886	9	91.00684261974584	2025-11-19 12:26:51
3887	10	0	2025-11-19 12:26:51
3888	9	91.00684261974584	2025-11-19 12:27:05
3889	10	0	2025-11-19 12:27:05
3890	9	91.00684261974584	2025-11-19 12:27:20
3891	10	0	2025-11-19 12:27:20
3892	9	91.00684261974584	2025-11-19 12:27:34
3893	10	0	2025-11-19 12:27:34
3894	9	91.00684261974584	2025-11-19 12:27:49
3895	10	0	2025-11-19 12:27:49
3896	9	91.00684261974584	2025-11-19 12:28:03
3897	10	0	2025-11-19 12:28:03
3898	9	91.00684261974584	2025-11-19 12:28:12
3899	10	0	2025-11-19 12:28:12
3900	9	91.00684261974584	2025-11-19 12:28:27
3901	10	0	2025-11-19 12:28:27
3902	9	91.00684261974584	2025-11-19 12:28:36
3903	10	0	2025-11-19 12:28:36
3904	9	91.00684261974584	2025-11-19 12:28:51
3905	10	0	2025-11-19 12:28:51
3906	9	91.00684261974584	2025-11-19 12:29:00
3907	10	0	2025-11-19 12:29:00
3908	9	91.00684261974584	2025-11-19 12:29:18
3909	10	0	2025-11-19 12:29:18
3910	9	91.00684261974584	2025-11-19 12:29:33
3911	10	0	2025-11-19 12:29:33
3912	9	91.00684261974584	2025-11-19 12:29:43
3913	10	0	2025-11-19 12:29:43
3914	9	91.00684261974584	2025-11-19 12:29:57
3915	10	0	2025-11-19 12:29:57
3916	9	91.00684261974584	2025-11-19 12:30:13
3917	10	0	2025-11-19 12:30:13
3918	9	91.00684261974584	2025-11-19 12:30:28
3919	10	0	2025-11-19 12:30:28
3920	9	91.00684261974584	2025-11-19 12:30:43
3921	10	0	2025-11-19 12:30:43
3922	9	91.00684261974584	2025-11-19 12:30:57
3923	10	0	2025-11-19 12:30:57
3924	9	91.00684261974584	2025-11-19 12:31:06
3925	10	0	2025-11-19 12:31:06
3926	9	91.00684261974584	2025-11-19 12:31:21
3927	10	0	2025-11-19 12:31:21
3928	9	91.00684261974584	2025-11-19 12:31:30
3929	10	0	2025-11-19 12:31:30
3930	9	91.00684261974584	2025-11-19 12:31:39
3931	10	0	2025-11-19 12:31:39
3932	9	91.00684261974584	2025-11-19 12:31:54
3933	10	0	2025-11-19 12:31:54
3934	9	91.00684261974584	2025-11-19 12:32:03
3935	10	0	2025-11-19 12:32:03
3936	9	91.00684261974584	2025-11-19 12:32:18
3937	10	0	2025-11-19 12:32:18
3938	9	91.00684261974584	2025-11-19 12:32:27
3939	10	0	2025-11-19 12:32:27
3940	9	91.00684261974584	2025-11-19 12:32:42
3941	10	0	2025-11-19 12:32:42
3942	9	91.00684261974584	2025-11-19 12:32:52
3943	10	0	2025-11-19 12:32:52
3944	9	91.00684261974584	2025-11-19 12:33:06
3945	10	0	2025-11-19 12:33:06
3946	9	91.00684261974584	2025-11-19 12:33:15
3947	10	0	2025-11-19 12:33:15
3948	9	91.00684261974584	2025-11-19 12:33:24
3949	10	0	2025-11-19 12:33:24
3950	9	91.00684261974584	2025-11-19 12:33:39
3951	10	0	2025-11-19 12:33:39
3952	9	91.00684261974584	2025-11-19 12:33:48
3953	10	0	2025-11-19 12:33:48
3954	9	91.00684261974584	2025-11-19 12:34:03
3955	10	0	2025-11-19 12:34:03
3956	9	91.00684261974584	2025-11-19 12:34:13
3957	10	0	2025-11-19 12:34:13
3958	9	91.00684261974584	2025-11-19 12:34:27
3959	10	0	2025-11-19 12:34:27
3960	9	91.00684261974584	2025-11-19 12:34:36
3961	10	0	2025-11-19 12:34:36
3962	9	91.00684261974584	2025-11-19 12:34:51
3963	10	0	2025-11-19 12:34:51
3964	9	91.00684261974584	2025-11-19 12:35:00
3965	10	0	2025-11-19 12:35:00
3966	9	91.00684261974584	2025-11-19 12:35:10
3967	10	0	2025-11-19 12:35:10
3968	9	91.00684261974584	2025-11-19 12:35:24
3969	10	0	2025-11-19 12:35:24
3970	9	91.00684261974584	2025-11-19 12:35:33
3971	10	0	2025-11-19 12:35:33
3972	9	91.00684261974584	2025-11-19 12:35:43
3973	10	0	2025-11-19 12:35:43
3974	9	91.00684261974584	2025-11-19 12:35:57
3975	10	0	2025-11-19 12:35:57
3976	9	91.00684261974584	2025-11-19 12:36:12
3977	10	0	2025-11-19 12:36:12
3978	9	91.00684261974584	2025-11-19 12:36:20
3979	10	0	2025-11-19 12:36:20
3980	9	91.00684261974584	2025-11-19 12:36:35
3981	10	0	2025-11-19 12:36:35
3982	9	91.00684261974584	2025-11-19 12:36:49
3983	10	0	2025-11-19 12:36:49
3984	9	91.00684261974584	2025-11-19 12:37:03
3985	10	0	2025-11-19 12:37:03
3986	9	90.9090909090909	2025-11-19 12:37:12
3987	10	0	2025-11-19 12:37:12
3988	9	91.00684261974584	2025-11-19 12:37:21
3989	10	0	2025-11-19 12:37:21
3990	9	91.00684261974584	2025-11-19 12:37:36
3991	10	0	2025-11-19 12:37:36
3992	9	91.00684261974584	2025-11-19 12:37:45
3993	10	0	2025-11-19 12:37:45
3994	9	91.00684261974584	2025-11-19 12:37:54
3995	10	0	2025-11-19 12:37:54
3996	9	91.00684261974584	2025-11-19 12:38:09
3997	10	0	2025-11-19 12:38:09
3998	9	91.00684261974584	2025-11-19 12:38:18
3999	10	0	2025-11-19 12:38:18
4000	9	91.00684261974584	2025-11-19 12:38:34
4001	10	0	2025-11-19 12:38:34
4002	9	91.00684261974584	2025-11-19 12:38:48
4003	10	0	2025-11-19 12:38:48
4004	9	91.00684261974584	2025-11-19 12:39:03
4005	10	0	2025-11-19 12:39:03
4006	9	91.00684261974584	2025-11-19 12:39:12
4007	10	0	2025-11-19 12:39:12
4008	9	91.00684261974584	2025-11-19 12:39:26
4009	10	0	2025-11-19 12:39:26
4010	9	91.00684261974584	2025-11-19 12:39:40
4011	10	0	2025-11-19 12:39:40
4012	9	91.00684261974584	2025-11-19 12:39:54
4013	10	0	2025-11-19 12:39:54
4014	9	91.00684261974584	2025-11-19 12:40:03
4015	10	0	2025-11-19 12:40:03
4016	9	91.00684261974584	2025-11-19 12:40:12
4017	10	0	2025-11-19 12:40:12
4018	9	91.00684261974584	2025-11-19 12:40:21
4019	10	0	2025-11-19 12:40:21
4020	9	91.00684261974584	2025-11-19 12:40:31
4021	10	0	2025-11-19 12:40:31
4022	9	91.00684261974584	2025-11-19 12:40:46
4023	10	0	2025-11-19 12:40:46
4024	9	91.00684261974584	2025-11-19 12:41:02
4025	10	0	2025-11-19 12:41:02
4026	9	91.00684261974584	2025-11-19 12:41:16
4027	10	0	2025-11-19 12:41:16
4028	9	91.00684261974584	2025-11-19 12:41:31
4029	10	0	2025-11-19 12:41:31
4030	9	91.00684261974584	2025-11-19 12:41:46
4031	10	0	2025-11-19 12:41:46
4032	9	91.00684261974584	2025-11-19 12:42:00
4033	10	0	2025-11-19 12:42:00
4034	9	91.00684261974584	2025-11-19 12:42:09
4035	10	0	2025-11-19 12:42:09
4036	9	91.00684261974584	2025-11-19 12:42:24
4037	10	0	2025-11-19 12:42:24
4038	9	91.00684261974584	2025-11-19 12:42:33
4039	10	0	2025-11-19 12:42:33
4040	9	91.00684261974584	2025-11-19 12:42:43
4041	10	0	2025-11-19 12:42:43
4042	9	91.00684261974584	2025-11-19 12:42:57
4043	10	0	2025-11-19 12:42:57
4044	9	91.00684261974584	2025-11-19 12:43:07
4045	10	0	2025-11-19 12:43:07
4046	9	91.00684261974584	2025-11-19 12:43:21
4047	10	0	2025-11-19 12:43:21
4048	9	91.00684261974584	2025-11-19 12:43:34
4049	10	0	2025-11-19 12:43:34
4050	9	91.00684261974584	2025-11-19 12:43:49
4051	10	0	2025-11-19 12:43:49
4052	9	91.00684261974584	2025-11-19 12:44:03
4053	10	0	2025-11-19 12:44:03
4054	9	91.00684261974584	2025-11-19 12:44:18
4055	10	0	2025-11-19 12:44:18
4056	9	91.00684261974584	2025-11-19 12:44:33
4057	10	0	2025-11-19 12:44:33
4058	9	91.00684261974584	2025-11-19 12:44:42
4059	10	0	2025-11-19 12:44:42
4060	9	91.00684261974584	2025-11-19 12:44:52
4061	10	0	2025-11-19 12:44:52
4062	9	91.00684261974584	2025-11-19 12:45:05
4063	10	0	2025-11-19 12:45:05
4064	9	91.00684261974584	2025-11-19 12:45:15
4065	10	0	2025-11-19 12:45:15
4066	9	91.00684261974584	2025-11-19 12:45:30
4067	10	0	2025-11-19 12:45:30
4068	9	91.00684261974584	2025-11-19 12:45:40
4069	10	0	2025-11-19 12:45:40
4070	9	91.00684261974584	2025-11-19 12:45:55
4071	10	0	2025-11-19 12:45:55
4072	9	91.00684261974584	2025-11-19 12:46:10
4073	10	0	2025-11-19 12:46:10
4074	9	91.00684261974584	2025-11-19 12:46:24
4075	10	0	2025-11-19 12:46:24
4076	9	91.00684261974584	2025-11-19 12:46:33
4077	10	0	2025-11-19 12:46:33
4078	9	91.00684261974584	2025-11-19 12:46:48
4079	10	0	2025-11-19 12:46:48
4080	9	91.00684261974584	2025-11-19 12:46:56
4081	10	0	2025-11-19 12:46:56
4082	9	91.00684261974584	2025-11-19 12:47:10
4083	10	0	2025-11-19 12:47:10
4084	9	91.00684261974584	2025-11-19 12:47:26
4085	10	0	2025-11-19 12:47:26
4086	9	91.00684261974584	2025-11-19 12:47:40
4087	10	0	2025-11-19 12:47:40
4088	9	91.00684261974584	2025-11-19 12:47:54
4089	10	0	2025-11-19 12:47:54
4090	9	91.00684261974584	2025-11-19 12:48:08
4091	10	0	2025-11-19 12:48:08
4092	9	91.00684261974584	2025-11-19 12:48:18
4093	10	0	2025-11-19 12:48:18
4094	9	91.00684261974584	2025-11-19 12:48:27
4095	10	0	2025-11-19 12:48:27
4096	9	91.00684261974584	2025-11-19 12:48:42
4097	10	0	2025-11-19 12:48:42
4098	9	91.00684261974584	2025-11-19 12:48:55
4099	10	0	2025-11-19 12:48:55
4100	9	91.00684261974584	2025-11-19 12:49:09
4101	10	0	2025-11-19 12:49:09
4102	9	91.00684261974584	2025-11-19 12:49:19
4103	10	0	2025-11-19 12:49:19
4104	9	91.00684261974584	2025-11-19 12:49:33
4105	10	0	2025-11-19 12:49:33
4106	9	91.00684261974584	2025-11-19 12:49:42
4107	10	0	2025-11-19 12:49:42
4108	9	91.00684261974584	2025-11-19 12:49:55
4109	10	0	2025-11-19 12:49:55
4110	9	91.00684261974584	2025-11-19 12:50:10
4111	10	0	2025-11-19 12:50:10
4112	9	91.00684261974584	2025-11-19 12:50:24
4113	10	0	2025-11-19 12:50:24
4114	9	91.00684261974584	2025-11-19 12:50:38
4115	10	0	2025-11-19 12:50:38
4116	9	91.00684261974584	2025-11-19 12:50:53
4117	10	0	2025-11-19 12:50:53
4118	9	91.00684261974584	2025-11-19 12:51:07
4119	10	0	2025-11-19 12:51:07
4120	9	91.00684261974584	2025-11-19 12:51:21
4121	10	0	2025-11-19 12:51:21
4122	9	91.00684261974584	2025-11-19 12:51:35
4123	10	0	2025-11-19 12:51:35
4124	9	91.00684261974584	2025-11-19 12:51:45
4125	10	0	2025-11-19 12:51:45
4126	9	91.00684261974584	2025-11-19 12:51:54
4127	10	0	2025-11-19 12:51:54
4128	9	91.00684261974584	2025-11-19 12:52:03
4129	10	0	2025-11-19 12:52:03
4130	9	91.00684261974584	2025-11-19 12:52:12
4131	10	0	2025-11-19 12:52:12
4132	9	91.00684261974584	2025-11-19 12:52:21
4133	10	0	2025-11-19 12:52:21
4134	9	91.00684261974584	2025-11-19 12:52:30
4135	10	0	2025-11-19 12:52:30
4136	9	91.00684261974584	2025-11-19 12:52:44
4137	10	0	2025-11-19 12:52:44
4138	9	91.00684261974584	2025-11-19 12:52:54
4139	10	0	2025-11-19 12:52:54
4140	9	91.00684261974584	2025-11-19 12:53:03
4141	10	0	2025-11-19 12:53:03
4142	9	91.00684261974584	2025-11-19 12:53:18
4143	10	0	2025-11-19 12:53:18
4144	9	91.00684261974584	2025-11-19 12:53:29
4145	10	0	2025-11-19 12:53:29
4146	9	91.00684261974584	2025-11-19 12:53:44
4147	10	0	2025-11-19 12:53:44
4148	9	91.00684261974584	2025-11-19 12:53:58
4149	10	0	2025-11-19 12:53:58
4150	9	91.00684261974584	2025-11-19 12:54:13
4151	10	0	2025-11-19 12:54:13
4152	9	91.00684261974584	2025-11-19 12:54:28
4153	10	0	2025-11-19 12:54:28
4154	9	91.00684261974584	2025-11-19 12:54:42
4155	10	0	2025-11-19 12:54:42
4156	9	91.00684261974584	2025-11-19 12:54:51
4157	10	0	2025-11-19 12:54:51
4158	9	91.00684261974584	2025-11-19 12:55:04
4159	10	0	2025-11-19 12:55:04
4160	9	91.00684261974584	2025-11-19 12:55:19
4161	10	0	2025-11-19 12:55:19
4162	9	91.00684261974584	2025-11-19 12:55:34
4163	10	0	2025-11-19 12:55:34
4164	9	91.00684261974584	2025-11-19 12:55:48
4165	10	0	2025-11-19 12:55:48
4166	9	91.00684261974584	2025-11-19 12:56:03
4167	10	0	2025-11-19 12:56:03
4168	9	91.00684261974584	2025-11-19 12:56:12
4169	10	0	2025-11-19 12:56:12
4170	9	91.00684261974584	2025-11-19 12:56:27
4171	10	0	2025-11-19 12:56:27
4172	9	91.00684261974584	2025-11-19 12:56:36
4173	10	0	2025-11-19 12:56:36
4174	9	91.00684261974584	2025-11-19 12:56:51
4175	10	0	2025-11-19 12:56:51
4176	9	91.00684261974584	2025-11-19 12:57:00
4177	10	0	2025-11-19 12:57:00
4178	9	91.00684261974584	2025-11-19 12:57:09
4179	10	0	2025-11-19 12:57:09
4180	9	91.00684261974584	2025-11-19 12:57:23
4181	10	0	2025-11-19 12:57:23
4182	9	91.00684261974584	2025-11-19 12:57:33
4183	10	0	2025-11-19 12:57:33
4184	9	91.00684261974584	2025-11-19 12:57:42
4185	10	0	2025-11-19 12:57:42
4186	9	91.00684261974584	2025-11-19 12:57:51
4187	10	0	2025-11-19 12:57:51
4188	9	91.10459433040079	2025-11-19 12:58:06
4189	10	0	2025-11-19 12:58:06
4190	9	91.00684261974584	2025-11-19 12:58:15
4191	10	0	2025-11-19 12:58:15
4192	9	91.00684261974584	2025-11-19 12:58:25
4193	10	0	2025-11-19 12:58:25
4194	9	91.00684261974584	2025-11-19 12:58:39
4195	10	0	2025-11-19 12:58:39
4196	9	91.00684261974584	2025-11-19 12:58:54
4197	10	0	2025-11-19 12:58:54
4198	9	91.00684261974584	2025-11-19 12:59:05
4199	10	0	2025-11-19 12:59:05
4200	9	91.00684261974584	2025-11-19 12:59:15
4201	10	0	2025-11-19 12:59:15
4202	9	91.00684261974584	2025-11-19 12:59:25
4203	10	0	2025-11-19 12:59:25
4204	9	91.00684261974584	2025-11-19 12:59:39
4205	10	0	2025-11-19 12:59:39
4206	9	91.00684261974584	2025-11-19 12:59:48
4207	10	0	2025-11-19 12:59:48
4208	9	91.00684261974584	2025-11-19 12:59:57
4209	10	0	2025-11-19 12:59:57
4210	9	91.00684261974584	2025-11-19 13:00:12
4211	10	0	2025-11-19 13:00:12
4212	9	91.00684261974584	2025-11-19 13:00:27
4213	10	0	2025-11-19 13:00:27
4214	9	91.00684261974584	2025-11-19 13:00:36
4215	10	0	2025-11-19 13:00:36
4216	9	91.00684261974584	2025-11-19 13:00:45
4217	10	0	2025-11-19 13:00:45
4218	9	91.00684261974584	2025-11-19 13:00:54
4219	10	0	2025-11-19 13:00:54
4220	9	91.00684261974584	2025-11-19 13:01:03
4221	10	0	2025-11-19 13:01:03
4222	9	91.00684261974584	2025-11-19 13:01:18
4223	10	0	2025-11-19 13:01:18
4224	9	91.00684261974584	2025-11-19 13:01:33
4225	10	0	2025-11-19 13:01:33
4226	9	91.00684261974584	2025-11-19 13:01:42
4227	10	0	2025-11-19 13:01:42
4228	9	91.00684261974584	2025-11-19 13:01:57
4229	10	0	2025-11-19 13:01:57
4230	9	91.00684261974584	2025-11-19 13:02:06
4231	10	0	2025-11-19 13:02:06
4232	9	91.00684261974584	2025-11-19 13:02:20
4233	10	0	2025-11-19 13:02:20
4234	9	91.00684261974584	2025-11-19 13:02:34
4235	10	0	2025-11-19 13:02:34
4236	9	91.00684261974584	2025-11-19 13:02:49
4237	10	0	2025-11-19 13:02:49
4238	9	91.00684261974584	2025-11-19 13:03:02
4239	10	0	2025-11-19 13:03:02
4240	9	91.00684261974584	2025-11-19 13:03:12
4241	10	0	2025-11-19 13:03:12
4242	9	91.00684261974584	2025-11-19 13:03:27
4243	10	0	2025-11-19 13:03:27
4244	9	91.00684261974584	2025-11-19 13:03:37
4245	10	0	2025-11-19 13:03:37
4246	9	91.00684261974584	2025-11-19 13:03:51
4247	10	0	2025-11-19 13:03:51
4248	9	91.00684261974584	2025-11-19 13:04:00
4249	10	0	2025-11-19 13:04:00
4250	9	91.00684261974584	2025-11-19 13:04:15
4251	10	0	2025-11-19 13:04:15
4252	9	91.00684261974584	2025-11-19 13:04:28
4253	10	0	2025-11-19 13:04:28
4254	9	91.00684261974584	2025-11-19 13:04:43
4255	10	0	2025-11-19 13:04:43
4256	9	91.00684261974584	2025-11-19 13:04:58
4257	10	0	2025-11-19 13:04:58
4258	9	91.00684261974584	2025-11-19 13:05:13
4259	10	0	2025-11-19 13:05:13
4260	9	91.10459433040079	2025-11-19 13:05:28
4261	10	0	2025-11-19 13:05:28
4262	9	91.00684261974584	2025-11-19 13:05:42
4263	10	0	2025-11-19 13:05:42
4264	9	91.00684261974584	2025-11-19 13:05:51
4265	10	0	2025-11-19 13:05:51
4266	9	91.00684261974584	2025-11-19 13:06:00
4267	10	0	2025-11-19 13:06:00
4268	9	91.00684261974584	2025-11-19 13:06:09
4269	10	0	2025-11-19 13:06:09
4270	9	91.00684261974584	2025-11-19 13:06:19
4271	10	0	2025-11-19 13:06:19
4272	9	91.00684261974584	2025-11-19 13:06:34
4273	10	0	2025-11-19 13:06:34
4274	9	91.00684261974584	2025-11-19 13:06:48
4275	10	0	2025-11-19 13:06:48
4276	9	91.00684261974584	2025-11-19 13:06:57
4277	10	0	2025-11-19 13:06:57
4278	9	91.00684261974584	2025-11-19 13:07:07
4279	10	0	2025-11-19 13:07:07
4280	9	91.00684261974584	2025-11-19 13:07:21
4281	10	0	2025-11-19 13:07:21
4282	9	91.00684261974584	2025-11-19 13:07:30
4283	10	0	2025-11-19 13:07:30
4284	9	91.00684261974584	2025-11-19 13:07:40
4285	10	0	2025-11-19 13:07:40
4286	9	91.00684261974584	2025-11-19 13:07:53
4287	10	0	2025-11-19 13:07:53
4288	9	91.00684261974584	2025-11-19 13:08:08
4289	10	0	2025-11-19 13:08:08
4290	9	91.00684261974584	2025-11-19 13:08:22
4291	10	0	2025-11-19 13:08:22
4292	9	91.00684261974584	2025-11-19 13:08:36
4293	10	0	2025-11-19 13:08:36
4294	9	91.00684261974584	2025-11-19 13:08:51
4295	10	0	2025-11-19 13:08:51
4296	9	91.00684261974584	2025-11-19 13:09:05
4297	10	0	2025-11-19 13:09:05
4298	9	91.00684261974584	2025-11-19 13:09:15
4299	10	0	2025-11-19 13:09:15
4300	9	91.00684261974584	2025-11-19 13:09:31
4301	10	0	2025-11-19 13:09:31
4302	9	91.00684261974584	2025-11-19 13:09:45
4303	10	0	2025-11-19 13:09:45
4304	9	91.00684261974584	2025-11-19 13:09:54
4305	10	0	2025-11-19 13:09:54
4306	9	91.00684261974584	2025-11-19 13:10:09
4307	10	0	2025-11-19 13:10:09
4308	9	91.00684261974584	2025-11-19 13:10:18
4309	10	0	2025-11-19 13:10:18
4310	9	91.00684261974584	2025-11-19 13:10:33
4311	10	0	2025-11-19 13:10:33
4312	9	91.00684261974584	2025-11-19 13:10:42
4313	10	0	2025-11-19 13:10:42
4314	9	91.00684261974584	2025-11-19 13:10:52
4315	10	0	2025-11-19 13:10:52
4316	9	91.00684261974584	2025-11-19 13:11:06
4317	10	0	2025-11-19 13:11:06
4318	9	91.00684261974584	2025-11-19 13:11:21
4319	10	0	2025-11-19 13:11:21
4320	9	91.00684261974584	2025-11-19 13:11:35
4321	10	0	2025-11-19 13:11:35
4322	9	91.00684261974584	2025-11-19 13:11:49
4323	10	0	2025-11-19 13:11:49
4324	9	91.00684261974584	2025-11-19 13:12:03
4325	10	0	2025-11-19 13:12:03
4326	9	91.00684261974584	2025-11-19 13:12:18
4327	10	0	2025-11-19 13:12:18
4328	9	91.00684261974584	2025-11-19 13:12:28
4329	10	0	2025-11-19 13:12:28
4330	9	91.00684261974584	2025-11-19 13:12:43
4331	10	0	2025-11-19 13:12:43
4332	9	91.00684261974584	2025-11-19 13:12:58
4333	10	0	2025-11-19 13:12:58
4334	9	91.00684261974584	2025-11-19 13:13:13
4335	10	0	2025-11-19 13:13:13
4336	9	91.00684261974584	2025-11-19 13:13:27
4337	10	0	2025-11-19 13:13:27
4338	9	91.00684261974584	2025-11-19 13:13:41
4339	10	0	2025-11-19 13:13:41
4340	9	91.00684261974584	2025-11-19 13:13:55
4341	10	0	2025-11-19 13:13:55
4342	9	91.00684261974584	2025-11-19 13:14:10
4343	10	0	2025-11-19 13:14:10
4344	9	91.00684261974584	2025-11-19 13:14:26
4345	10	0	2025-11-19 13:14:26
4346	9	91.00684261974584	2025-11-19 13:14:36
4347	10	0	2025-11-19 13:14:36
4348	9	91.00684261974584	2025-11-19 13:14:45
4349	10	0	2025-11-19 13:14:45
4350	9	91.00684261974584	2025-11-19 13:15:00
4351	10	0	2025-11-19 13:15:00
4352	9	91.00684261974584	2025-11-19 13:15:09
4353	10	0	2025-11-19 13:15:09
4354	9	91.00684261974584	2025-11-19 13:15:19
4355	10	0	2025-11-19 13:15:19
4356	9	91.00684261974584	2025-11-19 13:15:33
4357	10	0	2025-11-19 13:15:33
4358	9	91.00684261974584	2025-11-19 13:15:47
4359	10	0	2025-11-19 13:15:47
4360	9	91.00684261974584	2025-11-19 13:16:02
4361	10	0	2025-11-19 13:16:02
4362	9	91.00684261974584	2025-11-19 13:16:16
4363	10	0	2025-11-19 13:16:16
4364	9	91.00684261974584	2025-11-19 13:16:31
4365	10	0	2025-11-19 13:16:31
4366	9	91.00684261974584	2025-11-19 13:16:45
4367	10	0	2025-11-19 13:16:45
4368	9	91.00684261974584	2025-11-19 13:17:00
4369	10	0	2025-11-19 13:17:00
4370	7	26.7	2025-11-20 06:31:30
4371	8	52	2025-11-20 06:31:30
4372	9	0	2025-11-20 06:31:30
4373	10	10	2025-11-20 06:31:30
4374	7	26.7	2025-11-20 06:31:45
4375	8	52	2025-11-20 06:31:45
4376	9	0.09775171065493282	2025-11-20 06:31:45
4377	10	10	2025-11-20 06:31:45
4378	7	26.7	2025-11-20 06:32:00
4379	8	52	2025-11-20 06:32:00
4380	9	0.09775171065493282	2025-11-20 06:32:00
4381	10	10	2025-11-20 06:32:00
4382	7	26.7	2025-11-20 06:32:08
4383	8	52	2025-11-20 06:32:08
4384	9	0.09775171065493282	2025-11-20 06:32:08
4385	10	10	2025-11-20 06:32:08
4386	7	26.7	2025-11-20 06:32:22
4387	8	52	2025-11-20 06:32:22
4388	9	0	2025-11-20 06:32:22
4389	10	10	2025-11-20 06:32:22
4390	7	26.7	2025-11-20 06:32:36
4391	8	52	2025-11-20 06:32:36
4392	9	0	2025-11-20 06:32:36
4393	10	10	2025-11-20 06:32:36
4394	7	26.7	2025-11-20 06:32:46
4395	8	52	2025-11-20 06:32:46
4396	9	0	2025-11-20 06:32:46
4397	10	10	2025-11-20 06:32:46
4398	7	26.7	2025-11-20 06:32:55
4399	8	52	2025-11-20 06:32:55
4400	9	0	2025-11-20 06:32:55
4401	10	10	2025-11-20 06:32:55
4402	7	26.2	2025-11-20 06:33:09
4403	8	54	2025-11-20 06:33:09
4404	9	0	2025-11-20 06:33:09
4405	10	7	2025-11-20 06:33:09
4406	7	26.2	2025-11-20 06:33:18
4407	8	54	2025-11-20 06:33:18
4408	9	0	2025-11-20 06:33:18
4409	10	7	2025-11-20 06:33:18
4410	7	26.2	2025-11-20 06:33:27
4411	8	54	2025-11-20 06:33:27
4412	9	0.09775171065493282	2025-11-20 06:33:27
4413	10	7	2025-11-20 06:33:27
4414	7	26.2	2025-11-20 06:33:42
4415	8	54	2025-11-20 06:33:42
4416	9	0	2025-11-20 06:33:42
4417	10	7	2025-11-20 06:33:42
4418	7	26.2	2025-11-20 06:33:51
4419	8	54	2025-11-20 06:33:51
4420	9	0	2025-11-20 06:33:51
4421	10	7	2025-11-20 06:33:51
4422	7	26.2	2025-11-20 06:34:00
4423	8	54	2025-11-20 06:34:00
4424	9	0	2025-11-20 06:34:00
4425	10	7	2025-11-20 06:34:00
4426	7	26.2	2025-11-20 06:34:14
4427	8	54	2025-11-20 06:34:14
4428	9	0.09775171065493282	2025-11-20 06:34:14
4429	10	7	2025-11-20 06:34:14
4430	7	26.2	2025-11-20 06:34:28
4431	8	54	2025-11-20 06:34:28
4432	9	0	2025-11-20 06:34:28
4433	10	7	2025-11-20 06:34:28
4434	7	26.2	2025-11-20 06:34:42
4435	8	54	2025-11-20 06:34:42
4436	9	0	2025-11-20 06:34:42
4437	10	7	2025-11-20 06:34:42
4438	7	26.2	2025-11-20 06:34:51
4439	8	54	2025-11-20 06:34:51
4440	9	0	2025-11-20 06:34:51
4441	10	7	2025-11-20 06:34:51
4442	7	26.2	2025-11-20 06:35:00
4443	8	54	2025-11-20 06:35:00
4444	9	0	2025-11-20 06:35:00
4445	10	7	2025-11-20 06:35:00
4446	7	26.2	2025-11-20 06:35:16
4447	8	54	2025-11-20 06:35:16
4448	9	0	2025-11-20 06:35:16
4449	10	7	2025-11-20 06:35:16
4450	7	26.2	2025-11-20 06:35:31
4451	8	54	2025-11-20 06:35:31
4452	9	0	2025-11-20 06:35:31
4453	10	7	2025-11-20 06:35:31
4454	7	26.2	2025-11-20 06:35:45
4455	8	54	2025-11-20 06:35:45
4456	9	0.09775171065493282	2025-11-20 06:35:45
4457	10	7	2025-11-20 06:35:45
4458	7	26.2	2025-11-20 06:35:59
4459	8	54	2025-11-20 06:35:59
4460	9	0	2025-11-20 06:35:59
4461	10	7	2025-11-20 06:35:59
4462	7	26.2	2025-11-20 06:36:14
4463	8	54	2025-11-20 06:36:14
4464	9	0	2025-11-20 06:36:14
4465	10	7	2025-11-20 06:36:14
4466	7	26.2	2025-11-20 06:36:28
4467	8	54	2025-11-20 06:36:28
4468	9	0	2025-11-20 06:36:28
4469	10	7	2025-11-20 06:36:28
4470	7	26.2	2025-11-20 06:36:41
4471	8	54	2025-11-20 06:36:41
4472	9	0	2025-11-20 06:36:41
4473	10	7	2025-11-20 06:36:41
4474	7	26.2	2025-11-20 06:36:51
4475	8	54	2025-11-20 06:36:51
4476	9	0	2025-11-20 06:36:51
4477	10	7	2025-11-20 06:36:51
4478	7	26.2	2025-11-20 06:37:00
4479	8	54	2025-11-20 06:37:00
4480	9	0	2025-11-20 06:37:00
4481	10	7	2025-11-20 06:37:00
4482	7	26.2	2025-11-20 06:37:15
4483	8	54	2025-11-20 06:37:15
4484	9	0.09775171065493282	2025-11-20 06:37:15
4485	10	7	2025-11-20 06:37:15
4486	7	26.2	2025-11-20 06:37:30
4487	8	54	2025-11-20 06:37:30
4488	9	0	2025-11-20 06:37:30
4489	10	7	2025-11-20 06:37:30
4490	7	26.2	2025-11-20 06:37:45
4491	8	54	2025-11-20 06:37:45
4492	9	0	2025-11-20 06:37:45
4493	10	7	2025-11-20 06:37:45
4494	7	26.2	2025-11-20 06:37:54
4495	8	54	2025-11-20 06:37:54
4496	9	0	2025-11-20 06:37:54
4497	10	7	2025-11-20 06:37:54
4498	7	26.2	2025-11-20 06:38:02
4499	8	54	2025-11-20 06:38:02
4500	9	0	2025-11-20 06:38:02
4501	10	7	2025-11-20 06:38:02
4502	7	26.2	2025-11-20 06:38:16
4503	8	54	2025-11-20 06:38:16
4504	9	0	2025-11-20 06:38:16
4505	10	7	2025-11-20 06:38:16
4506	7	26.2	2025-11-20 06:38:32
4507	8	54	2025-11-20 06:38:32
4508	9	0.09775171065493282	2025-11-20 06:38:32
4509	10	7	2025-11-20 06:38:32
4510	7	26.2	2025-11-20 06:38:42
4511	8	54	2025-11-20 06:38:42
4512	9	0.09775171065493282	2025-11-20 06:38:42
4513	10	7	2025-11-20 06:38:42
4514	7	26.2	2025-11-20 06:38:51
4515	8	54	2025-11-20 06:38:51
4516	9	0	2025-11-20 06:38:51
4517	10	7	2025-11-20 06:38:51
4518	7	26.2	2025-11-20 06:39:06
4519	8	54	2025-11-20 06:39:06
4520	9	0	2025-11-20 06:39:06
4521	10	7	2025-11-20 06:39:06
4522	7	26.2	2025-11-20 06:39:20
4523	8	54	2025-11-20 06:39:20
4524	9	0	2025-11-20 06:39:20
4525	10	7	2025-11-20 06:39:20
4526	7	26.2	2025-11-20 06:39:30
4527	8	54	2025-11-20 06:39:30
4528	9	0	2025-11-20 06:39:30
4529	10	7	2025-11-20 06:39:30
4530	7	26.2	2025-11-20 06:39:45
4531	8	54	2025-11-20 06:39:45
4532	9	0	2025-11-20 06:39:45
4533	10	7	2025-11-20 06:39:45
4534	7	26.2	2025-11-20 06:39:54
4535	8	54	2025-11-20 06:39:54
4536	9	0	2025-11-20 06:39:54
4537	10	7	2025-11-20 06:39:54
4538	7	26.2	2025-11-20 06:40:09
4539	8	54	2025-11-20 06:40:09
4540	9	0	2025-11-20 06:40:09
4541	10	7	2025-11-20 06:40:09
4542	7	26.2	2025-11-20 06:40:19
4543	8	54	2025-11-20 06:40:19
4544	9	0	2025-11-20 06:40:19
4545	10	7	2025-11-20 06:40:19
4546	7	26.2	2025-11-20 06:40:33
4547	8	54	2025-11-20 06:40:33
4548	9	0	2025-11-20 06:40:33
4549	10	7	2025-11-20 06:40:33
4550	7	26.2	2025-11-20 06:40:47
4551	8	54	2025-11-20 06:40:47
4552	9	0	2025-11-20 06:40:47
4553	10	7	2025-11-20 06:40:47
4554	7	26.2	2025-11-20 06:41:02
4555	8	54	2025-11-20 06:41:02
4556	9	0.09775171065493282	2025-11-20 06:41:02
4557	10	7	2025-11-20 06:41:02
4558	7	26.2	2025-11-20 06:41:17
4559	8	54	2025-11-20 06:41:17
4560	9	0	2025-11-20 06:41:17
4561	10	7	2025-11-20 06:41:17
4562	7	26.2	2025-11-20 06:41:37
4563	8	54	2025-11-20 06:41:37
4564	9	0	2025-11-20 06:41:37
4565	10	7	2025-11-20 06:41:37
4566	7	26.2	2025-11-20 06:41:51
4567	8	54	2025-11-20 06:41:51
4568	9	0	2025-11-20 06:41:51
4569	10	7	2025-11-20 06:41:51
4570	7	26.2	2025-11-20 06:42:00
4571	8	54	2025-11-20 06:42:00
4572	9	0	2025-11-20 06:42:00
4573	10	7	2025-11-20 06:42:00
4574	7	26.2	2025-11-20 06:42:15
4575	8	54	2025-11-20 06:42:15
4576	9	0	2025-11-20 06:42:15
4577	10	7	2025-11-20 06:42:15
4578	7	26.2	2025-11-20 06:42:35
4579	8	54	2025-11-20 06:42:35
4580	9	0	2025-11-20 06:42:35
4581	10	7	2025-11-20 06:42:35
4582	7	26.2	2025-11-20 06:42:49
4583	8	54	2025-11-20 06:42:49
4584	9	0	2025-11-20 06:42:49
4585	10	7	2025-11-20 06:42:49
4586	7	26.2	2025-11-20 06:43:04
4587	8	54	2025-11-20 06:43:04
4588	9	0	2025-11-20 06:43:04
4589	10	7	2025-11-20 06:43:04
4590	7	26.2	2025-11-20 06:43:28
4591	8	54	2025-11-20 06:43:28
4592	9	0	2025-11-20 06:43:28
4593	10	7	2025-11-20 06:43:28
4594	7	26.2	2025-11-20 06:43:42
4595	8	54	2025-11-20 06:43:42
4596	9	0	2025-11-20 06:43:42
4597	10	7	2025-11-20 06:43:42
4598	7	26.2	2025-11-20 06:43:56
4599	8	54	2025-11-20 06:43:56
4600	9	0	2025-11-20 06:43:56
4601	10	7	2025-11-20 06:43:56
4602	7	26.2	2025-11-20 06:44:12
4603	8	54	2025-11-20 06:44:12
4604	9	0	2025-11-20 06:44:12
4605	10	7	2025-11-20 06:44:12
4606	7	26.2	2025-11-20 06:44:32
4607	8	54	2025-11-20 06:44:32
4608	9	0	2025-11-20 06:44:32
4609	10	7	2025-11-20 06:44:32
4610	7	26.2	2025-11-20 06:44:42
4611	8	54	2025-11-20 06:44:42
4612	9	0.09775171065493282	2025-11-20 06:44:42
4613	10	7	2025-11-20 06:44:42
4614	7	26.2	2025-11-20 06:44:57
4615	8	54	2025-11-20 06:44:57
4616	9	0	2025-11-20 06:44:57
4617	10	7	2025-11-20 06:44:57
4618	7	26.2	2025-11-20 06:45:17
4619	8	54	2025-11-20 06:45:17
4620	9	0	2025-11-20 06:45:17
4621	10	7	2025-11-20 06:45:17
4622	7	25.3	2025-11-20 07:03:07
4623	8	54	2025-11-20 07:03:07
4624	9	10.557184750733143	2025-11-20 07:03:07
4625	10	12	2025-11-20 07:03:07
4626	7	25.3	2025-11-20 07:03:18
4627	8	54	2025-11-20 07:03:18
4628	9	10.654936461388075	2025-11-20 07:03:18
4629	10	11	2025-11-20 07:03:18
4630	7	25.3	2025-11-20 07:03:27
4631	8	54	2025-11-20 07:03:27
4632	9	10.654936461388075	2025-11-20 07:03:27
4633	10	12	2025-11-20 07:03:27
4634	7	25.3	2025-11-20 07:03:36
4635	8	54	2025-11-20 07:03:36
4636	9	10.557184750733143	2025-11-20 07:03:36
4637	10	11	2025-11-20 07:03:36
4638	7	25.3	2025-11-20 07:03:45
4639	8	54	2025-11-20 07:03:45
4640	9	10.654936461388075	2025-11-20 07:03:45
4641	10	12	2025-11-20 07:03:45
4642	7	25.3	2025-11-20 07:03:55
4643	8	54	2025-11-20 07:03:55
4644	9	10.752688172043008	2025-11-20 07:03:55
4645	10	11	2025-11-20 07:03:55
4646	7	25.3	2025-11-20 07:04:09
4647	8	54	2025-11-20 07:04:09
4648	9	10.557184750733143	2025-11-20 07:04:09
4649	10	12	2025-11-20 07:04:09
4650	7	25.3	2025-11-20 07:04:24
4651	8	54	2025-11-20 07:04:24
4652	9	10.654936461388075	2025-11-20 07:04:24
4653	10	11	2025-11-20 07:04:24
4654	7	25.3	2025-11-20 07:04:33
4655	8	54	2025-11-20 07:04:33
4656	9	10.654936461388075	2025-11-20 07:04:33
4657	10	12	2025-11-20 07:04:33
4658	7	25.3	2025-11-20 07:04:48
4659	8	54	2025-11-20 07:04:48
4660	9	10.654936461388075	2025-11-20 07:04:48
4661	10	11	2025-11-20 07:04:48
4662	7	25.3	2025-11-20 07:04:57
4663	8	54	2025-11-20 07:04:57
4664	9	10.752688172043008	2025-11-20 07:04:57
4665	10	12	2025-11-20 07:04:57
4666	7	25.3	2025-11-20 07:05:06
4667	8	54	2025-11-20 07:05:06
4668	9	10.752688172043008	2025-11-20 07:05:06
4669	10	11	2025-11-20 07:05:06
4670	7	25.3	2025-11-20 07:05:21
4671	8	54	2025-11-20 07:05:21
4672	9	10.654936461388075	2025-11-20 07:05:21
4673	10	12	2025-11-20 07:05:21
4674	7	25.3	2025-11-20 07:05:35
4675	8	54	2025-11-20 07:05:35
4676	9	10.654936461388075	2025-11-20 07:05:35
4677	10	11	2025-11-20 07:05:35
4678	7	25.3	2025-11-20 07:05:45
4679	8	54	2025-11-20 07:05:45
4680	9	10.654936461388075	2025-11-20 07:05:45
4681	10	11	2025-11-20 07:05:45
4682	7	25.3	2025-11-20 07:05:55
4683	8	54	2025-11-20 07:05:55
4684	9	10.752688172043008	2025-11-20 07:05:55
4685	10	11	2025-11-20 07:05:55
4686	7	25.3	2025-11-20 07:06:10
4687	8	54	2025-11-20 07:06:10
4688	9	10.654936461388075	2025-11-20 07:06:10
4689	10	11	2025-11-20 07:06:10
4690	7	25.3	2025-11-20 07:06:24
4691	8	54	2025-11-20 07:06:24
4692	9	10.752688172043008	2025-11-20 07:06:24
4693	10	11	2025-11-20 07:06:24
4694	7	25.3	2025-11-20 07:06:38
4695	8	54	2025-11-20 07:06:38
4696	9	10.654936461388075	2025-11-20 07:06:38
4697	10	12	2025-11-20 07:06:38
4698	7	25.3	2025-11-20 07:06:52
4699	8	54	2025-11-20 07:06:52
4700	9	10.654936461388075	2025-11-20 07:06:52
4701	10	11	2025-11-20 07:06:52
4702	7	25.3	2025-11-20 07:07:07
4703	8	54	2025-11-20 07:07:07
4704	9	10.752688172043008	2025-11-20 07:07:07
4705	10	12	2025-11-20 07:07:07
4706	7	25.3	2025-11-20 07:07:21
4707	8	54	2025-11-20 07:07:21
4708	9	10.752688172043008	2025-11-20 07:07:21
4709	10	11	2025-11-20 07:07:21
4710	7	25.3	2025-11-20 07:07:30
4711	8	55	2025-11-20 07:07:30
4712	9	10.654936461388075	2025-11-20 07:07:30
4713	10	12	2025-11-20 07:07:30
4714	7	25.3	2025-11-20 07:07:40
4715	8	55	2025-11-20 07:07:40
4716	9	10.752688172043008	2025-11-20 07:07:40
4717	10	11	2025-11-20 07:07:40
4718	7	25.3	2025-11-20 07:07:54
4719	8	55	2025-11-20 07:07:54
4720	9	10.752688172043008	2025-11-20 07:07:54
4721	10	12	2025-11-20 07:07:54
4722	7	25.3	2025-11-20 07:08:09
4723	8	55	2025-11-20 07:08:09
4724	9	10.752688172043008	2025-11-20 07:08:09
4725	10	11	2025-11-20 07:08:09
4726	7	25.3	2025-11-20 07:08:23
4727	8	55	2025-11-20 07:08:23
4728	9	10.752688172043008	2025-11-20 07:08:23
4729	10	12	2025-11-20 07:08:23
4730	7	25.3	2025-11-20 07:08:34
4731	8	55	2025-11-20 07:08:34
4732	9	10.752688172043008	2025-11-20 07:08:34
4733	10	11	2025-11-20 07:08:34
4734	7	25.3	2025-11-20 07:08:50
4735	8	55	2025-11-20 07:08:50
4736	9	10.654936461388075	2025-11-20 07:08:50
4737	10	12	2025-11-20 07:08:50
4738	7	25.3	2025-11-20 07:09:04
4739	8	55	2025-11-20 07:09:04
4740	9	10.654936461388075	2025-11-20 07:09:04
4741	10	11	2025-11-20 07:09:04
4742	7	25.3	2025-11-20 07:09:18
4743	8	55	2025-11-20 07:09:18
4744	9	10.752688172043008	2025-11-20 07:09:18
4745	10	12	2025-11-20 07:09:18
4746	7	25.3	2025-11-20 07:09:32
4747	8	55	2025-11-20 07:09:32
4748	9	10.752688172043008	2025-11-20 07:09:32
4749	10	11	2025-11-20 07:09:32
4750	7	25.3	2025-11-20 07:09:42
4751	8	55	2025-11-20 07:09:42
4752	9	10.654936461388075	2025-11-20 07:09:42
4753	10	12	2025-11-20 07:09:42
4754	7	25.3	2025-11-20 07:09:57
4755	8	55	2025-11-20 07:09:57
4756	9	10.752688172043008	2025-11-20 07:09:57
4757	10	11	2025-11-20 07:09:57
4758	7	25.3	2025-11-20 07:10:06
4759	8	55	2025-11-20 07:10:06
4760	9	10.752688172043008	2025-11-20 07:10:06
4761	10	12	2025-11-20 07:10:06
4762	7	25.3	2025-11-20 07:10:15
4763	8	55	2025-11-20 07:10:15
4764	9	10.752688172043008	2025-11-20 07:10:15
4765	10	11	2025-11-20 07:10:15
4766	7	25.3	2025-11-20 07:10:30
4767	8	55	2025-11-20 07:10:30
4768	9	10.752688172043008	2025-11-20 07:10:30
4769	10	12	2025-11-20 07:10:30
4770	7	25.3	2025-11-20 07:10:45
4771	8	55	2025-11-20 07:10:45
4772	9	10.752688172043008	2025-11-20 07:10:45
4773	10	11	2025-11-20 07:10:45
4774	7	25.3	2025-11-20 07:10:54
4775	8	55	2025-11-20 07:10:54
4776	9	10.654936461388075	2025-11-20 07:10:54
4777	10	12	2025-11-20 07:10:54
4778	7	25.3	2025-11-20 07:11:08
4779	8	55	2025-11-20 07:11:08
4780	9	10.752688172043008	2025-11-20 07:11:08
4781	10	11	2025-11-20 07:11:08
4782	7	25.3	2025-11-20 07:11:22
4783	8	55	2025-11-20 07:11:22
4784	9	10.752688172043008	2025-11-20 07:11:22
4785	10	12	2025-11-20 07:11:22
4786	7	25.3	2025-11-20 07:11:37
4787	8	55	2025-11-20 07:11:37
4788	9	10.752688172043008	2025-11-20 07:11:37
4789	10	11	2025-11-20 07:11:37
4790	7	25.3	2025-11-20 07:11:52
4791	8	55	2025-11-20 07:11:52
4792	9	10.752688172043008	2025-11-20 07:11:52
4793	10	12	2025-11-20 07:11:52
4794	7	25.3	2025-11-20 07:12:06
4795	8	55	2025-11-20 07:12:06
4796	9	10.850439882697941	2025-11-20 07:12:06
4797	10	11	2025-11-20 07:12:06
4798	7	25.3	2025-11-20 07:12:21
4799	8	55	2025-11-20 07:12:21
4800	9	10.752688172043008	2025-11-20 07:12:21
4801	10	12	2025-11-20 07:12:21
4802	7	25.3	2025-11-20 07:12:30
4803	8	55	2025-11-20 07:12:30
4804	9	10.850439882697941	2025-11-20 07:12:30
4805	10	11	2025-11-20 07:12:30
4806	7	25.3	2025-11-20 07:12:40
4807	8	55	2025-11-20 07:12:40
4808	9	10.752688172043008	2025-11-20 07:12:40
4809	10	12	2025-11-20 07:12:40
4810	7	25.3	2025-11-20 07:12:54
4811	8	55	2025-11-20 07:12:54
4812	9	10.850439882697941	2025-11-20 07:12:54
4813	10	11	2025-11-20 07:12:54
4814	7	25.3	2025-11-20 07:13:09
4815	8	55	2025-11-20 07:13:09
4816	9	10.752688172043008	2025-11-20 07:13:09
4817	10	12	2025-11-20 07:13:09
4818	7	25.3	2025-11-20 07:13:19
4819	8	55	2025-11-20 07:13:19
4820	9	10.850439882697941	2025-11-20 07:13:19
4821	10	11	2025-11-20 07:13:19
4822	7	25.3	2025-11-20 07:13:33
4823	8	55	2025-11-20 07:13:33
4824	9	10.752688172043008	2025-11-20 07:13:33
4825	10	12	2025-11-20 07:13:33
4826	7	25.3	2025-11-20 07:13:46
4827	8	55	2025-11-20 07:13:46
4828	9	10.752688172043008	2025-11-20 07:13:46
4829	10	11	2025-11-20 07:13:46
4830	7	25.3	2025-11-20 07:14:01
4831	8	55	2025-11-20 07:14:01
4832	9	10.850439882697941	2025-11-20 07:14:01
4833	10	12	2025-11-20 07:14:01
4834	7	25.3	2025-11-20 07:14:15
4835	8	55	2025-11-20 07:14:15
4836	9	10.850439882697941	2025-11-20 07:14:15
4837	10	11	2025-11-20 07:14:15
4838	7	25.3	2025-11-20 07:14:25
4839	8	55	2025-11-20 07:14:25
4840	9	10.850439882697941	2025-11-20 07:14:25
4841	10	12	2025-11-20 07:14:25
4842	7	25.3	2025-11-20 07:14:39
4843	8	55	2025-11-20 07:14:39
4844	9	10.850439882697941	2025-11-20 07:14:39
4845	10	11	2025-11-20 07:14:39
4846	7	25.3	2025-11-20 07:14:54
4847	8	55	2025-11-20 07:14:54
4848	9	10.752688172043008	2025-11-20 07:14:54
4849	10	12	2025-11-20 07:14:54
4850	7	25.3	2025-11-20 07:15:09
4851	8	55	2025-11-20 07:15:09
4852	9	10.850439882697941	2025-11-20 07:15:09
4853	10	11	2025-11-20 07:15:09
4854	7	25.3	2025-11-20 07:15:18
4855	8	55	2025-11-20 07:15:18
4856	9	10.752688172043008	2025-11-20 07:15:18
4857	10	11	2025-11-20 07:15:18
4858	7	25.3	2025-11-20 07:15:26
4859	8	55	2025-11-20 07:15:26
4860	9	10.850439882697941	2025-11-20 07:15:26
4861	10	11	2025-11-20 07:15:26
4862	7	25.3	2025-11-20 07:15:41
4863	8	55	2025-11-20 07:15:41
4864	9	10.752688172043008	2025-11-20 07:15:41
4865	10	11	2025-11-20 07:15:41
4866	7	25.3	2025-11-20 07:15:55
4867	8	55	2025-11-20 07:15:55
4868	9	10.850439882697941	2025-11-20 07:15:55
4869	10	11	2025-11-20 07:15:55
4870	7	25.3	2025-11-20 07:16:10
4871	8	55	2025-11-20 07:16:10
4872	9	10.850439882697941	2025-11-20 07:16:10
4873	10	11	2025-11-20 07:16:10
4874	7	25.3	2025-11-20 07:16:24
4875	8	55	2025-11-20 07:16:24
4876	9	10.948191593352888	2025-11-20 07:16:24
4877	10	11	2025-11-20 07:16:24
4878	7	25.3	2025-11-20 07:16:38
4879	8	55	2025-11-20 07:16:38
4880	9	10.752688172043008	2025-11-20 07:16:38
4881	10	11	2025-11-20 07:16:38
4882	7	25.3	2025-11-20 07:16:52
4883	8	55	2025-11-20 07:16:52
4884	9	10.850439882697941	2025-11-20 07:16:52
4885	10	11	2025-11-20 07:16:52
4886	7	25.3	2025-11-20 07:17:09
4887	8	55	2025-11-20 07:17:09
4888	9	10.850439882697941	2025-11-20 07:17:09
4889	10	11	2025-11-20 07:17:09
4890	7	25.3	2025-11-20 07:17:18
4891	8	55	2025-11-20 07:17:18
4892	9	10.850439882697941	2025-11-20 07:17:18
4893	10	11	2025-11-20 07:17:18
4894	7	25.3	2025-11-20 07:17:39
4895	8	55	2025-11-20 07:17:39
4896	9	10.850439882697941	2025-11-20 07:17:39
4897	10	11	2025-11-20 07:17:39
4898	7	25.3	2025-11-20 07:17:49
4899	8	55	2025-11-20 07:17:49
4900	9	10.850439882697941	2025-11-20 07:17:49
4901	10	11	2025-11-20 07:17:49
4902	7	25.3	2025-11-20 07:17:58
4903	8	55	2025-11-20 07:17:58
4904	9	10.850439882697941	2025-11-20 07:17:58
4905	10	12	2025-11-20 07:17:58
4906	7	25.3	2025-11-20 07:18:12
4907	8	55	2025-11-20 07:18:12
4908	9	10.752688172043008	2025-11-20 07:18:12
4909	10	11	2025-11-20 07:18:12
4910	7	25.3	2025-11-20 07:18:27
4911	8	55	2025-11-20 07:18:27
4912	9	10.850439882697941	2025-11-20 07:18:27
4913	10	12	2025-11-20 07:18:27
4914	7	25.3	2025-11-20 07:18:36
4915	8	55	2025-11-20 07:18:36
4916	9	10.850439882697941	2025-11-20 07:18:36
4917	10	11	2025-11-20 07:18:36
4918	7	25.3	2025-11-20 07:18:51
4919	8	55	2025-11-20 07:18:51
4920	9	10.850439882697941	2025-11-20 07:18:51
4921	10	12	2025-11-20 07:18:51
4922	7	25.3	2025-11-20 07:19:00
4923	8	55	2025-11-20 07:19:00
4924	9	10.850439882697941	2025-11-20 07:19:00
4925	10	11	2025-11-20 07:19:00
4926	7	25.3	2025-11-20 07:19:09
4927	8	55	2025-11-20 07:19:09
4928	9	10.850439882697941	2025-11-20 07:19:09
4929	10	12	2025-11-20 07:19:09
4930	7	25.3	2025-11-20 07:19:24
4931	8	55	2025-11-20 07:19:24
4932	9	10.948191593352888	2025-11-20 07:19:24
4933	10	11	2025-11-20 07:19:24
4934	7	25.3	2025-11-20 07:19:39
4935	8	55	2025-11-20 07:19:39
4936	9	10.850439882697941	2025-11-20 07:19:39
4937	10	12	2025-11-20 07:19:39
4938	7	25.3	2025-11-20 07:20:00
4939	8	55	2025-11-20 07:20:00
4940	9	10.948191593352888	2025-11-20 07:20:00
4941	10	11	2025-11-20 07:20:00
4942	7	25.3	2025-11-20 07:20:16
4943	8	55	2025-11-20 07:20:16
4944	9	10.850439882697941	2025-11-20 07:20:16
4945	10	12	2025-11-20 07:20:16
4946	7	25.3	2025-11-20 07:20:30
4947	8	55	2025-11-20 07:20:30
4948	9	10.850439882697941	2025-11-20 07:20:30
4949	10	11	2025-11-20 07:20:30
4950	7	25.3	2025-11-20 07:20:45
4951	8	55	2025-11-20 07:20:45
4952	9	10.850439882697941	2025-11-20 07:20:45
4953	10	12	2025-11-20 07:20:45
4954	7	25.3	2025-11-20 07:20:58
4955	8	55	2025-11-20 07:20:58
4956	9	10.948191593352888	2025-11-20 07:20:58
4957	10	11	2025-11-20 07:20:58
4958	7	25.3	2025-11-20 07:21:13
4959	8	55	2025-11-20 07:21:13
4960	9	10.850439882697941	2025-11-20 07:21:13
4961	10	12	2025-11-20 07:21:13
4962	7	25.3	2025-11-20 07:21:30
4963	8	55	2025-11-20 07:21:30
4964	9	10.948191593352888	2025-11-20 07:21:30
4965	10	11	2025-11-20 07:21:30
4966	7	25.3	2025-11-20 07:21:40
4967	8	55	2025-11-20 07:21:40
4968	9	10.850439882697941	2025-11-20 07:21:40
4969	10	12	2025-11-20 07:21:40
4970	7	25.3	2025-11-20 07:21:55
4971	8	55	2025-11-20 07:21:55
4972	9	10.850439882697941	2025-11-20 07:21:55
4973	10	11	2025-11-20 07:21:55
4974	7	25.3	2025-11-20 07:22:09
4975	8	55	2025-11-20 07:22:09
4976	9	10.948191593352888	2025-11-20 07:22:09
4977	10	12	2025-11-20 07:22:09
4978	7	25.3	2025-11-20 07:22:25
4979	8	55	2025-11-20 07:22:25
4980	9	0	2025-11-20 07:22:25
4981	10	17	2025-11-20 07:22:25
4982	7	25.3	2025-11-20 07:22:40
4983	8	55	2025-11-20 07:22:40
4984	9	0	2025-11-20 07:22:40
4985	10	14	2025-11-20 07:22:40
4986	7	25.3	2025-11-20 07:22:56
4987	8	55	2025-11-20 07:22:56
4988	9	0	2025-11-20 07:22:56
4989	10	13	2025-11-20 07:22:56
4990	7	25.3	2025-11-20 07:23:11
4991	8	55	2025-11-20 07:23:11
4992	9	1.8572825024437947	2025-11-20 07:23:11
4993	10	24	2025-11-20 07:23:11
4994	7	25.3	2025-11-20 07:23:25
4995	8	55	2025-11-20 07:23:25
4996	9	0.09775171065493282	2025-11-20 07:23:25
4997	10	24	2025-11-20 07:23:25
4998	7	25.3	2025-11-20 07:23:39
4999	8	55	2025-11-20 07:23:39
5000	9	0	2025-11-20 07:23:39
5001	10	25	2025-11-20 07:23:39
5002	7	25.3	2025-11-20 07:24:01
5003	8	55	2025-11-20 07:24:01
5004	9	0.09775171065493282	2025-11-20 07:24:01
5005	10	26	2025-11-20 07:24:01
5006	7	25.7	2025-11-20 07:24:17
5007	8	56	2025-11-20 07:24:17
5008	9	0.09775171065493282	2025-11-20 07:24:17
5009	10	21	2025-11-20 07:24:17
5010	7	25.7	2025-11-20 07:24:28
5011	8	56	2025-11-20 07:24:28
5012	9	0	2025-11-20 07:24:28
5013	10	22	2025-11-20 07:24:28
5014	7	25.7	2025-11-20 07:24:45
5015	8	55	2025-11-20 07:24:45
5016	9	0	2025-11-20 07:24:45
5017	10	18	2025-11-20 07:24:45
5018	7	25.7	2025-11-20 07:25:00
5019	8	55	2025-11-20 07:25:00
5020	9	1.8572825024437947	2025-11-20 07:25:00
5021	10	22	2025-11-20 07:25:00
5022	7	25.8	2025-11-20 07:25:09
5023	8	55	2025-11-20 07:25:09
5024	9	1.1730205278592365	2025-11-20 07:25:09
5025	10	22	2025-11-20 07:25:09
5026	7	25.8	2025-11-20 07:25:24
5027	8	55	2025-11-20 07:25:24
5028	9	0	2025-11-20 07:25:24
5029	10	16	2025-11-20 07:25:24
5030	7	25.8	2025-11-20 07:25:33
5031	8	55	2025-11-20 07:25:33
5032	9	0.09775171065493282	2025-11-20 07:25:33
5033	10	11	2025-11-20 07:25:33
5034	7	25.8	2025-11-20 07:25:48
5035	8	55	2025-11-20 07:25:48
5036	9	0	2025-11-20 07:25:48
5037	10	10	2025-11-20 07:25:48
5038	7	25.8	2025-11-20 07:26:03
5039	8	55	2025-11-20 07:26:03
5040	9	0	2025-11-20 07:26:03
5041	10	11	2025-11-20 07:26:03
5042	7	25.8	2025-11-20 07:26:13
5043	8	55	2025-11-20 07:26:13
5044	9	0	2025-11-20 07:26:13
5045	10	10	2025-11-20 07:26:13
5046	7	25.8	2025-11-20 07:26:28
5047	8	55	2025-11-20 07:26:28
5048	9	0	2025-11-20 07:26:28
5049	10	11	2025-11-20 07:26:28
5050	7	25.8	2025-11-20 07:26:43
5051	8	55	2025-11-20 07:26:43
5052	9	0	2025-11-20 07:26:43
5053	10	10	2025-11-20 07:26:43
5054	7	25.8	2025-11-20 07:26:57
5055	8	55	2025-11-20 07:26:57
5056	9	0.09775171065493282	2025-11-20 07:26:57
5057	10	11	2025-11-20 07:26:57
5058	7	25.8	2025-11-20 07:27:09
5059	8	55	2025-11-20 07:27:09
5060	9	0	2025-11-20 07:27:09
5061	10	10	2025-11-20 07:27:09
5062	7	25.8	2025-11-20 07:27:19
5063	8	56	2025-11-20 07:27:19
5064	9	0.09775171065493282	2025-11-20 07:27:19
5065	10	11	2025-11-20 07:27:19
5066	7	25.8	2025-11-20 07:27:33
5067	8	56	2025-11-20 07:27:33
5068	9	0.09775171065493282	2025-11-20 07:27:33
5069	10	10	2025-11-20 07:27:33
5070	7	25.8	2025-11-20 07:27:43
5071	8	56	2025-11-20 07:27:43
5072	9	0	2025-11-20 07:27:43
5073	10	11	2025-11-20 07:27:43
5074	7	25.8	2025-11-20 07:27:57
5075	8	56	2025-11-20 07:27:57
5076	9	0	2025-11-20 07:27:57
5077	10	10	2025-11-20 07:27:57
5078	7	25.8	2025-11-20 07:28:12
5079	8	56	2025-11-20 07:28:12
5080	9	0	2025-11-20 07:28:12
5081	10	11	2025-11-20 07:28:12
5082	7	25.8	2025-11-20 07:28:21
5083	8	56	2025-11-20 07:28:21
5084	9	0	2025-11-20 07:28:21
5085	10	10	2025-11-20 07:28:21
5086	7	25.8	2025-11-20 07:28:30
5087	8	56	2025-11-20 07:28:30
5088	9	0	2025-11-20 07:28:30
5089	10	11	2025-11-20 07:28:30
5090	7	25.8	2025-11-20 07:28:40
5091	8	56	2025-11-20 07:28:40
5092	9	0	2025-11-20 07:28:40
5093	10	10	2025-11-20 07:28:40
5094	7	25.8	2025-11-20 07:28:55
5095	8	56	2025-11-20 07:28:55
5096	9	0	2025-11-20 07:28:55
5097	10	11	2025-11-20 07:28:55
5098	7	25.8	2025-11-20 07:29:09
5099	8	56	2025-11-20 07:29:09
5100	9	0	2025-11-20 07:29:09
5101	10	10	2025-11-20 07:29:09
5102	7	25.8	2025-11-20 07:29:17
5103	8	56	2025-11-20 07:29:17
5104	9	0.09775171065493282	2025-11-20 07:29:17
5105	10	11	2025-11-20 07:29:17
5106	7	25.8	2025-11-20 07:29:30
5107	8	56	2025-11-20 07:29:30
5108	9	0.09775171065493282	2025-11-20 07:29:30
5109	10	10	2025-11-20 07:29:30
5110	7	25.8	2025-11-20 07:29:45
5111	8	56	2025-11-20 07:29:45
5112	9	0.09775171065493282	2025-11-20 07:29:45
5113	10	11	2025-11-20 07:29:45
5114	7	25.8	2025-11-20 07:29:58
5115	8	56	2025-11-20 07:29:58
5116	9	0	2025-11-20 07:29:58
5117	10	10	2025-11-20 07:29:58
5118	7	25.8	2025-11-20 07:30:17
5119	8	56	2025-11-20 07:30:17
5120	9	0.09775171065493282	2025-11-20 07:30:17
5121	10	11	2025-11-20 07:30:17
5122	7	25.8	2025-11-20 07:30:32
5123	8	56	2025-11-20 07:30:32
5124	9	0	2025-11-20 07:30:32
5125	10	10	2025-11-20 07:30:32
5126	7	26.2	2025-11-20 07:30:46
5127	8	58	2025-11-20 07:30:46
5128	9	0	2025-11-20 07:30:46
5129	10	12	2025-11-20 07:30:46
5130	7	26.2	2025-11-20 07:31:02
5131	8	58	2025-11-20 07:31:02
5132	9	0.09775171065493282	2025-11-20 07:31:02
5133	10	12	2025-11-20 07:31:02
5134	7	26.2	2025-11-20 07:31:13
5135	8	58	2025-11-20 07:31:13
5136	9	0	2025-11-20 07:31:13
5137	10	12	2025-11-20 07:31:13
5138	7	26.2	2025-11-20 07:31:28
5139	8	58	2025-11-20 07:31:28
5140	9	0.09775171065493282	2025-11-20 07:31:28
5141	10	12	2025-11-20 07:31:28
5142	7	26.2	2025-11-20 07:31:43
5143	8	58	2025-11-20 07:31:43
5144	9	1.1730205278592365	2025-11-20 07:31:43
5145	10	13	2025-11-20 07:31:43
5146	7	26.2	2025-11-20 07:31:57
5147	8	58	2025-11-20 07:31:57
5148	9	0.2932551319648127	2025-11-20 07:31:57
5149	10	12	2025-11-20 07:31:57
5150	7	26.2	2025-11-20 07:32:12
5151	8	58	2025-11-20 07:32:12
5152	9	0.3910068426197455	2025-11-20 07:32:12
5153	10	13	2025-11-20 07:32:12
5154	7	26.2	2025-11-20 07:32:25
5155	8	58	2025-11-20 07:32:25
5156	9	0	2025-11-20 07:32:25
5157	10	13	2025-11-20 07:32:25
5158	7	26.2	2025-11-20 07:32:39
5159	8	58	2025-11-20 07:32:39
5160	9	0.09775171065493282	2025-11-20 07:32:39
5161	10	13	2025-11-20 07:32:39
5162	7	26.2	2025-11-20 07:32:49
5163	8	58	2025-11-20 07:32:49
5164	9	0	2025-11-20 07:32:49
5165	10	13	2025-11-20 07:32:49
5166	7	26.2	2025-11-20 07:33:06
5167	8	58	2025-11-20 07:33:06
5168	9	0	2025-11-20 07:33:06
5169	10	12	2025-11-20 07:33:06
5170	7	26.2	2025-11-20 07:33:20
5171	8	58	2025-11-20 07:33:20
5172	9	0.09775171065493282	2025-11-20 07:33:20
5173	10	13	2025-11-20 07:33:20
5174	7	26.2	2025-11-20 07:33:36
5175	8	58	2025-11-20 07:33:36
5176	9	0	2025-11-20 07:33:36
5177	10	12	2025-11-20 07:33:36
5178	7	26.2	2025-11-20 07:33:46
5179	8	58	2025-11-20 07:33:46
5180	9	0	2025-11-20 07:33:46
5181	10	13	2025-11-20 07:33:46
5182	7	26.2	2025-11-20 07:34:01
5183	8	58	2025-11-20 07:34:01
5184	9	0	2025-11-20 07:34:01
5185	10	12	2025-11-20 07:34:01
5186	7	26.2	2025-11-20 07:34:15
5187	8	58	2025-11-20 07:34:15
5188	9	0.09775171065493282	2025-11-20 07:34:15
5189	10	13	2025-11-20 07:34:15
5190	7	26.2	2025-11-20 07:34:29
5191	8	58	2025-11-20 07:34:29
5192	9	0.09775171065493282	2025-11-20 07:34:29
5193	10	14	2025-11-20 07:34:29
5194	7	26.2	2025-11-20 07:34:43
5195	8	58	2025-11-20 07:34:43
5196	9	0.5865102639296254	2025-11-20 07:34:43
5197	10	13	2025-11-20 07:34:43
5198	7	26.2	2025-11-20 07:34:58
5199	8	58	2025-11-20 07:34:58
5200	9	0.3910068426197455	2025-11-20 07:34:58
5201	10	13	2025-11-20 07:34:58
5202	7	26.2	2025-11-20 07:35:14
5203	8	58	2025-11-20 07:35:14
5204	9	0	2025-11-20 07:35:14
5205	10	12	2025-11-20 07:35:14
5206	7	26.2	2025-11-20 07:35:28
5207	8	58	2025-11-20 07:35:28
5208	9	0	2025-11-20 07:35:28
5209	10	12	2025-11-20 07:35:28
5210	7	26.2	2025-11-20 07:35:42
5211	8	58	2025-11-20 07:35:42
5212	9	0	2025-11-20 07:35:42
5213	10	12	2025-11-20 07:35:42
5214	7	26.2	2025-11-20 07:35:51
5215	8	58	2025-11-20 07:35:51
5216	9	0.09775171065493282	2025-11-20 07:35:51
5217	10	12	2025-11-20 07:35:51
5218	7	26.2	2025-11-20 07:36:00
5219	8	58	2025-11-20 07:36:00
5220	9	0	2025-11-20 07:36:00
5221	10	12	2025-11-20 07:36:00
5222	7	26.2	2025-11-20 07:36:09
5223	8	58	2025-11-20 07:36:09
5224	9	0	2025-11-20 07:36:09
5225	10	12	2025-11-20 07:36:09
5226	7	26.2	2025-11-20 07:36:18
5227	8	58	2025-11-20 07:36:18
5228	9	0.09775171065493282	2025-11-20 07:36:18
5229	10	12	2025-11-20 07:36:18
5230	7	26.2	2025-11-20 07:36:33
5231	8	58	2025-11-20 07:36:33
5232	9	0	2025-11-20 07:36:33
5233	10	12	2025-11-20 07:36:33
5234	7	26.2	2025-11-20 07:36:42
5235	8	58	2025-11-20 07:36:42
5236	9	0.09775171065493282	2025-11-20 07:36:42
5237	10	12	2025-11-20 07:36:42
5238	7	26.2	2025-11-20 07:36:58
5239	8	58	2025-11-20 07:36:58
5240	9	0.09775171065493282	2025-11-20 07:36:58
5241	10	13	2025-11-20 07:36:58
5242	7	26.2	2025-11-20 07:37:12
5243	8	58	2025-11-20 07:37:12
5244	9	0.09775171065493282	2025-11-20 07:37:12
5245	10	13	2025-11-20 07:37:12
5246	7	26.2	2025-11-20 07:37:21
5247	8	58	2025-11-20 07:37:21
5248	9	0	2025-11-20 07:37:21
5249	10	13	2025-11-20 07:37:21
5250	7	26.2	2025-11-20 07:37:36
5251	8	58	2025-11-20 07:37:36
5252	9	0	2025-11-20 07:37:36
5253	10	12	2025-11-20 07:37:36
5254	7	26.2	2025-11-20 07:37:45
5255	8	58	2025-11-20 07:37:45
5256	9	0	2025-11-20 07:37:45
5257	10	12	2025-11-20 07:37:45
5258	7	26.5	2025-11-20 07:37:55
5259	8	57	2025-11-20 07:37:55
5260	9	8.602150537634415	2025-11-20 07:37:55
5261	10	10	2025-11-20 07:37:55
5262	7	26.5	2025-11-20 07:38:09
5263	8	57	2025-11-20 07:38:09
5264	9	8.602150537634415	2025-11-20 07:38:09
5265	10	10	2025-11-20 07:38:09
5266	7	26.5	2025-11-20 07:38:24
5267	8	57	2025-11-20 07:38:24
5268	9	8.504398826979468	2025-11-20 07:38:24
5269	10	10	2025-11-20 07:38:24
5270	7	26.5	2025-11-20 07:38:33
5271	8	57	2025-11-20 07:38:33
5272	9	8.504398826979468	2025-11-20 07:38:33
5273	10	10	2025-11-20 07:38:33
5274	7	26.5	2025-11-20 07:38:42
5275	8	57	2025-11-20 07:38:42
5276	9	8.504398826979468	2025-11-20 07:38:42
5277	10	10	2025-11-20 07:38:42
5278	7	26.5	2025-11-20 07:38:59
5279	8	57	2025-11-20 07:38:59
5280	9	8.504398826979468	2025-11-20 07:38:59
5281	10	10	2025-11-20 07:38:59
5282	7	26.6	2025-11-20 07:39:12
5283	8	57	2025-11-20 07:39:12
5284	9	8.504398826979468	2025-11-20 07:39:12
5285	10	10	2025-11-20 07:39:12
5286	7	26.6	2025-11-20 07:39:27
5287	8	57	2025-11-20 07:39:27
5288	9	8.504398826979468	2025-11-20 07:39:27
5289	10	10	2025-11-20 07:39:27
5290	7	26.6	2025-11-20 07:39:37
5291	8	57	2025-11-20 07:39:37
5292	9	8.602150537634415	2025-11-20 07:39:37
5293	10	10	2025-11-20 07:39:37
5294	7	26.6	2025-11-20 07:39:51
5295	8	57	2025-11-20 07:39:51
5296	9	8.602150537634415	2025-11-20 07:39:51
5297	10	10	2025-11-20 07:39:51
5298	7	26.6	2025-11-20 07:40:05
5299	8	57	2025-11-20 07:40:05
5300	9	8.602150537634415	2025-11-20 07:40:05
5301	10	10	2025-11-20 07:40:05
5302	7	26.6	2025-11-20 07:40:20
5303	8	57	2025-11-20 07:40:20
5304	9	8.602150537634415	2025-11-20 07:40:20
5305	10	10	2025-11-20 07:40:20
5306	7	26.6	2025-11-20 07:40:35
5307	8	57	2025-11-20 07:40:35
5308	9	8.602150537634415	2025-11-20 07:40:35
5309	10	10	2025-11-20 07:40:35
5310	7	26.6	2025-11-20 07:40:49
5311	8	57	2025-11-20 07:40:49
5312	9	8.602150537634415	2025-11-20 07:40:49
5313	10	10	2025-11-20 07:40:49
5314	7	26.6	2025-11-20 07:41:03
5315	8	57	2025-11-20 07:41:03
5316	9	8.504398826979468	2025-11-20 07:41:03
5317	10	10	2025-11-20 07:41:03
5318	7	26.6	2025-11-20 07:41:17
5319	8	57	2025-11-20 07:41:17
5320	9	8.602150537634415	2025-11-20 07:41:17
5321	10	10	2025-11-20 07:41:17
5322	7	26.6	2025-11-20 07:41:31
5323	8	57	2025-11-20 07:41:31
5324	9	8.504398826979468	2025-11-20 07:41:31
5325	10	10	2025-11-20 07:41:31
5326	7	26.6	2025-11-20 07:41:45
5327	8	57	2025-11-20 07:41:45
5328	9	8.504398826979468	2025-11-20 07:41:45
5329	10	10	2025-11-20 07:41:45
5330	7	26.7	2025-11-20 07:41:54
5331	8	57	2025-11-20 07:41:54
5332	9	8.504398826979468	2025-11-20 07:41:54
5333	10	10	2025-11-20 07:41:54
5334	7	26.7	2025-11-20 07:42:03
5335	8	57	2025-11-20 07:42:03
5336	9	8.504398826979468	2025-11-20 07:42:03
5337	10	10	2025-11-20 07:42:03
5338	7	26.6	2025-11-20 07:42:18
5339	8	57	2025-11-20 07:42:18
5340	9	8.504398826979468	2025-11-20 07:42:18
5341	10	10	2025-11-20 07:42:18
5342	7	26.6	2025-11-20 07:42:32
5343	8	57	2025-11-20 07:42:32
5344	9	8.504398826979468	2025-11-20 07:42:32
5345	10	10	2025-11-20 07:42:32
5346	7	26.6	2025-11-20 07:42:42
5347	8	57	2025-11-20 07:42:42
5348	9	8.602150537634415	2025-11-20 07:42:42
5349	10	10	2025-11-20 07:42:42
5350	7	26.6	2025-11-20 07:42:51
5351	8	57	2025-11-20 07:42:51
5352	9	8.504398826979468	2025-11-20 07:42:51
5353	10	10	2025-11-20 07:42:51
5354	7	26.7	2025-11-20 07:43:05
5355	8	57	2025-11-20 07:43:05
5356	9	8.602150537634415	2025-11-20 07:43:05
5357	10	10	2025-11-20 07:43:05
5358	7	26.7	2025-11-20 07:43:15
5359	8	57	2025-11-20 07:43:15
5360	9	8.602150537634415	2025-11-20 07:43:15
5361	10	10	2025-11-20 07:43:15
5362	7	26.7	2025-11-20 07:43:24
5363	8	57	2025-11-20 07:43:24
5364	9	8.602150537634415	2025-11-20 07:43:24
5365	10	10	2025-11-20 07:43:24
5366	7	26.7	2025-11-20 07:43:39
5367	8	57	2025-11-20 07:43:39
5368	9	8.602150537634415	2025-11-20 07:43:39
5369	10	10	2025-11-20 07:43:39
5370	7	26.7	2025-11-20 07:43:48
5371	8	57	2025-11-20 07:43:48
5372	9	8.602150537634415	2025-11-20 07:43:48
5373	10	10	2025-11-20 07:43:48
5374	7	26.7	2025-11-20 07:43:57
5375	8	57	2025-11-20 07:43:57
5376	9	8.602150537634415	2025-11-20 07:43:57
5377	10	10	2025-11-20 07:43:57
5378	7	26.7	2025-11-20 07:44:07
5379	8	57	2025-11-20 07:44:07
5380	9	8.504398826979468	2025-11-20 07:44:07
5381	10	10	2025-11-20 07:44:07
5382	7	26.7	2025-11-20 07:44:21
5383	8	57	2025-11-20 07:44:21
5384	9	8.602150537634415	2025-11-20 07:44:21
5385	10	10	2025-11-20 07:44:21
5386	7	26.7	2025-11-20 07:44:31
5387	8	56	2025-11-20 07:44:31
5388	9	9.481915933528839	2025-11-20 07:44:31
5389	10	9	2025-11-20 07:44:31
5390	7	26.7	2025-11-20 07:44:45
5391	8	56	2025-11-20 07:44:45
5392	9	9.481915933528839	2025-11-20 07:44:45
5393	10	9	2025-11-20 07:44:45
5394	7	26.7	2025-11-20 07:44:54
5395	8	56	2025-11-20 07:44:54
5396	9	9.481915933528839	2025-11-20 07:44:54
5397	10	17	2025-11-20 07:44:54
5398	7	26.7	2025-11-20 07:45:09
5399	8	56	2025-11-20 07:45:09
5400	9	6.451612903225808	2025-11-20 07:45:09
5401	10	22	2025-11-20 07:45:09
5402	7	26.7	2025-11-20 07:45:18
5403	8	56	2025-11-20 07:45:18
5404	9	5.8651026392961825	2025-11-20 07:45:18
5405	10	10	2025-11-20 07:45:18
5406	7	26.7	2025-11-20 07:45:34
5407	8	56	2025-11-20 07:45:34
5408	9	0	2025-11-20 07:45:34
5409	10	14	2025-11-20 07:45:34
5410	7	26.7	2025-11-20 07:45:49
5411	8	56	2025-11-20 07:45:49
5412	9	3.910068426197455	2025-11-20 07:45:49
5413	10	14	2025-11-20 07:45:49
5414	7	26.7	2025-11-20 07:46:04
5415	8	56	2025-11-20 07:46:04
5416	9	4.007820136852402	2025-11-20 07:46:04
5417	10	14	2025-11-20 07:46:04
5418	7	26.7	2025-11-20 07:46:18
5419	8	56	2025-11-20 07:46:18
5420	9	4.007820136852402	2025-11-20 07:46:18
5421	10	12	2025-11-20 07:46:18
5422	7	26.7	2025-11-20 07:46:33
5423	8	56	2025-11-20 07:46:33
5424	9	4.105571847507335	2025-11-20 07:46:33
5425	10	22	2025-11-20 07:46:33
5426	7	26.7	2025-11-20 07:46:44
5427	8	56	2025-11-20 07:46:44
5428	9	4.007820136852402	2025-11-20 07:46:44
5429	10	23	2025-11-20 07:46:44
5430	7	26.7	2025-11-20 07:46:59
5431	8	56	2025-11-20 07:46:59
5432	9	4.3010752688172005	2025-11-20 07:46:59
5433	10	23	2025-11-20 07:46:59
5434	7	26.7	2025-11-20 07:47:15
5435	8	56	2025-11-20 07:47:15
5436	9	4.203323558162268	2025-11-20 07:47:15
5437	10	21	2025-11-20 07:47:15
5438	7	26.7	2025-11-20 07:47:28
5439	8	56	2025-11-20 07:47:28
5440	9	4.3010752688172005	2025-11-20 07:47:28
5441	10	19	2025-11-20 07:47:28
5442	7	26.7	2025-11-20 07:47:43
5443	8	56	2025-11-20 07:47:43
5444	9	4.3988269794721475	2025-11-20 07:47:43
5445	10	18	2025-11-20 07:47:43
5446	7	26.7	2025-11-20 07:47:57
5447	8	56	2025-11-20 07:47:57
5448	9	4.3010752688172005	2025-11-20 07:47:57
5449	10	16	2025-11-20 07:47:57
5450	7	26.7	2025-11-20 07:48:06
5451	8	56	2025-11-20 07:48:06
5452	9	4.3988269794721475	2025-11-20 07:48:06
5453	10	10	2025-11-20 07:48:06
5454	7	26.7	2025-11-20 07:48:17
5455	8	56	2025-11-20 07:48:17
5456	9	4.3988269794721475	2025-11-20 07:48:17
5457	10	10	2025-11-20 07:48:17
5458	7	26.7	2025-11-20 07:48:32
5459	8	56	2025-11-20 07:48:32
5460	9	4.49657869012708	2025-11-20 07:48:32
5461	10	9	2025-11-20 07:48:32
5462	7	26.7	2025-11-20 07:48:47
5463	8	56	2025-11-20 07:48:47
5464	9	4.49657869012708	2025-11-20 07:48:47
5465	10	16	2025-11-20 07:48:47
5466	7	26.7	2025-11-20 07:49:01
5467	8	56	2025-11-20 07:49:01
5468	9	4.594330400782013	2025-11-20 07:49:01
5469	10	12	2025-11-20 07:49:01
5470	7	26.7	2025-11-20 07:49:16
5471	8	56	2025-11-20 07:49:16
5472	9	4.3988269794721475	2025-11-20 07:49:16
5473	10	14	2025-11-20 07:49:16
5474	7	26.7	2025-11-20 07:49:30
5475	8	56	2025-11-20 07:49:30
5476	9	4.49657869012708	2025-11-20 07:49:30
5477	10	13	2025-11-20 07:49:30
5478	7	26.7	2025-11-20 07:49:40
5479	8	57	2025-11-20 07:49:40
5480	9	4.3988269794721475	2025-11-20 07:49:40
5481	10	18	2025-11-20 07:49:40
5482	7	26.7	2025-11-20 07:49:54
5483	8	57	2025-11-20 07:49:54
5484	9	4.3988269794721475	2025-11-20 07:49:54
5485	10	9	2025-11-20 07:49:54
5486	7	26.7	2025-11-20 07:50:09
5487	8	58	2025-11-20 07:50:09
5488	9	4.3988269794721475	2025-11-20 07:50:09
5489	10	9	2025-11-20 07:50:09
5490	7	26.7	2025-11-20 07:50:18
5491	8	58	2025-11-20 07:50:18
5492	9	4.3988269794721475	2025-11-20 07:50:18
5493	10	9	2025-11-20 07:50:18
5494	7	26.7	2025-11-20 07:50:32
5495	8	58	2025-11-20 07:50:32
5496	9	4.3988269794721475	2025-11-20 07:50:32
5497	10	10	2025-11-20 07:50:32
5498	7	26.7	2025-11-20 07:50:46
5499	8	58	2025-11-20 07:50:46
5500	9	4.3988269794721475	2025-11-20 07:50:46
5501	10	9	2025-11-20 07:50:46
5502	7	27.1	2025-11-20 07:51:02
5503	8	58	2025-11-20 07:51:02
5504	9	4.49657869012708	2025-11-20 07:51:02
5505	10	9	2025-11-20 07:51:02
5506	7	27.1	2025-11-20 07:51:16
5507	8	58	2025-11-20 07:51:16
5508	9	4.49657869012708	2025-11-20 07:51:16
5509	10	9	2025-11-20 07:51:16
5510	7	27.1	2025-11-20 07:51:30
5511	8	58	2025-11-20 07:51:30
5512	9	4.594330400782013	2025-11-20 07:51:30
5513	10	9	2025-11-20 07:51:30
5514	7	27.1	2025-11-20 07:51:45
5515	8	58	2025-11-20 07:51:45
5516	9	4.594330400782013	2025-11-20 07:51:45
5517	10	9	2025-11-20 07:51:45
5518	7	27.1	2025-11-20 07:52:00
5519	8	54	2025-11-20 07:52:00
5520	9	5.669599217986317	2025-11-20 07:52:00
5521	10	13	2025-11-20 07:52:00
5522	7	27.1	2025-11-20 07:52:10
5523	8	54	2025-11-20 07:52:10
5524	9	5.76735092864125	2025-11-20 07:52:10
5525	10	13	2025-11-20 07:52:10
5526	7	27.1	2025-11-20 07:52:24
5527	8	54	2025-11-20 07:52:24
5528	9	5.76735092864125	2025-11-20 07:52:24
5529	10	13	2025-11-20 07:52:24
5530	7	27.1	2025-11-20 07:52:33
5531	8	54	2025-11-20 07:52:33
5532	9	5.76735092864125	2025-11-20 07:52:33
5533	10	13	2025-11-20 07:52:33
5534	7	27.1	2025-11-20 07:52:48
5535	8	54	2025-11-20 07:52:48
5536	9	5.76735092864125	2025-11-20 07:52:48
5537	10	13	2025-11-20 07:52:48
5538	7	27.1	2025-11-20 07:52:58
5539	8	54	2025-11-20 07:52:58
5540	9	5.76735092864125	2025-11-20 07:52:58
5541	10	13	2025-11-20 07:52:58
5542	7	27.1	2025-11-20 07:53:12
5543	8	54	2025-11-20 07:53:12
5544	9	5.76735092864125	2025-11-20 07:53:12
5545	10	13	2025-11-20 07:53:12
5546	7	27.1	2025-11-20 07:53:21
5547	8	54	2025-11-20 07:53:21
5548	9	5.76735092864125	2025-11-20 07:53:21
5549	10	13	2025-11-20 07:53:21
5550	7	27.1	2025-11-20 07:53:36
5551	8	54	2025-11-20 07:53:36
5552	9	5.76735092864125	2025-11-20 07:53:36
5553	10	13	2025-11-20 07:53:36
5554	7	27.1	2025-11-20 07:53:51
5555	8	54	2025-11-20 07:53:51
5556	9	5.8651026392961825	2025-11-20 07:53:51
5557	10	13	2025-11-20 07:53:51
5558	7	27.1	2025-11-20 07:54:00
5559	8	54	2025-11-20 07:54:00
5560	9	5.76735092864125	2025-11-20 07:54:00
5561	10	13	2025-11-20 07:54:00
5562	7	27.1	2025-11-20 07:54:15
5563	8	54	2025-11-20 07:54:15
5564	9	5.76735092864125	2025-11-20 07:54:15
5565	10	13	2025-11-20 07:54:15
5566	7	27.1	2025-11-20 07:54:30
5567	8	54	2025-11-20 07:54:30
5568	9	5.76735092864125	2025-11-20 07:54:30
5569	10	13	2025-11-20 07:54:30
5570	7	27.1	2025-11-20 07:54:45
5571	8	54	2025-11-20 07:54:45
5572	9	5.76735092864125	2025-11-20 07:54:45
5573	10	13	2025-11-20 07:54:45
5574	7	27.1	2025-11-20 07:54:54
5575	8	54	2025-11-20 07:54:54
5576	9	5.76735092864125	2025-11-20 07:54:54
5577	10	13	2025-11-20 07:54:54
5578	7	27.1	2025-11-20 07:55:03
5579	8	54	2025-11-20 07:55:03
5580	9	5.8651026392961825	2025-11-20 07:55:03
5581	10	13	2025-11-20 07:55:03
5582	7	27.1	2025-11-20 07:55:18
5583	8	54	2025-11-20 07:55:18
5584	9	5.76735092864125	2025-11-20 07:55:18
5585	10	13	2025-11-20 07:55:18
5586	7	27.1	2025-11-20 07:55:28
5587	8	54	2025-11-20 07:55:28
5588	9	5.8651026392961825	2025-11-20 07:55:28
5589	10	13	2025-11-20 07:55:28
5590	7	27.1	2025-11-20 07:55:42
5591	8	54	2025-11-20 07:55:42
5592	9	5.8651026392961825	2025-11-20 07:55:42
5593	10	13	2025-11-20 07:55:42
5594	7	27.1	2025-11-20 07:55:52
5595	8	54	2025-11-20 07:55:52
5596	9	5.8651026392961825	2025-11-20 07:55:52
5597	10	13	2025-11-20 07:55:52
5598	7	27.1	2025-11-20 07:56:06
5599	8	54	2025-11-20 07:56:06
5600	9	5.76735092864125	2025-11-20 07:56:06
5601	10	13	2025-11-20 07:56:06
5602	7	27.1	2025-11-20 07:56:20
5603	8	54	2025-11-20 07:56:20
5604	9	5.8651026392961825	2025-11-20 07:56:20
5605	10	13	2025-11-20 07:56:20
5606	7	27.1	2025-11-20 07:56:30
5607	8	54	2025-11-20 07:56:30
5608	9	5.8651026392961825	2025-11-20 07:56:30
5609	10	13	2025-11-20 07:56:30
5610	7	27.1	2025-11-20 07:56:45
5611	8	54	2025-11-20 07:56:45
5612	9	5.8651026392961825	2025-11-20 07:56:45
5613	10	14	2025-11-20 07:56:45
5614	7	27.1	2025-11-20 07:56:54
5615	8	54	2025-11-20 07:56:54
5616	9	5.8651026392961825	2025-11-20 07:56:54
5617	10	13	2025-11-20 07:56:54
5618	7	27.1	2025-11-20 07:57:08
5619	8	54	2025-11-20 07:57:08
5620	9	5.8651026392961825	2025-11-20 07:57:08
5621	10	13	2025-11-20 07:57:08
5622	7	27.1	2025-11-20 07:57:18
5623	8	54	2025-11-20 07:57:18
5624	9	5.9628543499511295	2025-11-20 07:57:18
5625	10	13	2025-11-20 07:57:18
5626	7	27.1	2025-11-20 07:57:27
5627	8	54	2025-11-20 07:57:27
5628	9	5.8651026392961825	2025-11-20 07:57:27
5629	10	13	2025-11-20 07:57:27
5630	7	27.1	2025-11-20 07:57:36
5631	8	54	2025-11-20 07:57:36
5632	9	5.8651026392961825	2025-11-20 07:57:36
5633	10	13	2025-11-20 07:57:36
5634	7	27.1	2025-11-20 07:57:51
5635	8	54	2025-11-20 07:57:51
5636	9	5.9628543499511295	2025-11-20 07:57:51
5637	10	13	2025-11-20 07:57:51
5638	7	27.1	2025-11-20 07:58:05
5639	8	54	2025-11-20 07:58:05
5640	9	5.9628543499511295	2025-11-20 07:58:05
5641	10	13	2025-11-20 07:58:05
5642	7	27.1	2025-11-20 07:58:19
5643	8	54	2025-11-20 07:58:19
5644	9	5.8651026392961825	2025-11-20 07:58:19
5645	10	13	2025-11-20 07:58:19
5646	7	27.1	2025-11-20 07:58:34
5647	8	54	2025-11-20 07:58:34
5648	9	5.8651026392961825	2025-11-20 07:58:34
5649	10	12	2025-11-20 07:58:34
5650	7	27.1	2025-11-20 07:59:03
5651	8	54	2025-11-20 07:59:03
5652	9	0.09775171065493282	2025-11-20 07:59:03
5653	10	10	2025-11-20 07:59:03
5654	7	27.1	2025-11-20 07:59:18
5655	8	54	2025-11-20 07:59:18
5656	9	0.09775171065493282	2025-11-20 07:59:18
5657	10	10	2025-11-20 07:59:18
5658	7	27.1	2025-11-20 07:59:27
5659	8	54	2025-11-20 07:59:27
5660	9	0.09775171065493282	2025-11-20 07:59:27
5661	10	10	2025-11-20 07:59:27
5662	7	27.1	2025-11-20 07:59:42
5663	8	54	2025-11-20 07:59:42
5664	9	0	2025-11-20 07:59:42
5665	10	10	2025-11-20 07:59:42
5666	7	27.1	2025-11-20 08:00:01
5667	8	54	2025-11-20 08:00:01
5668	9	0.09775171065493282	2025-11-20 08:00:01
5669	10	10	2025-11-20 08:00:01
5670	7	27.1	2025-11-20 08:00:16
5671	8	54	2025-11-20 08:00:16
5672	9	0.09775171065493282	2025-11-20 08:00:16
5673	10	10	2025-11-20 08:00:16
5674	7	27.1	2025-11-20 08:00:32
5675	8	54	2025-11-20 08:00:32
5676	9	0.09775171065493282	2025-11-20 08:00:32
5677	10	10	2025-11-20 08:00:32
5678	7	27.1	2025-11-20 08:00:46
5679	8	54	2025-11-20 08:00:46
5680	9	0.09775171065493282	2025-11-20 08:00:46
5681	10	10	2025-11-20 08:00:46
5682	7	27.1	2025-11-20 08:01:00
5683	8	54	2025-11-20 08:01:00
5684	9	0	2025-11-20 08:01:00
5685	10	10	2025-11-20 08:01:00
5686	7	27.1	2025-11-20 08:01:15
5687	8	54	2025-11-20 08:01:15
5688	9	0.09775171065493282	2025-11-20 08:01:15
5689	10	10	2025-11-20 08:01:15
5690	7	27.1	2025-11-20 08:01:25
5691	8	54	2025-11-20 08:01:25
5692	9	0.09775171065493282	2025-11-20 08:01:25
5693	10	10	2025-11-20 08:01:25
5694	7	27.1	2025-11-20 08:01:38
5695	8	54	2025-11-20 08:01:38
5696	9	0.09775171065493282	2025-11-20 08:01:38
5697	10	10	2025-11-20 08:01:38
5698	7	27.1	2025-11-20 08:01:48
5699	8	54	2025-11-20 08:01:48
5700	9	0.09775171065493282	2025-11-20 08:01:48
5701	10	10	2025-11-20 08:01:48
5702	7	27.1	2025-11-20 08:02:03
5703	8	54	2025-11-20 08:02:03
5704	9	0.09775171065493282	2025-11-20 08:02:03
5705	10	10	2025-11-20 08:02:03
5706	7	27.1	2025-11-20 08:02:24
5707	8	54	2025-11-20 08:02:24
5708	9	0.09775171065493282	2025-11-20 08:02:24
5709	10	10	2025-11-20 08:02:24
5710	7	27.1	2025-11-20 08:02:33
5711	8	54	2025-11-20 08:02:33
5712	9	0	2025-11-20 08:02:33
5713	10	10	2025-11-20 08:02:33
5714	7	27.1	2025-11-20 08:02:48
5715	8	54	2025-11-20 08:02:48
5716	9	0.09775171065493282	2025-11-20 08:02:48
5717	10	10	2025-11-20 08:02:48
5718	7	27.1	2025-11-20 08:02:58
5719	8	54	2025-11-20 08:02:58
5720	9	0.09775171065493282	2025-11-20 08:02:58
5721	10	10	2025-11-20 08:02:58
5722	7	27.1	2025-11-20 08:03:14
5723	8	54	2025-11-20 08:03:14
5724	9	0	2025-11-20 08:03:14
5725	10	10	2025-11-20 08:03:14
5726	7	27.1	2025-11-20 08:03:28
5727	8	54	2025-11-20 08:03:28
5728	9	0.09775171065493282	2025-11-20 08:03:28
5729	10	10	2025-11-20 08:03:28
5730	7	27.1	2025-11-20 08:03:42
5731	8	54	2025-11-20 08:03:42
5732	9	0.09775171065493282	2025-11-20 08:03:42
5733	10	10	2025-11-20 08:03:42
5734	7	27.1	2025-11-20 08:03:57
5735	8	54	2025-11-20 08:03:57
5736	9	0	2025-11-20 08:03:57
5737	10	10	2025-11-20 08:03:57
5738	7	27.1	2025-11-20 08:04:12
5739	8	54	2025-11-20 08:04:12
5740	9	0.09775171065493282	2025-11-20 08:04:12
5741	10	10	2025-11-20 08:04:12
5742	7	27.1	2025-11-20 08:04:26
5743	8	54	2025-11-20 08:04:26
5744	9	0	2025-11-20 08:04:26
5745	10	10	2025-11-20 08:04:26
5746	7	27.1	2025-11-20 08:04:40
5747	8	54	2025-11-20 08:04:40
5748	9	0.09775171065493282	2025-11-20 08:04:40
5749	10	10	2025-11-20 08:04:40
5750	7	27.1	2025-11-20 08:04:55
5751	8	54	2025-11-20 08:04:55
5752	9	0.09775171065493282	2025-11-20 08:04:55
5753	10	10	2025-11-20 08:04:55
5754	7	27.1	2025-11-20 08:05:10
5755	8	54	2025-11-20 08:05:10
5756	9	0	2025-11-20 08:05:10
5757	10	10	2025-11-20 08:05:10
5758	7	27.1	2025-11-20 08:05:24
5759	8	54	2025-11-20 08:05:24
5760	9	0	2025-11-20 08:05:24
5761	10	10	2025-11-20 08:05:24
5762	7	27.1	2025-11-20 08:05:33
5763	8	54	2025-11-20 08:05:33
5764	9	0	2025-11-20 08:05:33
5765	10	10	2025-11-20 08:05:33
5766	7	27.1	2025-11-20 08:05:47
5767	8	54	2025-11-20 08:05:47
5768	9	0.09775171065493282	2025-11-20 08:05:47
5769	10	10	2025-11-20 08:05:47
5770	7	27.1	2025-11-20 08:05:57
5771	8	54	2025-11-20 08:05:57
5772	9	0.09775171065493282	2025-11-20 08:05:57
5773	10	10	2025-11-20 08:05:57
5774	7	27.1	2025-11-20 08:06:06
5775	8	54	2025-11-20 08:06:06
5776	9	0	2025-11-20 08:06:06
5777	10	10	2025-11-20 08:06:06
5778	7	27.1	2025-11-20 08:06:20
5779	8	54	2025-11-20 08:06:20
5780	9	0.09775171065493282	2025-11-20 08:06:20
5781	10	10	2025-11-20 08:06:20
5782	7	27.1	2025-11-20 08:06:35
5783	8	54	2025-11-20 08:06:35
5784	9	0.09775171065493282	2025-11-20 08:06:35
5785	10	10	2025-11-20 08:06:35
5786	7	27.1	2025-11-20 08:06:50
5787	8	54	2025-11-20 08:06:50
5788	9	0.09775171065493282	2025-11-20 08:06:50
5789	10	10	2025-11-20 08:06:50
5790	7	27.1	2025-11-20 08:07:05
5791	8	54	2025-11-20 08:07:05
5792	9	0.09775171065493282	2025-11-20 08:07:05
5793	10	10	2025-11-20 08:07:05
5794	7	27.1	2025-11-20 08:07:19
5795	8	54	2025-11-20 08:07:19
5796	9	0	2025-11-20 08:07:19
5797	10	10	2025-11-20 08:07:19
5798	7	27.1	2025-11-20 08:07:34
5799	8	54	2025-11-20 08:07:34
5800	9	0	2025-11-20 08:07:34
5801	10	10	2025-11-20 08:07:34
5802	7	27.1	2025-11-20 08:07:43
5803	8	54	2025-11-20 08:07:43
5804	9	0.09775171065493282	2025-11-20 08:07:43
5805	10	10	2025-11-20 08:07:43
5806	7	27.1	2025-11-20 08:07:51
5807	8	54	2025-11-20 08:07:51
5808	9	0.09775171065493282	2025-11-20 08:07:51
5809	10	10	2025-11-20 08:07:51
5810	7	27.1	2025-11-20 08:08:00
5811	8	54	2025-11-20 08:08:00
5812	9	0	2025-11-20 08:08:00
5813	10	10	2025-11-20 08:08:00
5814	7	27.1	2025-11-20 08:08:15
5815	8	54	2025-11-20 08:08:15
5816	9	0.09775171065493282	2025-11-20 08:08:15
5817	10	10	2025-11-20 08:08:15
5818	7	27.1	2025-11-20 08:08:24
5819	8	54	2025-11-20 08:08:24
5820	9	0.09775171065493282	2025-11-20 08:08:24
5821	10	10	2025-11-20 08:08:24
5822	7	27.1	2025-11-20 08:08:33
5823	8	54	2025-11-20 08:08:33
5824	9	0.09775171065493282	2025-11-20 08:08:33
5825	10	10	2025-11-20 08:08:33
5826	7	27.1	2025-11-20 08:08:48
5827	8	54	2025-11-20 08:08:48
5828	9	0	2025-11-20 08:08:48
5829	10	10	2025-11-20 08:08:48
5830	7	27.1	2025-11-20 08:08:57
5831	8	54	2025-11-20 08:08:57
5832	9	0	2025-11-20 08:08:57
5833	10	10	2025-11-20 08:08:57
5834	7	27.1	2025-11-20 08:09:07
5835	8	54	2025-11-20 08:09:07
5836	9	0	2025-11-20 08:09:07
5837	10	10	2025-11-20 08:09:07
5838	7	27.1	2025-11-20 08:09:21
5839	8	54	2025-11-20 08:09:21
5840	9	0.09775171065493282	2025-11-20 08:09:21
5841	10	10	2025-11-20 08:09:21
5842	7	27.1	2025-11-20 08:09:37
5843	8	54	2025-11-20 08:09:37
5844	9	0	2025-11-20 08:09:37
5845	10	10	2025-11-20 08:09:37
5846	7	27.1	2025-11-20 08:09:52
5847	8	54	2025-11-20 08:09:52
5848	9	0.09775171065493282	2025-11-20 08:09:52
5849	10	10	2025-11-20 08:09:52
5850	7	27.1	2025-11-20 08:10:07
5851	8	54	2025-11-20 08:10:07
5852	9	0.09775171065493282	2025-11-20 08:10:07
5853	10	10	2025-11-20 08:10:07
5854	7	25.3	2025-11-20 08:14:51
5855	8	54	2025-11-20 08:14:51
5856	9	9.384164222873906	2025-11-20 08:14:51
5857	10	10	2025-11-20 08:14:51
5858	7	25.3	2025-11-20 08:15:01
5859	8	54	2025-11-20 08:15:01
5860	9	9.384164222873906	2025-11-20 08:15:01
5861	10	10	2025-11-20 08:15:01
5862	7	25.3	2025-11-20 08:15:14
5863	8	54	2025-11-20 08:15:14
5864	9	9.481915933528839	2025-11-20 08:15:14
5865	10	10	2025-11-20 08:15:14
5866	7	25.3	2025-11-20 08:15:25
5867	8	54	2025-11-20 08:15:25
5868	9	9.384164222873906	2025-11-20 08:15:25
5869	10	10	2025-11-20 08:15:25
5870	7	25.3	2025-11-20 08:15:40
5871	8	54	2025-11-20 08:15:40
5872	9	9.384164222873906	2025-11-20 08:15:40
5873	10	10	2025-11-20 08:15:40
5874	7	25.3	2025-11-20 08:15:54
5875	8	54	2025-11-20 08:15:54
5876	9	9.384164222873906	2025-11-20 08:15:54
5877	10	10	2025-11-20 08:15:54
5878	7	25.3	2025-11-20 08:16:08
5879	8	54	2025-11-20 08:16:08
5880	9	9.384164222873906	2025-11-20 08:16:08
5881	10	10	2025-11-20 08:16:08
5882	7	25.3	2025-11-20 08:16:23
5883	8	54	2025-11-20 08:16:23
5884	9	9.384164222873906	2025-11-20 08:16:23
5885	10	10	2025-11-20 08:16:23
5886	7	25.3	2025-11-20 08:16:38
5887	8	54	2025-11-20 08:16:38
5888	9	9.384164222873906	2025-11-20 08:16:38
5889	10	10	2025-11-20 08:16:38
5890	7	25.3	2025-11-20 08:16:52
5891	8	54	2025-11-20 08:16:52
5892	9	9.384164222873906	2025-11-20 08:16:52
5893	10	10	2025-11-20 08:16:52
5894	7	25.3	2025-11-20 08:17:06
5895	8	54	2025-11-20 08:17:06
5896	9	9.384164222873906	2025-11-20 08:17:06
5897	10	10	2025-11-20 08:17:06
5898	7	25.3	2025-11-20 08:17:21
5899	8	54	2025-11-20 08:17:21
5900	9	9.384164222873906	2025-11-20 08:17:21
5901	10	10	2025-11-20 08:17:21
5902	7	25.3	2025-11-20 08:17:30
5903	8	54	2025-11-20 08:17:30
5904	9	9.481915933528839	2025-11-20 08:17:30
5905	10	10	2025-11-20 08:17:30
5906	7	25.3	2025-11-20 08:17:45
5907	8	54	2025-11-20 08:17:45
5908	9	9.384164222873906	2025-11-20 08:17:45
5909	10	10	2025-11-20 08:17:45
5910	7	25.3	2025-11-20 08:18:04
5911	8	54	2025-11-20 08:18:04
5912	9	9.384164222873906	2025-11-20 08:18:04
5913	10	10	2025-11-20 08:18:04
5914	7	25.3	2025-11-20 08:18:19
5915	8	54	2025-11-20 08:18:19
5916	9	9.384164222873906	2025-11-20 08:18:19
5917	10	10	2025-11-20 08:18:19
5918	7	25.3	2025-11-20 08:18:40
5919	8	54	2025-11-20 08:18:40
5920	9	9.481915933528839	2025-11-20 08:18:40
5921	10	10	2025-11-20 08:18:40
5922	7	25.3	2025-11-20 08:18:55
5923	8	54	2025-11-20 08:18:55
5924	9	9.481915933528839	2025-11-20 08:18:55
5925	10	10	2025-11-20 08:18:55
5926	7	25.3	2025-11-20 08:19:10
5927	8	54	2025-11-20 08:19:10
5928	9	9.384164222873906	2025-11-20 08:19:10
5929	10	10	2025-11-20 08:19:10
5930	7	25.3	2025-11-20 08:19:24
5931	8	54	2025-11-20 08:19:24
5932	9	9.384164222873906	2025-11-20 08:19:24
5933	10	10	2025-11-20 08:19:24
5934	7	25.3	2025-11-20 08:19:34
5935	8	54	2025-11-20 08:19:34
5936	9	9.384164222873906	2025-11-20 08:19:34
5937	10	10	2025-11-20 08:19:34
5938	7	25.3	2025-11-20 08:19:48
5939	8	54	2025-11-20 08:19:48
5940	9	9.384164222873906	2025-11-20 08:19:48
5941	10	10	2025-11-20 08:19:48
5942	7	25.3	2025-11-20 08:19:57
5943	8	54	2025-11-20 08:19:57
5944	9	9.384164222873906	2025-11-20 08:19:57
5945	10	10	2025-11-20 08:19:57
5946	7	25.3	2025-11-20 08:20:12
5947	8	54	2025-11-20 08:20:12
5948	9	9.384164222873906	2025-11-20 08:20:12
5949	10	10	2025-11-20 08:20:12
5950	7	25.3	2025-11-20 08:20:21
5951	8	54	2025-11-20 08:20:21
5952	9	9.481915933528839	2025-11-20 08:20:21
5953	10	10	2025-11-20 08:20:21
5954	7	25.3	2025-11-20 08:20:30
5955	8	54	2025-11-20 08:20:30
5956	9	9.481915933528839	2025-11-20 08:20:30
5957	10	10	2025-11-20 08:20:30
5958	7	25.3	2025-11-20 08:20:51
5959	8	55	2025-11-20 08:20:51
5960	9	9.384164222873906	2025-11-20 08:20:51
5961	10	10	2025-11-20 08:20:51
5962	7	25.3	2025-11-20 08:21:00
5963	8	55	2025-11-20 08:21:00
5964	9	9.384164222873906	2025-11-20 08:21:00
5965	10	10	2025-11-20 08:21:00
5966	7	25.3	2025-11-20 08:21:15
5967	8	55	2025-11-20 08:21:15
5968	9	9.384164222873906	2025-11-20 08:21:15
5969	10	10	2025-11-20 08:21:15
5970	7	25.3	2025-11-20 08:21:30
5971	8	55	2025-11-20 08:21:30
5972	9	9.384164222873906	2025-11-20 08:21:30
5973	10	10	2025-11-20 08:21:30
5974	7	25.3	2025-11-20 08:21:39
5975	8	55	2025-11-20 08:21:39
5976	9	9.481915933528839	2025-11-20 08:21:39
5977	10	10	2025-11-20 08:21:39
5978	7	25.3	2025-11-20 08:21:49
5979	8	55	2025-11-20 08:21:49
5980	9	9.481915933528839	2025-11-20 08:21:49
5981	10	10	2025-11-20 08:21:49
5982	7	25.3	2025-11-20 08:22:03
5983	8	55	2025-11-20 08:22:03
5984	9	9.384164222873906	2025-11-20 08:22:03
5985	10	10	2025-11-20 08:22:03
5986	7	25.3	2025-11-20 08:22:13
5987	8	55	2025-11-20 08:22:13
5988	9	9.481915933528839	2025-11-20 08:22:13
5989	10	10	2025-11-20 08:22:13
5990	7	25.3	2025-11-20 08:22:27
5991	8	55	2025-11-20 08:22:27
5992	9	9.384164222873906	2025-11-20 08:22:27
5993	10	10	2025-11-20 08:22:27
5994	7	25.3	2025-11-20 08:22:36
5995	8	55	2025-11-20 08:22:36
5996	9	9.384164222873906	2025-11-20 08:22:36
5997	10	10	2025-11-20 08:22:36
5998	7	25.3	2025-11-20 08:22:50
5999	8	55	2025-11-20 08:22:50
6000	9	9.384164222873906	2025-11-20 08:22:50
6001	10	10	2025-11-20 08:22:50
6002	7	25.3	2025-11-20 08:23:04
6003	8	55	2025-11-20 08:23:04
6004	9	9.481915933528839	2025-11-20 08:23:04
6005	10	10	2025-11-20 08:23:04
6006	7	25.3	2025-11-20 08:23:19
6007	8	55	2025-11-20 08:23:19
6008	9	9.384164222873906	2025-11-20 08:23:19
6009	10	10	2025-11-20 08:23:19
6010	7	25.3	2025-11-20 08:23:32
6011	8	55	2025-11-20 08:23:32
6012	9	9.481915933528839	2025-11-20 08:23:32
6013	10	10	2025-11-20 08:23:32
6014	7	25.3	2025-11-20 08:23:47
6015	8	55	2025-11-20 08:23:47
6016	9	9.384164222873906	2025-11-20 08:23:47
6017	10	10	2025-11-20 08:23:47
6018	7	25.3	2025-11-20 08:24:06
6019	8	55	2025-11-20 08:24:06
6020	9	9.384164222873906	2025-11-20 08:24:06
6021	10	10	2025-11-20 08:24:06
6022	7	25.3	2025-11-20 08:24:21
6023	8	55	2025-11-20 08:24:21
6024	9	9.384164222873906	2025-11-20 08:24:21
6025	10	10	2025-11-20 08:24:21
6026	7	25.3	2025-11-20 08:24:31
6027	8	55	2025-11-20 08:24:31
6028	9	9.384164222873906	2025-11-20 08:24:31
6029	10	10	2025-11-20 08:24:31
6030	7	25.3	2025-11-20 08:24:45
6031	8	55	2025-11-20 08:24:45
6032	9	9.481915933528839	2025-11-20 08:24:45
6033	10	10	2025-11-20 08:24:45
6034	7	25.3	2025-11-20 08:24:54
6035	8	55	2025-11-20 08:24:54
6036	9	9.481915933528839	2025-11-20 08:24:54
6037	10	10	2025-11-20 08:24:54
6038	7	25.3	2025-11-20 08:25:09
6039	8	55	2025-11-20 08:25:09
6040	9	9.384164222873906	2025-11-20 08:25:09
6041	10	10	2025-11-20 08:25:09
6042	7	25.3	2025-11-20 08:25:22
6043	8	55	2025-11-20 08:25:22
6044	9	9.384164222873906	2025-11-20 08:25:22
6045	10	10	2025-11-20 08:25:22
6046	7	25.3	2025-11-20 08:25:41
6047	8	55	2025-11-20 08:25:41
6048	9	9.384164222873906	2025-11-20 08:25:41
6049	10	10	2025-11-20 08:25:41
6050	7	25.3	2025-11-20 08:25:56
6051	8	55	2025-11-20 08:25:56
6052	9	9.384164222873906	2025-11-20 08:25:56
6053	10	10	2025-11-20 08:25:56
6054	7	25.3	2025-11-20 08:26:15
6055	8	55	2025-11-20 08:26:15
6056	9	9.384164222873906	2025-11-20 08:26:15
6057	10	10	2025-11-20 08:26:15
6058	7	25.3	2025-11-20 08:26:24
6059	8	55	2025-11-20 08:26:24
6060	9	9.481915933528839	2025-11-20 08:26:24
6061	10	10	2025-11-20 08:26:24
6062	7	25.3	2025-11-20 08:26:39
6063	8	55	2025-11-20 08:26:39
6064	9	9.481915933528839	2025-11-20 08:26:39
6065	10	10	2025-11-20 08:26:39
6066	7	25.3	2025-11-20 08:26:54
6067	8	55	2025-11-20 08:26:54
6068	9	9.384164222873906	2025-11-20 08:26:54
6069	10	10	2025-11-20 08:26:54
6070	7	25.3	2025-11-20 08:27:09
6071	8	55	2025-11-20 08:27:09
6072	9	9.384164222873906	2025-11-20 08:27:09
6073	10	10	2025-11-20 08:27:09
6074	7	25.3	2025-11-20 08:27:23
6075	8	55	2025-11-20 08:27:23
6076	9	9.384164222873906	2025-11-20 08:27:23
6077	10	10	2025-11-20 08:27:23
6078	7	25.3	2025-11-20 08:27:37
6079	8	55	2025-11-20 08:27:37
6080	9	9.481915933528839	2025-11-20 08:27:37
6081	10	10	2025-11-20 08:27:37
6082	7	25.3	2025-11-20 08:27:51
6083	8	55	2025-11-20 08:27:51
6084	9	9.481915933528839	2025-11-20 08:27:51
6085	10	10	2025-11-20 08:27:51
6086	7	25.3	2025-11-20 08:28:01
6087	8	55	2025-11-20 08:28:01
6088	9	9.384164222873906	2025-11-20 08:28:01
6089	10	10	2025-11-20 08:28:01
6090	7	25.3	2025-11-20 08:28:16
6091	8	55	2025-11-20 08:28:16
6092	9	9.384164222873906	2025-11-20 08:28:16
6093	10	10	2025-11-20 08:28:16
6094	7	25.3	2025-11-20 08:28:30
6095	8	55	2025-11-20 08:28:30
6096	9	9.384164222873906	2025-11-20 08:28:30
6097	10	10	2025-11-20 08:28:30
6098	7	25.3	2025-11-20 08:28:44
6099	8	55	2025-11-20 08:28:44
6100	9	9.481915933528839	2025-11-20 08:28:44
6101	10	10	2025-11-20 08:28:44
6102	7	25.3	2025-11-20 08:28:54
6103	8	55	2025-11-20 08:28:54
6104	9	9.481915933528839	2025-11-20 08:28:54
6105	10	10	2025-11-20 08:28:54
6106	7	25.3	2025-11-20 08:29:03
6107	8	55	2025-11-20 08:29:03
6108	9	9.481915933528839	2025-11-20 08:29:03
6109	10	10	2025-11-20 08:29:03
6110	7	25.3	2025-11-20 08:29:12
6111	8	55	2025-11-20 08:29:12
6112	9	9.384164222873906	2025-11-20 08:29:12
6113	10	10	2025-11-20 08:29:12
6114	7	25.3	2025-11-20 08:29:27
6115	8	55	2025-11-20 08:29:27
6116	9	9.481915933528839	2025-11-20 08:29:27
6117	10	10	2025-11-20 08:29:27
6118	7	25.3	2025-11-20 08:29:42
6119	8	55	2025-11-20 08:29:42
6120	9	9.384164222873906	2025-11-20 08:29:42
6121	10	10	2025-11-20 08:29:42
6122	7	25.3	2025-11-20 08:30:01
6123	8	55	2025-11-20 08:30:01
6124	9	9.384164222873906	2025-11-20 08:30:01
6125	10	10	2025-11-20 08:30:01
6126	7	25.3	2025-11-20 08:30:16
6127	8	56	2025-11-20 08:30:16
6128	9	9.384164222873906	2025-11-20 08:30:16
6129	10	10	2025-11-20 08:30:16
6130	7	25.3	2025-11-20 08:30:31
6131	8	56	2025-11-20 08:30:31
6132	9	9.384164222873906	2025-11-20 08:30:31
6133	10	10	2025-11-20 08:30:31
6134	7	25.3	2025-11-20 08:30:45
6135	8	56	2025-11-20 08:30:45
6136	9	9.481915933528839	2025-11-20 08:30:45
6137	10	10	2025-11-20 08:30:45
6138	7	25.3	2025-11-20 08:30:54
6139	8	56	2025-11-20 08:30:54
6140	9	9.384164222873906	2025-11-20 08:30:54
6141	10	10	2025-11-20 08:30:54
6142	7	25.3	2025-11-20 08:31:08
6143	8	56	2025-11-20 08:31:08
6144	9	9.384164222873906	2025-11-20 08:31:08
6145	10	10	2025-11-20 08:31:08
6146	7	25.3	2025-11-20 08:31:18
6147	8	56	2025-11-20 08:31:18
6148	9	9.481915933528839	2025-11-20 08:31:18
6149	10	10	2025-11-20 08:31:18
6150	7	25.3	2025-11-20 08:31:33
6151	8	56	2025-11-20 08:31:33
6152	9	9.481915933528839	2025-11-20 08:31:33
6153	10	10	2025-11-20 08:31:33
6154	7	25.3	2025-11-20 08:31:48
6155	8	56	2025-11-20 08:31:48
6156	9	9.384164222873906	2025-11-20 08:31:48
6157	10	10	2025-11-20 08:31:48
6158	7	25.3	2025-11-20 08:31:57
6159	8	56	2025-11-20 08:31:57
6160	9	9.481915933528839	2025-11-20 08:31:57
6161	10	10	2025-11-20 08:31:57
6162	7	25.3	2025-11-20 08:32:06
6163	8	56	2025-11-20 08:32:06
6164	9	9.481915933528839	2025-11-20 08:32:06
6165	10	10	2025-11-20 08:32:06
6166	7	25.3	2025-11-20 08:32:20
6167	8	56	2025-11-20 08:32:20
6168	9	9.384164222873906	2025-11-20 08:32:20
6169	10	10	2025-11-20 08:32:20
6170	7	25.3	2025-11-20 08:32:30
6171	8	56	2025-11-20 08:32:30
6172	9	9.481915933528839	2025-11-20 08:32:30
6173	10	10	2025-11-20 08:32:30
6174	7	25.3	2025-11-20 08:32:39
6175	8	56	2025-11-20 08:32:39
6176	9	9.481915933528839	2025-11-20 08:32:39
6177	10	10	2025-11-20 08:32:39
6178	7	25.3	2025-11-20 08:32:55
6179	8	56	2025-11-20 08:32:55
6180	9	9.384164222873906	2025-11-20 08:32:55
6181	10	10	2025-11-20 08:32:55
6182	7	25.3	2025-11-20 08:33:03
6183	8	56	2025-11-20 08:33:03
6184	9	9.384164222873906	2025-11-20 08:33:03
6185	10	10	2025-11-20 08:33:03
6186	7	25.3	2025-11-20 08:33:18
6187	8	56	2025-11-20 08:33:18
6188	9	9.481915933528839	2025-11-20 08:33:18
6189	10	10	2025-11-20 08:33:18
6190	7	25.3	2025-11-20 08:33:34
6191	8	56	2025-11-20 08:33:34
6192	9	9.384164222873906	2025-11-20 08:33:34
6193	10	9	2025-11-20 08:33:34
6194	7	25.3	2025-11-20 08:33:47
6195	8	56	2025-11-20 08:33:47
6196	9	9.481915933528839	2025-11-20 08:33:47
6197	10	10	2025-11-20 08:33:47
6198	7	25.3	2025-11-20 08:34:02
6199	8	56	2025-11-20 08:34:02
6200	9	9.481915933528839	2025-11-20 08:34:02
6201	10	10	2025-11-20 08:34:02
6202	7	25.3	2025-11-20 08:34:16
6203	8	56	2025-11-20 08:34:16
6204	9	9.481915933528839	2025-11-20 08:34:16
6205	10	10	2025-11-20 08:34:16
6206	7	25.3	2025-11-20 08:34:30
6207	8	56	2025-11-20 08:34:30
6208	9	9.384164222873906	2025-11-20 08:34:30
6209	10	9	2025-11-20 08:34:30
6210	7	25.3	2025-11-20 08:34:45
6211	8	56	2025-11-20 08:34:45
6212	9	9.481915933528839	2025-11-20 08:34:45
6213	10	10	2025-11-20 08:34:45
6214	7	25.3	2025-11-20 08:34:59
6215	8	56	2025-11-20 08:34:59
6216	9	9.481915933528839	2025-11-20 08:34:59
6217	10	9	2025-11-20 08:34:59
6218	7	25.3	2025-11-20 08:35:13
6219	8	56	2025-11-20 08:35:13
6220	9	9.481915933528839	2025-11-20 08:35:13
6221	10	10	2025-11-20 08:35:13
6222	7	25.3	2025-11-20 08:35:28
6223	8	56	2025-11-20 08:35:28
6224	9	9.481915933528839	2025-11-20 08:35:28
6225	10	9	2025-11-20 08:35:28
6226	7	25.3	2025-11-20 08:35:42
6227	8	56	2025-11-20 08:35:42
6228	9	9.384164222873906	2025-11-20 08:35:42
6229	10	10	2025-11-20 08:35:42
6230	7	25.3	2025-11-20 08:35:51
6231	8	56	2025-11-20 08:35:51
6232	9	9.384164222873906	2025-11-20 08:35:51
6233	10	10	2025-11-20 08:35:51
6234	7	25.3	2025-11-20 08:36:06
6235	8	57	2025-11-20 08:36:06
6236	9	9.481915933528839	2025-11-20 08:36:06
6237	10	10	2025-11-20 08:36:06
6238	7	25.3	2025-11-20 08:36:21
6239	8	57	2025-11-20 08:36:21
6240	9	9.481915933528839	2025-11-20 08:36:21
6241	10	9	2025-11-20 08:36:21
6242	7	25.3	2025-11-20 08:36:34
6243	8	57	2025-11-20 08:36:34
6244	9	9.384164222873906	2025-11-20 08:36:34
6245	10	10	2025-11-20 08:36:34
6246	7	25.3	2025-11-20 08:36:50
6247	8	57	2025-11-20 08:36:50
6248	9	9.481915933528839	2025-11-20 08:36:50
6249	10	10	2025-11-20 08:36:50
6250	7	25.3	2025-11-20 08:37:00
6251	8	57	2025-11-20 08:37:00
6252	9	9.481915933528839	2025-11-20 08:37:00
6253	10	10	2025-11-20 08:37:00
6254	7	25.3	2025-11-20 08:37:09
6255	8	57	2025-11-20 08:37:09
6256	9	9.384164222873906	2025-11-20 08:37:09
6257	10	10	2025-11-20 08:37:09
6258	7	25.3	2025-11-20 08:37:23
6259	8	57	2025-11-20 08:37:23
6260	9	9.481915933528839	2025-11-20 08:37:23
6261	10	10	2025-11-20 08:37:23
6262	7	25.3	2025-11-20 08:37:37
6263	8	57	2025-11-20 08:37:37
6264	9	9.481915933528839	2025-11-20 08:37:37
6265	10	10	2025-11-20 08:37:37
6266	7	25.3	2025-11-20 08:37:53
6267	8	57	2025-11-20 08:37:53
6268	9	9.481915933528839	2025-11-20 08:37:53
6269	10	10	2025-11-20 08:37:53
6270	7	25.3	2025-11-20 08:38:07
6271	8	57	2025-11-20 08:38:07
6272	9	9.481915933528839	2025-11-20 08:38:07
6273	10	10	2025-11-20 08:38:07
6274	7	25.3	2025-11-20 08:38:21
6275	8	57	2025-11-20 08:38:21
6276	9	9.384164222873906	2025-11-20 08:38:21
6277	10	10	2025-11-20 08:38:21
6278	7	25.3	2025-11-20 08:38:30
6279	8	57	2025-11-20 08:38:30
6280	9	9.384164222873906	2025-11-20 08:38:30
6281	10	10	2025-11-20 08:38:30
6282	7	25.3	2025-11-20 08:38:45
6283	8	57	2025-11-20 08:38:45
6284	9	9.384164222873906	2025-11-20 08:38:45
6285	10	10	2025-11-20 08:38:45
6286	7	25.3	2025-11-20 08:38:54
6287	8	57	2025-11-20 08:38:54
6288	9	9.384164222873906	2025-11-20 08:38:54
6289	10	10	2025-11-20 08:38:54
6290	7	25.3	2025-11-20 08:39:08
6291	8	57	2025-11-20 08:39:08
6292	9	9.384164222873906	2025-11-20 08:39:08
6293	10	10	2025-11-20 08:39:08
6294	7	25.3	2025-11-20 08:39:22
6295	8	57	2025-11-20 08:39:22
6296	9	9.384164222873906	2025-11-20 08:39:22
6297	10	10	2025-11-20 08:39:22
6298	7	25.3	2025-11-20 08:39:43
6299	8	57	2025-11-20 08:39:43
6300	9	9.384164222873906	2025-11-20 08:39:43
6301	10	10	2025-11-20 08:39:43
6302	7	25.3	2025-11-20 08:39:57
6303	8	57	2025-11-20 08:39:57
6304	9	9.384164222873906	2025-11-20 08:39:57
6305	10	10	2025-11-20 08:39:57
6306	7	25.3	2025-11-20 08:40:12
6307	8	57	2025-11-20 08:40:12
6308	9	9.384164222873906	2025-11-20 08:40:12
6309	10	10	2025-11-20 08:40:12
6310	7	25.3	2025-11-20 08:40:26
6311	8	57	2025-11-20 08:40:26
6312	9	9.481915933528839	2025-11-20 08:40:26
6313	10	10	2025-11-20 08:40:26
6314	7	25.3	2025-11-20 08:40:41
6315	8	57	2025-11-20 08:40:41
6316	9	9.384164222873906	2025-11-20 08:40:41
6317	10	10	2025-11-20 08:40:41
6318	7	25.8	2025-11-20 08:40:51
6319	8	61	2025-11-20 08:40:51
6320	9	0	2025-11-20 08:40:51
6321	10	10	2025-11-20 08:40:51
6322	7	25.8	2025-11-20 08:41:12
6323	8	61	2025-11-20 08:41:12
6324	9	0.09775171065493282	2025-11-20 08:41:12
6325	10	10	2025-11-20 08:41:12
6326	7	25.8	2025-11-20 08:41:27
6327	8	61	2025-11-20 08:41:27
6328	9	0	2025-11-20 08:41:27
6329	10	10	2025-11-20 08:41:27
6330	7	25.8	2025-11-20 08:41:42
6331	8	61	2025-11-20 08:41:42
6332	9	0.09775171065493282	2025-11-20 08:41:42
6333	10	10	2025-11-20 08:41:42
6334	7	25.8	2025-11-20 08:41:55
6335	8	61	2025-11-20 08:41:55
6336	9	0	2025-11-20 08:41:55
6337	10	10	2025-11-20 08:41:55
6338	7	25.8	2025-11-20 08:42:09
6339	8	61	2025-11-20 08:42:09
6340	9	0	2025-11-20 08:42:09
6341	10	10	2025-11-20 08:42:09
6342	7	25.8	2025-11-20 08:42:24
6343	8	61	2025-11-20 08:42:24
6344	9	0.09775171065493282	2025-11-20 08:42:24
6345	10	10	2025-11-20 08:42:24
6346	7	25.8	2025-11-20 08:42:39
6347	8	61	2025-11-20 08:42:39
6348	9	0.09775171065493282	2025-11-20 08:42:39
6349	10	10	2025-11-20 08:42:39
6350	7	25.8	2025-11-20 08:42:54
6351	8	61	2025-11-20 08:42:54
6352	9	0.09775171065493282	2025-11-20 08:42:54
6353	10	10	2025-11-20 08:42:54
6354	7	25.8	2025-11-20 08:43:08
6355	8	61	2025-11-20 08:43:08
6356	9	0.09775171065493282	2025-11-20 08:43:08
6357	10	10	2025-11-20 08:43:08
6358	7	25.8	2025-11-20 08:43:22
6359	8	61	2025-11-20 08:43:22
6360	9	0	2025-11-20 08:43:22
6361	10	10	2025-11-20 08:43:22
6362	7	25.8	2025-11-20 08:43:36
6363	8	61	2025-11-20 08:43:36
6364	9	0.09775171065493282	2025-11-20 08:43:36
6365	10	10	2025-11-20 08:43:36
6366	7	25.8	2025-11-20 08:43:51
6367	8	61	2025-11-20 08:43:51
6368	9	0.09775171065493282	2025-11-20 08:43:51
6369	10	10	2025-11-20 08:43:51
6370	7	25.8	2025-11-20 08:44:05
6371	8	61	2025-11-20 08:44:05
6372	9	0	2025-11-20 08:44:05
6373	10	10	2025-11-20 08:44:05
6374	7	25.8	2025-11-20 08:44:19
6375	8	61	2025-11-20 08:44:19
6376	9	0.09775171065493282	2025-11-20 08:44:19
6377	10	10	2025-11-20 08:44:19
6378	7	25.8	2025-11-20 08:44:34
6379	8	61	2025-11-20 08:44:34
6380	9	0	2025-11-20 08:44:34
6381	10	10	2025-11-20 08:44:34
6382	7	25.8	2025-11-20 08:44:48
6383	8	61	2025-11-20 08:44:48
6384	9	0	2025-11-20 08:44:48
6385	10	10	2025-11-20 08:44:48
6386	7	25.8	2025-11-20 08:45:03
6387	8	61	2025-11-20 08:45:03
6388	9	0.09775171065493282	2025-11-20 08:45:03
6389	10	10	2025-11-20 08:45:03
6390	7	25.8	2025-11-20 08:45:12
6391	8	61	2025-11-20 08:45:12
6392	9	0.09775171065493282	2025-11-20 08:45:12
6393	10	10	2025-11-20 08:45:12
6394	7	25.8	2025-11-20 08:45:27
6395	8	61	2025-11-20 08:45:27
6396	9	0.09775171065493282	2025-11-20 08:45:27
6397	10	10	2025-11-20 08:45:27
6398	7	25.8	2025-11-20 08:45:36
6399	8	61	2025-11-20 08:45:36
6400	9	0	2025-11-20 08:45:36
6401	10	10	2025-11-20 08:45:36
6402	7	25.8	2025-11-20 08:45:50
6403	8	61	2025-11-20 08:45:50
6404	9	0	2025-11-20 08:45:50
6405	10	10	2025-11-20 08:45:50
6406	7	25.8	2025-11-20 08:46:00
6407	8	61	2025-11-20 08:46:00
6408	9	0	2025-11-20 08:46:00
6409	10	10	2025-11-20 08:46:00
6410	7	25.8	2025-11-20 08:46:09
6411	8	61	2025-11-20 08:46:09
6412	9	0.09775171065493282	2025-11-20 08:46:09
6413	10	10	2025-11-20 08:46:09
6414	7	25.8	2025-11-20 08:46:18
6415	8	61	2025-11-20 08:46:18
6416	9	0	2025-11-20 08:46:18
6417	10	10	2025-11-20 08:46:18
6418	7	25.8	2025-11-20 08:46:33
6419	8	61	2025-11-20 08:46:33
6420	9	0.09775171065493282	2025-11-20 08:46:33
6421	10	10	2025-11-20 08:46:33
6422	7	25.8	2025-11-20 08:46:42
6423	8	61	2025-11-20 08:46:42
6424	9	0	2025-11-20 08:46:42
6425	10	10	2025-11-20 08:46:42
6426	7	25.8	2025-11-20 08:46:57
6427	8	61	2025-11-20 08:46:57
6428	9	0.09775171065493282	2025-11-20 08:46:57
6429	10	10	2025-11-20 08:46:57
6430	7	25.8	2025-11-20 08:47:16
6431	8	61	2025-11-20 08:47:16
6432	9	0.09775171065493282	2025-11-20 08:47:16
6433	10	10	2025-11-20 08:47:16
6434	7	25.8	2025-11-20 08:47:31
6435	8	61	2025-11-20 08:47:31
6436	9	0.09775171065493282	2025-11-20 08:47:31
6437	10	10	2025-11-20 08:47:31
6438	7	25.8	2025-11-20 08:47:45
6439	8	61	2025-11-20 08:47:45
6440	9	0	2025-11-20 08:47:45
6441	10	10	2025-11-20 08:47:45
6442	7	25.8	2025-11-20 08:47:55
6443	8	61	2025-11-20 08:47:55
6444	9	0.09775171065493282	2025-11-20 08:47:55
6445	10	10	2025-11-20 08:47:55
6446	7	26.2	2025-11-20 08:48:09
6447	8	60	2025-11-20 08:48:09
6448	9	0.09775171065493282	2025-11-20 08:48:09
6449	10	10	2025-11-20 08:48:09
6450	7	26.2	2025-11-20 08:48:24
6451	8	60	2025-11-20 08:48:24
6452	9	0	2025-11-20 08:48:24
6453	10	10	2025-11-20 08:48:24
6454	7	26.2	2025-11-20 08:48:34
6455	8	60	2025-11-20 08:48:34
6456	9	0.09775171065493282	2025-11-20 08:48:34
6457	10	10	2025-11-20 08:48:34
6458	7	26.2	2025-11-20 08:48:47
6459	8	60	2025-11-20 08:48:47
6460	9	0.09775171065493282	2025-11-20 08:48:47
6461	10	10	2025-11-20 08:48:47
6462	7	26.2	2025-11-20 08:48:57
6463	8	60	2025-11-20 08:48:57
6464	9	0	2025-11-20 08:48:57
6465	10	10	2025-11-20 08:48:57
6466	7	26.2	2025-11-20 08:49:12
6467	8	60	2025-11-20 08:49:12
6468	9	0.09775171065493282	2025-11-20 08:49:12
6469	10	10	2025-11-20 08:49:12
6470	7	26.2	2025-11-20 08:49:25
6471	8	60	2025-11-20 08:49:25
6472	9	0.09775171065493282	2025-11-20 08:49:25
6473	10	10	2025-11-20 08:49:25
6474	7	26.2	2025-11-20 08:49:38
6475	8	60	2025-11-20 08:49:38
6476	9	0.09775171065493282	2025-11-20 08:49:38
6477	10	10	2025-11-20 08:49:38
6478	7	26.2	2025-11-20 08:49:57
6479	8	60	2025-11-20 08:49:57
6480	9	0	2025-11-20 08:49:57
6481	10	10	2025-11-20 08:49:57
6482	7	26.2	2025-11-20 08:50:06
6483	8	60	2025-11-20 08:50:06
6484	9	0.09775171065493282	2025-11-20 08:50:06
6485	10	10	2025-11-20 08:50:06
6486	7	26.2	2025-11-20 08:50:16
6487	8	60	2025-11-20 08:50:16
6488	9	0.09775171065493282	2025-11-20 08:50:16
6489	10	10	2025-11-20 08:50:16
6490	7	26.2	2025-11-20 08:50:31
6491	8	60	2025-11-20 08:50:31
6492	9	0	2025-11-20 08:50:31
6493	10	10	2025-11-20 08:50:31
6494	7	26.2	2025-11-20 08:50:46
6495	8	60	2025-11-20 08:50:46
6496	9	0.09775171065493282	2025-11-20 08:50:46
6497	10	10	2025-11-20 08:50:46
6498	7	26.2	2025-11-20 08:51:00
6499	8	60	2025-11-20 08:51:00
6500	9	0.09775171065493282	2025-11-20 08:51:00
6501	10	10	2025-11-20 08:51:00
6502	7	26.2	2025-11-20 08:51:15
6503	8	60	2025-11-20 08:51:15
6504	9	0.09775171065493282	2025-11-20 08:51:15
6505	10	10	2025-11-20 08:51:15
6506	7	26.2	2025-11-20 08:51:24
6507	8	60	2025-11-20 08:51:24
6508	9	0.09775171065493282	2025-11-20 08:51:24
6509	10	10	2025-11-20 08:51:24
6510	7	26.2	2025-11-20 08:51:39
6511	8	60	2025-11-20 08:51:39
6512	9	0.09775171065493282	2025-11-20 08:51:39
6513	10	9	2025-11-20 08:51:39
6514	7	26.2	2025-11-20 08:51:49
6515	8	60	2025-11-20 08:51:49
6516	9	0.09775171065493282	2025-11-20 08:51:49
6517	10	10	2025-11-20 08:51:49
6518	7	26.2	2025-11-20 08:52:03
6519	8	60	2025-11-20 08:52:03
6520	9	0.09775171065493282	2025-11-20 08:52:03
6521	10	9	2025-11-20 08:52:03
6522	7	26.2	2025-11-20 08:52:13
6523	8	60	2025-11-20 08:52:13
6524	9	0	2025-11-20 08:52:13
6525	10	10	2025-11-20 08:52:13
6526	7	26.2	2025-11-20 08:52:27
6527	8	60	2025-11-20 08:52:27
6528	9	0	2025-11-20 08:52:27
6529	10	9	2025-11-20 08:52:27
6530	7	26.2	2025-11-20 08:52:42
6531	8	60	2025-11-20 08:52:42
6532	9	0.09775171065493282	2025-11-20 08:52:42
6533	10	10	2025-11-20 08:52:42
6534	7	26.2	2025-11-20 08:52:52
6535	8	60	2025-11-20 08:52:52
6536	9	0.09775171065493282	2025-11-20 08:52:52
6537	10	10	2025-11-20 08:52:52
6538	7	26.2	2025-11-20 08:53:12
6539	8	60	2025-11-20 08:53:12
6540	9	0.09775171065493282	2025-11-20 08:53:12
6541	10	10	2025-11-20 08:53:12
6542	7	26.2	2025-11-20 08:53:22
6543	8	60	2025-11-20 08:53:22
6544	9	0	2025-11-20 08:53:22
6545	10	10	2025-11-20 08:53:22
6546	7	26.2	2025-11-20 08:53:36
6547	8	60	2025-11-20 08:53:36
6548	9	0.09775171065493282	2025-11-20 08:53:36
6549	10	10	2025-11-20 08:53:36
6550	7	26.2	2025-11-20 08:53:46
6551	8	60	2025-11-20 08:53:46
6552	9	0.09775171065493282	2025-11-20 08:53:46
6553	10	9	2025-11-20 08:53:46
6554	7	26.2	2025-11-20 08:54:01
6555	8	60	2025-11-20 08:54:01
6556	9	0.09775171065493282	2025-11-20 08:54:01
6557	10	10	2025-11-20 08:54:01
6558	7	26.2	2025-11-20 08:54:15
6559	8	60	2025-11-20 08:54:15
6560	9	0	2025-11-20 08:54:15
6561	10	10	2025-11-20 08:54:15
6562	7	26.2	2025-11-20 08:54:24
6563	8	60	2025-11-20 08:54:24
6564	9	0.09775171065493282	2025-11-20 08:54:24
6565	10	10	2025-11-20 08:54:24
6566	7	26.2	2025-11-20 08:54:39
6567	8	60	2025-11-20 08:54:39
6568	9	0	2025-11-20 08:54:39
6569	10	10	2025-11-20 08:54:39
6570	7	26.2	2025-11-20 08:54:48
6571	8	60	2025-11-20 08:54:48
6572	9	0.09775171065493282	2025-11-20 08:54:48
6573	10	10	2025-11-20 08:54:48
6574	7	26.2	2025-11-20 08:55:03
6575	8	60	2025-11-20 08:55:03
6576	9	0.09775171065493282	2025-11-20 08:55:03
6577	10	9	2025-11-20 08:55:03
6578	7	26.7	2025-11-20 08:55:12
6579	8	59	2025-11-20 08:55:12
6580	9	0.09775171065493282	2025-11-20 08:55:12
6581	10	10	2025-11-20 08:55:12
6582	7	26.7	2025-11-20 08:55:27
6583	8	59	2025-11-20 08:55:27
6584	9	0.09775171065493282	2025-11-20 08:55:27
6585	10	10	2025-11-20 08:55:27
6586	7	26.7	2025-11-20 08:55:36
6587	8	59	2025-11-20 08:55:36
6588	9	0	2025-11-20 08:55:36
6589	10	10	2025-11-20 08:55:36
6590	7	26.7	2025-11-20 08:55:45
6591	8	59	2025-11-20 08:55:45
6592	9	0.09775171065493282	2025-11-20 08:55:45
6593	10	10	2025-11-20 08:55:45
6594	7	26.7	2025-11-20 08:56:00
6595	8	59	2025-11-20 08:56:00
6596	9	0.09775171065493282	2025-11-20 08:56:00
6597	10	10	2025-11-20 08:56:00
6598	7	26.7	2025-11-20 08:56:09
6599	8	59	2025-11-20 08:56:09
6600	9	0.09775171065493282	2025-11-20 08:56:09
6601	10	10	2025-11-20 08:56:09
6602	7	26.7	2025-11-20 08:56:18
6603	8	59	2025-11-20 08:56:18
6604	9	0	2025-11-20 08:56:18
6605	10	10	2025-11-20 08:56:18
6606	7	26.7	2025-11-20 08:56:27
6607	8	58	2025-11-20 08:56:27
6608	9	0.09775171065493282	2025-11-20 08:56:27
6609	10	10	2025-11-20 08:56:27
6610	7	26.7	2025-11-20 08:56:36
6611	8	58	2025-11-20 08:56:36
6612	9	0	2025-11-20 08:56:36
6613	10	10	2025-11-20 08:56:36
6614	7	26.7	2025-11-20 08:56:45
6615	8	58	2025-11-20 08:56:45
6616	9	0.09775171065493282	2025-11-20 08:56:45
6617	10	10	2025-11-20 08:56:45
6618	7	26.7	2025-11-20 08:57:00
6619	8	58	2025-11-20 08:57:00
6620	9	0	2025-11-20 08:57:00
6621	10	10	2025-11-20 08:57:00
6622	7	26.7	2025-11-20 08:57:15
6623	8	58	2025-11-20 08:57:15
6624	9	0.09775171065493282	2025-11-20 08:57:15
6625	10	10	2025-11-20 08:57:15
6626	7	26.7	2025-11-20 08:57:24
6627	8	58	2025-11-20 08:57:24
6628	9	0	2025-11-20 08:57:24
6629	10	10	2025-11-20 08:57:24
6630	7	26.7	2025-11-20 08:57:34
6631	8	58	2025-11-20 08:57:34
6632	9	0.09775171065493282	2025-11-20 08:57:34
6633	10	10	2025-11-20 08:57:34
6634	7	26.7	2025-11-20 08:57:49
6635	8	58	2025-11-20 08:57:49
6636	9	0.09775171065493282	2025-11-20 08:57:49
6637	10	10	2025-11-20 08:57:49
6638	7	26.7	2025-11-20 08:58:03
6639	8	58	2025-11-20 08:58:03
6640	9	0	2025-11-20 08:58:03
6641	10	10	2025-11-20 08:58:03
6642	7	26.7	2025-11-20 08:58:12
6643	8	58	2025-11-20 08:58:12
6644	9	0	2025-11-20 08:58:12
6645	10	10	2025-11-20 08:58:12
6646	7	26.7	2025-11-20 08:58:27
6647	8	58	2025-11-20 08:58:27
6648	9	0.09775171065493282	2025-11-20 08:58:27
6649	10	10	2025-11-20 08:58:27
6650	7	26.7	2025-11-20 08:58:42
6651	8	58	2025-11-20 08:58:42
6652	9	0.09775171065493282	2025-11-20 08:58:42
6653	10	10	2025-11-20 08:58:42
6654	7	26.7	2025-11-20 08:58:57
6655	8	58	2025-11-20 08:58:57
6656	9	0.09775171065493282	2025-11-20 08:58:57
6657	10	10	2025-11-20 08:58:57
6658	7	26.7	2025-11-20 08:59:06
6659	8	58	2025-11-20 08:59:06
6660	9	0.09775171065493282	2025-11-20 08:59:06
6661	10	10	2025-11-20 08:59:06
6662	7	26.7	2025-11-20 08:59:15
6663	8	58	2025-11-20 08:59:15
6664	9	0.09775171065493282	2025-11-20 08:59:15
6665	10	10	2025-11-20 08:59:15
6666	7	26.7	2025-11-20 08:59:24
6667	8	58	2025-11-20 08:59:24
6668	9	0.09775171065493282	2025-11-20 08:59:24
6669	10	10	2025-11-20 08:59:24
6670	7	26.7	2025-11-20 08:59:33
6671	8	58	2025-11-20 08:59:33
6672	9	0	2025-11-20 08:59:33
6673	10	10	2025-11-20 08:59:33
6674	7	26.7	2025-11-20 08:59:47
6675	8	58	2025-11-20 08:59:47
6676	9	0.09775171065493282	2025-11-20 08:59:47
6677	10	10	2025-11-20 08:59:47
6678	7	26.7	2025-11-20 09:00:01
6679	8	58	2025-11-20 09:00:01
6680	9	0.09775171065493282	2025-11-20 09:00:01
6681	10	10	2025-11-20 09:00:01
6682	7	26.7	2025-11-20 09:00:15
6683	8	58	2025-11-20 09:00:15
6684	9	0	2025-11-20 09:00:15
6685	10	10	2025-11-20 09:00:15
6686	7	26.7	2025-11-20 09:00:30
6687	8	58	2025-11-20 09:00:30
6688	9	0.09775171065493282	2025-11-20 09:00:30
6689	10	10	2025-11-20 09:00:30
6690	7	27.6	2025-11-20 09:48:16
6691	8	53	2025-11-20 09:48:16
6692	9	0.3910068426197455	2025-11-20 09:48:16
6693	10	16	2025-11-20 09:48:16
6694	7	27.6	2025-11-20 09:48:30
6695	8	53	2025-11-20 09:48:30
6696	9	0.2932551319648127	2025-11-20 09:48:30
6697	10	16	2025-11-20 09:48:30
6698	7	27.6	2025-11-20 09:48:39
6699	8	53	2025-11-20 09:48:39
6700	9	0.3910068426197455	2025-11-20 09:48:39
6701	10	16	2025-11-20 09:48:39
6702	7	27.6	2025-11-20 09:48:54
6703	8	53	2025-11-20 09:48:54
6704	9	0.2932551319648127	2025-11-20 09:48:54
6705	10	16	2025-11-20 09:48:54
6706	7	27.6	2025-11-20 09:49:03
6707	8	53	2025-11-20 09:49:03
6708	9	0.3910068426197455	2025-11-20 09:49:03
6709	10	16	2025-11-20 09:49:03
6710	7	27.6	2025-11-20 09:49:12
6711	8	53	2025-11-20 09:49:12
6712	9	0.2932551319648127	2025-11-20 09:49:12
6713	10	16	2025-11-20 09:49:12
6714	7	27.6	2025-11-20 09:49:21
6715	8	53	2025-11-20 09:49:21
6716	9	0.3910068426197455	2025-11-20 09:49:21
6717	10	16	2025-11-20 09:49:21
6718	7	27.6	2025-11-20 09:49:31
6719	8	53	2025-11-20 09:49:31
6720	9	0.19550342130987985	2025-11-20 09:49:31
6721	10	16	2025-11-20 09:49:31
6722	7	27.6	2025-11-20 09:49:49
6723	8	53	2025-11-20 09:49:49
6724	9	0.3910068426197455	2025-11-20 09:49:49
6725	10	16	2025-11-20 09:49:49
6726	7	27.6	2025-11-20 09:50:03
6727	8	53	2025-11-20 09:50:03
6728	9	0.2932551319648127	2025-11-20 09:50:03
6729	10	16	2025-11-20 09:50:03
6730	7	27.6	2025-11-20 09:50:18
6731	8	53	2025-11-20 09:50:18
6732	9	0.3910068426197455	2025-11-20 09:50:18
6733	10	16	2025-11-20 09:50:18
6734	7	27.6	2025-11-20 09:50:27
6735	8	53	2025-11-20 09:50:27
6736	9	0.2932551319648127	2025-11-20 09:50:27
6737	10	16	2025-11-20 09:50:27
6738	7	27.6	2025-11-20 09:50:43
6739	8	53	2025-11-20 09:50:43
6740	9	0.3910068426197455	2025-11-20 09:50:43
6741	10	16	2025-11-20 09:50:43
6742	7	27.6	2025-11-20 09:50:57
6743	8	53	2025-11-20 09:50:57
6744	9	0.2932551319648127	2025-11-20 09:50:57
6745	10	16	2025-11-20 09:50:57
6746	7	27.6	2025-11-20 09:51:07
6747	8	53	2025-11-20 09:51:07
6748	9	0.3910068426197455	2025-11-20 09:51:07
6749	10	16	2025-11-20 09:51:07
6750	7	27.6	2025-11-20 09:51:21
6751	8	53	2025-11-20 09:51:21
6752	9	0.19550342130987985	2025-11-20 09:51:21
6753	10	16	2025-11-20 09:51:21
6754	7	27.6	2025-11-20 09:51:35
6755	8	53	2025-11-20 09:51:35
6756	9	0.3910068426197455	2025-11-20 09:51:35
6757	10	16	2025-11-20 09:51:35
6758	7	27.6	2025-11-20 09:51:49
6759	8	53	2025-11-20 09:51:49
6760	9	0.2932551319648127	2025-11-20 09:51:49
6761	10	16	2025-11-20 09:51:49
6762	7	28	2025-11-20 09:53:11
6763	8	51	2025-11-20 09:53:11
6764	9	0.3910068426197455	2025-11-20 09:53:11
6765	10	15	2025-11-20 09:53:11
6766	7	28	2025-11-20 09:53:26
6767	8	51	2025-11-20 09:53:26
6768	9	0.2932551319648127	2025-11-20 09:53:26
6769	10	15	2025-11-20 09:53:26
6770	7	28	2025-11-20 09:53:40
6771	8	51	2025-11-20 09:53:40
6772	9	0.3910068426197455	2025-11-20 09:53:40
6773	10	15	2025-11-20 09:53:40
6774	7	28	2025-11-20 09:53:54
6775	8	51	2025-11-20 09:53:54
6776	9	0.2932551319648127	2025-11-20 09:53:54
6777	10	15	2025-11-20 09:53:54
6778	7	28	2025-11-20 09:54:03
6779	8	51	2025-11-20 09:54:03
6780	9	0.2932551319648127	2025-11-20 09:54:03
6781	10	15	2025-11-20 09:54:03
\.


--
-- Data for Name: sensor_node; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sensor_node (id, name, field_id, note) FROM stdin;
\.


--
-- Data for Name: warning_threshold; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warning_threshold (id, crop_season_id, min_temperature, max_temperature, min_humidity, max_humidity, min_soil_moisture, max_soil_moisture, group_type) FROM stdin;
1	1	10	25	50	80	30	60	\N
2	2	16	34	45	75	25	55	\N
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_id_seq', 52, true);


--
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_id_seq', 166, true);


--
-- Name: coordinates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coordinates_id_seq', 34, true);


--
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_growth_stage_id_seq', 4, true);


--
-- Name: crop_season_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_season_id_seq', 84, true);


--
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farm_id_seq', 3, true);


--
-- Name: fertilization_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fertilization_history_id_seq', 3, true);


--
-- Name: field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.field_id_seq', 9, true);


--
-- Name: harvest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.harvest_id_seq', 33, true);


--
-- Name: irrigation_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.irrigation_history_id_seq', 2, true);


--
-- Name: plant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plant_id_seq', 11, true);


--
-- Name: sensor_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_data_id_seq', 6781, true);


--
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_id_seq', 11, true);


--
-- Name: sensor_node_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_node_id_seq', 1, false);


--
-- Name: warning_threshold_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.warning_threshold_id_seq', 2, true);


--
-- Name: account account_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_email_key UNIQUE (email);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: coordinates coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates
    ADD CONSTRAINT coordinates_pkey PRIMARY KEY (id);


--
-- Name: crop_growth_stage crop_growth_stage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_growth_stage
    ADD CONSTRAINT crop_growth_stage_pkey PRIMARY KEY (id);


--
-- Name: crop_season crop_season_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season
    ADD CONSTRAINT crop_season_pkey PRIMARY KEY (id);


--
-- Name: farm farm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- Name: fertilization_history fertilization_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fertilization_history
    ADD CONSTRAINT fertilization_history_pkey PRIMARY KEY (id);


--
-- Name: field field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field
    ADD CONSTRAINT field_pkey PRIMARY KEY (id);


--
-- Name: harvest harvest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest
    ADD CONSTRAINT harvest_pkey PRIMARY KEY (id);


--
-- Name: irrigation_history irrigation_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irrigation_history
    ADD CONSTRAINT irrigation_history_pkey PRIMARY KEY (id);


--
-- Name: plant plant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant
    ADD CONSTRAINT plant_pkey PRIMARY KEY (id);


--
-- Name: plant plant_plant_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant
    ADD CONSTRAINT plant_plant_name_key UNIQUE (plant_name);


--
-- Name: sensor_data sensor_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT sensor_data_pkey PRIMARY KEY (id);


--
-- Name: sensor_node sensor_node_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_node
    ADD CONSTRAINT sensor_node_pkey PRIMARY KEY (id);


--
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (id);


--
-- Name: warning_threshold warning_threshold_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warning_threshold
    ADD CONSTRAINT warning_threshold_pkey PRIMARY KEY (id);


--
-- Name: coordinates coordinates_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates
    ADD CONSTRAINT coordinates_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- Name: crop_growth_stage crop_growth_stage_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_growth_stage
    ADD CONSTRAINT crop_growth_stage_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant(id) ON DELETE CASCADE;


--
-- Name: crop_season crop_season_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season
    ADD CONSTRAINT crop_season_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- Name: crop_season crop_season_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season
    ADD CONSTRAINT crop_season_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant(id) ON DELETE CASCADE;


--
-- Name: farm farm_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm
    ADD CONSTRAINT farm_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.account(id) ON DELETE CASCADE;


--
-- Name: fertilization_history fertilization_history_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fertilization_history
    ADD CONSTRAINT fertilization_history_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- Name: field field_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field
    ADD CONSTRAINT field_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farm(id) ON DELETE CASCADE;


--
-- Name: alert fk131rhyexaxwrt1fu1mk2g7f1n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT fk131rhyexaxwrt1fu1mk2g7f1n FOREIGN KEY (sensor_id) REFERENCES public.sensor(id);


--
-- Name: account fk2g8tsivyiqx51qd9jdktcuo56; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk2g8tsivyiqx51qd9jdktcuo56 FOREIGN KEY (field_id) REFERENCES public.field(id);


--
-- Name: alert fk3xx123j396c42mgw5v8vhqgf1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT fk3xx123j396c42mgw5v8vhqgf1 FOREIGN KEY (field_id) REFERENCES public.field(id);


--
-- Name: account_roles fk_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_roles
    ADD CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES public.account(id) ON DELETE CASCADE;


--
-- Name: account fkih9sjj23m5xdbw2rr54rmawus; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fkih9sjj23m5xdbw2rr54rmawus FOREIGN KEY (farm_id) REFERENCES public.farm(id);


--
-- Name: field fkld9jefpehl8rkm1jewqs64bqn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field
    ADD CONSTRAINT fkld9jefpehl8rkm1jewqs64bqn FOREIGN KEY (crop_season_id) REFERENCES public.crop_season(id);


--
-- Name: sensor fkpem65e5c3qxi0cj421bikqk5q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT fkpem65e5c3qxi0cj421bikqk5q FOREIGN KEY (farm_id) REFERENCES public.farm(id);


--
-- Name: harvest harvest_crop_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest
    ADD CONSTRAINT harvest_crop_season_id_fkey FOREIGN KEY (crop_season_id) REFERENCES public.crop_season(id) ON DELETE CASCADE;


--
-- Name: irrigation_history irrigation_history_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irrigation_history
    ADD CONSTRAINT irrigation_history_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- Name: sensor_data sensor_data_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT sensor_data_sensor_id_fkey FOREIGN KEY (sensor_id) REFERENCES public.sensor(id) ON DELETE CASCADE;


--
-- Name: sensor sensor_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- Name: warning_threshold warning_threshold_crop_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warning_threshold
    ADD CONSTRAINT warning_threshold_crop_season_id_fkey FOREIGN KEY (crop_season_id) REFERENCES public.crop_season(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vrO89Zm7P2aysvhHFOS78NcFAik8xBCBOuKi2izcNLF7FAnGJMGDkdFPQmpZV6o

