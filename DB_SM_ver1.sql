--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-11-07 15:04:18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 217 (class 1259 OID 36580)
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
-- TOC entry 218 (class 1259 OID 36588)
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_id_seq OWNER TO postgres;

--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 218
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- TOC entry 219 (class 1259 OID 36589)
-- Name: account_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_roles (
    account_id bigint NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE public.account_roles OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 36592)
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
    group_type character varying(255)
);


ALTER TABLE public.alert OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 36598)
-- Name: alert_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alert_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alert_id_seq OWNER TO postgres;

--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 221
-- Name: alert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alert_id_seq OWNED BY public.alert.id;


--
-- TOC entry 222 (class 1259 OID 36599)
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
-- TOC entry 223 (class 1259 OID 36602)
-- Name: coordinates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coordinates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coordinates_id_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 223
-- Name: coordinates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coordinates_id_seq OWNED BY public.coordinates.id;


--
-- TOC entry 224 (class 1259 OID 36603)
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
-- TOC entry 225 (class 1259 OID 36608)
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crop_growth_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.crop_growth_stage_id_seq OWNER TO postgres;

--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 225
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crop_growth_stage_id_seq OWNED BY public.crop_growth_stage.id;


--
-- TOC entry 226 (class 1259 OID 36609)
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
-- TOC entry 227 (class 1259 OID 36614)
-- Name: crop_season_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crop_season_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.crop_season_id_seq OWNER TO postgres;

--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 227
-- Name: crop_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crop_season_id_seq OWNED BY public.crop_season.id;


--
-- TOC entry 228 (class 1259 OID 36615)
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
-- TOC entry 229 (class 1259 OID 36620)
-- Name: farm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.farm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.farm_id_seq OWNER TO postgres;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 229
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.farm_id_seq OWNED BY public.farm.id;


--
-- TOC entry 230 (class 1259 OID 36621)
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
-- TOC entry 231 (class 1259 OID 36624)
-- Name: fertilization_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fertilization_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fertilization_history_id_seq OWNER TO postgres;

--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 231
-- Name: fertilization_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fertilization_history_id_seq OWNED BY public.fertilization_history.id;


--
-- TOC entry 232 (class 1259 OID 36625)
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
-- TOC entry 233 (class 1259 OID 36632)
-- Name: field_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.field_id_seq OWNER TO postgres;

--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 233
-- Name: field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.field_id_seq OWNED BY public.field.id;


--
-- TOC entry 234 (class 1259 OID 36633)
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
-- TOC entry 235 (class 1259 OID 36636)
-- Name: harvest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.harvest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.harvest_id_seq OWNER TO postgres;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 235
-- Name: harvest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.harvest_id_seq OWNED BY public.harvest.id;


--
-- TOC entry 236 (class 1259 OID 36637)
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
-- TOC entry 237 (class 1259 OID 36642)
-- Name: irrigation_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.irrigation_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.irrigation_history_id_seq OWNER TO postgres;

--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 237
-- Name: irrigation_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.irrigation_history_id_seq OWNED BY public.irrigation_history.id;


--
-- TOC entry 238 (class 1259 OID 36643)
-- Name: plant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plant (
    id bigint NOT NULL,
    plant_name character varying(255) NOT NULL,
    description character varying(255)
);


ALTER TABLE public.plant OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 36648)
-- Name: plant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plant_id_seq OWNER TO postgres;

--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 239
-- Name: plant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plant_id_seq OWNED BY public.plant.id;


--
-- TOC entry 240 (class 1259 OID 36649)
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
-- TOC entry 241 (class 1259 OID 36658)
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
-- TOC entry 242 (class 1259 OID 36662)
-- Name: sensor_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sensor_data_id_seq OWNER TO postgres;

--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 242
-- Name: sensor_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_data_id_seq OWNED BY public.sensor_data.id;


--
-- TOC entry 243 (class 1259 OID 36663)
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sensor_id_seq OWNER TO postgres;

