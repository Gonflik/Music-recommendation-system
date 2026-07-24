--
-- PostgreSQL database dump
--

\restrict E57nd2lWDXux37VTXf55DgOkA8P6cmZDsRZMtvqTfNl4uqeBcNOrfRpZIlSpU5z

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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

--
-- Name: action_name_enum; Type: TYPE; Schema: public; Owner: testdranik
--

CREATE TYPE public.action_name_enum AS ENUM (
    'ALBUM_SHOW',
    'ARTIST_SHOW',
    'ADD_TO_LISTEN',
    'RATE_ALBUM',
    'RATE_SONG'
);


ALTER TYPE public.action_name_enum OWNER TO testdranik;

--
-- Name: user_action_object_enum; Type: TYPE; Schema: public; Owner: testdranik
--

CREATE TYPE public.user_action_object_enum AS ENUM (
    'ALBUM',
    'SONG',
    'ARTIST'
);


ALTER TYPE public.user_action_object_enum OWNER TO testdranik;

--
-- Name: user_gender_enum; Type: TYPE; Schema: public; Owner: testdranik
--

CREATE TYPE public.user_gender_enum AS ENUM (
    'MALE',
    'FEMALE',
    'NON_BINARY',
    'PREFER_NOT_TO_SAY'
);


ALTER TYPE public.user_gender_enum OWNER TO testdranik;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: testdranik
--