--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 243
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_id_seq OWNED BY public.sensor.id;


--
-- TOC entry 247 (class 1259 OID 44719)
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
-- TOC entry 246 (class 1259 OID 44718)
-- Name: sensor_node_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sensor_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sensor_node_id_seq OWNER TO postgres;

--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 246
-- Name: sensor_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sensor_node_id_seq OWNED BY public.sensor_node.id;


--
-- TOC entry 244 (class 1259 OID 36664)
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
-- TOC entry 245 (class 1259 OID 36667)
-- Name: warning_threshold_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.warning_threshold_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.warning_threshold_id_seq OWNER TO postgres;

--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 245
-- Name: warning_threshold_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.warning_threshold_id_seq OWNED BY public.warning_threshold.id;


--
-- TOC entry 4816 (class 2604 OID 36668)
-- Name: account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 36669)
-- Name: alert id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert ALTER COLUMN id SET DEFAULT nextval('public.alert_id_seq'::regclass);


--
-- TOC entry 4821 (class 2604 OID 36670)
-- Name: coordinates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates ALTER COLUMN id SET DEFAULT nextval('public.coordinates_id_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 36671)
-- Name: crop_growth_stage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_growth_stage ALTER COLUMN id SET DEFAULT nextval('public.crop_growth_stage_id_seq'::regclass);


--
-- TOC entry 4823 (class 2604 OID 36672)
-- Name: crop_season id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season ALTER COLUMN id SET DEFAULT nextval('public.crop_season_id_seq'::regclass);


--
-- TOC entry 4824 (class 2604 OID 36673)
-- Name: farm id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm ALTER COLUMN id SET DEFAULT nextval('public.farm_id_seq'::regclass);


--
-- TOC entry 4825 (class 2604 OID 36674)
-- Name: fertilization_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fertilization_history ALTER COLUMN id SET DEFAULT nextval('public.fertilization_history_id_seq'::regclass);


--
-- TOC entry 4826 (class 2604 OID 36675)
-- Name: field id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field ALTER COLUMN id SET DEFAULT nextval('public.field_id_seq'::regclass);


--
-- TOC entry 4829 (class 2604 OID 36676)
-- Name: harvest id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest ALTER COLUMN id SET DEFAULT nextval('public.harvest_id_seq'::regclass);


--
-- TOC entry 4830 (class 2604 OID 36677)
-- Name: irrigation_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irrigation_history ALTER COLUMN id SET DEFAULT nextval('public.irrigation_history_id_seq'::regclass);


--
-- TOC entry 4832 (class 2604 OID 36678)
-- Name: plant id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant ALTER COLUMN id SET DEFAULT nextval('public.plant_id_seq'::regclass);


--
-- TOC entry 4833 (class 2604 OID 44479)
-- Name: sensor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor ALTER COLUMN id SET DEFAULT nextval('public.sensor_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 36680)
-- Name: sensor_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_data ALTER COLUMN id SET DEFAULT nextval('public.sensor_data_id_seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 44722)
-- Name: sensor_node id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_node ALTER COLUMN id SET DEFAULT nextval('public.sensor_node_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 36681)
-- Name: warning_threshold id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warning_threshold ALTER COLUMN id SET DEFAULT nextval('public.warning_threshold_id_seq'::regclass);


--
-- TOC entry 5040 (class 0 OID 36580)
-- Dependencies: 217
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
\.


--
-- TOC entry 5042 (class 0 OID 36589)
-- Dependencies: 219
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
\.


--
-- TOC entry 5043 (class 0 OID 36592)
-- Dependencies: 220
-- Data for Name: alert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alert (id, field_id, message, status, "timestamp", owner_id, sensor_id, group_type) FROM stdin;
18	1	Alert for sensorTemperatureWARNING	WARNING	2025-05-31 10:21:32.052776	2	2	s
19	1	Alert for sensorTemperatureGOOD	GOOD	2025-06-04 22:51:36.408297	1	1	s
20	1	Alert for sensorTemperatureGOOD	GOOD	2025-06-04 22:51:36.458432	2	2	s
22	1	Alert for sensorTemperatureWARNING	WARNING	2025-06-04 22:51:47.353129	2	2	s
23	1	Alert for sensorTemperatureGOOD	GOOD	2025-06-04 22:59:33.284056	2	2	s
24	1	Alert for sensor TemperatureGood	Good	2025-06-05 21:57:43.545642	1	1	s
25	1	Alert for sensor TemperatureCritical	Critical	2025-06-05 21:57:43.589244	2	2	s
26	2	Alert for sensor Critical	Critical	2025-06-05 21:57:43.605329	4	4	s
27	1	Alert for sensor TemperatureGood	Good	2025-06-05 21:58:19.893495	2	2	s
28	1	Alert for sensor TemperatureGood	Good	2025-06-05 22:00:46.454003	2	2	s
29	1	Alert for sensor  TemperatureGood	Good	2025-06-05 22:18:26.205603	2	2	s
30	2	Alert for sensor S oil MoistureCritical	Critical	2025-06-05 22:22:44.693884	3	3	s
31	2	Alert for sensor S oil MoistureCritical	Critical	2025-06-05 22:23:57.753667	3	3	s
32	2	Alert for sensor S oil MoistureCritical	Critical	2025-06-05 22:24:37.407266	3	3	s
33	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:26:24.570458	3	3	s
34	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:28:59.791779	3	3	s
35	1	Alert for sensor  TemperatureGood	Good	2025-06-05 22:28:59.792285	1	1	s
36	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:28:59.709524	3	3	s
37	1	Alert for sensor  TemperatureCritical	Critical	2025-06-05 22:28:59.930776	2	2	s
38	2	Alert for sensor Soil MoistureWarning	Warning	2025-06-05 22:28:59.949628	3	3	s
39	2	Alert for sensor  HumidityGood	Good	2025-06-05 22:28:59.966555	4	4	s
40	2	Alert for sensor Soil MoistureCritical	Critical	2025-06-05 22:30:10.322927	3	3	s
41	2	Alert for sensor  HumidityCritical	Critical	2025-06-05 22:32:18.333995	4	4	s
42	1	Alert for sensor  TemperatureWarning	Warning	2025-06-06 12:34:45.510961	1	1	s
44	2	Alert for sensor Soil MoistureGood	Good	2025-06-06 12:34:45.5843	3	3	s
45	2	Alert for sensor  HumidityGood	Good	2025-06-06 12:34:45.599635	4	4	s
46	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:40:12.922566	4	4	s
47	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:40:12.81058	4	4	s
48	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:40:12.996812	2	2	s
49	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:41:10.528842	4	4	s
50	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:41:10.617894	2	2	s
52	2	Alert for sensor  HumidityCritical	Critical	2025-06-06 12:42:05.413432	4	4	s
51	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:42:05.444744	2	2	s
53	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:42:05.513976	2	2	s
54	1	Alert for sensor  TemperatureCritical	Critical	2025-06-06 12:44:31.839941	2	2	s
55	1	Alert for sensor TemperatureCritical	Critical	2025-06-06 14:41:35.571902	1	1	s
56	1	Alert for sensor TemperatureCritical	Critical	2025-06-06 14:41:35.618206	2	2	s
57	2	Alert for sensor Soil MoistureWarning	Warning	2025-06-06 14:41:35.631796	3	3	s
58	2	Alert for sensor HumidityWarning	Warning	2025-06-06 14:41:35.645794	4	4	s
59	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 13:45:03.923527	1	1	s
60	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 13:45:04.124461	2	2	s
61	2	Alert for sensor Soil MoistureGood	Good	2025-07-27 13:45:04.240589	3	3	s
62	2	Alert for sensor HumidityCritical	Critical	2025-07-27 13:45:04.351232	4	4	s
63	1	Alert for sensor TemperatureGood	Good	2025-07-27 13:45:09.416416	1	1	s
64	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 13:45:09.489988	2	2	s
65	2	Alert for sensor Soil MoistureGood	Good	2025-07-27 13:45:09.609743	3	3	s
66	2	Alert for sensor HumidityGood	Good	2025-07-27 13:45:09.800696	4	4	s
67	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:15:09.43563	1	1	s
68	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:15:09.60618	2	2	s
69	2	Alert for sensor Soil MoistureWarning	Warning	2025-07-27 14:15:09.71393	3	3	s
70	2	Alert for sensor HumidityGood	Good	2025-07-27 14:15:09.86324	4	4	s
71	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:45:09.428353	1	1	s
72	1	Alert for sensor TemperatureCritical	Critical	2025-07-27 14:45:09.526081	2	2	s
73	2	Alert for sensor Soil MoistureGood	Good	2025-07-27 14:45:09.625255	3	3	s
74	2	Alert for sensor HumidityCritical	Critical	2025-07-27 14:45:09.686711	4	4	s
43	1	Alert for sensor  TemperatureCritical	GOOD	2025-06-06 12:34:45.568661	2	2	s
17	1	Alert for sensorTemperatureCRITICAL	GOOD	2025-05-31 10:21:31.941154	1	1	s
21	1	Alert for sensorTemperatureCRITICAL	GOOD	2025-06-04 22:51:47.338007	1	1	s
\.


--
-- TOC entry 5045 (class 0 OID 36599)
-- Dependencies: 222
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
-- TOC entry 5047 (class 0 OID 36603)
-- Dependencies: 224
-- Data for Name: crop_growth_stage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crop_growth_stage (id, plant_id, stage_name, min_day, max_day, description) FROM stdin;
1	1	Germination	1	7	Seed begins to sprout.
2	1	Vegetative	8	30	Leaf and root growth.
3	2	Flowering	31	45	Flowers start forming.
4	2	Fruiting	46	75	Tomatoes grow and ripen.
\.


--
-- TOC entry 5049 (class 0 OID 36609)
-- Dependencies: 226
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
-- TOC entry 5051 (class 0 OID 36615)
-- Dependencies: 228
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farm (id, farm_name, owner_id, lat, lng, area, region) FROM stdin;
2	Farm Demo1	3	10.82037	106.62966	7.5	Khu vực B
1	Green Farm	3	10.762622	106.660172	5	TP. Đà Lạt
3	Sunny Farm	3	10.56432	106.34256	8	TP. Tuy Hòa
\.


--
-- TOC entry 5053 (class 0 OID 36621)
-- Dependencies: 230
-- Data for Name: fertilization_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fertilization_history (id, field_id, fertilizer_type, fertilizer_amount, fertilization_date) FROM stdin;
1	1	Nitrogen	10.5	2025-03-15
2	2	Phosphorus	8	2025-06-10
3	1	NPK 20-20-15	2.5	2025-05-17
\.


--
-- TOC entry 5055 (class 0 OID 36625)
-- Dependencies: 232
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
-- TOC entry 5057 (class 0 OID 36633)
-- Dependencies: 234
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
-- TOC entry 5059 (class 0 OID 36637)
-- Dependencies: 236
-- Data for Name: irrigation_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irrigation_history (id, field_id, action, "timestamp") FROM stdin;
1	1	Start	2025-03-20 08:00:00
2	2	Stop	2025-06-12 07:30:00
\.


--
-- TOC entry 5061 (class 0 OID 36643)
-- Dependencies: 238
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
-- TOC entry 5063 (class 0 OID 36649)
-- Dependencies: 240
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
-- TOC entry 5064 (class 0 OID 36658)
-- Dependencies: 241
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
\.


--
-- TOC entry 5070 (class 0 OID 44719)
-- Dependencies: 247
-- Data for Name: sensor_node; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sensor_node (id, name, field_id, note) FROM stdin;
\.


--
-- TOC entry 5067 (class 0 OID 36664)
-- Dependencies: 244
-- Data for Name: warning_threshold; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warning_threshold (id, crop_season_id, min_temperature, max_temperature, min_humidity, max_humidity, min_soil_moisture, max_soil_moisture, group_type) FROM stdin;
1	1	10	25	50	80	30	60	\N
2	2	16	34	45	75	25	55	\N
\.


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 218
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.account_id_seq', 49, true);


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 221
-- Name: alert_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alert_id_seq', 74, true);


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 223
-- Name: coordinates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coordinates_id_seq', 34, true);


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 225
-- Name: crop_growth_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_growth_stage_id_seq', 4, true);


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 227
-- Name: crop_season_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_season_id_seq', 84, true);


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 229
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farm_id_seq', 3, true);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 231
-- Name: fertilization_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fertilization_history_id_seq', 3, true);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 233
-- Name: field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.field_id_seq', 9, true);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 235
-- Name: harvest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.harvest_id_seq', 33, true);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 237
-- Name: irrigation_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.irrigation_history_id_seq', 2, true);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 239
-- Name: plant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plant_id_seq', 11, true);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 242
-- Name: sensor_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_data_id_seq', 326, true);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 243
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_id_seq', 11, true);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 246
-- Name: sensor_node_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sensor_node_id_seq', 1, false);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 245
-- Name: warning_threshold_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.warning_threshold_id_seq', 2, true);


--
-- TOC entry 4845 (class 2606 OID 36683)
-- Name: account account_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_email_key UNIQUE (email);


--
-- TOC entry 4847 (class 2606 OID 36685)
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 36687)
-- Name: coordinates coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates
    ADD CONSTRAINT coordinates_pkey PRIMARY KEY (id);


--
-- TOC entry 4851 (class 2606 OID 36689)
-- Name: crop_growth_stage crop_growth_stage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_growth_stage
    ADD CONSTRAINT crop_growth_stage_pkey PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 36691)
-- Name: crop_season crop_season_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season
    ADD CONSTRAINT crop_season_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 36693)
-- Name: farm farm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 2606 OID 36695)
-- Name: fertilization_history fertilization_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fertilization_history
    ADD CONSTRAINT fertilization_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4859 (class 2606 OID 36697)
-- Name: field field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field
    ADD CONSTRAINT field_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 36699)
-- Name: harvest harvest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest
    ADD CONSTRAINT harvest_pkey PRIMARY KEY (id);


--
-- TOC entry 4863 (class 2606 OID 36701)
-- Name: irrigation_history irrigation_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irrigation_history
    ADD CONSTRAINT irrigation_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 36703)
-- Name: plant plant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant
    ADD CONSTRAINT plant_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 36705)
-- Name: plant plant_plant_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plant
    ADD CONSTRAINT plant_plant_name_key UNIQUE (plant_name);


--
-- TOC entry 4871 (class 2606 OID 36707)
-- Name: sensor_data sensor_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT sensor_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 44726)
-- Name: sensor_node sensor_node_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_node
    ADD CONSTRAINT sensor_node_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 36709)
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 36711)
-- Name: warning_threshold warning_threshold_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warning_threshold
    ADD CONSTRAINT warning_threshold_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 36712)
-- Name: coordinates coordinates_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordinates
    ADD CONSTRAINT coordinates_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- TOC entry 4882 (class 2606 OID 36717)
-- Name: crop_growth_stage crop_growth_stage_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_growth_stage
    ADD CONSTRAINT crop_growth_stage_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant(id) ON DELETE CASCADE;