CREATE TYPE public.user_role_enum AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public.user_role_enum OWNER TO testdranik;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.action (
    id integer NOT NULL,
    name public.action_name_enum NOT NULL,
    reference_name public.user_action_object_enum NOT NULL,
    reference_id integer NOT NULL,
    counter integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.action OWNER TO testdranik;

--
-- Name: action_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_id_seq OWNER TO testdranik;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.action_id_seq OWNED BY public.action.id;


--
-- Name: album; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.album (
    id integer NOT NULL,
    dzid bigint NOT NULL,
    name character varying(200) NOT NULL,
    length integer NOT NULL,
    picture character varying NOT NULL,
    artist_id integer NOT NULL,
    ghost_songs_count integer NOT NULL,
    release_date date NOT NULL,
    release_type character varying NOT NULL,
    CONSTRAINT ck_album_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.album OWNER TO testdranik;

--
-- Name: album_genre_association; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.album_genre_association (
    album_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.album_genre_association OWNER TO testdranik;

--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.album_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.album_id_seq OWNER TO testdranik;

--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.album_id_seq OWNED BY public.album.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO testdranik;

--
-- Name: artist; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.artist (
    id integer NOT NULL,
    dzid bigint NOT NULL,
    name character varying(100) NOT NULL,
    picture character varying NOT NULL,
    ghost_albums_count integer NOT NULL,
    CONSTRAINT ck_artist_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.artist OWNER TO testdranik;

--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artist_id_seq OWNER TO testdranik;

--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.artist_id_seq OWNED BY public.artist.id;


--
-- Name: artist_song_association; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.artist_song_association (
    artist_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE public.artist_song_association OWNER TO testdranik;

--
-- Name: genre; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.genre (
    id integer NOT NULL,
    dzid integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.genre OWNER TO testdranik;

--
-- Name: genre_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genre_id_seq OWNER TO testdranik;

--
-- Name: genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.genre_id_seq OWNED BY public.genre.id;


--
-- Name: rating; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.rating (
    id integer NOT NULL,
    score integer NOT NULL,
    description text,
    album_id integer,
    song_id integer,
    user_id integer NOT NULL,
    CONSTRAINT ck_rating_score_range CHECK (((score >= 0) AND (score <= 10)))
);


ALTER TABLE public.rating OWNER TO testdranik;

--
-- Name: rating_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.rating_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rating_id_seq OWNER TO testdranik;

--
-- Name: rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.rating_id_seq OWNED BY public.rating.id;


--
-- Name: song; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.song (
    id integer NOT NULL,
    dzid bigint NOT NULL,
    name character varying(100) NOT NULL,
    length integer NOT NULL,
    song_position integer NOT NULL,
    picture character varying NOT NULL,
    preview character varying NOT NULL,
    album_id integer,
    CONSTRAINT ck_length_value CHECK ((length > 30)),
    CONSTRAINT ck_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.song OWNER TO testdranik;

--
-- Name: song_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.song_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.song_id_seq OWNER TO testdranik;

--
-- Name: song_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.song_id_seq OWNED BY public.song.id;


--
-- Name: tokenblocklist; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.tokenblocklist (
    id integer NOT NULL,
    jti character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tokenblocklist OWNER TO testdranik;

--
-- Name: tokenblocklist_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.tokenblocklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tokenblocklist_id_seq OWNER TO testdranik;

--
-- Name: tokenblocklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.tokenblocklist_id_seq OWNED BY public.tokenblocklist.id;


--
-- Name: tolisten; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public.tolisten (
    id integer NOT NULL,
    note character varying(300) NOT NULL,
    user_id integer NOT NULL,
    album_id integer NOT NULL
);


ALTER TABLE public.tolisten OWNER TO testdranik;

--
-- Name: tolisten_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.tolisten_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tolisten_id_seq OWNER TO testdranik;

--
-- Name: tolisten_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.tolisten_id_seq OWNED BY public.tolisten.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: testdranik
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    email character varying(100) NOT NULL,
    role public.user_role_enum NOT NULL,
    password character varying NOT NULL,
    age integer,
    gender public.user_gender_enum NOT NULL,
    location character varying(100),
    CONSTRAINT ck_user_age_range CHECK (((age >= 6) AND (age <= 119))),
    CONSTRAINT ck_user_email_form CHECK (((email)::text ~~ '%_@__%.__%'::text)),
    CONSTRAINT ck_user_location_length CHECK ((length((location)::text) > 1)),
    CONSTRAINT ck_user_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public."user" OWNER TO testdranik;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: testdranik
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO testdranik;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: testdranik
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: action id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.action ALTER COLUMN id SET DEFAULT nextval('public.action_id_seq'::regclass);


--
-- Name: album id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album ALTER COLUMN id SET DEFAULT nextval('public.album_id_seq'::regclass);


--
-- Name: artist id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.artist ALTER COLUMN id SET DEFAULT nextval('public.artist_id_seq'::regclass);


--
-- Name: genre id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.genre ALTER COLUMN id SET DEFAULT nextval('public.genre_id_seq'::regclass);


--
-- Name: rating id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating ALTER COLUMN id SET DEFAULT nextval('public.rating_id_seq'::regclass);


--
-- Name: song id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.song ALTER COLUMN id SET DEFAULT nextval('public.song_id_seq'::regclass);


--
-- Name: tokenblocklist id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tokenblocklist ALTER COLUMN id SET DEFAULT nextval('public.tokenblocklist_id_seq'::regclass);


--
-- Name: tolisten id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tolisten ALTER COLUMN id SET DEFAULT nextval('public.tolisten_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: action; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.action (id, name, reference_name, reference_id, counter, "timestamp", user_id) FROM stdin;
10	RATE_SONG	SONG	175	1	2026-04-16 11:20:39.036394	1
11	ALBUM_SHOW	ALBUM	116	4	2026-04-17 23:42:31.290827	1
12	ADD_TO_LISTEN	ALBUM	116	1	2026-04-17 23:44:28.054028	1
13	RATE_ALBUM	ALBUM	116	1	2026-04-17 23:45:29.450497	1
15	RATE_SONG	SONG	190	1	2026-04-19 11:17:36.418336	1
16	ALBUM_SHOW	ALBUM	128	1	2026-04-22 17:15:42.237924	1
14	ALBUM_SHOW	ALBUM	99	2	2026-04-17 23:47:41.909967	1
17	RATE_ALBUM	ALBUM	151	1	2026-04-25 21:18:33.69869	2
18	RATE_ALBUM	ALBUM	163	1	2026-04-25 21:24:08.422083	2
19	RATE_ALBUM	ALBUM	186	1	2026-04-25 21:25:16.752669	2
20	ADD_TO_LISTEN	ALBUM	186	2	2026-04-25 21:25:49.55641	2
21	RATE_ALBUM	ALBUM	220	2	2026-04-26 09:59:33.095886	3
22	RATE_ALBUM	ALBUM	229	1	2026-04-26 10:01:18.064106	3
23	RATE_SONG	SONG	286	1	2026-04-26 10:03:23.867288	3
24	ADD_TO_LISTEN	ALBUM	253	1	2026-04-26 10:15:31.79332	3
25	RATE_SONG	SONG	304	1	2026-04-26 10:16:40.811852	3
26	RATE_ALBUM	ALBUM	269	1	2026-04-30 15:12:40.855365	3
\.


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.album (id, dzid, name, length, picture, artist_id, ghost_songs_count, release_date, release_type) FROM stdin;
122	603134172	Mauvaise foi	2372	https://api.deezer.com/album/603134172/image	121	15	2010-01-01	album
123	600636262	Chateau de France	1223	https://api.deezer.com/album/600636262/image	121	6	2010-01-01	ep
124	600488552	Tu L'As Bien Mérité!	2649	https://api.deezer.com/album/600488552/image	121	16	2009-05-07	album
125	600488512	Cyril	2231	https://api.deezer.com/album/600488512/image	121	14	2010-06-21	album
126	600636302	Marre marre marre	2218	https://api.deezer.com/album/600636302/image	121	12	2008-03-03	album
127	604458542	Vous n'allez pas repartir les mains vides?	4035	https://api.deezer.com/album/604458542/image	121	32	2013-05-13	album
128	6414905	Comedown Machine	2389	https://api.deezer.com/album/6414905/image	126	11	2013-03-22	album
129	629800531	Live & Destroy	2917	https://api.deezer.com/album/629800531/image	127	11	2014-10-06	album
130	329338227	30 Something (Deluxe Version)	5104	https://api.deezer.com/album/329338227/image	128	33	1991-01-01	album
131	203110682	Трэп, который мы заслужили	1388	https://api.deezer.com/album/203110682/image	131	7	2020-12-25	album
132	180497152	жвачка	1723	https://api.deezer.com/album/180497152/image	132	9	2020-10-30	album
133	308977677	Моргенштерн Скриптонит Легенда	85	https://api.deezer.com/album/308977677/image	133	1	2022-05-01	single
134	356999357	Привет, это последнее ЕР перед фитом с Моргенштерном	839	https://api.deezer.com/album/356999357/image	134	5	2022-09-16	ep
135	9298172	ХА-ХА-ХА	2389	https://api.deezer.com/album/9298172/image	136	14	2012-01-01	album
136	250776582	Чёрный пистолет	96	https://api.deezer.com/album/250776582/image	135	1	2021-08-13	single
137	150454752	AIBYVAIBY	1525	https://api.deezer.com/album/150454752/image	137	10	2020-06-05	album
138	175833112	Сон под пятницу	3725	https://api.deezer.com/album/175833112/image	138	50	2017-11-11	album
139	10355768	Как здорово, что все мы здесь сегодня собрались! (Четверть века спустя)	4180	https://api.deezer.com/album/10355768/image	139	21	2015-05-18	album
140	597994842	Кадиллак	114	https://api.deezer.com/album/597994842/image	140	1	2024-06-07	single
141	8215110	Чёрный кадиллак, Ч. 2	2409	https://api.deezer.com/album/8215110/image	141	9	2014-07-22	album
142	8193306	Чёрный кадиллак, Ч. 1	2530	https://api.deezer.com/album/8193306/image	141	8	2014-07-19	album
143	81869102	Динозаври кадилаци	142	https://api.deezer.com/album/81869102/image	142	1	2024-01-20	single
144	911094891	Каділак	149	https://api.deezer.com/album/911094891/image	143	1	2026-02-03	single
148	635940221	Thing	234	https://api.deezer.com/album/635940221/image	150	1	2018-01-01	single
149	106462	I Am A Bird Now	2124	https://api.deezer.com/album/106462/image	151	10	2005-02-07	album
150	264782602	Rated Z	2343	https://api.deezer.com/album/264782602/image	152	8	2021-10-22	album
151	401340	Whatever People Say I Am, That's What I'm Not	2462	https://api.deezer.com/album/401340/image	99	13	2006-02-18	album
190	895811902	If	2702	https://api.deezer.com/album/895811902/image	186	15	2008-04-29	album
191	791483241	DON'T TAP THE GLASS	1707	https://api.deezer.com/album/791483241/image	187	10	2025-07-21	album
192	662648981	CHROMAKOPIA	3177	https://api.deezer.com/album/662648981/image	187	14	2024-10-28	album
193	44730061	Flower Boy	2794	https://api.deezer.com/album/44730061/image	187	14	2017-07-21	album
194	97140952	IGOR	2383	https://api.deezer.com/album/97140952/image	187	12	2019-05-17	album
195	1129652	Goblin	4926	https://api.deezer.com/album/1129652/image	187	18	2011-05-09	album
202	910510411	Dracula (Remix)	414	https://api.deezer.com/album/910510411/image	13	2	2026-02-06	single
203	825550621	Dracula	205	https://api.deezer.com/album/825550621/image	13	1	2025-09-26	single
204	130876272	The Slow Rush	3447	https://api.deezer.com/album/130876272/image	13	12	2020-02-14	album
205	76298222	InnerSpeaker	3201	https://api.deezer.com/album/76298222/image	13	11	2018-10-26	album
206	837961612	Deadbeat	3361	https://api.deezer.com/album/837961612/image	13	12	2025-10-17	album
210	950475551	Crush on you	125	https://api.deezer.com/album/950475551/image	193	1	2024-07-12	single
211	720461471	Счастливая	121	https://api.deezer.com/album/720461471/image	188	1	2025-03-07	single
212	6398213	Романсы	4789	https://api.deezer.com/album/6398213/image	194	18	2013-02-08	album
213	13197514	Песнопения иеромонаха Романа	5278	https://api.deezer.com/album/13197514/image	195	18	2016-05-27	album
214	12218542	Молюсь	3043	https://api.deezer.com/album/12218542/image	196	10	2016-01-29	album
215	502453341	Ой Ой	120	https://api.deezer.com/album/502453341/image	197	1	2023-10-20	single
216	177755132	Отбой	148	https://api.deezer.com/album/177755132/image	198	1	2020-10-05	single
163	177830722	Destructive Amplifier	1371	https://api.deezer.com/album/177830722/image	173	6	2015-06-17	ep
164	177830412	Sol-fa	2787	https://api.deezer.com/album/177830412/image	173	12	2015-06-17	album
165	151783792	Re:Re:	506	https://api.deezer.com/album/151783792/image	173	2	2016-03-16	single
166	151792242	Blood Circulator	405	https://api.deezer.com/album/151792242/image	173	2	2016-07-13	single
167	946143681	Skins	245	https://api.deezer.com/album/946143681/image	173	1	2026-04-03	single
168	177833132	BEST HIT AKG	4458	https://api.deezer.com/album/177833132/image	173	17	2015-06-17	album
169	95826372	Here Comes The Cowboy	2786	https://api.deezer.com/album/95826372/image	178	13	2019-05-10	album
170	7533292	Salad Days	2087	https://api.deezer.com/album/7533292/image	178	11	2014-04-01	album
171	6158996	2	1887	https://api.deezer.com/album/6158996/image	178	11	2012-10-16	album
172	39511351	This Old Dog	2550	https://api.deezer.com/album/39511351/image	178	13	2017-05-05	album
173	429737827	One Wayne G	4040	https://api.deezer.com/album/429737827/image	178	199	2023-04-21	album
174	14880711	Pablo Honey	2529	https://api.deezer.com/album/14880711/image	180	12	1993-02-22	album
175	14879699	OK Computer	3216	https://api.deezer.com/album/14879699/image	180	12	1997-06-17	album
176	14879583	No Surprises	641	https://api.deezer.com/album/14879583/image	180	3	1998-01-12	single
177	14880317	The Bends	2914	https://api.deezer.com/album/14880317/image	180	12	1994-11-01	album
178	14880659	In Rainbows	2554	https://api.deezer.com/album/14880659/image	180	10	2007-12-28	album
179	14880741	Kid A	2826	https://api.deezer.com/album/14880741/image	180	11	2000-10-02	album
180	584380142	Metaphorical Music	3744	https://api.deezer.com/album/584380142/image	1	15	2017-12-13	album
181	584402082	Luv(sic) Hexalogy	7702	https://api.deezer.com/album/584402082/image	1	26	2015-12-09	album
182	584383232	Spiritual State	3622	https://api.deezer.com/album/584383232/image	1	14	2011-12-03	album
183	584380342	Modal Soul	3810	https://api.deezer.com/album/584380342/image	1	14	2005-11-11	album
184	526029192	samurai champloo music record departure	4085	https://api.deezer.com/album/526029192/image	185	17	2015-04-15	album
185	596251	Frankenstein Girls Will Seem Strangely Sexy	2737	https://api.deezer.com/album/596251/image	186	30	2000-02-11	album
186	605282412	MSI B-SIDES vol.1	2176	https://api.deezer.com/album/605282412/image	186	13	2024-06-22	album
187	857119022	PINK	3277	https://api.deezer.com/album/857119022/image	186	19	2015-09-18	album
188	900775892	Tighter	2787	https://api.deezer.com/album/900775892/image	186	27	2026-01-28	album
189	740768	You'll Rebel to Anything (Expanded and Remastered 2008)	2259	https://api.deezer.com/album/740768/image	186	14	2008-01-22	album
25	222850892	Dear Wormwood	2342	https://api.deezer.com/album/222850892/image	26	13	2015-10-16	album
26	394743357	The Death We Seek	2389	https://api.deezer.com/album/394743357/image	8	10	2023-05-05	album
27	137306592	The Way It Ends	2325	https://api.deezer.com/album/137306592/image	8	11	2020-06-05	album
28	831248571	All That Follows	1199	https://api.deezer.com/album/831248571/image	8	5	2025-10-31	ep
29	10709540	Currents	3064	https://api.deezer.com/album/10709540/image	13	13	2015-07-17	album
30	92438682	The Place I Feel Safest	3018	https://api.deezer.com/album/92438682/image	8	13	2017-06-16	album
31	90903372	The Place I Feel Safest (Instrumental)	3018	https://api.deezer.com/album/90903372/image	8	13	2018-05-04	album
32	85335372	I Let the Devil In	2320	https://api.deezer.com/album/85335372/image	8	10	2018-12-14	ep
33	7347091	Victimized	1152	https://api.deezer.com/album/7347091/image	8	5	2013-01-20	ep
34	9492170	Life // Lost	1796	https://api.deezer.com/album/9492170/image	8	8	2015-02-01	ep
35	809362641	bad luck	252	https://api.deezer.com/album/809362641/image	19	1	2025-09-10	single
36	775053491	It Only Gets Darker	271	https://api.deezer.com/album/775053491/image	8	1	2025-07-18	single
37	51431732	Currents B-Sides & Remixes	1685	https://api.deezer.com/album/51431732/image	13	5	2017-11-17	ep
38	952353611	Roofless Records For Drop Tops: Disc 1	1849	https://api.deezer.com/album/952353611/image	25	10	2026-04-02	album
39	919938201	Currents on Audiotree Live	1456	https://api.deezer.com/album/919938201/image	9	6	2026-03-11	ep
40	372800377	Vengeance	475	https://api.deezer.com/album/372800377/image	8	2	2022-11-25	single
41	596470922	Currents	3387	https://api.deezer.com/album/596470922/image	32	9	2018-02-23	album
42	223848222	Currents	207	https://api.deezer.com/album/223848222/image	33	1	2021-05-07	single
43	216049622	The Way It Ends (Instrumental)	2332	https://api.deezer.com/album/216049622/image	8	11	2020-06-05	album
44	9414152	Currents	1485	https://api.deezer.com/album/9414152/image	34	7	2010-03-09	ep
45	345700437	Currents	161	https://api.deezer.com/album/345700437/image	35	1	2020-03-20	single
46	411353227	Dead Blue	2233	https://api.deezer.com/album/411353227/image	41	11	2016-09-16	album
47	83461462	Currents	238	https://api.deezer.com/album/83461462/image	42	1	2024-02-16	single
48	15771842	Currents	1246	https://api.deezer.com/album/15771842/image	43	7	2017-03-29	album
49	537405862	Currents	456	https://api.deezer.com/album/537405862/image	44	3	2024-02-13	single
50	343550887	The Death We Seek	245	https://api.deezer.com/album/343550887/image	8	1	2022-08-31	single
51	6562898	Currents	3038	https://api.deezer.com/album/6562898/image	45	12	2013-05-28	album
60	945917251	Jane!	187	https://api.deezer.com/album/945917251/image	55	1	2018-07-03	single
61	1254871	Shallow Bay: The Best Of Breaking Benjamin Deluxe Edition (Explicit)	5362	https://api.deezer.com/album/1254871/image	56	24	2011-08-16	album
62	11375984	Zanaka	1993	https://api.deezer.com/album/11375984/image	51	10	2016-10-21	album
63	1543242	Some Nights	2749	https://api.deezer.com/album/1543242/image	57	11	2012-02-21	album
64	942552041	Jane! (Slowed & reverb)	253	https://api.deezer.com/album/942552041/image	58	1	2026-03-16	single
65	943647141	Yoga (Copacabana) - Jersey Club Remix	132	https://api.deezer.com/album/943647141/image	64	1	2026-03-20	single
66	8986017	Reckless	2276	https://api.deezer.com/album/8986017/image	65	10	2014-11-24	album
67	925154	Porque te vas	2008	https://api.deezer.com/album/925154/image	66	10	2011-01-25	album
68	732037221	JANE!	121	https://api.deezer.com/album/732037221/image	67	1	2025-04-05	single
69	794930241	JANE! (pxiqzes remix)	662	https://api.deezer.com/album/794930241/image	68	4	2025-08-08	ep
70	3227271	Songs About Jane: 10th Anniversary Edition	5329	https://api.deezer.com/album/3227271/image	69	29	2012-06-05	album
71	338269	Mary Jane Girls	2155	https://api.deezer.com/album/338269/image	59	8	2009-01-13	album
72	345278	Ritual De Lo Habitual	3093	https://api.deezer.com/album/345278/image	60	9	1990-08-21	album
73	79085832	Greatest Hits	3921	https://api.deezer.com/album/79085832/image	74	18	2018-11-23	album
74	335236727	Samba de Janeiro	2594	https://api.deezer.com/album/335236727/image	75	11	2008-06-20	album
75	322288667	Dinner in America Soundtrack	222	https://api.deezer.com/album/322288667/image	76	2	2024-10-20	single
76	46196432	Still Striving	2902	https://api.deezer.com/album/46196432/image	77	14	2017-08-18	album
77	1484717	Jane Doe	2715	https://api.deezer.com/album/1484717/image	78	12	2012-01-10	album
78	304265	Damita Jo	3893	https://api.deezer.com/album/304265/image	72	22	2004-03-30	album
79	12494534	Jane Birkin & Serge Gainsbourg	1862	https://api.deezer.com/album/12494534/image	54	11	1969-01-01	album
80	361792807	The Velvet Rope (Deluxe Edition)	4960	https://api.deezer.com/album/361792807/image	72	38	2022-10-07	album
81	91985	Three Cheers for Sweet Revenge	2370	https://api.deezer.com/album/91985/image	7	13	2004-06-08	album
82	87903062	Сборник север 3	1787	https://api.deezer.com/album/87903062/image	86	10	2016-01-01	album
83	188912412	Культурний шок	1654	https://api.deezer.com/album/188912412/image	87	8	2020-12-09	album
84	54847902	V$tavляє	2732	https://api.deezer.com/album/54847902/image	87	11	2018-01-18	album
85	89867812	Tomos	735	https://api.deezer.com/album/89867812/image	87	3	2019-03-13	single
86	597350882	BRAT	2483	https://api.deezer.com/album/597350882/image	88	15	2024-06-07	album
87	654424131	Brat and it’s completely different but also still brat	4339	https://api.deezer.com/album/654424131/image	88	34	2024-10-11	album
88	789758081	BRATLAND	2620	https://api.deezer.com/album/789758081/image	89	16	2025-07-18	album
89	656715281	Brat and it’s completely different but also still brat	4270	https://api.deezer.com/album/656715281/image	88	35	2024-10-14	album
90	440835217	BRAT	142	https://api.deezer.com/album/440835217/image	90	1	2023-06-09	single
91	67819132	Losing It	248	https://api.deezer.com/album/67819132/image	96	1	2018-07-13	single
92	76783062	Losing It (Radio Edit)	163	https://api.deezer.com/album/76783062/image	96	1	2018-10-25	single
93	368425367	Her Love Still Haunts Me Like a Ghost	1239	https://api.deezer.com/album/368425367/image	91	7	2022-10-28	album
94	914989941	Love You Right	165	https://api.deezer.com/album/914989941/image	91	1	2026-03-20	single
95	670373061	i cant tell (love my money)	163	https://api.deezer.com/album/670373061/image	91	1	2024-11-22	single
96	186203092	The Lo-Fis	1513	https://api.deezer.com/album/186203092/image	97	15	2020-12-04	album
97	316706887	Fall in Love with You.	132	https://api.deezer.com/album/316706887/image	91	1	2022-05-11	single
98	632901571	8 роздумів	1619	https://api.deezer.com/album/632901571/image	98	8	2024-09-20	album
99	401346	Favourite Worst Nightmare	2280	https://api.deezer.com/album/401346/image	99	12	2007-04-21	album
100	796709881	Imaginal Disk	3216	https://api.deezer.com/album/796709881/image	100	15	2024-08-23	album
101	102960742	Antes e depois (Ao vivo)	4141	https://api.deezer.com/album/102960742/image	101	21	2019-04-19	album
102	639869531	Welcome To Hell	251	https://api.deezer.com/album/639869531/image	104	3	2024-09-27	single
103	895784212	WELCOME TO HELL	209	https://api.deezer.com/album/895784212/image	105	1	2026-02-27	single
104	62822542	Welcome to Hell	5227	https://api.deezer.com/album/62822542/image	106	21	2018-07-27	album
105	85609322	Chuck	2500	https://api.deezer.com/album/85609322/image	107	14	2019-02-01	album
106	1066859	And Then It Got Ugly	2497	https://api.deezer.com/album/1066859/image	108	11	2006-04-18	album
107	467267	The Sound of the Smiths (Deluxe; 2008 Remaster)	4986	https://api.deezer.com/album/467267/image	110	45	2008-11-11	album
108	1261479	Hatful of Hollow	3367	https://api.deezer.com/album/1261479/image	110	16	2001-06-26	album
109	507126981	Should I Stay or Should I Go?	2810	https://api.deezer.com/album/507126981/image	111	13	2024-02-16	album
110	906042682	Look Out Live!	6228	https://api.deezer.com/album/906042682/image	112	22	2025-09-19	album
111	116781012	This Charming Man	184	https://api.deezer.com/album/116781012/image	113	1	2019-10-25	single
112	488748325	This Charming Man	173	https://api.deezer.com/album/488748325/image	114	1	2023-09-16	single
113	259380532	This Charming Man	167	https://api.deezer.com/album/259380532/image	115	1	2021-09-24	single
114	1261473	The Smiths	2733	https://api.deezer.com/album/1261473/image	110	11	2001-06-26	album
115	7025352	You Can Play These Songs With Chords	4013	https://api.deezer.com/album/7025352/image	116	18	2013-10-08	album
116	535677592	hades (the nine stages of change at the deceased remains)	2921	https://api.deezer.com/album/535677592/image	117	10	2015-06-03	album
117	82097	Famous Last Words	739	https://api.deezer.com/album/82097/image	7	3	2007-01-22	single
118	14069820	The Black Parade / Living with Ghosts (The 10th Anniversary Edition)	5391	https://api.deezer.com/album/14069820/image	7	25	2016-09-23	album
119	365894357	Kill All Your Friends	248	https://api.deezer.com/album/365894357/image	118	1	2022-10-13	single
120	571370141	Dreams Of Puke	1231	https://api.deezer.com/album/571370141/image	119	12	2024-06-14	album
121	626101	Unbreakable	1607	https://api.deezer.com/album/626101/image	120	9	2010-09-13	album
217	542824492	Ой ой	126	https://api.deezer.com/album/542824492/image	199	1	2024-02-08	single
218	414325407	Оторвёмся по-питерски	3212	https://api.deezer.com/album/414325407/image	200	14	2005-01-02	album
219	958546541	На двох	150	https://api.deezer.com/album/958546541/image	98	1	2026-04-24	single
220	534392132	темна ч.2	1727	https://api.deezer.com/album/534392132/image	98	11	2024-01-30	album
221	15746602	Hator!	2688	https://api.deezer.com/album/15746602/image	205	10	1993-11-07	album
222	118100602	Euphonic Entropy	3386	https://api.deezer.com/album/118100602/image	206	12	2020-02-14	album
223	489120565	Судоми	146	https://api.deezer.com/album/489120565/image	98	1	2023-09-29	single
224	513276971	IKURRAK	941	https://api.deezer.com/album/513276971/image	207	4	2023-11-20	ep
225	424350887	Недовготривалі відносини	1297	https://api.deezer.com/album/424350887/image	98	9	2023-05-25	album
226	418913827	CVIT	928	https://api.deezer.com/album/418913827/image	98	6	2020-12-16	ep
227	781459041	Пекло	210	https://api.deezer.com/album/781459041/image	98	1	2025-07-25	single
228	768362431	Забудуться жалі	163	https://api.deezer.com/album/768362431/image	213	1	2025-06-19	single
229	422429357	Безодня	130	https://api.deezer.com/album/422429357/image	208	1	2023-04-07	single
230	956596401	Совковий модернізм	163	https://api.deezer.com/album/956596401/image	208	1	2026-04-24	single
231	886928522	Хороший громадянин	166	https://api.deezer.com/album/886928522/image	208	1	2026-01-16	single
232	784655041	Кінець фільму	178	https://api.deezer.com/album/784655041/image	208	1	2025-07-25	single
233	519803712	Місто розбитих надій	146	https://api.deezer.com/album/519803712/image	208	1	2023-12-22	single
234	394603857	Зима	188	https://api.deezer.com/album/394603857/image	208	1	2023-01-09	single
235	647152651	Від людей для людей	868	https://api.deezer.com/album/647152651/image	217	4	2024-10-04	album
236	680542031	Тиха вода	288	https://api.deezer.com/album/680542031/image	218	1	2024-12-05	single
237	524522822	Вибране	6035	https://api.deezer.com/album/524522822/image	219	40	2023-12-16	album
238	482459865	Тиха Вода	212	https://api.deezer.com/album/482459865/image	220	1	2023-09-07	single
239	11201916	Жива вода	2678	https://api.deezer.com/album/11201916/image	221	12	2015-09-22	album
240	945488621	Тиха вода	127	https://api.deezer.com/album/945488621/image	222	1	2026-03-27	single
241	696861421	Тиха вода (Maver Remix)	306	https://api.deezer.com/album/696861421/image	218	1	2025-01-10	single
242	493141091	Голубоглазый	181	https://api.deezer.com/album/493141091/image	214	1	2023-09-27	single
243	81307352	Мертві голоси	2266	https://api.deezer.com/album/81307352/image	223	9	2018-12-14	album
244	515504582	Гріх	1261	https://api.deezer.com/album/515504582/image	223	5	2023-12-07	ep
245	761174901	На іншому боці ріки	1114	https://api.deezer.com/album/761174901/image	223	4	2025-05-29	ep
246	497013131	Тисяча Очей	2670	https://api.deezer.com/album/497013131/image	223	11	2023-10-13	album
247	663939851	ЕПОХА	1647	https://api.deezer.com/album/663939851/image	228	8	2024-11-15	album
248	663553841	Не довіряй смертним	268	https://api.deezer.com/album/663553841/image	223	1	2024-10-30	single
249	728605251	Від тилу до фронту	2470	https://api.deezer.com/album/728605251/image	229	18	2025-04-01	album
250	769759621	Війни	155	https://api.deezer.com/album/769759621/image	230	1	2025-06-20	single
251	897466882	Хата скраю села	3770	https://api.deezer.com/album/897466882/image	231	15	2006-03-18	album
252	887072072	Чорна рілля	3500	https://api.deezer.com/album/887072072/image	231	13	2020-05-16	album
253	398014727	Щось справжнє	2317	https://api.deezer.com/album/398014727/image	232	12	2023-01-05	album
254	251583152	Лебеді	203	https://api.deezer.com/album/251583152/image	232	1	2021-08-12	single
255	955832201	Моровиця	146	https://api.deezer.com/album/955832201/image	232	1	2026-04-13	single
256	426908497	Легенди Дикого Поля	2289	https://api.deezer.com/album/426908497/image	232	12	2023-04-16	album
257	261115882	Екзотична	213	https://api.deezer.com/album/261115882/image	232	1	2021-09-24	single
261	130595652	death bed (coffee for your head)	173	https://api.deezer.com/album/130595652/image	235	1	2020-02-08	single
262	292229642	Beatopia	2738	https://api.deezer.com/album/292229642/image	159	14	2022-07-15	album
263	932209631	All I Did Was Dream of You	223	https://api.deezer.com/album/932209631/image	159	1	2026-03-14	single
264	80045512	Patched Up	1554	https://api.deezer.com/album/80045512/image	159	7	2018-12-07	ep
265	575621241	This Is How Tomorrow Moves	2483	https://api.deezer.com/album/575621241/image	159	14	2024-08-16	album
266	93511772	Loveworm	1541	https://api.deezer.com/album/93511772/image	159	7	2019-04-26	ep
267	3602971	Believe (Deluxe Edition)	3591	https://api.deezer.com/album/3602971/image	236	16	2012-06-19	album
268	786280691	SWAG	3260	https://api.deezer.com/album/786280691/image	236	21	2025-07-11	album
269	816518541	SWAG II	5035	https://api.deezer.com/album/816518541/image	236	44	2025-09-05	album
270	242430582	STAY	140	https://api.deezer.com/album/242430582/image	241	1	2021-07-09	single
271	512013	My World 2.0	2249	https://api.deezer.com/album/512013/image	236	10	2010-03-23	album
272	215962322	Justice	2725	https://api.deezer.com/album/215962322/image	236	16	2021-03-19	album
273	11674704	Purpose	2904	https://api.deezer.com/album/11674704/image	236	13	2015-11-13	album
274	131498332	Changes	3092	https://api.deezer.com/album/131498332/image	236	17	2020-02-14	album
\.


--
-- Data for Name: album_genre_association; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.album_genre_association (album_id, genre_id) FROM stdin;
25	8
25	7
26	2
27	2
28	9
29	8
30	2
31	2
32	2
33	8
33	10
33	9
34	8
34	10
34	9
35	9
36	9
37	8
38	1
39	8
39	9
40	2
41	2
42	8
42	11
42	10
43	2
45	4
46	8
46	11
47	9
48	12
49	13
50	2
51	8
51	2
60	2
61	2
62	22
62	23
62	2
63	8
64	2
65	8
65	1
65	22
65	4
65	24
66	22
67	22
68	12
68	1
69	1
70	22
71	4
72	8
72	2
72	25
73	2
74	12
74	26
74	27
75	22
76	1
77	2
78	4
79	22
80	4
81	2
82	1
83	1
84	1
85	1
86	12
87	26
88	1
89	26
90	8
90	22
91	26
92	26
93	8
94	4
95	12
96	4
98	1
99	8
100	8
100	11
101	28
102	22
103	9
104	2
105	8
106	2
106	3
107	8
107	2
108	8
108	2
109	22
110	8
111	22
112	29
113	22
114	8
114	2
115	8
115	2
117	8
118	8
119	22
120	8
120	2
121	8
121	10
122	12
122	26
123	12
123	26
124	12
124	26
125	8
126	12
126	26
127	8
127	10
127	12
128	8
128	22
128	23
128	2
129	12
130	2
132	22
132	2
133	1
134	26
134	22
135	22
135	27
136	1
137	1
138	2
138	30
139	22
139	30
140	1
141	22
142	22
143	1
144	1
148	8
149	8
150	2
151	8
163	2
164	2
165	2
166	2
167	2
168	2
169	8
170	8
171	8
172	8
173	8
174	8
175	8
176	8
177	8
178	8
179	8
180	1
181	1
182	1
183	1
184	5
185	22
186	8
186	11
186	10
187	8
187	11
187	10
188	8
189	8
190	12
191	1
192	1
193	1
194	1
195	1
202	8
202	11
202	10
202	26
203	8
203	11
203	10
203	26
204	8
205	8
206	8
206	11
206	10
206	26
210	12
211	12
211	22
212	22
214	2
215	22
216	1
217	22
218	2
218	33
219	22
220	1
221	2
222	9
223	1
224	8
224	2
225	1
226	1
227	1
228	8
228	10
229	2
230	8
230	2
231	8
231	2
232	8
232	2
233	2
234	2
235	7
236	22
236	7
237	22
238	22
239	22
239	7
240	26
240	1
241	22
242	22
246	2
247	8
247	10
247	2
248	2
249	2
250	22
251	22
251	34
251	7
252	22
252	34
252	7
253	7
254	7
255	7
256	7
257	7
261	1
261	22
261	4
262	8
263	2
264	8
265	8
266	8
267	22
268	22
269	22
270	8
270	11
270	22
270	34
271	22
272	22
273	22
274	22
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.alembic_version (version_num) FROM stdin;
29c645eec193
\.


--
-- Data for Name: artist; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.artist (id, dzid, name, picture, ghost_albums_count) FROM stdin;
121	68580	Sexy sushi	https://api.deezer.com/artist/68580/image	8
122	4861539	Sexy Music Band	https://api.deezer.com/artist/4861539/image	1
123	1398813	Sexy Music	https://api.deezer.com/artist/1398813/image	12
124	3840661	Sexy Music Lounge	https://api.deezer.com/artist/3840661/image	4
125	4547564	Sexy Music Mar DJ	https://api.deezer.com/artist/4547564/image	3
126	569	The Strokes	https://api.deezer.com/artist/569/image	18
127	5362155	Minuit Machine	https://api.deezer.com/artist/5362155/image	22
128	6927	Carter the Unstoppable Sex Machine	https://api.deezer.com/artist/6927/image	31
129	98335212	Никита Моргенштерн	https://api.deezer.com/artist/98335212/image	1
130	294237341	Ярослава Моргенштерн	https://api.deezer.com/artist/294237341/image	1
131	98151	ERM	https://api.deezer.com/artist/98151/image	16
132	78116442	PunkShow	https://api.deezer.com/artist/78116442/image	73
133	4170146	Баста	https://api.deezer.com/artist/4170146/image	113
134	68813	Lida	https://api.deezer.com/artist/68813/image	64
135	131611392	Коделак	https://api.deezer.com/artist/131611392/image	2
136	3110841	DZIDZIO	https://api.deezer.com/artist/3110841/image	33
137	68961602	Кисло-сладкий	https://api.deezer.com/artist/68961602/image	39
138	4806784	Юрий Визбор	https://api.deezer.com/artist/4806784/image	9
139	5175857	Олег Митяев	https://api.deezer.com/artist/5175857/image	36
140	55109182	METRO PRO	https://api.deezer.com/artist/55109182/image	39
141	6189150	Нэнси	https://api.deezer.com/artist/6189150/image	33
142	97526152	İMera	https://api.deezer.com/artist/97526152/image	44
143	371198551	Люта Зневага	https://api.deezer.com/artist/371198551/image	4
144	230	Kanye West	https://api.deezer.com/artist/230/image	69
145	313551521	Kanye West	https://api.deezer.com/artist/313551521/image	0
146	4099199	Yé	https://api.deezer.com/artist/4099199/image	51
147	11198106	Kanye West & Nas	https://api.deezer.com/artist/11198106/image	0
148	171221527	Kanye West & XXXTENTACION	https://api.deezer.com/artist/171221527/image	0
149	1309	JAŸ-Z	https://api.deezer.com/artist/1309/image	40
150	7347888	Steampianist	https://api.deezer.com/artist/7347888/image	17
151	67334	Antony & The Johnsons	https://api.deezer.com/artist/67334/image	2
152	13082199	Escape-ism	https://api.deezer.com/artist/13082199/image	8
153	68659522	Bertoia	https://api.deezer.com/artist/68659522/image	4
154	258854	Blutopia	https://api.deezer.com/artist/258854/image	3
155	1447002	Ben Tapia	https://api.deezer.com/artist/1447002/image	6
156	5269070	Beateria	https://api.deezer.com/artist/5269070/image	1
157	1401745	The Best Piano	https://api.deezer.com/artist/1401745/image	1
158	133618442	Вектор А	https://api.deezer.com/artist/133618442/image	33
159	13499081	beabadoobee	https://api.deezer.com/artist/13499081/image	36
160	115382322	Troy	https://api.deezer.com/artist/115382322/image	4
161	9498	ASP	https://api.deezer.com/artist/9498/image	27
162	13999305	Jonah Senzel	https://api.deezer.com/artist/13999305/image	1
163	58568762	Camilo	https://api.deezer.com/artist/58568762/image	59
164	754	Garou	https://api.deezer.com/artist/754/image	23
165	321764371	Damon Solis	https://api.deezer.com/artist/321764371/image	5
166	4430326	Tatsuro Yamashita	https://api.deezer.com/artist/4430326/image	1
167	5338160	Dan Gibson's Solitudes	https://api.deezer.com/artist/5338160/image	268
168	350566872	Prod.Nifour	https://api.deezer.com/artist/350566872/image	9
169	4277041	Héctor "El Father"	https://api.deezer.com/artist/4277041/image	10
170	51708732	SawanoHiroyuki[nZk]	https://api.deezer.com/artist/51708732/image	43
171	103851292	DJ Japa NK	https://api.deezer.com/artist/103851292/image	128
172	14256	Al Bano & Romina Power	https://api.deezer.com/artist/14256/image	26
188	170414187	Отойди поближе	https://api.deezer.com/artist/170414187/image	31
189	4981244	Кажэ Обойма	https://api.deezer.com/artist/4981244/image	31
190	8375166	Каже Обойма	https://api.deezer.com/artist/8375166/image	0
191	4321024	Kazhe Oboyma	https://api.deezer.com/artist/4321024/image	7
192	180436487	Милиан О'Войд	https://api.deezer.com/artist/180436487/image	10
193	237017471	yungalligator	https://api.deezer.com/artist/237017471/image	17
194	4520880	Александр Малинин	https://api.deezer.com/artist/4520880/image	27
195	8005180	Олег Погудин	https://api.deezer.com/artist/8005180/image	14
196	9210206	ШANA	https://api.deezer.com/artist/9210206/image	6
197	331334	Konfuz	https://api.deezer.com/artist/331334/image	40
198	14814761	Kavabanga Depo Kolibri	https://api.deezer.com/artist/14814761/image	131
199	171944	Esco	https://api.deezer.com/artist/171944/image	213
200	484281	Billy's Band	https://api.deezer.com/artist/484281/image	22
201	2519	The Notorious B.I.G.	https://api.deezer.com/artist/2519/image	41
202	11060562	Oklou	https://api.deezer.com/artist/11060562/image	32
203	127170	Itoiz	https://api.deezer.com/artist/127170/image	8
204	1083	DJ Ötzi	https://api.deezer.com/artist/1083/image	60
205	326541	Akelarre	https://api.deezer.com/artist/326541/image	8
206	382294	Diabulus in Musica	https://api.deezer.com/artist/382294/image	8
207	143861522	OTOI	https://api.deezer.com/artist/143861522/image	7
208	128414082	bawn	https://api.deezer.com/artist/128414082/image	35
209	8853864	Banners	https://api.deezer.com/artist/8853864/image	55
173	831	ASIAN KUNG-FU GENERATION	https://api.deezer.com/artist/831/image	82
174	253044772	ASIAN KUNG-FU GENERATION, ROTH BART BARON	https://api.deezer.com/artist/253044772/image	0
175	14417559	Asian Kung-fu Generation & Eriko Hashimoto	https://api.deezer.com/artist/14417559/image	0
176	149529362	ASIAN KUNG-FU GENERATION & Hiroko Sebu	https://api.deezer.com/artist/149529362/image	0
177	163735377	ASIAN KUNG-FU GENERATION feat. Rachel & OMSB	https://api.deezer.com/artist/163735377/image	0
178	1619572	Mac Demarco	https://api.deezer.com/artist/1619572/image	38
179	209104	Quatuor de Saxophones de Luxembourg, Guy Goethals, Marc Hoffmann, Marco Puetz, Roland Schneider	https://api.deezer.com/artist/209104/image	0
180	399	Radiohead	https://api.deezer.com/artist/399/image	45
181	323887691	Radiohead	https://api.deezer.com/artist/323887691/image	1
182	1431492	Gigamesh	https://api.deezer.com/artist/1431492/image	20
183	7888234	Kelly Lee Owens	https://api.deezer.com/artist/7888234/image	41
184	53477202	DJ Radiohead	https://api.deezer.com/artist/53477202/image	29
185	247635892	Nujabes / fat jon	https://api.deezer.com/artist/247635892/image	1
186	2927	Mindless Self Indulgence	https://api.deezer.com/artist/2927/image	16
210	10172688	Gawne	https://api.deezer.com/artist/10172688/image	124
211	9074712	Barns Courtney	https://api.deezer.com/artist/9074712/image	31
212	1561519	HASN	https://api.deezer.com/artist/1561519/image	17
213	216919365	Сусіди Стерплять	https://api.deezer.com/artist/216919365/image	30
214	129614992	Яна Тихонова	https://api.deezer.com/artist/129614992/image	7
215	10726119	Инструментальный квартет п/у Бориса Тихонова	https://api.deezer.com/artist/10726119/image	0
216	352369062	Инструментальный септет п/у Бориса Тихонова	https://api.deezer.com/artist/352369062/image	0
217	124567642	Rohata Zhaba	https://api.deezer.com/artist/124567642/image	11
218	11285170	Марина і компанія	https://api.deezer.com/artist/11285170/image	48
219	5343100	Руся	https://api.deezer.com/artist/5343100/image	47
220	220543155	Victoria Niro	https://api.deezer.com/artist/220543155/image	5
221	7872896	Христина Соловій	https://api.deezer.com/artist/7872896/image	28
222	14003525	Довгий Пес	https://api.deezer.com/artist/14003525/image	52
223	12054664	Zwyntar	https://api.deezer.com/artist/12054664/image	13
224	5570625	Aystar	https://api.deezer.com/artist/5570625/image	35
225	317569811	Syntax	https://api.deezer.com/artist/317569811/image	15
226	1548700	Syntra	https://api.deezer.com/artist/1548700/image	11
227	2062021	Antar	https://api.deezer.com/artist/2062021/image	19
228	287947661	Третя Штурмова	https://api.deezer.com/artist/287947661/image	29
229	310208771	Військовий стан	https://api.deezer.com/artist/310208771/image	9
230	239557881	Domiy	https://api.deezer.com/artist/239557881/image	24
231	94883992	ВІЙ	https://api.deezer.com/artist/94883992/image	9
1	1978	Nujabes	https://api.deezer.com/artist/1978/image	12
2	128293792	Oma	https://api.deezer.com/artist/128293792/image	22
3	75971352	Sickmode	https://api.deezer.com/artist/75971352/image	41
4	133267472	HAECHAN	https://api.deezer.com/artist/133267472/image	4
5	1331356	JUNNY	https://api.deezer.com/artist/1331356/image	54
6	15193591	SANDEUL	https://api.deezer.com/artist/15193591/image	30
7	599	My Chemical Romance	https://api.deezer.com/artist/599/image	39
8	412538	Currents	https://api.deezer.com/artist/412538/image	15
9	252586452	Currents	https://api.deezer.com/artist/252586452/image	4
10	120658702	Currents	https://api.deezer.com/artist/120658702/image	13
11	13117393	Current Joys	https://api.deezer.com/artist/13117393/image	18
12	12132520	The Currents	https://api.deezer.com/artist/12132520/image	4
13	134790	Tame Impala	https://api.deezer.com/artist/134790/image	37
14	15013267	Currents Will Shift	https://api.deezer.com/artist/15013267/image	6
15	402158	Curren$y	https://api.deezer.com/artist/402158/image	159
16	140172842	Passing Currents	https://api.deezer.com/artist/140172842/image	16
17	208529657	Stray Currents	https://api.deezer.com/artist/208529657/image	14
18	191141377	Currents	https://api.deezer.com/artist/191141377/image	2
19	356815	We Came As Romans	https://api.deezer.com/artist/356815/image	22
20	55141312	Silent Currents	https://api.deezer.com/artist/55141312/image	6
21	295323941	Black Currents	https://api.deezer.com/artist/295323941/image	2
22	120658712	Currents	https://api.deezer.com/artist/120658712/image	1
23	104107352	Eddy Currents	https://api.deezer.com/artist/104107352/image	12
24	212492487	Sleepy Currents	https://api.deezer.com/artist/212492487/image	8
25	74804	Wiz Khalifa	https://api.deezer.com/artist/74804/image	201
26	6318152	The Oh Hellos	https://api.deezer.com/artist/6318152/image	16
27	372003511	Ancient Currents	https://api.deezer.com/artist/372003511/image	3
28	114175602	Bad Currents	https://api.deezer.com/artist/114175602/image	3
29	296466121	Liminal Currents	https://api.deezer.com/artist/296466121/image	9
30	286972951	Gentle Stream Currents	https://api.deezer.com/artist/286972951/image	38
31	144788232	The Sheer Currents	https://api.deezer.com/artist/144788232/image	5
32	555102	In Vain	https://api.deezer.com/artist/555102/image	12
33	70821102	Youth 83	https://api.deezer.com/artist/70821102/image	55
34	416733	The Gun Show	https://api.deezer.com/artist/416733/image	2
81	310229591	BRAT	https://api.deezer.com/artist/310229591/image	8
35	10153646	Native Dancer	https://api.deezer.com/artist/10153646/image	10
36	12120364	Mellow Currents	https://api.deezer.com/artist/12120364/image	1
37	121646022	Boxwood Currents	https://api.deezer.com/artist/121646022/image	4
38	12298614	New Currents	https://api.deezer.com/artist/12298614/image	1
39	128476372	Ocean Currents	https://api.deezer.com/artist/128476372/image	34
40	128930762	Sweet Currents	https://api.deezer.com/artist/128930762/image	10
41	524675	Still Corners	https://api.deezer.com/artist/524675/image	28
42	56943632	Aedra	https://api.deezer.com/artist/56943632/image	14
43	12057546	Lux Pacific	https://api.deezer.com/artist/12057546/image	3
44	13498347	Mad Keys	https://api.deezer.com/artist/13498347/image	36
45	1860	Eisley	https://api.deezer.com/artist/1860/image	22
46	259645622	ILLIT	https://api.deezer.com/artist/259645622/image	20
47	57092	Hot Lips Page	https://api.deezer.com/artist/57092/image	59
48	75964992	Magenta Club	https://api.deezer.com/artist/75964992/image	21
49	147184	Pixote	https://api.deezer.com/artist/147184/image	79
50	13612387	Måneskin	https://api.deezer.com/artist/13612387/image	20
51	5951582	Jain	https://api.deezer.com/artist/5951582/image	19
52	141074952	Pale Jay	https://api.deezer.com/artist/141074952/image	25
53	2047	Jean-Michel Jarre	https://api.deezer.com/artist/2047/image	84
54	1529	Jane Birkin	https://api.deezer.com/artist/1529/image	33
55	13682985	The Long Faces	https://api.deezer.com/artist/13682985/image	6
56	5286	Breaking Benjamin	https://api.deezer.com/artist/5286/image	15
57	380832	Fun.	https://api.deezer.com/artist/380832/image	11
58	165644657	aurora hills	https://api.deezer.com/artist/165644657/image	26
59	13209	Mary Jane Girls	https://api.deezer.com/artist/13209/image	5
60	2559	Jane's Addiction	https://api.deezer.com/artist/2559/image	28
61	3557	Jeanne Mas	https://api.deezer.com/artist/3557/image	36
62	107557062	Rio Romeo	https://api.deezer.com/artist/107557062/image	8
63	1658	Janis Joplin	https://api.deezer.com/artist/1658/image	18
64	131935	Janelle Monáe	https://api.deezer.com/artist/131935/image	48
65	170	Bryan Adams	https://api.deezer.com/artist/170/image	71
66	836	Jeanette	https://api.deezer.com/artist/836/image	24
67	283419621	GASPXR	https://api.deezer.com/artist/283419621/image	97
68	222357135	pxiqzes	https://api.deezer.com/artist/222357135/image	49
69	1188	Maroon 5	https://api.deezer.com/artist/1188/image	69
70	827425	Kane Brown	https://api.deezer.com/artist/827425/image	62
71	1308	Jeanne Cherhal	https://api.deezer.com/artist/1308/image	13
72	262	Janet Jackson	https://api.deezer.com/artist/262/image	67
73	484370	Jeanne Added	https://api.deezer.com/artist/484370/image	18
74	2110	Tom Petty And The Heartbreakers	https://api.deezer.com/artist/2110/image	46
75	355	Bellini	https://api.deezer.com/artist/355/image	34
76	171334977	John + Jane Q. Public	https://api.deezer.com/artist/171334977/image	3
77	4341930	A$AP Ferg	https://api.deezer.com/artist/4341930/image	71
78	2986	Converge	https://api.deezer.com/artist/2986/image	30
79	170234767	Jane Remover	https://api.deezer.com/artist/170234767/image	19
80	135183112	Jalen Ngonda	https://api.deezer.com/artist/135183112/image	23
82	3810	Brat	https://api.deezer.com/artist/3810/image	45
83	310228951	Brat	https://api.deezer.com/artist/310228951/image	19
84	380425731	Brat	https://api.deezer.com/artist/380425731/image	9
85	11665341	Jala Brat	https://api.deezer.com/artist/11665341/image	101
86	7071665	Гио ПиКа	https://api.deezer.com/artist/7071665/image	94
87	380426441	Brat	https://api.deezer.com/artist/380426441/image	3
88	1462230	Charli xcx	https://api.deezer.com/artist/1462230/image	112
89	8720732	Macan	https://api.deezer.com/artist/8720732/image	67
90	1432119	DEZI	https://api.deezer.com/artist/1432119/image	25
91	7576432	Montell Fish	https://api.deezer.com/artist/7576432/image	49
92	163258297	Disney Lofi	https://api.deezer.com/artist/163258297/image	7
93	318723281	Kolby Fisher	https://api.deezer.com/artist/318723281/image	3
94	62577652	The Lo-Fi's	https://api.deezer.com/artist/62577652/image	3
95	58536592	Ben Logan & the Lo-Fis	https://api.deezer.com/artist/58536592/image	1
96	56125	FISHER	https://api.deezer.com/artist/56125/image	25
97	65574	Steve Lacy	https://api.deezer.com/artist/65574/image	21
98	102262192	OTOY	https://api.deezer.com/artist/102262192/image	39
99	1182	Arctic Monkeys	https://api.deezer.com/artist/1182/image	35
100	10468777	Magdalena Bay	https://api.deezer.com/artist/10468777/image	41
101	244332	Imaginasamba	https://api.deezer.com/artist/244332/image	55
102	12566664	Welcome To Hell	https://api.deezer.com/artist/12566664/image	2
103	54564552	Ensemble Welcome To Hell	https://api.deezer.com/artist/54564552/image	0
104	353582	Siwel	https://api.deezer.com/artist/353582/image	12
105	72030	Gothminister	https://api.deezer.com/artist/72030/image	28
106	180746	MONO INC.	https://api.deezer.com/artist/180746/image	41
107	459	Sum 41	https://api.deezer.com/artist/459/image	28
108	399141	Rhino Bucket	https://api.deezer.com/artist/399141/image	8
109	448595	This Charming Man	https://api.deezer.com/artist/448595/image	1
110	1297	The Smiths	https://api.deezer.com/artist/1297/image	17
111	1387	Nouvelle Vague	https://api.deezer.com/artist/1387/image	25
112	573304	Johnny Marr	https://api.deezer.com/artist/573304/image	39
113	167831	Cannibal	https://api.deezer.com/artist/167831/image	51
114	132853262	EZ Band	https://api.deezer.com/artist/132853262/image	19
115	141057192	Johnny Mitch	https://api.deezer.com/artist/141057192/image	7
116	383	Death Cab For Cutie	https://api.deezer.com/artist/383/image	60
117	116047382	my dead girlfriend	https://api.deezer.com/artist/116047382/image	6
118	14546477	Black Dresses	https://api.deezer.com/artist/14546477/image	18
119	201103587	Squid Pisser	https://api.deezer.com/artist/201103587/image	14
120	488044	The Slugz	https://api.deezer.com/artist/488044/image	8
187	1194083	Tyler, The Creator	https://api.deezer.com/artist/1194083/image	29
232	12904065	Харцизи	https://api.deezer.com/artist/12904065/image	8
233	12521498	Харизма	https://api.deezer.com/artist/12521498/image	24
234	8891012	Валерій Харчишин	https://api.deezer.com/artist/8891012/image	1
235	14107147	Powfu	https://api.deezer.com/artist/14107147/image	79
236	288166	Justin Bieber	https://api.deezer.com/artist/288166/image	60
237	126335112	Rosé	https://api.deezer.com/artist/126335112/image	6
238	225697885	Justin Bieber - Piano Covers	https://api.deezer.com/artist/225697885/image	1
239	5531258	SZA	https://api.deezer.com/artist/5531258/image	40
240	331665651	Justin Bieber HM	https://api.deezer.com/artist/331665651/image	7
241	51204222	The Kid LAROI	https://api.deezer.com/artist/51204222/image	52
\.


--
-- Data for Name: artist_song_association; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.artist_song_association (artist_id, song_id) FROM stdin;
26	26
8	27
8	28
8	29
8	30
8	31
8	32
8	33
8	34
8	35
8	36
8	37
19	38
8	39
8	40
8	41
8	42
8	43
8	44
8	45
8	46
8	47
8	48
41	49
8	50
8	51
55	52
56	53
51	54
57	55
58	56
64	57
65	58
51	59
66	60
67	61
68	62
74	63
75	64
76	65
77	66
7	67
7	68
7	69
7	70
7	71
7	72
7	73
7	74
7	75
7	76
7	77
7	78
7	79
86	80
87	81
87	82
87	83
87	84
88	85
88	86
88	87
88	88
88	89
88	90
88	91
88	92
88	93
88	94
88	95
88	96
88	97
88	98
88	99
96	100
96	101
91	102
91	103
91	104
97	105
97	106
97	107
97	108
97	109
97	110
97	111
97	112
97	113
97	114
97	115
97	116
97	117
97	118
97	119
8	120
8	121
8	122
8	123
8	124
8	125
8	126
8	127
8	128
8	129
8	130
8	131
98	132
98	133
98	134
98	135
98	136
98	137
98	138
98	139
99	140
99	141
99	142
99	143
99	144
99	145
99	146
99	147
99	148
99	149
99	150
99	151
100	152
100	153
101	154
100	155
100	156
100	157
100	158
100	159
100	160
100	161
100	162
100	163
100	164
100	165
100	166
100	167
104	168
105	169
106	170
107	171
108	172
104	173
104	174
110	175
110	176
110	177
111	178
112	179
117	180
117	181
117	182
117	183
117	184
117	185
117	186
117	187
117	188
117	189
7	190
7	191
118	192
119	193
120	194
121	195
121	196
121	197
121	198
121	199
121	200
121	201
121	202
126	203
127	204
128	205
126	206
126	207
126	208
126	209
126	210
126	211
126	212
126	213
126	214
126	215
131	216
132	217
133	218
134	219
134	220
136	221
135	222
137	223
138	224
139	225
150	226
151	227
91	228
152	229
99	230
99	231
99	232
99	233
173	234
173	235
173	236
173	237
173	238
178	239
178	240
178	241
178	242
178	243
180	244
180	245
180	246
180	247
180	248
1	249
1	250
1	251
1	252
1	253
186	254
186	255
186	256
186	257
186	258
187	259
187	260
187	261
187	262
187	263
13	264
13	265
13	266
13	267
13	268
193	269
188	270
194	271
195	272
196	273
98	274
98	275
205	276
206	277
98	278
98	279
98	280
213	281
208	282
208	283
208	284
208	285
217	286
218	287
219	288
220	289
221	290
223	291
223	292
223	293
223	294
228	295
229	296
230	297
231	298
231	299
231	300
232	301
232	302
232	303
232	304
232	305
235	306
159	307
159	308
159	309
159	310
236	311
236	312
236	313
241	314
236	315
\.


--
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.genre (id, dzid, name) FROM stdin;
1	116	Rap/Hip Hop
2	152	Rock
3	155	Hard Rock
4	165	R&B
5	173	Films/Games
6	174	Film Scores
7	466	Folk
8	85	Alternative
9	464	Metal
10	87	Indie Rock
11	86	Indie Pop
12	106	Electro
13	129	Jazz
22	132	Pop
23	134	International Pop
24	166	Contemporary R&B
25	154	Indie Rock/Rock pop
26	113	Dance
27	168	Disco
28	75	Brazilian Music
29	197	Latin Music
30	522	Singer & Songwriter
33	153	Blues
34	133	Indie Pop/Folk
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.rating (id, score, description, album_id, song_id, user_id) FROM stdin;
4	8	this charmiiiing maaaan! hya	\N	175	1
5	6	Meeeeeeeeeeeeeeehhhh	116	\N	1
6	8	this charmiiiing maaaan! hya	\N	190	1
7	10	Meeeeeeeeeeeeeeehhhh	151	\N	2
8	10	Meeeeeeeeeeeeeeehhhh	163	\N	2
9	10	Meeeeeeeeeeeeeeehhhh	186	\N	2
10	10	Meeeeeeeeeeeeeeehhhh	220	\N	3
11	10	Meeeeeeeeeeeeeeehhhh	229	\N	3
12	10	супер пупер вода хода тихо брода	\N	286	3
13	9	жббур бур бур бррбрбрбрббр	\N	304	3
14	10	Meeeeeeeeeeeeeeehhhh	269	\N	3
\.


--
-- Data for Name: song; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.song (id, dzid, name, length, song_position, picture, preview, album_id) FROM stdin;
26	1343803132	Soldier, Poet, King	165	10	https://api.deezer.com/album/222850892/image	https://cdnt-preview.dzcdn.net/api/1/1/d/4/c/0/d4c2ad95f0cb01290112131c16172557.mp3?hdnea=exp=1775488714~acl=/api/1/1/d/4/c/0/d4c2ad95f0cb01290112131c16172557.mp3*~data=user_id=0,application_id=42~hmac=025651f4e4444fce1fb993422a609e417ba2d7a29462c62b3a421621a5295dd0	25
27	2101635277	Remember Me	244	9	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/b/d/4/0/bd45eccd5185a04ddfaee29b8b92a30c.mp3?hdnea=exp=1775488795~acl=/api/1/1/b/d/4/0/bd45eccd5185a04ddfaee29b8b92a30c.mp3*~data=user_id=0,application_id=42~hmac=6f339fcac7a8f11d2f62a4d427b3a7e818805fd8df5bc56696c725620d4e5256	26
28	909001362	Better Days	247	11	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/6/a/8/0/6a8a2275a807829b43edac03128389b1.mp3?hdnea=exp=1775488795~acl=/api/1/1/6/a/8/0/6a8a2275a807829b43edac03128389b1.mp3*~data=user_id=0,application_id=42~hmac=1a99b622f7f24f62d25dcdd209fa774f8eefaa84d0a336ef1db0f07035fd96ef	27
29	2101635227	So Alone	238	4	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/9/b/5/0/9b56f60b348b646c150f323657d50e79.mp3?hdnea=exp=1775488795~acl=/api/1/1/9/b/5/0/9b56f60b348b646c150f323657d50e79.mp3*~data=user_id=0,application_id=42~hmac=546554f3eb4188825ab5721c04e7779bbfebde7032ac46e026b37a9070d5bc66	26
30	3583314871	Making Circles	264	3	https://api.deezer.com/album/831248571/image	https://cdnt-preview.dzcdn.net/api/1/1/c/e/d/0/ceda1b1b8c89203f5cedccb8171e3968.mp3?hdnea=exp=1775488795~acl=/api/1/1/c/e/d/0/ceda1b1b8c89203f5cedccb8171e3968.mp3*~data=user_id=0,application_id=42~hmac=60a3b04e5c6052d8afa0b969555af753b999ba0847235f21ebedfdc7243d11a0	28
31	2101635207	Living In Tragedy	243	2	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/6/7/2/0/672135edfde3cd1ec1ab88d0fbdad52d.mp3?hdnea=exp=1775488795~acl=/api/1/1/6/7/2/0/672135edfde3cd1ec1ab88d0fbdad52d.mp3*~data=user_id=0,application_id=42~hmac=f85036840cdfa6b1967d3554b5a343d15e1ab34fb28c113b6e59fbf1ce6b04ab	26
32	2101635217	Unfamiliar	224	3	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/e/3/7/0/e37b06a17145dd25695cded0bdb20e50.mp3?hdnea=exp=1775488852~acl=/api/1/1/e/3/7/0/e37b06a17145dd25695cded0bdb20e50.mp3*~data=user_id=0,application_id=42~hmac=7048f74f54e4d628b888b52ff7be0a6aad907bd7847e42b6daddcbbc1f460f77	26
33	2101635197	The Death We Seek	245	1	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/d/8/f/0/d8f7aca420ac8b6b782dee832853367d.mp3?hdnea=exp=1775488852~acl=/api/1/1/d/8/f/0/d8f7aca420ac8b6b782dee832853367d.mp3*~data=user_id=0,application_id=42~hmac=1e025da60fed80cf91a4df4446138c65a4bc74a979dd2948a80f65be9cbedad7	26
34	2101635237	Over And Over	248	5	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/8/8/4/0/884959ceee78a67321ff5c0943d215c7.mp3?hdnea=exp=1775488852~acl=/api/1/1/8/8/4/0/884959ceee78a67321ff5c0943d215c7.mp3*~data=user_id=0,application_id=42~hmac=16d48ad2307ced11b8c23bec533ad3dffe91c6cb581341b3b4b8114ed9426289	26
35	909001312	Let Me Leave	201	6	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/0/7/d/0/07db90cbdf92063ae2fd4af1909097a7.mp3?hdnea=exp=1775488852~acl=/api/1/1/0/7/d/0/07db90cbdf92063ae2fd4af1909097a7.mp3*~data=user_id=0,application_id=42~hmac=db3677ab22560bcdf4d8d72c8b4f29e32a9fc4d5230cf6646eb0f61595bc1ef6	27
36	909001352	How I Fall Apart	251	10	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/2/c/8/0/2c89851ed7ad75fb5d37d20ff5a42fb8.mp3?hdnea=exp=1775488852~acl=/api/1/1/2/c/8/0/2c89851ed7ad75fb5d37d20ff5a42fb8.mp3*~data=user_id=0,application_id=42~hmac=fd0a77d12d6899eaa46b405b65061da3225532b0c0fcb6cfd58794f8936a3ea5	27
37	2101635287	Guide Us Home	251	10	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/c/8/6/0/c86528d735620dd56b6a076a841850e9.mp3?hdnea=exp=1775488879~acl=/api/1/1/c/8/6/0/c86528d735620dd56b6a076a841850e9.mp3*~data=user_id=0,application_id=42~hmac=8e666cadd3f4837d964e05d42bdbbcb216a167402732bfa46ef1aa18a2629e09	26
38	3521612621	bad luck	252	1	https://api.deezer.com/album/809362641/image	https://cdnt-preview.dzcdn.net/api/1/1/1/1/d/0/11d79bce71ad31c6865e9690e60d002b.mp3?hdnea=exp=1775488879~acl=/api/1/1/1/1/d/0/11d79bce71ad31c6865e9690e60d002b.mp3*~data=user_id=0,application_id=42~hmac=aaefa6b84c21664813fc488c0039f19949a4577670dd395770ab05c9f55f3e25	35
39	2101635257	Vengeance	230	7	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/3/a/2/0/3a2b4edae2be6e35fc26949e744f68df.mp3?hdnea=exp=1775488879~acl=/api/1/1/3/a/2/0/3a2b4edae2be6e35fc26949e744f68df.mp3*~data=user_id=0,application_id=42~hmac=a29e826b82f5a157ae3f97a6b2401f7d7167b6ecf5b7429149cf103b234a1e13	26
40	2101635247	Beyond This Road	248	6	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/1/3/2/0/1320b8dd7d952660c6a64961abd0e416.mp3?hdnea=exp=1775488879~acl=/api/1/1/1/3/2/0/1320b8dd7d952660c6a64961abd0e416.mp3*~data=user_id=0,application_id=42~hmac=5282d764ae5240bf9334ac1ab857edbcb74ae123425f313cc5c4db2c9973235d	26
41	3583314851	It Only Gets Darker	271	1	https://api.deezer.com/album/831248571/image	https://cdnt-preview.dzcdn.net/api/1/1/a/c/6/0/ac68a750f045ce51fd2523c188de7877.mp3?hdnea=exp=1775488879~acl=/api/1/1/a/c/6/0/ac68a750f045ce51fd2523c188de7877.mp3*~data=user_id=0,application_id=42~hmac=396b7e8a1ebafce3f15f936c41c735b444e2ee367dbe1ecaad89e7f0daef3ee0	28
42	909001302	Kill the Ache	233	5	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/4/7/6/0/476e2bcc9d8b2f4011698e6c96361835.mp3?hdnea=exp=1775488898~acl=/api/1/1/4/7/6/0/476e2bcc9d8b2f4011698e6c96361835.mp3*~data=user_id=0,application_id=42~hmac=60a54969306ad2d41aeda09e1e6a5cfecfa993c88e2283a4bb4da9c9659d1e77	27
43	2101635267	Gone Astray	218	8	https://api.deezer.com/album/394743357/image	https://cdnt-preview.dzcdn.net/api/1/1/1/6/9/0/1698c71440ec5c99669b43ed393b900e.mp3?hdnea=exp=1775488898~acl=/api/1/1/1/6/9/0/1698c71440ec5c99669b43ed393b900e.mp3*~data=user_id=0,application_id=42~hmac=dd83bb43ba6c8c85282391254b71c273d35ee152fef340aabc8f6db571609adb	26
44	909001262	Never There	108	1	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/c/2/2/0/c22ef65c34b13265f3015e2ba40f1f45.mp3?hdnea=exp=1775488898~acl=/api/1/1/c/2/2/0/c22ef65c34b13265f3015e2ba40f1f45.mp3*~data=user_id=0,application_id=42~hmac=60d39d75ccd12406ac5cf352341cec80598ac49f88118f4dddc88e8c3cdace40	27
45	909001292	Monsters	212	4	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/0/d/9/0/0d9a3bbc4aae7c0f2414295858375228.mp3?hdnea=exp=1775488898~acl=/api/1/1/0/d/9/0/0d9a3bbc4aae7c0f2414295858375228.mp3*~data=user_id=0,application_id=42~hmac=a8e554f3dd42aff4d5b0c17393a69aaa368873637b04646f696cd204ed90fb9d	27
46	909001282	Poverty of Self	205	3	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/d/9/6/0/d9621169bc759fb4e49ca3e43a3146bb.mp3?hdnea=exp=1775488898~acl=/api/1/1/d/9/6/0/d9621169bc759fb4e49ca3e43a3146bb.mp3*~data=user_id=0,application_id=42~hmac=0e52a4159bab97cede59ca46784e3248ba58590df4d3ca61738793ec93870651	27
47	909001342	Second Skin	225	9	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/3/c/7/0/3c712a1f9e1d60a1a65b1fa1ff7cad79.mp3?hdnea=exp=1775488917~acl=/api/1/1/3/c/7/0/3c712a1f9e1d60a1a65b1fa1ff7cad79.mp3*~data=user_id=0,application_id=42~hmac=1a6fb191625da3e55bd54eadd92dfd30352075de3474f463cafa1da5c7939f12	27
48	909001322	Origin	244	7	https://api.deezer.com/album/137306592/image	https://cdnt-preview.dzcdn.net/api/1/1/6/2/1/0/6211870bd230e4ae9f917ad87c369231.mp3?hdnea=exp=1775488917~acl=/api/1/1/6/2/1/0/6211870bd230e4ae9f917ad87c369231.mp3*~data=user_id=0,application_id=42~hmac=e52e4a8adaf3112679eb8c800100a5bea0fd81c5b81497a36302d204545ac920	27
49	2165525477	Currents	204	2	https://api.deezer.com/album/411353227/image	https://cdnt-preview.dzcdn.net/api/1/1/8/c/0/0/8c0a15998fa6dd65c51b6a2f7e6dcd69.mp3?hdnea=exp=1775488917~acl=/api/1/1/8/c/0/0/8c0a15998fa6dd65c51b6a2f7e6dcd69.mp3*~data=user_id=0,application_id=42~hmac=e5b3389f49a21d2de2fd3eaf6e284abdaa398f42f776fc881415cea3f4a597c0	46
50	659570072	Forget Me	253	7	https://api.deezer.com/album/92438682/image	https://cdnt-preview.dzcdn.net/api/1/1/f/9/e/0/f9e51f42de378700fa46c5708dae605a.mp3?hdnea=exp=1775488917~acl=/api/1/1/f/9/e/0/f9e51f42de378700fa46c5708dae605a.mp3*~data=user_id=0,application_id=42~hmac=4f0408fb9d51c82356f02af2941a5fcf669ec38332f06754807d795c938521c1	30
51	651515062	Another Life (Instrumental)	204	11	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/8/3/e/0/83e66d838ffbe4ae6af0d1d634e8a125.mp3?hdnea=exp=1775488917~acl=/api/1/1/8/3/e/0/83e66d838ffbe4ae6af0d1d634e8a125.mp3*~data=user_id=0,application_id=42~hmac=6a86fe0495568edb0ef9e679fd4d4fd57863720208e5aa92be292b81af0f4e02	31
52	3917470511	Jane!	187	1	https://api.deezer.com/album/945917251/image	https://cdnt-preview.dzcdn.net/api/1/1/3/3/3/0/333f5c48665452c68ae7cf0c208705a4.mp3?hdnea=exp=1775489373~acl=/api/1/1/3/3/3/0/333f5c48665452c68ae7cf0c208705a4.mp3*~data=user_id=0,application_id=42~hmac=6dfa1c20a827c7c7c33e631db878419ad2baa25d4ce2ec22b03fdac0e383e519	60
53	13711280	The Diary Of Jane	198	7	https://api.deezer.com/album/1254871/image	https://cdnt-preview.dzcdn.net/api/1/1/8/e/2/0/8e2f826d46604f23143871b2d025dd53.mp3?hdnea=exp=1775489373~acl=/api/1/1/8/e/2/0/8e2f826d46604f23143871b2d025dd53.mp3*~data=user_id=0,application_id=42~hmac=cb1d5feffe25be56cc04e8b771b4d03702d02ee8384718734d5560490bd423a1	61
54	109176426	Makeba	249	8	https://api.deezer.com/album/11375984/image	https://cdnt-preview.dzcdn.net/api/1/1/1/a/6/0/1a64836be22e29ed21108527f7d0178b.mp3?hdnea=exp=1775489373~acl=/api/1/1/1/a/6/0/1a64836be22e29ed21108527f7d0178b.mp3*~data=user_id=0,application_id=42~hmac=0fc834519966f769cb4c9d6e600420b397ebbed42b8897a00a6908ab1d40c163	62
55	16501728	We Are Young (feat. Janelle Monáe)	250	3	https://api.deezer.com/album/1543242/image	https://cdnt-preview.dzcdn.net/api/1/1/8/2/c/0/82c08ccf615f63cca82adfe5d7110dd4.mp3?hdnea=exp=1775489373~acl=/api/1/1/8/2/c/0/82c08ccf615f63cca82adfe5d7110dd4.mp3*~data=user_id=0,application_id=42~hmac=95f2df22ca3210a9320d7f74024095db9761761577c3fd6a4df5dd30e1f271b6	63
56	3908590391	Jane! (Slowed & reverb)	253	1	https://api.deezer.com/album/942552041/image	https://cdnt-preview.dzcdn.net/api/1/1/e/0/0/0/e00434152a772847e78dc468ca79f987.mp3?hdnea=exp=1775489373~acl=/api/1/1/e/0/0/0/e00434152a772847e78dc468ca79f987.mp3*~data=user_id=0,application_id=42~hmac=16650d59081c7218591225b522ea6ada90e2a15fe452559a03ebb02af9335383	64
57	3911708961	Yoga (Copacabana) - Jersey Club Remix	132	1	https://api.deezer.com/album/943647141/image	https://cdnt-preview.dzcdn.net/api/1/1/2/8/d/0/28d00609f25b9ac6cd3ed9fc0dd140dc.mp3?hdnea=exp=1775489458~acl=/api/1/1/2/8/d/0/28d00609f25b9ac6cd3ed9fc0dd140dc.mp3*~data=user_id=0,application_id=42~hmac=22b641af100606cbb6dc85ebac63a4cc4be287bcffc66d03708c71b55a95924c	65
58	88902735	Run To You	234	3	https://api.deezer.com/album/8986017/image	https://cdnt-preview.dzcdn.net/api/1/1/b/7/0/0/b70aeca529460e68afafd8cc44f2ef76.mp3?hdnea=exp=1775489458~acl=/api/1/1/b/7/0/0/b70aeca529460e68afafd8cc44f2ef76.mp3*~data=user_id=0,application_id=42~hmac=0c2413026afc99f7343f17545eb1d2b4d2d5c6064a91229c682e6856b4c92b58	66
59	109176400	Come	162	1	https://api.deezer.com/album/11375984/image	https://cdnt-preview.dzcdn.net/api/1/1/a/9/1/0/a9112d10a0182836b493effe5e4dbc90.mp3?hdnea=exp=1775489458~acl=/api/1/1/a/9/1/0/a9112d10a0182836b493effe5e4dbc90.mp3*~data=user_id=0,application_id=42~hmac=8c03a49f8d11c6475f214bfa42e51096f475a0e3b00c79999351df48bacc35cd	62
60	10114381	Porque te vas	201	2	https://api.deezer.com/album/925154/image	https://cdnt-preview.dzcdn.net/api/1/1/1/9/8/0/198f415b1631d793a14f68157b8e7534.mp3?hdnea=exp=1775489458~acl=/api/1/1/1/9/8/0/198f415b1631d793a14f68157b8e7534.mp3*~data=user_id=0,application_id=42~hmac=11699e99a521f34f62c713a5e0f920e2b54f74de98d73f03c69e1736bf933478	67
61	3292493231	JANE!	121	1	https://api.deezer.com/album/732037221/image	https://cdnt-preview.dzcdn.net/api/1/1/9/9/d/0/99da96007146fdd092a30920b9ffdf42.mp3?hdnea=exp=1775489458~acl=/api/1/1/9/9/d/0/99da96007146fdd092a30920b9ffdf42.mp3*~data=user_id=0,application_id=42~hmac=d52b6dcb2f0f08aefdff0e082caa1f75729c36edc9d0b4ec26945c2c2d9a1378	68
62	3479690961	JANE! (pxiqzes remix - Instrumental)	167	2	https://api.deezer.com/album/794930241/image	https://cdnt-preview.dzcdn.net/api/1/1/d/3/9/0/d3935b062a3b24f7d35525ea483da825.mp3?hdnea=exp=1775489477~acl=/api/1/1/d/3/9/0/d3935b062a3b24f7d35525ea483da825.mp3*~data=user_id=0,application_id=42~hmac=26f008571eb6664ca2a35048338ad179d05bf1a49afd32c0591fb55f47b07627	69
63	588236412	Mary Jane's Last Dance	273	17	https://api.deezer.com/album/79085832/image	https://cdnt-preview.dzcdn.net/api/1/1/6/1/6/0/61610be60e48ccca2b292d219c9d2186.mp3?hdnea=exp=1775489477~acl=/api/1/1/6/1/6/0/61610be60e48ccca2b292d219c9d2186.mp3*~data=user_id=0,application_id=42~hmac=a98f73d0185b4b7e7d83071c09950ff74279b0918a08006bac3ba80bf8eb8dac	73
64	1822997377	Samba de Janeiro (Album Version)	168	2	https://api.deezer.com/album/335236727/image	https://cdnt-preview.dzcdn.net/api/1/1/f/1/8/0/f188ab5167955f445f7e0b279ddd887f.mp3?hdnea=exp=1775489477~acl=/api/1/1/f/1/8/0/f188ab5167955f445f7e0b279ddd887f.mp3*~data=user_id=0,application_id=42~hmac=ef2fe781dc80361c9503b89354179987639c5ca04c7e33e96b8964797635b3d5	74
65	1767733437	Watermelon	110	1	https://api.deezer.com/album/322288667/image	https://cdnt-preview.dzcdn.net/api/1/1/f/2/b/0/f2b34395fe1f995bc504f716f4417d0c.mp3?hdnea=exp=1775489477~acl=/api/1/1/f/2/b/0/f2b34395fe1f995bc504f716f4417d0c.mp3*~data=user_id=0,application_id=42~hmac=833b3fd8115f314f6c8cdd36625cdabb33bad3eea36619728a6eaf11edafb3f5	75
66	394080362	Plain Jane	173	8	https://api.deezer.com/album/46196432/image	https://cdnt-preview.dzcdn.net/api/1/1/4/a/8/0/4a8b3faf09b42a2e4e3cce632634b234.mp3?hdnea=exp=1775489477~acl=/api/1/1/4/a/8/0/4a8b3faf09b42a2e4e3cce632634b234.mp3*~data=user_id=0,application_id=42~hmac=72e47064d33faa37e9eb2c9be66a632def2b85b4a6258dc45d961dfd290f7ea0	76
67	785938	Helena	204	1	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/d/8/1/0/d814b1850bb92c860c77ab7a7dac1455.mp3?hdnea=exp=1775660543~acl=/api/1/1/d/8/1/0/d814b1850bb92c860c77ab7a7dac1455.mp3*~data=user_id=0,application_id=42~hmac=918771ce068af51c666a0c6a4d8fc62937ebc845cd0dccc3f3f5dcf17a24b819	81
68	785961	I'm Not Okay (I Promise)	188	5	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/b/a/d/0/bad956c9a980103195570dd248dfb5e8.mp3?hdnea=exp=1775660543~acl=/api/1/1/b/a/d/0/bad956c9a980103195570dd248dfb5e8.mp3*~data=user_id=0,application_id=42~hmac=ba0c24653b0feee294012db03e3ac8fb3916e0b09d9d258054fbf3e629b2f5ca	81
69	785996	Cemetery Drive	188	12	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/3/4/b/0/34ba3ea718957aa0024cdc05bb767b14.mp3?hdnea=exp=1775660543~acl=/api/1/1/3/4/b/0/34ba3ea718957aa0024cdc05bb767b14.mp3*~data=user_id=0,application_id=42~hmac=c64a9ef4ea5f54f8ee3f711fbe2a73f182baef9dd014885b770cb81eec2318a2	81
70	785948	To the End	181	3	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/6/8/d/0/68d8202c1b0c15f5bbf21b6236d7a9f5.mp3?hdnea=exp=1775660543~acl=/api/1/1/6/8/d/0/68d8202c1b0c15f5bbf21b6236d7a9f5.mp3*~data=user_id=0,application_id=42~hmac=ac01d5f56619e209533f2400db09f2589a127183f1909600c8efe7baf7855fac	81
71	785965	The Ghost of You	194	6	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/c/8/2/0/c82c4c11a016263f369dda368448e315.mp3?hdnea=exp=1775660543~acl=/api/1/1/c/8/2/0/c82c4c11a016263f369dda368448e315.mp3*~data=user_id=0,application_id=42~hmac=2bd2e1affb93a0ad0ff84d4d23ba2f2f25b7c23bf956a44b565da64333ccbbfa	81
72	785942	Give 'Em Hell, Kid	138	2	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/5/c/7/0/5c75625944c9fcdea83613c304504d4b.mp3?hdnea=exp=1775660962~acl=/api/1/1/5/c/7/0/5c75625944c9fcdea83613c304504d4b.mp3*~data=user_id=0,application_id=42~hmac=2a86f90e440602989d85384bf049b6df0bd9b018591885afb099194ae2eb6b9f	81
73	785955	You Know What They Do to Guys Like Us in Prison	173	4	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/5/a/6/0/5a6b29aec5552d37289af16055f1517e.mp3?hdnea=exp=1775660962~acl=/api/1/1/5/a/6/0/5a6b29aec5552d37289af16055f1517e.mp3*~data=user_id=0,application_id=42~hmac=9cb382b175f7f9932695aa40aa6b81461aab1dd59a6166d19fcfe506880d01d7	81
74	785970	The Jetset Life Is Gonna Kill You	217	7	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/d/e/2/0/de2e7cbeb74c9567fc178f8016212cb4.mp3?hdnea=exp=1775660962~acl=/api/1/1/d/e/2/0/de2e7cbeb74c9567fc178f8016212cb4.mp3*~data=user_id=0,application_id=42~hmac=382c124953da4535f8148861e1644f02cf1cf764d62de94dd9af2674e3ce89c7	81
75	785976	Interlude	57	8	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/1/2/8/0/1280846078fee49400f905fa6e09d790.mp3?hdnea=exp=1775660962~acl=/api/1/1/1/2/8/0/1280846078fee49400f905fa6e09d790.mp3*~data=user_id=0,application_id=42~hmac=9292e65b0b8537f84c016a7b78465983588528544f519eb2dd05598d8bd7bd9e	81
76	785982	Thank You for the Venom	221	9	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/d/f/5/0/df5c2cfb3cd7a2768435cbabd0460cf2.mp3?hdnea=exp=1775660962~acl=/api/1/1/d/f/5/0/df5c2cfb3cd7a2768435cbabd0460cf2.mp3*~data=user_id=0,application_id=42~hmac=ca0ddd80e21a44a5c02616bdd5f737a20ed1849459ae5822652e237c3b5d06e4	81
77	785985	Hang 'Em High	167	10	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/3/d/8/0/3d89560f484c8c7a7aa084ad7ae767a6.mp3?hdnea=exp=1775660962~acl=/api/1/1/3/d/8/0/3d89560f484c8c7a7aa084ad7ae767a6.mp3*~data=user_id=0,application_id=42~hmac=797af9e124836add592d4e82f012e2609c60f086c1a50959446462e46606ec34	81
78	785989	It's Not a Fashion Statement, It's a Deathwish	210	11	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/f/2/7/0/f27babbbae26d29fbd9f725742b06f39.mp3?hdnea=exp=1775660962~acl=/api/1/1/f/2/7/0/f27babbbae26d29fbd9f725742b06f39.mp3*~data=user_id=0,application_id=42~hmac=34e4f00928f9d47859366f1ef988a0ed61fa355bdabe3a7dc36035bb30babff8	81
79	785999	I Never Told You What I Do for a Living	232	13	https://api.deezer.com/album/91985/image	https://cdnt-preview.dzcdn.net/api/1/1/c/1/2/0/c129be6a5773b02a39714812975a937f.mp3?hdnea=exp=1775660962~acl=/api/1/1/c/1/2/0/c129be6a5773b02a39714812975a937f.mp3*~data=user_id=0,application_id=42~hmac=9d1c80f24c0b39fe5f18af1017948a28e8507c5d2f2884c6fd158b2b5eefc6ff	81
80	635507082	Буйно голова	128	6	https://api.deezer.com/album/87903062/image	https://cdnt-preview.dzcdn.net/api/1/1/9/6/7/0/9676fc25230c865253f5db0355f3b792.mp3?hdnea=exp=1775661876~acl=/api/1/1/9/6/7/0/9676fc25230c865253f5db0355f3b792.mp3*~data=user_id=0,application_id=42~hmac=658f2fdb8b341e14575db505e5e5a511e1b36054813b2d1c81b6d8aa6b927dd0	82
81	1155192392	Катяосадча	179	2	https://api.deezer.com/album/188912412/image	https://cdnt-preview.dzcdn.net/api/1/1/0/5/e/0/05e1784093e8612982764bb470cbe7c5.mp3?hdnea=exp=1775661876~acl=/api/1/1/0/5/e/0/05e1784093e8612982764bb470cbe7c5.mp3*~data=user_id=0,application_id=42~hmac=6fdc1a87d13b4324123249a7ea432ca126a9a64f479b19f6e9a091c1c14dcd67	83
82	449163142	1991	261	11	https://api.deezer.com/album/54847902/image	https://cdnt-preview.dzcdn.net/api/1/1/d/7/e/0/d7eaa04aad07618ae8790e3c2b66d6da.mp3?hdnea=exp=1775661876~acl=/api/1/1/d/7/e/0/d7eaa04aad07618ae8790e3c2b66d6da.mp3*~data=user_id=0,application_id=42~hmac=c25742a8a4cae53e57f29bf3c95a401503f95516177c708b68a4754a18b14e64	84
83	449163072	Ні хуйні	235	4	https://api.deezer.com/album/54847902/image	https://cdnt-preview.dzcdn.net/api/1/1/6/6/a/0/66ac00932a626dad773aa7fa8572895e.mp3?hdnea=exp=1775661876~acl=/api/1/1/6/6/a/0/66ac00932a626dad773aa7fa8572895e.mp3*~data=user_id=0,application_id=42~hmac=4b3f65d7ae2883add64b5a0a68a29afbcefa27874e05fec30c29324095ed4e78	84
84	646080222	Папі тяжело	224	3	https://api.deezer.com/album/89867812/image	https://cdnt-preview.dzcdn.net/api/1/1/e/5/0/0/e502445fc84f71f4c5781606fdb7ffb3.mp3?hdnea=exp=1775661876~acl=/api/1/1/e/5/0/0/e502445fc84f71f4c5781606fdb7ffb3.mp3*~data=user_id=0,application_id=42~hmac=c2979ed0fca05829ed1261a4f500962e4fcb3f6b9b30d25ab9887a0130f03162	85
85	2833834772	360	133	1	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/6/d/f/0/6df461a2309db820e650158cee4f0b70.mp3?hdnea=exp=1775661891~acl=/api/1/1/6/d/f/0/6df461a2309db820e650158cee4f0b70.mp3*~data=user_id=0,application_id=42~hmac=fcf2a1bf626229f5229a9366668949fcb5e9a2733b49c487a2673f5844351546	86
86	2833834782	Club classics	153	2	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/8/b/2/0/8b23a527a2d492b9bf99b548a8cd1f6e.mp3?hdnea=exp=1775661891~acl=/api/1/1/8/b/2/0/8b23a527a2d492b9bf99b548a8cd1f6e.mp3*~data=user_id=0,application_id=42~hmac=293a215ec5917c78a1c050684c15e2581fb12925092ce3e6080209ac6513d851	86
87	2833834792	Sympathy is a knife	151	3	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/5/d/9/0/5d9ac003a4b42c62b46cf9af1d100b14.mp3?hdnea=exp=1775661891~acl=/api/1/1/5/d/9/0/5d9ac003a4b42c62b46cf9af1d100b14.mp3*~data=user_id=0,application_id=42~hmac=67b564101d7c2bba21f968067725ce91add8861094b22e44d631c7bab06961ec	86
88	2833834802	I might say something stupid	109	4	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/4/f/3/0/4f310bb564d3ad2d308b5737edf1693d.mp3?hdnea=exp=1775661891~acl=/api/1/1/4/f/3/0/4f310bb564d3ad2d308b5737edf1693d.mp3*~data=user_id=0,application_id=42~hmac=6e434624aa19f5b8eb40b5152cc0ae8d573f7f736a33a835e75446323b69b047	86
89	2833834812	Talk talk	161	5	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/9/4/d/0/94db203f6e5fb7c11d59f956992a6297.mp3?hdnea=exp=1775661891~acl=/api/1/1/9/4/d/0/94db203f6e5fb7c11d59f956992a6297.mp3*~data=user_id=0,application_id=42~hmac=03216ba338580fe0db612903361e91ea00d0f14b995afae78604bf5f909af7ed	86
90	2833834822	Von dutch	164	6	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/5/7/a/0/57adc1a4c05fa745f9939adcc9c892b2.mp3?hdnea=exp=1775661891~acl=/api/1/1/5/7/a/0/57adc1a4c05fa745f9939adcc9c892b2.mp3*~data=user_id=0,application_id=42~hmac=6aa477399b55642637e502ef17179c159819de17168b9a1b4d730d36bd8a3641	86
91	2833834832	Everything is romantic	203	7	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/5/a/2/0/5a28bbb2b30ae70d63217ee4bccbe103.mp3?hdnea=exp=1775661891~acl=/api/1/1/5/a/2/0/5a28bbb2b30ae70d63217ee4bccbe103.mp3*~data=user_id=0,application_id=42~hmac=edfdc29e5b17a830429359a24eaea870a2534934ef314de6ae9926c97d0a5b51	86
92	2833834842	Rewind	168	8	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/a/2/4/0/a24ba26f5e79f4a57b037140db8b656e.mp3?hdnea=exp=1775661891~acl=/api/1/1/a/2/4/0/a24ba26f5e79f4a57b037140db8b656e.mp3*~data=user_id=0,application_id=42~hmac=01f29680d2f33896da15afefa8557f3599331809fa1b1463dd2a758a8624815d	86
93	2833834852	So I	211	9	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/4/8/1/0/4814c44aaea2483f636dd299f882cb86.mp3?hdnea=exp=1775661891~acl=/api/1/1/4/8/1/0/4814c44aaea2483f636dd299f882cb86.mp3*~data=user_id=0,application_id=42~hmac=4bbda1d274f868bb1f819f8458804277a4cd83e05bc8341789d110078841e3bb	86
94	2833834862	Girl, so confusing	174	10	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/c/a/5/0/ca52e8d9eb71f8a0ad027bbf9650ae52.mp3?hdnea=exp=1775661891~acl=/api/1/1/c/a/5/0/ca52e8d9eb71f8a0ad027bbf9650ae52.mp3*~data=user_id=0,application_id=42~hmac=3a153752cde68a95c287cbb08320cc017d75dcdabf8b867405dea69091dec940	86
95	2833834872	Apple	151	11	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/d/8/6/0/d863ea5f62d2c02d615fc0553835802a.mp3?hdnea=exp=1775661891~acl=/api/1/1/d/8/6/0/d863ea5f62d2c02d615fc0553835802a.mp3*~data=user_id=0,application_id=42~hmac=20edb67baab4a7d7fb353b78cc8f114e34d39da8fd9edfdcf27b51a5faa9e9b5	86
96	2833834882	B2b	178	12	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/f/2/0/0/f20d10b6971a1d13ca2b637bd08fc04a.mp3?hdnea=exp=1775661891~acl=/api/1/1/f/2/0/0/f20d10b6971a1d13ca2b637bd08fc04a.mp3*~data=user_id=0,application_id=42~hmac=5e62ea39aeaf30710b609eeee70a7a5a03fcaa41f68bb7aa377d474b5e0579b9	86
97	2833834892	Mean girls	189	13	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/6/d/5/0/6d5bc979c6e5c72c4fb047804440934d.mp3?hdnea=exp=1775661891~acl=/api/1/1/6/d/5/0/6d5bc979c6e5c72c4fb047804440934d.mp3*~data=user_id=0,application_id=42~hmac=f7afdd23e7e6de6aea40af590f2524d0fc324e400d66b47360265f2d0572ddf3	86
98	2833834902	I think about it all the time	135	14	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/c/b/c/0/cbcdd900dfbfe3c1d1d9b4f73662a49a.mp3?hdnea=exp=1775661891~acl=/api/1/1/c/b/c/0/cbcdd900dfbfe3c1d1d9b4f73662a49a.mp3*~data=user_id=0,application_id=42~hmac=56285e9a14776b1b95385f614ca5749dbf0aeee94854e4ad2c312ef5b0422012	86
99	2833834912	365	203	15	https://api.deezer.com/album/597350882/image	https://cdnt-preview.dzcdn.net/api/1/1/2/a/2/0/2a2937c5c088cd18c7e7cb062ea0494c.mp3?hdnea=exp=1775661891~acl=/api/1/1/2/a/2/0/2a2937c5c088cd18c7e7cb062ea0494c.mp3*~data=user_id=0,application_id=42~hmac=6cea4aeffe7ba9a242370313d7671f3f9f4cec640eb23a09852393ac42e04d17	86
100	525334532	Losing It	248	1	https://api.deezer.com/album/67819132/image	https://cdnt-preview.dzcdn.net/api/1/1/7/a/d/0/7ad87e96efe096d1202a6d294b0ee140.mp3?hdnea=exp=1775662511~acl=/api/1/1/7/a/d/0/7ad87e96efe096d1202a6d294b0ee140.mp3*~data=user_id=0,application_id=42~hmac=2fc2b46f99ba1bbf66ce302f3fa9fbe927ba868f9d3440f3de07962cfd8e9308	91
101	574823082	Losing It (Radio Edit)	163	1	https://api.deezer.com/album/76783062/image	https://cdnt-preview.dzcdn.net/api/1/1/1/c/c/0/1cce1d2025167c08789f5169606af55b.mp3?hdnea=exp=1775662511~acl=/api/1/1/1/c/c/0/1cce1d2025167c08789f5169606af55b.mp3*~data=user_id=0,application_id=42~hmac=d8c6fe1edb02e5dbf9ebd4da2c51cce37cf88565ebc1cc605cbdc34af90a4012	92
102	1976497887	Pretend Lovers	194	4	https://api.deezer.com/album/368425367/image	https://cdnt-preview.dzcdn.net/api/1/1/d/c/7/0/dc78329cf1e3fa453a58ccea32beba1f.mp3?hdnea=exp=1775662511~acl=/api/1/1/d/c/7/0/dc78329cf1e3fa453a58ccea32beba1f.mp3*~data=user_id=0,application_id=42~hmac=7b83578504d22e7f4e524a52a9a283ad40b10a68cb31d06838830db40d971f05	93
103	3832441491	Love You Right	165	1	https://api.deezer.com/album/914989941/image	https://cdnt-preview.dzcdn.net/api/1/1/c/a/4/0/ca48fc8c20dd39ebcae4345e38a885d1.mp3?hdnea=exp=1775662511~acl=/api/1/1/c/a/4/0/ca48fc8c20dd39ebcae4345e38a885d1.mp3*~data=user_id=0,application_id=42~hmac=6e78e454fe75fa6e890bde3de8746a3b439fc6813532c829857dc5418b9771d1	94
104	3092824611	i cant tell (love my money)	163	1	https://api.deezer.com/album/670373061/image	https://cdnt-preview.dzcdn.net/api/1/1/1/3/b/0/13b9a5d68513f1a8ebeafe28087c4201.mp3?hdnea=exp=1775662511~acl=/api/1/1/1/3/b/0/13b9a5d68513f1a8ebeafe28087c4201.mp3*~data=user_id=0,application_id=42~hmac=37f7d17455948080b542fa960ff0994fcf337cf4c3f842e1b7c540a4363f84e2	95
105	1141592672	Atomic Vomit	90	1	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/b/b/4/0/bb4c712b15d1c92b7f54dcaa047d3055.mp3?hdnea=exp=1775662548~acl=/api/1/1/b/b/4/0/bb4c712b15d1c92b7f54dcaa047d3055.mp3*~data=user_id=0,application_id=42~hmac=a85a4a494fbdb7e8ba09315db699e24da4e88a4f8dc9c7cffb4db1ad0a9d04a7	96
106	1141592682	When I	60	2	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/3/1/1/0/31184f22acea6f34f263586490266bfd.mp3?hdnea=exp=1775662548~acl=/api/1/1/3/1/1/0/31184f22acea6f34f263586490266bfd.mp3*~data=user_id=0,application_id=42~hmac=315a61281588b16726658c73f039b19e116145a7ea31c4cdca7be56f818f20f7	96
107	1141592692	Thats No Fun	161	3	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/a/0/3/0/a03fa35811e4935200f9e4a94cc5b259.mp3?hdnea=exp=1775662548~acl=/api/1/1/a/0/3/0/a03fa35811e4935200f9e4a94cc5b259.mp3*~data=user_id=0,application_id=42~hmac=d88b771a4666dd4b9f7a36fd77e372b49000148b8b537c99008c4b2d4109bf8d	96
108	1141592702	Cocky Girl	53	4	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/b/0/0/0/b005552be4ece6f18569c888873f02a4.mp3?hdnea=exp=1775662548~acl=/api/1/1/b/0/0/0/b005552be4ece6f18569c888873f02a4.mp3*~data=user_id=0,application_id=42~hmac=f4b2c1494967338d64d84ba4b6aeb5c3fc5514435aae429987ccae924819c096	96
109	1141592712	Uuuu	90	5	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/3/f/3/0/3f3029337573f402999ac9be648b9e12.mp3?hdnea=exp=1775662548~acl=/api/1/1/3/f/3/0/3f3029337573f402999ac9be648b9e12.mp3*~data=user_id=0,application_id=42~hmac=861ce91db8c3c7f1533d72e205e50f751b5e6e537166c0a51b5ef70e176f74bd	96
110	1141592722	Jars of It	144	6	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/2/8/b/0/28b31b6c5145f0d1aaa965115ea1e9ae.mp3?hdnea=exp=1775662548~acl=/api/1/1/2/8/b/0/28b31b6c5145f0d1aaa965115ea1e9ae.mp3*~data=user_id=0,application_id=42~hmac=91ae22783b80f8af0288b4dc803744e01cd79b545c7baa2b3e3c739359e89dc2	96
111	1141592732	Bars. 16	46	7	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/0/7/6/0/076445228c4185711d3b61ce59807a2f.mp3?hdnea=exp=1775662548~acl=/api/1/1/0/7/6/0/076445228c4185711d3b61ce59807a2f.mp3*~data=user_id=0,application_id=42~hmac=689f75b811ef38e378b010af5c22c4acfb26e634d376c5ee1822435ef67539d3	96
112	1141592742	Infrunami	178	8	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/6/1/c/0/61c454327d68c3af19e7f7d5e71be739.mp3?hdnea=exp=1775662548~acl=/api/1/1/6/1/c/0/61c454327d68c3af19e7f7d5e71be739.mp3*~data=user_id=0,application_id=42~hmac=18f1f87f0917059ba0396fc0e389ed61e43f6cc24a14219b99503cdd6291d759	96
113	1141592752	Hummer	71	9	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/a/8/1/0/a8131190c2ae3cbc2cf148b89c4c4bc4.mp3?hdnea=exp=1775662548~acl=/api/1/1/a/8/1/0/a8131190c2ae3cbc2cf148b89c4c4bc4.mp3*~data=user_id=0,application_id=42~hmac=6fffb605e1c93e735ff511e7910f1d2420830e4278fd2fce4a4a6c4df875a9b5	96
114	1141592762	4real	144	10	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/8/c/c/0/8cc84ffa0d69f113a3dd1ddb753010f2.mp3?hdnea=exp=1775662548~acl=/api/1/1/8/c/c/0/8cc84ffa0d69f113a3dd1ddb753010f2.mp3*~data=user_id=0,application_id=42~hmac=df93cf0dcce8186826a49fd828a7eb814f58dc077ebe89067fe02cc180a926f9	96
115	1141592772	I Think I Should	99	11	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/f/1/4/0/f140cce5e9ef5a3b1c6ebc3df49e334f.mp3?hdnea=exp=1775662548~acl=/api/1/1/f/1/4/0/f140cce5e9ef5a3b1c6ebc3df49e334f.mp3*~data=user_id=0,application_id=42~hmac=085de311bb902045d9d0d34bb80faaa3683f6c52bcb792b5b19eaae0be125daf	96
116	1141592782	Daze	72	12	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/1/7/e/0/17e890319fb0b7065e5fa557784b4bbe.mp3?hdnea=exp=1775662548~acl=/api/1/1/1/7/e/0/17e890319fb0b7065e5fa557784b4bbe.mp3*~data=user_id=0,application_id=42~hmac=9a4f077ca8167926b1eaae70af7ec4922df37ee4c66eeb6b2ff8c7960e350258	96
117	1141592792	Out of Me Head	141	13	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/0/8/6/0/086ea2027e1e662c23bf6c37cdd39723.mp3?hdnea=exp=1775662548~acl=/api/1/1/0/8/6/0/086ea2027e1e662c23bf6c37cdd39723.mp3*~data=user_id=0,application_id=42~hmac=be4528026ac31d9415703d26025cf3e70303ace507aa94e8de4f3a935ac10a27	96
118	1141592802	Donchano	98	14	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/6/e/1/0/6e1b966a1ce5ed7b82e26a228bdf8179.mp3?hdnea=exp=1775662548~acl=/api/1/1/6/e/1/0/6e1b966a1ce5ed7b82e26a228bdf8179.mp3*~data=user_id=0,application_id=42~hmac=95a07ac4d747d5d80f33326074888caa0f0c1c61e5fcc4a2942d1097fe9c7b8f	96
119	1141592812	The Song	66	15	https://api.deezer.com/album/186203092/image	https://cdnt-preview.dzcdn.net/api/1/1/3/a/3/0/3a31820817e7206c47bef7753ab8d789.mp3?hdnea=exp=1775662548~acl=/api/1/1/3/a/3/0/3a31820817e7206c47bef7753ab8d789.mp3*~data=user_id=0,application_id=42~hmac=cce4eb8edee22735c531d7b62d1b5e0410e49c4a08673b2d71a402d202625817	96
120	651514962	Apnea (Instrumental)	205	1	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/e/a/a/0/eaa78a3175489e6c1770826cc576828d.mp3?hdnea=exp=1775662920~acl=/api/1/1/e/a/a/0/eaa78a3175489e6c1770826cc576828d.mp3*~data=user_id=0,application_id=42~hmac=49e501950457600bf39ea25f026c6043a5dafc989c249f67671be2cf66554d81	31
121	651514972	Tremor (Instrumental)	199	2	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/1/6/6/0/166d38e2cb90064aa443f2323572d533.mp3?hdnea=exp=1775662920~acl=/api/1/1/1/6/6/0/166d38e2cb90064aa443f2323572d533.mp3*~data=user_id=0,application_id=42~hmac=745201e03bd27cdd06c2a8e41a28edc4b32f51d7c5dc7a7a2a8b2b2e99e2ea34	31
122	651514982	Night Terrors (Instrumental)	225	3	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/a/7/2/0/a72c54b47b7a4380263f628455ec3c93.mp3?hdnea=exp=1775662920~acl=/api/1/1/a/7/2/0/a72c54b47b7a4380263f628455ec3c93.mp3*~data=user_id=0,application_id=42~hmac=4093f2b03381fe0884074dfaf5f6ee9468db93cdf07d590d548dd1fb30491a83	31
123	651514992	Delusion (Instrumental)	242	4	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/c/6/7/0/c675f0f81385cbc1140478e9d0b8aa7e.mp3?hdnea=exp=1775662920~acl=/api/1/1/c/6/7/0/c675f0f81385cbc1140478e9d0b8aa7e.mp3*~data=user_id=0,application_id=42~hmac=679cb23d14158fd1d2515e9ce75320d7bab33f37338198e3487e223e0fdc3920	31
124	651515002	Withered (Instrumental)	226	5	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/3/c/9/0/3c9e9b4b889aefaee921f66ea8e941ff.mp3?hdnea=exp=1775662920~acl=/api/1/1/3/c/9/0/3c9e9b4b889aefaee921f66ea8e941ff.mp3*~data=user_id=0,application_id=42~hmac=c952c5a3049024771ac12624e03561eb065a6e241ccb378c4cfebe38578a5438	31
125	651515012	Dreamer (Instrumental)	205	6	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/1/3/d/0/13d77cb3e173c75f9a899566d2aede5e.mp3?hdnea=exp=1775662920~acl=/api/1/1/1/3/d/0/13d77cb3e173c75f9a899566d2aede5e.mp3*~data=user_id=0,application_id=42~hmac=bfbde68397843ef96d11b313f6bf860003e8b3dea57f7fc1ccc2067061f98847	31
126	651515022	Forget Me (Instrumental)	253	7	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/7/a/0/0/7a09b4426635bc9f7d1d4f9ec39565bc.mp3?hdnea=exp=1775662920~acl=/api/1/1/7/a/0/0/7a09b4426635bc9f7d1d4f9ec39565bc.mp3*~data=user_id=0,application_id=42~hmac=6bcc215a5d77099db731ac3c1b8f63b40d4afeaa896dfe480677a28b31bb8e90	31
127	651515032	The Place I Feel Safest (Instrumental)	232	8	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/a/2/0/0/a2073f4e3f4084fdf6ec0d1f63f22017.mp3?hdnea=exp=1775662920~acl=/api/1/1/a/2/0/0/a2073f4e3f4084fdf6ec0d1f63f22017.mp3*~data=user_id=0,application_id=42~hmac=03452a3e74bdf7c368d3998371b1bf7bba5f22798784f2a82c1e699739ec3223	31
128	651515042	Silence (Instrumental)	247	9	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/e/c/8/0/ec80611abc6a35bedf4d052da955635c.mp3?hdnea=exp=1775662920~acl=/api/1/1/e/c/8/0/ec80611abc6a35bedf4d052da955635c.mp3*~data=user_id=0,application_id=42~hmac=607cc6ba6cdb8b655bc42646eeeb950929db0377a640d74c98d5aabc6bf12808	31
129	651515052	Best Memory (Instrumental)	265	10	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/2/0/c/0/20c1e1e7b8253e123e397acd1c321e9f.mp3?hdnea=exp=1775662920~acl=/api/1/1/2/0/c/0/20c1e1e7b8253e123e397acd1c321e9f.mp3*~data=user_id=0,application_id=42~hmac=83709b4e4bc49730c2b7d1fe0745056843fcaa9c3378457953d81d6db0bdfba3	31
130	651515072	I'm Not Waiting (Instrumental)	238	12	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/d/1/d/0/d1d3f1f48163e424dacbce5502863541.mp3?hdnea=exp=1775662920~acl=/api/1/1/d/1/d/0/d1d3f1f48163e424dacbce5502863541.mp3*~data=user_id=0,application_id=42~hmac=e846557b1e2ab759bc772b4bf77e390119a8177bc817736ac5a21add1d27705a	31
131	651515082	Shattered (Instrumental)	277	13	https://api.deezer.com/album/90903372/image	https://cdnt-preview.dzcdn.net/api/1/1/f/5/5/0/f55f69e05180bd91d398295e012126c8.mp3?hdnea=exp=1775662920~acl=/api/1/1/f/5/5/0/f55f69e05180bd91d398295e012126c8.mp3*~data=user_id=0,application_id=42~hmac=abc661ace0edaf30bd7ce32ff6518d1bcae21e773ae0ce80e7d6752495ad73cb	31
132	2958579561	Роздуми про стиль	213	7	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/5/f/4/0/5f46ee198ca06c2bd760058543013e0d.mp3?hdnea=exp=1775665838~acl=/api/1/1/5/f/4/0/5f46ee198ca06c2bd760058543013e0d.mp3*~data=user_id=0,application_id=42~hmac=d7c869cd8c6eabc9d4328e8080c0de7dfb2ba486c48666ade63160d4923dcc97	98
133	2958579501	Десять причин	192	1	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/e/2/0/0/e2064456a3b076dd52261a8ab109da58.mp3?hdnea=exp=1775665838~acl=/api/1/1/e/2/0/0/e2064456a3b076dd52261a8ab109da58.mp3*~data=user_id=0,application_id=42~hmac=3f912965783e167ca52df7c7136118e4460bac1b7bffcb08a8a76b06ff9811c3	98
134	2958579531	Страхом задуває	179	4	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/f/7/e/0/f7e83523e10a72f695c553a85d35808d.mp3?hdnea=exp=1775665838~acl=/api/1/1/f/7/e/0/f7e83523e10a72f695c553a85d35808d.mp3*~data=user_id=0,application_id=42~hmac=bf6e37583fb84078064249abba0de3e1fc9241404deae8b576c47458c816e60d	98
135	2958579521	Мрії, бажання, плани, цілі	218	3	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/5/2/5/0/525fdaf9cfe725e88019c15b8026f9c1.mp3?hdnea=exp=1775665838~acl=/api/1/1/5/2/5/0/525fdaf9cfe725e88019c15b8026f9c1.mp3*~data=user_id=0,application_id=42~hmac=128e75389c67a15fcb705d60120000da1406022b45484a896f326795d270711b	98
136	2958579511	Знову на плато	230	2	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/4/d/3/0/4d3795d7c1ce13dc7a82b665d5ce4a01.mp3?hdnea=exp=1775665838~acl=/api/1/1/4/d/3/0/4d3795d7c1ce13dc7a82b665d5ce4a01.mp3*~data=user_id=0,application_id=42~hmac=472e352b81196e4f0f1d5f69dd80caade0589691a79707aee6a3d6f35d7dada7	98
137	2958579541	Відчайдушно живий	186	5	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/7/3/1/0/7310cf94a0ebb909ddf039e71044d0ec.mp3?hdnea=exp=1775665879~acl=/api/1/1/7/3/1/0/7310cf94a0ebb909ddf039e71044d0ec.mp3*~data=user_id=0,application_id=42~hmac=ca2d61f19185ec750e4532e3497e76153a00fba7bb8ad47130adac39b6083199	98
138	2958579551	Угу, ага	178	6	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/2/9/b/0/29b886deb0fcae6b0762e56a81008135.mp3?hdnea=exp=1775665879~acl=/api/1/1/2/9/b/0/29b886deb0fcae6b0762e56a81008135.mp3*~data=user_id=0,application_id=42~hmac=b7dfe0e9c1e7ae51cb966d4dee0e9f0537ad702f5156539326bdf144dfcb3c57	98
139	2958579571	Залишайся вдома	223	8	https://api.deezer.com/album/632901571/image	https://cdnt-preview.dzcdn.net/api/1/1/b/1/b/0/b1bd4cc3e51edba81f81cad73a204c62.mp3?hdnea=exp=1775665879~acl=/api/1/1/b/1/b/0/b1bd4cc3e51edba81f81cad73a204c62.mp3*~data=user_id=0,application_id=42~hmac=9d765d85cc45933b1de05dadecd7410bd45e149200f49b116ffed8ba3b58c20a	98
140	4315389	505	253	12	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/3/2/9/0/329517eb3334d90587e141ae5ace1f40.mp3?hdnea=exp=1776155070~acl=/api/1/1/3/2/9/0/329517eb3334d90587e141ae5ace1f40.mp3*~data=user_id=0,application_id=42~hmac=a3660877d9073def5a59020148b970dd36b4f6ba0a1bf51b3fa3b91ac510fc63	99
141	4315378	Brianstorm	172	1	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/e/2/5/0/e25582132cf097d9dc673e7b014404f6.mp3?hdnea=exp=1776155070~acl=/api/1/1/e/2/5/0/e25582132cf097d9dc673e7b014404f6.mp3*~data=user_id=0,application_id=42~hmac=926bd878f82059e5012f170c227beea5f05b3a2a352e415cefc8bcf1f3f8fa7b	99
142	4315382	Fluorescent Adolescent	183	5	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/e/f/7/0/ef7220044ffe85c636aa2abbe0fafec3.mp3?hdnea=exp=1776155070~acl=/api/1/1/e/f/7/0/ef7220044ffe85c636aa2abbe0fafec3.mp3*~data=user_id=0,application_id=42~hmac=49b6460373a8bffb53f4b37c8ccee6e6d31a559846d10334d70c588ca7db46e1	99
143	4315388	Old Yellow Bricks	193	11	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/6/f/c/0/6fc715766b06b8fe16731f35364d9f70.mp3?hdnea=exp=1776155070~acl=/api/1/1/6/f/c/0/6fc715766b06b8fe16731f35364d9f70.mp3*~data=user_id=0,application_id=42~hmac=d0d90bacc6605d254f6fc9bd7e4e3bb53e635fbcec135421596ed4289664a2ff	99
144	4315379	Teddy Picker	165	2	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/b/4/c/0/b4c87092f14eac8d75d4ff94e5383a1b.mp3?hdnea=exp=1776155070~acl=/api/1/1/b/4/c/0/b4c87092f14eac8d75d4ff94e5383a1b.mp3*~data=user_id=0,application_id=42~hmac=3771216e05875571ca1cb92fdcdf14b2fd5510df1bfb90252a17347dc8810708	99
145	4315380	D is for Dangerous	138	3	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/2/5/e/0/25e8ebc20785ba3c3864a3e81a04109d.mp3?hdnea=exp=1776155133~acl=/api/1/1/2/5/e/0/25e8ebc20785ba3c3864a3e81a04109d.mp3*~data=user_id=0,application_id=42~hmac=faf0eeaeff6e07826d76f6b9abccc4e32feae46090929659280648af398db915	99
146	4315381	Balaclava	171	4	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/5/4/0/0/540078a0daa7c33814bf430884eacbeb.mp3?hdnea=exp=1776155133~acl=/api/1/1/5/4/0/0/540078a0daa7c33814bf430884eacbeb.mp3*~data=user_id=0,application_id=42~hmac=2d7bdefb613066db2d0f228fe668244b1892e6e0b3daf0b99c7391f0bb6de3a5	99
147	4315383	Only Ones Who Know	184	6	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/9/1/8/0/918ab5d9a30d4ea15e2883a1679d93be.mp3?hdnea=exp=1776155133~acl=/api/1/1/9/1/8/0/918ab5d9a30d4ea15e2883a1679d93be.mp3*~data=user_id=0,application_id=42~hmac=cc0ba6a6dec3c7d5505d4908f2f54cb6713529c79d21b31bf948d51f03ac1a82	99
148	4315384	Do Me a Favour	209	7	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/7/d/4/0/7d41de9692128d778ff01badcfb189f8.mp3?hdnea=exp=1776155133~acl=/api/1/1/7/d/4/0/7d41de9692128d778ff01badcfb189f8.mp3*~data=user_id=0,application_id=42~hmac=3e2c3af42dc35102cded658331c6abbc4cec838af106e5c83c6fd073d8da156e	99
149	4315385	This House is a Circus	191	8	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/1/6/e/0/16e2b8e847a7b2f9f6e2a87b0d5e0199.mp3?hdnea=exp=1776155133~acl=/api/1/1/1/6/e/0/16e2b8e847a7b2f9f6e2a87b0d5e0199.mp3*~data=user_id=0,application_id=42~hmac=846d9fd71f50fb5c42a06bf0a8fd81c81eb11b4c54f2eb78bd6dc13e51e96a0b	99
150	4315386	If You Were There, Beware	276	9	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/e/4/7/0/e47f0ea56ef4bf03e89e4f91081c03d9.mp3?hdnea=exp=1776155133~acl=/api/1/1/e/4/7/0/e47f0ea56ef4bf03e89e4f91081c03d9.mp3*~data=user_id=0,application_id=42~hmac=e8827db871e11804dbeb7fbc4e50505e103f537c5b72ed477a8b8cc8b11cc651	99
151	4315387	The Bad Thing	145	10	https://api.deezer.com/album/401346/image	https://cdnt-preview.dzcdn.net/api/1/1/a/7/d/0/a7d6abe3baf0fd3f0241ff5da4894b63.mp3?hdnea=exp=1776155133~acl=/api/1/1/a/7/d/0/a7d6abe3baf0fd3f0241ff5da4894b63.mp3*~data=user_id=0,application_id=42~hmac=ba9c684e2fe46d4f2dd957e19eec638e4f53b0b3ef6a46fc5827bc33b2d69d7d	99
152	3484517561	Death & Romance	314	5	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/b/7/d/0/b7dd5c43cb2beae7cb6771ebaa52b2a5.mp3?hdnea=exp=1776264833~acl=/api/1/1/b/7/d/0/b7dd5c43cb2beae7cb6771ebaa52b2a5.mp3*~data=user_id=0,application_id=42~hmac=bdc3a48dbf36cc63d96fd32a4bf235150c6948ff6e8200228ce4c6ec57d7d033	100
153	3484517531	Killing Time	233	2	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/2/2/6/0/226403edea1357ebbaba4f116384ee2f.mp3?hdnea=exp=1776264833~acl=/api/1/1/2/2/6/0/226403edea1357ebbaba4f116384ee2f.mp3*~data=user_id=0,application_id=42~hmac=e5db7b6536d655ba8b662732ccf3dc022c24eef1dca270c1527f8103a656cfd1	100
154	709290882	Pega pega (Participação especial de Jojo Maronttinni) (Ao vivo)	222	17	https://api.deezer.com/album/102960742/image	https://cdnt-preview.dzcdn.net/api/1/1/b/9/a/0/b9a2cb1675184419927cc0ef6a2d1735.mp3?hdnea=exp=1776264833~acl=/api/1/1/b/9/a/0/b9a2cb1675184419927cc0ef6a2d1735.mp3*~data=user_id=0,application_id=42~hmac=d62f7d01e962fd119973ee4645e054ff902fcf1b71c0540d6b2c2047c7fbae29	101
155	3484517641	Cry for Me	307	13	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/4/9/6/0/4960806a9b83dbf840e6fedfc0494255.mp3?hdnea=exp=1776264833~acl=/api/1/1/4/9/6/0/4960806a9b83dbf840e6fedfc0494255.mp3*~data=user_id=0,application_id=42~hmac=c635f63e59be4937ae1d259df38fe0f6a4d3aed5279221286afe455112148086	100
156	3484517521	She Looked Like Me!	193	1	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/3/c/7/0/3c7c9d0a81efbcc941a9e341fbc63f9c.mp3?hdnea=exp=1776264833~acl=/api/1/1/3/c/7/0/3c7c9d0a81efbcc941a9e341fbc63f9c.mp3*~data=user_id=0,application_id=42~hmac=700d3c89b87fb688c5535d52281f4b69a17cee5c3f6983dc885b1a1698cd5aed	100
157	3484517541	True Blue Interlude	109	3	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/d/3/5/0/d35822b5013836043adb6280217cc2c0.mp3?hdnea=exp=1776264865~acl=/api/1/1/d/3/5/0/d35822b5013836043adb6280217cc2c0.mp3*~data=user_id=0,application_id=42~hmac=ac3fd08ce323693b2ea87dea03c58854ab0269728490d16043fe61b35478b1ab	100
158	3484517551	Image	212	4	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/3/1/0/0/310e5c1192a6371e4b84c0ccb050c6be.mp3?hdnea=exp=1776264865~acl=/api/1/1/3/1/0/0/310e5c1192a6371e4b84c0ccb050c6be.mp3*~data=user_id=0,application_id=42~hmac=da592c035049c0a8dd853e20aa4b58bf529530710db5a851e26c64b076439e9d	100
159	3484517571	Fear, Sex	152	6	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/e/8/7/0/e875c865be0c5ca0f1ff3578857232e5.mp3?hdnea=exp=1776264865~acl=/api/1/1/e/8/7/0/e875c865be0c5ca0f1ff3578857232e5.mp3*~data=user_id=0,application_id=42~hmac=84ee8b3edc1146d6bb67bd20816c9be2bc98dd4f0be2486c2588a0302bc207a1	100
160	3484517581	Vampire in the Corner	202	7	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/9/6/e/0/96e40fddfef2dfa0cdd97c1b16d4b75a.mp3?hdnea=exp=1776264865~acl=/api/1/1/9/6/e/0/96e40fddfef2dfa0cdd97c1b16d4b75a.mp3*~data=user_id=0,application_id=42~hmac=fbbeed60acd5b9ac0fc4163567ee1fbc71837580d35fc67b213590b3a000e51c	100
161	3484517591	Watching T.V.	245	8	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/8/e/4/0/8e4b8b0ed630c941c7c0688253d27c04.mp3?hdnea=exp=1776264865~acl=/api/1/1/8/e/4/0/8e4b8b0ed630c941c7c0688253d27c04.mp3*~data=user_id=0,application_id=42~hmac=1c4e422f45b807f5edd567a1f6985b498b00eeedd2da52803d983d501b6e9853	100
162	3484517601	Tunnel Vision	305	9	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/c/c/1/0/cc1f24eb0d742d0f6310352383f9f074.mp3?hdnea=exp=1776264865~acl=/api/1/1/c/c/1/0/cc1f24eb0d742d0f6310352383f9f074.mp3*~data=user_id=0,application_id=42~hmac=bc6a6a934b207b318cadc0efe71708ed8a9a9b94281bfccbd68764867f5d364d	100
163	3484517611	Love Is Everywhere	194	10	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/4/5/b/0/45bd38abd591afad66b673856bd0097b.mp3?hdnea=exp=1776264865~acl=/api/1/1/4/5/b/0/45bd38abd591afad66b673856bd0097b.mp3*~data=user_id=0,application_id=42~hmac=67ca133f533d5905934781eb60f5f32b436333e39e65e2bbfba09ae2f8591765	100
164	3484517621	Feeling DiskInserted?	58	11	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/2/f/3/0/2f31a6d52f2bdda5dd56e55b2023099f.mp3?hdnea=exp=1776264865~acl=/api/1/1/2/f/3/0/2f31a6d52f2bdda5dd56e55b2023099f.mp3*~data=user_id=0,application_id=42~hmac=cc83098106d44dcc385fb0581b518dc8744316d8fdd8f1d5b27731b7836a3135	100
165	3484517631	That's My Floor	209	12	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/8/8/f/0/88f7de6b62d599d10e8a0d8dd95728ec.mp3?hdnea=exp=1776264865~acl=/api/1/1/8/8/f/0/88f7de6b62d599d10e8a0d8dd95728ec.mp3*~data=user_id=0,application_id=42~hmac=faf408b056b4b471f2a13394abf36b6fde48f0e048fae193586def2b4a23122a	100
166	3484517651	Angel on a Satellite	243	14	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/5/e/f/0/5ef019322a3e94a0a9dc929e33567c7a.mp3?hdnea=exp=1776264865~acl=/api/1/1/5/e/f/0/5ef019322a3e94a0a9dc929e33567c7a.mp3*~data=user_id=0,application_id=42~hmac=2a927fda234b1d5651203d23c734064cf1ec4dc60453ab27f784565b2bd6c236	100
167	3484517661	The Ballad of Matt & Mica	240	15	https://api.deezer.com/album/796709881/image	https://cdnt-preview.dzcdn.net/api/1/1/9/d/7/0/9d770176f60c00df65d524683b9460cb.mp3?hdnea=exp=1776264865~acl=/api/1/1/9/d/7/0/9d770176f60c00df65d524683b9460cb.mp3*~data=user_id=0,application_id=42~hmac=f080d11d30e41be5c13b46321885161d2029406fa7f96fe94df59d0dcf9f40c1	100
168	2983763921	Welcome To Hell	83	1	https://api.deezer.com/album/639869531/image	https://cdnt-preview.dzcdn.net/api/1/1/a/5/4/0/a543c1a17892a52242e3e1d3a0c5a84c.mp3?hdnea=exp=1776325105~acl=/api/1/1/a/5/4/0/a543c1a17892a52242e3e1d3a0c5a84c.mp3*~data=user_id=0,application_id=42~hmac=60687141ab3323ea09e75ab72228ff850fc0918ac90f8002ddc3d070cbf20cee	102
169	3768947302	WELCOME TO HELL	209	1	https://api.deezer.com/album/895784212/image	https://cdnt-preview.dzcdn.net/api/1/1/b/2/b/0/b2b79301f7c51a8afee7c107fb72c3d7.mp3?hdnea=exp=1776325105~acl=/api/1/1/b/2/b/0/b2b79301f7c51a8afee7c107fb72c3d7.mp3*~data=user_id=0,application_id=42~hmac=0cb4d76d3bf253be2e4399320da2e654a697fa870b1aeb7a3dc373422694a02b	103
170	495700592	Welcome to Hell	262	2	https://api.deezer.com/album/62822542/image	https://cdnt-preview.dzcdn.net/api/1/1/2/7/d/0/27d0177733fd94488c1cbbd3fc026026.mp3?hdnea=exp=1776325105~acl=/api/1/1/2/7/d/0/27d0177733fd94488c1cbbd3fc026026.mp3*~data=user_id=0,application_id=42~hmac=05b6f41c1b23ed2b0270d1f986ead4394b62599474cf50aee2a7de1b2779e4d6	104
171	623736442	Welcome To Hell	116	10	https://api.deezer.com/album/85609322/image	https://cdnt-preview.dzcdn.net/api/1/1/3/7/b/0/37bc72958d56faafcab65f0f9f47dccd.mp3?hdnea=exp=1776325105~acl=/api/1/1/3/7/b/0/37bc72958d56faafcab65f0f9f47dccd.mp3*~data=user_id=0,application_id=42~hmac=c98b73ee670063a138111a89c35e32d297cebfdf74aaa2b9d49a1e0777d8d519	105
172	11655106	Welcome To Hell	250	1	https://api.deezer.com/album/1066859/image	https://cdnt-preview.dzcdn.net/api/1/1/1/b/b/0/1bbd77362170c30f41826a3d9ffe04e4.mp3?hdnea=exp=1776325105~acl=/api/1/1/1/b/b/0/1bbd77362170c30f41826a3d9ffe04e4.mp3*~data=user_id=0,application_id=42~hmac=51f2a8d6de016cd51bd4c729650f8271753aa97a235bcf68fb688b948be420ca	106
173	2983763931	Welcome To Hell (Sped Up)	75	2	https://api.deezer.com/album/639869531/image	https://cdnt-preview.dzcdn.net/api/1/1/1/a/4/0/1a4d274ed7ea2a3100d54b4692a71ed3.mp3?hdnea=exp=1776325125~acl=/api/1/1/1/a/4/0/1a4d274ed7ea2a3100d54b4692a71ed3.mp3*~data=user_id=0,application_id=42~hmac=f8824e06eb9a1f87db84e767ab0d49ac144ee5604b1fb1165f826a2a5664227b	102
174	2983763941	Welcome To Hell (Slowed Down)	93	3	https://api.deezer.com/album/639869531/image	https://cdnt-preview.dzcdn.net/api/1/1/2/b/0/0/2b0042cf41cb3d5b720b602b0bcafe82.mp3?hdnea=exp=1776325125~acl=/api/1/1/2/b/0/0/2b0042cf41cb3d5b720b602b0bcafe82.mp3*~data=user_id=0,application_id=42~hmac=284186a35fdfe888057fef9b4b2d5183e4a3c66ee3607bb52cc734de6a5f29a6	102
175	5093604	This Charming Man (Single Version; 2008 Remaster)	163	2	https://api.deezer.com/album/467267/image	https://cdnt-preview.dzcdn.net/api/1/1/c/b/8/0/cb836f510f8aa8c754947b692d480df5.mp3?hdnea=exp=1776326954~acl=/api/1/1/c/b/8/0/cb836f510f8aa8c754947b692d480df5.mp3*~data=user_id=0,application_id=42~hmac=f03aa74d2468afb53a58283be3c476faa196252eb0543ec491eb5699a29a1e0b	107
176	13786035	This Charming Man (John Peel Session 14/09/83)	163	4	https://api.deezer.com/album/1261479/image	https://cdnt-preview.dzcdn.net/api/1/1/2/9/3/0/2936c35af17372e7a42345d8db0d8cd4.mp3?hdnea=exp=1776326954~acl=/api/1/1/2/9/3/0/2936c35af17372e7a42345d8db0d8cd4.mp3*~data=user_id=0,application_id=42~hmac=60f6efdc5a07f2ab618fabda5dcafaf8ef38ce85ddb31bed1a60598a8dc0da12	108
177	5093628	This Charming Man (New York Vocal; 2008 Remaster)	336	26	https://api.deezer.com/album/467267/image	https://cdnt-preview.dzcdn.net/api/1/1/7/7/9/0/7796ea38c0af54f92c8bdb32623d634b.mp3?hdnea=exp=1776326954~acl=/api/1/1/7/7/9/0/7796ea38c0af54f92c8bdb32623d634b.mp3*~data=user_id=0,application_id=42~hmac=8dbb0e4fed2d4fa813e451a75efa40b9ce6dc5b2d3b20bb64d383bb22797043e	107
178	2522230851	This Charming Man	200	13	https://api.deezer.com/album/507126981/image	https://cdnt-preview.dzcdn.net/api/1/1/5/4/9/0/5491d1a0ecbef7cbc22a823cecb02919.mp3?hdnea=exp=1776326954~acl=/api/1/1/5/4/9/0/5491d1a0ecbef7cbc22a823cecb02919.mp3*~data=user_id=0,application_id=42~hmac=4b0a5431b510ef025f2139f433fffde23426d080eceb9b4656d77abe5a2d9e63	109
179	3805786232	This Charming Man (Live)	185	5	https://api.deezer.com/album/906042682/image	https://cdnt-preview.dzcdn.net/api/1/1/c/c/7/0/cc7c1d05cd4b660753225e63d0199aee.mp3?hdnea=exp=1776326954~acl=/api/1/1/c/c/7/0/cc7c1d05cd4b660753225e63d0199aee.mp3*~data=user_id=0,application_id=42~hmac=409d02a159060da652daa4739a8ec4b36d1231bdba32796fbb3d365e38fec452	110
180	2622563192	hades in the dead of winter	331	3	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/c/a/d/0/cad90873653e334b2bdd8669ba4c9f18.mp3?hdnea=exp=1776459429~acl=/api/1/1/c/a/d/0/cad90873653e334b2bdd8669ba4c9f18.mp3*~data=user_id=0,application_id=42~hmac=2f91df8f9d0e2ccf640966d856825f7e7030c2f3903b77dfad79fa99828a2aec	116
181	2622563172	kanojo ga tsumetaku warattara (prologue to the nine stages of change at the deceased remains)	274	1	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/0/1/b/0/01b84afc69fc2f9ce2346e9c31fa5bbc.mp3?hdnea=exp=1776459451~acl=/api/1/1/0/1/b/0/01b84afc69fc2f9ce2346e9c31fa5bbc.mp3*~data=user_id=0,application_id=42~hmac=23f5e13a2f0f982f305117fc3054c16a613376344e7f288f9b3032b28a65694d	116
182	2622563182	te wo futte	227	2	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/8/f/4/0/8f4e86abc71d4c7c6cc8b4f4fa6be7d5.mp3?hdnea=exp=1776459451~acl=/api/1/1/8/f/4/0/8f4e86abc71d4c7c6cc8b4f4fa6be7d5.mp3*~data=user_id=0,application_id=42~hmac=55cb4a3160069ec9b584f7de61b0a1aeaef738dd71e7ce84f002761f517a3165	116
183	2622563202	danke	272	4	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/4/b/b/0/4bbe9a8ec7e27d173788841f44a08bf1.mp3?hdnea=exp=1776459451~acl=/api/1/1/4/b/b/0/4bbe9a8ec7e27d173788841f44a08bf1.mp3*~data=user_id=0,application_id=42~hmac=ec6de6bde93b691532202190e78f75749bf594a5c6218e9b621cdb0eeaffe293	116
184	2622563212	Hong Kong Police	241	5	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/8/3/b/0/83b38d3ca4d0937027e84a65dfbe39a5.mp3?hdnea=exp=1776459451~acl=/api/1/1/8/3/b/0/83b38d3ca4d0937027e84a65dfbe39a5.mp3*~data=user_id=0,application_id=42~hmac=6ab2e7e80ba12f43f195bb6ba428a0a39d61296b5f884526792e254bb34eb517	116
185	2622563222	I think about Mary Poppins	396	6	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/1/b/0/0/1b0d3b34b5ea01338bc1225a97d2b99d.mp3?hdnea=exp=1776459451~acl=/api/1/1/1/b/0/0/1b0d3b34b5ea01338bc1225a97d2b99d.mp3*~data=user_id=0,application_id=42~hmac=9373907b5daea00e8f3594cfc1550a98474f847c24e63920dfb820ec7ea2ff51	116
186	2622563232	incarnation of pessimism	297	7	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/c/7/f/0/c7f2bd895bfd34bf655ca69e0a5c5411.mp3?hdnea=exp=1776459451~acl=/api/1/1/c/7/f/0/c7f2bd895bfd34bf655ca69e0a5c5411.mp3*~data=user_id=0,application_id=42~hmac=b3fc317b62446818d563b454555c9e055d1114ea6cd52dff578f08a6ebd96116	116
187	2622563242	kanojo ga atsukute kusattara	270	8	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/e/a/2/0/ea20c132d1c48208fc54183bbfdc1922.mp3?hdnea=exp=1776459451~acl=/api/1/1/e/a/2/0/ea20c132d1c48208fc54183bbfdc1922.mp3*~data=user_id=0,application_id=42~hmac=9324491265220fd2c461047442f7a11817463050f87d8806f284cd35bcd68fe2	116
188	2622563252	yurikago kara hakaba made	224	9	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/f/3/8/0/f38b2b1dcccfec289943fc992db3a577.mp3?hdnea=exp=1776459451~acl=/api/1/1/f/3/8/0/f38b2b1dcccfec289943fc992db3a577.mp3*~data=user_id=0,application_id=42~hmac=6af198fc16c8ac6a7f7d5c2d820d346e9f8254a74a2a718cfa6bb18549915f23	116
189	2622563262	hakuiki (the last stage of change at the deceased remains)	389	10	https://api.deezer.com/album/535677592/image	https://cdnt-preview.dzcdn.net/api/1/1/c/2/7/0/c274a9614cec7947d1f9a11c1147e40b.mp3?hdnea=exp=1776459451~acl=/api/1/1/c/2/7/0/c274a9614cec7947d1f9a11c1147e40b.mp3*~data=user_id=0,application_id=42~hmac=99c71ce51feaaac22d43716b7a1b6aec8755c34867230abce5c4810ff6259917	116
190	680414	Kill All Your Friends	268	3	https://api.deezer.com/album/82097/image	https://cdnt-preview.dzcdn.net/api/1/1/e/1/5/0/e154a614f4e60c0890c19daa18cf49dd.mp3?hdnea=exp=1776587519~acl=/api/1/1/e/1/5/0/e154a614f4e60c0890c19daa18cf49dd.mp3*~data=user_id=0,application_id=42~hmac=ed070cdfda24661b6a7e78af9b00b19f41db1c555e9aa16b939c7b3b191add00	117
191	132357594	Kill All Your Friends (Live Demo)	262	16	https://api.deezer.com/album/14069820/image	https://cdnt-preview.dzcdn.net/api/1/1/f/5/8/0/f584c2164d03b7ef1d36b91d4c05f238.mp3?hdnea=exp=1776587519~acl=/api/1/1/f/5/8/0/f584c2164d03b7ef1d36b91d4c05f238.mp3*~data=user_id=0,application_id=42~hmac=c69d8cdd38bdad4b6ef4ea958bdb6852cd22838cb12dbd674e757f0ed2ffccd5	118
192	1962827927	Kill All Your Friends	248	1	https://api.deezer.com/album/365894357/image	https://cdnt-preview.dzcdn.net/api/1/1/0/9/b/0/09be917c9d34ea75d598ce7c91b17c5e.mp3?hdnea=exp=1776587519~acl=/api/1/1/0/9/b/0/09be917c9d34ea75d598ce7c91b17c5e.mp3*~data=user_id=0,application_id=42~hmac=bf274fff3818db635fbceecf3a7701118f8b305c848673bda69d719659c8c1f5	119
193	2744290001	Kill All Your Friends	69	2	https://api.deezer.com/album/571370141/image	https://cdnt-preview.dzcdn.net/api/1/1/5/f/a/0/5faa2fbe943e5c1fa68c7d8079ed802a.mp3?hdnea=exp=1776587519~acl=/api/1/1/5/f/a/0/5faa2fbe943e5c1fa68c7d8079ed802a.mp3*~data=user_id=0,application_id=42~hmac=e59adde4256dda206f3598298f1351ec59a8ed7fbcf4372e054049ce23fa899f	120
194	6776494	Kill All Your Friends	110	5	https://api.deezer.com/album/626101/image	https://cdnt-preview.dzcdn.net/api/1/1/d/b/5/0/db51cd3be436234b116171e9a12bc38f.mp3?hdnea=exp=1776587519~acl=/api/1/1/d/b/5/0/db51cd3be436234b116171e9a12bc38f.mp3*~data=user_id=0,application_id=42~hmac=546090fcf888b458c75102bf591f0a06329839fedb62e4e53389ffcb83fe9cda	121
195	2851583222	Sex appeal	207	4	https://api.deezer.com/album/603134172/image	https://cdnt-preview.dzcdn.net/api/1/1/4/c/8/0/4c82ed7935eb08d67e4fb8e5e8d36cf1.mp3?hdnea=exp=1776595044~acl=/api/1/1/4/c/8/0/4c82ed7935eb08d67e4fb8e5e8d36cf1.mp3*~data=user_id=0,application_id=42~hmac=c32dd0713be003ee3c3b4f9d26cf591b80433352a8ea2f55f45c51f5db54af38	122
196	2843813942	Rachida a bien regardé	196	1	https://api.deezer.com/album/600636262/image	https://cdnt-preview.dzcdn.net/api/1/1/1/b/0/0/1b0dc98a8faa57dc563520ef659fdd4f.mp3?hdnea=exp=1776595044~acl=/api/1/1/1/b/0/0/1b0dc98a8faa57dc563520ef659fdd4f.mp3*~data=user_id=0,application_id=42~hmac=b703c93e5291eff761abfc251aaa0846f20fee7385a7c387ebe676ef611d3452	123
197	2843357552	Distraction	245	10	https://api.deezer.com/album/600488552/image	https://cdnt-preview.dzcdn.net/api/1/1/a/2/4/0/a2429562cae3424c251dde2fb21400f6.mp3?hdnea=exp=1776595044~acl=/api/1/1/a/2/4/0/a2429562cae3424c251dde2fb21400f6.mp3*~data=user_id=0,application_id=42~hmac=c05521a2ed697529980d6551f4ab7b7744f1cc425472a3ffabc5afa179574185	124
198	2843357352	La fille à la tête de dinde	184	7	https://api.deezer.com/album/600488512/image	https://cdnt-preview.dzcdn.net/api/1/1/8/6/8/0/8684e7a9f1fe195ddc417ec8182b2b0d.mp3?hdnea=exp=1776595044~acl=/api/1/1/8/6/8/0/8684e7a9f1fe195ddc417ec8182b2b0d.mp3*~data=user_id=0,application_id=42~hmac=b9934465bb472bb7f5d39038724735a168edf06aeddeece03709351fc4c57b0f	125
199	2843814242	Rien à foutre	209	11	https://api.deezer.com/album/600636302/image	https://cdnt-preview.dzcdn.net/api/1/1/3/d/a/0/3da9fe749880972c16e243dc25b6ce44.mp3?hdnea=exp=1776595044~acl=/api/1/1/3/d/a/0/3da9fe749880972c16e243dc25b6ce44.mp3*~data=user_id=0,application_id=42~hmac=639a20d3be3d7e7514c3a14480de6957d3bbdc82e68f228a185c6c47721addf1	126
200	2843357482	Tu Dégages	216	3	https://api.deezer.com/album/600488552/image	https://cdnt-preview.dzcdn.net/api/1/1/2/9/0/0/290329a4d2a600ef7e90f1c194a9030b.mp3?hdnea=exp=1776868173~acl=/api/1/1/2/9/0/0/290329a4d2a600ef7e90f1c194a9030b.mp3*~data=user_id=0,application_id=42~hmac=254279dae26b203e912c549f3407c573c90f22d4121701d20e9f8b09724b9e06	124
201	2856987432	Calvaire (Fräulein Warrior Version)	261	16	https://api.deezer.com/album/604458542/image	https://cdnt-preview.dzcdn.net/api/1/1/a/3/a/0/a3ac454ca7cb91aa8fdf11877493d1ad.mp3?hdnea=exp=1776868173~acl=/api/1/1/a/3/a/0/a3ac454ca7cb91aa8fdf11877493d1ad.mp3*~data=user_id=0,application_id=42~hmac=a4080daa3e7c249c0e5d21926fba64a6dd6fbd6e9b869eabb0077305c82f4403	127
202	2843357492	L'Idole Des Connes	205	4	https://api.deezer.com/album/600488552/image	https://cdnt-preview.dzcdn.net/api/1/1/6/6/3/0/663cdfa7044741bbfe9962508e1a92b4.mp3?hdnea=exp=1776868173~acl=/api/1/1/6/6/3/0/663cdfa7044741bbfe9962508e1a92b4.mp3*~data=user_id=0,application_id=42~hmac=067bebf6a99d5f7df8f44c91333b4636b65c0e9e5403aafadf08b27a775305dc	124
203	65440513	80's Comedown Machine	298	5	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/5/6/1/0/561df715ab47e0a1221012d325a87eb1.mp3?hdnea=exp=1776868196~acl=/api/1/1/5/6/1/0/561df715ab47e0a1221012d325a87eb1.mp3*~data=user_id=0,application_id=42~hmac=daa93ff46a3e80cc1f6758e6124e099d53be617bd944cdb891f037eb9e02ac54	128
204	2948434851	Comedown	217	3	https://api.deezer.com/album/629800531/image	https://cdnt-preview.dzcdn.net/api/1/1/2/1/8/0/218d4a8e2332f13cae56bf13596ea95a.mp3?hdnea=exp=1776868196~acl=/api/1/1/2/1/8/0/218d4a8e2332f13cae56bf13596ea95a.mp3*~data=user_id=0,application_id=42~hmac=65e116397293b24f301c3a264bdf00a942b2f7b238a9215a50e0864fa9ebaa1d	129
205	1799072177	The Final Comedown (2012 Remaster)	127	11	https://api.deezer.com/album/329338227/image	https://cdnt-preview.dzcdn.net/api/1/1/f/0/0/0/f006fd449180bc80f69da9cf8d038f50.mp3?hdnea=exp=1776868196~acl=/api/1/1/f/0/0/0/f006fd449180bc80f69da9cf8d038f50.mp3*~data=user_id=0,application_id=42~hmac=7e6b3fa8114ecb52fc529d4b03699a7aa6f090cc832a22266976d216a17f242e	130
206	65440509	Tap Out	222	1	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/1/1/6/0/116d57c31c9b5dd87f05e588e30acd86.mp3?hdnea=exp=1776868196~acl=/api/1/1/1/1/6/0/116d57c31c9b5dd87f05e588e30acd86.mp3*~data=user_id=0,application_id=42~hmac=6d09521b095acf03241caf1e82ee26d49d203c7e8e94c3e47ba533f442faa259	128
207	65440511	One Way Trigger	242	3	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/6/2/9/0/629b855a83a181c8ee0386ff50e36067.mp3?hdnea=exp=1776868196~acl=/api/1/1/6/2/9/0/629b855a83a181c8ee0386ff50e36067.mp3*~data=user_id=0,application_id=42~hmac=0b8cbd5970cb422fec0e0b8372843cce410a71579565e6444e85e2b52c1a90cf	128
208	65440510	All The Time	181	2	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/a/a/0/0/aa0d49cac9c3d316c836d325bed82c6d.mp3?hdnea=exp=1776868242~acl=/api/1/1/a/a/0/0/aa0d49cac9c3d316c836d325bed82c6d.mp3*~data=user_id=0,application_id=42~hmac=fa5f2df60a82567ead203dd73edb659ea165657de46576a69f0c36f5d1cc685d	128
209	65440512	Welcome To Japan	230	4	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/0/1/8/0/018ca20c2b82e542db7855f162a94201.mp3?hdnea=exp=1776868242~acl=/api/1/1/0/1/8/0/018ca20c2b82e542db7855f162a94201.mp3*~data=user_id=0,application_id=42~hmac=e43dd1a8813ed77de994d1071046a6702b8b3f15d9646ff1334e1d2a89575223	128
210	65440514	50/50	163	6	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/5/4/b/0/54bf2a2462874ce95f34b8c1d59e936a.mp3?hdnea=exp=1776868242~acl=/api/1/1/5/4/b/0/54bf2a2462874ce95f34b8c1d59e936a.mp3*~data=user_id=0,application_id=42~hmac=295343f9d494252b2c2bafbcb8fa6f782b90f318b7947eeab6781fce606de8fc	128
211	65440515	Slow Animals	260	7	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/9/9/9/0/9996898c45dff124f241f733cfa90d49.mp3?hdnea=exp=1776868242~acl=/api/1/1/9/9/9/0/9996898c45dff124f241f733cfa90d49.mp3*~data=user_id=0,application_id=42~hmac=ed79a422373486acf1c4f109ea31af1a2ea43f193e6c02ba9a50d8d2196d744d	128
212	65440516	Partners In Crime	201	8	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/8/2/4/0/824a59768bf6e4c874ddc8a3f745e5dc.mp3?hdnea=exp=1776868242~acl=/api/1/1/8/2/4/0/824a59768bf6e4c874ddc8a3f745e5dc.mp3*~data=user_id=0,application_id=42~hmac=2926de27efaffa656a88baed3e456a27422a3694bca1291ce95837c8479daa08	128
213	65440517	Chances	216	9	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/b/7/4/0/b74362a61cf3af63b7a7bbac31be1181.mp3?hdnea=exp=1776868242~acl=/api/1/1/b/7/4/0/b74362a61cf3af63b7a7bbac31be1181.mp3*~data=user_id=0,application_id=42~hmac=3191bee41d99394f11e28676a6a5dc2eea123ba8a1a4238b0f6ffd30b4718cf7	128
214	65440518	Happy Ending	172	10	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/f/d/4/0/fd4d10468fa45992195a01a6c7006e87.mp3?hdnea=exp=1776868242~acl=/api/1/1/f/d/4/0/fd4d10468fa45992195a01a6c7006e87.mp3*~data=user_id=0,application_id=42~hmac=da61e1ac2b87c69e1e19a45c6e2390e62933ca84a069da169112a4bea783b399	128
215	65440519	Call It Fate, Call It Karma	204	11	https://api.deezer.com/album/6414905/image	https://cdnt-preview.dzcdn.net/api/1/1/4/0/1/0/401216800c39af26151e36e26f3f7d2a.mp3?hdnea=exp=1776868242~acl=/api/1/1/4/0/1/0/401216800c39af26151e36e26f3f7d2a.mp3*~data=user_id=0,application_id=42~hmac=39370149355a63119e754b6cfa39224b0df4b87fdb270b3819266b65e2b84654	128
216	1223180592	Моргенштерн	165	6	https://api.deezer.com/album/203110682/image	https://cdnt-preview.dzcdn.net/api/1/1/5/5/1/0/5510e6d5c47799a812d241325783f642.mp3?hdnea=exp=1777141876~acl=/api/1/1/5/5/1/0/5510e6d5c47799a812d241325783f642.mp3*~data=user_id=0,application_id=42~hmac=d938836b7557b16078ff6b83f8c98dbca3b1fef079b00b3d9d50404ab67a3726	131
217	1113114172	моргенштерн	236	7	https://api.deezer.com/album/180497152/image	https://cdnt-preview.dzcdn.net/api/1/1/b/5/5/0/b55798b3d84eeb1296187661dc2900f6.mp3?hdnea=exp=1777141876~acl=/api/1/1/b/5/5/0/b55798b3d84eeb1296187661dc2900f6.mp3*~data=user_id=0,application_id=42~hmac=27a4711ca2946748574196ba32580d0ab8e923bafb6d9856dcb04ede91561a8a	132
218	1711271137	Моргенштерн Скриптонит Легенда	85	1	https://api.deezer.com/album/308977677/image	https://cdnt-preview.dzcdn.net/api/1/1/3/3/6/0/33682d2b57037330d1f1285f02a8d9ce.mp3?hdnea=exp=1777141876~acl=/api/1/1/3/3/6/0/33682d2b57037330d1f1285f02a8d9ce.mp3*~data=user_id=0,application_id=42~hmac=172fcc4a1546cf2bdf7923866d7e28da5b6925029d162c5fab644b1a85287869	133
219	1915441187	Париж	161	4	https://api.deezer.com/album/356999357/image	https://cdnt-preview.dzcdn.net/api/1/1/6/9/8/0/698145a0e22ffc59ef4292f412c0a1dd.mp3?hdnea=exp=1777141876~acl=/api/1/1/6/9/8/0/698145a0e22ffc59ef4292f412c0a1dd.mp3*~data=user_id=0,application_id=42~hmac=15d2b30fcd2b9a0d804fcc853b1f6dd30bdfd27cb90fa17fb65cedbc9ef7f897	134
220	1915441157	Влюблино	181	1	https://api.deezer.com/album/356999357/image	https://cdnt-preview.dzcdn.net/api/1/1/7/d/4/0/7d46a96242e2a64f15b40acda7084231.mp3?hdnea=exp=1777141876~acl=/api/1/1/7/d/4/0/7d46a96242e2a64f15b40acda7084231.mp3*~data=user_id=0,application_id=42~hmac=be27b646576c74daa26c0625ac4e73d98b5e97b93ddb24dff47a8cc9d60a0483	134
221	91637094	Каділак	172	6	https://api.deezer.com/album/9298172/image	https://cdnt-preview.dzcdn.net/api/1/1/b/e/4/0/be429038f2fe3b5ab17b7f82665dddb7.mp3?hdnea=exp=1777141886~acl=/api/1/1/b/e/4/0/be429038f2fe3b5ab17b7f82665dddb7.mp3*~data=user_id=0,application_id=42~hmac=201c5cbc0b7209f541d9a2e54381178f2502bca18179a5551d065a192f13273f	135
222	1460426482	Чёрный пистолет	96	1	https://api.deezer.com/album/250776582/image	https://cdnt-preview.dzcdn.net/api/1/1/8/2/7/0/8270c8c916e1d535a64e84f772eab011.mp3?hdnea=exp=1777141886~acl=/api/1/1/8/2/7/0/8270c8c916e1d535a64e84f772eab011.mp3*~data=user_id=0,application_id=42~hmac=408079147ec67e670fe6c8ae8f637b128de2f282e8e709e7473a321defd5b255	136
223	970503272	Кадилакта	161	4	https://api.deezer.com/album/150454752/image	https://cdnt-preview.dzcdn.net/api/1/1/0/f/a/0/0fa453a80dd46106d3485c70ffe16798.mp3?hdnea=exp=1777141886~acl=/api/1/1/0/f/a/0/0fa453a80dd46106d3485c70ffe16798.mp3*~data=user_id=0,application_id=42~hmac=f415099b09e1b27956549db38b8a0dd198d339185a6fa86a471bb74902c31b35	137
224	1091848082	Кандалакша-56	151	43	https://api.deezer.com/album/175833112/image	https://cdnt-preview.dzcdn.net/api/1/1/e/2/4/0/e243593beb962c1b1641e00ffaef2af6.mp3?hdnea=exp=1777141886~acl=/api/1/1/e/2/4/0/e243593beb962c1b1641e00ffaef2af6.mp3*~data=user_id=0,application_id=42~hmac=948880a9a3cc1dad00469f27d5643a438443d49aeb3c7de1c82b2bba0f1ae756	138
225	100699218	Кандалакша	251	7	https://api.deezer.com/album/10355768/image	https://cdnt-preview.dzcdn.net/api/1/1/c/3/e/0/c3e781c286dfd23b9001286857a8e8e5.mp3?hdnea=exp=1777141886~acl=/api/1/1/c/3/e/0/c3e781c286dfd23b9001286857a8e8e5.mp3*~data=user_id=0,application_id=42~hmac=8897b045d3bcce6d3f69f46fe16faf719f57a462d29b9bbe112174eb9722f591	139
226	2969992851	Thing	234	1	https://api.deezer.com/album/635940221/image	https://cdnt-preview.dzcdn.net/api/1/1/7/0/e/0/70e3c21205c60c8085a659291acaf13a.mp3?hdnea=exp=1777141964~acl=/api/1/1/7/0/e/0/70e3c21205c60c8085a659291acaf13a.mp3*~data=user_id=0,application_id=42~hmac=9627020380d8d73b3d9f016d536eb177c0be15c9fbaecc55996ba8d69b954966	148
227	946048	Fistful Of Love	351	7	https://api.deezer.com/album/106462/image	https://cdnt-preview.dzcdn.net/api/1/1/7/e/e/0/7eee9c548f03f408f1b2f2d9004bf829.mp3?hdnea=exp=1777141964~acl=/api/1/1/7/e/e/0/7eee9c548f03f408f1b2f2d9004bf829.mp3*~data=user_id=0,application_id=42~hmac=d83bbf680156c54f912283fa3c3db65cde84607c43f6cbac7544b2ba12105668	149
228	1743658157	Fall in Love with You.	132	1	https://api.deezer.com/album/316706887/image	https://cdnt-preview.dzcdn.net/api/1/1/f/d/9/0/fd9b33a9bc11de6246afe3936b596de2.mp3?hdnea=exp=1777141964~acl=/api/1/1/f/d/9/0/fd9b33a9bc11de6246afe3936b596de2.mp3*~data=user_id=0,application_id=42~hmac=96363083be045a2c5685e8ea00376aecde7d2da506ca6e9f06ee4c76c767dd47	97
229	1518058732	Whatever People Say That I Am (That's What I'm Not)	277	6	https://api.deezer.com/album/264782602/image	https://cdnt-preview.dzcdn.net/api/1/1/8/b/3/0/8b379b7b5ccaf0fb4334d7d5ca199597.mp3?hdnea=exp=1777141982~acl=/api/1/1/8/b/3/0/8b379b7b5ccaf0fb4334d7d5ca199597.mp3*~data=user_id=0,application_id=42~hmac=5a1ef4743e521a9a0ae55e88df8b1c268aadff45d155f825e6195f6c47a27e83	150
230	4315317	Mardy Bum	175	9	https://api.deezer.com/album/401340/image	https://cdnt-preview.dzcdn.net/api/1/1/3/f/2/0/3f2e4b9651387376f1d9bd5c3511052f.mp3?hdnea=exp=1777141982~acl=/api/1/1/3/f/2/0/3f2e4b9651387376f1d9bd5c3511052f.mp3*~data=user_id=0,application_id=42~hmac=a85f30789bdf4898ddcbcea6e82a2680788c455f7fa43d00d93d177996664701	151
231	4315310	I Bet You Look Good On The Dancefloor	173	2	https://api.deezer.com/album/401340/image	https://cdnt-preview.dzcdn.net/api/1/1/6/6/7/0/667973ef99272d4622145ddddd4f1201.mp3?hdnea=exp=1777141982~acl=/api/1/1/6/6/7/0/667973ef99272d4622145ddddd4f1201.mp3*~data=user_id=0,application_id=42~hmac=7e49c5f1b3f3bc009555d8298da03705ce6e795a200dfcb37c0cb7ceeac4c2e9	151
232	4315311	Fake Tales Of San Francisco	177	3	https://api.deezer.com/album/401340/image	https://cdnt-preview.dzcdn.net/api/1/1/9/d/1/0/9d1e9a0a40f51f6920a15bc6df6f6b4a.mp3?hdnea=exp=1777141982~acl=/api/1/1/9/d/1/0/9d1e9a0a40f51f6920a15bc6df6f6b4a.mp3*~data=user_id=0,application_id=42~hmac=807cbc26fb6e0a938b9c7648044621ad035484ceca686ca989e71a6bb4a9bcee	151
233	4315315	Riot Van	134	7	https://api.deezer.com/album/401340/image	https://cdnt-preview.dzcdn.net/api/1/1/3/e/4/0/3e4bbe53e8f2bc74a4429d0588136580.mp3?hdnea=exp=1777141982~acl=/api/1/1/3/e/4/0/3e4bbe53e8f2bc74a4429d0588136580.mp3*~data=user_id=0,application_id=42~hmac=6097c2854abc364161a5555f6794248d3490dcf30c8949b8a10ee53379126395	151
234	1100592452	Haruka Kanata	242	1	https://api.deezer.com/album/177830722/image	https://cdnt-preview.dzcdn.net/api/1/1/1/e/3/0/1e398e56a4b723f657f81acb706c85db.mp3?hdnea=exp=1777142333~acl=/api/1/1/1/e/3/0/1e398e56a4b723f657f81acb706c85db.mp3*~data=user_id=0,application_id=42~hmac=563b5fe350db4d95579c9412b567d164d8d903123605fa7670a82e6593bc474d	163
235	1100590722	Re:Re:	227	8	https://api.deezer.com/album/177830412/image	https://cdnt-preview.dzcdn.net/api/1/1/0/b/a/0/0ba511a318efc69bb74af925b8ef5d81.mp3?hdnea=exp=1777142333~acl=/api/1/1/0/b/a/0/0ba511a318efc69bb74af925b8ef5d81.mp3*~data=user_id=0,application_id=42~hmac=15ed9ce524a51d702fee8b7379b3e20e4a7218d61118d90cb399d6af0085b820	164
236	975978822	Re: Re: Single version	332	1	https://api.deezer.com/album/151783792/image	https://cdnt-preview.dzcdn.net/api/1/1/7/0/b/0/70b2b2705cd370338386ed04c7b0134d.mp3?hdnea=exp=1777142333~acl=/api/1/1/7/0/b/0/70b2b2705cd370338386ed04c7b0134d.mp3*~data=user_id=0,application_id=42~hmac=b22e09617439276d05c790a447cd3a4b0eaced7474dd7370b9c59e858ac40e0c	165
237	976006152	Blood Circulator	221	1	https://api.deezer.com/album/151792242/image	https://cdnt-preview.dzcdn.net/api/1/1/6/3/9/0/6399f0e6fff721754bf72d922927f746.mp3?hdnea=exp=1777142333~acl=/api/1/1/6/3/9/0/6399f0e6fff721754bf72d922927f746.mp3*~data=user_id=0,application_id=42~hmac=f49a5f32ce7406657f1fa3d8cc4743f6823efd11dfa4b77da05a121c2f6d89f8	166
238	3917999131	Skins	245	1	https://api.deezer.com/album/946143681/image	https://cdnt-preview.dzcdn.net/api/1/1/2/1/8/0/218f04fc17e5e8aaf432af7e78933dc0.mp3?hdnea=exp=1777142333~acl=/api/1/1/2/1/8/0/218f04fc17e5e8aaf432af7e78933dc0.mp3*~data=user_id=0,application_id=42~hmac=c04fbc36830696e90ff475d0cb1cabfa71da5ad70cde7f1145b804c4f9e0e70d	167
239	675316632	Heart To Heart	211	8	https://api.deezer.com/album/95826372/image	https://cdnt-preview.dzcdn.net/api/1/1/f/3/f/0/f3f3e11749c8430bc7cbffe28151935c.mp3?hdnea=exp=1777142361~acl=/api/1/1/f/3/f/0/f3f3e11749c8430bc7cbffe28151935c.mp3*~data=user_id=0,application_id=42~hmac=1ff93a9af8689f52b251745361c05dbafba728b2adc77713352df89b27ded0b3	169
240	76008448	Chamber Of Reflection	232	9	https://api.deezer.com/album/7533292/image	https://cdnt-preview.dzcdn.net/api/1/1/3/1/9/0/319c9f6f028ea4d478d0f6c041fb90b1.mp3?hdnea=exp=1777142361~acl=/api/1/1/3/1/9/0/319c9f6f028ea4d478d0f6c041fb90b1.mp3*~data=user_id=0,application_id=42~hmac=b100d9874c9a6241bb4ff7879c0fed8a092c2765778b991b39adc40a3e04bae1	170
241	62744398	Freaking Out the Neighborhood	174	3	https://api.deezer.com/album/6158996/image	https://cdnt-preview.dzcdn.net/api/1/1/e/d/c/0/edc3eb5029a0a3b4c5478ed976e7d18a.mp3?hdnea=exp=1777142361~acl=/api/1/1/e/d/c/0/edc3eb5029a0a3b4c5478ed976e7d18a.mp3*~data=user_id=0,application_id=42~hmac=0f3969743567eb7d06e892ad4fa6d81d17cd89f52b8a6139b4be2e5a5450b345	171
242	347015791	For the First Time	182	4	https://api.deezer.com/album/39511351/image	https://cdnt-preview.dzcdn.net/api/1/1/1/3/a/0/13a4071dc7fd2bbb0c2cc732c797e865.mp3?hdnea=exp=1777142361~acl=/api/1/1/1/3/a/0/13a4071dc7fd2bbb0c2cc732c797e865.mp3*~data=user_id=0,application_id=42~hmac=01b318e31102e78dc73b28871092ecf88fe52ba69b074524ab70fd7f630fa9dc	172
243	62744403	My Kind of Woman	191	8	https://api.deezer.com/album/6158996/image	https://cdnt-preview.dzcdn.net/api/1/1/a/2/c/0/a2c52d86c525b80008141e53724709e1.mp3?hdnea=exp=1777142361~acl=/api/1/1/a/2/c/0/a2c52d86c525b80008141e53724709e1.mp3*~data=user_id=0,application_id=42~hmac=5735b67ecf576105ae2f700f9ce8ace4eeb18bbfb106bfc08776037d0e9c5715	171
244	138547415	Creep	238	2	https://api.deezer.com/album/14880711/image	https://cdnt-preview.dzcdn.net/api/1/1/b/9/c/0/b9c4cde36fbe176cc3e84dc08fc0611b.mp3?hdnea=exp=1777142371~acl=/api/1/1/b/9/c/0/b9c4cde36fbe176cc3e84dc08fc0611b.mp3*~data=user_id=0,application_id=42~hmac=d71b2a6d72251c8eccc221d564b2cf35a07c1fd7821470f4a17bdcb311304cf4	174
245	138539979	Let Down	299	5	https://api.deezer.com/album/14879699/image	https://cdnt-preview.dzcdn.net/api/1/1/9/9/1/0/991f911408c85213268ebf001476d6b6.mp3?hdnea=exp=1777142371~acl=/api/1/1/9/9/1/0/991f911408c85213268ebf001476d6b6.mp3*~data=user_id=0,application_id=42~hmac=cf89ac68ee0bd0f393a63d7cbb708202d09f7bbdb40202474b7b6ce989378807	175
246	138539981	Karma Police	264	6	https://api.deezer.com/album/14879699/image	https://cdnt-preview.dzcdn.net/api/1/1/4/1/d/0/41dd34fd7d334b1c55b6970ef6db0d2f.mp3?hdnea=exp=1777142371~acl=/api/1/1/4/1/d/0/41dd34fd7d334b1c55b6970ef6db0d2f.mp3*~data=user_id=0,application_id=42~hmac=2fcb27a130e69fdb88b0cd1c6e8e497285d6aa1905cc33919344f2ad34ed60a2	175
247	138539157	No Surprises	229	1	https://api.deezer.com/album/14879583/image	https://cdnt-preview.dzcdn.net/api/1/1/6/3/3/0/6339c4be65e78cbf7b53abe2cd83f0b1.mp3?hdnea=exp=1777142371~acl=/api/1/1/6/3/3/0/6339c4be65e78cbf7b53abe2cd83f0b1.mp3*~data=user_id=0,application_id=42~hmac=e88e5a3aea86af9c85579ee57c2658609eba8e7b19ce3b0ed468a3355fd1cf44	176
248	138544279	Street Spirit (Fade Out)	253	12	https://api.deezer.com/album/14880317/image	https://cdnt-preview.dzcdn.net/api/1/1/0/a/3/0/0a38ba04b6fed75bc1e660e1f34e2587.mp3?hdnea=exp=1777142371~acl=/api/1/1/0/a/3/0/0a38ba04b6fed75bc1e660e1f34e2587.mp3*~data=user_id=0,application_id=42~hmac=2165a05c886dcddf6e4bd477a0cb35977fb80a0f3c62385253483a32c00212d6	177
249	2791872362	Lady Brown	199	3	https://api.deezer.com/album/584380142/image	https://cdnt-preview.dzcdn.net/api/1/1/b/e/8/0/be86d614d1d43c92d880d48390bf67d4.mp3?hdnea=exp=1777142383~acl=/api/1/1/b/e/8/0/be86d614d1d43c92d880d48390bf67d4.mp3*~data=user_id=0,application_id=42~hmac=12ea8768764ad1f6ab044363b97a4ec5c32faad789ec05e84ddace4009baf213	180
250	2791984142	Luv (sic)	289	1	https://api.deezer.com/album/584402082/image	https://cdnt-preview.dzcdn.net/api/1/1/5/8/2/0/58223e821976e5b94a189b0027171c78.mp3?hdnea=exp=1777142383~acl=/api/1/1/5/8/2/0/58223e821976e5b94a189b0027171c78.mp3*~data=user_id=0,application_id=42~hmac=b3c9a14967e2a0a9dae4873c89db4e9ba63c3f2b894c919780033f8c6301c02c	181
251	2791872482	Peaceland	499	15	https://api.deezer.com/album/584380142/image	https://cdnt-preview.dzcdn.net/api/1/1/7/d/c/0/7dc36dfd72fab124c68a0aa84884c97e.mp3?hdnea=exp=1777142383~acl=/api/1/1/7/d/c/0/7dc36dfd72fab124c68a0aa84884c97e.mp3*~data=user_id=0,application_id=42~hmac=a8f851fb25b39ddb0c106057d16ed2cba141ff9c05b0cca36abf97c5d7baa944	180
252	2791984162	Luv (sic.) pt3 (feat. Shing02)	374	3	https://api.deezer.com/album/584402082/image	https://cdnt-preview.dzcdn.net/api/1/1/e/7/0/0/e7042aa11c44ffc2120c0c5c583f9fc1.mp3?hdnea=exp=1777142383~acl=/api/1/1/e/7/0/0/e7042aa11c44ffc2120c0c5c583f9fc1.mp3*~data=user_id=0,application_id=42~hmac=7c0ba99d3753bdf281d893ae259e778ff2a6933452d8e1d11e31a9e0160d89b5	181
253	2791882262	Far Fowls	264	10	https://api.deezer.com/album/584383232/image	https://cdnt-preview.dzcdn.net/api/1/1/2/e/a/0/2ea04df8bf042cfc2d247b5501b6abdb.mp3?hdnea=exp=1777142383~acl=/api/1/1/2/e/a/0/2ea04df8bf042cfc2d247b5501b6abdb.mp3*~data=user_id=0,application_id=42~hmac=800d2448db14c76d6a704d51272ce0f2a3d73c2d1a7ee4160c27f6c157cbf9dd	182
254	6469963	Bitches	165	2	https://api.deezer.com/album/596251/image	https://cdnt-preview.dzcdn.net/api/1/1/3/e/8/0/3e8f7feeb9610889ee8a86b22d6c6fcc.mp3?hdnea=exp=1777142396~acl=/api/1/1/3/e/8/0/3e8f7feeb9610889ee8a86b22d6c6fcc.mp3*~data=user_id=0,application_id=42~hmac=c442c43a9cb4ab30622d35cbdebdf8899074bdf79aaf3bfa543b0dec909ab2e3	185
255	2859555592	Seven Minutes in Heaven	134	4	https://api.deezer.com/album/605282412/image	https://cdnt-preview.dzcdn.net/api/1/1/0/2/4/0/0248734b20adfadc5ffdb13c465389b5.mp3?hdnea=exp=1777142396~acl=/api/1/1/0/2/4/0/0248734b20adfadc5ffdb13c465389b5.mp3*~data=user_id=0,application_id=42~hmac=652188965fe92faab5f33a96376236a60fefcc8d17f64cd7cdfc3218159eabd2	186
256	3657980752	For The Love of God	133	13	https://api.deezer.com/album/857119022/image	https://cdnt-preview.dzcdn.net/api/1/1/9/e/d/0/9ed949de94bcbb82a7c712a8b69fa1b5.mp3?hdnea=exp=1777142396~acl=/api/1/1/9/e/d/0/9ed949de94bcbb82a7c712a8b69fa1b5.mp3*~data=user_id=0,application_id=42~hmac=1939f2a3d2e8ea9a491d311c0d8955db064a401e9181039e8097f5ace8e961bd	187
257	3783894292	Tight	167	4	https://api.deezer.com/album/900775892/image	https://cdnt-preview.dzcdn.net/api/1/1/5/1/c/0/51c7641cab1eddf0f3759cb75d753da1.mp3?hdnea=exp=1777142396~acl=/api/1/1/5/1/c/0/51c7641cab1eddf0f3759cb75d753da1.mp3*~data=user_id=0,application_id=42~hmac=aa725cac1a2316d70d0eb82ebfe7fabaefbdfab7c02af16aa6605e79eec41c8b	188
258	8025461	Shut Me Up	168	1	https://api.deezer.com/album/740768/image	https://cdnt-preview.dzcdn.net/api/1/1/6/8/8/0/68825bb3b344eff006d0da608305d4a5.mp3?hdnea=exp=1777142396~acl=/api/1/1/6/8/8/0/68825bb3b344eff006d0da608305d4a5.mp3*~data=user_id=0,application_id=42~hmac=5a2579e862046e1862da791f828572f49ce674f268d5d5da14dace9e0056fb35	189
259	3470152941	Sugar On My Tongue	153	2	https://api.deezer.com/album/791483241/image	https://cdnt-preview.dzcdn.net/api/1/1/2/f/d/0/2fd3ba3b1617860c6e8d856b96a44bb7.mp3?hdnea=exp=1777142472~acl=/api/1/1/2/f/d/0/2fd3ba3b1617860c6e8d856b96a44bb7.mp3*~data=user_id=0,application_id=42~hmac=7d4fc482a685a440869ae580b97d8262ef71fd25fc0481ad3cff1183b6aa0371	191
260	3064010401	Like Him (feat. Lola Young)	278	12	https://api.deezer.com/album/662648981/image	https://cdnt-preview.dzcdn.net/api/1/1/3/4/c/0/34cb4691b89ff66fe892c224208e12a1.mp3?hdnea=exp=1777142472~acl=/api/1/1/3/4/c/0/34cb4691b89ff66fe892c224208e12a1.mp3*~data=user_id=0,application_id=42~hmac=e2f3b9d955836d73d5b1d2e753661fcf59e1cd9195d3350bfe9c3e84c6140cc1	192
261	384157591	See You Again (feat. Kali Uchis)	180	4	https://api.deezer.com/album/44730061/image	https://cdnt-preview.dzcdn.net/api/1/1/1/5/2/0/152df582229560f1ef355fab43102a1e.mp3?hdnea=exp=1777142472~acl=/api/1/1/1/5/2/0/152df582229560f1ef355fab43102a1e.mp3*~data=user_id=0,application_id=42~hmac=0434348c3411f67b8168dfcc910e1a7fb91309d28392b8a03836042c2bd22d43	193
262	681009652	EARFQUAKE	190	2	https://api.deezer.com/album/97140952/image	https://cdnt-preview.dzcdn.net/api/1/1/5/c/c/0/5ccb6775df9a07a06e8b5f94b9affec1.mp3?hdnea=exp=1777142472~acl=/api/1/1/5/c/c/0/5ccb6775df9a07a06e8b5f94b9affec1.mp3*~data=user_id=0,application_id=42~hmac=b46277650efffb5ed76a6d60211ad8c78c685df56eeed093263f4afc14c562ff	194
263	681009692	NEW MAGIC WAND	195	6	https://api.deezer.com/album/97140952/image	https://cdnt-preview.dzcdn.net/api/1/1/4/9/8/0/498bfe694cd260b9169baec151e771e2.mp3?hdnea=exp=1777142472~acl=/api/1/1/4/9/8/0/498bfe694cd260b9169baec151e771e2.mp3*~data=user_id=0,application_id=42~hmac=6d84811cbab201911b36af3ae465f2cd39c3f785d4f9ec73f4bf767369c21d2d	194
264	3818963601	Dracula (JENNIE Remix)	209	1	https://api.deezer.com/album/910510411/image	https://cdnt-preview.dzcdn.net/api/1/1/6/2/5/0/6254df268039f4200674df6d63701e33.mp3?hdnea=exp=1777142935~acl=/api/1/1/6/2/5/0/6254df268039f4200674df6d63701e33.mp3*~data=user_id=0,application_id=42~hmac=1560d9c0e3af471c7127432a4cfe4b935eef3406c4fb7973497b01340284e892	202
265	3567385391	Dracula	205	1	https://api.deezer.com/album/825550621/image	https://cdnt-preview.dzcdn.net/api/1/1/7/2/d/0/72d9c71556ab7b935a6914bda5029ed2.mp3?hdnea=exp=1777142935~acl=/api/1/1/7/2/d/0/72d9c71556ab7b935a6914bda5029ed2.mp3*~data=user_id=0,application_id=42~hmac=d37d2c31ae61d8db0cf4ce7db0cfd7189e3efab8eab6c184fa21beb4fa0a3181	203
266	103052650	Let It Happen	469	1	https://api.deezer.com/album/10709540/image	https://cdnt-preview.dzcdn.net/api/1/1/6/a/e/0/6aee42a038480ecdcf2d6168f95810f2.mp3?hdnea=exp=1777142935~acl=/api/1/1/6/a/e/0/6aee42a038480ecdcf2d6168f95810f2.mp3*~data=user_id=0,application_id=42~hmac=5957b28c353e66f5dcaf1b83f44023c793952895c15f9b11e487755dfe519e5b	29
267	103052662	The Less I Know The Better	217	7	https://api.deezer.com/album/10709540/image	https://cdnt-preview.dzcdn.net/api/1/1/d/7/e/0/d7e09f788f6834e38f61f8a589b0390a.mp3?hdnea=exp=1777142935~acl=/api/1/1/d/7/e/0/d7e09f788f6834e38f61f8a589b0390a.mp3*~data=user_id=0,application_id=42~hmac=3831e5db8c72ff07a2b95afbc108cfc1c4b3ede868417532f0e2484f41b4747b	29
268	872345282	Borderline	240	3	https://api.deezer.com/album/130876272/image	https://cdnt-preview.dzcdn.net/api/1/1/e/f/e/0/efe16471ba48ab8dd697e33793a7d039.mp3?hdnea=exp=1777142935~acl=/api/1/1/e/f/e/0/efe16471ba48ab8dd697e33793a7d039.mp3*~data=user_id=0,application_id=42~hmac=4c27e4a60257ab7be369c8617b889ef8cee005ddcf730e8b6d9db7fa54f83653	204
269	3929283701	Crush on you	125	1	https://api.deezer.com/album/950475551/image	https://cdnt-preview.dzcdn.net/api/1/1/6/6/8/0/668c7de8ba2e0332f55d58cfe867dacc.mp3?hdnea=exp=1777187602~acl=/api/1/1/6/6/8/0/668c7de8ba2e0332f55d58cfe867dacc.mp3*~data=user_id=0,application_id=42~hmac=d2c8ac5278bc7512f35e392b7d1c55fc84f8c3a442d62be858ec1aa0bc4dbc00	210
270	3256939871	Счастливая	121	1	https://api.deezer.com/album/720461471/image	https://cdnt-preview.dzcdn.net/api/1/1/8/5/1/0/851b9c9b646048f87ec3f5d5b6d30b7b.mp3?hdnea=exp=1777187602~acl=/api/1/1/8/5/1/0/851b9c9b646048f87ec3f5d5b6d30b7b.mp3*~data=user_id=0,application_id=42~hmac=6d18d0dba8a5fa09490944beec131c0da4bc6a5cb8fcb6475d56b3295f32c30d	211
271	65279912	Отойди	282	4	https://api.deezer.com/album/6398213/image	https://cdnt-preview.dzcdn.net/api/1/1/8/6/6/0/866957dfab27b7f1103d04e7aebb0532.mp3?hdnea=exp=1777187602~acl=/api/1/1/8/6/6/0/866957dfab27b7f1103d04e7aebb0532.mp3*~data=user_id=0,application_id=42~hmac=9156c92b75a33730866339fea7060e0bb4597b1113ec64dad4dad58644055ed5	212
272	125491414	Отойди, отойди, грусть-печаль	147	2	https://api.deezer.com/album/13197514/image	https://cdnt-preview.dzcdn.net/api/1/1/3/f/c/0/3fc853a986ade69da8b3b7e62f837239.mp3?hdnea=exp=1777187602~acl=/api/1/1/3/f/c/0/3fc853a986ade69da8b3b7e62f837239.mp3*~data=user_id=0,application_id=42~hmac=2bbec7bfc9a6f5c8d4d657da7ac8cf46e593d89f3c408d857e40aedff05831e4	213
273	117674210	Отойди	232	4	https://api.deezer.com/album/12218542/image	https://cdnt-preview.dzcdn.net/api/1/1/5/4/4/0/5444956254f152a4c59db5022fb35f52.mp3?hdnea=exp=1777187602~acl=/api/1/1/5/4/4/0/5444956254f152a4c59db5022fb35f52.mp3*~data=user_id=0,application_id=42~hmac=ced39970c93767bebdb1976f5d79a7e274850de7c6aa6ea65487d405fb376758	214
274	3952958871	На двох	150	1	https://api.deezer.com/album/958546541/image	https://cdnt-preview.dzcdn.net/api/1/1/9/d/4/0/9d443b2373b26146cdba71c67f548f4e.mp3?hdnea=exp=1777187617~acl=/api/1/1/9/d/4/0/9d443b2373b26146cdba71c67f548f4e.mp3*~data=user_id=0,application_id=42~hmac=455a100566ff0af527ca05ebd954a49ea8f1ac0f66d18a45c6d73d2368d69b29	219
275	2618842312	пащека	186	2	https://api.deezer.com/album/534392132/image	https://cdnt-preview.dzcdn.net/api/1/1/5/5/e/0/55e60a579c18a38a62eb489edb51c8a1.mp3?hdnea=exp=1777187617~acl=/api/1/1/5/5/e/0/55e60a579c18a38a62eb489edb51c8a1.mp3*~data=user_id=0,application_id=42~hmac=8a0859cf0118cdecd6e3f25ba177c456e0f2963b119bd45b6bae55f97408045c	220
276	145049016	Otoi	252	1	https://api.deezer.com/album/15746602/image	https://cdnt-preview.dzcdn.net/api/1/1/3/3/0/0/3306a7340670df9d3921ee18a2e02bf8.mp3?hdnea=exp=1777187617~acl=/api/1/1/3/3/0/0/3306a7340670df9d3921ee18a2e02bf8.mp3*~data=user_id=0,application_id=42~hmac=e63ede8a209388d438c04646e2d17752fbafffefa6ac9d91280aae14c3987f3e	221
277	799277872	Otoi	343	6	https://api.deezer.com/album/118100602/image	https://cdnt-preview.dzcdn.net/api/1/1/8/8/d/0/88dadb18c37dc815f3fa9c38d252b816.mp3?hdnea=exp=1777187617~acl=/api/1/1/8/8/d/0/88dadb18c37dc815f3fa9c38d252b816.mp3*~data=user_id=0,application_id=42~hmac=af13ba7576aaeabc60295779f6ba481fac6888a046b8733dab8cfb0c0a184bdf	222
278	2458573015	Судоми	146	1	https://api.deezer.com/album/489120565/image	https://cdnt-preview.dzcdn.net/api/1/1/0/2/0/0/0208b31c14c641a3a390d8271e91b32f.mp3?hdnea=exp=1777187617~acl=/api/1/1/0/2/0/0/0208b31c14c641a3a390d8271e91b32f.mp3*~data=user_id=0,application_id=42~hmac=3f45ae7e2881f49f60e33324ce9b3396df806cec7535144035ddc49d1f7e930a	223
279	2196957517	CHORT	171	6	https://api.deezer.com/album/418913827/image	https://cdnt-preview.dzcdn.net/api/1/1/9/f/4/0/9f4c2d99895aea63b05f871276e9ad81.mp3?hdnea=exp=1777187629~acl=/api/1/1/9/f/4/0/9f4c2d99895aea63b05f871276e9ad81.mp3*~data=user_id=0,application_id=42~hmac=8535f379dd97cdaf17a37f65ff1c71c1470621fdca376be3cef92566572f3304	226
280	3440584641	Пекло	210	1	https://api.deezer.com/album/781459041/image	https://cdnt-preview.dzcdn.net/api/1/1/b/2/3/0/b23c0c4939ee9c559da3ae2bf2dd38e0.mp3?hdnea=exp=1777187629~acl=/api/1/1/b/2/3/0/b23c0c4939ee9c559da3ae2bf2dd38e0.mp3*~data=user_id=0,application_id=42~hmac=00dd4de71ae89069335dccb939692c7cd8fd7d744b05650db5f96fc87c3b9a48	227
281	3402065411	Забудуться жалі	163	1	https://api.deezer.com/album/768362431/image	https://cdnt-preview.dzcdn.net/api/1/1/9/e/6/0/9e6c1a2a1d90126652b7b77d39fa2262.mp3?hdnea=exp=1777187709~acl=/api/1/1/9/e/6/0/9e6c1a2a1d90126652b7b77d39fa2262.mp3*~data=user_id=0,application_id=42~hmac=512d24a0784dee24bd6f152caa71c7bee6d1963d4f4b2eeefa1509cf77765abb	228
282	2210764257	Безодня	130	1	https://api.deezer.com/album/422429357/image	https://cdnt-preview.dzcdn.net/api/1/1/c/9/a/0/c9a5abb6160136fb87b19329ff888691.mp3?hdnea=exp=1777187709~acl=/api/1/1/c/9/a/0/c9a5abb6160136fb87b19329ff888691.mp3*~data=user_id=0,application_id=42~hmac=7284d21308ec81d911047d6cbb429fdf92957feab54f7c80df2bf36426d2246f	229
283	3947662241	Совковий модернізм	163	1	https://api.deezer.com/album/956596401/image	https://cdnt-preview.dzcdn.net/api/1/1/8/7/b/0/87bf11126ed4da23df291fcda102f6ae.mp3?hdnea=exp=1777187709~acl=/api/1/1/8/7/b/0/87bf11126ed4da23df291fcda102f6ae.mp3*~data=user_id=0,application_id=42~hmac=a92a4040cbdc1419977445bae7e7de7908d4ec281365499a1f0abd207722ce24	230
284	3745081472	Хороший громадянин	166	1	https://api.deezer.com/album/886928522/image	https://cdnt-preview.dzcdn.net/api/1/1/6/3/c/0/63c2c5c6b70f2fed74fa43b71f6e8335.mp3?hdnea=exp=1777187709~acl=/api/1/1/6/3/c/0/63c2c5c6b70f2fed74fa43b71f6e8335.mp3*~data=user_id=0,application_id=42~hmac=53923258eff7abbf210d43946a0ab3f251c76be82dc294105a0fcefd3eb347c4	231
285	3449822261	Кінець фільму	178	1	https://api.deezer.com/album/784655041/image	https://cdnt-preview.dzcdn.net/api/1/1/e/3/a/0/e3a3f3d963dde4084d2abf393bad415d.mp3?hdnea=exp=1777187709~acl=/api/1/1/e/3/a/0/e3a3f3d963dde4084d2abf393bad415d.mp3*~data=user_id=0,application_id=42~hmac=a7f7217017f9ed30f393ea2dddba42272653f34b2612097016a478928e76510d	232
286	3012340061	Тихохода	185	3	https://api.deezer.com/album/647152651/image	https://cdnt-preview.dzcdn.net/api/1/1/1/7/e/0/17e450994c9c0e4f8ecf7e30e127fa10.mp3?hdnea=exp=1777187816~acl=/api/1/1/1/7/e/0/17e450994c9c0e4f8ecf7e30e127fa10.mp3*~data=user_id=0,application_id=42~hmac=aab61c545648e1964ccb1c76ee424db5d0f287d143883e0b07bd1bf6e06e23d1	235
287	3130425871	Тиха вода	288	1	https://api.deezer.com/album/680542031/image	https://cdnt-preview.dzcdn.net/api/1/1/f/d/2/0/fd2c5674fdce21fc26a5c7d7378a296c.mp3?hdnea=exp=1777187816~acl=/api/1/1/f/d/2/0/fd2c5674fdce21fc26a5c7d7378a296c.mp3*~data=user_id=0,application_id=42~hmac=db8070ec61ce24c99ebfbcda7f05518a1f88c9ed429c594c44106be6ed975c31	236
288	2587705962	Тиха вода	238	7	https://api.deezer.com/album/524522822/image	https://cdnt-preview.dzcdn.net/api/1/1/d/1/6/0/d1622bf6a58598edaaa14895bfc0eb4c.mp3?hdnea=exp=1777187816~acl=/api/1/1/d/1/6/0/d1622bf6a58598edaaa14895bfc0eb4c.mp3*~data=user_id=0,application_id=42~hmac=4b6d2214ee63e68477d7afb9fa353e3188bfa30c80a105f1ac7b1f5f4c889626	237
289	2433718395	Тиха Вода	212	1	https://api.deezer.com/album/482459865/image	https://cdnt-preview.dzcdn.net/api/1/1/e/6/5/0/e65a2fd5f576eafcf664db75dc348211.mp3?hdnea=exp=1777187816~acl=/api/1/1/e/6/5/0/e65a2fd5f576eafcf664db75dc348211.mp3*~data=user_id=0,application_id=42~hmac=494b17263d572c2120bae66e5e60a3b044e6aa53a3ec5e2704525aa2be178ad1	238
290	107436088	Тиха вода	201	7	https://api.deezer.com/album/11201916/image	https://cdnt-preview.dzcdn.net/api/1/1/0/2/8/0/0281fd77437d688b14c75d72eff76c44.mp3?hdnea=exp=1777187816~acl=/api/1/1/0/2/8/0/0281fd77437d688b14c75d72eff76c44.mp3*~data=user_id=0,application_id=42~hmac=1872f728155ec3c986da55eb872bd978b1342192bfd3095fbabebaff934a61fa	239
291	601664312	Мексиканець	236	1	https://api.deezer.com/album/81307352/image	https://cdnt-preview.dzcdn.net/api/1/1/a/f/c/0/afc35ee68c775acc8a0826be16f61298.mp3?hdnea=exp=1777187936~acl=/api/1/1/a/f/c/0/afc35ee68c775acc8a0826be16f61298.mp3*~data=user_id=0,application_id=42~hmac=22dd24509af2988447cbb31a22bde97e070887535d94d20e0bf296b7fbc78c85	243
292	2553734662	Танцюй і пий	274	1	https://api.deezer.com/album/515504582/image	https://cdnt-preview.dzcdn.net/api/1/1/a/f/7/0/af7d43761ad5a273c628d5bf695b12cf.mp3?hdnea=exp=1777187936~acl=/api/1/1/a/f/7/0/af7d43761ad5a273c628d5bf695b12cf.mp3*~data=user_id=0,application_id=42~hmac=375f51cc31b3f6e886983d309dc949f81a376552313ff855cf1c0e474ecdcd65	244
293	3380246611	Потяг на Південь	206	1	https://api.deezer.com/album/761174901/image	https://cdnt-preview.dzcdn.net/api/1/1/c/e/3/0/ce3f51b4a7c1cf77d5d3ab782b97458f.mp3?hdnea=exp=1777187936~acl=/api/1/1/c/e/3/0/ce3f51b4a7c1cf77d5d3ab782b97458f.mp3*~data=user_id=0,application_id=42~hmac=ddc41f4a4dfb2fd8e0482979024efffb5a6b60b864794e1198067677e2d7d136	245
294	2486842921	Госпел	215	3	https://api.deezer.com/album/497013131/image	https://cdnt-preview.dzcdn.net/api/1/1/b/a/b/0/bab49a92e658aafd340012e745cbce54.mp3?hdnea=exp=1777187936~acl=/api/1/1/b/a/b/0/bab49a92e658aafd340012e745cbce54.mp3*~data=user_id=0,application_id=42~hmac=f266f415e6836c2894630be77d85afec339ffd4816c39f3ccd0c14919d12a6db	246
295	3068417241	Золото і блакить	230	7	https://api.deezer.com/album/663939851/image	https://cdnt-preview.dzcdn.net/api/1/1/b/e/9/0/be9b2089de9d1f26134b117e5807528d.mp3?hdnea=exp=1777187936~acl=/api/1/1/b/e/9/0/be9b2089de9d1f26134b117e5807528d.mp3*~data=user_id=0,application_id=42~hmac=d561a9decfa1e8f9beb3a1f8682511bc1120745bc666a1246564a01f11e0919b	247
296	3281754281	Контузія	166	13	https://api.deezer.com/album/728605251/image	https://cdnt-preview.dzcdn.net/api/1/1/f/4/2/0/f42c663276a9c3a8c95caaa720374a68.mp3?hdnea=exp=1777187954~acl=/api/1/1/f/4/2/0/f42c663276a9c3a8c95caaa720374a68.mp3*~data=user_id=0,application_id=42~hmac=99fccdd285a08688c585a144dd9715ad722c9c53b7dcb08b84721251784ab7ee	249
297	3405994371	Війни	155	1	https://api.deezer.com/album/769759621/image	https://cdnt-preview.dzcdn.net/api/1/1/c/b/4/0/cb479c0da058bdde8e3c5c5680eb57b7.mp3?hdnea=exp=1777187954~acl=/api/1/1/c/b/4/0/cb479c0da058bdde8e3c5c5680eb57b7.mp3*~data=user_id=0,application_id=42~hmac=f108d4e19beffca988d0f90b6976fd13fde9a813212e3dd93b12b3b62d0b9ceb	250
298	3774200712	Вогняне Коло	194	3	https://api.deezer.com/album/897466882/image	https://cdnt-preview.dzcdn.net/api/1/1/b/1/6/0/b164383b97a4f5232b0d7a35a2951ecc.mp3?hdnea=exp=1777187954~acl=/api/1/1/b/1/6/0/b164383b97a4f5232b0d7a35a2951ecc.mp3*~data=user_id=0,application_id=42~hmac=e90b309a72b4773c083c2ab134063b53fbd7cc9bbbd2e757b1fcf6812ab0ed87	251
299	3745458102	Очі Відьми	317	3	https://api.deezer.com/album/887072072/image	https://cdnt-preview.dzcdn.net/api/1/1/f/6/b/0/f6b15c034bed002fc30443143e53e916.mp3?hdnea=exp=1777187954~acl=/api/1/1/f/6/b/0/f6b15c034bed002fc30443143e53e916.mp3*~data=user_id=0,application_id=42~hmac=a43eb923554e9712433cb5d83464f89751c1018d2d1ae97a91c2162c8aec09ba	252
300	3774200742	Як Летіли Бугаї	209	6	https://api.deezer.com/album/897466882/image	https://cdnt-preview.dzcdn.net/api/1/1/f/e/e/0/feeb034b848cf86c6d561b6e4561d5d1.mp3?hdnea=exp=1777187954~acl=/api/1/1/f/e/e/0/feeb034b848cf86c6d561b6e4561d5d1.mp3*~data=user_id=0,application_id=42~hmac=c0f6d1373e832c16cb6960487537d992f9218eba5a57f54b84adad10c6f9d0c8	251
301	2113690087	Шибеник	186	1	https://api.deezer.com/album/398014727/image	https://cdnt-preview.dzcdn.net/api/1/1/0/5/4/0/054057c618b63be8149f98cc69207659.mp3?hdnea=exp=1777188587~acl=/api/1/1/0/5/4/0/054057c618b63be8149f98cc69207659.mp3*~data=user_id=0,application_id=42~hmac=e906dc60e5ffc171f04d3f7f2f4e0c2bc750af7a7d0eca679e0804aba6a16724	253
302	2113690107	Від зими до літа	146	3	https://api.deezer.com/album/398014727/image	https://cdnt-preview.dzcdn.net/api/1/1/5/e/2/0/5e256fb094d41617ea089862553adb4d.mp3?hdnea=exp=1777188587~acl=/api/1/1/5/e/2/0/5e256fb094d41617ea089862553adb4d.mp3*~data=user_id=0,application_id=42~hmac=0879d2460f4ce39039060adb199fa9b64f7d542357d4337db9ba7523623389e1	253
303	1463465352	Лебеді	203	1	https://api.deezer.com/album/251583152/image	https://cdnt-preview.dzcdn.net/api/1/1/0/9/4/0/0942a45aa28aca5b394fd7a976336424.mp3?hdnea=exp=1777188587~acl=/api/1/1/0/9/4/0/0942a45aa28aca5b394fd7a976336424.mp3*~data=user_id=0,application_id=42~hmac=63d3e6b75cee44b00e7cd942e8362ea7c53fa606f20db0760a1c25cf92d0caef	254
304	2113690127	Жбурляю	203	5	https://api.deezer.com/album/398014727/image	https://cdnt-preview.dzcdn.net/api/1/1/c/7/d/0/c7d094ce99d2d68fca6188323c871a3b.mp3?hdnea=exp=1777188587~acl=/api/1/1/c/7/d/0/c7d094ce99d2d68fca6188323c871a3b.mp3*~data=user_id=0,application_id=42~hmac=4b9b90021e8a5825ee337b5c7c824f95de7c60b2ecc4d52f4ce72620d75c4631	253
305	3945707331	Моровиця	146	1	https://api.deezer.com/album/955832201/image	https://cdnt-preview.dzcdn.net/api/1/1/b/3/4/0/b344716732a5250f205400f61613a55a.mp3?hdnea=exp=1777188587~acl=/api/1/1/b/3/4/0/b344716732a5250f205400f61613a55a.mp3*~data=user_id=0,application_id=42~hmac=70234ee6870c9134cfb8fcd7df84e99c1c7ceefd6223a27803c46bceb729d9a8	255
306	871124582	death bed (coffee for your head)	173	1	https://api.deezer.com/album/130595652/image	https://cdnt-preview.dzcdn.net/api/1/1/b/2/0/0/b204de6fedc9a6f39bcbd53e345cca99.mp3?hdnea=exp=1777189156~acl=/api/1/1/b/2/0/0/b204de6fedc9a6f39bcbd53e345cca99.mp3*~data=user_id=0,application_id=42~hmac=e02dbeba03abf6aee06a4b81800cbab74f7d8d332e5970d9619ad48830b1e861	261
307	1641651592	the perfect pair	177	6	https://api.deezer.com/album/292229642/image	https://cdnt-preview.dzcdn.net/api/1/1/f/2/2/0/f22bbd60b96c8b24a330cdbb2a4f4b02.mp3?hdnea=exp=1777189156~acl=/api/1/1/f/2/2/0/f22bbd60b96c8b24a330cdbb2a4f4b02.mp3*~data=user_id=0,application_id=42~hmac=cbaf833e04c05ae7985329cb133f9dca333f5c6ef5496e3028704f36d39ae7e5	262
308	3880356121	All I Did Was Dream of You	223	1	https://api.deezer.com/album/932209631/image	https://cdnt-preview.dzcdn.net/api/1/1/d/5/a/0/d5a2aca6656cf38bbf7f26208f2b3016.mp3?hdnea=exp=1777189156~acl=/api/1/1/d/5/a/0/d5a2aca6656cf38bbf7f26208f2b3016.mp3*~data=user_id=0,application_id=42~hmac=91e94150d360d5c82cbb669873b60ee5b69257bda1ac5b635530b8a8d8a6c818	263
309	594582722	Tired	199	2	https://api.deezer.com/album/80045512/image	https://cdnt-preview.dzcdn.net/api/1/1/2/7/0/0/270ab72c68aa31397211e5e48a8dc267.mp3?hdnea=exp=1777189156~acl=/api/1/1/2/7/0/0/270ab72c68aa31397211e5e48a8dc267.mp3*~data=user_id=0,application_id=42~hmac=97a5c1b6cb573a0415af359edba2cfadb60d7ba762bdec467046d818fb60cfa9	264
310	2758747991	Take A Bite	158	1	https://api.deezer.com/album/575621241/image	https://cdnt-preview.dzcdn.net/api/1/1/4/1/4/0/414f90022bc9ca3b3394ff91018133be.mp3?hdnea=exp=1777189156~acl=/api/1/1/4/1/4/0/414f90022bc9ca3b3394ff91018133be.mp3*~data=user_id=0,application_id=42~hmac=e133e56ed780d985e4069f4b0395ecebb04ab4f88e47e282dcbb79d1000d78c0	265
311	37027991	Beauty And A Beat	228	10	https://api.deezer.com/album/3602971/image	https://cdnt-preview.dzcdn.net/api/1/1/a/1/c/0/a1c35032aab8a465a73991e05ac30db6.mp3?hdnea=exp=1777551987~acl=/api/1/1/a/1/c/0/a1c35032aab8a465a73991e05ac30db6.mp3*~data=user_id=0,application_id=42~hmac=f8f6f56a12503c6129ec28c639f6af75bed138ef8705202eb2113f423c2e0ecf	267
312	3454558661	DAISIES	176	2	https://api.deezer.com/album/786280691/image	https://cdnt-preview.dzcdn.net/api/1/1/5/c/8/0/5c8b19ee997114e357b892f062635d60.mp3?hdnea=exp=1777551987~acl=/api/1/1/5/c/8/0/5c8b19ee997114e357b892f062635d60.mp3*~data=user_id=0,application_id=42~hmac=5d37468f0d5f09935c7da10b514d3b669fe164130184d5f5e63e9e2e3622ea77	268
313	3541914121	SPEED DEMON	212	1	https://api.deezer.com/album/816518541/image	https://cdnt-preview.dzcdn.net/api/1/1/a/b/1/0/ab119e1f99c617faa905adecb4edd5db.mp3?hdnea=exp=1777551987~acl=/api/1/1/a/b/1/0/ab119e1f99c617faa905adecb4edd5db.mp3*~data=user_id=0,application_id=42~hmac=be03479ea00663f3385fc4b5751e45d2bf0f6222ff271bf3a7c9d5d430f469aa	269
314	1425844092	STAY	140	1	https://api.deezer.com/album/242430582/image	https://cdnt-preview.dzcdn.net/api/1/1/c/2/7/0/c27d817565b9df8ab6393bb8202b58b9.mp3?hdnea=exp=1777551987~acl=/api/1/1/c/2/7/0/c27d817565b9df8ab6393bb8202b58b9.mp3*~data=user_id=0,application_id=42~hmac=beda137b4e03eac1f43a7b02298310235a882311c8b0173226be133d5ad1f763	270
315	5606967	Baby	216	1	https://api.deezer.com/album/512013/image	https://cdnt-preview.dzcdn.net/api/1/1/1/3/7/0/1377b0443b2c324b239425d106ee569c.mp3?hdnea=exp=1777551987~acl=/api/1/1/1/3/7/0/1377b0443b2c324b239425d106ee569c.mp3*~data=user_id=0,application_id=42~hmac=a798f10cfc8fdf555526bdf428b8d4861c984f7fc580097bffbc77201a94c953	271
\.


--
-- Data for Name: tokenblocklist; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.tokenblocklist (id, jti, created_at) FROM stdin;
\.


--
-- Data for Name: tolisten; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public.tolisten (id, note, user_id, album_id) FROM stdin;
2	welcome to heeeeeeellllll	1	102
3	super vibey cool album	1	116
4	super vibey cool album	1	186
5	super vibey cool album	2	186
6	super vibey cool album 2к17	3	253
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: testdranik
--

COPY public."user" (id, name, email, role, password, age, gender, location) FROM stdin;
1	Ostap	ostap@gmail.com	USER	c6a20c3f56a85d86bf9b5eb3f22af278bba756f12f24b997f5459184c97440dd	16	PREFER_NOT_TO_SAY	Ukraine
2	Svyatoslav	slavik@gmail.com	USER	0534a115f2161c1c28d17a882ea86b2b95c934578535c2dbcc7fc3dd7f1de72d	18	PREFER_NOT_TO_SAY	Ukraine
3	Maksimus	max@gmail.com	USER	334282ed503f4c5d9e243cf9e6261f2e7d7e5329270c72f593c91899ae305fac	18	PREFER_NOT_TO_SAY	Kamboja
\.


--
-- Name: action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.action_id_seq', 26, true);


--
-- Name: album_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.album_id_seq', 274, true);


--
-- Name: artist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.artist_id_seq', 241, true);


--
-- Name: genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.genre_id_seq', 34, true);


--
-- Name: rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.rating_id_seq', 14, true);


--
-- Name: song_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.song_id_seq', 315, true);


--
-- Name: tokenblocklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.tokenblocklist_id_seq', 1, false);


--
-- Name: tolisten_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.tolisten_id_seq', 6, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: testdranik
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- Name: action action_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_pkey PRIMARY KEY (id);


--
-- Name: album album_dzid_key; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_dzid_key UNIQUE (dzid);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: artist artist_dzid_key; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_dzid_key UNIQUE (dzid);


--
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);


--
-- Name: artist_song_association artist_song_association_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_pkey PRIMARY KEY (artist_id, song_id);


--
-- Name: genre genre_dzid_key; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_dzid_key UNIQUE (dzid);


--
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);


--
-- Name: song song_dzid_key; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_dzid_key UNIQUE (dzid);


--
-- Name: song song_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_pkey PRIMARY KEY (id);


--
-- Name: tokenblocklist tokenblocklist_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tokenblocklist
    ADD CONSTRAINT tokenblocklist_pkey PRIMARY KEY (id);


--
-- Name: tolisten tolisten_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_pkey PRIMARY KEY (id);


--
-- Name: album_genre_association uq_album_genre; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album_genre_association
    ADD CONSTRAINT uq_album_genre PRIMARY KEY (album_id, genre_id);


--
-- Name: tolisten uq_tolisten_albumid_userid; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT uq_tolisten_albumid_userid UNIQUE (user_id, album_id);


--
-- Name: rating uq_user_album_rating; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT uq_user_album_rating UNIQUE (user_id, album_id);


--
-- Name: rating uq_user_song_rating; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT uq_user_song_rating UNIQUE (user_id, song_id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_tokenblocklist_jti; Type: INDEX; Schema: public; Owner: testdranik
--

CREATE INDEX ix_tokenblocklist_jti ON public.tokenblocklist USING btree (jti);


--
-- Name: action action_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: album album_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: album_genre_association album_genre_association_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album_genre_association
    ADD CONSTRAINT album_genre_association_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: album_genre_association album_genre_association_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.album_genre_association
    ADD CONSTRAINT album_genre_association_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genre(id);


--
-- Name: artist_song_association artist_song_association_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: artist_song_association artist_song_association_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: rating rating_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: rating rating_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: rating rating_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: song song_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: tolisten tolisten_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: tolisten tolisten_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: testdranik
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict E57nd2lWDXux37VTXf55DgOkA8P6cmZDsRZMtvqTfNl4uqeBcNOrfRpZIlSpU5z