--
-- TOC entry 4883 (class 2606 OID 36722)
-- Name: crop_season crop_season_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season
    ADD CONSTRAINT crop_season_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- TOC entry 4884 (class 2606 OID 36727)
-- Name: crop_season crop_season_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_season
    ADD CONSTRAINT crop_season_plant_id_fkey FOREIGN KEY (plant_id) REFERENCES public.plant(id) ON DELETE CASCADE;


--
-- TOC entry 4885 (class 2606 OID 36732)
-- Name: farm farm_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farm
    ADD CONSTRAINT farm_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.account(id) ON DELETE CASCADE;


--
-- TOC entry 4886 (class 2606 OID 36737)
-- Name: fertilization_history fertilization_history_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fertilization_history
    ADD CONSTRAINT fertilization_history_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- TOC entry 4887 (class 2606 OID 36742)
-- Name: field field_farm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field
    ADD CONSTRAINT field_farm_id_fkey FOREIGN KEY (farm_id) REFERENCES public.farm(id) ON DELETE CASCADE;


--
-- TOC entry 4879 (class 2606 OID 36747)
-- Name: alert fk131rhyexaxwrt1fu1mk2g7f1n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT fk131rhyexaxwrt1fu1mk2g7f1n FOREIGN KEY (sensor_id) REFERENCES public.sensor(id);


--
-- TOC entry 4876 (class 2606 OID 36752)
-- Name: account fk2g8tsivyiqx51qd9jdktcuo56; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk2g8tsivyiqx51qd9jdktcuo56 FOREIGN KEY (field_id) REFERENCES public.field(id);


--
-- TOC entry 4880 (class 2606 OID 36757)
-- Name: alert fk3xx123j396c42mgw5v8vhqgf1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alert
    ADD CONSTRAINT fk3xx123j396c42mgw5v8vhqgf1 FOREIGN KEY (field_id) REFERENCES public.field(id);


--
-- TOC entry 4878 (class 2606 OID 36762)
-- Name: account_roles fk_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_roles
    ADD CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES public.account(id) ON DELETE CASCADE;


--
-- TOC entry 4877 (class 2606 OID 36767)
-- Name: account fkih9sjj23m5xdbw2rr54rmawus; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fkih9sjj23m5xdbw2rr54rmawus FOREIGN KEY (farm_id) REFERENCES public.farm(id);


--
-- TOC entry 4888 (class 2606 OID 36772)
-- Name: field fkld9jefpehl8rkm1jewqs64bqn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.field
    ADD CONSTRAINT fkld9jefpehl8rkm1jewqs64bqn FOREIGN KEY (crop_season_id) REFERENCES public.crop_season(id);


--
-- TOC entry 4891 (class 2606 OID 36777)
-- Name: sensor fkpem65e5c3qxi0cj421bikqk5q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT fkpem65e5c3qxi0cj421bikqk5q FOREIGN KEY (farm_id) REFERENCES public.farm(id);


--
-- TOC entry 4889 (class 2606 OID 36782)
-- Name: harvest harvest_crop_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest
    ADD CONSTRAINT harvest_crop_season_id_fkey FOREIGN KEY (crop_season_id) REFERENCES public.crop_season(id) ON DELETE CASCADE;


--
-- TOC entry 4890 (class 2606 OID 36787)
-- Name: irrigation_history irrigation_history_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irrigation_history
    ADD CONSTRAINT irrigation_history_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- TOC entry 4893 (class 2606 OID 36792)
-- Name: sensor_data sensor_data_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT sensor_data_sensor_id_fkey FOREIGN KEY (sensor_id) REFERENCES public.sensor(id) ON DELETE CASCADE;


--
-- TOC entry 4892 (class 2606 OID 36797)
-- Name: sensor sensor_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_field_id_fkey FOREIGN KEY (field_id) REFERENCES public.field(id) ON DELETE CASCADE;


--
-- TOC entry 4894 (class 2606 OID 36802)
-- Name: warning_threshold warning_threshold_crop_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warning_threshold
    ADD CONSTRAINT warning_threshold_crop_season_id_fkey FOREIGN KEY (crop_season_id) REFERENCES public.crop_season(id) ON DELETE CASCADE;


-- Completed on 2025-11-07 15:04:19

--
-- PostgreSQL database dump complete
--

