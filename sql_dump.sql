--
-- PostgreSQL database dump
--

\restrict hbgCwQQZ6a48qUK6lHfMhk9prZA0oRR3Uu71PK71AtI4CI4bkuGpULUPGW1EfsI

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

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
-- Name: action_name_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.action_name_enum AS ENUM (
    'ALBUM_SHOW',
    'ARTIST_SHOW',
    'ADD_TO_LISTEN',
    'RATE_ALBUM',
    'RATE_SONG'
);


ALTER TYPE public.action_name_enum OWNER TO postgres;

--
-- Name: user_action_object_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_action_object_enum AS ENUM (
    'ALBUM',
    'SONG',
    'ARTIST'
);


ALTER TYPE public.user_action_object_enum OWNER TO postgres;

--
-- Name: user_gender_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_gender_enum AS ENUM (
    'MALE',
    'FEMALE',
    'NON_BINARY',
    'PREFER_NOT_TO_SAY'
);


ALTER TYPE public.user_gender_enum OWNER TO postgres;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role_enum AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public.user_role_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action (
    id integer NOT NULL,
    name public.action_name_enum NOT NULL,
    reference_name public.user_action_object_enum NOT NULL,
    reference_id integer NOT NULL,
    counter integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.action OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_id_seq OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_id_seq OWNED BY public.action.id;


--
-- Name: album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album (
    id integer NOT NULL,
    dzid bigint NOT NULL,
    name character varying(500) NOT NULL,
    length integer,
    picture character varying NOT NULL,
    artist_id integer NOT NULL,
    ghost_songs_count integer,
    release_date date,
    release_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_album_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.album OWNER TO postgres;

--
-- Name: album_genre_association; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album_genre_association (
    album_id integer NOT NULL,
    genre_id integer NOT NULL
);


ALTER TABLE public.album_genre_association OWNER TO postgres;

--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.album_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.album_id_seq OWNER TO postgres;

--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.album_id_seq OWNED BY public.album.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: artist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist (
    id integer NOT NULL,
    dzid bigint NOT NULL,
    name character varying(100) NOT NULL,
    picture character varying NOT NULL,
    ghost_albums_count integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_artist_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.artist OWNER TO postgres;

--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artist_id_seq OWNER TO postgres;

--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artist_id_seq OWNED BY public.artist.id;


--
-- Name: artist_song_association; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_song_association (
    artist_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE public.artist_song_association OWNER TO postgres;

--
-- Name: genre; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genre (
    id integer NOT NULL,
    dzid integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.genre OWNER TO postgres;

--
-- Name: genre_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genre_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genre_id_seq OWNER TO postgres;

--
-- Name: genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genre_id_seq OWNED BY public.genre.id;


--
-- Name: rating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rating (
    id integer NOT NULL,
    score integer NOT NULL,
    description text,
    album_id integer,
    song_id integer,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_rating_score_range CHECK (((score >= 0) AND (score <= 10)))
);


ALTER TABLE public.rating OWNER TO postgres;

--
-- Name: rating_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rating_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rating_id_seq OWNER TO postgres;

--
-- Name: rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rating_id_seq OWNED BY public.rating.id;


--
-- Name: song; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.song (
    id integer NOT NULL,
    dzid bigint NOT NULL,
    name character varying(500) NOT NULL,
    length integer NOT NULL,
    song_position integer,
    picture character varying NOT NULL,
    preview character varying,
    album_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_length_value CHECK ((length > 5)),
    CONSTRAINT ck_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public.song OWNER TO postgres;

--
-- Name: song_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.song_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.song_id_seq OWNER TO postgres;

--
-- Name: song_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.song_id_seq OWNED BY public.song.id;


--
-- Name: tokenblocklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokenblocklist (
    id integer NOT NULL,
    jti character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tokenblocklist OWNER TO postgres;

--
-- Name: tokenblocklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokenblocklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tokenblocklist_id_seq OWNER TO postgres;

--
-- Name: tokenblocklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokenblocklist_id_seq OWNED BY public.tokenblocklist.id;


--
-- Name: tolisten; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tolisten (
    id integer NOT NULL,
    note character varying(300) NOT NULL,
    user_id integer NOT NULL,
    album_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    listened boolean NOT NULL
);


ALTER TABLE public.tolisten OWNER TO postgres;

--
-- Name: tolisten_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tolisten_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tolisten_id_seq OWNER TO postgres;

--
-- Name: tolisten_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tolisten_id_seq OWNED BY public.tolisten.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
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
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bio character varying(300),
    CONSTRAINT ck_user_age_range CHECK (((age >= 6) AND (age <= 119))),
    CONSTRAINT ck_user_email_form CHECK (((email)::text ~~ '%_@__%.__%'::text)),
    CONSTRAINT ck_user_location_length CHECK ((length((location)::text) > 1)),
    CONSTRAINT ck_user_name_length CHECK ((length((name)::text) > 0))
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: action id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action ALTER COLUMN id SET DEFAULT nextval('public.action_id_seq'::regclass);


--
-- Name: album id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album ALTER COLUMN id SET DEFAULT nextval('public.album_id_seq'::regclass);


--
-- Name: artist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist ALTER COLUMN id SET DEFAULT nextval('public.artist_id_seq'::regclass);


--
-- Name: genre id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre ALTER COLUMN id SET DEFAULT nextval('public.genre_id_seq'::regclass);


--
-- Name: rating id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating ALTER COLUMN id SET DEFAULT nextval('public.rating_id_seq'::regclass);


--
-- Name: song id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.song ALTER COLUMN id SET DEFAULT nextval('public.song_id_seq'::regclass);


--
-- Name: tokenblocklist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenblocklist ALTER COLUMN id SET DEFAULT nextval('public.tokenblocklist_id_seq'::regclass);


--
-- Name: tolisten id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tolisten ALTER COLUMN id SET DEFAULT nextval('public.tolisten_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.action (id, name, reference_name, reference_id, counter, user_id, created_at, updated_at) FROM stdin;
49	ALBUM_SHOW	ALBUM	191	1	5	2026-07-09 09:24:47.211436	2026-07-09 09:24:47.211436
51	ALBUM_SHOW	ALBUM	501	1	5	2026-07-09 10:02:54.038339	2026-07-09 10:02:54.038339
50	ALBUM_SHOW	ALBUM	493	4	5	2026-07-09 09:29:57.734816	2026-07-09 10:37:06.495863
72	ALBUM_SHOW	ALBUM	484	1	3	2026-07-10 10:54:17.189459	2026-07-10 10:54:17.189459
65	ALBUM_SHOW	ALBUM	187	1	3	2026-07-09 18:33:25.581837	2026-07-09 18:33:25.581837
73	ARTIST_SHOW	ARTIST	332	1	3	2026-07-10 10:54:19.387726	2026-07-10 10:54:19.387726
56	ALBUM_SHOW	ALBUM	512	3	3	2026-07-09 11:26:40.65001	2026-07-10 10:55:04.48203
125	RATE_SONG	SONG	849	1	3	2026-07-12 08:50:16.188614	2026-07-12 08:50:16.188614
115	ADD_TO_LISTEN	ALBUM	624	1	3	2026-07-11 15:28:20.076443	2026-07-11 15:28:20.076443
116	ALBUM_SHOW	ALBUM	485	1	3	2026-07-11 16:14:18.03099	2026-07-11 16:14:18.03099
62	ARTIST_SHOW	ARTIST	99	13	3	2026-07-09 18:23:24.446303	2026-07-11 16:31:53.919507
33	ALBUM_SHOW	ALBUM	151	26	3	2026-07-07 17:48:24.900629	2026-07-28 19:35:23.784653
52	ADD_TO_LISTEN	ALBUM	151	1	5	2026-07-09 10:52:29.929744	2026-07-09 10:52:29.929744
118	ADD_TO_LISTEN	ALBUM	631	1	4	2026-07-11 18:09:13.1076	2026-07-11 18:09:13.1076
74	ALBUM_SHOW	ALBUM	429	3	3	2026-07-10 11:19:31.963704	2026-07-10 11:22:36.250518
53	ALBUM_SHOW	ALBUM	186	2	5	2026-07-09 10:53:53.714464	2026-07-09 10:54:19.722122
10	RATE_SONG	SONG	175	1	1	2026-04-16 11:20:39.036394	2026-04-16 11:20:39.036394
11	ALBUM_SHOW	ALBUM	116	4	1	2026-04-17 23:42:31.290827	2026-04-17 23:42:31.290827
12	ADD_TO_LISTEN	ALBUM	116	1	1	2026-04-17 23:44:28.054028	2026-04-17 23:44:28.054028
13	RATE_ALBUM	ALBUM	116	1	1	2026-04-17 23:45:29.450497	2026-04-17 23:45:29.450497
15	RATE_SONG	SONG	190	1	1	2026-04-19 11:17:36.418336	2026-04-19 11:17:36.418336
16	ALBUM_SHOW	ALBUM	128	1	1	2026-04-22 17:15:42.237924	2026-04-22 17:15:42.237924
14	ALBUM_SHOW	ALBUM	99	2	1	2026-04-17 23:47:41.909967	2026-04-17 23:47:41.909967
17	RATE_ALBUM	ALBUM	151	1	2	2026-04-25 21:18:33.69869	2026-04-25 21:18:33.69869
18	RATE_ALBUM	ALBUM	163	1	2	2026-04-25 21:24:08.422083	2026-04-25 21:24:08.422083
19	RATE_ALBUM	ALBUM	186	1	2	2026-04-25 21:25:16.752669	2026-04-25 21:25:16.752669
20	ADD_TO_LISTEN	ALBUM	186	2	2	2026-04-25 21:25:49.55641	2026-04-25 21:25:49.55641
21	RATE_ALBUM	ALBUM	220	2	3	2026-04-26 09:59:33.095886	2026-04-26 09:59:33.095886
22	RATE_ALBUM	ALBUM	229	1	3	2026-04-26 10:01:18.064106	2026-04-26 10:01:18.064106
23	RATE_SONG	SONG	286	1	3	2026-04-26 10:03:23.867288	2026-04-26 10:03:23.867288
24	ADD_TO_LISTEN	ALBUM	253	1	3	2026-04-26 10:15:31.79332	2026-04-26 10:15:31.79332
25	RATE_SONG	SONG	304	1	3	2026-04-26 10:16:40.811852	2026-04-26 10:16:40.811852
26	RATE_ALBUM	ALBUM	269	1	3	2026-04-30 15:12:40.855365	2026-04-30 15:12:40.855365
119	RATE_SONG	SONG	1008	1	4	2026-07-11 18:09:19.643161	2026-07-11 18:09:19.643161
29	ALBUM_SHOW	ALBUM	314	1	4	2026-06-25 12:11:45.46612	2026-06-25 12:11:45.46612
30	ALBUM_SHOW	ALBUM	377	1	4	2026-06-25 12:12:42.650056	2026-06-25 12:12:42.650056
31	ALBUM_SHOW	ALBUM	387	6	4	2026-06-25 12:14:18.848686	2026-06-25 12:14:18.848686
28	ALBUM_SHOW	ALBUM	380	6	4	2026-06-25 12:07:26.474155	2026-06-25 12:07:26.474155
140	ALBUM_SHOW	ALBUM	493	2	2	2026-07-14 11:37:24.360182	2026-07-15 18:30:35.16682
34	RATE_SONG	SONG	469	1	3	2026-07-07 17:48:47.762959	2026-07-07 17:48:47.762959
107	RATE_ALBUM	ALBUM	151	1	3	2026-07-11 10:18:41.589152	2026-07-11 10:18:41.589152
36	ALBUM_SHOW	ALBUM	269	2	4	2026-07-07 18:00:57.235751	2026-07-12 08:22:38.483757
63	ARTIST_SHOW	ARTIST	186	28	3	2026-07-09 18:30:51.809014	2026-07-29 08:43:34.508842
38	ALBUM_SHOW	ALBUM	116	1	4	2026-07-08 09:27:08.543266	2026-07-08 09:27:08.543266
121	ALBUM_SHOW	ALBUM	229	2	4	2026-07-12 08:22:36.399739	2026-07-12 08:22:40.506381
41	ALBUM_SHOW	ALBUM	151	22	5	2026-07-08 10:57:28.979382	2026-07-09 11:08:51.498916
27	ARTIST_SHOW	ARTIST	242	14	4	2026-06-25 09:55:42.530384	2026-07-09 11:11:14.237307
122	ARTIST_SHOW	ARTIST	208	1	4	2026-07-12 08:22:41.730774	2026-07-12 08:22:41.730774
39	ALBUM_SHOW	ALBUM	429	1	4	2026-07-08 10:23:11.600673	2026-07-08 10:23:11.600673
37	ALBUM_SHOW	ALBUM	151	11	4	2026-07-08 09:21:24.667882	2026-07-18 12:05:17.617727
40	ADD_TO_LISTEN	ALBUM	438	1	4	2026-07-08 10:34:53.647962	2026-07-08 10:34:53.647962
42	RATE_SONG	SONG	469	1	5	2026-07-08 10:58:03.734033	2026-07-08 10:58:03.734033
55	ADD_TO_LISTEN	ALBUM	251	1	3	2026-07-09 11:24:46.753692	2026-07-09 11:24:46.753692
43	ADD_TO_LISTEN	ALBUM	466	1	5	2026-07-08 11:00:19.996126	2026-07-08 11:00:19.996126
44	ALBUM_SHOW	ALBUM	466	1	5	2026-07-08 11:11:56.186112	2026-07-08 11:11:56.186112
45	ALBUM_SHOW	ALBUM	424	1	5	2026-07-08 16:50:25.2978	2026-07-08 16:50:25.2978
120	ARTIST_SHOW	ARTIST	396	2	4	2026-07-11 18:09:24.868631	2026-07-12 08:23:05.19376
47	ALBUM_SHOW	ALBUM	429	1	5	2026-07-09 09:11:52.950375	2026-07-09 09:11:52.950375
48	ALBUM_SHOW	ALBUM	99	1	5	2026-07-09 09:12:00.09656	2026-07-09 09:12:00.09656
46	ALBUM_SHOW	ALBUM	486	3	5	2026-07-09 09:09:15.479023	2026-07-09 09:12:40.809192
35	ALBUM_SHOW	ALBUM	186	15	3	2026-07-07 17:49:28.980782	2026-07-28 19:48:22.149905
57	ADD_TO_LISTEN	ALBUM	512	1	3	2026-07-09 11:26:45.995322	2026-07-09 11:26:45.995322
117	ALBUM_SHOW	ALBUM	631	2	4	2026-07-11 18:08:37.727805	2026-07-12 08:23:15.676943
66	ALBUM_SHOW	ALBUM	488	1	3	2026-07-10 09:45:19.59355	2026-07-10 09:45:19.59355
58	RATE_SONG	SONG	231	1	3	2026-07-09 11:28:19.498012	2026-07-09 11:28:19.498012
67	ARTIST_SHOW	ARTIST	334	1	3	2026-07-10 09:45:31.041198	2026-07-10 09:45:31.041198
59	ALBUM_SHOW	ALBUM	81	1	3	2026-07-09 11:44:07.655111	2026-07-09 11:44:07.655111
108	ADD_TO_LISTEN	ALBUM	186	1	3	2026-07-11 15:21:59.347226	2026-07-11 15:21:59.347226
60	ALBUM_SHOW	ALBUM	501	1	3	2026-07-09 12:06:59.738133	2026-07-09 12:06:59.738133
61	ALBUM_SHOW	ALBUM	523	1	3	2026-07-09 12:07:27.240101	2026-07-09 12:07:27.240101
70	ADD_TO_LISTEN	ALBUM	485	1	3	2026-07-10 10:41:51.983185	2026-07-10 10:41:51.983185
109	RATE_ALBUM	ALBUM	186	1	3	2026-07-11 15:22:10.63165	2026-07-11 15:22:10.63165
126	RATE_ALBUM	ALBUM	482	1	3	2026-07-12 08:51:03.155876	2026-07-12 08:51:03.155876
110	ADD_TO_LISTEN	ALBUM	96	1	3	2026-07-11 15:23:04.878259	2026-07-11 15:23:04.878259
111	ALBUM_SHOW	ALBUM	96	1	3	2026-07-11 15:23:15.876433	2026-07-11 15:23:15.876433
112	ADD_TO_LISTEN	ALBUM	99	1	3	2026-07-11 15:23:38.200958	2026-07-11 15:23:38.200958
123	ALBUM_SHOW	ALBUM	438	3	4	2026-07-12 08:33:19.955666	2026-07-12 08:33:36.792554
71	ALBUM_SHOW	ALBUM	486	1	3	2026-07-10 10:47:35.938031	2026-07-10 10:47:35.938031
113	ALBUM_SHOW	ALBUM	99	1	3	2026-07-11 15:24:00.816009	2026-07-11 15:24:00.816009
130	RATE_ALBUM	ALBUM	190	1	3	2026-07-12 09:26:59.146165	2026-07-12 09:26:59.146165
114	ADD_TO_LISTEN	ALBUM	429	1	3	2026-07-11 15:24:17.062322	2026-07-11 15:24:17.062322
124	ARTIST_SHOW	ARTIST	286	1	4	2026-07-12 08:33:38.006313	2026-07-12 08:33:38.006313
69	ARTIST_SHOW	ARTIST	110	38	3	2026-07-10 09:45:48.708463	2026-07-10 10:53:41.615416
64	ALBUM_SHOW	ALBUM	559	2	3	2026-07-09 18:31:24.257982	2026-07-12 09:27:35.412874
127	ADD_TO_LISTEN	ALBUM	482	1	3	2026-07-12 08:51:12.879718	2026-07-12 08:51:12.879718
131	ALBUM_SHOW	ALBUM	220	2	3	2026-07-12 14:52:20.177514	2026-07-19 10:23:35.413234
128	RATE_SONG	SONG	255	1	3	2026-07-12 09:26:23.819807	2026-07-12 09:26:23.819807
68	ALBUM_SHOW	ALBUM	482	7	3	2026-07-10 09:45:47.283463	2026-07-19 10:23:32.821401
134	RATE_SONG	SONG	1088	1	2	2026-07-14 11:29:09.159607	2026-07-14 11:29:09.159607
136	RATE_ALBUM	ALBUM	190	1	2	2026-07-14 11:29:52.460321	2026-07-14 11:29:52.460321
135	ADD_TO_LISTEN	ALBUM	190	1	2	2026-07-14 11:29:35.400274	2026-07-14 11:29:35.400274
133	ALBUM_SHOW	ALBUM	190	8	2	2026-07-14 11:28:26.830191	2026-07-16 18:00:46.946484
137	ARTIST_SHOW	ARTIST	186	2	2	2026-07-14 11:30:03.884082	2026-07-14 11:31:18.601441
138	ADD_TO_LISTEN	ALBUM	731	1	2	2026-07-14 11:32:48.409141	2026-07-14 11:32:48.409141
139	ALBUM_SHOW	ALBUM	731	1	2	2026-07-14 11:33:53.441211	2026-07-14 11:33:53.441211
32	ALBUM_SHOW	ALBUM	388	3	4	2026-06-25 12:30:11.90553	2026-07-15 08:23:10.140642
142	ALBUM_SHOW	ALBUM	151	20	2	2026-07-15 08:21:48.460674	2026-07-18 11:10:34.277272
141	ALBUM_SHOW	ALBUM	186	3	2	2026-07-14 11:39:28.27395	2026-07-18 11:10:29.269762
129	ALBUM_SHOW	ALBUM	190	22	3	2026-07-12 09:26:41.995051	2026-08-07 12:23:37.74669
132	ALBUM_SHOW	ALBUM	163	2	3	2026-07-13 10:20:24.556658	2026-07-19 10:23:37.798986
54	ALBUM_SHOW	ALBUM	251	5	3	2026-07-09 11:23:11.40395	2026-07-19 10:24:02.512358
143	ALBUM_SHOW	ALBUM	163	14	2	2026-07-17 10:16:51.373998	2026-07-18 10:38:35.090503
176	RATE_SONG	SONG	231	1	2	2026-07-18 10:53:15.277162	2026-07-18 10:53:15.277162
177	RATE_SONG	SONG	469	1	2	2026-07-18 10:53:17.930636	2026-07-18 10:53:17.930636
178	ALBUM_SHOW	ALBUM	482	1	2	2026-07-18 11:10:32.314106	2026-07-18 11:10:32.314106
181	ARTIST_SHOW	ARTIST	394	1	3	2026-07-19 08:27:36.802915	2026-07-19 08:27:36.802915
180	ALBUM_SHOW	ALBUM	623	9	3	2026-07-19 08:27:27.038637	2026-07-19 08:34:29.056187
182	ALBUM_SHOW	ALBUM	181	6	3	2026-07-19 08:27:45.135049	2026-07-19 08:34:33.629116
183	ALBUM_SHOW	ALBUM	68	1	3	2026-07-19 08:34:46.43845	2026-07-19 08:34:46.43845
184	ALBUM_SHOW	ALBUM	466	1	3	2026-07-19 10:22:14.891249	2026-07-19 10:22:14.891249
185	ALBUM_SHOW	ALBUM	753	1	3	2026-07-19 10:22:31.56427	2026-07-19 10:22:31.56427
218	ADD_TO_LISTEN	ALBUM	190	1	7	2026-07-19 13:32:32.911663	2026-07-19 13:32:32.911663
219	RATE_ALBUM	ALBUM	190	1	7	2026-07-19 13:32:41.473443	2026-07-19 13:32:41.473443
220	RATE_SONG	SONG	1089	1	7	2026-07-19 13:32:48.59925	2026-07-19 13:32:48.59925
217	ALBUM_SHOW	ALBUM	190	2	7	2026-07-19 13:29:52.555709	2026-07-19 13:32:51.733003
222	ADD_TO_LISTEN	ALBUM	556	1	7	2026-07-19 13:34:34.675396	2026-07-19 13:34:34.675396
223	ALBUM_SHOW	ALBUM	269	1	7	2026-07-19 13:35:46.016447	2026-07-19 13:35:46.016447
224	ALBUM_SHOW	ALBUM	151	1	7	2026-07-19 13:36:42.576552	2026-07-19 13:36:42.576552
257	ALBUM_SHOW	ALBUM	556	1	7	2026-07-24 09:31:09.04204	2026-07-24 09:31:09.04204
258	ALBUM_SHOW	ALBUM	186	1	7	2026-07-24 13:50:16.326256	2026-07-24 13:50:16.326256
221	ARTIST_SHOW	ARTIST	186	5	7	2026-07-19 13:33:38.962089	2026-07-24 14:04:26.836712
179	ALBUM_SHOW	ALBUM	229	2	3	2026-07-18 12:01:25.983995	2026-07-24 14:44:19.003097
259	ARTIST_SHOW	ARTIST	260	3	3	2026-07-24 15:07:57.86132	2026-07-24 15:08:01.57685
260	RATE_SONG	SONG	1086	1	3	2026-08-07 12:24:38.782749	2026-08-07 12:24:38.782749
261	ADD_TO_LISTEN	ALBUM	190	1	3	2026-08-07 12:25:32.872036	2026-08-07 12:25:32.872036
262	ARTIST_SHOW	ARTIST	447	2	3	2026-08-07 12:26:51.427296	2026-08-07 12:27:26.283869
263	ALBUM_SHOW	ALBUM	814	1	3	2026-08-07 12:28:15.985418	2026-08-07 12:28:15.985418
\.


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.album (id, dzid, name, length, picture, artist_id, ghost_songs_count, release_date, release_type, created_at, updated_at) FROM stdin;
482	49722702	The Queen Is Dead (Deluxe Edition)	5969	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	110	36	2017-10-20	album	2026-07-09 09:08:32.218122	2026-07-09 09:08:32.218122
483	901479902	Live At Earls Court	4443	https://cdn-images.dzcdn.net/images/cover/171466a7e722c7d1ca0f79cad3c34e5b/1000x1000-000000-80-0-0.jpg	331	18	2005-03-29	album	2026-07-09 09:08:32.218122	2026-07-09 09:08:32.218122
484	352368357	Covers	2440	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	332	10	2003-03-24	album	2026-07-09 09:08:32.218122	2026-07-09 09:08:32.218122
485	1261476	Rank	3373	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	110	14	2001-06-26	album	2026-07-09 09:08:32.218122	2026-07-09 09:08:32.218122
486	1261474	The Queen Is Dead	2227	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	110	10	2001-06-26	album	2026-07-09 09:08:33.224867	2026-07-09 09:08:33.224867
487	1261472	The World Won't Listen	3592	https://cdn-images.dzcdn.net/images/cover/82e7aa454050e368dbb4f5b8824485a5/1000x1000-000000-80-0-0.jpg	110	18	2001-06-26	album	2026-07-09 09:08:33.224867	2026-07-09 09:08:33.224867
488	805698721	Don't Tap The Glass! (feat. Taylor & The Creative)	166	https://cdn-images.dzcdn.net/images/cover/30c4d5c8542bf7a8468bd4500035f97e/1000x1000-000000-80-0-0.jpg	334	1	2025-08-15	single	2026-07-09 09:24:43.560148	2026-07-09 09:24:43.560148
489	256273532	I Don't Wanna Talk (I Just Wanna Dance)	195	https://cdn-images.dzcdn.net/images/cover/d02cc165fcdaa7cf5b4e4ee929ab99bd/1000x1000-000000-80-0-0.jpg	335	1	2021-09-10	single	2026-07-09 09:24:43.560148	2026-07-09 09:24:43.560148
490	311160127	I Don't Wanna Talk (I Just Wanna Dance)	254	https://cdn-images.dzcdn.net/images/cover/e108a3f6bb2ca387c7ff663e18bdf473/1000x1000-000000-80-0-0.jpg	335	1	2022-04-22	single	2026-07-09 09:24:44.502386	2026-07-09 09:24:44.502386
491	393412457	Don't Tap The Glass	2870	https://cdn-images.dzcdn.net/images/cover/dbff6442240fb0ff81d4d49d271912d9/1000x1000-000000-80-0-0.jpg	336	11	2023-01-05	album	2026-07-09 09:24:44.502386	2026-07-09 09:24:44.502386
492	932066821	Don't Tap The Glass	227	https://cdn-images.dzcdn.net/images/cover/1e156b5cf927591b44dbd6cea5c91f45/1000x1000-000000-80-0-0.jpg	337	1	2026-03-10	single	2026-07-09 09:24:44.502386	2026-07-09 09:24:44.502386
493	782762881	I Love My Computer	2383	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	339	12	2025-08-08	album	2026-07-09 09:29:27.979225	2026-07-09 09:29:27.979225
494	654229061	Cum n Cocaine	731	https://cdn-images.dzcdn.net/images/cover/c37155da3fc4304e892686e482446509/1000x1000-000000-80-0-0.jpg	340	5	2021-08-02	ep	2026-07-09 09:29:27.979225	2026-07-09 09:29:27.979225
495	865336782	ipodtouch	145	https://cdn-images.dzcdn.net/images/cover/b9fa8ac8c15eac7e4aaab06692d1fe33/1000x1000-000000-80-0-0.jpg	341	1	2025-12-12	single	2026-07-09 09:29:27.979225	2026-07-09 09:29:27.979225
496	12382344	Larp of Luxury	2274	https://cdn-images.dzcdn.net/images/cover/1c2e7df59aa5f631b068d2d1c9d4af08/1000x1000-000000-80-0-0.jpg	342	9	2013-11-28	album	2026-07-09 09:29:27.979225	2026-07-09 09:29:27.979225
497	136160812	Funky Stuff	491	https://cdn-images.dzcdn.net/images/cover/af00f0b9e81a3cad8e429cdc98978a79/1000x1000-000000-80-0-0.jpg	343	2	2016-12-19	single	2026-07-09 09:29:27.979225	2026-07-09 09:29:27.979225
498	764785951	iPod Touch	196	https://cdn-images.dzcdn.net/images/cover/92868a6677823e09eac1d8ead1f5f6f1/1000x1000-000000-80-0-0.jpg	339	1	2025-06-20	single	2026-07-09 09:29:28.921832	2026-07-09 09:29:28.921832
499	936314501	iPod Touch	162	https://cdn-images.dzcdn.net/images/cover/3b1cf8b5374da65757692cba2d6c98c8/1000x1000-000000-80-0-0.jpg	344	1	2026-03-27	single	2026-07-09 09:29:28.921832	2026-07-09 09:29:28.921832
500	829700431	iPod Touch	114	https://cdn-images.dzcdn.net/images/cover/b21cfdf32b6602691b4d101a6b39f8ab/1000x1000-000000-80-0-0.jpg	345	1	2025-09-30	single	2026-07-09 09:29:28.921832	2026-07-09 09:29:28.921832
501	625285601	Diet Pepsi	169	https://cdn-images.dzcdn.net/images/cover/ee890cf16d00c684be76b0087c7108c4/1000x1000-000000-80-0-0.jpg	349	1	2024-08-09	single	2026-07-09 09:51:03.36226	2026-07-09 09:51:03.36226
502	802390131	Diet Pepsi (Live from 2025 Las Culturistas Culture Awards)	194	https://cdn-images.dzcdn.net/images/cover/de2e00a34efc9a5caf3a4d30ee40124c/1000x1000-000000-80-0-0.jpg	350	1	2025-08-10	single	2026-07-09 09:51:03.36226	2026-07-09 09:51:03.36226
503	767081171	Diet Pepsi (Live at Sirius XMU)	165	https://cdn-images.dzcdn.net/images/cover/626783ce13fd445f8eb4982965cffe5d/1000x1000-000000-80-0-0.jpg	351	1	2025-06-12	single	2026-07-09 09:51:03.36226	2026-07-09 09:51:03.36226
504	733730921	Diet Pepsi	146	https://cdn-images.dzcdn.net/images/cover/220c9d6dcd1ffcc7caa46afc9eaa30a0/1000x1000-000000-80-0-0.jpg	352	1	2025-04-18	single	2026-07-09 09:51:03.36226	2026-07-09 09:51:03.36226
505	691129891	Diet Pepsi	149	https://cdn-images.dzcdn.net/images/cover/15b46d585139fcee4f43e4647824a713/1000x1000-000000-80-0-0.jpg	353	1	2025-03-01	single	2026-07-09 09:51:03.36226	2026-07-09 09:51:03.36226
122	603134172	Mauvaise foi	2372	https://cdn-images.dzcdn.net/images/cover/3038277946aa748dccecb0d6127e4863/1000x1000-000000-80-0-0.jpg	121	15	2010-01-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
506	698422931	Memories (Slowed + Reverb) - Hey Hey	228	https://cdn-images.dzcdn.net/images/cover/a4895cf4a17637ebce090533de5555cf/1000x1000-000000-80-0-0.jpg	358	1	2024-01-30	single	2026-07-09 10:54:13.157669	2026-07-09 10:54:13.157669
507	6462673	3's	2767	https://cdn-images.dzcdn.net/images/cover/a1edc202ce46c9836275c6fc0fba300f/1000x1000-000000-80-0-0.jpg	360	12	2012-05-22	album	2026-07-09 10:54:13.157669	2026-07-09 10:54:13.157669
508	702166201	I follow Rivers (Slowed + Reverb) - I follow you deep sea baby	291	https://cdn-images.dzcdn.net/images/cover/799f5e534376f40e9faf44693bd6e71c/1000x1000-000000-80-0-0.jpg	358	1	2023-12-19	single	2026-07-09 10:54:13.157669	2026-07-09 10:54:13.157669
509	535671252	3S	145	https://cdn-images.dzcdn.net/images/cover/ce9186757113fbc1268e1f1de6c49093/1000x1000-000000-80-0-0.jpg	361	1	2024-02-09	single	2026-07-09 10:54:13.157669	2026-07-09 10:54:13.157669
510	186193272	3SEX	256	https://cdn-images.dzcdn.net/images/cover/abb3dceed04c82bb8a601d4e76c05555/1000x1000-000000-80-0-0.jpg	362	1	2020-11-25	single	2026-07-09 10:54:13.157669	2026-07-09 10:54:13.157669
446	88400112	Home Cooking	2922	https://cdn-images.dzcdn.net/images/cover/39d32df73aec3559146a8738972ca795/1000x1000-000000-80-0-0.jpg	297	13	2019-04-12	album	2026-07-08 10:38:09.629877	2026-07-09 12:14:16.818522
447	668004	Classics II	2330	https://cdn-images.dzcdn.net/images/cover/9306bf6d38f644e6fa24135fbfe70b9d/1000x1000-000000-80-0-0.jpg	298	10	2010-10-18	album	2026-07-08 10:38:09.629877	2026-07-09 12:14:16.818522
448	892838272	KEINE INTELLIGENZ	3031	https://cdn-images.dzcdn.net/images/cover/e85e00c33b370ae3768febd5be6bf188/1000x1000-000000-80-0-0.jpg	299	17	2024-04-20	album	2026-07-08 10:38:09.629877	2026-07-09 12:14:16.818522
449	938530811	CHE ME NE FACCIO DEL TEMPO	2911	https://cdn-images.dzcdn.net/images/cover/e8b20eea3bde8c2c8b75cea65845c4f9/1000x1000-000000-80-0-0.jpg	300	17	2026-03-13	album	2026-07-08 10:38:09.629877	2026-07-09 12:14:16.818522
450	880037882	Blueprint	1157	https://cdn-images.dzcdn.net/images/cover/7e3379694b033ca0f814a301b7738dd8/1000x1000-000000-80-0-0.jpg	301	5	2026-02-06	ep	2026-07-08 10:38:09.629877	2026-07-09 12:14:16.818522
565	995189631	At Heart's Creek	370	https://cdn-images.dzcdn.net/images/cover/16bc35827234279bd0b38991f7f32f52/1000x1000-000000-80-0-0.jpg	334	1	2026-05-31	single	2026-07-10 09:45:31.715358	2026-07-10 09:45:31.715358
566	805762211	Don't Tap The Glass! (feat. Taylor & The Creative)	166	https://cdn-images.dzcdn.net/images/cover/30c4d5c8542bf7a8468bd4500035f97e/1000x1000-000000-80-0-0.jpg	334	1	2025-08-16	single	2026-07-10 09:45:31.715358	2026-07-10 09:45:31.715358
572	243781	The Sound Of The Smiths	4947	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	110	25	2008-11-10	album	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
575	1377236	The Sound of the Smiths (2008 Remaster)	4896	https://cdn-images.dzcdn.net/images/cover/a7b1d60a817a97e7d7d389172fb3b4ac/1000x1000-000000-80-0-0.jpg	110	26	2008-11-10	album	2026-07-10 09:45:53.549279	2026-07-10 09:45:53.549279
568	1260614	Complete	6375	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	110	106	2001-06-26	album	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
570	1261475	Strangeways, Here We Come	2172	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	110	10	2001-06-26	album	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
567	1261478	Louder Than Bombs	4382	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	110	24	2001-06-26	album	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
569	1261477	Meat Is Murder	2389	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	110	9	2001-06-26	album	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
571	1379069	Meat Is Murder	2793	https://cdn-images.dzcdn.net/images/cover/5fe513cbcd62d69e2d0868ee0e3186e2/1000x1000-000000-80-0-0.jpg	110	10	2005-02-08	album	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
574	48679742	I Know It's Over (Demo)	348	https://cdn-images.dzcdn.net/images/cover/7802a7611d2128aeecdd3087d720d845/1000x1000-000000-80-0-0.jpg	110	1	2017-10-06	single	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
576	46914622	Rubber Ring / What She Said / Rubber Ring (Live in Boston)	257	https://cdn-images.dzcdn.net/images/cover/7802a7611d2128aeecdd3087d720d845/1000x1000-000000-80-0-0.jpg	110	1	2017-09-08	single	2026-07-10 09:45:53.549279	2026-07-10 09:45:53.549279
573	44414471	There Is a Light That Never Goes Out (Take 1)	265	https://cdn-images.dzcdn.net/images/cover/7802a7611d2128aeecdd3087d720d845/1000x1000-000000-80-0-0.jpg	110	1	1986-06-16	single	2026-07-10 09:45:51.672978	2026-07-10 09:45:53.549279
579	342872	Best Of The Bands	\N	https://cdn-images.dzcdn.net/images/cover/6d0e74c185ccde6f06c0279d29e04bf4/1000x1000-000000-80-0-0.jpg	332	\N	\N	\N	2026-07-10 10:54:19.951008	2026-07-10 10:54:19.951008
582	938269461	Placebo RE:CREATED	4567	https://cdn-images.dzcdn.net/images/cover/6b2c55e6920b7d4f35e24d52ae3c6afe/1000x1000-000000-80-0-0.jpg	332	17	2026-06-19	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
583	516185282	Collapse Into Never - Live In Europe 2023	5512	https://cdn-images.dzcdn.net/images/cover/568ad188938c5ca2a871ff4bfdc90647/1000x1000-000000-80-0-0.jpg	332	19	2023-12-15	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
584	319040377	Never Let Me Go	3464	https://cdn-images.dzcdn.net/images/cover/44c798ed778ee20ee4bb7b1fc8fd8bfc/1000x1000-000000-80-0-0.jpg	332	13	2022-03-25	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
585	353514697	A Place for Us to Dream	5668	https://cdn-images.dzcdn.net/images/cover/8f26abae956cfca3e268b26ac7c1e285/1000x1000-000000-80-0-0.jpg	332	36	2016-10-07	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
586	353509447	Meds: B-Sides	4016	https://cdn-images.dzcdn.net/images/cover/4ee846ae6fef43ab941e634905e4185b/1000x1000-000000-80-0-0.jpg	332	13	2016-04-08	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
587	351948877	Sleeping With Ghosts: B-Sides	2992	https://cdn-images.dzcdn.net/images/cover/d6e44a8d274a5850d91951df7728f7e3/1000x1000-000000-80-0-0.jpg	332	13	2016-02-19	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
588	351942847	Black Market Music: B-Sides	3345	https://cdn-images.dzcdn.net/images/cover/1f5bcded04b885723c3e762a0d21ce1c/1000x1000-000000-80-0-0.jpg	332	11	2015-11-27	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
589	348437547	Placebo: B-Sides	3874	https://cdn-images.dzcdn.net/images/cover/fc545e077f86576427e9516963e8d55e/1000x1000-000000-80-0-0.jpg	332	17	2015-07-31	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
581	348311007	Loud Like Love	2840	https://cdn-images.dzcdn.net/images/cover/863af1f70c109aa39b20dee2453a5211/1000x1000-000000-80-0-0.jpg	332	10	2013-09-13	album	2026-07-10 10:54:19.951008	2026-07-10 10:54:23.221083
590	353490757	Battle for the Sun	3124	https://cdn-images.dzcdn.net/images/cover/bd4f4d3e6cd246e0547fcc2ae75acf8b/1000x1000-000000-80-0-0.jpg	332	13	2009-06-09	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
580	352367877	Meds	2877	https://cdn-images.dzcdn.net/images/cover/daa67f6a512718bad66e2986ff40843e/1000x1000-000000-80-0-0.jpg	332	13	2006-03-13	album	2026-07-10 10:54:19.951008	2026-07-10 10:54:23.221083
451	648751121	Meditation 66	8337	https://cdn-images.dzcdn.net/images/cover/6ebbc929301ee29121e2be57565e2aea/1000x1000-000000-80-0-0.jpg	307	23	2024-10-11	album	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
452	1002600221	Twenty One	2636	https://cdn-images.dzcdn.net/images/cover/021770bfdd65ae5978680a8e3b9e8899/1000x1000-000000-80-0-0.jpg	308	21	2026-06-26	album	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
453	75624372	Amir	3065	https://cdn-images.dzcdn.net/images/cover/0ae2f2aeb34757d49a2edea516ee8153/1000x1000-000000-80-0-0.jpg	309	12	2018-10-19	album	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
454	272967532	Habibi (Albanian Remix)	129	https://cdn-images.dzcdn.net/images/cover/744ab63244c3678e7be35ca5fc31ff16/1000x1000-000000-80-0-0.jpg	310	1	2021-11-19	single	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
455	920955161	habibi	576	https://cdn-images.dzcdn.net/images/cover/c543ae5c0979b854c8bc7e9a93945f14/1000x1000-000000-80-0-0.jpg	311	6	2026-02-27	ep	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
456	324514947	Свой дом	211	https://cdn-images.dzcdn.net/images/cover/7a2028360db83db9c384a0b9317a2126/1000x1000-000000-80-0-0.jpg	313	1	2022-06-04	single	2026-07-08 10:58:50.044311	2026-07-08 10:58:50.044311
457	86872402	Малый повзрослел, Ч. 2	1521	https://cdn-images.dzcdn.net/images/cover/23459a8b1f40c4fadd02734792eb3bdc/1000x1000-000000-80-0-0.jpg	313	7	2017-10-27	album	2026-07-08 10:58:50.044311	2026-07-08 10:58:50.044311
458	86872812	Жить в кайф	3847	https://cdn-images.dzcdn.net/images/cover/db13a4fa1877ad1c2837413446c257da/1000x1000-000000-80-0-0.jpg	313	17	2013-10-21	album	2026-07-08 10:58:50.044311	2026-07-08 10:58:50.044311
459	89276792	Животный мир	3633	https://cdn-images.dzcdn.net/images/cover/7b07f38b90fa47bf16b73c0fe603c48c/1000x1000-000000-80-0-0.jpg	313	18	2013-01-15	album	2026-07-08 10:58:50.044311	2026-07-08 10:58:50.044311
460	983078781	Что ты несёшь	177	https://cdn-images.dzcdn.net/images/cover/34419c4038eed93ff8308405bf9a0305/1000x1000-000000-80-0-0.jpg	313	1	2026-05-15	single	2026-07-08 10:58:50.044311	2026-07-08 10:58:50.044311
480	477526445	Зорепад	1906	https://cdn-images.dzcdn.net/images/cover/8d9b2956e446df3f7a8c8e5475face2e/1000x1000-000000-80-0-0.jpg	312	10	2023-09-08	album	2026-07-08 10:59:51.221933	2026-07-08 10:59:51.221933
481	717826851	Stomach Butterflies	171	https://cdn-images.dzcdn.net/images/cover/b1ff8c9274872a50dc389cd3ba6fa778/1000x1000-000000-80-0-0.jpg	312	1	2025-03-14	single	2026-07-08 10:59:51.221933	2026-07-08 10:59:51.221933
511	806692861	A Matter of Time	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	242	\N	\N	\N	2026-07-09 11:11:16.512598	2026-07-09 11:11:16.512598
384	842075532	A Very Laufey Holiday	1141	https://cdn-images.dzcdn.net/images/cover/45ad16772d73fe7c97f977f6ca0c458f/1000x1000-000000-80-0-0.jpg	242	7	2025-11-05	ep	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
375	655451281	A Very Laufey Holiday	792	https://cdn-images.dzcdn.net/images/cover/0706de5a7d9c3ceacf17ccb31091ae1f/1000x1000-000000-80-0-0.jpg	242	5	2024-11-01	ep	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
382	360142137	Typical of Me EP	1258	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	242	7	2021-04-30	ep	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
378	908017202	How I Get	219	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	242	1	2026-02-25	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
372	790463031	Snow White	193	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	242	1	2025-08-07	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
376	747351701	Tough Luck	192	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	242	1	2025-05-15	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
385	612127642	Where or When	203	https://cdn-images.dzcdn.net/images/cover/bded88a124732a9c8ea77cdfef7439c6/1000x1000-000000-80-0-0.jpg	242	1	2024-07-19	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
383	508270081	Christmas With You	424	https://cdn-images.dzcdn.net/images/cover/bb43aa3eefb87cbf692c56561d215fb5/1000x1000-000000-80-0-0.jpg	242	2	2023-11-10	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
373	496608861	A Night To Remember	233	https://cdn-images.dzcdn.net/images/cover/fe4b7355b4cc565a34d59fe67211dfa0/1000x1000-000000-80-0-0.jpg	242	1	2023-10-20	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
381	450349585	Bewitched	246	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	242	1	2023-07-26	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
371	344145527	Let You Break My Heart Again	269	https://cdn-images.dzcdn.net/images/cover/9825bb50e26e8daae1ba75b7f7a17489/1000x1000-000000-80-0-0.jpg	242	1	2021-08-13	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
390	343905707	Someone New	198	https://cdn-images.dzcdn.net/images/cover/0ef9646a87ab053ed8fd9f9de174183d/1000x1000-000000-80-0-0.jpg	242	1	2020-05-25	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
512	752021091	Тільки мрії	171	https://cdn-images.dzcdn.net/images/cover/66d0fe79881ee5bd4b59e37f288e1646/1000x1000-000000-80-0-0.jpg	368	1	2025-05-16	single	2026-07-09 11:26:17.846712	2026-07-09 11:26:17.846712
513	92982582	Ронім	2460	https://cdn-images.dzcdn.net/images/cover/a7832c3d30b1b9a4190821c83abafb34/1000x1000-000000-80-0-0.jpg	369	13	2019-04-06	album	2026-07-09 11:26:17.846712	2026-07-09 11:26:17.846712
514	613225632	Чому ти тільки в мріях	145	https://cdn-images.dzcdn.net/images/cover/5b11cc14cbe6b9d0c9617296a8d136b6/1000x1000-000000-80-0-0.jpg	370	1	2024-07-09	single	2026-07-09 11:26:17.846712	2026-07-09 11:26:17.846712
515	930616991	Я охороняю твій сон	557	https://cdn-images.dzcdn.net/images/cover/211e20b8cb0414367b975b38f31911a9/1000x1000-000000-80-0-0.jpg	371	3	2026-03-02	single	2026-07-09 11:26:17.846712	2026-07-09 11:26:17.846712
516	1166556	Suck It and See	2404	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	99	12	2011-06-06	album	2026-07-09 11:27:38.9605	2026-07-09 11:27:38.9605
521	763519501	Fame is a Gun	183	https://cdn-images.dzcdn.net/images/cover/5f8734a22538b6cc1312491b3c9b586d/1000x1000-000000-80-0-0.jpg	349	1	2025-05-30	single	2026-07-09 12:07:25.208246	2026-07-09 12:07:25.208246
522	742955041	Headphones On	240	https://cdn-images.dzcdn.net/images/cover/b41ebd8d73d8de9d58df3caef10625fe/1000x1000-000000-80-0-0.jpg	349	1	2025-04-18	single	2026-07-09 12:07:25.208246	2026-07-09 12:07:25.208246
523	766908331	Addison	2010	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	349	12	2025-06-06	album	2026-07-09 12:07:25.208246	2026-07-09 12:07:25.208246
524	660083811	Aquamarine	163	https://cdn-images.dzcdn.net/images/cover/8db5fe3314c1b8fa9510a7d3eaa5f778/1000x1000-000000-80-0-0.jpg	349	1	2024-10-25	single	2026-07-09 12:07:25.208246	2026-07-09 12:07:25.208246
461	872772572	Шарики	2946	https://cdn-images.dzcdn.net/images/cover/5ac68130062fd4f563ea96305f5f769e/1000x1000-000000-80-0-0.jpg	317	13	2011-05-27	album	2026-07-08 10:58:50.397115	2026-07-08 10:58:50.397115
462	397062147	Хочу чтоб были все друзья	5078	https://cdn-images.dzcdn.net/images/cover/01819cd885eafec993bcaf4aafa26f3a/1000x1000-000000-80-0-0.jpg	317	23	2019-01-23	album	2026-07-08 10:58:50.397115	2026-07-08 10:58:50.397115
463	86334272	Мир твоими глазами	240	https://cdn-images.dzcdn.net/images/cover/805ce865a4c43717a25bfda7bfeabaf7/1000x1000-000000-80-0-0.jpg	317	1	2012-09-01	single	2026-07-08 10:58:50.397115	2026-07-08 10:58:50.397115
464	82498712	Лучше, чем вчера	3966	https://cdn-images.dzcdn.net/images/cover/d16605c07b5b532a2490e70870ecc576/1000x1000-000000-80-0-0.jpg	318	17	2018-12-25	album	2026-07-08 10:58:50.397115	2026-07-08 10:58:50.397115
470	1510636	To The Maxximum	3859	https://cdn-images.dzcdn.net/images/cover/f49a4b819f2c8653cf2a96e4bf419d1e/1000x1000-000000-80-0-0.jpg	319	15	2010-06-29	album	2026-07-08 10:58:56.651022	2026-07-08 10:58:56.651022
471	104759722	Ma Chérie	886	https://cdn-images.dzcdn.net/images/cover/fef344675f60f7357b328fc6f43bb5eb/1000x1000-000000-80-0-0.jpg	320	4	2011-10-28	ep	2026-07-08 10:58:56.651022	2026-07-08 10:58:56.651022
472	946624391	Freaky 1	232	https://cdn-images.dzcdn.net/images/cover/3165968b80c20fe612bc5f361e5e7fa5/1000x1000-000000-80-0-0.jpg	321	1	2026-04-10	single	2026-07-08 10:58:56.651022	2026-07-08 10:58:56.651022
473	982075481	Kame	144	https://cdn-images.dzcdn.net/images/cover/b6d1a93857fe81f962026239de5c83a3/1000x1000-000000-80-0-0.jpg	322	1	2026-06-05	single	2026-07-08 10:58:56.651022	2026-07-08 10:58:56.651022
474	63095522	The Blue Notebooks (15 Years)	4280	https://cdn-images.dzcdn.net/images/cover/ed07053951a44ce34a5ca9c61a2d680f/1000x1000-000000-80-0-0.jpg	323	18	2018-05-11	album	2026-07-08 10:58:56.651022	2026-07-08 10:58:56.651022
517	989437791	Save Yourself, I'll Hold Them Back / S/C/A/R/E/C/R/O/W / Summertime	744	https://cdn-images.dzcdn.net/images/cover/d841606fe5331765b5305ea497e2e35f/1000x1000-000000-80-0-0.jpg	7	3	2026-05-29	single	2026-07-09 11:44:00.638071	2026-07-09 11:44:00.638071
518	81797	The Black Parade	3111	https://cdn-images.dzcdn.net/images/cover/0f23ab7de2b53c5298044ef1de148c50/1000x1000-000000-80-0-0.jpg	7	14	2006-10-23	album	2026-07-09 11:44:00.638071	2026-07-09 11:44:00.638071
519	712492	Danger Days: The True Lives of the Fabulous Killjoys	3236	https://cdn-images.dzcdn.net/images/cover/44c297f29b81346405a58f4e2df19f14/1000x1000-000000-80-0-0.jpg	7	15	2010-11-05	album	2026-07-09 11:44:01.587696	2026-07-09 11:44:01.587696
520	14111848	I Brought You My Bullets, You Brought Me Your Love	2452	https://cdn-images.dzcdn.net/images/cover/dafef999cc8651971389bedbd79643b8/1000x1000-000000-80-0-0.jpg	7	11	2006-07-18	album	2026-07-09 11:44:01.587696	2026-07-09 11:44:01.587696
429	6899610	AM	2504	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	99	12	2013-09-06	album	2026-07-08 10:22:55.170661	2026-07-09 12:14:16.818522
430	401361	Humbug	2355	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	99	10	2009-08-20	album	2026-07-08 10:22:55.895955	2026-07-09 12:14:16.818522
431	63203772	Tranquility Base Hotel & Casino	2451	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	99	11	2018-05-12	album	2026-07-08 10:22:55.895955	2026-07-09 12:14:16.818522
432	344968797	Steve Lacy's Demo	810	https://cdn-images.dzcdn.net/images/cover/7514781a2e26062a0edd8ef66c52d768/1000x1000-000000-80-0-0.jpg	97	6	2017-02-24	ep	2026-07-08 10:23:28.916549	2026-07-09 12:14:16.818522
433	333896087	Gemini Rights	2101	https://cdn-images.dzcdn.net/images/cover/3b60918205a5bb30e2b2427714ec3162/1000x1000-000000-80-0-0.jpg	97	10	2022-07-15	album	2026-07-08 10:23:28.916549	2026-07-09 12:14:16.818522
434	1014380601	is it cool? (feat. SZA)	174	https://cdn-images.dzcdn.net/images/cover/c64458bda012cdf305dc92a07626a51d/1000x1000-000000-80-0-0.jpg	97	1	2026-06-26	single	2026-07-08 10:23:28.916549	2026-07-09 12:14:16.818522
435	995998291	the feeling	275	https://cdn-images.dzcdn.net/images/cover/c64458bda012cdf305dc92a07626a51d/1000x1000-000000-80-0-0.jpg	97	1	2026-06-05	single	2026-07-08 10:23:28.916549	2026-07-09 12:14:16.818522
436	162269762	Live Without Your Love (with Steve Lacy)	205	https://cdn-images.dzcdn.net/images/cover/7080259274eaa1ab0348d8f345152d27/1000x1000-000000-80-0-0.jpg	280	1	2020-07-16	single	2026-07-08 10:23:28.916549	2026-07-09 12:14:16.818522
437	12047958	Let It Be (Remastered)	2095	https://cdn-images.dzcdn.net/images/cover/fcf05300b7c17ec77a6d01028a4bef61/1000x1000-000000-80-0-0.jpg	286	12	2015-12-24	album	2026-07-08 10:34:50.14869	2026-07-09 12:14:16.818522
438	12047952	Abbey Road (Remastered)	2832	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	286	17	2015-12-24	album	2026-07-08 10:34:50.14869	2026-07-09 12:14:16.818522
439	12047950	A Hard Day's Night (Remastered)	1794	https://cdn-images.dzcdn.net/images/cover/7d1c6019481f5b2b2a6e5de1ee57425c/1000x1000-000000-80-0-0.jpg	286	13	2015-12-24	album	2026-07-08 10:34:50.14869	2026-07-09 12:14:16.818522
440	12047956	1 (Remastered)	4278	https://cdn-images.dzcdn.net/images/cover/c65b3bd84e81056e060be144381c06c8/1000x1000-000000-80-0-0.jpg	286	27	2015-12-24	album	2026-07-08 10:34:50.14869	2026-07-09 12:14:16.818522
441	507149371	Now And Then	391	https://cdn-images.dzcdn.net/images/cover/120998ec2b30b9e11c15092b16ff242a/1000x1000-000000-80-0-0.jpg	286	2	2023-11-02	single	2026-07-08 10:34:50.14869	2026-07-09 12:14:16.818522
442	12047948	Revolver (Remastered)	2062	https://cdn-images.dzcdn.net/images/cover/6e1e24a3e4311371abd2c888b1f0e13e/1000x1000-000000-80-0-0.jpg	286	14	2015-12-24	album	2026-07-08 10:34:51.064752	2026-07-09 12:14:16.818522
443	12047934	The Beatles (Remastered)	4388	https://cdn-images.dzcdn.net/images/cover/f8b236243adae6bc187d27157bc61ae9/1000x1000-000000-80-0-0.jpg	286	30	2015-12-24	album	2026-07-08 10:34:51.064752	2026-07-09 12:14:16.818522
444	12047960	Sgt. Pepper's Lonely Hearts Club Band (Remastered)	2390	https://cdn-images.dzcdn.net/images/cover/4fcb73352b17d47429a273c5112632b0/1000x1000-000000-80-0-0.jpg	286	13	2015-12-24	album	2026-07-08 10:34:51.064752	2026-07-09 12:14:16.818522
445	664237	Imagine	2365	https://cdn-images.dzcdn.net/images/cover/2675a9277dfabb74c32b7a3b2c9b0170/1000x1000-000000-80-0-0.jpg	291	10	2010-10-01	album	2026-07-08 10:37:45.108846	2026-07-09 12:14:16.818522
531	7071805	When The Sun Goes Down	\N	https://cdn-images.dzcdn.net/images/cover/531dab0d0da6394a148721808dee94a8/1000x1000-000000-80-0-0.jpg	99	\N	\N	\N	2026-07-09 18:23:27.168853	2026-07-09 18:23:27.168853
465	875169612	Не складається	211	https://cdn-images.dzcdn.net/images/cover/cf6f0cc4578d0fcd9d075d32a328b2fc/1000x1000-000000-80-0-0.jpg	312	1	2025-12-12	single	2026-07-08 10:58:50.464053	2026-07-08 10:58:50.464053
466	996332321	Кольє	201	https://cdn-images.dzcdn.net/images/cover/31f8c9a7b27f75e151ce453b9842f2c2/1000x1000-000000-80-0-0.jpg	312	1	2026-06-19	single	2026-07-08 10:58:50.464053	2026-07-08 10:58:50.464053
467	981893091	Людина для мене	267	https://cdn-images.dzcdn.net/images/cover/20fb5b4abb4e3632d56d69282bca07f4/1000x1000-000000-80-0-0.jpg	312	1	2026-05-22	single	2026-07-08 10:58:50.464053	2026-07-08 10:58:50.464053
468	906787212	Закоханий	228	https://cdn-images.dzcdn.net/images/cover/5e8e59954ce49377da69288dcf9cd4e8/1000x1000-000000-80-0-0.jpg	312	1	2026-02-06	single	2026-07-08 10:58:50.464053	2026-07-08 10:58:50.464053
469	855976352	Колишній	220	https://cdn-images.dzcdn.net/images/cover/5d1c7b5d62fa0da3beaedbbf36cdf29f/1000x1000-000000-80-0-0.jpg	312	1	2025-11-21	single	2026-07-08 10:58:50.464053	2026-07-08 10:58:50.464053
475	286603762	Ultima Botella (feat. Lenmelody & Max Agende)	262	https://cdn-images.dzcdn.net/images/cover/bbc9aac411448b936e19a268d28bc217/1000x1000-000000-80-0-0.jpg	329	1	2022-01-21	single	2026-07-08 10:59:49.996902	2026-07-08 10:59:49.996902
476	885090492	Wherever You Go	183	https://cdn-images.dzcdn.net/images/cover/1a8ac1cfdc24f8d87cbe46498bdd2ef7/1000x1000-000000-80-0-0.jpg	326	1	2026-01-02	single	2026-07-08 10:59:49.996902	2026-07-08 10:59:49.996902
477	846884342	The Thing I Love	172	https://cdn-images.dzcdn.net/images/cover/1b6ab9a23f2d3804e8034966e7aa0bc0/1000x1000-000000-80-0-0.jpg	330	1	2025-11-14	single	2026-07-08 10:59:49.996902	2026-07-08 10:59:49.996902
478	528085782	come home	146	https://cdn-images.dzcdn.net/images/cover/aa75eb1c27af65cf0eaf72647fa1a3b1/1000x1000-000000-80-0-0.jpg	326	1	2023-12-27	single	2026-07-08 10:59:49.996902	2026-07-08 10:59:49.996902
479	835425272	Everywhere	199	https://cdn-images.dzcdn.net/images/cover/31d9e4d4bf3baa6e77b700d6e18a7b7d/1000x1000-000000-80-0-0.jpg	326	1	2025-10-17	single	2026-07-08 10:59:49.996902	2026-07-08 10:59:49.996902
529	364187517	The Car	2238	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	99	10	2022-10-21	album	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
535	181946162	Live at the Royal Albert Hall	5167	https://cdn-images.dzcdn.net/images/cover/aa8ea17eb50583c3ee24e3989385f963/1000x1000-000000-80-0-0.jpg	99	20	2020-12-04	album	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
527	426674	Who The F*** Are Arctic Monkeys?	1133	https://cdn-images.dzcdn.net/images/cover/0aa4d11b329649549d792124918b9517/1000x1000-000000-80-0-0.jpg	99	5	2006-05-20	ep	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
525	900672512	Opening Night	259	https://cdn-images.dzcdn.net/images/cover/ee987bc5ae84a3e3d6143db84e91c0de/1000x1000-000000-80-0-0.jpg	99	1	2026-01-22	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
541	364811007	I Ain't Quite Where I Think I Am	746	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	99	3	2022-10-18	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
542	360480597	Body Paint	555	https://cdn-images.dzcdn.net/images/cover/7dba50e64f2563331d370c4e30020ca8/1000x1000-000000-80-0-0.jpg	99	2	2022-09-29	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
543	350385747	There’d Better Be A Mirrorball	265	https://cdn-images.dzcdn.net/images/cover/9dc5886f76c1627a3c6a84868dd14b87/1000x1000-000000-80-0-0.jpg	99	1	2022-08-30	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
544	78773022	Tranquility Base Hotel & Casino	432	https://cdn-images.dzcdn.net/images/cover/b9159a6f9254e316c34fccc5cd3fcd59/1000x1000-000000-80-0-0.jpg	99	2	2018-05-02	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
534	7175532	One For The Road	388	https://cdn-images.dzcdn.net/images/cover/f342d00b4350d8eb28c582160b0b03d0/1000x1000-000000-80-0-0.jpg	99	2	2013-12-09	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
528	6884910	Why'd You Only Call Me When You're High?	352	https://cdn-images.dzcdn.net/images/cover/3426755cf672f3237a877f19f693a564/1000x1000-000000-80-0-0.jpg	99	2	2013-09-02	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
545	6785154	Do I Wanna Know?	419	https://cdn-images.dzcdn.net/images/cover/d959ffc5b586e7f7591b1c06abd440d5/1000x1000-000000-80-0-0.jpg	99	2	2013-07-18	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
539	1714681	R U Mine? / Electricity	381	https://cdn-images.dzcdn.net/images/cover/fc5f8a3e97f5fd7d1bac1cd68bedfca6/1000x1000-000000-80-0-0.jpg	99	2	2012-04-23	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
546	1420881	Black Treacle	423	https://cdn-images.dzcdn.net/images/cover/e7319b7ee7d2d90051d36a787c2be610/1000x1000-000000-80-0-0.jpg	99	2	2012-01-23	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
547	1296195	Suck It and See	422	https://cdn-images.dzcdn.net/images/cover/cf4a51018668ebba740a3b32ec301f14/1000x1000-000000-80-0-0.jpg	99	2	2011-10-31	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
548	1209800	The Hellcat Spangled Shalalala	371	https://cdn-images.dzcdn.net/images/cover/4c940e0f0db394b5afcfc5a77016d058/1000x1000-000000-80-0-0.jpg	99	2	2011-08-15	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
549	1581668	Don't Sit Down 'Cause I've Moved Your Chair	495	https://cdn-images.dzcdn.net/images/cover/52c3995278bad1cac2cbc9e5111c13c4/1000x1000-000000-80-0-0.jpg	99	3	2011-05-30	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
550	1028602	Don't Sit Down 'Cause I've Moved Your Chair	183	https://cdn-images.dzcdn.net/images/cover/51a6210d8f4d0a7d14e35f54bb9b87f9/1000x1000-000000-80-0-0.jpg	99	1	2011-04-12	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
536	509021	My Propeller	870	https://cdn-images.dzcdn.net/images/cover/aa5d463f4fa6c6bd3de44553d3b11ca4/1000x1000-000000-80-0-0.jpg	99	4	2010-03-22	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
551	426665	Cornerstone	197	https://cdn-images.dzcdn.net/images/cover/ac0fe55b6fa5545a7acafdf720f56ef7/1000x1000-000000-80-0-0.jpg	99	1	2009-11-16	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
540	426666	Cornerstone	731	https://cdn-images.dzcdn.net/images/cover/521f322a4b76c550bd1b12d64a8b1066/1000x1000-000000-80-0-0.jpg	99	4	2009-11-17	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
537	426667	Crying Lightning	572	https://cdn-images.dzcdn.net/images/cover/b881de6a063710bf0f376754ab6abc58/1000x1000-000000-80-0-0.jpg	99	3	2009-08-16	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
552	426668	Crying Lightning	222	https://cdn-images.dzcdn.net/images/cover/e3a08509e9e1157be75f279383a05b83/1000x1000-000000-80-0-0.jpg	99	1	2009-07-13	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
553	426669	Teddy Picker	609	https://cdn-images.dzcdn.net/images/cover/467c8b3dfbed0e2cab6f803cdb202b94/1000x1000-000000-80-0-0.jpg	99	4	2007-12-01	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
530	426670	Fluorescent Adolescent	715	https://cdn-images.dzcdn.net/images/cover/5f5beea1c209a589796b81dd0d8f86dc/1000x1000-000000-80-0-0.jpg	99	4	2007-07-08	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
554	426671	Da Frame 2R / Matador	440	https://cdn-images.dzcdn.net/images/cover/52a7f813155f6c27de35dd306fc57047/1000x1000-000000-80-0-0.jpg	99	2	2007-06-18	single	2026-07-09 18:23:30.338365	2026-07-09 18:23:30.338365
25	222850892	Dear Wormwood	2342	https://cdn-images.dzcdn.net/images/cover/ed02c86f4af4ba017b30ff2f210656a7/1000x1000-000000-80-0-0.jpg	26	13	2015-10-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
26	394743357	The Death We Seek	2389	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	8	10	2023-05-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
27	137306592	The Way It Ends	2325	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	8	11	2020-06-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
28	831248571	All That Follows	1199	https://cdn-images.dzcdn.net/images/cover/ba142c155764fa3b9cc52e1be7e43d47/1000x1000-000000-80-0-0.jpg	8	5	2025-10-31	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
29	10709540	Currents	3064	https://cdn-images.dzcdn.net/images/cover/de5b9b704cd4ec36f8bf49beb3e17ba2/1000x1000-000000-80-0-0.jpg	13	13	2015-07-17	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
30	92438682	The Place I Feel Safest	3018	https://cdn-images.dzcdn.net/images/cover/3e917ac7780ca460f9bc875ba86d6a3c/1000x1000-000000-80-0-0.jpg	8	13	2017-06-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
31	90903372	The Place I Feel Safest (Instrumental)	3018	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	8	13	2018-05-04	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
32	85335372	I Let the Devil In	2320	https://cdn-images.dzcdn.net/images/cover/60eb212d82b36da0f4eacaaa84205e3b/1000x1000-000000-80-0-0.jpg	8	10	2018-12-14	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
33	7347091	Victimized	1152	https://cdn-images.dzcdn.net/images/cover/ff50e89de587f65543974ea3aabc7a41/1000x1000-000000-80-0-0.jpg	8	5	2013-01-20	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
34	9492170	Life // Lost	1796	https://cdn-images.dzcdn.net/images/cover/0ac01f46a97e57ef66f3bc27a1040504/1000x1000-000000-80-0-0.jpg	8	8	2015-02-01	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
35	809362641	bad luck	252	https://cdn-images.dzcdn.net/images/cover/dfa4490a0141a17cf9cd4e57a1e81193/1000x1000-000000-80-0-0.jpg	19	1	2025-09-10	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
36	775053491	It Only Gets Darker	271	https://cdn-images.dzcdn.net/images/cover/b26006e15c94930b1c75051dbcb4642e/1000x1000-000000-80-0-0.jpg	8	1	2025-07-18	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
37	51431732	Currents B-Sides & Remixes	1685	https://cdn-images.dzcdn.net/images/cover/4d9b3ad6489b071bb1aa6d959b1dba53/1000x1000-000000-80-0-0.jpg	13	5	2017-11-17	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
38	952353611	Roofless Records For Drop Tops: Disc 1	1849	https://cdn-images.dzcdn.net/images/cover/55badb8fd3a41b1fdf6bc56a934098fd/1000x1000-000000-80-0-0.jpg	25	10	2026-04-02	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
39	919938201	Currents on Audiotree Live	1456	https://cdn-images.dzcdn.net/images/cover/cbbcea3697c146cd4bd3a43ec339044e/1000x1000-000000-80-0-0.jpg	9	6	2026-03-11	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
40	372800377	Vengeance	475	https://cdn-images.dzcdn.net/images/cover/f143c6a4f1885b34bcd5a65e84db8500/1000x1000-000000-80-0-0.jpg	8	2	2022-11-25	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
41	596470922	Currents	3387	https://cdn-images.dzcdn.net/images/cover/023be9bbed739c1e26ccd6da62beb51a/1000x1000-000000-80-0-0.jpg	32	9	2018-02-23	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
42	223848222	Currents	207	https://cdn-images.dzcdn.net/images/cover/1ba9abe98f968dfaeb702ad29c29f627/1000x1000-000000-80-0-0.jpg	33	1	2021-05-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
43	216049622	The Way It Ends (Instrumental)	2332	https://cdn-images.dzcdn.net/images/cover/f8b403a673e0d7ed13d2b8aff7b82451/1000x1000-000000-80-0-0.jpg	8	11	2020-06-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
44	9414152	Currents	1485	https://cdn-images.dzcdn.net/images/cover/680202af3653917ed1b75719f22afb2e/1000x1000-000000-80-0-0.jpg	34	7	2010-03-09	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
45	345700437	Currents	161	https://cdn-images.dzcdn.net/images/cover/0e4a5b957b8e02b639c2d7cc46d75543/1000x1000-000000-80-0-0.jpg	35	1	2020-03-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
46	411353227	Dead Blue	2233	https://cdn-images.dzcdn.net/images/cover/8daf580519b7c8255dbca9dd22ad649e/1000x1000-000000-80-0-0.jpg	41	11	2016-09-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
47	83461462	Currents	238	https://cdn-images.dzcdn.net/images/cover/614a870975d6ecc563a96c77180e466a/1000x1000-000000-80-0-0.jpg	42	1	2024-02-16	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
48	15771842	Currents	1246	https://cdn-images.dzcdn.net/images/cover/8cf03c8b5fc51f701ab62165cc68f9c2/1000x1000-000000-80-0-0.jpg	43	7	2017-03-29	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
49	537405862	Currents	456	https://cdn-images.dzcdn.net/images/cover/eeb9dfdcf9b05dae7084d4aed96f7f94/1000x1000-000000-80-0-0.jpg	44	3	2024-02-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
50	343550887	The Death We Seek	245	https://cdn-images.dzcdn.net/images/cover/f3db7f347ff158c437b602ac25dd184a/1000x1000-000000-80-0-0.jpg	8	1	2022-08-31	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
51	6562898	Currents	3038	https://cdn-images.dzcdn.net/images/cover/b5abb8e4ea800ea574d37bc97d31166d/1000x1000-000000-80-0-0.jpg	45	12	2013-05-28	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
60	945917251	Jane!	187	https://cdn-images.dzcdn.net/images/cover/a98d324be4c3aefcaebfb81165e46561/1000x1000-000000-80-0-0.jpg	55	1	2018-07-03	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
61	1254871	Shallow Bay: The Best Of Breaking Benjamin Deluxe Edition (Explicit)	5362	https://cdn-images.dzcdn.net/images/cover/3e0cb6bd5522a9be439722a5b54a573c/1000x1000-000000-80-0-0.jpg	56	24	2011-08-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
62	11375984	Zanaka	1993	https://cdn-images.dzcdn.net/images/cover/cc09c2457ce3e1adc3a7a23f93440e59/1000x1000-000000-80-0-0.jpg	51	10	2016-10-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
63	1543242	Some Nights	2749	https://cdn-images.dzcdn.net/images/cover/5f7bd91e2d91ce2d308ee754d6821ff7/1000x1000-000000-80-0-0.jpg	57	11	2012-02-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
64	942552041	Jane! (Slowed & reverb)	253	https://cdn-images.dzcdn.net/images/cover/47f59221a7b2c8620a84b5028f765fb4/1000x1000-000000-80-0-0.jpg	58	1	2026-03-16	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
65	943647141	Yoga (Copacabana) - Jersey Club Remix	132	https://cdn-images.dzcdn.net/images/cover/490f004d8662ae78141721cfbf3a61d9/1000x1000-000000-80-0-0.jpg	64	1	2026-03-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
66	8986017	Reckless	2276	https://cdn-images.dzcdn.net/images/cover/f5c062034dbbf74f9c158c51ba783871/1000x1000-000000-80-0-0.jpg	65	10	2014-11-24	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
67	925154	Porque te vas	2008	https://cdn-images.dzcdn.net/images/cover/1265eea6e3ffce493b164ede8600d10c/1000x1000-000000-80-0-0.jpg	66	10	2011-01-25	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
68	732037221	JANE!	121	https://cdn-images.dzcdn.net/images/cover/ef59668c9557860d0e451ee67cfcca87/1000x1000-000000-80-0-0.jpg	67	1	2025-04-05	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
69	794930241	JANE! (pxiqzes remix)	662	https://cdn-images.dzcdn.net/images/cover/ba336cea18b6baf740868c9f7ddc0575/1000x1000-000000-80-0-0.jpg	68	4	2025-08-08	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
70	3227271	Songs About Jane: 10th Anniversary Edition	5329	https://cdn-images.dzcdn.net/images/cover/a93caa280e6dd750508aa54c932b6bbe/1000x1000-000000-80-0-0.jpg	69	29	2012-06-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
71	338269	Mary Jane Girls	2155	https://cdn-images.dzcdn.net/images/cover/ae80cebadfc698c4acd20aa649daab59/1000x1000-000000-80-0-0.jpg	59	8	2009-01-13	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
72	345278	Ritual De Lo Habitual	3093	https://cdn-images.dzcdn.net/images/cover/e31d867c27803d442aacad8a7dac5d15/1000x1000-000000-80-0-0.jpg	60	9	1990-08-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
73	79085832	Greatest Hits	3921	https://cdn-images.dzcdn.net/images/cover/fc7a9b132524c63f26a70d26d15cff58/1000x1000-000000-80-0-0.jpg	74	18	2018-11-23	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
74	335236727	Samba de Janeiro	2594	https://cdn-images.dzcdn.net/images/cover/c7f9d5dc4aa235c3d02bfbea3539152e/1000x1000-000000-80-0-0.jpg	75	11	2008-06-20	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
75	322288667	Dinner in America Soundtrack	222	https://cdn-images.dzcdn.net/images/cover/341da7e0d8563d91df8c7b8903411a6c/1000x1000-000000-80-0-0.jpg	76	2	2024-10-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
76	46196432	Still Striving	2902	https://cdn-images.dzcdn.net/images/cover/245dba4a2fac1b5be255951d263d6baa/1000x1000-000000-80-0-0.jpg	77	14	2017-08-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
77	1484717	Jane Doe	2715	https://cdn-images.dzcdn.net/images/cover/edde4d2f6a9fbb37a7594113bf7aa4a9/1000x1000-000000-80-0-0.jpg	78	12	2012-01-10	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
78	304265	Damita Jo	3893	https://cdn-images.dzcdn.net/images/cover/008c1e5797196e77d4325b2153cca9b3/1000x1000-000000-80-0-0.jpg	72	22	2004-03-30	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
79	12494534	Jane Birkin & Serge Gainsbourg	1862	https://cdn-images.dzcdn.net/images/cover/081ec099bb912538c513fddd1577a132/1000x1000-000000-80-0-0.jpg	54	11	1969-01-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
80	361792807	The Velvet Rope (Deluxe Edition)	4960	https://cdn-images.dzcdn.net/images/cover/9ef879250b2a691568be7f1bbb91cdb6/1000x1000-000000-80-0-0.jpg	72	38	2022-10-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
81	91985	Three Cheers for Sweet Revenge	2370	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	7	13	2004-06-08	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
82	87903062	Сборник север 3	1787	https://cdn-images.dzcdn.net/images/cover/a58946114be7c5b72d7d22517db75c75/1000x1000-000000-80-0-0.jpg	86	10	2016-01-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
83	188912412	Культурний шок	1654	https://cdn-images.dzcdn.net/images/cover/9041f2042adec516ba29153a0f762eff/1000x1000-000000-80-0-0.jpg	87	8	2020-12-09	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
84	54847902	V$tavляє	2732	https://cdn-images.dzcdn.net/images/cover/b3832eb004bed8939f5f161436a0d5bc/1000x1000-000000-80-0-0.jpg	87	11	2018-01-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
85	89867812	Tomos	735	https://cdn-images.dzcdn.net/images/cover/ff6df666b18d017795992dbb72d35b9a/1000x1000-000000-80-0-0.jpg	87	3	2019-03-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
86	597350882	BRAT	2483	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	88	15	2024-06-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
87	654424131	Brat and it’s completely different but also still brat	4339	https://cdn-images.dzcdn.net/images/cover/cb0212716fb2fafe362a1a475276b368/1000x1000-000000-80-0-0.jpg	88	34	2024-10-11	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
88	789758081	BRATLAND	2620	https://cdn-images.dzcdn.net/images/cover/e4f789c089a86724cc813da9ebf62763/1000x1000-000000-80-0-0.jpg	89	16	2025-07-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
89	656715281	Brat and it’s completely different but also still brat	4270	https://cdn-images.dzcdn.net/images/cover/2e2214c3a3cce1129d5b4c95fa392860/1000x1000-000000-80-0-0.jpg	88	35	2024-10-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
90	440835217	BRAT	142	https://cdn-images.dzcdn.net/images/cover/b69fddee87f7a9708e666a3731a5fe46/1000x1000-000000-80-0-0.jpg	90	1	2023-06-09	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
91	67819132	Losing It	248	https://cdn-images.dzcdn.net/images/cover/b62a06ef55ce19c91c67f1ebaa098886/1000x1000-000000-80-0-0.jpg	96	1	2018-07-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
92	76783062	Losing It (Radio Edit)	163	https://cdn-images.dzcdn.net/images/cover/ebac3c7a4baff91f789cfdf053a11938/1000x1000-000000-80-0-0.jpg	96	1	2018-10-25	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
93	368425367	Her Love Still Haunts Me Like a Ghost	1239	https://cdn-images.dzcdn.net/images/cover/9f56db5203a64f8e2bfe9e1c33cdbd50/1000x1000-000000-80-0-0.jpg	91	7	2022-10-28	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
94	914989941	Love You Right	165	https://cdn-images.dzcdn.net/images/cover/c9f019d78cacdcc236a271602f35476d/1000x1000-000000-80-0-0.jpg	91	1	2026-03-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
95	670373061	i cant tell (love my money)	163	https://cdn-images.dzcdn.net/images/cover/efa6dc306bc3a2be6ac1f8469c04ae81/1000x1000-000000-80-0-0.jpg	91	1	2024-11-22	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
96	186203092	The Lo-Fis	1513	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	97	15	2020-12-04	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
97	316706887	Fall in Love with You.	132	https://cdn-images.dzcdn.net/images/cover/d29aba2d12d8ba1d17f9bd8a8127c087/1000x1000-000000-80-0-0.jpg	91	1	2022-05-11	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
98	632901571	8 роздумів	1619	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	98	8	2024-09-20	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
99	401346	Favourite Worst Nightmare	2280	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	99	12	2007-04-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
100	796709881	Imaginal Disk	3216	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	100	15	2024-08-23	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
101	102960742	Antes e depois (Ao vivo)	4141	https://cdn-images.dzcdn.net/images/cover/3ed961d54f9cef26bdf796a991c495a4/1000x1000-000000-80-0-0.jpg	101	21	2019-04-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
102	639869531	Welcome To Hell	251	https://cdn-images.dzcdn.net/images/cover/f95e3aea3fc53d4191fb658082b62d50/1000x1000-000000-80-0-0.jpg	104	3	2024-09-27	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
103	895784212	WELCOME TO HELL	209	https://cdn-images.dzcdn.net/images/cover/aa1638d9c12ebdf46f50fcabba1d5c84/1000x1000-000000-80-0-0.jpg	105	1	2026-02-27	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
104	62822542	Welcome to Hell	5227	https://cdn-images.dzcdn.net/images/cover/f7c0aafb90922643da37b071837f65f1/1000x1000-000000-80-0-0.jpg	106	21	2018-07-27	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
105	85609322	Chuck	2500	https://cdn-images.dzcdn.net/images/cover/c6a0130589841326372ac87c6924ed65/1000x1000-000000-80-0-0.jpg	107	14	2019-02-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
106	1066859	And Then It Got Ugly	2497	https://cdn-images.dzcdn.net/images/cover/97cc90f60a0106e49d67e92b4ceb65b1/1000x1000-000000-80-0-0.jpg	108	11	2006-04-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
107	467267	The Sound of the Smiths (Deluxe; 2008 Remaster)	4986	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	110	45	2008-11-11	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
108	1261479	Hatful of Hollow	3367	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	110	16	2001-06-26	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
109	507126981	Should I Stay or Should I Go?	2810	https://cdn-images.dzcdn.net/images/cover/73af771a84c36b6b892ba801f7c9fec8/1000x1000-000000-80-0-0.jpg	111	13	2024-02-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
110	906042682	Look Out Live!	6228	https://cdn-images.dzcdn.net/images/cover/46bbbb94213c6cafd2730a2ddfc29025/1000x1000-000000-80-0-0.jpg	112	22	2025-09-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
111	116781012	This Charming Man	184	https://cdn-images.dzcdn.net/images/cover/981fcd4994b7474ca9adde9ed05f4267/1000x1000-000000-80-0-0.jpg	113	1	2019-10-25	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
112	488748325	This Charming Man	173	https://cdn-images.dzcdn.net/images/cover/efe555fccd60fe3d57841606a7e6d91e/1000x1000-000000-80-0-0.jpg	114	1	2023-09-16	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
113	259380532	This Charming Man	167	https://cdn-images.dzcdn.net/images/cover/190bb2e978b69906b5f0124111eb3245/1000x1000-000000-80-0-0.jpg	115	1	2021-09-24	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
114	1261473	The Smiths	2733	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	110	11	2001-06-26	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
115	7025352	You Can Play These Songs With Chords	4013	https://cdn-images.dzcdn.net/images/cover/1c625626c2a6fdd01786aac7202ebad7/1000x1000-000000-80-0-0.jpg	116	18	2013-10-08	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
116	535677592	hades (the nine stages of change at the deceased remains)	2921	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	117	10	2015-06-03	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
117	82097	Famous Last Words	739	https://cdn-images.dzcdn.net/images/cover/a9d3a79ddc4e2f6da7896eb571929b6d/1000x1000-000000-80-0-0.jpg	7	3	2007-01-22	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
118	14069820	The Black Parade / Living with Ghosts (The 10th Anniversary Edition)	5391	https://cdn-images.dzcdn.net/images/cover/2914a662dd00f96969cd3ee6a3330663/1000x1000-000000-80-0-0.jpg	7	25	2016-09-23	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
119	365894357	Kill All Your Friends	248	https://cdn-images.dzcdn.net/images/cover/d41572b0f17fe6e87cd5d10d9e8f8d5e/1000x1000-000000-80-0-0.jpg	118	1	2022-10-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
120	571370141	Dreams Of Puke	1231	https://cdn-images.dzcdn.net/images/cover/e86f6718a371a55edc92d051ff63b46f/1000x1000-000000-80-0-0.jpg	119	12	2024-06-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
121	626101	Unbreakable	1607	https://cdn-images.dzcdn.net/images/cover/2f2d9c303f69d7d7640fbce90eb08aa4/1000x1000-000000-80-0-0.jpg	120	9	2010-09-13	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
123	600636262	Chateau de France	1223	https://cdn-images.dzcdn.net/images/cover/389d61c2d5155b36df04457b78816503/1000x1000-000000-80-0-0.jpg	121	6	2010-01-01	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
124	600488552	Tu L'As Bien Mérité!	2649	https://cdn-images.dzcdn.net/images/cover/4ab54fbc5c58c2531bd9d4737597e068/1000x1000-000000-80-0-0.jpg	121	16	2009-05-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
125	600488512	Cyril	2231	https://cdn-images.dzcdn.net/images/cover/e08e4747cb5b5fba4092a4e54f3ac23a/1000x1000-000000-80-0-0.jpg	121	14	2010-06-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
126	600636302	Marre marre marre	2218	https://cdn-images.dzcdn.net/images/cover/88676ed155c420f68532e0c4004c3b1d/1000x1000-000000-80-0-0.jpg	121	12	2008-03-03	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
127	604458542	Vous n'allez pas repartir les mains vides?	4035	https://cdn-images.dzcdn.net/images/cover/1c65745eec23e4f5d1cc2056fc9e9517/1000x1000-000000-80-0-0.jpg	121	32	2013-05-13	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
128	6414905	Comedown Machine	2389	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	126	11	2013-03-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
129	629800531	Live & Destroy	2917	https://cdn-images.dzcdn.net/images/cover/642e107e1b653c0f64329db0e7d6e1f1/1000x1000-000000-80-0-0.jpg	127	11	2014-10-06	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
130	329338227	30 Something (Deluxe Version)	5104	https://cdn-images.dzcdn.net/images/cover/f15c4ac33721aaab4905e052dca5c09a/1000x1000-000000-80-0-0.jpg	128	33	1991-01-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
131	203110682	Трэп, который мы заслужили	1388	https://cdn-images.dzcdn.net/images/cover/67f7b4cd51f156f7c1c52d58c5c31f73/1000x1000-000000-80-0-0.jpg	131	7	2020-12-25	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
133	308977677	Моргенштерн Скриптонит Легенда	85	https://cdn-images.dzcdn.net/images/cover/94dec43c964e781771ad64db6f99a606/1000x1000-000000-80-0-0.jpg	133	1	2022-05-01	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
134	356999357	Привет, это последнее ЕР перед фитом с Моргенштерном	839	https://cdn-images.dzcdn.net/images/cover/b4e91b49db8c3414b79a876a9f95eddc/1000x1000-000000-80-0-0.jpg	134	5	2022-09-16	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
135	9298172	ХА-ХА-ХА	2389	https://cdn-images.dzcdn.net/images/cover/c7165e46aa6d7aa3c92757b365be7163/1000x1000-000000-80-0-0.jpg	136	14	2012-01-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
136	250776582	Чёрный пистолет	96	https://cdn-images.dzcdn.net/images/cover/86ade36185b70796396bbd002ad5a174/1000x1000-000000-80-0-0.jpg	135	1	2021-08-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
137	150454752	AIBYVAIBY	1525	https://cdn-images.dzcdn.net/images/cover/a1de0bbb791d4e1407d14439b71e880c/1000x1000-000000-80-0-0.jpg	137	10	2020-06-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
138	175833112	Сон под пятницу	3725	https://cdn-images.dzcdn.net/images/cover/fcd07825439ba60c21dc5f65a609c4a5/1000x1000-000000-80-0-0.jpg	138	50	2017-11-11	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
139	10355768	Как здорово, что все мы здесь сегодня собрались! (Четверть века спустя)	4180	https://cdn-images.dzcdn.net/images/cover/413fc962453a267876a70867bc8e3745/1000x1000-000000-80-0-0.jpg	139	21	2015-05-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
140	597994842	Кадиллак	114	https://cdn-images.dzcdn.net/images/cover/4e3755bf7c331005f2578fcbb73ded16/1000x1000-000000-80-0-0.jpg	140	1	2024-06-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
141	8215110	Чёрный кадиллак, Ч. 2	2409	https://cdn-images.dzcdn.net/images/cover/2ca29e8f9490bcd15ebd6beb08c38363/1000x1000-000000-80-0-0.jpg	141	9	2014-07-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
142	8193306	Чёрный кадиллак, Ч. 1	2530	https://cdn-images.dzcdn.net/images/cover/037ab465ce3e0f5fc6aae3f0aa0c658c/1000x1000-000000-80-0-0.jpg	141	8	2014-07-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
143	81869102	Динозаври кадилаци	142	https://cdn-images.dzcdn.net/images/cover/9096dd830d1b02a91c068c00e88f39c9/1000x1000-000000-80-0-0.jpg	142	1	2024-01-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
144	911094891	Каділак	149	https://cdn-images.dzcdn.net/images/cover/0680ea7ad731a4086d3a5cbec7274f33/1000x1000-000000-80-0-0.jpg	143	1	2026-02-03	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
148	635940221	Thing	234	https://cdn-images.dzcdn.net/images/cover/8bfd83468fea6807d6957e94d1175fc5/1000x1000-000000-80-0-0.jpg	150	1	2018-01-01	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
149	106462	I Am A Bird Now	2124	https://cdn-images.dzcdn.net/images/cover/ff7e1ca71724a860608a7bf92efd3cf0/1000x1000-000000-80-0-0.jpg	151	10	2005-02-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
150	264782602	Rated Z	2343	https://cdn-images.dzcdn.net/images/cover/bb3c5ccc889400510e747a5e52a5a2aa/1000x1000-000000-80-0-0.jpg	152	8	2021-10-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
151	401340	Whatever People Say I Am, That's What I'm Not	2462	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	99	13	2006-02-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
163	177830722	Destructive Amplifier	1371	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	173	6	2015-06-17	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
164	177830412	Sol-fa	2787	https://cdn-images.dzcdn.net/images/cover/5b8d294ba72b50db78a4dea82db50438/1000x1000-000000-80-0-0.jpg	173	12	2015-06-17	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
165	151783792	Re:Re:	506	https://cdn-images.dzcdn.net/images/cover/4b6954804e8f4976f75d78ee703f21ce/1000x1000-000000-80-0-0.jpg	173	2	2016-03-16	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
166	151792242	Blood Circulator	405	https://cdn-images.dzcdn.net/images/cover/230aff850451111a12fff99b7aed98ed/1000x1000-000000-80-0-0.jpg	173	2	2016-07-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
167	946143681	Skins	245	https://cdn-images.dzcdn.net/images/cover/7ccf14966abd98b1fcb363be8b9b9afb/1000x1000-000000-80-0-0.jpg	173	1	2026-04-03	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
168	177833132	BEST HIT AKG	4458	https://cdn-images.dzcdn.net/images/cover/09def128c370220f17e00d6648812370/1000x1000-000000-80-0-0.jpg	173	17	2015-06-17	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
169	95826372	Here Comes The Cowboy	2786	https://cdn-images.dzcdn.net/images/cover/b4b7dd92a404cd45a556b4066f7b8cbd/1000x1000-000000-80-0-0.jpg	178	13	2019-05-10	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
170	7533292	Salad Days	2087	https://cdn-images.dzcdn.net/images/cover/96f16ccb3da4d231b72bc5de25a16202/1000x1000-000000-80-0-0.jpg	178	11	2014-04-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
171	6158996	2	1887	https://cdn-images.dzcdn.net/images/cover/48dd98d88f1af797d65faf7f3e4beef7/1000x1000-000000-80-0-0.jpg	178	11	2012-10-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
172	39511351	This Old Dog	2550	https://cdn-images.dzcdn.net/images/cover/5e7b8670b572a110d4453e6ac94421d8/1000x1000-000000-80-0-0.jpg	178	13	2017-05-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
173	429737827	One Wayne G	4040	https://cdn-images.dzcdn.net/images/cover/1df3f13e3b5ac9723c121ff9a91368cd/1000x1000-000000-80-0-0.jpg	178	199	2023-04-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
174	14880711	Pablo Honey	2529	https://cdn-images.dzcdn.net/images/cover/1dd56fd8824492e1a5106c99a00a85ec/1000x1000-000000-80-0-0.jpg	180	12	1993-02-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
175	14879699	OK Computer	3216	https://cdn-images.dzcdn.net/images/cover/05a186e0a859a36f9cd51cdae2158fe1/1000x1000-000000-80-0-0.jpg	180	12	1997-06-17	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
176	14879583	No Surprises	641	https://cdn-images.dzcdn.net/images/cover/7a378976d3ff1b1fd7b21ee0c7f95fa5/1000x1000-000000-80-0-0.jpg	180	3	1998-01-12	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
177	14880317	The Bends	2914	https://cdn-images.dzcdn.net/images/cover/0d2ccaf5f7b35af57f3d9c8f4504a6e6/1000x1000-000000-80-0-0.jpg	180	12	1994-11-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
178	14880659	In Rainbows	2554	https://cdn-images.dzcdn.net/images/cover/a175af9b7d329bc678cb4d26fc13d6de/1000x1000-000000-80-0-0.jpg	180	10	2007-12-28	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
179	14880741	Kid A	2826	https://cdn-images.dzcdn.net/images/cover/e5925065cdb1cefbc3bd75af4a1f1801/1000x1000-000000-80-0-0.jpg	180	11	2000-10-02	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
180	584380142	Metaphorical Music	3744	https://cdn-images.dzcdn.net/images/cover/1101dad700ff330a9ca2c6915135af4e/1000x1000-000000-80-0-0.jpg	1	15	2017-12-13	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
181	584402082	Luv(sic) Hexalogy	7702	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	1	26	2015-12-09	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
182	584383232	Spiritual State	3622	https://cdn-images.dzcdn.net/images/cover/a169eaef1fb5af5792586df290a81143/1000x1000-000000-80-0-0.jpg	1	14	2011-12-03	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
183	584380342	Modal Soul	3810	https://cdn-images.dzcdn.net/images/cover/df84078a237cfcc1632b2e1e3796b9c6/1000x1000-000000-80-0-0.jpg	1	14	2005-11-11	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
184	526029192	samurai champloo music record departure	4085	https://cdn-images.dzcdn.net/images/cover/90de339798d6c7bbd11013ba1550cf8c/1000x1000-000000-80-0-0.jpg	185	17	2015-04-15	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
185	596251	Frankenstein Girls Will Seem Strangely Sexy	2737	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	186	30	2000-02-11	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
186	605282412	MSI B-SIDES vol.1	2176	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	186	13	2024-06-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
187	857119022	PINK	3277	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	186	19	2015-09-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
188	900775892	Tighter	2787	https://cdn-images.dzcdn.net/images/cover/e4b0ec6b60e3409db28aa23ee113045d/1000x1000-000000-80-0-0.jpg	186	27	2026-01-28	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
189	740768	You'll Rebel to Anything (Expanded and Remastered 2008)	2259	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	186	14	2008-01-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
190	895811902	If	2702	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	186	15	2008-04-29	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
191	791483241	DON'T TAP THE GLASS	1707	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	187	10	2025-07-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
192	662648981	CHROMAKOPIA	3177	https://cdn-images.dzcdn.net/images/cover/cb415a59a7bc198ec4aab01f02600691/1000x1000-000000-80-0-0.jpg	187	14	2024-10-28	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
193	44730061	Flower Boy	2794	https://cdn-images.dzcdn.net/images/cover/a7a16b8f63b1ec0e9fbd327619966737/1000x1000-000000-80-0-0.jpg	187	14	2017-07-21	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
194	97140952	IGOR	2383	https://cdn-images.dzcdn.net/images/cover/041ab5ceb6fb6ebf9512966835be9e1b/1000x1000-000000-80-0-0.jpg	187	12	2019-05-17	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
195	1129652	Goblin	4926	https://cdn-images.dzcdn.net/images/cover/65d4a36d03918097176d42f8f55900af/1000x1000-000000-80-0-0.jpg	187	18	2011-05-09	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
202	910510411	Dracula (Remix)	414	https://cdn-images.dzcdn.net/images/cover/b868399da682f34dcd7d98af1c0de80b/1000x1000-000000-80-0-0.jpg	13	2	2026-02-06	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
203	825550621	Dracula	205	https://cdn-images.dzcdn.net/images/cover/b428fa5da7496083cd2c2e87b94e2ceb/1000x1000-000000-80-0-0.jpg	13	1	2025-09-26	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
204	130876272	The Slow Rush	3447	https://cdn-images.dzcdn.net/images/cover/d8eb61bd4becf79a602a75b69eebde7d/1000x1000-000000-80-0-0.jpg	13	12	2020-02-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
205	76298222	InnerSpeaker	3201	https://cdn-images.dzcdn.net/images/cover/5bf6a2d836429e215be5f0213882ad1f/1000x1000-000000-80-0-0.jpg	13	11	2018-10-26	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
206	837961612	Deadbeat	3361	https://cdn-images.dzcdn.net/images/cover/23b006b2e956536d97612847bbd7a3b7/1000x1000-000000-80-0-0.jpg	13	12	2025-10-17	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
210	950475551	Crush on you	125	https://cdn-images.dzcdn.net/images/cover/d246732856fbe6109c4a78fbd02d147d/1000x1000-000000-80-0-0.jpg	193	1	2024-07-12	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
211	720461471	Счастливая	121	https://cdn-images.dzcdn.net/images/cover/97ce2ddd038b03aca5497746b4cd06b5/1000x1000-000000-80-0-0.jpg	188	1	2025-03-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
212	6398213	Романсы	4789	https://cdn-images.dzcdn.net/images/cover/3ae85cec86675b5b441190d7f9ef01e3/1000x1000-000000-80-0-0.jpg	194	18	2013-02-08	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
213	13197514	Песнопения иеромонаха Романа	5278	https://cdn-images.dzcdn.net/images/cover/972181cf751de9dcefce3e4acdb5da5c/1000x1000-000000-80-0-0.jpg	195	18	2016-05-27	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
214	12218542	Молюсь	3043	https://cdn-images.dzcdn.net/images/cover/5a337e971510d565ffe8d92ec850da86/1000x1000-000000-80-0-0.jpg	196	10	2016-01-29	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
215	502453341	Ой Ой	120	https://cdn-images.dzcdn.net/images/cover/25f57ca16e868c0450e42c42d5ea73b5/1000x1000-000000-80-0-0.jpg	197	1	2023-10-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
216	177755132	Отбой	148	https://cdn-images.dzcdn.net/images/cover/05f6cf92675d933e6f5173ebd97abe76/1000x1000-000000-80-0-0.jpg	198	1	2020-10-05	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
217	542824492	Ой ой	126	https://cdn-images.dzcdn.net/images/cover/5b6c7f1aeeba547936e5962adf9ddadd/1000x1000-000000-80-0-0.jpg	199	1	2024-02-08	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
218	414325407	Оторвёмся по-питерски	3212	https://cdn-images.dzcdn.net/images/cover/12e1186f71a3d7414a358eace1b42aa6/1000x1000-000000-80-0-0.jpg	200	14	2005-01-02	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
219	958546541	На двох	150	https://cdn-images.dzcdn.net/images/cover/f4440d667a734e057787635e8e76f5d0/1000x1000-000000-80-0-0.jpg	98	1	2026-04-24	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
220	534392132	темна ч.2	1727	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	98	11	2024-01-30	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
221	15746602	Hator!	2688	https://cdn-images.dzcdn.net/images/cover/7f7527c38afb700a2128ec6e38d0f7ca/1000x1000-000000-80-0-0.jpg	205	10	1993-11-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
222	118100602	Euphonic Entropy	3386	https://cdn-images.dzcdn.net/images/cover/de3d4ef5ba7c4c1fb6c12019764d0c67/1000x1000-000000-80-0-0.jpg	206	12	2020-02-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
223	489120565	Судоми	146	https://cdn-images.dzcdn.net/images/cover/7cf6cad57141fb00147c3994d08d9f66/1000x1000-000000-80-0-0.jpg	98	1	2023-09-29	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
224	513276971	IKURRAK	941	https://cdn-images.dzcdn.net/images/cover/7559d75534d7758e57b96bdb64460f56/1000x1000-000000-80-0-0.jpg	207	4	2023-11-20	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
225	424350887	Недовготривалі відносини	1297	https://cdn-images.dzcdn.net/images/cover/458a65c4a23faadd14c0f36cc5f62b32/1000x1000-000000-80-0-0.jpg	98	9	2023-05-25	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
226	418913827	CVIT	928	https://cdn-images.dzcdn.net/images/cover/44927d36b2b160b183cfc21a4bac0187/1000x1000-000000-80-0-0.jpg	98	6	2020-12-16	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
227	781459041	Пекло	210	https://cdn-images.dzcdn.net/images/cover/16d323ce498287a3ad46511c889e5511/1000x1000-000000-80-0-0.jpg	98	1	2025-07-25	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
228	768362431	Забудуться жалі	163	https://cdn-images.dzcdn.net/images/cover/fd5d51409df03bf74814f247b60232b1/1000x1000-000000-80-0-0.jpg	213	1	2025-06-19	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
229	422429357	Безодня	130	https://cdn-images.dzcdn.net/images/cover/366ddb808331d495be759a092092af12/1000x1000-000000-80-0-0.jpg	208	1	2023-04-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
230	956596401	Совковий модернізм	163	https://cdn-images.dzcdn.net/images/cover/65ed68e35a1b1feb2ee55bcbaf78c1e1/1000x1000-000000-80-0-0.jpg	208	1	2026-04-24	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
231	886928522	Хороший громадянин	166	https://cdn-images.dzcdn.net/images/cover/ad6ea35d1cc8e9a5a53b83267c70e232/1000x1000-000000-80-0-0.jpg	208	1	2026-01-16	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
232	784655041	Кінець фільму	178	https://cdn-images.dzcdn.net/images/cover/b51f92904cf2063cf83f7e0596354e02/1000x1000-000000-80-0-0.jpg	208	1	2025-07-25	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
233	519803712	Місто розбитих надій	146	https://cdn-images.dzcdn.net/images/cover/a82d88dcacab8a879a96f7ec8f330811/1000x1000-000000-80-0-0.jpg	208	1	2023-12-22	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
234	394603857	Зима	188	https://cdn-images.dzcdn.net/images/cover/fef9f632c51d7e499ffb7d7b896c27d4/1000x1000-000000-80-0-0.jpg	208	1	2023-01-09	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
235	647152651	Від людей для людей	868	https://cdn-images.dzcdn.net/images/cover/0fe7540c6c7ad6c6aef3684ed1a16492/1000x1000-000000-80-0-0.jpg	217	4	2024-10-04	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
236	680542031	Тиха вода	288	https://cdn-images.dzcdn.net/images/cover/695536359e9d936b7eeeaaef08010888/1000x1000-000000-80-0-0.jpg	218	1	2024-12-05	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
237	524522822	Вибране	6035	https://cdn-images.dzcdn.net/images/cover/54b607f056631d6fc3ac7d5db45c6416/1000x1000-000000-80-0-0.jpg	219	40	2023-12-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
238	482459865	Тиха Вода	212	https://cdn-images.dzcdn.net/images/cover/93c6e38e5213c47dfab9431d1fc827f3/1000x1000-000000-80-0-0.jpg	220	1	2023-09-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
239	11201916	Жива вода	2678	https://cdn-images.dzcdn.net/images/cover/fd9ab31f91ef6d0f6c9108456459271c/1000x1000-000000-80-0-0.jpg	221	12	2015-09-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
240	945488621	Тиха вода	127	https://cdn-images.dzcdn.net/images/cover/31ec6701dcdc95abc9e6c598d9e12799/1000x1000-000000-80-0-0.jpg	222	1	2026-03-27	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
241	696861421	Тиха вода (Maver Remix)	306	https://cdn-images.dzcdn.net/images/cover/04ba3ee8cc11c6777f32d042b71a6a6f/1000x1000-000000-80-0-0.jpg	218	1	2025-01-10	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
242	493141091	Голубоглазый	181	https://cdn-images.dzcdn.net/images/cover/a724155df5ee46f08c4e35ffc06cc8ce/1000x1000-000000-80-0-0.jpg	214	1	2023-09-27	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
243	81307352	Мертві голоси	2266	https://cdn-images.dzcdn.net/images/cover/f5a0b686e228612b5aada0cad54c8e05/1000x1000-000000-80-0-0.jpg	223	9	2018-12-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
244	515504582	Гріх	1261	https://cdn-images.dzcdn.net/images/cover/5fb6cc3fc672404c72bf42029328ca1e/1000x1000-000000-80-0-0.jpg	223	5	2023-12-07	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
245	761174901	На іншому боці ріки	1114	https://cdn-images.dzcdn.net/images/cover/c484012d0dc2784f5c6782def35026e9/1000x1000-000000-80-0-0.jpg	223	4	2025-05-29	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
246	497013131	Тисяча Очей	2670	https://cdn-images.dzcdn.net/images/cover/a61030910e83fff9445929e6bea19952/1000x1000-000000-80-0-0.jpg	223	11	2023-10-13	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
247	663939851	ЕПОХА	1647	https://cdn-images.dzcdn.net/images/cover/81f7e046d09d7548ec4c66cafd1f5800/1000x1000-000000-80-0-0.jpg	228	8	2024-11-15	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
248	663553841	Не довіряй смертним	268	https://cdn-images.dzcdn.net/images/cover/dc6ee626757fad9bf9ec93ece7b4e714/1000x1000-000000-80-0-0.jpg	223	1	2024-10-30	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
249	728605251	Від тилу до фронту	2470	https://cdn-images.dzcdn.net/images/cover/c3430697ff4515b23c02385b3af634d6/1000x1000-000000-80-0-0.jpg	229	18	2025-04-01	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
250	769759621	Війни	155	https://cdn-images.dzcdn.net/images/cover/16ac2aacc116c0dafae5009d194be03b/1000x1000-000000-80-0-0.jpg	230	1	2025-06-20	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
251	897466882	Хата скраю села	3770	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	231	15	2006-03-18	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
252	887072072	Чорна рілля	3500	https://cdn-images.dzcdn.net/images/cover/48def83a99d438e5328e64b52a94f573/1000x1000-000000-80-0-0.jpg	231	13	2020-05-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
253	398014727	Щось справжнє	2317	https://cdn-images.dzcdn.net/images/cover/2fad3c50a24ab5e0bcdcbf90b175eb46/1000x1000-000000-80-0-0.jpg	232	12	2023-01-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
254	251583152	Лебеді	203	https://cdn-images.dzcdn.net/images/cover/f17be3334e8d8164ddc8f2c6fc3e50cf/1000x1000-000000-80-0-0.jpg	232	1	2021-08-12	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
255	955832201	Моровиця	146	https://cdn-images.dzcdn.net/images/cover/55bcfc60282a40a661a0dd238666196b/1000x1000-000000-80-0-0.jpg	232	1	2026-04-13	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
256	426908497	Легенди Дикого Поля	2289	https://cdn-images.dzcdn.net/images/cover/bc2d9bee75f8ed7f9ee0787193d766dd/1000x1000-000000-80-0-0.jpg	232	12	2023-04-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
257	261115882	Екзотична	213	https://cdn-images.dzcdn.net/images/cover/3f20ba7a3c893a81669b087f6149b21c/1000x1000-000000-80-0-0.jpg	232	1	2021-09-24	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
261	130595652	death bed (coffee for your head)	173	https://cdn-images.dzcdn.net/images/cover/85380bbb010f1b675c29ac06c6e343ea/1000x1000-000000-80-0-0.jpg	235	1	2020-02-08	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
262	292229642	Beatopia	2738	https://cdn-images.dzcdn.net/images/cover/61e1093dfaafa599e459ddf4c665e985/1000x1000-000000-80-0-0.jpg	159	14	2022-07-15	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
263	932209631	All I Did Was Dream of You	223	https://cdn-images.dzcdn.net/images/cover/4e3e287293e593dac462146d3c92afda/1000x1000-000000-80-0-0.jpg	159	1	2026-03-14	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
264	80045512	Patched Up	1554	https://cdn-images.dzcdn.net/images/cover/30effb95bd2f00d0637efa5d310ae8aa/1000x1000-000000-80-0-0.jpg	159	7	2018-12-07	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
265	575621241	This Is How Tomorrow Moves	2483	https://cdn-images.dzcdn.net/images/cover/1ca27b208e5b2ace3f055139f1cae5a6/1000x1000-000000-80-0-0.jpg	159	14	2024-08-16	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
266	93511772	Loveworm	1541	https://cdn-images.dzcdn.net/images/cover/e9fa909b7bf3cf5d6f9caab3b74adc94/1000x1000-000000-80-0-0.jpg	159	7	2019-04-26	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
267	3602971	Believe (Deluxe Edition)	3591	https://cdn-images.dzcdn.net/images/cover/312ece7b31fb86c7a13afd757e99437c/1000x1000-000000-80-0-0.jpg	236	16	2012-06-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
268	786280691	SWAG	3260	https://cdn-images.dzcdn.net/images/cover/d0f4411377c5b6a81cdf18d9587a7641/1000x1000-000000-80-0-0.jpg	236	21	2025-07-11	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
269	816518541	SWAG II	5035	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	236	44	2025-09-05	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
270	242430582	STAY	140	https://cdn-images.dzcdn.net/images/cover/dd6fe7fa9267185c4b835bd4f155d1d2/1000x1000-000000-80-0-0.jpg	241	1	2021-07-09	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
271	512013	My World 2.0	2249	https://cdn-images.dzcdn.net/images/cover/39aa26b45fa69cd89b8ef1a46f106c43/1000x1000-000000-80-0-0.jpg	236	10	2010-03-23	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
272	215962322	Justice	2725	https://cdn-images.dzcdn.net/images/cover/87468622c8e7ac9dce7b541be136aa4c/1000x1000-000000-80-0-0.jpg	236	16	2021-03-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
273	11674704	Purpose	2904	https://cdn-images.dzcdn.net/images/cover/35a50db01d6764caa78cf9bfe3eafc04/1000x1000-000000-80-0-0.jpg	236	13	2015-11-13	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
274	131498332	Changes	3092	https://cdn-images.dzcdn.net/images/cover/8d54ffac647e9e40cd91686c8a906de6/1000x1000-000000-80-0-0.jpg	236	17	2020-02-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
275	10795966	Another One	1429	https://cdn-images.dzcdn.net/images/cover/a8cc3d9a142cd0119c42eb1aafc974b9/1000x1000-000000-80-0-0.jpg	178	8	2015-08-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
308	429726397	From The Start	169	https://cdn-images.dzcdn.net/images/cover/497515366a19189203786c2315eb6609/1000x1000-000000-80-0-0.jpg	242	1	2023-05-11	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
309	806692801	A Matter of Time	2726	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	242	14	2025-08-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
310	768065981	Lover Girl	164	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	242	1	2025-06-25	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
311	953309981	A Matter of Time: The Final Hour	3824	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	242	19	2026-04-10	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
312	538347882	Bewitched: The Goddess Edition	3677	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	242	18	2024-04-26	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
313	448448585	Bewitched	2899	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	242	14	2023-09-08	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
314	362293407	Everything I Know About Love	3169	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	242	16	2022-10-14	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
315	353176757	Falling Behind	173	https://cdn-images.dzcdn.net/images/cover/ce4203bf02c22e66eaf2a221fb844c87/1000x1000-000000-80-0-0.jpg	242	1	2022-08-11	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
316	448778635	Promise	403	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	242	2	2023-06-14	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
374	953406931	A Matter of Time: The Final Hour	\N	https://cdn-images.dzcdn.net/images/cover/99f872f6a3e9493e21014a879369ac1f/1000x1000-000000-80-0-0.jpg	242	\N	\N	\N	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
379	777046131	The Secret Of Life: Partners, Volume 2	\N	https://cdn-images.dzcdn.net/images/cover/bf1c90831483e99771c3562c92908eef/1000x1000-000000-80-0-0.jpg	242	\N	\N	\N	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
380	518166322	Winter Wonderland	132	https://cdn-images.dzcdn.net/images/cover/7f917c6ece68040dbcf17117984fe3a5/1000x1000-000000-80-0-0.jpg	242	1	2023-12-15	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
386	488063775	Angel Face	\N	https://cdn-images.dzcdn.net/images/cover/f3474c53cd2d30dcdb1c4d68171fc627/1000x1000-000000-80-0-0.jpg	242	\N	\N	\N	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
387	676658701	A Night At The Symphony: Live at the Hollywood Bowl	3250	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	242	15	2024-12-06	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
388	403589897	A Night At The Symphony	3053	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	242	14	2023-03-02	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
389	821829311	A Big Bold Beautiful Journey (Original Motion Picture Soundtrack)	\N	https://cdn-images.dzcdn.net/images/cover/65aa1ec6cb0a79acda7fdeb02a108499/1000x1000-000000-80-0-0.jpg	242	\N	\N	\N	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
391	807480151	A Matter of Time (Standard Edition)	2905	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	242	15	2025-08-24	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
392	353384337	Everything I Know About Love	2677	https://cdn-images.dzcdn.net/images/cover/ce4203bf02c22e66eaf2a221fb844c87/1000x1000-000000-80-0-0.jpg	242	13	2022-08-26	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
393	359565847	The Reykjavík Sessions	1319	https://cdn-images.dzcdn.net/images/cover/5555c7f66072cca3993536c158fbdb63/1000x1000-000000-80-0-0.jpg	242	6	2022-09-22	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
394	727214221	Silver Lining	197	https://cdn-images.dzcdn.net/images/cover/149cdab032a6fd715cd4e59a5753185d/1000x1000-000000-80-0-0.jpg	242	1	2025-04-03	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
395	591330902	Bewitched (Rework)	508	https://cdn-images.dzcdn.net/images/cover/6f35ff039de550c8f8c9b678002a6f96/1000x1000-000000-80-0-0.jpg	242	2	2024-06-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
396	473560875	California and Me	216	https://cdn-images.dzcdn.net/images/cover/c0859efee3cdc3938916dfe810148a2f/1000x1000-000000-80-0-0.jpg	242	1	2023-08-24	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
397	403585387	Valentine (Live at The Symphony)	180	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	242	1	2023-02-14	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
398	380017887	Ain't Christmas	189	https://cdn-images.dzcdn.net/images/cover/92874b4727db6eee23a08e3daebaf6e5/1000x1000-000000-80-0-0.jpg	242	1	2022-12-02	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
399	353173697	Dear Soulmate	260	https://cdn-images.dzcdn.net/images/cover/ce4203bf02c22e66eaf2a221fb844c87/1000x1000-000000-80-0-0.jpg	242	1	2022-07-06	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
400	353190727	Everything I Know About Love	209	https://cdn-images.dzcdn.net/images/cover/d302785a44233e405abc22a4b31cc945/1000x1000-000000-80-0-0.jpg	242	1	2022-04-21	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
401	348383617	Valentine	168	https://cdn-images.dzcdn.net/images/cover/01216d231903da186abeebe6648c44cf/1000x1000-000000-80-0-0.jpg	242	1	2022-02-14	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
402	349232467	Love to Keep Me Warm	158	https://cdn-images.dzcdn.net/images/cover/ac34a3b2146dcc4ea55d6c3b16007bce/1000x1000-000000-80-0-0.jpg	242	1	2021-12-03	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
403	344152697	Love Flew Away	147	https://cdn-images.dzcdn.net/images/cover/12b236eabd392f2ccd13bedcf07ca6dc/1000x1000-000000-80-0-0.jpg	242	1	2021-10-07	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
404	343906547	Street by Street	224	https://cdn-images.dzcdn.net/images/cover/05639b7b7ad03c965a9ff2080d680734/1000x1000-000000-80-0-0.jpg	242	1	2020-04-06	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
405	87866912	Parting the Sea Between Brightness and Me	1247	https://cdn-images.dzcdn.net/images/cover/401b6e6a78863b74d41d4b04170e67fc/1000x1000-000000-80-0-0.jpg	252	13	2011-06-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
406	807521901	private music	2542	https://cdn-images.dzcdn.net/images/cover/c4ba2ef789f09b0ac549867d97f4a229/1000x1000-000000-80-0-0.jpg	253	11	2025-08-22	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
407	898369232	HEAL	1982	https://cdn-images.dzcdn.net/images/cover/8b00e03400711d00290ab95c7bc707ce/1000x1000-000000-80-0-0.jpg	254	10	2022-10-07	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
408	250889442	When the Day Yearns for Light	2281	https://cdn-images.dzcdn.net/images/cover/f838a8f0c27cc7b870cb643ecfe9db14/1000x1000-000000-80-0-0.jpg	255	8	2021-10-29	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
409	77023512	10 Years / 1000 Shows - Live at the Regent Theater	3292	https://cdn-images.dzcdn.net/images/cover/4ccefb038b2dadca2228ad4e2058bc37/1000x1000-000000-80-0-0.jpg	252	29	2018-11-02	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
410	363784187	~how i'm feeling~	3981	https://cdn-images.dzcdn.net/images/cover/5290bc62c3f5def2da7cbaba5b015c93/1000x1000-000000-80-0-0.jpg	256	21	2020-03-06	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
411	79329102	~~~	1627	https://cdn-images.dzcdn.net/images/cover/0aa3c445f978de3b5cb381f57bd51b45/1000x1000-000000-80-0-0.jpg	257	6	2018-11-30	ep	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
412	363778537	~how i'm feeling~ (the extras)	2207	https://cdn-images.dzcdn.net/images/cover/8a90273443371347d919af469c3f6209/1000x1000-000000-80-0-0.jpg	256	11	2019-12-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
413	2604911	~Sine - EP	2190	https://cdn-images.dzcdn.net/images/cover/2ac43b8cae6aee72ad88103e7a45ca58/1000x1000-000000-80-0-0.jpg	258	6	2012-05-02	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
414	511365591	~mAntras~	2452	https://cdn-images.dzcdn.net/images/cover/cc70b66b91e2f70bba260e40b943ed26/1000x1000-000000-80-0-0.jpg	259	11	2024-04-26	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
377	538749992	Goddess	267	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	242	1	2024-03-06	single	2026-07-06 13:33:02.149504	2026-07-09 11:11:20.133428
634	73361182	The Ant	2069	https://cdn-images.dzcdn.net/images/cover/46d7d0bffda750963caf5ce9eff0fea0/1000x1000-000000-80-0-0.jpg	396	10	2018-10-05	album	2026-07-11 18:09:25.236249	2026-07-11 18:09:27.151058
636	12782458	Jazz For Idiots	2938	https://cdn-images.dzcdn.net/images/cover/f981da5632f0174326d1ac63cf2b00bb/1000x1000-000000-80-0-0.jpg	396	12	2016-04-01	album	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
637	388372667	Brokat (Muzyka z serialu oryginalnego Netflix)	1283	https://cdn-images.dzcdn.net/images/cover/6f47ca8149f1c6c8bd6842735e0e5788/1000x1000-000000-80-0-0.jpg	396	5	2022-12-23	ep	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
638	327443367	Ostatnia nocka ale to DRILL	260	https://cdn-images.dzcdn.net/images/cover/4972a6bb541fd7b51ee90ae99ecc0aa6/1000x1000-000000-80-0-0.jpg	396	1	2022-06-14	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
639	327447037	Ostatnia nocka ale to DRILL (Radio Edit)	208	https://cdn-images.dzcdn.net/images/cover/4972a6bb541fd7b51ee90ae99ecc0aa6/1000x1000-000000-80-0-0.jpg	396	1	2022-06-14	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
640	291619212	Psie łzy	190	https://cdn-images.dzcdn.net/images/cover/3fdfd90b0c6e91317a64cfdf61ae9be2/1000x1000-000000-80-0-0.jpg	396	1	2021-03-30	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
641	73665892	Nalej Jej	207	https://cdn-images.dzcdn.net/images/cover/18b333cd3bddaa6f80971f526badd3af/1000x1000-000000-80-0-0.jpg	396	1	2018-09-26	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
415	977254071	ALEX. REVOLVER, Vol. 2	1545	https://cdn-images.dzcdn.net/images/cover/3724396b09aee98edf0d42ec63dc6cea/1000x1000-000000-80-0-0.jpg	262	14	2026-06-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
416	470234845	Visual kei Kami kyoku	3416	https://cdn-images.dzcdn.net/images/cover/b31800e179fa55343f8d603dd69102ac/1000x1000-000000-80-0-0.jpg	263	31	2023-07-30	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
417	978666791	MALICE MIZER (LA COMÉDIE MUSICALE)	3414	https://cdn-images.dzcdn.net/images/cover/7de32f482f7d8bf43873baa2d766e459/1000x1000-000000-80-0-0.jpg	264	13	2026-03-19	album	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
418	956669771	Gardenia	955	https://cdn-images.dzcdn.net/images/cover/877b0a2795289cd8adb2e1ee2e6e266c/1000x1000-000000-80-0-0.jpg	260	3	2025-09-09	single	2026-07-06 13:33:02.149504	2026-07-07 13:26:44.84782
419	650684991	Hymne à l'amour (Live aux Jeux Olympiques de Paris 2024 / Live from the Olympic Games Paris 2024)	229	https://cdn-images.dzcdn.net/images/cover/643d861edc0a6aa60d235344b65d28cd/1000x1000-000000-80-0-0.jpg	270	1	2024-10-10	single	2026-07-06 13:36:06.464302	2026-07-07 13:26:44.84782
420	1009261021	A deux	1570	https://cdn-images.dzcdn.net/images/cover/7d6cdcaf8653ac2774850a9de51f10a3/1000x1000-000000-80-0-0.jpg	271	10	2026-06-20	album	2026-07-06 13:36:06.464302	2026-07-07 13:26:44.84782
421	69134452	Le temps est bon	210	https://cdn-images.dzcdn.net/images/cover/91a0814b55c7d9d89dcf20840cf0fda2/1000x1000-000000-80-0-0.jpg	272	1	2018-07-27	single	2026-07-06 13:36:06.464302	2026-07-07 13:26:44.84782
422	1015645331	x_x	1608	https://cdn-images.dzcdn.net/images/cover/30b147ccefae586fb9d5840dceb2d7e4/1000x1000-000000-80-0-0.jpg	273	8	2026-06-26	album	2026-07-06 13:36:06.464302	2026-07-07 13:26:44.84782
423	53514702	Chaleur Humaine	2562	https://cdn-images.dzcdn.net/images/cover/d9fcaf9ab19436cce27af945d86eea98/1000x1000-000000-80-0-0.jpg	274	11	2013-04-22	album	2026-07-06 13:36:06.464302	2026-07-07 13:26:44.84782
424	159495092	Le ciel	3425	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	275	22	2020-07-17	album	2026-07-06 13:36:07.873837	2026-07-07 13:26:44.84782
425	795098041	Le ciel (feat. padID)	223	https://cdn-images.dzcdn.net/images/cover/682908d8e9c4cc39f5774914910afd1f/1000x1000-000000-80-0-0.jpg	276	1	2025-08-01	single	2026-07-06 13:36:07.873837	2026-07-07 13:26:44.84782
426	828912211	Le physique de nos idées	727	https://cdn-images.dzcdn.net/images/cover/07b1b7c3efa7746101e9e831ce0d9d4f/1000x1000-000000-80-0-0.jpg	265	5	2025-11-21	ep	2026-07-06 13:36:07.873837	2026-07-07 13:26:44.84782
427	438636897	Le Ciel (me fait des signes)	111	https://cdn-images.dzcdn.net/images/cover/a7f9b871c57906364cedc07c5a731197/1000x1000-000000-80-0-0.jpg	277	1	2023-11-01	single	2026-07-06 13:36:07.873837	2026-07-07 13:26:44.84782
428	60993782	Le Ciel (Edit)	216	https://cdn-images.dzcdn.net/images/cover/26c10f6749ef646ab8b233dade34fc5d/1000x1000-000000-80-0-0.jpg	278	1	2018-04-27	single	2026-07-06 13:36:07.873837	2026-07-07 13:26:44.84782
538	426672	Brianstorm	657	https://cdn-images.dzcdn.net/images/cover/007fefc664c041b0a5c8afdd6ee10cb2/1000x1000-000000-80-0-0.jpg	99	4	2007-04-15	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
526	426673	Leave Before The Lights Come On	568	https://cdn-images.dzcdn.net/images/cover/26eb03c5425cfae62b6c918e75c3c27a/1000x1000-000000-80-0-0.jpg	99	3	2006-08-14	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
533	426675	When The Sun Goes Down	410	https://cdn-images.dzcdn.net/images/cover/ed5ac8e597315a96a7743bbfc19ead27/1000x1000-000000-80-0-0.jpg	99	3	2006-01-16	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
532	426676	I Bet You Look Good On The Dancefloor	636	https://cdn-images.dzcdn.net/images/cover/4101f13e259b9a23cba4dfc54c172f90/1000x1000-000000-80-0-0.jpg	99	3	2005-10-17	single	2026-07-09 18:23:27.168853	2026-07-09 18:23:30.338365
558	880413322	ON IT	1560	https://cdn-images.dzcdn.net/images/cover/809ee59f35fe26ce34cfc1afc0e182c1/1000x1000-000000-80-0-0.jpg	186	7	2008-08-05	album	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
559	880413342	Never Wanted To Dance	1809	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	186	6	2008-03-18	album	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
555	479082935	How I Learned to Stop Giving a Shit and Love Mindless Self Indulgence	2384	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	186	14	2013-05-10	album	2026-07-09 18:30:54.008309	2026-07-09 18:30:55.90618
557	746674	Straight To Video: Remixes	4576	https://cdn-images.dzcdn.net/images/cover/d61150d721760f27379d13d149e6378d/1000x1000-000000-80-0-0.jpg	186	17	2006-03-07	album	2026-07-09 18:30:54.008309	2026-07-09 18:30:55.90618
556	1124131	You'll Rebel To Anything (Expanded and Remastered 2008)	1583	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	186	10	2008-01-22	album	2026-07-09 18:30:54.008309	2026-07-09 18:30:55.90618
560	3396511	You'll Rebel To Anything (Clean Version)	1708	https://cdn-images.dzcdn.net/images/cover/a59fadeda468b0c58e1179cc728f98c5/1000x1000-000000-80-0-0.jpg	186	11	2005-04-12	album	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
561	877838612	(It's 3am) ISSUES	1266	https://cdn-images.dzcdn.net/images/cover/d0ceee9650ea53757cf51ac99bdfa854/1000x1000-000000-80-0-0.jpg	186	6	2026-01-28	ep	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
562	892778112	PAY FOR IT	1431	https://cdn-images.dzcdn.net/images/cover/415dedb8e1dfe28d6382b530f291f644/1000x1000-000000-80-0-0.jpg	186	6	2008-08-05	ep	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
563	519819842	Raw Talk	138	https://cdn-images.dzcdn.net/images/cover/8ae8c78a0aa29e4218c579833e1053bc/1000x1000-000000-80-0-0.jpg	186	1	2009-11-09	single	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
564	873183392	Evening Wear	560	https://cdn-images.dzcdn.net/images/cover/e89a339b47b90bf5e1201b93dc16f04f/1000x1000-000000-80-0-0.jpg	186	3	2026-01-28	single	2026-07-09 18:30:55.90618	2026-07-09 18:30:55.90618
578	351619137	Sleeping With Ghosts	2790	https://cdn-images.dzcdn.net/images/cover/2eed7f87482c120dafa45ddc78b91a36/1000x1000-000000-80-0-0.jpg	332	12	2006-08-14	album	2026-07-10 10:54:19.951008	2026-07-10 10:54:23.221083
591	352364437	Black Market Music	3047	https://cdn-images.dzcdn.net/images/cover/dc88f8dcfcdec049a854a65fbdd9f4fc/1000x1000-000000-80-0-0.jpg	332	13	2000-10-09	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
577	352412657	Without You I'm Nothing	3439	https://cdn-images.dzcdn.net/images/cover/704fc1d3226cbe373dfd6c00345f16f9/1000x1000-000000-80-0-0.jpg	332	13	1998-10-12	album	2026-07-10 10:54:19.951008	2026-07-10 10:54:23.221083
592	352769807	Without You I'm Nothing: B-Sides	2685	https://cdn-images.dzcdn.net/images/cover/b43f05c735df1dcd91f11340ec68ba76/1000x1000-000000-80-0-0.jpg	332	10	2015-09-25	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
593	352412367	Placebo	3014	https://cdn-images.dzcdn.net/images/cover/584d2d300c0cffa05b657689c05e96fe/1000x1000-000000-80-0-0.jpg	332	11	1996-06-17	album	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
594	353509337	Without You I'm Nothing	1752	https://cdn-images.dzcdn.net/images/cover/30d70c546a93869e266963519f39391d/1000x1000-000000-80-0-0.jpg	332	4	1999-08-16	ep	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
595	353496637	Life's What You Make It	1558	https://cdn-images.dzcdn.net/images/cover/49ffb398bfd6cb68c1028cba276850df/1000x1000-000000-80-0-0.jpg	332	6	2016-10-07	ep	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
596	985775861	Nancy Boy (RE:CREATED VERSION)	210	https://cdn-images.dzcdn.net/images/cover/66da6939132b39a62363dc180eb0ebb5/1000x1000-000000-80-0-0.jpg	332	1	2026-06-05	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
597	962263211	Lady of the Flowers (RE:CREATED VERSION)	288	https://cdn-images.dzcdn.net/images/cover/e941554533fcee919b63250209cce478/1000x1000-000000-80-0-0.jpg	332	1	2026-05-01	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
598	938261301	Bruise Pristine (RE:CREATED VERSION)	216	https://cdn-images.dzcdn.net/images/cover/9953a3df2e856077ca2d5b6d9af5e1b6/1000x1000-000000-80-0-0.jpg	332	1	2026-03-27	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
599	350369597	Shout	304	https://cdn-images.dzcdn.net/images/cover/48193ceca8fd8b2fc85a4a87a13ae81c/1000x1000-000000-80-0-0.jpg	332	1	2022-09-07	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
600	306491097	Never Let Me Go - Remixes	1182	https://cdn-images.dzcdn.net/images/cover/06f34355c4543a7c960b75ebdceecd6a/1000x1000-000000-80-0-0.jpg	332	3	2022-03-23	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
601	319820677	Happy Birthday in the Sky	1061	https://cdn-images.dzcdn.net/images/cover/7b54d05ed9bf6efbbd7587c9c6d08e50/1000x1000-000000-80-0-0.jpg	332	4	2022-03-04	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
602	319761117	Try Better Next Time	752	https://cdn-images.dzcdn.net/images/cover/cff03123df72a09b0a959f0aef3b88c3/1000x1000-000000-80-0-0.jpg	332	3	2022-01-11	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
603	319711317	Surrounded By Spies	564	https://cdn-images.dzcdn.net/images/cover/9e51f7fe848d641526783eeec2369e71/1000x1000-000000-80-0-0.jpg	332	2	2021-11-09	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
604	319273857	Beautiful James	248	https://cdn-images.dzcdn.net/images/cover/57ab66041c6a6c5e846aefece3db7331/1000x1000-000000-80-0-0.jpg	332	1	2021-09-17	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
605	348087697	Life's What You Make It (Remixes)	714	https://cdn-images.dzcdn.net/images/cover/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	332	2	2017-10-20	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
606	351950827	Twenty Years	259	https://cdn-images.dzcdn.net/images/cover/ae6b1a10209ef716ca8ec1dd547670ab/1000x1000-000000-80-0-0.jpg	332	1	2016-08-04	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
607	351950697	Without You I'm Nothing	256	https://cdn-images.dzcdn.net/images/cover/e99134eb4f346af79d1667ea06575885/1000x1000-000000-80-0-0.jpg	332	1	1999-08-16	single	2026-07-10 10:54:23.221083	2026-07-10 10:54:23.221083
608	43833881	The New America	2816	https://cdn-images.dzcdn.net/images/cover/340bd9145fb4e84b505c11f1789834b2/1000x1000-000000-80-0-0.jpg	377	15	2008-08-25	album	2026-07-11 10:30:55.336221	2026-07-11 10:30:55.336221
609	107858	Stankonia	4401	https://cdn-images.dzcdn.net/images/cover/646d6414a24faaccf67c1d7e01f7d095/1000x1000-000000-80-0-0.jpg	383	24	2000-10-31	album	2026-07-11 15:22:38.733748	2026-07-11 15:22:38.733748
610	569874311	6.Ila	202	https://cdn-images.dzcdn.net/images/cover/a50d4e6197d56b24a8381eca2e580de7/1000x1000-000000-80-0-0.jpg	384	1	2019-03-17	single	2026-07-11 15:22:38.733748	2026-07-11 15:22:38.733748
611	564798072	Du bruit dans la tête	2311	https://cdn-images.dzcdn.net/images/cover/8419aad85333fd1d7a4a7a6adfd8a589/1000x1000-000000-80-0-0.jpg	385	15	2024-04-08	album	2026-07-11 15:22:38.733748	2026-07-11 15:22:38.733748
612	75123252	Suburban	692	https://cdn-images.dzcdn.net/images/cover/e8df2a82fc7198cbe9b2007cb7a3181e/1000x1000-000000-80-0-0.jpg	380	4	2018-10-07	ep	2026-07-11 15:22:38.733748	2026-07-11 15:22:38.733748
613	821345821	MSI	96	https://cdn-images.dzcdn.net/images/cover/77ba26ffa1e1e818be0456bfbcc2e005/1000x1000-000000-80-0-0.jpg	386	1	2025-09-18	single	2026-07-11 15:22:38.733748	2026-07-11 15:22:38.733748
614	226383	Dynasty	2320	https://cdn-images.dzcdn.net/images/cover/22abb990857654105f908a558ea78bc1/1000x1000-000000-80-0-0.jpg	387	9	1997-08-25	album	2026-07-11 15:22:57.648504	2026-07-11 15:22:57.648504
615	960860881	First Light	204	https://cdn-images.dzcdn.net/images/cover/6f91210db2e594848ef5b609a98de9b5/1000x1000-000000-80-0-0.jpg	388	1	2026-04-16	single	2026-07-11 15:22:57.648504	2026-07-11 15:22:57.648504
616	1335314	Talk That Talk (Deluxe)	2943	https://cdn-images.dzcdn.net/images/cover/5199f89d5113a83b5086463d5d0c9415/1000x1000-000000-80-0-0.jpg	389	14	2011-11-21	album	2026-07-11 15:22:57.648504	2026-07-11 15:22:57.648504
617	6168389	Nothing but the Beat (Ultimate Edition)	5794	https://cdn-images.dzcdn.net/images/cover/52330286cb5008805253fd77c7111d3f/1000x1000-000000-80-0-0.jpg	390	29	2012-12-07	album	2026-07-11 15:22:57.648504	2026-07-11 15:22:57.648504
618	1167403	Hands All Over (Revised International Deluxe)	3916	https://cdn-images.dzcdn.net/images/cover/86fb42ca017f0266d0885c1bede988bf/1000x1000-000000-80-0-0.jpg	69	19	2011-07-11	album	2026-07-11 15:22:57.648504	2026-07-11 15:22:57.648504
619	374937097	Out of the Hole	186	https://cdn-images.dzcdn.net/images/cover/a98c5495c28a25cfdf8f41f13099357e/1000x1000-000000-80-0-0.jpg	391	1	2022-11-30	single	2026-07-11 15:28:03.477571	2026-07-11 15:28:03.477571
620	471976625	Stage 30	1784	https://cdn-images.dzcdn.net/images/cover/14970e95249d6b4104b9d1f54fc370d1/1000x1000-000000-80-0-0.jpg	392	13	2023-07-29	album	2026-07-11 15:28:03.477571	2026-07-11 15:28:03.477571
621	375181977	Human Fly	200	https://cdn-images.dzcdn.net/images/cover/7e7725facbea2a6017db08325f1b35d9/1000x1000-000000-80-0-0.jpg	391	1	2022-12-12	single	2026-07-11 15:28:03.477571	2026-07-11 15:28:03.477571
622	502670021	I Woke Up A ROCKSTAR! ++	1987	https://cdn-images.dzcdn.net/images/cover/0f585eca288fb3d53b89d3d717c14ee7/1000x1000-000000-80-0-0.jpg	393	13	2023-10-20	album	2026-07-11 15:28:03.477571	2026-07-11 15:28:03.477571
623	885138262	##MongolianChopSquad	780	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	394	6	2025-12-26	ep	2026-07-11 15:28:03.477571	2026-07-11 15:28:03.477571
624	195997952	Blight of Nature	250	https://cdn-images.dzcdn.net/images/cover/f6d674de8db24cd96cb34663e96be834/1000x1000-000000-80-0-0.jpg	391	1	2021-01-07	single	2026-07-11 15:28:04.386146	2026-07-11 15:28:04.386146
625	479895235	Mongolian Chop Squad	145	https://cdn-images.dzcdn.net/images/cover/8d609bedaf0b46ff346ee4143a89faa5/1000x1000-000000-80-0-0.jpg	393	1	2023-08-30	single	2026-07-11 15:28:04.386146	2026-07-11 15:28:04.386146
626	425026577	Babystar	205	https://cdn-images.dzcdn.net/images/cover/9239134d2069d9584d0dc978fb943550/1000x1000-000000-80-0-0.jpg	395	1	2023-04-04	single	2026-07-11 15:28:04.386146	2026-07-11 15:28:04.386146
627	941137291	Malencunia	208	https://cdn-images.dzcdn.net/images/cover/8bae2b12930ec520454f13df0738b419/1000x1000-000000-80-0-0.jpg	401	1	2026-03-27	single	2026-07-11 18:08:20.692892	2026-07-11 18:08:20.692892
628	7875017	Alla riva del mare	2834	https://cdn-images.dzcdn.net/images/cover/a8bd2e4250a873580b00c6e8d74c0e98/1000x1000-000000-80-0-0.jpg	402	10	2002-06-01	album	2026-07-11 18:08:20.692892	2026-07-11 18:08:20.692892
629	8664381	The Best Of Yugopolis (Maleńczuk / Kukiz / Piekarczyk / Muniek I Inni)	2885	https://cdn-images.dzcdn.net/images/cover/e14473922faec2d2774460027125a562/1000x1000-000000-80-0-0.jpg	403	13	2014-09-08	album	2026-07-11 18:08:20.692892	2026-07-11 18:08:20.692892
630	492529071	2012	3562	https://cdn-images.dzcdn.net/images/cover/bb35c40d0a504b69ec4fd8a3180168ae/1000x1000-000000-80-0-0.jpg	403	15	2023-09-25	album	2026-07-11 18:08:20.692892	2026-07-11 18:08:20.692892
631	48866062	Maleńczuk Gra Młynarskiego	2923	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	396	12	2017-10-13	album	2026-07-11 18:08:22.061565	2026-07-11 18:08:22.061565
632	15238013	Koledzy	3643	https://cdn-images.dzcdn.net/images/cover/e95fcdcbb4a60bee3ec11d541711668e/1000x1000-000000-80-0-0.jpg	396	17	2007-05-07	album	2026-07-11 18:08:22.061565	2026-07-11 18:08:22.061565
633	1351646	Live	6561	https://cdn-images.dzcdn.net/images/cover/f889d16e364e9255fa360ef01260d8aa/1000x1000-000000-80-0-0.jpg	398	24	2010-06-28	album	2026-07-11 18:08:22.061565	2026-07-11 18:08:22.061565
635	175283882	Klauzula sumienia	3120	https://cdn-images.dzcdn.net/images/cover/5f31b26d06c630efac83e360649dc188/1000x1000-000000-80-0-0.jpg	396	12	2020-10-02	album	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
642	72040062	French Love	244	https://cdn-images.dzcdn.net/images/cover/57f7d2355002fbbd9876710060fd57cd/1000x1000-000000-80-0-0.jpg	396	1	2018-09-05	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
643	72040342	Ant	192	https://cdn-images.dzcdn.net/images/cover/ba1f3db8c5127540b5d498e4946d2e93/1000x1000-000000-80-0-0.jpg	396	1	2018-09-05	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
644	48964362	Mam Coś Zaśpiewać O Cyrku	218	https://cdn-images.dzcdn.net/images/cover/28ea5682f3451ff649f8adf119f18afb/1000x1000-000000-80-0-0.jpg	396	1	2017-10-02	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
645	45787782	Żniwna Dziewczyna	221	https://cdn-images.dzcdn.net/images/cover/6ea6860ad2f30c836ec6652e276462e5/1000x1000-000000-80-0-0.jpg	396	1	2017-08-16	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
646	14253324	Kazdy Dziad	186	https://cdn-images.dzcdn.net/images/cover/b7b5477ddc73efa9673b8eeb32122bb6/1000x1000-000000-80-0-0.jpg	396	1	2016-10-10	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
647	12519712	Paris	233	https://cdn-images.dzcdn.net/images/cover/f981da5632f0174326d1ac63cf2b00bb/1000x1000-000000-80-0-0.jpg	396	1	2016-02-29	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
648	12519716	Tell Me That You Want Me	186	https://cdn-images.dzcdn.net/images/cover/f981da5632f0174326d1ac63cf2b00bb/1000x1000-000000-80-0-0.jpg	396	1	2016-02-29	single	2026-07-11 18:09:27.151058	2026-07-11 18:09:27.151058
649	996055241	Пострадянська доба	160	https://cdn-images.dzcdn.net/images/cover/f598fba52bb7095826908acbd7e8bb8d/1000x1000-000000-80-0-0.jpg	208	1	2026-06-19	single	2026-07-12 08:22:42.434021	2026-07-12 08:22:45.676283
650	930884601	Порожні вікна	168	https://cdn-images.dzcdn.net/images/cover/f62b4878271b43acdc3182f610ea36cf/1000x1000-000000-80-0-0.jpg	208	1	2026-03-20	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
651	858328612	Серед хаосу	152	https://cdn-images.dzcdn.net/images/cover/754b04acc171fadbdea16f7749536afd/1000x1000-000000-80-0-0.jpg	208	1	2025-12-05	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
652	845042052	Забуття/Oblivion	188	https://cdn-images.dzcdn.net/images/cover/a441d7830210d776c23080a720ef4eaa/1000x1000-000000-80-0-0.jpg	208	1	2025-11-14	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
653	822125271	Ти моє щастя	147	https://cdn-images.dzcdn.net/images/cover/fb10783ac335b5779192e8762e347d79/1000x1000-000000-80-0-0.jpg	208	1	2025-10-10	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
654	807817681	Девʼять поверхів	171	https://cdn-images.dzcdn.net/images/cover/5ca0718b2431aef65872372b08b3a414/1000x1000-000000-80-0-0.jpg	208	1	2025-09-05	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
655	745406001	Потопельник	184	https://cdn-images.dzcdn.net/images/cover/6f673177861c09f4781f380c0076bf6f/1000x1000-000000-80-0-0.jpg	208	1	2025-05-02	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
656	723462901	Смерті не існує	154	https://cdn-images.dzcdn.net/images/cover/a3935457f9d1f2e24303c88775a02c1b/1000x1000-000000-80-0-0.jpg	208	1	2025-03-21	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
657	702770041	Стабільність	130	https://cdn-images.dzcdn.net/images/cover/2e60ad2fc917d735fbc7302412482594/1000x1000-000000-80-0-0.jpg	208	1	2025-02-07	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
658	687812881	Загублені	194	https://cdn-images.dzcdn.net/images/cover/fc749f728fdaeb3fc6a921b9339a7e1d/1000x1000-000000-80-0-0.jpg	208	1	2025-01-10	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
659	661555141	Егоїст	151	https://cdn-images.dzcdn.net/images/cover/534ac492440395d5c0d1d3e0ea20e2bc/1000x1000-000000-80-0-0.jpg	208	1	2024-11-08	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
660	647133161	Гул	226	https://cdn-images.dzcdn.net/images/cover/ef81744825afaaadecdc11d72c8cd2dd/1000x1000-000000-80-0-0.jpg	208	1	2024-10-04	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
661	636106981	Я бачу тебе	120	https://cdn-images.dzcdn.net/images/cover/aafcedfec1b797e7cf297c756c0bfb6e/1000x1000-000000-80-0-0.jpg	208	1	2024-09-06	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
662	622027731	Не для нас	171	https://cdn-images.dzcdn.net/images/cover/a3503762fb2d9dec07b84efc1a02db0b/1000x1000-000000-80-0-0.jpg	208	1	2024-08-09	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
663	604478672	Після нас	186	https://cdn-images.dzcdn.net/images/cover/68f0d18d0935c5e6e33f6c0f0da4924a/1000x1000-000000-80-0-0.jpg	208	1	2024-07-05	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
664	583286012	Тіні	145	https://cdn-images.dzcdn.net/images/cover/1b4657344c54cf84ee34b920bf515393/1000x1000-000000-80-0-0.jpg	208	1	2024-05-24	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
665	563273002	Байдужий	120	https://cdn-images.dzcdn.net/images/cover/a436514d03b413f4d354f504bd927d57/1000x1000-000000-80-0-0.jpg	208	1	2024-03-29	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
666	543025242	Не прокинусь	201	https://cdn-images.dzcdn.net/images/cover/6265b5a45ad69e92224951d76307ea6b/1000x1000-000000-80-0-0.jpg	208	1	2024-02-16	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
667	532404152	Тихо	201	https://cdn-images.dzcdn.net/images/cover/bdfeda6f086b2f4df6c0e21bf12c0edf/1000x1000-000000-80-0-0.jpg	208	1	2024-01-19	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
668	505598331	Під дощем	137	https://cdn-images.dzcdn.net/images/cover/fde9f6473b9d9fdd6f57692192c8f737/1000x1000-000000-80-0-0.jpg	208	1	2023-11-10	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
669	493810391	Вдячність	108	https://cdn-images.dzcdn.net/images/cover/ef65828c6e6759a4439ca3bcf3492490/1000x1000-000000-80-0-0.jpg	208	1	2023-09-13	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
670	478699585	Зорі	170	https://cdn-images.dzcdn.net/images/cover/9cfd4a58b1af97cf9743ad17c24ea459/1000x1000-000000-80-0-0.jpg	208	1	2023-09-01	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
671	465510605	Падаю вниз	178	https://cdn-images.dzcdn.net/images/cover/9e597236f19361af5ea0a00a195fb8d8/1000x1000-000000-80-0-0.jpg	208	1	2023-07-28	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
672	454286055	Шрам	269	https://cdn-images.dzcdn.net/images/cover/0a4d7357efc04d6a9c2a786c212a64ba/1000x1000-000000-80-0-0.jpg	208	2	2023-06-30	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
673	404041237	Магнітофон	142	https://cdn-images.dzcdn.net/images/cover/74c249bb2048acc98583be0087864a5e/1000x1000-000000-80-0-0.jpg	208	1	2023-02-10	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
674	415556247	Обійме	189	https://cdn-images.dzcdn.net/images/cover/3271d67e8adeb68fdeca79599005e658/1000x1000-000000-80-0-0.jpg	208	1	2023-02-10	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
675	373985467	Мертві теж кохають	156	https://cdn-images.dzcdn.net/images/cover/2774ddc5d08e4688f9e8fd29ebe61d21/1000x1000-000000-80-0-0.jpg	208	1	2022-11-18	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
676	360603737	Я б зіграв	194	https://cdn-images.dzcdn.net/images/cover/3aebbecaff08f8096f7e5f60b6b59da2/1000x1000-000000-80-0-0.jpg	208	1	2022-10-01	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
677	349786637	Тліє	128	https://cdn-images.dzcdn.net/images/cover/742d81154addc72b21da60954abefa51/1000x1000-000000-80-0-0.jpg	208	1	2022-08-31	single	2026-07-12 08:22:45.676283	2026-07-12 08:22:45.676283
678	213693792	Zabierz tę miłość (Storytel "Random")	249	https://cdn-images.dzcdn.net/images/cover/a088f234fc54ab8f2e8b91b61f3d95da/1000x1000-000000-80-0-0.jpg	404	1	2021-03-23	single	2026-07-12 08:22:58.412579	2026-07-12 08:22:58.412579
679	967535001	Z Tobą być (love u like that)	160	https://cdn-images.dzcdn.net/images/cover/3f3d8b5e845ac6ef3a13e86294fdfd92/1000x1000-000000-80-0-0.jpg	405	1	2026-04-29	single	2026-07-12 08:22:58.412579	2026-07-12 08:22:58.412579
680	90892102	Necropolis	2889	https://cdn-images.dzcdn.net/images/cover/ffb04a3bc4868f4bc2499e0da96b3501/1000x1000-000000-80-0-0.jpg	406	15	2009-08-23	album	2026-07-12 08:22:58.412579	2026-07-12 08:22:58.412579
681	1013396841	Maciej Zieliński: V Symphony	3742	https://cdn-images.dzcdn.net/images/cover/fe8c1e995960e31033ae10c03ba94375/1000x1000-000000-80-0-0.jpg	407	8	2026-06-26	album	2026-07-12 08:22:59.496421	2026-07-12 08:22:59.496421
682	339318097	Marianna	2553	https://cdn-images.dzcdn.net/images/cover/398123b5da5d814c662eae812cca1674/1000x1000-000000-80-0-0.jpg	408	7	2022-09-16	album	2026-07-12 08:22:59.496421	2026-07-12 08:22:59.496421
683	968087131	Damion	2368	https://cdn-images.dzcdn.net/images/cover/df80d732159b6fb99ad0b1831b68cf70/1000x1000-000000-80-0-0.jpg	408	7	2026-05-15	album	2026-07-12 08:22:59.496421	2026-07-12 08:22:59.496421
684	858830922	Anthology 4	4718	https://cdn-images.dzcdn.net/images/cover/ad1658e4784cac89161d5151be746dca/1000x1000-000000-80-0-0.jpg	286	36	2025-11-21	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
685	860363782	Anthology Collection	2690	https://cdn-images.dzcdn.net/images/cover/cda71e62442527b52d19ba0f2272cc76/1000x1000-000000-80-0-0.jpg	286	191	2025-11-21	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
686	290309452	Get Back (Rooftop Performance)	2311	https://cdn-images.dzcdn.net/images/cover/df4709ee7d571b75f46923992d6b77e5/1000x1000-000000-80-0-0.jpg	286	10	2022-01-28	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
687	67272022	On Air - Live At The BBC (Vol.2)	2337	https://cdn-images.dzcdn.net/images/cover/f373112f2894bda5888c4db7db104825/1000x1000-000000-80-0-0.jpg	286	63	2018-07-06	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
688	13367057	Love	4620	https://cdn-images.dzcdn.net/images/cover/35621b78e11aeeca37f6fa275100482f/1000x1000-000000-80-0-0.jpg	286	28	2016-06-17	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
689	59393282	Let It Be... Naked (Remastered)	2101	https://cdn-images.dzcdn.net/images/cover/efacd27f64a06aa8dae8de0dea7f0ac4/1000x1000-000000-80-0-0.jpg	286	11	2018-03-23	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
690	59393272	Yellow Submarine Songtrack	2723	https://cdn-images.dzcdn.net/images/cover/b97e8cbe4179bedc313f179f7535093f/1000x1000-000000-80-0-0.jpg	286	15	2018-03-23	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
691	12779758	Anthology 3	4115	https://cdn-images.dzcdn.net/images/cover/be01f37a129aa4c004d4bb755d6caa92/1000x1000-000000-80-0-0.jpg	286	50	2016-04-04	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
692	12779756	Anthology 2	3794	https://cdn-images.dzcdn.net/images/cover/a08f99ba94e5e2c4e816ac9d4a449500/1000x1000-000000-80-0-0.jpg	286	45	2016-04-04	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
693	806862611	Anthology 2	3794	https://cdn-images.dzcdn.net/images/cover/3cec05ed7cc48f298a188085de602637/1000x1000-000000-80-0-0.jpg	286	45	2025-08-21	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
694	12779760	Anthology 1	2690	https://cdn-images.dzcdn.net/images/cover/6af301bd77dca5bdb99855ab775eb6c9/1000x1000-000000-80-0-0.jpg	286	60	2016-04-04	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
695	67271332	Live At The BBC (Remastered)	2762	https://cdn-images.dzcdn.net/images/cover/72bfd28bbd4c3dd8cd336a4763b409f8/1000x1000-000000-80-0-0.jpg	286	71	2018-07-06	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
696	12047968	Past Masters (Vols. 1 & 2 / Remastered)	3853	https://cdn-images.dzcdn.net/images/cover/9d135ceacc863223f662c3d5954a66b1/1000x1000-000000-80-0-0.jpg	286	33	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
697	7243440	The Early Tapes Of	2409	https://cdn-images.dzcdn.net/images/cover/51609541d82c33bb48f34c938550e702/1000x1000-000000-80-0-0.jpg	286	14	1993-01-01	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
698	13994298	Live At The Hollywood Bowl	2607	https://cdn-images.dzcdn.net/images/cover/ee8392c4f323ec5d803feb3903990beb/1000x1000-000000-80-0-0.jpg	286	17	2016-09-09	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
699	12047930	The Beatles 1967 - 1970 (Remastered)	5258	https://cdn-images.dzcdn.net/images/cover/32b6b5174e633cd6d182d00024dddcb5/1000x1000-000000-80-0-0.jpg	286	28	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
700	12047932	The Beatles 1962 - 1966 (Remastered)	3544	https://cdn-images.dzcdn.net/images/cover/45591b70e9b45e897dd7b65b54825c47/1000x1000-000000-80-0-0.jpg	286	26	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
701	510095571	The Beatles 1962 – 1966 (2023 Edition)	3668	https://cdn-images.dzcdn.net/images/cover/e679057d276b04a2b64dafc26c7b84a7/1000x1000-000000-80-0-0.jpg	286	38	2023-11-10	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
702	510095581	The Beatles 1967 – 1970 (2023 Edition)	5295	https://cdn-images.dzcdn.net/images/cover/346169e46cb9869b52165dabfdd9605b/1000x1000-000000-80-0-0.jpg	286	37	2023-11-10	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
703	264255742	Let It Be (Super Deluxe)	4403	https://cdn-images.dzcdn.net/images/cover/2acdd7fbc5f3f36f415c8ebe9d8c20cd/1000x1000-000000-80-0-0.jpg	286	57	2021-10-15	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
704	112126942	Abbey Road (Super Deluxe Edition)	4676	https://cdn-images.dzcdn.net/images/cover/cb1291c76d83e54e03ea17e53df99cf2/1000x1000-000000-80-0-0.jpg	286	40	2019-09-27	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
705	12047964	Yellow Submarine (Remastered)	2364	https://cdn-images.dzcdn.net/images/cover/c105ffd0f6855c565cd3a0be47a1ee31/1000x1000-000000-80-0-0.jpg	286	13	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
706	77649352	The Beatles (White Album / Super Deluxe)	4394	https://cdn-images.dzcdn.net/images/cover/b8970772e00c2289e3aecef089589dbf/1000x1000-000000-80-0-0.jpg	286	107	2018-11-09	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
707	12047938	Magical Mystery Tour (Remastered)	2176	https://cdn-images.dzcdn.net/images/cover/4eb13af46f92a16e907745448ff91c70/1000x1000-000000-80-0-0.jpg	286	11	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
708	41838521	Sgt. Pepper's Lonely Hearts Club Band (Deluxe Edition)	4726	https://cdn-images.dzcdn.net/images/cover/8ab1bc093a405049ca5cdc0e305b482a/1000x1000-000000-80-0-0.jpg	286	31	2017-05-26	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
709	73301852	Sgt. Pepper's Lonely Hearts Club Band (Super Deluxe Edition)	4640	https://cdn-images.dzcdn.net/images/cover/0ab6b0d667820e425cf195835b4a5fb3/1000x1000-000000-80-0-0.jpg	286	65	2018-09-21	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
710	370690567	Revolver (Super Deluxe)	4009	https://cdn-images.dzcdn.net/images/cover/bade219a19f51f3ea01b159bc6b36498/1000x1000-000000-80-0-0.jpg	286	63	2022-10-28	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
711	12047936	Rubber Soul (Remastered 2009)	2114	https://cdn-images.dzcdn.net/images/cover/da80520440d5d29876b9df3e375793b5/1000x1000-000000-80-0-0.jpg	286	14	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
712	12047944	Help! (Remastered)	2015	https://cdn-images.dzcdn.net/images/cover/44f87ff491af981fd129b6d159f47b96/1000x1000-000000-80-0-0.jpg	286	14	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
713	12047946	Beatles For Sale (Remastered)	2005	https://cdn-images.dzcdn.net/images/cover/3c1ebf7765293ec02d3aa124aadb258c/1000x1000-000000-80-0-0.jpg	286	14	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
714	12047962	With The Beatles (Remastered)	1967	https://cdn-images.dzcdn.net/images/cover/43504743d2efb7092130f1e2340e1ffa/1000x1000-000000-80-0-0.jpg	286	14	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
715	12047942	Please Please Me (Remastered)	1919	https://cdn-images.dzcdn.net/images/cover/03a4debd84fd2769cf1beb7c2e7c40a4/1000x1000-000000-80-0-0.jpg	286	14	2015-12-24	album	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
716	852770112	In My Life (Take 1)	160	https://cdn-images.dzcdn.net/images/cover/ad1658e4784cac89161d5151be746dca/1000x1000-000000-80-0-0.jpg	286	1	2025-11-15	single	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
717	839768132	I've Just Seen A Face (Take 3)	144	https://cdn-images.dzcdn.net/images/cover/ad1658e4784cac89161d5151be746dca/1000x1000-000000-80-0-0.jpg	286	1	2025-10-24	single	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
718	829925211	While My Guitar Gently Weeps (Third Version - Take 27)	196	https://cdn-images.dzcdn.net/images/cover/ad1658e4784cac89161d5151be746dca/1000x1000-000000-80-0-0.jpg	286	1	2025-10-03	single	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
719	820199271	Helter Skelter (Second Version - Take 17)	217	https://cdn-images.dzcdn.net/images/cover/ad1658e4784cac89161d5151be746dca/1000x1000-000000-80-0-0.jpg	286	1	2025-09-19	single	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
720	806861311	Free As A Bird (2025 Mix)	266	https://cdn-images.dzcdn.net/images/cover/ad1658e4784cac89161d5151be746dca/1000x1000-000000-80-0-0.jpg	286	1	2025-08-21	single	2026-07-12 08:33:43.554007	2026-07-12 08:33:43.554007
721	576666061	WORK	201	https://cdn-images.dzcdn.net/images/cover/842b6981905706f21b1411801714e5f3/1000x1000-000000-80-0-0.jpg	414	1	2023-04-01	single	2026-07-13 09:32:59.444391	2026-07-13 09:32:59.444391
722	64184022	Reimport Vol.2 Civil Aviation Bureau	2597	https://cdn-images.dzcdn.net/images/cover/65a014c2247a839964bbc3627d3876de/1000x1000-000000-80-0-0.jpg	409	11	2018-05-27	album	2026-07-13 09:32:59.444391	2026-07-13 09:32:59.444391
723	1020194491	naked	197	https://cdn-images.dzcdn.net/images/cover/f2bbf239b1cda8d5c3cc6b26449587a3/1000x1000-000000-80-0-0.jpg	409	1	2026-07-10	single	2026-07-13 09:32:59.444391	2026-07-13 09:32:59.444391
724	118144942	Apple Of Universal Gravity	6044	https://cdn-images.dzcdn.net/images/cover/fdbff2a426d6138a067806a5c2d3c736/1000x1000-000000-80-0-0.jpg	409	30	2019-11-13	album	2026-07-13 09:32:59.444391	2026-07-13 09:32:59.444391
725	932052601	forbidden	2538	https://cdn-images.dzcdn.net/images/cover/7925ce48499657b150d7457141b27e35/1000x1000-000000-80-0-0.jpg	409	11	2026-03-11	album	2026-07-13 09:33:00.351371	2026-07-13 09:33:00.351371
726	64184242	Shouso Strip -Winning Strip-	3351	https://cdn-images.dzcdn.net/images/cover/7f3d8c2859008d28143c57e10dec6899/1000x1000-000000-80-0-0.jpg	409	13	2018-05-27	album	2026-07-13 09:33:00.351371	2026-07-13 09:33:00.351371
727	64184292	Heisei Fuuzoku -Japanese Manners-	3148	https://cdn-images.dzcdn.net/images/cover/27a0de9715bb8e20060d72233c3f3297/1000x1000-000000-80-0-0.jpg	409	13	2018-05-27	album	2026-07-13 09:33:04.4575	2026-07-13 09:33:04.4575
728	591127272	Carnival	2644	https://cdn-images.dzcdn.net/images/cover/d72fb55efe9ced3f35b7195db9eaa48f/1000x1000-000000-80-0-0.jpg	409	13	2024-05-28	album	2026-07-13 09:33:05.244278	2026-07-13 09:33:05.244278
729	64184222	Karuki Zahmen Kuri No Hana -Kalk Samen Chestnut Flower-	2693	https://cdn-images.dzcdn.net/images/cover/d176017fdca35e76f715249f54cecedc/1000x1000-000000-80-0-0.jpg	409	11	2008-06-27	album	2026-07-13 09:33:05.244278	2026-07-13 09:33:05.244278
730	64184372	Muzai Moratorium -Innocence Moratorium-	2453	https://cdn-images.dzcdn.net/images/cover/998fe24a29474d982f666006703c1225/1000x1000-000000-80-0-0.jpg	409	11	2015-01-21	album	2026-07-13 09:33:05.244278	2026-07-13 09:33:05.244278
731	235606532	Cadillac	177	https://cdn-images.dzcdn.net/images/cover/323dae988c88cda6b6b90fd7b0bc0f71/1000x1000-000000-80-0-0.jpg	418	1	2020-06-09	single	2026-07-14 11:32:33.50345	2026-07-14 11:32:33.50345
732	234201482	LEGENDARNAJa PYL'	1251	https://cdn-images.dzcdn.net/images/cover/c05bc7d37f1bca6c8f9d5b9d18adb9f5/1000x1000-000000-80-0-0.jpg	418	10	2020-01-17	album	2026-07-14 11:32:33.50345	2026-07-14 11:32:33.50345
733	234203842	Cristal & MOYOT	137	https://cdn-images.dzcdn.net/images/cover/c011ffbe3a5a78892f86c21b53c7e01f/1000x1000-000000-80-0-0.jpg	418	1	2020-12-28	single	2026-07-14 11:32:33.50345	2026-07-14 11:32:33.50345
734	443392825	ПОЙДЕТ	120	https://cdn-images.dzcdn.net/images/cover/8b3349e4784a7328478c7bb0f511047b/1000x1000-000000-80-0-0.jpg	418	1	2023-05-19	single	2026-07-14 11:32:33.50345	2026-07-14 11:32:33.50345
735	401259017	El Problema	136	https://cdn-images.dzcdn.net/images/cover/4eaac630af063ac7acec9094068cdefc/1000x1000-000000-80-0-0.jpg	418	1	2020-09-18	single	2026-07-14 11:32:33.50345	2026-07-14 11:32:33.50345
736	234203972	ICE	126	https://cdn-images.dzcdn.net/images/cover/f7c69b09e3793553fb9713432099f95c/1000x1000-000000-80-0-0.jpg	418	1	2020-07-31	single	2026-07-14 11:32:34.39537	2026-07-14 11:32:34.39537
737	150939192	Улыбнись, дурак!	1277	https://cdn-images.dzcdn.net/images/cover/2b4ea8bb898a9b2755bd23f7d4eb775d/1000x1000-000000-80-0-0.jpg	418	7	2018-12-12	album	2026-07-14 11:32:34.39537	2026-07-14 11:32:34.39537
738	712778521	ALISHER	774	https://cdn-images.dzcdn.net/images/cover/3b8f501a672c36d1f916ac67775e72b1/1000x1000-000000-80-0-0.jpg	418	5	2025-02-14	ep	2026-07-14 11:32:34.39537	2026-07-14 11:32:34.39537
739	755626131	Morgen	190	https://cdn-images.dzcdn.net/images/cover/5e1ff11c8690c36ed742a599f8348402/1000x1000-000000-80-0-0.jpg	423	1	2025-05-23	single	2026-07-14 11:32:58.443072	2026-07-14 11:32:58.443072
740	275438002	Mörge!	240	https://cdn-images.dzcdn.net/images/cover/4ff04fb191c33744a672251328494d66/1000x1000-000000-80-0-0.jpg	424	1	2021-11-26	single	2026-07-14 11:32:58.443072	2026-07-14 11:32:58.443072
741	86933072	Reise, Reise	2860	https://cdn-images.dzcdn.net/images/cover/633b009c486f17d1aef7fef6b1151201/1000x1000-000000-80-0-0.jpg	425	11	2005-04-25	album	2026-07-14 11:32:58.443072	2026-07-14 11:32:58.443072
742	928867111	Цветок	155	https://cdn-images.dzcdn.net/images/cover/043b0120458069b04312cd643177b9c1/1000x1000-000000-80-0-0.jpg	418	1	2026-03-06	single	2026-07-14 11:32:59.247695	2026-07-14 11:32:59.247695
743	354982377	BUGATTI	190	https://cdn-images.dzcdn.net/images/cover/ffe5fc3fcacda1e048530a71fc6c61c0/1000x1000-000000-80-0-0.jpg	426	1	2022-09-09	single	2026-07-14 11:32:59.247695	2026-07-14 11:32:59.247695
744	234300012	POSOSI	130	https://cdn-images.dzcdn.net/images/cover/a5d527a6893c6b9851ac984333f0059b/1000x1000-000000-80-0-0.jpg	418	1	2020-06-06	single	2026-07-14 11:32:59.247695	2026-07-14 11:32:59.247695
745	94555092	Morgens	1357	https://cdn-images.dzcdn.net/images/cover/8cae50357d26b10f04723aea98c9620d/1000x1000-000000-80-0-0.jpg	427	5	2019-04-26	ep	2026-07-14 11:33:19.508489	2026-07-14 11:33:19.508489
746	166295482	Morgensonne	1771	https://cdn-images.dzcdn.net/images/cover/1fa8cfda2ef6d27b41d75b028569c958/1000x1000-000000-80-0-0.jpg	428	11	2020-08-26	album	2026-07-14 11:33:19.508489	2026-07-14 11:33:19.508489
747	423561997	Morgens um vier	2478	https://cdn-images.dzcdn.net/images/cover/f093a55b320b502f2c303720a7136ab1/1000x1000-000000-80-0-0.jpg	429	10	2023-04-06	album	2026-07-14 11:33:19.508489	2026-07-14 11:33:19.508489
748	101618	Is This It	2136	https://cdn-images.dzcdn.net/images/cover/700f0375d5ac8570f16a2c7eb128303f/1000x1000-000000-80-0-0.jpg	126	11	2001-07-25	album	2026-07-15 08:21:06.161052	2026-07-15 08:21:06.161052
749	807818761	Live in Paris 2002	2929	https://cdn-images.dzcdn.net/images/cover/a79555895e5dd8f543fb196f962966b2/1000x1000-000000-80-0-0.jpg	126	14	2002-08-19	album	2026-07-15 08:21:06.161052	2026-07-15 08:21:06.161052
750	96730142	ARS003	1615	https://cdn-images.dzcdn.net/images/cover/e9da3e26c558bff8fae6226d3ec55d02/1000x1000-000000-80-0-0.jpg	432	4	2019-07-05	ep	2026-07-15 08:21:06.161052	2026-07-15 08:21:06.161052
751	349456487	Hard to Explain	216	https://cdn-images.dzcdn.net/images/cover/aad8375c844f26cf47e64898af595f2d/1000x1000-000000-80-0-0.jpg	433	1	2022-04-07	single	2026-07-15 08:21:06.161052	2026-07-15 08:21:06.161052
752	282148	Best Of Cowboy Junkies	4061	https://cdn-images.dzcdn.net/images/cover/c71a1b646c622fe7d0c3292bc4c1d089/1000x1000-000000-80-0-0.jpg	434	16	2001-09-10	album	2026-07-15 08:21:06.161052	2026-07-15 08:21:06.161052
753	647461321	Я вже не ти	162	https://cdn-images.dzcdn.net/images/cover/a87ea227fd69bcbddd59c2c7fe657de7/1000x1000-000000-80-0-0.jpg	312	1	2024-10-04	single	2026-07-19 10:22:07.637261	2026-07-19 10:22:07.637261
754	313389297	Туманы	2651	https://cdn-images.dzcdn.net/images/cover/2a8c5cc3dd4a075e967dc1513711ca13/1000x1000-000000-80-0-0.jpg	312	12	2016-10-07	album	2026-07-19 10:22:07.637261	2026-07-19 10:22:07.637261
755	262234302	Туманы	2659	https://cdn-images.dzcdn.net/images/cover/45c9c115b914ab0534e566714cc22cce/1000x1000-000000-80-0-0.jpg	312	12	2016-10-05	album	2026-07-19 10:22:07.637261	2026-07-19 10:22:07.637261
786	13726450	Encore	3158	https://cdn-images.dzcdn.net/images/cover/6a52e1bbddc750c996a66b0ccfa4370c/1000x1000-000000-80-0-0.jpg	435	14	2016-08-05	album	2026-07-19 13:35:28.225858	2026-07-19 13:35:28.225858
787	11674708	Purpose (Deluxe)	3979	https://cdn-images.dzcdn.net/images/cover/340283aafac320864b207c420124ee46/1000x1000-000000-80-0-0.jpg	236	18	2015-11-13	album	2026-07-19 13:35:28.225858	2026-07-19 13:35:28.225858
788	203600132	Killshot (Slowed + Reverb)	278	https://cdn-images.dzcdn.net/images/cover/23b8217031ed6b93d2a8068ed247625b/1000x1000-000000-80-0-0.jpg	100	1	2021-02-05	single	2026-07-24 13:48:29.261334	2026-07-24 13:48:29.261334
789	136107352	Killshot	236	https://cdn-images.dzcdn.net/images/cover/bfe8069fbbf5226c9c6e589c8a7504b4/1000x1000-000000-80-0-0.jpg	100	1	2019-10-30	single	2026-07-24 13:48:29.261334	2026-07-24 13:48:29.261334
790	796710841	Image	212	https://cdn-images.dzcdn.net/images/cover/a1e2df90b6ac6e57bfadb965d9aa503a/1000x1000-000000-80-0-0.jpg	100	1	2024-07-10	single	2026-07-24 13:48:29.261334	2026-07-24 13:48:29.261334
791	946798451	Imaginal Disk	3216	https://cdn-images.dzcdn.net/images/cover/9bf3fef533c09d8d2423883186cabc60/1000x1000-000000-80-0-0.jpg	100	15	2024-08-23	album	2026-07-24 13:48:30.163547	2026-07-24 13:48:30.163547
792	234682722	Mercurial World	2759	https://cdn-images.dzcdn.net/images/cover/87dd7911f7c37b2a90ce9dd2b9ff7d82/1000x1000-000000-80-0-0.jpg	100	14	2021-10-08	album	2026-07-24 13:48:30.163547	2026-07-24 13:48:30.163547
793	339165487	Mercurial World (Deluxe)	3797	https://cdn-images.dzcdn.net/images/cover/09630557a773f02305ce72fd401456c0/1000x1000-000000-80-0-0.jpg	100	28	2022-09-23	album	2026-07-24 13:48:30.163547	2026-07-24 13:48:30.163547
794	132257622	A Little Rhythm and a Wicked Feeling	1674	https://cdn-images.dzcdn.net/images/cover/7dbdeb762743a17610ba49753f1037e7/1000x1000-000000-80-0-0.jpg	100	8	2020-03-13	ep	2026-07-24 13:48:30.163547	2026-07-24 13:48:30.163547
795	383513	Awake	2525	https://cdn-images.dzcdn.net/images/cover/fce6fe4cf02a3c78cedb8eb32fa4fa31/1000x1000-000000-80-0-0.jpg	438	12	2009-08-21	album	2026-07-24 14:42:40.322153	2026-07-24 14:42:40.322153
796	943145961	Dead Man Walking	164	https://cdn-images.dzcdn.net/images/cover/e7f3b75a4710c53686f323e419223fb1/1000x1000-000000-80-0-0.jpg	436	1	2026-03-20	single	2026-07-24 14:42:40.322153	2026-07-24 14:42:40.322153
797	933651041	ANABIOS	2270	https://cdn-images.dzcdn.net/images/cover/139c56818176a31cd90081b33d32d09e/1000x1000-000000-80-0-0.jpg	441	13	2026-03-06	album	2026-07-24 14:42:40.322153	2026-07-24 14:42:40.322153
798	573610191	I Just Want To Dance	149	https://cdn-images.dzcdn.net/images/cover/df01892eba28751796d3e2c7c47b23ef/1000x1000-000000-80-0-0.jpg	442	1	2024-04-19	single	2026-07-24 14:42:40.322153	2026-07-24 14:42:40.322153
799	920188311	The Hunt	521	https://cdn-images.dzcdn.net/images/cover/2ff1d0421f771b90836cfc39ce572199/1000x1000-000000-80-0-0.jpg	436	4	2026-02-27	ep	2026-07-24 14:42:40.322153	2026-07-24 14:42:40.322153
800	574225461	The Rusty Trombone	173	https://cdn-images.dzcdn.net/images/cover/41553bddfb682262958b23f00cbdffea/1000x1000-000000-80-0-0.jpg	443	1	2024-05-17	single	2026-07-24 14:42:42.055445	2026-07-24 14:42:42.055445
801	425754977	Bach (Mandragora & Devochka Remix)	339	https://cdn-images.dzcdn.net/images/cover/051e6cc55ed73d5bfcc73a4aeb92114b/1000x1000-000000-80-0-0.jpg	449	1	2023-04-04	single	2026-08-07 12:26:39.190242	2026-08-07 12:26:39.190242
802	319173587	La Bachata	162	https://cdn-images.dzcdn.net/images/cover/88390e8360f6f28138ab200efd1f9a6f/1000x1000-000000-80-0-0.jpg	450	1	2022-05-26	single	2026-08-07 12:26:39.190242	2026-08-07 12:26:39.190242
803	123805302	Le professionnel (Bande originale du film)	3024	https://cdn-images.dzcdn.net/images/cover/bfcf260f3ca1eaea676a1f9f83927798/1000x1000-000000-80-0-0.jpg	451	25	1981-01-01	album	2026-08-07 12:26:39.190242	2026-08-07 12:26:39.190242
804	7020970	Bach	415	https://cdn-images.dzcdn.net/images/cover/aef04736b26bcc467800566619626655/1000x1000-000000-80-0-0.jpg	449	1	2013-10-24	single	2026-08-07 12:26:39.190242	2026-08-07 12:26:39.190242
805	1025522582	J.S. Bach: Air on the G String (Arr. Ólafsson for Piano from Orchestral Suite No. 3, BWV 1068)	\N	https://cdn-images.dzcdn.net/images/cover/cd9b42b2e7325fb63765b6748041767a/1000x1000-000000-80-0-0.jpg	447	\N	\N	\N	2026-08-07 12:26:52.032888	2026-08-07 12:26:52.032888
806	6585265	Bach, J.S.: Toccata and Fugue BWV 565; Organ Works BWV 572, 590, 532, 769 & 552	\N	https://cdn-images.dzcdn.net/images/cover/d16d40d8ebd347650af0c6e8627dfc99/1000x1000-000000-80-0-0.jpg	447	\N	\N	\N	2026-08-07 12:26:52.032888	2026-08-07 12:26:52.032888
807	71059322	Bach, J.S.: Sonata for Violin Solo No. 1 in G Minor, BWV 1001: 4. Presto	\N	https://cdn-images.dzcdn.net/images/cover/fbe0266937ade7b5610dfca4c98333b3/1000x1000-000000-80-0-0.jpg	447	\N	\N	\N	2026-08-07 12:26:52.032888	2026-08-07 12:26:52.032888
808	6472252	Bach, J.S.: Orchestral Works	\N	https://cdn-images.dzcdn.net/images/cover/9224b78e7f1a364c7ae5758c522ffd62/1000x1000-000000-80-0-0.jpg	447	\N	\N	\N	2026-08-07 12:26:52.032888	2026-08-07 12:26:52.032888
809	14283988	Bach	\N	https://cdn-images.dzcdn.net/images/cover/f2d02f45d84fccc0073da00698ccfeb3/1000x1000-000000-80-0-0.jpg	447	\N	\N	\N	2026-08-07 12:26:52.032888	2026-08-07 12:26:52.032888
810	91549082	Bach, JS: Violin Sonatas, BWV 1016 - 1019	3841	https://cdn-images.dzcdn.net/images/cover/e8d282ccf7ef470d5aec53f806843e25/1000x1000-000000-80-0-0.jpg	453	17	2019-03-27	album	2026-08-07 12:27:45.668934	2026-08-07 12:27:45.668934
811	1334743	Bach By Menuhin - Volume 1	2720	https://cdn-images.dzcdn.net/images/cover/bf38372e8557860687203f225d84ef78/1000x1000-000000-80-0-0.jpg	454	12	2006-01-10	album	2026-08-07 12:27:45.668934	2026-08-07 12:27:45.668934
812	613304832	Bach	3838	https://cdn-images.dzcdn.net/images/cover/ed497dcdf68b15c0542e492cb2d4ac1e/1000x1000-000000-80-0-0.jpg	455	25	2024-10-18	album	2026-08-07 12:27:45.668934	2026-08-07 12:27:45.668934
813	72168922	Johann Sebastian Bach	2800	https://cdn-images.dzcdn.net/images/cover/e1cb539536a6916a3a45d0151a4b1d92/1000x1000-000000-80-0-0.jpg	456	35	2018-09-07	album	2026-08-07 12:27:45.668934	2026-08-07 12:27:45.668934
814	140425062	Moonlight Sonata	331	https://cdn-images.dzcdn.net/images/cover/a5581fca84c28ea419efc8b6cb788172/1000x1000-000000-80-0-0.jpg	462	1	2020-04-03	single	2026-08-07 12:27:51.185369	2026-08-07 12:27:51.185369
815	150221892	Bethoven Masterpieces and Friends	7781	https://cdn-images.dzcdn.net/images/cover/b523e17e7991aff979b47d2d9f675310/1000x1000-000000-80-0-0.jpg	463	38	2020-05-19	album	2026-08-07 12:27:51.185369	2026-08-07 12:27:51.185369
816	7029476	Moonlight Sonata	4215	https://cdn-images.dzcdn.net/images/cover/c6b54ae7af4992902349d909da34c0e2/1000x1000-000000-80-0-0.jpg	457	32	2013-10-08	album	2026-08-07 12:27:51.185369	2026-08-07 12:27:51.185369
817	366747127	Chaos Magic	1316	https://cdn-images.dzcdn.net/images/cover/8c98651f639be65ab35f5bf2fb3b8cca/1000x1000-000000-80-0-0.jpg	464	5	2022-10-16	ep	2026-08-07 12:27:51.185369	2026-08-07 12:27:51.185369
818	7064224	Bach Sonatas	4443	https://cdn-images.dzcdn.net/images/cover/1f436ddafde0d80a4187884bb38dcb24/1000x1000-000000-80-0-0.jpg	465	21	2009-10-02	album	2026-08-07 12:39:34.041421	2026-08-07 12:39:34.041421
819	123007642	Bach Sonatas and Partitas: 2017 Session	1699	https://cdn-images.dzcdn.net/images/cover/8cd151540a75c0d76b4048e3b73e8f20/1000x1000-000000-80-0-0.jpg	466	8	2018-09-22	album	2026-08-07 12:39:34.041421	2026-08-07 12:39:34.041421
820	14713386	Bach Sonatas BWV 1014-1019	6463	https://cdn-images.dzcdn.net/images/cover/fd8e8e3affa06d0f4f247d612b811533/1000x1000-000000-80-0-0.jpg	467	25	2016-12-02	album	2026-08-07 12:39:34.041421	2026-08-07 12:39:34.041421
821	839391242	Bach Sonatas for Viola da Gamba and Obbligato Harpsichord	3129	https://cdn-images.dzcdn.net/images/cover/48877d75d1943f18d8ed25037206bd4f/1000x1000-000000-80-0-0.jpg	468	13	2025-11-21	album	2026-08-07 12:39:34.041421	2026-08-07 12:39:34.041421
822	74439372	Hilary Hahn plays J.S. Bach: Violin Sonatas Nos. 1 & 2; Partita No. 1	4541	https://cdn-images.dzcdn.net/images/cover/fbe0266937ade7b5610dfca4c98333b3/1000x1000-000000-80-0-0.jpg	469	16	2018-10-05	album	2026-08-07 12:39:34.041421	2026-08-07 12:39:34.041421
\.


--
-- Data for Name: album_genre_association; Type: TABLE DATA; Schema: public; Owner: postgres
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
275	8
308	13
309	22
310	22
311	22
312	13
313	13
314	13
315	13
316	13
391	22
392	13
393	13
394	22
395	13
396	13
397	13
399	13
400	13
401	13
402	13
403	13
404	13
388	13
405	8
405	2
406	2
406	3
407	22
407	2
408	9
409	2
410	22
411	12
412	22
413	12
414	8
414	2
415	1
416	35
417	35
417	22
418	2
419	22
419	2
420	22
422	8
422	11
422	10
422	22
423	8
423	22
423	34
423	2
423	25
424	1
425	12
425	26
426	22
427	1
428	8
429	8
430	8
431	8
432	4
433	4
434	8
434	22
434	4
434	24
435	8
435	22
435	4
435	24
436	26
437	2
438	2
439	2
440	2
441	2
442	2
443	2
444	2
445	2
446	1
446	4
447	22
448	1
449	22
450	22
451	36
452	12
452	37
452	29
453	8
454	1
455	28
455	38
456	1
457	1
458	1
459	1
460	1
461	1
462	1
463	1
464	1
465	22
466	22
467	22
468	22
469	22
470	12
471	12
471	26
471	27
472	12
472	37
473	36
474	36
475	29
476	22
477	22
478	22
479	22
480	26
480	22
481	8
481	11
481	10
481	22
482	8
482	10
483	8
484	8
484	2
485	8
485	2
486	8
486	2
487	8
487	2
488	12
488	26
489	22
490	22
491	2
492	22
493	12
493	26
494	22
495	1
496	12
496	22
497	12
497	37
497	26
498	12
498	26
499	12
500	1
501	22
502	30
503	8
504	26
504	22
505	12
506	22
507	2
507	9
508	22
509	1
510	8
510	22
510	34
510	2
510	25
387	13
375	13
382	13
378	22
372	22
376	22
385	13
377	13
380	13
373	8
381	13
371	13
390	13
512	8
512	10
512	2
513	22
514	22
515	22
516	8
517	8
518	8
519	8
520	8
521	22
522	22
523	22
524	22
529	8
535	8
527	8
525	8
541	8
542	8
543	8
544	8
534	8
528	8
545	8
539	8
546	8
547	8
548	8
549	8
550	8
550	10
536	8
551	8
551	10
540	8
537	8
552	8
552	10
553	8
530	8
554	8
554	10
554	22
554	2
538	8
526	8
533	8
532	8
558	12
559	12
555	8
555	11
555	10
557	2
556	2
560	2
561	12
562	12
564	12
565	8
565	11
565	10
566	12
566	26
572	8
575	8
568	8
568	2
570	8
570	2
567	8
567	2
569	8
569	2
571	8
571	2
574	2
576	2
573	2
582	8
583	8
584	8
585	8
585	2
586	8
586	2
587	8
587	2
588	8
588	2
589	8
589	2
581	8
581	2
590	8
590	2
580	8
580	2
578	8
578	2
591	8
591	2
577	8
577	2
592	8
592	2
593	8
593	2
594	8
594	2
595	8
595	2
596	8
597	8
598	8
599	8
600	8
601	8
602	8
603	8
604	8
605	12
606	8
606	2
607	8
607	2
608	8
609	1
610	1
611	8
611	10
612	12
612	26
613	12
613	26
614	2
615	8
616	22
617	26
618	22
619	4
621	4
622	2
623	1
625	8
625	10
626	2
627	12
629	22
630	2
632	2
633	2
635	2
634	13
636	13
637	22
637	5
637	6
638	1
639	1
640	2
640	33
641	2
642	13
643	13
646	22
647	13
648	13
649	8
649	2
650	8
650	2
651	8
651	2
652	8
652	2
653	8
653	2
654	8
654	2
655	8
655	2
656	8
656	2
657	8
657	2
658	8
658	2
659	8
659	2
660	8
660	2
661	8
661	2
662	8
662	2
663	2
664	8
664	2
665	8
665	10
666	8
666	2
667	8
667	2
668	2
669	2
670	2
671	2
672	2
673	2
674	2
675	2
676	2
677	2
678	22
679	22
680	2
681	36
682	13
683	13
684	2
685	2
686	2
687	22
688	2
689	2
690	5
690	6
691	2
692	2
693	2
694	2
695	22
696	2
697	22
698	2
699	2
700	2
701	2
702	2
703	2
704	2
705	2
706	22
707	2
708	2
709	2
710	2
711	2
712	2
713	2
714	2
715	2
716	2
717	2
718	2
719	2
720	2
721	8
721	5
721	6
722	35
723	2
724	35
725	2
726	35
727	35
728	2
729	35
730	35
731	1
732	1
733	1
734	1
735	1
736	1
737	1
738	2
738	39
739	1
740	22
741	9
742	22
742	2
743	1
744	1
745	22
745	30
746	1
747	2
748	2
749	2
750	12
750	26
751	8
751	11
751	22
752	8
752	11
752	10
752	22
752	34
752	2
753	26
753	22
754	22
755	22
786	26
787	22
788	8
788	11
788	22
789	8
789	11
789	22
790	8
790	11
791	8
792	8
792	11
792	22
793	8
793	11
793	22
794	8
794	11
794	22
795	2
796	26
796	2
796	3
797	1
798	26
798	2
798	3
799	26
799	2
799	3
800	26
800	2
800	3
801	12
801	26
802	1
802	22
802	29
804	26
810	36
811	36
812	36
813	36
814	36
815	8
816	22
817	12
817	26
818	36
819	36
820	36
821	36
822	36
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
c32c718afe5b
\.


--
-- Data for Name: artist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist (id, dzid, name, picture, ghost_albums_count, created_at, updated_at) FROM stdin;
372	14626427	sømething	https://api.deezer.com/artist/14626427/image	26	2026-07-11 10:25:25.841004	2026-07-11 10:25:25.841004
373	111747	Something	https://api.deezer.com/artist/111747/image	17	2026-07-11 10:25:25.841004	2026-07-11 10:25:25.841004
374	337	Something Corporate	https://api.deezer.com/artist/337/image	7	2026-07-11 10:25:25.841004	2026-07-11 10:25:25.841004
375	1931	Deep Blue Something	https://api.deezer.com/artist/1931/image	9	2026-07-11 10:25:25.841004	2026-07-11 10:25:25.841004
376	296169	SomethingALaMode	https://api.deezer.com/artist/296169/image	4	2026-07-11 10:25:25.841004	2026-07-11 10:25:25.841004
378	9573304	MSI	https://api.deezer.com/artist/9573304/image	56	2026-07-11 15:22:36.382031	2026-07-11 15:22:36.382031
379	341323	M'Si	https://api.deezer.com/artist/341323/image	2	2026-07-11 15:22:36.382031	2026-07-11 15:22:36.382031
380	14521743	.Msi	https://api.deezer.com/artist/14521743/image	4	2026-07-11 15:22:36.382031	2026-07-11 15:22:36.382031
381	705	Muse	https://api.deezer.com/artist/705/image	71	2026-07-11 15:22:36.382031	2026-07-11 15:22:36.382031
382	5472150	KSI	https://api.deezer.com/artist/5472150/image	62	2026-07-11 15:22:36.382031	2026-07-11 15:22:36.382031
383	9	OutKast	https://api.deezer.com/artist/9/image	34	2026-07-11 15:22:37.052086	2026-07-11 15:22:37.052086
384	10434312	G.G.A	https://api.deezer.com/artist/10434312/image	60	2026-07-11 15:22:37.052086	2026-07-11 15:22:37.052086
385	469180	Nina'school	https://api.deezer.com/artist/469180/image	4	2026-07-11 15:22:37.052086	2026-07-11 15:22:37.052086
386	4063124	Theow	https://api.deezer.com/artist/4063124/image	36	2026-07-11 15:22:37.052086	2026-07-11 15:22:37.052086
387	67	Kiss	https://api.deezer.com/artist/67/image	66	2026-07-11 15:22:56.121387	2026-07-11 15:22:56.121387
388	1424821	Lana Del Rey	https://api.deezer.com/artist/1424821/image	71	2026-07-11 15:22:56.121387	2026-07-11 15:22:56.121387
389	564	Rihanna	https://api.deezer.com/artist/564/image	98	2026-07-11 15:22:56.121387	2026-07-11 15:22:56.121387
390	542	David Guetta	https://api.deezer.com/artist/542/image	398	2026-07-11 15:22:56.121387	2026-07-11 15:22:56.121387
391	118079502	Mongolian Chop Squad	https://api.deezer.com/artist/118079502/image	3	2026-07-11 15:28:01.772703	2026-07-11 15:28:01.772703
395	180440797	Paperchamps	https://api.deezer.com/artist/180440797/image	11	2026-07-11 15:28:03.543163	2026-07-11 15:28:03.543163
396	170280	Maciej Malenczuk	https://api.deezer.com/artist/170280/image	17	2026-07-11 18:08:18.701465	2026-07-11 18:08:18.701465
397	1557438	Ira Malaniuk	https://api.deezer.com/artist/1557438/image	18	2026-07-11 18:08:18.701465	2026-07-11 18:08:18.701465
398	1452147	Maciej Malenczuk z zespolem Psychodancing	https://api.deezer.com/artist/1452147/image	9	2026-07-11 18:08:18.701465	2026-07-11 18:08:18.701465
399	12926253	Yugopolis, Maciej Maleńczuk	https://api.deezer.com/artist/12926253/image	0	2026-07-11 18:08:18.701465	2026-07-11 18:08:18.701465
400	11857983	Maleńczuk & Waglewski	https://api.deezer.com/artist/11857983/image	0	2026-07-11 18:08:18.701465	2026-07-11 18:08:18.701465
401	10303468	Inude	https://api.deezer.com/artist/10303468/image	16	2026-07-11 18:08:19.269908	2026-07-11 18:08:19.269908
402	281732	Canzoniere Grecanico Salentino	https://api.deezer.com/artist/281732/image	24	2026-07-11 18:08:19.269908	2026-07-11 18:08:19.269908
403	4035703	Yugopolis	https://api.deezer.com/artist/4035703/image	6	2026-07-11 18:08:19.269908	2026-07-11 18:08:19.269908
404	126093402	Maciej Musiałowski	https://api.deezer.com/artist/126093402/image	4	2026-07-12 08:22:57.032533	2026-07-12 08:22:57.032533
405	271135692	Maciej Skiba	https://api.deezer.com/artist/271135692/image	14	2026-07-12 08:22:57.032533	2026-07-12 08:22:57.032533
406	7708	Vader	https://api.deezer.com/artist/7708/image	32	2026-07-12 08:22:57.032533	2026-07-12 08:22:57.032533
407	2887811	Polish Radio Symphony Orchestra	https://api.deezer.com/artist/2887811/image	30	2026-07-12 08:22:58.455355	2026-07-12 08:22:58.455355
408	104764222	Maciej Gołyźniak Trio	https://api.deezer.com/artist/104764222/image	9	2026-07-12 08:22:58.455355	2026-07-12 08:22:58.455355
409	211417	Sheena Ringo	https://api.deezer.com/artist/211417/image	73	2026-07-13 09:32:58.006454	2026-07-13 09:32:58.006454
410	259589222	Sheena Ringo	https://api.deezer.com/artist/259589222/image	3	2026-07-13 09:32:58.006454	2026-07-13 09:32:58.006454
411	229413065	SOIL & "PIMP" SESSIONS x Ringo Sheena	https://api.deezer.com/artist/229413065/image	0	2026-07-13 09:32:58.006454	2026-07-13 09:32:58.006454
412	286176971	Miliyah x Sheena Ringo	https://api.deezer.com/artist/286176971/image	0	2026-07-13 09:32:58.006454	2026-07-13 09:32:58.006454
413	268194742	ꉈꀧ꒒꒒ꁄꍈꍈꀧ꒦ꉈ ꉣꅔꎡꅔꁕꁄ x Sheena Ringo	https://api.deezer.com/artist/268194742/image	0	2026-07-13 09:32:58.006454	2026-07-13 09:32:58.006454
414	262796731	ꉈꀧ꒒꒒ꁄꍈꍈꀧ꒦ꉈ ꉣꅔꎡꅔꁕꁄ	https://api.deezer.com/artist/262796731/image	15	2026-07-13 09:32:58.335275	2026-07-13 09:32:58.335275
415	4934518	Ichiyo Izawa	https://api.deezer.com/artist/4934518/image	5	2026-07-13 09:33:03.327396	2026-07-13 09:33:03.327396
416	8553818	BIGYUKI	https://api.deezer.com/artist/8553818/image	13	2026-07-13 09:33:03.327396	2026-07-13 09:33:03.327396
417	277062	Jun Miyake	https://api.deezer.com/artist/277062/image	21	2026-07-13 09:33:03.327396	2026-07-13 09:33:03.327396
418	14468689	Morgenshtern	https://api.deezer.com/artist/14468689/image	61	2026-07-14 11:32:32.272401	2026-07-14 11:32:32.272401
419	164941387	Morgenshtern	https://api.deezer.com/artist/164941387/image	1	2026-07-14 11:32:32.272401	2026-07-14 11:32:32.272401
420	147362272	Morgenstern	https://api.deezer.com/artist/147362272/image	4	2026-07-14 11:32:32.272401	2026-07-14 11:32:32.272401
421	147362772	Morgenstern	https://api.deezer.com/artist/147362772/image	12	2026-07-14 11:32:32.272401	2026-07-14 11:32:32.272401
422	59208	Morgenstern	https://api.deezer.com/artist/59208/image	18	2026-07-14 11:32:32.272401	2026-07-14 11:32:32.272401
423	14956079	Apache 207	https://api.deezer.com/artist/14956079/image	49	2026-07-14 11:32:53.148015	2026-07-14 11:32:53.148015
424	5095744	Marleen Rutten	https://api.deezer.com/artist/5095744/image	29	2026-07-14 11:32:53.148015	2026-07-14 11:32:53.148015
425	464	Rammstein	https://api.deezer.com/artist/464/image	50	2026-07-14 11:32:53.148015	2026-07-14 11:32:53.148015
430	1594390	Hard To Explain	https://api.deezer.com/artist/1594390/image	17	2026-07-15 08:21:04.337207	2026-07-15 08:21:04.337207
431	13013057	The Hard to Explain	https://api.deezer.com/artist/13013057/image	3	2026-07-15 08:21:04.337207	2026-07-15 08:21:04.337207
432	12082900	Aleksandir	https://api.deezer.com/artist/12082900/image	24	2026-07-15 08:21:04.803722	2026-07-15 08:21:04.803722
433	5339471	Monica Martin	https://api.deezer.com/artist/5339471/image	19	2026-07-15 08:21:04.803722	2026-07-15 08:21:04.803722
434	1042	Cowboy Junkies	https://api.deezer.com/artist/1042/image	42	2026-07-15 08:21:04.803722	2026-07-15 08:21:04.803722
435	482758	DJ Snake	https://api.deezer.com/artist/482758/image	104	2026-07-19 13:35:24.48002	2026-07-19 13:35:24.48002
436	119579222	S-KILL	https://api.deezer.com/artist/119579222/image	52	2026-07-24 14:42:38.328758	2026-07-24 14:42:38.328758
437	90688	Skill	https://api.deezer.com/artist/90688/image	73	2026-07-24 14:42:38.328758	2026-07-24 14:42:38.328758
438	9315	Skillet	https://api.deezer.com/artist/9315/image	63	2026-07-24 14:42:38.328758	2026-07-24 14:42:38.328758
439	8810764	Skillibeng	https://api.deezer.com/artist/8810764/image	71	2026-07-24 14:42:38.328758	2026-07-24 14:42:38.328758
440	525643	Skrillex	https://api.deezer.com/artist/525643/image	88	2026-07-24 14:42:38.328758	2026-07-24 14:42:38.328758
441	11028668	MiyaGi & Эндшпиль	https://api.deezer.com/artist/11028668/image	25	2026-07-24 14:42:38.783484	2026-07-24 14:42:38.783484
442	2576381	F. Noize	https://api.deezer.com/artist/2576381/image	58	2026-07-24 14:42:38.783484	2026-07-24 14:42:38.783484
443	4084122	Partyraiser	https://api.deezer.com/artist/4084122/image	36	2026-07-24 14:42:40.364318	2026-07-24 14:42:40.364318
377	936	Bad Religion	https://api.deezer.com/artist/936/image	34	2026-07-11 10:30:54.324082	2026-07-11 10:30:54.324082
392	176093017	Chiptune & 8 bit Planet	https://api.deezer.com/artist/176093017/image	159	2026-07-11 15:28:01.99784	2026-07-11 15:28:01.99784
393	215272595	ZzzSleepyAsh	https://api.deezer.com/artist/215272595/image	40	2026-07-11 15:28:01.99784	2026-07-11 15:28:01.99784
394	76715642	Slashin	https://api.deezer.com/artist/76715642/image	17	2026-07-11 15:28:01.99784	2026-07-11 15:28:01.99784
426	137967232	Arut	https://api.deezer.com/artist/137967232/image	15	2026-07-14 11:32:54.158405	2026-07-14 11:32:54.158405
444	13618153	Bach	https://api.deezer.com/artist/13618153/image	7	2026-08-07 12:26:37.78666	2026-08-07 12:26:37.78666
445	377397211	BACH.	https://api.deezer.com/artist/377397211/image	27	2026-08-07 12:26:37.78666	2026-08-07 12:26:37.78666
446	57213	Bach & Laverne	https://api.deezer.com/artist/57213/image	1	2026-08-07 12:26:37.78666	2026-08-07 12:26:37.78666
447	1900	Johann Sebastian Bach	https://api.deezer.com/artist/1900/image	469	2026-08-07 12:26:37.78666	2026-08-07 12:26:37.78666
448	74397	Nach	https://api.deezer.com/artist/74397/image	20	2026-08-07 12:26:37.78666	2026-08-07 12:26:37.78666
449	1887541	4i20	https://api.deezer.com/artist/1887541/image	42	2026-08-07 12:26:38.158988	2026-08-07 12:26:38.158988
450	11559031	Manuel Turizo	https://api.deezer.com/artist/11559031/image	100	2026-08-07 12:26:38.158988	2026-08-07 12:26:38.158988
451	1536	Ennio Morricone	https://api.deezer.com/artist/1536/image	287	2026-08-07 12:26:38.158988	2026-08-07 12:26:38.158988
452	128227902	Bath Sonata	https://api.deezer.com/artist/128227902/image	3	2026-08-07 12:27:43.94808	2026-08-07 12:27:43.94808
453	409258	Renaud Capuçon	https://api.deezer.com/artist/409258/image	86	2026-08-07 12:27:44.242952	2026-08-07 12:27:44.242952
454	1473410	Menuhin	https://api.deezer.com/artist/1473410/image	1	2026-08-07 12:27:44.242952	2026-08-07 12:27:44.242952
455	153702	Alexandre Tharaud	https://api.deezer.com/artist/153702/image	103	2026-08-07 12:27:44.242952	2026-08-07 12:27:44.242952
456	1324555	Víkingur Ólafsson	https://api.deezer.com/artist/1324555/image	54	2026-08-07 12:27:44.242952	2026-08-07 12:27:44.242952
457	5275401	Moonlight Sonata	https://api.deezer.com/artist/5275401/image	121	2026-08-07 12:27:49.890624	2026-08-07 12:27:49.890624
458	1872881	Moonlight Sonata , Mondschein Sonate (L. V. Beethoven)	https://api.deezer.com/artist/1872881/image	2	2026-08-07 12:27:49.890624	2026-08-07 12:27:49.890624
459	230065185	Moonlight Sonata	https://api.deezer.com/artist/230065185/image	1	2026-08-07 12:27:49.890624	2026-08-07 12:27:49.890624
460	4395935	Moonlight Sonata , Mondscheinsonate [ Beethoven ]	https://api.deezer.com/artist/4395935/image	1	2026-08-07 12:27:49.890624	2026-08-07 12:27:49.890624
461	5253607	Moonlight Sonata Moods	https://api.deezer.com/artist/5253607/image	1	2026-08-07 12:27:49.890624	2026-08-07 12:27:49.890624
462	6144	Ludwig van Beethoven	https://api.deezer.com/artist/6144/image	477	2026-08-07 12:27:50.0401	2026-08-07 12:27:50.0401
463	244336762	Junior dos Santos Silva	https://api.deezer.com/artist/244336762/image	4	2026-08-07 12:27:50.0401	2026-08-07 12:27:50.0401
464	5987322	meganeko	https://api.deezer.com/artist/5987322/image	26	2026-08-07 12:27:50.0401	2026-08-07 12:27:50.0401
427	81707552	Nevis	https://api.deezer.com/artist/81707552/image	10	2026-07-14 11:33:14.470904	2026-07-14 11:33:14.470904
428	60761882	01099	https://api.deezer.com/artist/60761882/image	63	2026-07-14 11:33:14.470904	2026-07-14 11:33:14.470904
429	15727	Element Of Crime	https://api.deezer.com/artist/15727/image	31	2026-07-14 11:33:14.470904	2026-07-14 11:33:14.470904
465	70673	James Galway	https://api.deezer.com/artist/70673/image	112	2026-08-07 12:39:32.66612	2026-08-07 12:39:32.66612
466	1157575	Derek Gripper	https://api.deezer.com/artist/1157575/image	30	2026-08-07 12:39:32.66612	2026-08-07 12:39:32.66612
467	70297	David Oistrakh	https://api.deezer.com/artist/70297/image	417	2026-08-07 12:39:32.66612	2026-08-07 12:39:32.66612
468	1636662	Margaret Little	https://api.deezer.com/artist/1636662/image	8	2026-08-07 12:39:32.66612	2026-08-07 12:39:32.66612
469	70067	Hilary Hahn	https://api.deezer.com/artist/70067/image	48	2026-08-07 12:39:32.66612	2026-08-07 12:39:32.66612
293	304870	Abbey Road Ensemble	https://cdn-images.dzcdn.net/images/artist/afae92db62467dca3b9351dde1546e93/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:38:08.047226	2026-07-09 12:19:15.990432
294	1582485	Abbey Road Xmas Ensemble	https://cdn-images.dzcdn.net/images/artist/82cb29162eaba6c0a6329f6de9ac8b71/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:38:08.047226	2026-07-09 12:19:15.990432
295	1192449	Abbey Road's Philharmonic Orchestra	https://cdn-images.dzcdn.net/images/artist/5cda1f6327cc4bb6a388ed98700982fa/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:38:08.047226	2026-07-09 12:19:15.990432
296	4240911	Abbey Road Troubadours	https://cdn-images.dzcdn.net/images/artist/f2a1601483a302d332cbe2f1587f2a81/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:38:08.047226	2026-07-09 12:19:15.990432
1	1978	Nujabes	https://cdn-images.dzcdn.net/images/artist/66061639b73edb7a01e8de7a1990eaa2/1000x1000-000000-80-0-0.jpg	12	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
2	128293792	Oma	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	22	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
3	75971352	Sickmode	https://cdn-images.dzcdn.net/images/artist/d4163ac6b94506c0b99b07d9fbf21635/1000x1000-000000-80-0-0.jpg	41	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
4	133267472	HAECHAN	https://cdn-images.dzcdn.net/images/artist/b115136b525f2ae24e13e7f398cbfd9c/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
5	1331356	JUNNY	https://cdn-images.dzcdn.net/images/artist/3dae04b9bebded07c7c6e08aab4d73de/1000x1000-000000-80-0-0.jpg	54	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
6	15193591	SANDEUL	https://cdn-images.dzcdn.net/images/artist/3d818c26a5a7528f77ce2abdaa7b0149/1000x1000-000000-80-0-0.jpg	30	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
7	599	My Chemical Romance	https://cdn-images.dzcdn.net/images/artist/e34296360cda10a29f85c7170a60178d/1000x1000-000000-80-0-0.jpg	39	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
8	412538	Currents	https://cdn-images.dzcdn.net/images/artist/1bdd67845bcd168210e099e139e9381a/1000x1000-000000-80-0-0.jpg	15	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
9	252586452	Currents	https://cdn-images.dzcdn.net/images/artist/bfe71e0876fe556b00047f29db52f2ef/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
10	120658702	Currents	https://cdn-images.dzcdn.net/images/artist/d8bfcd18c6e177e9a500876b18e9ecc0/1000x1000-000000-80-0-0.jpg	13	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
11	13117393	Current Joys	https://cdn-images.dzcdn.net/images/artist/5890d003f9365b8ac1800fd39b21eb11/1000x1000-000000-80-0-0.jpg	18	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
12	12132520	The Currents	https://cdn-images.dzcdn.net/images/artist/7d78cc0d4df67a91b3c9216c1c617e36/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
13	134790	Tame Impala	https://cdn-images.dzcdn.net/images/artist/879015e713cc6ad6ffaeec154c027505/1000x1000-000000-80-0-0.jpg	37	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
14	15013267	Currents Will Shift	https://cdn-images.dzcdn.net/images/artist/24b6d2e4eba8c534758f087af87653cd/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
15	402158	Curren$y	https://cdn-images.dzcdn.net/images/artist/5e4bffd6fd84774118723e4813cd84c9/1000x1000-000000-80-0-0.jpg	159	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
16	140172842	Passing Currents	https://cdn-images.dzcdn.net/images/artist/86d6f6067e69c55b4713779e1631cbec/1000x1000-000000-80-0-0.jpg	16	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
17	208529657	Stray Currents	https://cdn-images.dzcdn.net/images/artist/cfa6c3b3d7d587d97d4eaaf34fc2014c/1000x1000-000000-80-0-0.jpg	14	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
18	191141377	Currents	https://cdn-images.dzcdn.net/images/artist/0f7b6bafdb7cf8612498ef396cfd6500/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
19	356815	We Came As Romans	https://cdn-images.dzcdn.net/images/artist/724efa2a1f1b75a487e330d40c347207/1000x1000-000000-80-0-0.jpg	22	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
20	55141312	Silent Currents	https://cdn-images.dzcdn.net/images/artist/be0c8c845ac62fb9ab9adc86c8e5e7b9/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
21	295323941	Black Currents	https://cdn-images.dzcdn.net/images/artist/43eff32efdf0d2b27ae6151e55c4c62a/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
22	120658712	Currents	https://cdn-images.dzcdn.net/images/artist/36dbfe757cb6b08d7afc3dc8965f29b5/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
23	104107352	Eddy Currents	https://cdn-images.dzcdn.net/images/artist/5533a9d46dbe265db39f6d0a18181838/1000x1000-000000-80-0-0.jpg	12	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
24	212492487	Sleepy Currents	https://cdn-images.dzcdn.net/images/artist/5d53a90c0c49a2ec3203dbf422396fec/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
25	74804	Wiz Khalifa	https://cdn-images.dzcdn.net/images/artist/a1dc970ad2ad6afa42580c692b8a8a8d/1000x1000-000000-80-0-0.jpg	201	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
26	6318152	The Oh Hellos	https://cdn-images.dzcdn.net/images/artist/4c6ae68004f3e5fa7e28065784e2cab3/1000x1000-000000-80-0-0.jpg	16	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
27	372003511	Ancient Currents	https://cdn-images.dzcdn.net/images/artist/b169e69e4d1d792f94ac437f7b34758e/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
28	114175602	Bad Currents	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
29	296466121	Liminal Currents	https://cdn-images.dzcdn.net/images/artist/3d89c852e90eb0b8872cac7bb436d848/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
30	286972951	Gentle Stream Currents	https://cdn-images.dzcdn.net/images/artist/b872bf59d1afbc4931550350220047c1/1000x1000-000000-80-0-0.jpg	38	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
31	144788232	The Sheer Currents	https://cdn-images.dzcdn.net/images/artist/b282e353418b1f01c3e20da813a02f53/1000x1000-000000-80-0-0.jpg	5	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
32	555102	In Vain	https://cdn-images.dzcdn.net/images/artist/760c9ff6a0f473f286a0f21e4612327e/1000x1000-000000-80-0-0.jpg	12	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
33	70821102	Youth 83	https://cdn-images.dzcdn.net/images/artist/917a1b09048e0084027c9cc54275b8a6/1000x1000-000000-80-0-0.jpg	55	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
34	416733	The Gun Show	https://cdn-images.dzcdn.net/images/artist/680202af3653917ed1b75719f22afb2e/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
35	10153646	Native Dancer	https://cdn-images.dzcdn.net/images/artist/acf3cc326dd8f4954a811b2b6de33b7f/1000x1000-000000-80-0-0.jpg	10	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
36	12120364	Mellow Currents	https://cdn-images.dzcdn.net/images/artist/27fa8d66896092b8354dc33b4063e07e/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
37	121646022	Boxwood Currents	https://cdn-images.dzcdn.net/images/artist/3749071a33c7b174fb132b4d752558a3/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
38	12298614	New Currents	https://cdn-images.dzcdn.net/images/artist/915808181dd9122f29fb24046526240a/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
39	128476372	Ocean Currents	https://cdn-images.dzcdn.net/images/artist/a034204f3b372a813404756400369dd0/1000x1000-000000-80-0-0.jpg	34	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
40	128930762	Sweet Currents	https://cdn-images.dzcdn.net/images/artist/a1a29aa2e12a535f271415a0b6b2c248/1000x1000-000000-80-0-0.jpg	10	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
41	524675	Still Corners	https://cdn-images.dzcdn.net/images/artist/b09621096c0d1b8bbba2a2b56415df41/1000x1000-000000-80-0-0.jpg	28	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
42	56943632	Aedra	https://cdn-images.dzcdn.net/images/artist/614a870975d6ecc563a96c77180e466a/1000x1000-000000-80-0-0.jpg	14	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
43	12057546	Lux Pacific	https://cdn-images.dzcdn.net/images/artist/a761e0d27a1d7e4b930fd269e51f5511/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
44	13498347	Mad Keys	https://cdn-images.dzcdn.net/images/artist/06167c36897be0f0d80442d0af7b256c/1000x1000-000000-80-0-0.jpg	36	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
45	1860	Eisley	https://cdn-images.dzcdn.net/images/artist/5d351382c7c823a83829671c6a7b1b77/1000x1000-000000-80-0-0.jpg	22	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
46	259645622	ILLIT	https://cdn-images.dzcdn.net/images/artist/fc9af226576dd0244593dff0c10bebf0/1000x1000-000000-80-0-0.jpg	20	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
47	57092	Hot Lips Page	https://cdn-images.dzcdn.net/images/artist/923538a57b0870da2c16829ab232cd59/1000x1000-000000-80-0-0.jpg	59	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
48	75964992	Magenta Club	https://cdn-images.dzcdn.net/images/artist/2b9905ea459ac0bbe8c8cdf918f3f13a/1000x1000-000000-80-0-0.jpg	21	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
49	147184	Pixote	https://cdn-images.dzcdn.net/images/artist/aa73661c8d19a0eadc394ec6bc1ffac0/1000x1000-000000-80-0-0.jpg	79	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
50	13612387	Måneskin	https://cdn-images.dzcdn.net/images/artist/b5ee25137476918b7660f80529981436/1000x1000-000000-80-0-0.jpg	20	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
51	5951582	Jain	https://cdn-images.dzcdn.net/images/artist/4081ad8f96b9b8215a1a42e45ae7d17b/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
52	141074952	Pale Jay	https://cdn-images.dzcdn.net/images/artist/1bd6dc0def32298eb92286f55f233fc2/1000x1000-000000-80-0-0.jpg	25	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
53	2047	Jean-Michel Jarre	https://cdn-images.dzcdn.net/images/artist/3ea16ff83d0129f38755b0c2454e1731/1000x1000-000000-80-0-0.jpg	84	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
54	1529	Jane Birkin	https://cdn-images.dzcdn.net/images/artist/99edd4d669a7fe23e4cba6d0313abfe1/1000x1000-000000-80-0-0.jpg	33	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
55	13682985	The Long Faces	https://cdn-images.dzcdn.net/images/artist/6e1b4c71257cd5aa40299b2c583bfb77/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
56	5286	Breaking Benjamin	https://cdn-images.dzcdn.net/images/artist/fbfe5fa355f1f81e67377385e9a2a9ad/1000x1000-000000-80-0-0.jpg	15	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
57	380832	Fun.	https://cdn-images.dzcdn.net/images/artist/04b78dcf94871240e68b556c0a81321c/1000x1000-000000-80-0-0.jpg	11	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
58	165644657	aurora hills	https://cdn-images.dzcdn.net/images/artist/46f1406e8089d5789b5625e90889391a/1000x1000-000000-80-0-0.jpg	26	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
59	13209	Mary Jane Girls	https://cdn-images.dzcdn.net/images/artist/9df7c461c6b83862ef0ecce11ea322e1/1000x1000-000000-80-0-0.jpg	5	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
60	2559	Jane's Addiction	https://cdn-images.dzcdn.net/images/artist/404056eaba81b1af1b74517b455e423e/1000x1000-000000-80-0-0.jpg	28	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
61	3557	Jeanne Mas	https://cdn-images.dzcdn.net/images/artist/55d46aa572a75d20936d55800a8fa06b/1000x1000-000000-80-0-0.jpg	36	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
62	107557062	Rio Romeo	https://cdn-images.dzcdn.net/images/artist/93c8fefb155e85a62c7e7357903bd452/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
63	1658	Janis Joplin	https://cdn-images.dzcdn.net/images/artist/b0886c9443302509efab54604e201227/1000x1000-000000-80-0-0.jpg	18	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
64	131935	Janelle Monáe	https://cdn-images.dzcdn.net/images/artist/92f85ade98d2839697ef8a248fbe66ee/1000x1000-000000-80-0-0.jpg	48	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
65	170	Bryan Adams	https://cdn-images.dzcdn.net/images/artist/85d6a14a21da43928992c586fe8a2b41/1000x1000-000000-80-0-0.jpg	71	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
66	836	Jeanette	https://cdn-images.dzcdn.net/images/artist/2057109645f2e4c0fa6c0a843348207d/1000x1000-000000-80-0-0.jpg	24	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
67	283419621	GASPXR	https://cdn-images.dzcdn.net/images/artist/abb032ec7c17d120e2d01db5d798efb9/1000x1000-000000-80-0-0.jpg	97	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
68	222357135	pxiqzes	https://cdn-images.dzcdn.net/images/artist/2441004a5c072063317ca300b947bcea/1000x1000-000000-80-0-0.jpg	49	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
69	1188	Maroon 5	https://cdn-images.dzcdn.net/images/artist/bbb526b9666c7e31dee295bcabbbdd8e/1000x1000-000000-80-0-0.jpg	69	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
70	827425	Kane Brown	https://cdn-images.dzcdn.net/images/artist/031a975249b648d21f34c5b2bbd3c877/1000x1000-000000-80-0-0.jpg	62	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
71	1308	Jeanne Cherhal	https://cdn-images.dzcdn.net/images/artist/12eb1d0e23c6701d584b48c93c71e3a2/1000x1000-000000-80-0-0.jpg	13	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
72	262	Janet Jackson	https://cdn-images.dzcdn.net/images/artist/2d2d36f89a7281fe0a8f6a5dd274505e/1000x1000-000000-80-0-0.jpg	67	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
73	484370	Jeanne Added	https://cdn-images.dzcdn.net/images/artist/ed8268f90f0d9b2bdd6f694982e92946/1000x1000-000000-80-0-0.jpg	18	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
74	2110	Tom Petty And The Heartbreakers	https://cdn-images.dzcdn.net/images/artist/76a12d46d557f75b9676c6ae2729ed3c/1000x1000-000000-80-0-0.jpg	46	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
75	355	Bellini	https://cdn-images.dzcdn.net/images/artist/e219517563ccaef72b14f066405e0f2a/1000x1000-000000-80-0-0.jpg	34	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
76	171334977	John + Jane Q. Public	https://cdn-images.dzcdn.net/images/artist/341da7e0d8563d91df8c7b8903411a6c/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
77	4341930	A$AP Ferg	https://cdn-images.dzcdn.net/images/artist/184a9d3c214117727e2fbe3ac8d849e7/1000x1000-000000-80-0-0.jpg	71	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
78	2986	Converge	https://cdn-images.dzcdn.net/images/artist/cbb7f67ec9e1fe006b202c0f6543a962/1000x1000-000000-80-0-0.jpg	30	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
79	170234767	Jane Remover	https://cdn-images.dzcdn.net/images/artist/ebd6b5e5a0b0f178163005de1869767b/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
80	135183112	Jalen Ngonda	https://cdn-images.dzcdn.net/images/artist/139fec85da0f4dc84477898fdd1ca090/1000x1000-000000-80-0-0.jpg	23	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
81	310229591	BRAT	https://cdn-images.dzcdn.net/images/artist/0bf6e0652ff38ccd10132508f75dec19/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
82	3810	Brat	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	45	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
83	310228951	Brat	https://cdn-images.dzcdn.net/images/artist/0646f9401f8d86ec081da993a9fb718b/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
84	380425731	Brat	https://cdn-images.dzcdn.net/images/artist/c51bb1853d2fcd891b616d61ca4ca613/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
85	11665341	Jala Brat	https://cdn-images.dzcdn.net/images/artist/59c68f8faae5261f3df5494f8290d6ef/1000x1000-000000-80-0-0.jpg	101	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
86	7071665	Гио ПиКа	https://cdn-images.dzcdn.net/images/artist/520b6e8aa9a6945ddfbc2c863b615e79/1000x1000-000000-80-0-0.jpg	94	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
87	380426441	Brat	https://cdn-images.dzcdn.net/images/artist/7df728fb70ff28b2fd41f60dd8bffa5a/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
88	1462230	Charli xcx	https://cdn-images.dzcdn.net/images/artist/5a4f593c65c71292b4389e871f76c023/1000x1000-000000-80-0-0.jpg	112	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
89	8720732	Macan	https://cdn-images.dzcdn.net/images/artist/f228eb5b70ee5ef5295ca1fac4e5455a/1000x1000-000000-80-0-0.jpg	67	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
90	1432119	DEZI	https://cdn-images.dzcdn.net/images/artist/259ffc8799893b72ca8eeb7a8fa69ac4/1000x1000-000000-80-0-0.jpg	25	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
91	7576432	Montell Fish	https://cdn-images.dzcdn.net/images/artist/24b966e608fa8a459c73b0e2252fd92b/1000x1000-000000-80-0-0.jpg	49	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
92	163258297	Disney Lofi	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	7	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
93	318723281	Kolby Fisher	https://cdn-images.dzcdn.net/images/artist/c40b92645e2230b83c56d501c12a76c2/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
94	62577652	The Lo-Fi's	https://cdn-images.dzcdn.net/images/artist/c920f80f6082288fbcac2c48b3775fa9/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
95	58536592	Ben Logan & the Lo-Fis	https://cdn-images.dzcdn.net/images/artist/94fcb9e2c5b901217bc7d65d71a7e7eb/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
96	56125	FISHER	https://cdn-images.dzcdn.net/images/artist/86e22d6af3b1dbef69c9134a701a1e28/1000x1000-000000-80-0-0.jpg	25	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
97	65574	Steve Lacy	https://cdn-images.dzcdn.net/images/artist/1ddf70d9445da4439a16bfea909d77f6/1000x1000-000000-80-0-0.jpg	21	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
98	102262192	OTOY	https://cdn-images.dzcdn.net/images/artist/fbe499f46fa7a4f84c0e76e8cebbc37d/1000x1000-000000-80-0-0.jpg	39	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
99	1182	Arctic Monkeys	https://cdn-images.dzcdn.net/images/artist/6c03e4c7c36800897fd468633286db24/1000x1000-000000-80-0-0.jpg	35	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
100	10468777	Magdalena Bay	https://cdn-images.dzcdn.net/images/artist/d997d33abc84ad8158e6379c84eeb761/1000x1000-000000-80-0-0.jpg	41	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
101	244332	Imaginasamba	https://cdn-images.dzcdn.net/images/artist/ef8ddd14bdf596bfb98c5d1f2105a9d3/1000x1000-000000-80-0-0.jpg	55	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
102	12566664	Welcome To Hell	https://cdn-images.dzcdn.net/images/artist/4254cf7622c58dd3373d4194f0730de5/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
103	54564552	Ensemble Welcome To Hell	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
104	353582	Siwel	https://cdn-images.dzcdn.net/images/artist/9e1bd5aa47cbd98279acc1ea3cfb4178/1000x1000-000000-80-0-0.jpg	12	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
105	72030	Gothminister	https://cdn-images.dzcdn.net/images/artist/980f02ba5b3b7ed6e1de5fde7ce7c5da/1000x1000-000000-80-0-0.jpg	28	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
106	180746	MONO INC.	https://cdn-images.dzcdn.net/images/artist/518b12d94129f3498cc92512d33f9f14/1000x1000-000000-80-0-0.jpg	41	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
107	459	Sum 41	https://cdn-images.dzcdn.net/images/artist/4e050809d936853e333deb5331dbc476/1000x1000-000000-80-0-0.jpg	28	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
108	399141	Rhino Bucket	https://cdn-images.dzcdn.net/images/artist/dcf21a2de569631e09190738bc73e6e0/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
109	448595	This Charming Man	https://cdn-images.dzcdn.net/images/artist/0a782767e2f3e3391fefd0bf5845605d/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
110	1297	The Smiths	https://cdn-images.dzcdn.net/images/artist/458e4ee61a7fc57a79ac2b9b20c47bd9/1000x1000-000000-80-0-0.jpg	17	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
111	1387	Nouvelle Vague	https://cdn-images.dzcdn.net/images/artist/e5632a779c57b226753356cec9133fdc/1000x1000-000000-80-0-0.jpg	25	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
112	573304	Johnny Marr	https://cdn-images.dzcdn.net/images/artist/318e533e6129c1c6eb838e0f823e2983/1000x1000-000000-80-0-0.jpg	39	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
113	167831	Cannibal	https://cdn-images.dzcdn.net/images/artist/981fcd4994b7474ca9adde9ed05f4267/1000x1000-000000-80-0-0.jpg	51	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
114	132853262	EZ Band	https://cdn-images.dzcdn.net/images/artist/4a86b9a614bacdca415ba18057b0f16e/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
115	141057192	Johnny Mitch	https://cdn-images.dzcdn.net/images/artist/190bb2e978b69906b5f0124111eb3245/1000x1000-000000-80-0-0.jpg	7	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
116	383	Death Cab For Cutie	https://cdn-images.dzcdn.net/images/artist/3f44f1d9518985b54ecdaf08994ce027/1000x1000-000000-80-0-0.jpg	60	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
117	116047382	my dead girlfriend	https://cdn-images.dzcdn.net/images/artist/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
118	14546477	Black Dresses	https://cdn-images.dzcdn.net/images/artist/4d4d9e1e25541739cb97f2b82c29d517/1000x1000-000000-80-0-0.jpg	18	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
119	201103587	Squid Pisser	https://cdn-images.dzcdn.net/images/artist/f041a5694be53fe29f0e425c4fae3575/1000x1000-000000-80-0-0.jpg	14	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
120	488044	The Slugz	https://cdn-images.dzcdn.net/images/artist/2f2d9c303f69d7d7640fbce90eb08aa4/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
121	68580	Sexy sushi	https://cdn-images.dzcdn.net/images/artist/17d94d1e97a08b8faf33cfb21a5500ff/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
122	4861539	Sexy Music Band	https://cdn-images.dzcdn.net/images/artist/68536b9430d321d882c24a9b2fed4a92/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
123	1398813	Sexy Music	https://cdn-images.dzcdn.net/images/artist/519e70fd2bce6d746b45e5f2b0c96669/1000x1000-000000-80-0-0.jpg	12	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
124	3840661	Sexy Music Lounge	https://cdn-images.dzcdn.net/images/artist/fd0a31760c732989c079ecc94b524496/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
125	4547564	Sexy Music Mar DJ	https://cdn-images.dzcdn.net/images/artist/88a0933c075ea9f64f67b381657fbf4d/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
126	569	The Strokes	https://cdn-images.dzcdn.net/images/artist/88e8ecd06aae5cd69d414af57a67f339/1000x1000-000000-80-0-0.jpg	18	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
127	5362155	Minuit Machine	https://cdn-images.dzcdn.net/images/artist/c95a197dee96829eadda2cdb98170e25/1000x1000-000000-80-0-0.jpg	22	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
128	6927	Carter the Unstoppable Sex Machine	https://cdn-images.dzcdn.net/images/artist/b8c9a2ca4923bc12906719c8112276a3/1000x1000-000000-80-0-0.jpg	31	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
129	98335212	Никита Моргенштерн	https://cdn-images.dzcdn.net/images/artist/2828e48de9af3a780068fe488032953c/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
130	294237341	Ярослава Моргенштерн	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
131	98151	ERM	https://cdn-images.dzcdn.net/images/artist/67f7b4cd51f156f7c1c52d58c5c31f73/1000x1000-000000-80-0-0.jpg	16	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
132	78116442	PunkShow	https://cdn-images.dzcdn.net/images/artist/502009962d2809ceefc7bc944ec51a84/1000x1000-000000-80-0-0.jpg	73	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
133	4170146	Баста	https://cdn-images.dzcdn.net/images/artist/bac9a8bce57b3feb07a8a69b985032b1/1000x1000-000000-80-0-0.jpg	113	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
134	68813	Lida	https://cdn-images.dzcdn.net/images/artist/80c223be3e0e9ae1c89ed76e487eef53/1000x1000-000000-80-0-0.jpg	64	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
135	131611392	Коделак	https://cdn-images.dzcdn.net/images/artist/86ade36185b70796396bbd002ad5a174/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
136	3110841	DZIDZIO	https://cdn-images.dzcdn.net/images/artist/058e135cc832c00ca39ec368c0b4f45a/1000x1000-000000-80-0-0.jpg	33	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
137	68961602	Кисло-сладкий	https://cdn-images.dzcdn.net/images/artist/4a8c74b4c9207b1957900386390b8039/1000x1000-000000-80-0-0.jpg	39	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
138	4806784	Юрий Визбор	https://cdn-images.dzcdn.net/images/artist/fcd07825439ba60c21dc5f65a609c4a5/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
139	5175857	Олег Митяев	https://cdn-images.dzcdn.net/images/artist/23e712d3c6f208cd30f2ea4fbca4c8d1/1000x1000-000000-80-0-0.jpg	36	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
140	55109182	METRO PRO	https://cdn-images.dzcdn.net/images/artist/26ac05516772187992b7020beb945ae3/1000x1000-000000-80-0-0.jpg	39	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
141	6189150	Нэнси	https://cdn-images.dzcdn.net/images/artist/25c3da9067e89904a65489f482c8f691/1000x1000-000000-80-0-0.jpg	33	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
142	97526152	İMera	https://cdn-images.dzcdn.net/images/artist/0d1b1cde77f2e5141b63b5799c68be28/1000x1000-000000-80-0-0.jpg	44	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
143	371198551	Люта Зневага	https://cdn-images.dzcdn.net/images/artist/0680ea7ad731a4086d3a5cbec7274f33/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
144	230	Kanye West	https://cdn-images.dzcdn.net/images/artist/bb76c2ee3b068726ab4c37b0aabdb57a/1000x1000-000000-80-0-0.jpg	69	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
145	313551521	Kanye West	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
146	4099199	Yé	https://cdn-images.dzcdn.net/images/artist/bee7027021b52bb1b7487eee1cd82244/1000x1000-000000-80-0-0.jpg	51	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
147	11198106	Kanye West & Nas	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
148	171221527	Kanye West & XXXTENTACION	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
149	1309	JAŸ-Z	https://cdn-images.dzcdn.net/images/artist/a59aabd18e84d732ce3b9f6f5c4e5f50/1000x1000-000000-80-0-0.jpg	40	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
150	7347888	Steampianist	https://cdn-images.dzcdn.net/images/artist/8bfd83468fea6807d6957e94d1175fc5/1000x1000-000000-80-0-0.jpg	17	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
151	67334	Antony & The Johnsons	https://cdn-images.dzcdn.net/images/artist/609d39447544a75ee3ea229d6f49bc34/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
152	13082199	Escape-ism	https://cdn-images.dzcdn.net/images/artist/111e0bd21f24de15698875d5b77af778/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
153	68659522	Bertoia	https://cdn-images.dzcdn.net/images/artist/f6fc1506766aeebf8c1245db775bcc5a/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
154	258854	Blutopia	https://cdn-images.dzcdn.net/images/artist/e705863cd6e12bcf4f6f0f71c9061140/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
155	1447002	Ben Tapia	https://cdn-images.dzcdn.net/images/artist/411b911d8cacbfbc49c2bf71bcd97244/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
156	5269070	Beateria	https://cdn-images.dzcdn.net/images/artist/049ab175f145cc08f501e3258f078615/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
157	1401745	The Best Piano	https://cdn-images.dzcdn.net/images/artist/c0bd48814e6432d742e11c284e4ce6d5/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
158	133618442	Вектор А	https://cdn-images.dzcdn.net/images/artist/0a6976e5ec790357ae94840444608417/1000x1000-000000-80-0-0.jpg	33	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
159	13499081	beabadoobee	https://cdn-images.dzcdn.net/images/artist/9a677342b08c4ce2ed2d75e8ebfd5b85/1000x1000-000000-80-0-0.jpg	36	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
160	115382322	Troy	https://cdn-images.dzcdn.net/images/artist/30235c45e3eb17ec5534c211fff03185/1000x1000-000000-80-0-0.jpg	4	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
161	9498	ASP	https://cdn-images.dzcdn.net/images/artist/a790a03f5be854c5f8fb7b3c748510c1/1000x1000-000000-80-0-0.jpg	27	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
162	13999305	Jonah Senzel	https://cdn-images.dzcdn.net/images/artist/54392de32a01f1e334131df0758ecf96/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
163	58568762	Camilo	https://cdn-images.dzcdn.net/images/artist/4cfeee11e242345430528870250f0b72/1000x1000-000000-80-0-0.jpg	59	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
164	754	Garou	https://cdn-images.dzcdn.net/images/artist/c7a85a87e3ec068025dea28669132ec8/1000x1000-000000-80-0-0.jpg	23	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
165	321764371	Damon Solis	https://cdn-images.dzcdn.net/images/artist/52aeaef9ce8a9e5231bece52fb95f9d7/1000x1000-000000-80-0-0.jpg	5	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
166	4430326	Tatsuro Yamashita	https://cdn-images.dzcdn.net/images/artist/a6aee680c3a4c7b0fd6c7bdf624923a4/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
167	5338160	Dan Gibson's Solitudes	https://cdn-images.dzcdn.net/images/artist/a146eaa56cbcf807d72003a08802fb39/1000x1000-000000-80-0-0.jpg	268	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
168	350566872	Prod.Nifour	https://cdn-images.dzcdn.net/images/artist/782f275d3556ee61064530056ba6bf90/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
169	4277041	Héctor "El Father"	https://cdn-images.dzcdn.net/images/artist/6800a19ab85deb0b762c952a2dc7f6a8/1000x1000-000000-80-0-0.jpg	10	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
170	51708732	SawanoHiroyuki[nZk]	https://cdn-images.dzcdn.net/images/artist/644748be784454ade66dee34c5a65142/1000x1000-000000-80-0-0.jpg	43	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
171	103851292	DJ Japa NK	https://cdn-images.dzcdn.net/images/artist/4eb00e15a592d161570f822a174af1d2/1000x1000-000000-80-0-0.jpg	128	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
172	14256	Al Bano & Romina Power	https://cdn-images.dzcdn.net/images/artist/3ce33b833c23b9f364cd5234b4309f05/1000x1000-000000-80-0-0.jpg	26	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
173	831	ASIAN KUNG-FU GENERATION	https://cdn-images.dzcdn.net/images/artist/a3470c73fa847c7872018577390a2b54/1000x1000-000000-80-0-0.jpg	82	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
174	253044772	ASIAN KUNG-FU GENERATION, ROTH BART BARON	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
175	14417559	Asian Kung-fu Generation & Eriko Hashimoto	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
176	149529362	ASIAN KUNG-FU GENERATION & Hiroko Sebu	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
177	163735377	ASIAN KUNG-FU GENERATION feat. Rachel & OMSB	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
178	1619572	Mac Demarco	https://cdn-images.dzcdn.net/images/artist/b468329467ac01256a85e0925026715d/1000x1000-000000-80-0-0.jpg	38	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
179	209104	Quatuor de Saxophones de Luxembourg, Guy Goethals, Marc Hoffmann, Marco Puetz, Roland Schneider	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
180	399	Radiohead	https://cdn-images.dzcdn.net/images/artist/96b688020014a21cb80a0268b90287f5/1000x1000-000000-80-0-0.jpg	45	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
181	323887691	Radiohead	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
182	1431492	Gigamesh	https://cdn-images.dzcdn.net/images/artist/dc5af92476868f6e0de3bf1cc77b6fda/1000x1000-000000-80-0-0.jpg	20	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
183	7888234	Kelly Lee Owens	https://cdn-images.dzcdn.net/images/artist/9253c23ce2135938593e232008de2821/1000x1000-000000-80-0-0.jpg	41	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
184	53477202	DJ Radiohead	https://cdn-images.dzcdn.net/images/artist/b58f051742ef450c20af6219fd4df2f1/1000x1000-000000-80-0-0.jpg	29	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
185	247635892	Nujabes / fat jon	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
186	2927	Mindless Self Indulgence	https://cdn-images.dzcdn.net/images/artist/d2d5eaf908e1d6c60f61b7c7d1ed377a/1000x1000-000000-80-0-0.jpg	16	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
187	1194083	Tyler, The Creator	https://cdn-images.dzcdn.net/images/artist/5eceecd683beab6dd901a7931294a121/1000x1000-000000-80-0-0.jpg	29	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
188	170414187	Отойди поближе	https://cdn-images.dzcdn.net/images/artist/4198322a6336e43b238686a977e9023c/1000x1000-000000-80-0-0.jpg	31	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
189	4981244	Кажэ Обойма	https://cdn-images.dzcdn.net/images/artist/c3fbcafa9e33d3fbadcc767dac808d63/1000x1000-000000-80-0-0.jpg	31	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
190	8375166	Каже Обойма	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
191	4321024	Kazhe Oboyma	https://cdn-images.dzcdn.net/images/artist/da91447e8f68277357362196e7a83d0f/1000x1000-000000-80-0-0.jpg	7	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
192	180436487	Милиан О'Войд	https://cdn-images.dzcdn.net/images/artist/ad65fdfbb871ad87bbdd2daee198ea34/1000x1000-000000-80-0-0.jpg	10	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
193	237017471	yungalligator	https://cdn-images.dzcdn.net/images/artist/3752dfaaab0ab2e97f2dc1d9ae06d8dc/1000x1000-000000-80-0-0.jpg	17	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
194	4520880	Александр Малинин	https://cdn-images.dzcdn.net/images/artist/9146e07ea589da49b3cfa8430fd37f40/1000x1000-000000-80-0-0.jpg	27	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
195	8005180	Олег Погудин	https://cdn-images.dzcdn.net/images/artist/abb4754656257f2445eee4a257777bab/1000x1000-000000-80-0-0.jpg	14	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
196	9210206	ШANA	https://cdn-images.dzcdn.net/images/artist/5a337e971510d565ffe8d92ec850da86/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
197	331334	Konfuz	https://cdn-images.dzcdn.net/images/artist/253a2676895fb8630864090da3c73a6b/1000x1000-000000-80-0-0.jpg	40	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
198	14814761	Kavabanga Depo Kolibri	https://cdn-images.dzcdn.net/images/artist/e01ccdd2f797ed3e5ee6575bb98f6691/1000x1000-000000-80-0-0.jpg	131	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
199	171944	Esco	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	213	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
200	484281	Billy's Band	https://cdn-images.dzcdn.net/images/artist/bf70a96d4adeec6b7864d69b7ab04da0/1000x1000-000000-80-0-0.jpg	22	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
201	2519	The Notorious B.I.G.	https://cdn-images.dzcdn.net/images/artist/87e928a899c183eb10f1da14db7485dd/1000x1000-000000-80-0-0.jpg	41	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
202	11060562	Oklou	https://cdn-images.dzcdn.net/images/artist/62264e9e14517893902490de935bc5dd/1000x1000-000000-80-0-0.jpg	32	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
203	127170	Itoiz	https://cdn-images.dzcdn.net/images/artist/07f75c26f8b80df993f9c5012365eb7c/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
204	1083	DJ Ötzi	https://cdn-images.dzcdn.net/images/artist/2acd4149595fd3d956f5f81be48b2331/1000x1000-000000-80-0-0.jpg	60	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
205	326541	Akelarre	https://cdn-images.dzcdn.net/images/artist/4bedb2ca98f2c5130d72eef2a372d9c1/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
206	382294	Diabulus in Musica	https://cdn-images.dzcdn.net/images/artist/e374e40fd8e4e7e138f330eec83993ee/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
207	143861522	OTOI	https://cdn-images.dzcdn.net/images/artist/e3e8b44cf53eec51cbc2c2de534f1dce/1000x1000-000000-80-0-0.jpg	7	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
208	128414082	bawn	https://cdn-images.dzcdn.net/images/artist/f598fba52bb7095826908acbd7e8bb8d/1000x1000-000000-80-0-0.jpg	35	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
209	8853864	Banners	https://cdn-images.dzcdn.net/images/artist/ab9e08a4455b3b57ac7f3b2aa68679cb/1000x1000-000000-80-0-0.jpg	55	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
210	10172688	Gawne	https://cdn-images.dzcdn.net/images/artist/ca4c8b0cd11c1711cffc088724c7631a/1000x1000-000000-80-0-0.jpg	124	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
211	9074712	Barns Courtney	https://cdn-images.dzcdn.net/images/artist/d786c916239016ad288d086940490760/1000x1000-000000-80-0-0.jpg	31	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
212	1561519	HASN	https://cdn-images.dzcdn.net/images/artist/2a2168cce2ddd4414fff278cd5e08736/1000x1000-000000-80-0-0.jpg	17	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
213	216919365	Сусіди Стерплять	https://cdn-images.dzcdn.net/images/artist/35b503a93c26c064b65b77a4eeb92c02/1000x1000-000000-80-0-0.jpg	30	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
214	129614992	Яна Тихонова	https://cdn-images.dzcdn.net/images/artist/a724155df5ee46f08c4e35ffc06cc8ce/1000x1000-000000-80-0-0.jpg	7	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
215	10726119	Инструментальный квартет п/у Бориса Тихонова	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
216	352369062	Инструментальный септет п/у Бориса Тихонова	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
217	124567642	Rohata Zhaba	https://cdn-images.dzcdn.net/images/artist/c388080e346ac6df602812a9627036a0/1000x1000-000000-80-0-0.jpg	11	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
218	11285170	Марина і компанія	https://cdn-images.dzcdn.net/images/artist/e8bc2457542c2c99354f5812a6c22f93/1000x1000-000000-80-0-0.jpg	48	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
219	5343100	Руся	https://cdn-images.dzcdn.net/images/artist/251aa23089e57ca68ea1b6904a0de716/1000x1000-000000-80-0-0.jpg	47	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
220	220543155	Victoria Niro	https://cdn-images.dzcdn.net/images/artist/3adf46e5ef4ec52e828695fb77aa0134/1000x1000-000000-80-0-0.jpg	5	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
221	7872896	Христина Соловій	https://cdn-images.dzcdn.net/images/artist/10785e06c02728889aa38d29e0efe92d/1000x1000-000000-80-0-0.jpg	28	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
222	14003525	Довгий Пес	https://cdn-images.dzcdn.net/images/artist/d49a42836a2a7022bd36d58e62135ab8/1000x1000-000000-80-0-0.jpg	52	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
223	12054664	Zwyntar	https://cdn-images.dzcdn.net/images/artist/f5a0b686e228612b5aada0cad54c8e05/1000x1000-000000-80-0-0.jpg	13	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
224	5570625	Aystar	https://cdn-images.dzcdn.net/images/artist/0cf5a2f303ccb411a2b0e1d61d795300/1000x1000-000000-80-0-0.jpg	35	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
225	317569811	Syntax	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	15	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
226	1548700	Syntra	https://cdn-images.dzcdn.net/images/artist/c3e31eeb54373955bef3aa4a9fb2bc2d/1000x1000-000000-80-0-0.jpg	11	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
227	2062021	Antar	https://cdn-images.dzcdn.net/images/artist/5259730cb47ec71250e850a8c8f16e05/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
228	287947661	Третя Штурмова	https://cdn-images.dzcdn.net/images/artist/81f7e046d09d7548ec4c66cafd1f5800/1000x1000-000000-80-0-0.jpg	29	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
229	310208771	Військовий стан	https://cdn-images.dzcdn.net/images/artist/c3430697ff4515b23c02385b3af634d6/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
230	239557881	Domiy	https://cdn-images.dzcdn.net/images/artist/896ad96450ea7c4e3c27dea53bf86480/1000x1000-000000-80-0-0.jpg	24	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
231	94883992	ВІЙ	https://cdn-images.dzcdn.net/images/artist/e47169dcf33e55be2be5fb5c0cb75b18/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
232	12904065	Харцизи	https://cdn-images.dzcdn.net/images/artist/2fad3c50a24ab5e0bcdcbf90b175eb46/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
233	12521498	Харизма	https://cdn-images.dzcdn.net/images/artist/4ecef30a7fa48b0346ef8e62659903bd/1000x1000-000000-80-0-0.jpg	24	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
234	8891012	Валерій Харчишин	https://cdn-images.dzcdn.net/images/artist/ea974a3d6a6f317c17bbf62a3acbbf6e/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
235	14107147	Powfu	https://cdn-images.dzcdn.net/images/artist/4a0479e8e96bf1044f3e075b3fdb8c83/1000x1000-000000-80-0-0.jpg	79	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
236	288166	Justin Bieber	https://cdn-images.dzcdn.net/images/artist/fe097f693cebf1f882e3da79e99e3bf9/1000x1000-000000-80-0-0.jpg	60	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
237	126335112	Rosé	https://cdn-images.dzcdn.net/images/artist/dca80c50292476001830d88019cdd2f2/1000x1000-000000-80-0-0.jpg	6	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
238	225697885	Justin Bieber - Piano Covers	https://cdn-images.dzcdn.net/images/artist/ec6fe37fcdec781df628fdf9bd25073f/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
239	5531258	SZA	https://cdn-images.dzcdn.net/images/artist/8ced041da2bed70d5715f0860956169b/1000x1000-000000-80-0-0.jpg	40	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
240	331665651	Justin Bieber HM	https://cdn-images.dzcdn.net/images/artist/836fc09d5cad4726c225ceb5bf736e05/1000x1000-000000-80-0-0.jpg	7	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
241	51204222	The Kid LAROI	https://cdn-images.dzcdn.net/images/artist/784b991057e2b8c07e8b9687a79502ce/1000x1000-000000-80-0-0.jpg	52	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
242	12369444	Laufey	https://cdn-images.dzcdn.net/images/artist/0eca5dd5f8ac336e55bf390da9ce13d0/1000x1000-000000-80-0-0.jpg	39	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
243	2025	Cyndi Lauper	https://cdn-images.dzcdn.net/images/artist/05b343dd206c2ac4cca081948ddb3e7f/1000x1000-000000-80-0-0.jpg	41	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
244	103702992	Laufey Soffia	https://cdn-images.dzcdn.net/images/artist/324cdafae74341505ce0ff88f648a8c3/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
245	6303698	Lainey Wilson	https://cdn-images.dzcdn.net/images/artist/b0e44295204ab831d9e8744236c3cf27/1000x1000-000000-80-0-0.jpg	32	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
246	214497065	Sigríður Laufey Sigurjónsdóttir	https://cdn-images.dzcdn.net/images/artist/c6851d0be670f8d85fb98ab689550970/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
247	112676122	~ronzoni~	https://cdn-images.dzcdn.net/images/artist/f84a393c3aa2681243d6686dd8ba7a5d/1000x1000-000000-80-0-0.jpg	24	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
248	185686007	~ QueenRahana ~	https://cdn-images.dzcdn.net/images/artist/528f414d4277484ea97b20410040b8c0/1000x1000-000000-80-0-0.jpg	3	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
249	97532512	~Nois	https://cdn-images.dzcdn.net/images/artist/962e912894785f37350b4fd5e5d70394/1000x1000-000000-80-0-0.jpg	17	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
250	49757272	~Sea of Disorder~	https://cdn-images.dzcdn.net/images/artist/16b583fb002a8166937ffca020769288/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
251	66222832	~flynn	https://cdn-images.dzcdn.net/images/artist/3834f7d49e02a01404e4186168265cb0/1000x1000-000000-80-0-0.jpg	20	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
252	391403	Touché Amoré	https://cdn-images.dzcdn.net/images/artist/04fe682f6a1b4f1580d37eefc56eb0e3/1000x1000-000000-80-0-0.jpg	38	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
253	535	Deftones	https://cdn-images.dzcdn.net/images/artist/a4fab59f82dc48f2c636ce8497282e67/1000x1000-000000-80-0-0.jpg	36	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
254	4269318	The Rose	https://cdn-images.dzcdn.net/images/artist/96ed0b0fcf4ab765257bff70fcd460b4/1000x1000-000000-80-0-0.jpg	20	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
255	7810880	A Secret Revealed	https://cdn-images.dzcdn.net/images/artist/f838a8f0c27cc7b870cb643ecfe9db14/1000x1000-000000-80-0-0.jpg	10	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
256	4677655	Lauv	https://cdn-images.dzcdn.net/images/artist/487f1e3bd864cfc040bbe5318fc383ea/1000x1000-000000-80-0-0.jpg	65	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
257	48925411	Ana Roxanne	https://cdn-images.dzcdn.net/images/artist/0155b73e6989a2595f3a73330a0ff4e1/1000x1000-000000-80-0-0.jpg	8	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
258	1369663	Radboud Mens	https://cdn-images.dzcdn.net/images/artist/3e099385b86a4c736ef11119e8cc2da6/1000x1000-000000-80-0-0.jpg	21	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
259	420	Alien Ant Farm	https://cdn-images.dzcdn.net/images/artist/35c53c4074fc3c2022c51c7788c92092/1000x1000-000000-80-0-0.jpg	10	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
260	341517991	Malace Mizer	https://cdn-images.dzcdn.net/images/artist/68f46eb6c84b42fa989577a610e27d1d/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
261	205033087	From Misery to Malice	https://cdn-images.dzcdn.net/images/artist/61897bf0b1de5c921d349df72b655152/1000x1000-000000-80-0-0.jpg	5	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
262	361238552	Copa	https://cdn-images.dzcdn.net/images/artist/f6c92757f00eaf9124e8e86d84cabd58/1000x1000-000000-80-0-0.jpg	78	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
263	177007957	SUPER DJ'S MUSIC	https://cdn-images.dzcdn.net/images/artist/1096485c5b785dec5345ee926588bba4/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
264	112709462	Hikaya	https://cdn-images.dzcdn.net/images/artist/f68cbfd23d58792399b8c79d5effe070/1000x1000-000000-80-0-0.jpg	9	2026-07-06 13:33:02.149504	2026-07-09 12:19:15.990432
265	351645962	Leciel	https://cdn-images.dzcdn.net/images/artist/d5202e145ca86f8465667d00c0001eaa/1000x1000-000000-80-0-0.jpg	2	2026-07-06 13:36:04.716088	2026-07-09 12:19:15.990432
266	251627052	CIEL.	https://cdn-images.dzcdn.net/images/artist/d2138b88c8ef53d07ce98fa95eda8051/1000x1000-000000-80-0-0.jpg	16	2026-07-06 13:36:04.716088	2026-07-09 12:19:15.990432
267	345670541	Les Ciel	https://cdn-images.dzcdn.net/images/artist/a630f0517139020264bc426ce94f87d5/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:36:04.716088	2026-07-09 12:19:15.990432
268	50574642	Dj Léo le kdo du ciel	https://cdn-images.dzcdn.net/images/artist/11bba6c2c4556596501d5b4a4c5ea3fa/1000x1000-000000-80-0-0.jpg	20	2026-07-06 13:36:04.716088	2026-07-09 12:19:15.990432
269	106544332	CIEL	https://cdn-images.dzcdn.net/images/artist/c9a8b2259c98fe85b7712600e453e447/1000x1000-000000-80-0-0.jpg	18	2026-07-06 13:36:04.716088	2026-07-09 12:19:15.990432
270	198	Céline Dion	https://cdn-images.dzcdn.net/images/artist/e3ae78e5c49ed42342513d5a248b9c4c/1000x1000-000000-80-0-0.jpg	71	2026-07-06 13:36:05.103562	2026-07-09 12:19:15.990432
271	186477787	Seven Starr	https://cdn-images.dzcdn.net/images/artist/1f9850a4d989e915c1817f833455f6b4/1000x1000-000000-80-0-0.jpg	14	2026-07-06 13:36:05.103562	2026-07-09 12:19:15.990432
272	13314683	Bon Entendeur	https://cdn-images.dzcdn.net/images/artist/549bc8843ad63c1e162eb5c23f8ab806/1000x1000-000000-80-0-0.jpg	33	2026-07-06 13:36:05.103562	2026-07-09 12:19:15.990432
273	399799441	:Х	https://cdn-images.dzcdn.net/images/artist/30b147ccefae586fb9d5840dceb2d7e4/1000x1000-000000-80-0-0.jpg	1	2026-07-06 13:36:05.103562	2026-07-09 12:19:15.990432
274	1520407	Christine and the Queens	https://cdn-images.dzcdn.net/images/artist/ca9abfe880ec47890f184b7523f463d7/1000x1000-000000-80-0-0.jpg	44	2026-07-06 13:36:05.103562	2026-07-09 12:19:15.990432
275	6754503	Retro X	https://cdn-images.dzcdn.net/images/artist/82efab6c8b04ed6a170579136d0725f6/1000x1000-000000-80-0-0.jpg	49	2026-07-06 13:36:06.528082	2026-07-09 12:19:15.990432
276	137732022	MTZx	https://cdn-images.dzcdn.net/images/artist/d3a1a79fd679dc6532cf5893877aafe8/1000x1000-000000-80-0-0.jpg	28	2026-07-06 13:36:06.528082	2026-07-09 12:19:15.990432
277	88243052	Martin Manson	https://cdn-images.dzcdn.net/images/artist/d87605bd28fd3861d3e50744fa3685cb/1000x1000-000000-80-0-0.jpg	38	2026-07-06 13:36:06.528082	2026-07-09 12:19:15.990432
278	1041708	Témé Tan	https://cdn-images.dzcdn.net/images/artist/a4b52f3b9addbdc0f9298af9b8544057/1000x1000-000000-80-0-0.jpg	19	2026-07-06 13:36:06.528082	2026-07-09 12:19:15.990432
279	241869	Marvin Winans	https://cdn-images.dzcdn.net/images/artist/6b336204014d9aae7050567dc7db2a78/1000x1000-000000-80-0-0.jpg	5	2026-07-07 18:00:56.57565	2026-07-09 12:19:15.990432
280	83843482	Love Regenerator	https://cdn-images.dzcdn.net/images/artist/e9fa4e08293fc9b8a189c396e71251a8/1000x1000-000000-80-0-0.jpg	13	2026-07-08 10:23:27.857369	2026-07-09 12:19:15.990432
281	4221392	Swa	https://cdn-images.dzcdn.net/images/artist/8367112bff0262d050bfe94692b2eba2/1000x1000-000000-80-0-0.jpg	28	2026-07-08 10:25:51.082625	2026-07-09 12:19:15.990432
282	7627172	Swae Lee	https://cdn-images.dzcdn.net/images/artist/7d66cba93af97719dc9f10e31c328023/1000x1000-000000-80-0-0.jpg	30	2026-07-08 10:25:51.082625	2026-07-09 12:19:15.990432
283	317282	Swanky Tunes	https://cdn-images.dzcdn.net/images/artist/3118ebc62d97e7d5fe333ffe02bc96f7/1000x1000-000000-80-0-0.jpg	176	2026-07-08 10:25:51.082625	2026-07-09 12:19:15.990432
284	6926	Swans	https://cdn-images.dzcdn.net/images/artist/41ec13c7a4f13394a675fadd38b1fa57/1000x1000-000000-80-0-0.jpg	37	2026-07-08 10:25:51.082625	2026-07-09 12:19:15.990432
285	133150	Swallow The Sun	https://cdn-images.dzcdn.net/images/artist/e2c7fdc00ff93b9001964cfcf9136e93/1000x1000-000000-80-0-0.jpg	26	2026-07-08 10:25:51.082625	2026-07-09 12:19:15.990432
286	1	The Beatles	https://cdn-images.dzcdn.net/images/artist/fe9eb4463ea87452e84ed97e0c86b878/1000x1000-000000-80-0-0.jpg	45	2026-07-08 10:34:48.878109	2026-07-09 12:19:15.990432
287	6239220	Beat-les	https://cdn-images.dzcdn.net/images/artist/85f49d6b4a49ee7abb7660581cdf431b/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:34:48.878109	2026-07-09 12:19:15.990432
288	94217	The Beatles Revival Band	https://cdn-images.dzcdn.net/images/artist/629c3b461f9832c2747efb34ec83d4f7/1000x1000-000000-80-0-0.jpg	6	2026-07-08 10:34:48.878109	2026-07-09 12:19:15.990432
289	131444982	Beatles Cordel	https://cdn-images.dzcdn.net/images/artist/4274d23c8d98ca563c322f5fb828ad1a/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:34:48.878109	2026-07-09 12:19:15.990432
290	11386468	Blues Beatles	https://cdn-images.dzcdn.net/images/artist/c7216fff4cb7f77887451f1a7b8230a9/1000x1000-000000-80-0-0.jpg	4	2026-07-08 10:34:48.878109	2026-07-09 12:19:15.990432
291	226	John Lennon	https://cdn-images.dzcdn.net/images/artist/ef6244c655e8cbe91eeb56bb6f934176/1000x1000-000000-80-0-0.jpg	46	2026-07-08 10:37:43.917939	2026-07-09 12:19:15.990432
292	1364241	Abbey Road All-Stars	https://cdn-images.dzcdn.net/images/artist/dd12398d3858577865743bfde9a2e07a/1000x1000-000000-80-0-0.jpg	1	2026-07-08 10:38:08.047226	2026-07-09 12:19:15.990432
297	366683	DJ Yoda	https://cdn-images.dzcdn.net/images/artist/ccc2219df564935229e46b1c6e57a428/1000x1000-000000-80-0-0.jpg	28	2026-07-08 10:38:08.248084	2026-07-09 12:19:15.990432
298	114	ERA	https://cdn-images.dzcdn.net/images/artist/1a095ea779bdb234b7fefaadca5c8403/1000x1000-000000-80-0-0.jpg	18	2026-07-08 10:38:08.248084	2026-07-09 12:19:15.990432
299	181985	Marsimoto	https://cdn-images.dzcdn.net/images/artist/6595f00a70573cbe145cdb11eac38c4f/1000x1000-000000-80-0-0.jpg	19	2026-07-08 10:38:08.248084	2026-07-09 12:19:15.990432
300	63273652	Mara Sattei	https://cdn-images.dzcdn.net/images/artist/394b60b7a1d6a04c039ac2199f7fddef/1000x1000-000000-80-0-0.jpg	26	2026-07-08 10:38:08.248084	2026-07-09 12:19:15.990432
301	59056602	Diana Herrera	https://cdn-images.dzcdn.net/images/artist/d88ccd26ebc2d58bf1b0f8e325709c0f/1000x1000-000000-80-0-0.jpg	3	2026-07-08 10:38:08.248084	2026-07-09 12:19:15.990432
302	563079	Habibi	https://cdn-images.dzcdn.net/images/artist/058be634aba1ded2032f9a54ba1c8a08/1000x1000-000000-80-0-0.jpg	17	2026-07-08 10:44:04.044114	2026-07-09 12:19:15.990432
303	142280292	Habibi	https://cdn-images.dzcdn.net/images/artist/d41d8cd98f00b204e9800998ecf8427e/1000x1000-000000-80-0-0.jpg	51	2026-07-08 10:44:04.044114	2026-07-09 12:19:15.990432
304	124787332	Habibi	https://cdn-images.dzcdn.net/images/artist/7a9caa82314089d08ffaea60a5ec218e/1000x1000-000000-80-0-0.jpg	28	2026-07-08 10:44:04.044114	2026-07-09 12:19:15.990432
305	120662682	HABIBI	https://cdn-images.dzcdn.net/images/artist/38b26989e3fb7d08656b4748e0cbd798/1000x1000-000000-80-0-0.jpg	15	2026-07-08 10:44:04.044114	2026-07-09 12:19:15.990432
306	139471572	HabibiSly	https://cdn-images.dzcdn.net/images/artist/f0414050171d45e74de14eb9ff999e54/1000x1000-000000-80-0-0.jpg	10	2026-07-08 10:44:04.044114	2026-07-09 12:19:15.990432
307	277684031	TUNE YOUR MIND	https://cdn-images.dzcdn.net/images/artist/b785cdf0efc36654d955ee58856fc85e/1000x1000-000000-80-0-0.jpg	2	2026-07-08 10:44:04.509242	2026-07-09 12:19:15.990432
308	7803478	HUGEL	https://cdn-images.dzcdn.net/images/artist/3c13af28b7ea160a4e844c16e5109d18/1000x1000-000000-80-0-0.jpg	142	2026-07-08 10:44:04.509242	2026-07-09 12:19:15.990432
309	11121068	Tamino	https://cdn-images.dzcdn.net/images/artist/d68c4668975183238d3b3576aa7e489e/1000x1000-000000-80-0-0.jpg	20	2026-07-08 10:44:04.509242	2026-07-09 12:19:15.990432
310	288793	Ricky Rich	https://cdn-images.dzcdn.net/images/artist/02009dffd05def1af7d93c9e066074f7/1000x1000-000000-80-0-0.jpg	55	2026-07-08 10:44:04.509242	2026-07-09 12:19:15.990432
311	1359318	Rakhim	https://cdn-images.dzcdn.net/images/artist/73511cab550ee8a740b5ed58b3571719/1000x1000-000000-80-0-0.jpg	47	2026-07-08 10:44:04.509242	2026-07-09 12:19:15.990432
312	1365309	MAX BARSKIH	https://cdn-images.dzcdn.net/images/artist/b74aa51acaefce4542df33660786776f/1000x1000-000000-80-0-0.jpg	85	2026-07-08 10:58:43.930886	2026-07-09 12:19:15.990432
313	5014953	Макс Корж	https://cdn-images.dzcdn.net/images/artist/923011d7dcfd392247093bd1506ca9a3/1000x1000-000000-80-0-0.jpg	32	2026-07-08 10:58:43.930886	2026-07-09 12:19:15.990432
314	1477183	Makar	https://cdn-images.dzcdn.net/images/artist/8f954d92fe5681a477b22ae62309ff11/1000x1000-000000-80-0-0.jpg	66	2026-07-08 10:58:43.930886	2026-07-09 12:19:15.990432
315	55444722	Макси Ак	https://cdn-images.dzcdn.net/images/artist/46589e9d8a243f16f471aed5ba180f42/1000x1000-000000-80-0-0.jpg	14	2026-07-08 10:58:43.930886	2026-07-09 12:19:15.990432
316	62067412	Макс Вертиго	https://cdn-images.dzcdn.net/images/artist/3de123462734c2165bf6bd5403c91551/1000x1000-000000-80-0-0.jpg	85	2026-07-08 10:58:43.930886	2026-07-09 12:19:15.990432
317	9093474	4atty aka Tilla	https://cdn-images.dzcdn.net/images/artist/4e0b4813a4f1a765fddacd41d5258375/1000x1000-000000-80-0-0.jpg	39	2026-07-08 10:58:48.672638	2026-07-09 12:19:15.990432
318	4378641	Лион	https://cdn-images.dzcdn.net/images/artist/875d752c378cb63e264ad8783c67ae6e/1000x1000-000000-80-0-0.jpg	18	2026-07-08 10:58:48.672638	2026-07-09 12:19:15.990432
319	1120023	Maxx	https://cdn-images.dzcdn.net/images/artist/5543726187c16bab88638747d51cbf4d/1000x1000-000000-80-0-0.jpg	12	2026-07-08 10:58:55.075712	2026-07-09 12:19:15.990432
320	10041	DJ Antoine	https://cdn-images.dzcdn.net/images/artist/41e56a3364c7a494efca5cbf252b5d24/1000x1000-000000-80-0-0.jpg	189	2026-07-08 10:58:55.075712	2026-07-09 12:19:15.990432
321	6469465	Max Styler	https://cdn-images.dzcdn.net/images/artist/eb050be68c88feb90e8aa975c7aad42f/1000x1000-000000-80-0-0.jpg	104	2026-07-08 10:58:55.075712	2026-07-09 12:19:15.990432
322	130026302	Max Kelm	https://cdn-images.dzcdn.net/images/artist/b6d1a93857fe81f962026239de5c83a3/1000x1000-000000-80-0-0.jpg	26	2026-07-08 10:58:55.075712	2026-07-09 12:19:15.990432
323	6690	Max Richter	https://cdn-images.dzcdn.net/images/artist/5fb82c9b42f1200c5b2dffed432cf6dc/1000x1000-000000-80-0-0.jpg	116	2026-07-08 10:58:55.075712	2026-07-09 12:19:15.990432
324	12776975	Maxa	https://cdn-images.dzcdn.net/images/artist/8dbd0ba9b99bf342d45ccb8c745a7343/1000x1000-000000-80-0-0.jpg	10	2026-07-08 10:59:48.013387	2026-07-09 12:19:15.990432
325	60926432	Max A.	https://cdn-images.dzcdn.net/images/artist/105892440ee0d8f940918eac5ab08bd2/1000x1000-000000-80-0-0.jpg	2	2026-07-08 10:59:48.013387	2026-07-09 12:19:15.990432
326	99060902	Max Allais	https://cdn-images.dzcdn.net/images/artist/8133c23a4f2e33ea07c64c5d61e5df1e/1000x1000-000000-80-0-0.jpg	9	2026-07-08 10:59:48.013387	2026-07-09 12:19:15.990432
327	63041	Max & Harvey	https://cdn-images.dzcdn.net/images/artist/f813615d437acc64b4c97f4e1f807e3f/1000x1000-000000-80-0-0.jpg	25	2026-07-08 10:59:48.013387	2026-07-09 12:19:15.990432
328	1474701	Max Ablitzer	https://cdn-images.dzcdn.net/images/artist/ac62f83ebdb55fa824d27ad5c3d7e40a/1000x1000-000000-80-0-0.jpg	7	2026-07-08 10:59:48.013387	2026-07-09 12:19:15.990432
329	156993352	Wilven Bello	https://cdn-images.dzcdn.net/images/artist/bbc9aac411448b936e19a268d28bc217/1000x1000-000000-80-0-0.jpg	4	2026-07-08 10:59:48.632262	2026-07-09 12:19:15.990432
330	8904	MAX	https://cdn-images.dzcdn.net/images/artist/984e5d4ef4e4c105fe753b03f69ab13e/1000x1000-000000-80-0-0.jpg	103	2026-07-08 10:59:48.632262	2026-07-09 12:19:15.990432
331	1305	Morrissey	https://cdn-images.dzcdn.net/images/artist/65094273ce26f015638a9fa0f6ebc675/1000x1000-000000-80-0-0.jpg	50	2026-07-09 09:08:30.853779	2026-07-09 12:19:15.990432
332	8	Placebo	https://cdn-images.dzcdn.net/images/artist/8a0866a77000e6c545180d2572c877dc/1000x1000-000000-80-0-0.jpg	31	2026-07-09 09:08:30.853779	2026-07-09 12:19:15.990432
333	342696411	Dont Tap The Glass	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-09 09:24:42.437901	2026-07-09 12:19:15.990432
334	303506421	Slope in Slope	https://cdn-images.dzcdn.net/images/artist/26f1e61f86d535526f3917d4d88cb2cc/1000x1000-000000-80-0-0.jpg	3	2026-07-09 09:24:42.664171	2026-07-09 12:19:15.990432
335	2489131	Glass Animals	https://cdn-images.dzcdn.net/images/artist/b2e9164dfa2a293330ce341905710034/1000x1000-000000-80-0-0.jpg	42	2026-07-09 09:24:42.664171	2026-07-09 12:19:15.990432
336	195466107	New Disguise	https://cdn-images.dzcdn.net/images/artist/dbff6442240fb0ff81d4d49d271912d9/1000x1000-000000-80-0-0.jpg	4	2026-07-09 09:24:43.606377	2026-07-09 12:19:15.990432
337	374178131	I and T	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	2	2026-07-09 09:24:43.606377	2026-07-09 12:19:15.990432
338	4729179	Iron Touch	https://cdn-images.dzcdn.net/images/artist/8612219d1a9797cdcd2da14b0f04ed77/1000x1000-000000-80-0-0.jpg	26	2026-07-09 09:29:26.359365	2026-07-09 12:19:15.990432
339	12053242	Ninajirachi	https://cdn-images.dzcdn.net/images/artist/c4dc2676b8b1aa0c679d614deb66bcdf/1000x1000-000000-80-0-0.jpg	69	2026-07-09 09:29:26.532928	2026-07-09 12:19:15.990432
340	104810942	BJ Lips	https://cdn-images.dzcdn.net/images/artist/4c2c344a9dbb1f1cd9994ed18c2cd874/1000x1000-000000-80-0-0.jpg	20	2026-07-09 09:29:26.532928	2026-07-09 12:19:15.990432
341	351224992	zoku	https://cdn-images.dzcdn.net/images/artist/66f9d7f6054e68470901c8262eaa2f43/1000x1000-000000-80-0-0.jpg	54	2026-07-09 09:29:26.532928	2026-07-09 12:19:15.990432
342	5632238	Eyeliner	https://cdn-images.dzcdn.net/images/artist/1d0f7d5bf2bc190979204a763e587ece/1000x1000-000000-80-0-0.jpg	10	2026-07-09 09:29:26.532928	2026-07-09 12:19:15.990432
343	9314830	Chris River	https://cdn-images.dzcdn.net/images/artist/e107a027c01339c93f44fb8c09d9b07c/1000x1000-000000-80-0-0.jpg	73	2026-07-09 09:29:26.532928	2026-07-09 12:19:15.990432
344	204783107	Azi	https://cdn-images.dzcdn.net/images/artist/1fa4c424c40222ecbefb0ac987e91f6c/1000x1000-000000-80-0-0.jpg	6	2026-07-09 09:29:28.043562	2026-07-09 12:19:15.990432
345	296212721	sunnydvd	https://cdn-images.dzcdn.net/images/artist/d1d27dd9a531dda81ca94133a799f64e/1000x1000-000000-80-0-0.jpg	15	2026-07-09 09:29:28.043562	2026-07-09 12:19:15.990432
346	1439004	Die Pepi Wichart Schrammeln	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-09 09:51:01.897848	2026-07-09 12:19:15.990432
347	11889593	Heller Duo / Die 3 Frohen Sänger / Pepi Reichl / Alpenland-Duo / Die Volksmusikanten	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-09 09:51:01.897848	2026-07-09 12:19:15.990432
348	11889601	Heller Duo /Die 3 Frohen Sänger / Pepi Reichl / Alpenland-Duo / Die Volksmusikanten	https://cdn-images.dzcdn.net/images/artist//1000x1000-000000-80-0-0.jpg	0	2026-07-09 09:51:01.897848	2026-07-09 12:19:15.990432
349	95074402	Addison Rae	https://cdn-images.dzcdn.net/images/artist/a8bc8bbb055934154ffe5ab48e61d6d0/1000x1000-000000-80-0-0.jpg	9	2026-07-09 09:51:02.123316	2026-07-09 12:19:15.990432
350	11474676	Ben Platt	https://cdn-images.dzcdn.net/images/artist/2ae780fcbf4cfbf9f6d2c193f7ff6d7d/1000x1000-000000-80-0-0.jpg	31	2026-07-09 09:51:02.123316	2026-07-09 12:19:15.990432
351	170172097	Blondshell	https://cdn-images.dzcdn.net/images/artist/bcbd1ade1c1fa392834ea90e3525c601/1000x1000-000000-80-0-0.jpg	14	2026-07-09 09:51:02.123316	2026-07-09 12:19:15.990432
352	14718919	Lone Tusker	https://cdn-images.dzcdn.net/images/artist/c521346c3333fb54d4fd407ec0999772/1000x1000-000000-80-0-0.jpg	79	2026-07-09 09:51:02.123316	2026-07-09 12:19:15.990432
353	170489017	Alosa	https://cdn-images.dzcdn.net/images/artist/1300941b1ca17ec6694ba2d2e22c2713/1000x1000-000000-80-0-0.jpg	141	2026-07-09 09:51:02.123316	2026-07-09 12:19:15.990432
354	183210107	Arctic Monkey	https://cdn-images.dzcdn.net/images/artist/85ce22cc5d9f315eea935d07813a1277/1000x1000-000000-80-0-0.jpg	5	2026-07-09 10:45:17.381368	2026-07-09 12:19:15.990432
355	215598895	3S	https://cdn-images.dzcdn.net/images/artist/260efe4a410691fc78131752d1ea6b9f/1000x1000-000000-80-0-0.jpg	5	2026-07-09 10:54:11.99122	2026-07-09 12:19:15.990432
356	95757512	3 S	https://cdn-images.dzcdn.net/images/artist/54f73ecda051fad6e3ca5ac10ee9fecc/1000x1000-000000-80-0-0.jpg	2	2026-07-09 10:54:11.99122	2026-07-09 12:19:15.990432
357	4694336	3S	https://cdn-images.dzcdn.net/images/artist/e92dbca7b8ab3a4e98994ba792475685/1000x1000-000000-80-0-0.jpg	26	2026-07-09 10:54:11.99122	2026-07-09 12:19:15.990432
358	169422027	3slow2	https://cdn-images.dzcdn.net/images/artist/2e27dc0d03b3163ff227c87becfb0c49/1000x1000-000000-80-0-0.jpg	494	2026-07-09 10:54:11.99122	2026-07-09 12:19:15.990432
359	89309312	3STRANGE	https://cdn-images.dzcdn.net/images/artist/4951956aa379048171e5deca509b9fc6/1000x1000-000000-80-0-0.jpg	15	2026-07-09 10:54:11.99122	2026-07-09 12:19:15.990432
360	3051	Smile Empty Soul	https://cdn-images.dzcdn.net/images/artist/c8c4016b281efda803879a7fbc5e379d/1000x1000-000000-80-0-0.jpg	31	2026-07-09 10:54:12.254293	2026-07-09 12:19:15.990432
361	191830997	Salve Crazy	https://cdn-images.dzcdn.net/images/artist/03468564591df4e3a081804fd2b3c522/1000x1000-000000-80-0-0.jpg	93	2026-07-09 10:54:12.254293	2026-07-09 12:19:15.990432
362	47	Indochine	https://cdn-images.dzcdn.net/images/artist/25b2e9befc7d9faf2b95feab29ba7c00/1000x1000-000000-80-0-0.jpg	83	2026-07-09 10:54:12.254293	2026-07-09 12:19:15.990432
363	5617934	Надежда Кадышева и ансамбль Золотое кольцо	https://cdn-images.dzcdn.net/images/artist/5be07e5dca4a842bcd2f53dc3ddb2b8e/1000x1000-000000-80-0-0.jpg	13	2026-07-09 11:09:05.179788	2026-07-09 12:19:15.990432
364	287988341	очки и кольца	https://cdn-images.dzcdn.net/images/artist/873e2d5e07c52839f73445f9a997cf55/1000x1000-000000-80-0-0.jpg	9	2026-07-09 11:09:05.179788	2026-07-09 12:19:15.990432
365	9073232	ансамбль "Золотое кольцо"	https://cdn-images.dzcdn.net/images/artist/38a34837b4c25f6abaf806c095986329/1000x1000-000000-80-0-0.jpg	7	2026-07-09 11:09:05.179788	2026-07-09 12:19:15.990432
366	7972152	Группа "Садовое Кольцо"	https://cdn-images.dzcdn.net/images/artist/b502142b9ccd5b4dc7407aa018fb6dba/1000x1000-000000-80-0-0.jpg	1	2026-07-09 11:09:05.179788	2026-07-09 12:19:15.990432
367	4520851	Надежда Кадышева и ансамбль "Золотое кольцо"	https://cdn-images.dzcdn.net/images/artist/b840a603010f0225368c82b987accda0/1000x1000-000000-80-0-0.jpg	3	2026-07-09 11:09:05.179788	2026-07-09 12:19:15.990432
368	205038907	туди-сюди і смерть	https://cdn-images.dzcdn.net/images/artist/257022f388d392331f00b353ff7cdc82/1000x1000-000000-80-0-0.jpg	17	2026-07-09 11:26:16.286323	2026-07-09 12:19:15.990432
369	208125427	Adam	https://cdn-images.dzcdn.net/images/artist/d19c8edcd89bd59c6a41a5754c55bdc4/1000x1000-000000-80-0-0.jpg	30	2026-07-09 11:26:16.286323	2026-07-09 12:19:15.990432
370	268392382	ALEXNOVSKI	https://cdn-images.dzcdn.net/images/artist/2ccab38e34eafd0700a062688de6c22c/1000x1000-000000-80-0-0.jpg	96	2026-07-09 11:26:16.286323	2026-07-09 12:19:15.990432
371	245238312	Detam	https://cdn-images.dzcdn.net/images/artist/0d5cb18c47a95e26c7ffce9a7e7f7292/1000x1000-000000-80-0-0.jpg	170	2026-07-09 11:26:16.286323	2026-07-09 12:19:15.990432
\.


--
-- Data for Name: artist_song_association; Type: TABLE DATA; Schema: public; Owner: postgres
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
178	316
178	317
242	318
242	319
242	320
242	321
242	322
242	323
242	324
242	325
242	356
242	357
242	358
242	359
242	360
242	361
242	362
242	363
242	364
242	365
242	366
242	367
242	368
242	369
242	370
242	371
242	372
242	373
242	374
242	375
242	376
242	377
242	378
242	379
242	380
242	381
242	382
242	383
242	384
242	385
242	386
242	387
242	388
242	389
242	390
242	391
242	392
242	393
242	394
242	395
242	396
242	397
242	398
242	399
242	400
242	401
242	402
242	403
242	404
242	405
242	406
242	407
242	408
242	409
242	410
242	411
242	412
242	413
242	414
242	415
242	416
242	417
242	418
242	419
242	420
242	421
242	422
242	423
242	424
242	425
242	426
242	427
242	428
242	429
242	430
242	431
242	432
242	433
242	434
242	435
242	436
242	437
242	438
242	439
242	440
242	441
242	442
242	443
242	444
242	445
242	446
242	447
242	448
242	449
242	450
242	451
252	452
253	453
254	454
255	455
252	456
262	457
263	458
264	459
260	460
260	461
270	462
271	463
272	464
273	465
274	466
260	467
264	468
99	469
99	470
99	471
99	472
99	473
99	474
99	475
99	476
99	477
186	478
186	479
186	480
186	481
186	482
186	483
186	484
186	485
186	486
186	487
186	488
186	489
236	490
236	491
236	492
236	493
236	494
236	495
236	496
236	497
236	498
236	499
236	500
236	501
236	502
236	503
236	504
236	505
236	506
236	507
236	508
236	509
236	510
236	511
236	512
236	513
236	514
236	515
236	516
236	517
236	518
236	519
236	520
236	521
236	522
236	523
236	524
236	525
236	526
236	527
236	528
236	529
236	530
236	531
279	532
99	533
99	534
99	535
99	536
99	537
99	538
99	539
99	540
99	541
99	542
99	543
99	544
97	545
97	546
97	547
97	548
280	549
286	550
286	551
286	552
286	553
286	554
291	555
286	556
297	557
298	558
299	559
300	560
301	561
307	562
308	563
309	564
310	565
311	566
313	567
313	568
313	569
313	570
313	571
317	572
317	573
317	574
317	575
318	576
312	577
312	578
312	579
312	580
312	581
319	582
320	583
321	584
322	585
323	586
329	587
326	588
330	589
326	590
326	591
275	592
275	593
275	594
275	595
275	596
275	597
275	598
275	599
275	600
275	601
275	602
275	603
275	604
275	605
275	606
275	607
275	608
275	609
275	610
275	611
275	612
275	613
110	614
331	615
332	616
110	617
110	618
110	619
110	620
110	621
110	622
110	623
110	624
110	625
110	626
110	627
110	628
334	629
187	630
335	631
187	632
187	633
187	634
187	635
187	636
187	637
187	638
187	639
339	640
340	641
341	642
342	643
343	644
339	645
339	646
339	647
339	648
339	649
339	650
339	651
339	652
339	653
339	654
339	655
349	656
350	657
351	658
352	659
353	660
242	661
242	662
242	663
242	664
242	665
242	666
242	667
242	668
242	669
242	670
242	671
242	672
242	673
242	674
242	675
242	676
242	677
242	678
242	679
231	680
231	681
231	682
231	683
231	684
231	685
231	686
231	687
231	688
231	689
231	690
231	691
231	692
368	693
369	694
370	695
371	696
7	697
7	698
7	699
7	700
349	701
349	702
349	703
349	704
349	705
349	706
349	707
349	708
349	709
349	710
349	711
349	712
349	713
349	714
349	715
99	716
99	717
99	718
99	719
99	720
99	721
99	722
99	723
99	724
99	725
99	726
99	727
99	728
99	729
99	730
99	731
99	732
99	733
99	734
99	735
99	736
99	737
99	738
99	739
99	740
99	741
99	742
99	743
99	744
99	745
99	746
99	747
99	748
99	749
99	750
99	751
99	752
99	753
99	754
99	755
99	756
99	757
99	758
99	759
99	760
99	761
99	762
99	763
99	764
99	765
99	766
99	767
99	768
99	769
99	770
99	771
99	772
99	773
99	774
99	775
99	776
99	777
99	778
99	779
186	780
186	781
186	782
186	783
186	784
186	785
186	786
186	787
186	788
186	789
186	790
186	791
186	792
186	793
186	794
186	795
186	796
186	797
186	798
186	799
186	800
186	801
186	802
186	803
186	804
186	805
186	806
186	807
186	808
186	809
186	810
186	811
186	812
186	813
186	814
186	815
186	816
186	817
186	818
186	819
186	820
186	821
186	822
186	823
186	824
186	825
186	826
186	827
186	828
186	829
186	830
186	831
186	832
186	833
186	834
186	835
186	836
186	837
186	838
186	839
186	840
186	841
186	842
186	843
186	844
186	845
186	846
186	847
186	848
110	849
110	850
110	851
110	852
110	853
110	854
110	855
110	856
110	857
110	858
110	859
110	860
110	861
110	862
110	863
110	864
110	865
110	866
110	867
110	868
110	869
110	870
110	871
110	872
110	873
110	874
110	875
110	876
110	877
110	878
110	879
110	880
110	881
110	882
110	883
110	884
110	885
110	886
110	887
110	888
110	889
110	890
110	891
110	892
110	893
110	894
110	895
110	896
110	897
110	898
110	899
110	900
110	901
110	902
110	903
110	904
110	905
110	906
110	907
110	908
110	909
110	910
110	911
110	912
110	913
110	914
110	915
110	916
110	917
110	918
110	919
110	920
110	921
110	922
110	923
110	924
110	925
110	926
110	927
110	928
110	929
110	930
110	931
110	932
110	933
110	934
110	935
110	936
110	937
110	938
110	939
110	940
110	941
110	942
110	943
110	944
110	945
110	946
110	947
110	948
110	949
110	950
110	951
110	952
110	953
110	954
110	955
110	956
110	957
110	958
110	959
110	960
332	961
332	962
332	963
332	964
332	965
332	966
332	967
332	968
332	969
332	970
332	971
332	972
332	973
332	974
377	975
383	976
384	977
385	978
380	979
386	980
387	981
388	982
389	983
390	984
69	985
391	986
392	987
391	988
393	989
394	990
110	991
110	992
110	993
110	994
110	995
110	996
110	997
110	998
110	999
110	1000
110	1001
110	1002
401	1003
402	1004
403	1005
403	1006
403	1007
396	1008
396	1009
396	1010
396	1011
396	1012
396	1013
396	1014
396	1015
396	1016
396	1017
396	1018
396	1019
396	1020
396	1021
208	1022
208	1023
404	1024
405	1025
406	1026
286	1071
286	1072
286	1073
286	1074
286	1075
286	1076
286	1077
286	1078
286	1079
286	1080
286	1081
286	1082
286	1083
286	1084
286	1085
186	1086
186	1087
186	1088
186	1089
186	1090
186	1091
186	1092
186	1093
186	1094
186	1095
186	1096
186	1097
186	1098
186	1099
186	1100
98	1101
98	1102
98	1103
98	1104
98	1105
98	1106
98	1107
98	1108
98	1109
98	1110
414	1111
409	1112
409	1113
409	1114
409	1115
415	1116
409	1117
416	1118
417	1119
409	1120
173	1121
173	1122
173	1123
173	1124
173	1125
186	1126
186	1127
418	1128
418	1129
418	1130
418	1131
418	1132
423	1133
424	1134
425	1135
418	1136
418	1137
426	1138
418	1139
126	1140
126	1141
432	1142
433	1143
434	1144
394	1145
394	1146
394	1147
394	1148
394	1149
1	1150
1	1151
1	1152
1	1153
1	1154
1	1155
1	1156
1	1157
1	1158
1	1159
1	1160
1	1161
1	1162
1	1163
1	1164
1	1165
1	1166
1	1167
1	1168
1	1169
1	1170
1	1171
1	1172
1	1173
312	1174
186	1207
435	1208
236	1209
186	1210
186	1211
186	1212
186	1213
186	1214
186	1215
186	1216
186	1217
100	1218
100	1219
100	1220
438	1221
436	1222
441	1223
442	1224
436	1225
186	1226
186	1227
186	1228
186	1229
449	1259
450	1260
451	1261
451	1262
449	1263
462	1272
463	1273
457	1274
463	1275
464	1276
453	1281
454	1282
454	1283
455	1284
456	1285
\.


--
-- Data for Name: genre; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genre (id, dzid, name, created_at, updated_at) FROM stdin;
1	116	Rap/Hip Hop	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
2	152	Rock	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
3	155	Hard Rock	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
4	165	R&B	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
5	173	Films/Games	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
6	174	Film Scores	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
7	466	Folk	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
8	85	Alternative	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
9	464	Metal	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
10	87	Indie Rock	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
11	86	Indie Pop	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
12	106	Electro	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
13	129	Jazz	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
22	132	Pop	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
23	134	International Pop	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
24	166	Contemporary R&B	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
25	154	Indie Rock/Rock pop	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
26	113	Dance	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
27	168	Disco	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
28	75	Brazilian Music	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
29	197	Latin Music	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
30	522	Singer & Songwriter	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
33	153	Blues	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
34	133	Indie Pop/Folk	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
35	16	Asian Music	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
36	98	Classical	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
37	111	Techno/House	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
38	169	Soul & Funk	2026-07-08 10:44:05.942784	2026-07-08 10:44:05.942784
39	158	Russian Rock	2026-07-14 11:32:34.39537	2026-07-14 11:32:34.39537
\.


--
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rating (id, score, description, album_id, song_id, user_id, created_at, updated_at) FROM stdin;
5	6	Meeeeeeeeeeeeeeehhhh	116	\N	1	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
7	10	Meeeeeeeeeeeeeeehhhh	151	\N	2	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
8	10	Meeeeeeeeeeeeeeehhhh	163	\N	2	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
9	10	Meeeeeeeeeeeeeeehhhh	186	\N	2	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
11	10	Meeeeeeeeeeeeeeehhhh	229	\N	3	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
14	10	Meeeeeeeeeeeeeeehhhh	269	\N	3	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504
15	4	5 centimeters per second	\N	469	3	2026-07-07 17:48:47.711409	2026-07-07 17:48:47.711409
16	5	Veri cool songe	\N	469	5	2026-07-08 10:58:03.722617	2026-07-08 10:58:03.722617
17	5	Veri cool songeeeee	\N	231	3	2026-07-09 11:28:19.477151	2026-07-09 11:28:19.477151
19	6	67	186	\N	3	2026-07-11 15:22:10.560029	2026-07-11 15:22:10.560029
20	4	5 centimeters per second	\N	1008	4	2026-07-11 18:09:19.618936	2026-07-11 18:09:19.618936
21	5	habibi	\N	849	3	2026-07-12 08:50:16.162875	2026-07-12 08:50:16.162875
22	7	\N	482	\N	3	2026-07-12 08:51:03.116028	2026-07-12 08:51:03.116028
23	5	67676	\N	255	3	2026-07-12 09:26:23.788751	2026-07-12 09:26:23.788751
24	10	never wanted to dance with nobody but you,you,youyouoyuyouyo	190	\N	3	2026-07-12 09:26:59.105698	2026-07-12 09:26:59.105698
10	6	Meeeeeeeeeeeeeeehhhh...	220	\N	3	2026-07-06 13:33:02.149504	2026-07-12 15:09:57.920289
18	10	Actually a great album, it has dat raw energy. LIl trashy sound, dat garage rock ykwim. Lorem ipsum dolom apt sudo install, python pip install pip --upgrade, docker exec -it name flask db migrate -m 'migration message type shit yeeee". NOw but actually my favourite songs are songs. They play through speakerphone and speaker and phone. I can listen to them when i want to, if i dont want to i dont listen, does that make sense? Are you stupid. Im not stupid, im actually typing on keyboard	151	\N	3	2026-07-11 10:18:41.572926	2026-07-12 15:14:33.895665
25	4	aboba	\N	1088	2	2026-07-14 11:29:09.094693	2026-07-14 11:29:09.094693
26	10	\N	190	\N	2	2026-07-14 11:29:52.38567	2026-07-14 11:29:52.38567
27	5	5 centimeters per second	\N	231	2	2026-07-18 10:53:15.265406	2026-07-18 10:53:15.265406
28	5	5 centimeters per second	\N	469	2	2026-07-18 10:53:17.88012	2026-07-18 10:53:17.88012
30	5	5 centimeters per second	\N	1089	7	2026-07-19 13:32:48.578855	2026-07-19 13:32:48.578855
31	4	5 centimeters per second	\N	1086	3	2026-08-07 12:24:38.760255	2026-08-07 12:24:38.760255
\.


--
-- Data for Name: song; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.song (id, dzid, name, length, song_position, picture, preview, album_id, created_at, updated_at) FROM stdin;
804	3657980632	Personal Jesus	125	1	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
843	3657980642	This Hurts	141	2	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:33:25.547808	2026-07-09 18:33:25.547808
821	3657980652	Be Like Superman	164	3	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
836	3657980662	Memory of Heaven	181	4	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
827	3657980672	Vanity	168	5	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
791	3657980682	Married Alive	132	6	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
787	3657980692	Girls On Film	178	7	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
844	3657980702	5TR82HE11	180	8	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:33:25.547808	2026-07-09 18:33:25.547808
795	3657980712	Envy	190	9	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
845	3657980722	Device	207	10	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:33:25.547808	2026-07-09 18:33:25.547808
846	3657980732	Out of My Minds	140	11	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:33:25.547808	2026-07-09 18:33:25.547808
847	3657980742	Darling Young Boyz	109	12	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:33:25.547808	2026-07-09 18:33:25.547808
790	3657980762	Slim	123	14	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
798	3657980772	Do Unto Others	199	15	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
789	3657980792	Bed of Roses	260	16	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
832	3657980812	Unsociable	169	17	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
808	3657980832	Do Unto Others, Pt. 2	200	18	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:30:54.020851	2026-07-09 18:33:25.547808
848	3657980852	Angry Boy	278	19	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	\N	187	2026-07-09 18:33:25.547808	2026-07-09 18:33:25.547808
849	416477012	The Queen Is Dead (2017 Master)	384	1	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
850	416477022	Frankly, Mr. Shankly (2017 Master)	137	2	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
851	416477032	I Know It's Over (2017 Master)	347	3	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
852	416477042	Never Had No One Ever (2017 Master)	216	4	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
853	416477052	Cemetry Gates (2017 Master)	158	5	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
614	416477062	Bigmouth Strikes Again (2017 Master)	191	6	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/9/d/0/49d603b02c5547c78d66fce973ba3ba3.mp3?hdnea=exp=1783589011~acl=/api/1/1/4/9/d/0/49d603b02c5547c78d66fce973ba3ba3.mp3*~data=user_id=0,application_id=42~hmac=efcc6e063f9d32df4bb4facb61fad8f69a65d8bf90761de4871148b36a274924	482	2026-07-09 09:08:32.252141	2026-07-10 09:45:47.217115
854	416477072	The Boy with the Thorn in His Side (2017 Master)	195	7	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
855	416477082	Vicar in a Tutu (2017 Master)	142	8	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
856	416477092	There Is a Light That Never Goes Out (2017 Master)	242	9	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
857	416477102	Some Girls Are Bigger Than Others (2017 Master)	196	10	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
858	416477112	The Queen Is Dead (Full Version)	434	1	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
859	416477122	Frankly, Mr. Shankly (Demo)	138	2	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
860	416477132	I Know It's Over (Demo)	348	3	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
861	416477142	Never Had No One Ever (Demo)	280	4	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
862	416477152	Cemetry Gates (Demo)	181	5	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
618	416477162	Bigmouth Strikes Again (Demo)	186	6	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/f/3/0/8f3ec3ce308908c6da3cd11dd5290944.mp3?hdnea=exp=1783589011~acl=/api/1/1/8/f/3/0/8f3ec3ce308908c6da3cd11dd5290944.mp3*~data=user_id=0,application_id=42~hmac=e049bb1ca31a894b7320ce05441cd98b87e2ab5ffc740b7d18bf800e5d36ec95	482	2026-07-09 09:08:32.252141	2026-07-10 09:45:47.217115
863	416477172	Some Girls Are Bigger Than Others (Demo)	237	7	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
488	2859555672	Lush	157	12	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/7/b/0/b7bc5256c892bc10b5a4c30ed722d13c.mp3?hdnea=exp=1783447468~acl=/api/1/1/b/7/b/0/b7bc5256c892bc10b5a4c30ed722d13c.mp3*~data=user_id=0,application_id=42~hmac=fc7ecec7072f47d3209813f220711db44b6fcd6560b4c7df237e34cfed85363c	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
489	2859555682	You Will See Just What I See	175	13	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/3/8/0/0388924a6b5c446c8d28be97d732a863.mp3?hdnea=exp=1783447468~acl=/api/1/1/0/3/8/0/0388924a6b5c446c8d28be97d732a863.mp3*~data=user_id=0,application_id=42~hmac=0defaa978c9e0dd7a2c0fd73456b2849a5b8838a5e0480b560d9fef9a3389c26	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
864	416477182	The Boy with the Thorn in His Side (Demo Mix)	198	8	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
865	416477192	There Is a Light That Never Goes Out (Take 1)	265	9	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
866	416477202	Rubber Ring (2017 Master)	234	10	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
867	416477212	Asleep (Single B-Side; 2017 Master)	242	11	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
868	416477222	Money Changes Everything (2017 Master)	281	12	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
869	416477232	Unloveable (2017 Master)	235	13	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
870	416477242	How Soon Is Now? (Live in Boston)	325	1	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
871	416477252	Hand in Glove (Live in Boston)	177	2	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
872	416477262	I Want the One I Can't Have (Live in Boston)	203	3	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
873	416477272	Never Had No One Ever (Live in Boston)	205	4	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
874	416477282	Stretch out and Wait (Live in Boston)	191	5	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
875	416477292	The Boy with the Thorn in His Side (Live in Boston)	214	6	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
876	416477302	Cemetry Gates (Live in Boston)	181	7	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
877	416477312	Rubber Ring / What She Said / Rubber Ring (Live in Boston)	257	8	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
878	416477322	Is It Really so Strange? (Live in Boston)	202	9	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
879	416477332	There Is a Light That Never Goes Out (Live in Boston)	249	10	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
880	416477342	That Joke Isn't Funny Anymore (Live in Boston)	290	11	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
881	416477352	The Queen Is Dead (Live in Boston)	305	12	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
882	416477362	I Know It's Over (Live in Boston)	455	13	https://cdn-images.dzcdn.net/images/cover/8fbb2d7d0b51c4e74fd3c99b680abc10/1000x1000-000000-80-0-0.jpg	\N	482	2026-07-10 09:45:47.217115	2026-07-10 09:45:47.217115
883	13786025	Back to the Old House (2011 Remaster)	186	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
884	5093617	There Is a Light That Never Goes Out (2008 Remaster)	245	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
885	5093607	Heaven Knows I'm Miserable Now (2008 Remaster)	216	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
886	5093637	Asleep (2008 Remaster)	250	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
887	5093609	How Soon Is Now? (2008 Remaster)	407	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
888	13786037	Handsome Devil (John Peel Session 18/05/83)	164	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
889	13776577	Please, Please, Please, Let Me Get What I Want (2011 Remaster)	112	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
890	13786041	This Night Has Opened My Eyes (2011 Remaster)	221	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
891	13786005	Well I Wonder (2011 Remaster)	239	\N	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	\N	569	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
892	13785956	Miserable Lie (2011 Remaster)	267	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
893	13786038	Hand in Glove (2011 Remaster)	195	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
894	13785979	Stop Me If You Think You've Heard This One Before (2011 Remaster)	215	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
1210	12235147	Shut Me Up	168	1	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
530	3541914531	ZUMA HOUSE	83	19	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/a/0/83aba54004b8f882cac91ad258b2acbc.mp3?hdnea=exp=1783448156~acl=/api/1/1/8/3/a/0/83aba54004b8f882cac91ad258b2acbc.mp3*~data=user_id=0,application_id=42~hmac=7e4c6316b03d9f2d1f2601b21c24a8f5031177a64f1c86de845c5eb1a0abb603	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
531	3541914541	TOO LONG	185	20	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/6/8/0/4689a56e01926df671578092dfb6fd64.mp3?hdnea=exp=1783448156~acl=/api/1/1/4/6/8/0/4689a56e01926df671578092dfb6fd64.mp3*~data=user_id=0,application_id=42~hmac=294a17c23ecf322d3cbcefa7964b1af4a3ffc60c38a49827d338e83bf80ed0c6	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
532	3541914551	FORGIVENESS	90	21	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/9/d/0/49d72fa09b55c3dc91de7a4b0579be1d.mp3?hdnea=exp=1783448156~acl=/api/1/1/4/9/d/0/49d72fa09b55c3dc91de7a4b0579be1d.mp3*~data=user_id=0,application_id=42~hmac=a86de935932a3ad0cc4cae0819e476a6772fa51d27bd028e220d54104bdfdd35	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
895	13785975	A Rush and a Push and the Land Is Ours (2011 Remaster)	183	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
896	13785957	Pretty Girls Make Graves (2011 Remaster)	223	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
897	13785976	I Started Something I Couldn't Finish (2011 Remaster)	227	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
898	13785962	What Difference Does It Make? (2011 Remaster)	229	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
899	13786001	I Want the One I Can't Have (2011 Remaster)	193	\N	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	\N	569	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
900	13785999	The Headmaster Ritual (2011 Remaster)	295	\N	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	\N	569	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
901	13785954	Reel Around the Fountain (2011 Remaster)	359	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
902	13786010	Shoplifters of the World Unite (2011 Remaster)	178	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
903	13776575	Back to the Old House (John Peel Session 14/09/83)	185	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
904	13785947	Half a Person (2011 Remaster)	218	\N	https://cdn-images.dzcdn.net/images/cover/82e7aa454050e368dbb4f5b8824485a5/1000x1000-000000-80-0-0.jpg	\N	487	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
905	13785960	Still Ill (2011 Remaster)	201	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
906	14954509	Rusholme Ruffians	260	\N	https://cdn-images.dzcdn.net/images/cover/5fe513cbcd62d69e2d0868ee0e3186e2/1000x1000-000000-80-0-0.jpg	\N	571	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
907	13785955	You've Got Everything Now (2011 Remaster)	239	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
908	13785961	Hand in Glove (2011 Remaster)	202	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
909	13786006	Barbarism Begins at Home (2011 Remaster)	413	\N	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	\N	569	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
910	2480576	What Difference Does It Make? [Peel Session - BBC]	193	\N	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	\N	572	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
911	2480587	Barbarism Begins At Home [7" Version]	231	\N	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	\N	572	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
912	2480590	That Joke Isn't Funny Anymore	232	\N	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	\N	572	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
913	13785964	Suffer Little Children (2011 Remaster)	330	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
914	13785978	Girlfriend in a Coma (2011 Remaster)	122	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
915	13786032	William, It Was Really Nothing (2011 Remaster)	131	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
916	382034231	There Is a Light That Never Goes Out (Take 1)	265	\N	https://cdn-images.dzcdn.net/images/cover/7802a7611d2128aeecdd3087d720d845/1000x1000-000000-80-0-0.jpg	\N	573	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
917	13786027	Stretch out and Wait (2011 Remaster)	159	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
918	13786020	Ask (2011 Remaster)	198	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
919	13786044	Girl Afraid (2011 Remaster)	166	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
920	13785958	The Hand That Rocks the Cradle (2011 Remaster)	277	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
921	2480583	Nowhere Fast	159	\N	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	\N	572	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
922	2480586	What She Said	160	\N	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	\N	572	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
923	13786039	Still Ill (John Peel Session 14/09/83)	215	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
924	5093644	Pretty Girls Make Graves (Troy Tate Version; 2008 Remaster)	215	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
925	409679482	I Know It's Over (Demo)	348	\N	https://cdn-images.dzcdn.net/images/cover/7802a7611d2128aeecdd3087d720d845/1000x1000-000000-80-0-0.jpg	\N	574	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
926	13785963	I Don't Owe You Anything (2011 Remaster)	244	\N	https://cdn-images.dzcdn.net/images/cover/7c5e7a27c8c48b4f252ed86ad40de4c7/1000x1000-000000-80-0-0.jpg	\N	114	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
927	5093634	Stretch out and Wait (2008 Remaster)	165	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
928	13786014	Panic (2011 Remaster)	140	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
929	5093629	Wonderful Woman (2008 Remaster)	190	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
930	13785980	Last Night I Dreamt That Somebody Loved Me (2011 Remaster)	305	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
931	5093611	Shakespeare's Sister (2008 Remaster)	129	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
932	5093631	These Things Take Time (2008 Remaster)	144	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
933	13786011	Sweet and Tender Hooligan (John Peel Session, 12/2/86)	216	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
934	13786003	That Joke Isn't Funny Anymore	297	\N	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	\N	569	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
935	13785981	Unhappy Birthday (2011 Remaster)	165	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
936	13786007	Meat Is Murder (2011 Remaster)	373	\N	https://cdn-images.dzcdn.net/images/cover/468e647424f6ae2619e5f3e49074359e/1000x1000-000000-80-0-0.jpg	\N	569	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
937	2480599	You Just Haven't Earned It Yet, Baby	214	\N	https://cdn-images.dzcdn.net/images/cover/bb8815335df0a01bbe58e8ac3504cf34/1000x1000-000000-80-0-0.jpg	\N	572	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
938	13776601	Handsome Devil (Live at Manchester Hacienda 4/2/83; 2008 Remaster)	176	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
939	13786034	These Things Take Time (David Jensen Session 26/06/83)	153	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
940	14954516	Barbarism Begins At Home	417	\N	https://cdn-images.dzcdn.net/images/cover/5fe513cbcd62d69e2d0868ee0e3186e2/1000x1000-000000-80-0-0.jpg	\N	571	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
941	13786009	Sheila Take a Bow (2011 Remaster)	162	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
942	14954511	What She Said	162	\N	https://cdn-images.dzcdn.net/images/cover/5fe513cbcd62d69e2d0868ee0e3186e2/1000x1000-000000-80-0-0.jpg	\N	571	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
943	13786008	Is It Really so Strange? (John Peel session, 12/2/86)	188	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
944	13785984	I Won't Share You (2011 Remaster)	173	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
945	13785977	Death of a Disco Dancer (2011 Remaster)	326	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
946	5093625	Last Night I Dreamt That Somebody Loved Me (2008 Remaster)	193	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
947	5093626	Jeane (2008 Remaster)	184	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
948	13786046	Reel Around the Fountain (John Peel Session 18/05/83)	350	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
949	5093635	Oscillate Wildly (Instrumental; 2008 Remaster)	208	\N	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	\N	107	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
950	13786043	Accept Yourself (David Jensen Session 25/08/83)	243	\N	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	\N	108	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
951	13786013	London (2011 Remaster)	127	\N	https://cdn-images.dzcdn.net/images/cover/8252e9d1e87b9048ea1252f29bce2c5b/1000x1000-000000-80-0-0.jpg	\N	567	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
953	13785982	Paint a Vulgar Picture (2011 Remaster)	336	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
954	13776605	How Soon Is Now? (Single Edit; 2008 Remaster)	221	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
955	13785983	Death at One's Elbow (2011 Remaster)	120	\N	https://cdn-images.dzcdn.net/images/cover/4a5d74581f163cc22b0f2da533dc4aa8/1000x1000-000000-80-0-0.jpg	\N	570	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
956	13776609	The Draize Train (2008 Remaster)	309	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
957	13776554	The Boy with the Thorn in His Side (Live in London, 1986)	228	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
958	14954514	Nowhere Fast	157	\N	https://cdn-images.dzcdn.net/images/cover/5fe513cbcd62d69e2d0868ee0e3186e2/1000x1000-000000-80-0-0.jpg	\N	571	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
959	13776572	You've Got Everything Now (David Jensen Session 26/06/83)	254	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
960	13776587	Golden Lights (2011 Remaster)	161	\N	https://cdn-images.dzcdn.net/images/cover/babdf83b3ce1e224e030761d0bb81998/1000x1000-000000-80-0-0.jpg	\N	568	2026-07-10 09:45:51.699409	2026-07-10 09:45:51.699409
552	116348434	And I Love Her (Remastered 2009)	149	\N	https://cdn-images.dzcdn.net/images/cover/7d1c6019481f5b2b2a6e5de1ee57425c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/1/7/0/9170938bc90d380cca0ac289585468be.mp3?hdnea=exp=1783507789~acl=/api/1/1/9/1/7/0/9170938bc90d380cca0ac289585468be.mp3*~data=user_id=0,application_id=42~hmac=0858453b42ddc1704faa2ac5420d606190efa934a6df6ea2802fcc741a0827ed	439	2026-07-08 10:34:50.165638	2026-07-09 12:24:03.394153
553	116348612	Yesterday (Remastered 2015)	123	\N	https://cdn-images.dzcdn.net/images/cover/c65b3bd84e81056e060be144381c06c8/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/9/2/0/b92a1a6becd36ae9f8721999d3d916a6.mp3?hdnea=exp=1783507789~acl=/api/1/1/b/9/2/0/b92a1a6becd36ae9f8721999d3d916a6.mp3*~data=user_id=0,application_id=42~hmac=2983aa2866c6e7f6b588edb244173df37e808deffae3d9109075b7c4dadc8d32	440	2026-07-08 10:34:50.165638	2026-07-09 12:24:03.394153
554	2522288451	Now And Then	248	\N	https://cdn-images.dzcdn.net/images/cover/120998ec2b30b9e11c15092b16ff242a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/2/0/0/6207b99b694bc3292004325f215fa44c.mp3?hdnea=exp=1783507789~acl=/api/1/1/6/2/0/0/6207b99b694bc3292004325f215fa44c.mp3*~data=user_id=0,application_id=42~hmac=e446cf5c5364a9eae50ac4aee029c0940be14dfbff7b4af15dafca62a599877d	441	2026-07-08 10:34:50.165638	2026-07-09 12:24:03.394153
555	7193834	Imagine (Remastered 2010)	184	\N	https://cdn-images.dzcdn.net/images/cover/2675a9277dfabb74c32b7a3b2c9b0170/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/c/9/0/fc9e6e7fd857d23c06e58da584e8e7d5.mp3?hdnea=exp=1783507964~acl=/api/1/1/f/c/9/0/fc9e6e7fd857d23c06e58da584e8e7d5.mp3*~data=user_id=0,application_id=42~hmac=36eaa30853a1d65d1e70faaf8b0f1e0871c7aa67166f7b2939fd9245fbca061d	445	2026-07-08 10:37:45.121238	2026-07-09 12:24:03.394153
557	638289522	Abbey Road	287	\N	https://cdn-images.dzcdn.net/images/cover/39d32df73aec3559146a8738972ca795/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/4/0/0/340b8f21ddc654694cf406453e4728b7.mp3?hdnea=exp=1783507988~acl=/api/1/1/3/4/0/0/340b8f21ddc654694cf406453e4728b7.mp3*~data=user_id=0,application_id=42~hmac=1dcf9e6afcd4ddbc43e5289eaa32ce9d932a1dc8eb89312654c3b5b193fc8827	446	2026-07-08 10:38:09.641639	2026-07-09 12:24:03.394153
558	7239811	Abbey Road Blues	277	\N	https://cdn-images.dzcdn.net/images/cover/9306bf6d38f644e6fa24135fbfe70b9d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/9/f/0/c9fc7a23bb998734fb097635f1367572.mp3?hdnea=exp=1783507988~acl=/api/1/1/c/9/f/0/c9fc7a23bb998734fb097635f1367572.mp3*~data=user_id=0,application_id=42~hmac=1d5918077aec4568b00925f6322735ee1f269f8e1fd71a40b68f52aa9f0755c8	447	2026-07-08 10:38:09.641639	2026-07-09 12:24:03.394153
559	3761240162	ABBEY ROAD	189	\N	https://cdn-images.dzcdn.net/images/cover/e85e00c33b370ae3768febd5be6bf188/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/8/a/0/b8a5ed2301b2081b96cb06def1f42600.mp3?hdnea=exp=1783507988~acl=/api/1/1/b/8/a/0/b8a5ed2301b2081b96cb06def1f42600.mp3*~data=user_id=0,application_id=42~hmac=2c36dc3172f4c516257018e24cacf946cb7e68028cf2f564c5a68748db9b8256	448	2026-07-08 10:38:09.641639	2026-07-09 12:24:03.394153
961	1895403967	Running Up That Hill	297	1	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
962	1895403977	Where Is My Mind? (XFM Live Version)	224	2	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
963	1895403997	Johnny and Mary	205	4	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
964	1895404007	20th Century Boy	220	5	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
965	1895404017	The Ballad of Melody Nelson	238	6	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
966	1895404027	Holocaust	267	7	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
967	1895404037	I Feel You	386	8	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
968	1895404047	Daddy Cool	201	9	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
969	1895404057	Jackie	168	10	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	\N	484	2026-07-10 10:54:17.162134	2026-07-10 10:54:17.162134
970	1895560297	Every You Every Me	213	\N	https://cdn-images.dzcdn.net/images/cover/704fc1d3226cbe373dfd6c00345f16f9/1000x1000-000000-80-0-0.jpg	\N	577	2026-07-10 10:54:19.970807	2026-07-10 10:54:19.970807
971	1892440847	The Bitter End	190	\N	https://cdn-images.dzcdn.net/images/cover/2eed7f87482c120dafa45ddc78b91a36/1000x1000-000000-80-0-0.jpg	\N	578	2026-07-10 10:54:19.970807	2026-07-10 10:54:19.970807
972	3642076	Running Up That Hill	294	\N	https://cdn-images.dzcdn.net/images/cover/6d0e74c185ccde6f06c0279d29e04bf4/1000x1000-000000-80-0-0.jpg	\N	579	2026-07-10 10:54:19.970807	2026-07-10 10:54:19.970807
973	1895402107	Meds	175	\N	https://cdn-images.dzcdn.net/images/cover/daa67f6a512718bad66e2986ff40843e/1000x1000-000000-80-0-0.jpg	\N	580	2026-07-10 10:54:19.970807	2026-07-10 10:54:19.970807
974	1875132217	Too Many Friends	214	\N	https://cdn-images.dzcdn.net/images/cover/863af1f70c109aa39b20dee2453a5211/1000x1000-000000-80-0-0.jpg	\N	581	2026-07-10 10:54:19.970807	2026-07-10 10:54:19.970807
975	378170441	I Love My Computer	187	\N	https://cdn-images.dzcdn.net/images/cover/340bd9145fb4e84b505c11f1789834b2/1000x1000-000000-80-0-0.jpg	\N	608	2026-07-11 10:30:55.345442	2026-07-11 10:30:55.345442
976	963042	Ms. Jackson	272	\N	https://cdn-images.dzcdn.net/images/cover/646d6414a24faaccf67c1d7e01f7d095/1000x1000-000000-80-0-0.jpg	\N	609	2026-07-11 15:22:38.775061	2026-07-11 15:22:38.775061
977	2739792971	6.Ila	202	\N	https://cdn-images.dzcdn.net/images/cover/a50d4e6197d56b24a8381eca2e580de7/1000x1000-000000-80-0-0.jpg	\N	610	2026-07-11 15:22:38.775061	2026-07-11 15:22:38.775061
978	2721580562	M.S.I.	126	\N	https://cdn-images.dzcdn.net/images/cover/8419aad85333fd1d7a4a7a6adfd8a589/1000x1000-000000-80-0-0.jpg	\N	611	2026-07-11 15:22:38.775061	2026-07-11 15:22:38.775061
979	565419712	From Suburban (feat. Dj D.S.)	187	\N	https://cdn-images.dzcdn.net/images/cover/e8df2a82fc7198cbe9b2007cb7a3181e/1000x1000-000000-80-0-0.jpg	\N	612	2026-07-11 15:22:38.775061	2026-07-11 15:22:38.775061
980	3555795571	MSI	96	\N	https://cdn-images.dzcdn.net/images/cover/77ba26ffa1e1e818be0456bfbcc2e005/1000x1000-000000-80-0-0.jpg	\N	613	2026-07-11 15:22:38.775061	2026-07-11 15:22:38.775061
981	2267042	I Was Made For Lovin' You	269	\N	https://cdn-images.dzcdn.net/images/cover/22abb990857654105f908a558ea78bc1/1000x1000-000000-80-0-0.jpg	\N	614	2026-07-11 15:22:57.680178	2026-07-11 15:22:57.680178
562	3018519691	Habibi (Love)	144	\N	https://cdn-images.dzcdn.net/images/cover/6ebbc929301ee29121e2be57565e2aea/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/b/8/0/cb81d83eeb6d8abfa8babdd4b502c6ef.mp3?hdnea=exp=1783508344~acl=/api/1/1/c/b/8/0/cb81d83eeb6d8abfa8babdd4b502c6ef.mp3*~data=user_id=0,application_id=42~hmac=6b1ec43aa06fa4de44df47c85a482b69320d398898c22014abfbf560d6a65c2e	451	2026-07-08 10:44:05.966663	2026-07-08 10:44:05.966663
563	4078261761	Habibi	137	\N	https://cdn-images.dzcdn.net/images/cover/021770bfdd65ae5978680a8e3b9e8899/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/e/1/0/8e1f0c4975eabad980d7dd4d330aefe4.mp3?hdnea=exp=1783508344~acl=/api/1/1/8/e/1/0/8e1f0c4975eabad980d7dd4d330aefe4.mp3*~data=user_id=0,application_id=42~hmac=2282c5bf9d82b837a88d8636cc9a16f4f0423dfe962357e2b11f70bf18c29238	452	2026-07-08 10:44:05.966663	2026-07-08 10:44:05.966663
564	568147712	Habibi	306	\N	https://cdn-images.dzcdn.net/images/cover/0ae2f2aeb34757d49a2edea516ee8153/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/a/0/0/2a022ec6a69a378bacf15fdba7faaecf.mp3?hdnea=exp=1783508344~acl=/api/1/1/2/a/0/0/2a022ec6a69a378bacf15fdba7faaecf.mp3*~data=user_id=0,application_id=42~hmac=44211c1ea807a6707bd5dd3f303b11f9be504fe3290c8f443000636b554f7208	453	2026-07-08 10:44:05.966663	2026-07-08 10:44:05.966663
565	1554899102	Habibi (Albanian Remix)	129	\N	https://cdn-images.dzcdn.net/images/cover/744ab63244c3678e7be35ca5fc31ff16/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/b/3/0/eb397e62d0871509ca0369a5cc8b4588.mp3?hdnea=exp=1783508344~acl=/api/1/1/e/b/3/0/eb397e62d0871509ca0369a5cc8b4588.mp3*~data=user_id=0,application_id=42~hmac=35f3aad110217b9d5bb130cfa1fe83980fcb00801f57df0f73bd6d3fd029ba13	454	2026-07-08 10:44:05.966663	2026-07-08 10:44:05.966663
566	3849106611	habibi (Slowed Reverb)	97	\N	https://cdn-images.dzcdn.net/images/cover/c543ae5c0979b854c8bc7e9a93945f14/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/b/2/0/eb27f4086f5a571ab527e0432f341a1d.mp3?hdnea=exp=1783508344~acl=/api/1/1/e/b/2/0/eb27f4086f5a571ab527e0432f341a1d.mp3*~data=user_id=0,application_id=42~hmac=539bf8b105e0fb65f03fda06b6adece99b84ba2c6453ddcf81ea4fe9da9d0288	455	2026-07-08 10:44:05.966663	2026-07-08 10:44:05.966663
567	1778246247	Свой дом	211	\N	https://cdn-images.dzcdn.net/images/cover/7a2028360db83db9c384a0b9317a2126/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/8/8/0/7884b3221669b602431a05d1912f399b.mp3?hdnea=exp=1783509229~acl=/api/1/1/7/8/8/0/7884b3221669b602431a05d1912f399b.mp3*~data=user_id=0,application_id=42~hmac=12724125bbf96fa9970bd5c6d5d270dbf884aa4f9cdda6198ff0635d013c9f3d	456	2026-07-08 10:58:50.061615	2026-07-08 10:58:50.061615
568	630340912	Малиновый закат	177	\N	https://cdn-images.dzcdn.net/images/cover/23459a8b1f40c4fadd02734792eb3bdc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/b/d/0/4bda3668320e571a69b6a45e7f702586.mp3?hdnea=exp=1783509229~acl=/api/1/1/4/b/d/0/4bda3668320e571a69b6a45e7f702586.mp3*~data=user_id=0,application_id=42~hmac=6161d6a9a15f147f1bc14f0c4877a028b96250e9f463981b3cf7f1507d46246e	457	2026-07-08 10:58:50.061615	2026-07-08 10:58:50.061615
569	630343642	Жить в кайф	174	\N	https://cdn-images.dzcdn.net/images/cover/db13a4fa1877ad1c2837413446c257da/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/2/2/0/5225f684286f7f49bdb0303bc12047c4.mp3?hdnea=exp=1783509229~acl=/api/1/1/5/2/2/0/5225f684286f7f49bdb0303bc12047c4.mp3*~data=user_id=0,application_id=42~hmac=9abe3be534de839b57c526252a116205c51526bd99f9ea1a57a9ab4967116d7a	458	2026-07-08 10:58:50.061615	2026-07-08 10:58:50.061615
570	643028932	Небо поможет нам	208	\N	https://cdn-images.dzcdn.net/images/cover/7b07f38b90fa47bf16b73c0fe603c48c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/9/c/0/69c75c1c39257d216530a49e6a9a2851.mp3?hdnea=exp=1783509229~acl=/api/1/1/6/9/c/0/69c75c1c39257d216530a49e6a9a2851.mp3*~data=user_id=0,application_id=42~hmac=5ca54fa7542f89933723add336da327f9c7b82505a336c63cd6b729d64383770	459	2026-07-08 10:58:50.061615	2026-07-08 10:58:50.061615
571	4022516031	Что ты несёшь	177	\N	https://cdn-images.dzcdn.net/images/cover/34419c4038eed93ff8308405bf9a0305/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/0/2/0/5022b2cea8cd4232e0db0cb066112478.mp3?hdnea=exp=1783509229~acl=/api/1/1/5/0/2/0/5022b2cea8cd4232e0db0cb066112478.mp3*~data=user_id=0,application_id=42~hmac=e5f417423aeddbb7b0f4237a2a20832c9b4a59ef518f5fca947716bc324decf5	460	2026-07-08 10:58:50.061615	2026-07-08 10:58:50.061615
592	1015632342	Fenêtre (Pt, 1)	66	1	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/2/4/0/1244908a79d0c101f87299cb1425706b.mp3?hdnea=exp=1783530325~acl=/api/1/1/1/2/4/0/1244908a79d0c101f87299cb1425706b.mp3*~data=user_id=0,application_id=42~hmac=d1b26fd550f873eb3bafa3ea7ccd21490b0ed825df9cb80816292f5b3b75d049	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
593	1015632352	Spring Break	131	2	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/0/b/0/90bdb754aa5ad9c195975dfdcdd75098.mp3?hdnea=exp=1783530325~acl=/api/1/1/9/0/b/0/90bdb754aa5ad9c195975dfdcdd75098.mp3*~data=user_id=0,application_id=42~hmac=7e472c2577803d93fdeb6aaf06e7ed79ef3d854dc876bd9dee478e4803e274a0	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
594	1015632362	Kobe	151	3	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/d/f/0/2df77bd9fdfa1e56fd4a01583d592736.mp3?hdnea=exp=1783530325~acl=/api/1/1/2/d/f/0/2df77bd9fdfa1e56fd4a01583d592736.mp3*~data=user_id=0,application_id=42~hmac=4c0f46bf286004c2214e0c3cb0c2e4772b8e43c2d6535700c0d5655acefd3dfd	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
595	1015632372	Roméo + Juliette	208	4	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/d/8/0/7d89222d9793a66056af9ce382098ef7.mp3?hdnea=exp=1783530325~acl=/api/1/1/7/d/8/0/7d89222d9793a66056af9ce382098ef7.mp3*~data=user_id=0,application_id=42~hmac=b295be0ce07112d9535b8f5a53de60ec195c7bdf487a40aa55a0473ce4b4703a	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
596	1015632382	Pirogue	204	5	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/3/7/0/1374b7c42d96bd8a75880588b40eaa05.mp3?hdnea=exp=1783530325~acl=/api/1/1/1/3/7/0/1374b7c42d96bd8a75880588b40eaa05.mp3*~data=user_id=0,application_id=42~hmac=82f57c4116e96eaaedc2c5862cf77d1734a0dedc814eeccd517134e28da96070	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
597	1015632392	Sirius	210	6	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/5/2/0/052010fcee7ca72fcb1c254fa7d7174b.mp3?hdnea=exp=1783530325~acl=/api/1/1/0/5/2/0/052010fcee7ca72fcb1c254fa7d7174b.mp3*~data=user_id=0,application_id=42~hmac=b4d0bc9270013f1ec39edeaf865b7dc2f5dc5f80637ed9cb165cb84c32531a96	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
598	1015632402	Victor	161	7	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/9/b/0/b9ba150036389b70e5596721d6bc1bc0.mp3?hdnea=exp=1783530325~acl=/api/1/1/b/9/b/0/b9ba150036389b70e5596721d6bc1bc0.mp3*~data=user_id=0,application_id=42~hmac=ca3531d88f22a4b197d13a50db3f3ef1cf1c2721abf71fdc9db1852b20ea757f	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
572	3702636262	В невесомости	192	\N	https://cdn-images.dzcdn.net/images/cover/5ac68130062fd4f563ea96305f5f769e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/0/3/0/60333d24b000bb03e55c7862cdc39d2a.mp3?hdnea=exp=1783509229~acl=/api/1/1/6/0/3/0/60333d24b000bb03e55c7862cdc39d2a.mp3*~data=user_id=0,application_id=42~hmac=7bc885538626df470ab0c4ec316f75c5f657f94de3c6f70ebece363510ec2e5e	461	2026-07-08 10:58:50.411933	2026-07-08 10:58:50.411933
573	2109984447	Пацаны грустили	179	\N	https://cdn-images.dzcdn.net/images/cover/01819cd885eafec993bcaf4aafa26f3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/1/0/8310337b0a2c22df4825846a40b6e100.mp3?hdnea=exp=1783509229~acl=/api/1/1/8/3/1/0/8310337b0a2c22df4825846a40b6e100.mp3*~data=user_id=0,application_id=42~hmac=a6b5b213ffa7749e16c53163a6089a9c0d57510c0b266f34223988d89f59e7d0	462	2026-07-08 10:58:50.411933	2026-07-08 10:58:50.411933
574	627615482	Мир твоими глазами	240	\N	https://cdn-images.dzcdn.net/images/cover/805ce865a4c43717a25bfda7bfeabaf7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/5/0/635684fbb0e573d71c1df25d510e5a27.mp3?hdnea=exp=1783509229~acl=/api/1/1/6/3/5/0/635684fbb0e573d71c1df25d510e5a27.mp3*~data=user_id=0,application_id=42~hmac=d1bd954f5834041a968b024efce27a298e9e3d275c33fe2ca9dee72764ac400c	463	2026-07-08 10:58:50.411933	2026-07-08 10:58:50.411933
575	2109984437	Клевер	204	\N	https://cdn-images.dzcdn.net/images/cover/01819cd885eafec993bcaf4aafa26f3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/9/e/0/39ec3058e91b9e52cbb1e446eb484d81.mp3?hdnea=exp=1783509229~acl=/api/1/1/3/9/e/0/39ec3058e91b9e52cbb1e446eb484d81.mp3*~data=user_id=0,application_id=42~hmac=9313cbb5db0dd5478b5ae3d045acb7a8ee23baa38fb8ae5f69d204092b6b819d	462	2026-07-08 10:58:50.411933	2026-07-08 10:58:50.411933
576	608225062	Новый день	198	\N	https://cdn-images.dzcdn.net/images/cover/d16605c07b5b532a2490e70870ecc576/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/a/b/0/aab8c76ddb5ebd3de93ec4ba3d0b6b22.mp3?hdnea=exp=1783509229~acl=/api/1/1/a/a/b/0/aab8c76ddb5ebd3de93ec4ba3d0b6b22.mp3*~data=user_id=0,application_id=42~hmac=b6c176a9ad756f0a88650533becd0e39eaafd7681260b204325c476e8fe38996	464	2026-07-08 10:58:50.411933	2026-07-08 10:58:50.411933
599	1015632412	IO Super bulle bonus	153	8	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/b/5/0/cb5dce26f99c2fcf6f080ddaf0b8a52b.mp3?hdnea=exp=1783530325~acl=/api/1/1/c/b/5/0/cb5dce26f99c2fcf6f080ddaf0b8a52b.mp3*~data=user_id=0,application_id=42~hmac=f7651705049337c57bb805cdb8980d5770000ea6b30eed202529f9c042896e18	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
600	1015632422	Neo	107	9	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/b/2/0/5b26d1e78a562551ab73299a54d3fff6.mp3?hdnea=exp=1783530325~acl=/api/1/1/5/b/2/0/5b26d1e78a562551ab73299a54d3fff6.mp3*~data=user_id=0,application_id=42~hmac=06c29e005bc94857950b776f0036b37187cdf7394e25edd4224208831bbc5e0a	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
601	1015632432	Esteban	178	10	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/5/2/0/35238e512d6d1ae7094f7f9c60c90844.mp3?hdnea=exp=1783530325~acl=/api/1/1/3/5/2/0/35238e512d6d1ae7094f7f9c60c90844.mp3*~data=user_id=0,application_id=42~hmac=6a87032aa9f5c3abb26b27c4d4790877621a852e3760190198a754e5e7a07cc9	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
602	1015632442	Soucoupe	141	11	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/2/b/0/f2b1e95c20b75bb435ebf0d0dbe073e7.mp3?hdnea=exp=1783530325~acl=/api/1/1/f/2/b/0/f2b1e95c20b75bb435ebf0d0dbe073e7.mp3*~data=user_id=0,application_id=42~hmac=b20a2deb2e209328096ad00b15811d752361f81e1f328003451ae89c006c926b	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
603	1015632452	Fantasia	146	12	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/7/7/0/1771f49cc251f4e353c3abed2120827b.mp3?hdnea=exp=1783530325~acl=/api/1/1/1/7/7/0/1771f49cc251f4e353c3abed2120827b.mp3*~data=user_id=0,application_id=42~hmac=cb89112dd9d63c4dd4d64b1d9dd30de16de076d4fb35da352f149b47f1cf810f	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
604	1015632462	Faut que tu saches	191	13	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/4/2/0/d421eb99b7ec69fb1ee9e4fb12379009.mp3?hdnea=exp=1783530325~acl=/api/1/1/d/4/2/0/d421eb99b7ec69fb1ee9e4fb12379009.mp3*~data=user_id=0,application_id=42~hmac=3af51ebf6d96fcbe0116bbe47de3b10a9b381dd7b6566ecb695f0a658dd051ed	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
605	1015632472	Maya Maya	194	14	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/7/0/637e670eb05341682d3183b867945e0f.mp3?hdnea=exp=1783530325~acl=/api/1/1/6/3/7/0/637e670eb05341682d3183b867945e0f.mp3*~data=user_id=0,application_id=42~hmac=93655ef08ecb20d9d4ca4c70e2eed1b2233a909e6585fa695f2d49a7aa039ac2	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
606	1015632482	Feel Good	224	15	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/a/5/0/ca5fbb9ddaf6e1ff93cbace83ccbdbbf.mp3?hdnea=exp=1783530325~acl=/api/1/1/c/a/5/0/ca5fbb9ddaf6e1ff93cbace83ccbdbbf.mp3*~data=user_id=0,application_id=42~hmac=acc103dfd247a8a526165af7bf97808995c5f6c2fa6f4d7bb479331c49fe955a	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
607	1015632492	Jumanji	105	16	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/6/6/0/866e297f7af9bac37f4642954c21b8d1.mp3?hdnea=exp=1783530325~acl=/api/1/1/8/6/6/0/866e297f7af9bac37f4642954c21b8d1.mp3*~data=user_id=0,application_id=42~hmac=7460cb2577469e2406e77271573ea1eb5b792b973a4e27e51dc585667e7334aa	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
608	1015632502	Overstone	161	17	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/3/f/0/33f678ee81ba96f91ddd97ea4d82e534.mp3?hdnea=exp=1783530325~acl=/api/1/1/3/3/f/0/33f678ee81ba96f91ddd97ea4d82e534.mp3*~data=user_id=0,application_id=42~hmac=68175d6f8c3bcefeda1f9c74cd7798092881662a5b2c19d4af539220f9857993	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
609	1015632512	Stu	123	18	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/c/3/0/fc3f13b28113e4c92739971750e8a2dc.mp3?hdnea=exp=1783530325~acl=/api/1/1/f/c/3/0/fc3f13b28113e4c92739971750e8a2dc.mp3*~data=user_id=0,application_id=42~hmac=b81d0d36a23d782556f3cdd763df145812afc82b34ec4c1b6ba7f5c5024f1eba	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
610	1015632522	Acné	159	19	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/b/f/0/7bf31c09398f978dacf131c105936656.mp3?hdnea=exp=1783530325~acl=/api/1/1/7/b/f/0/7bf31c09398f978dacf131c105936656.mp3*~data=user_id=0,application_id=42~hmac=b24c9b328bbede9f66440424f97bbba4922cbe180ebc7b46894a25103fe74f31	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
982	3958854131	First Light	204	\N	https://cdn-images.dzcdn.net/images/cover/6f91210db2e594848ef5b609a98de9b5/1000x1000-000000-80-0-0.jpg	\N	615	2026-07-11 15:22:57.680178	2026-07-11 15:22:57.680178
577	3709980222	Не складається	211	\N	https://cdn-images.dzcdn.net/images/cover/cf6f0cc4578d0fcd9d075d32a328b2fc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/2/f/0/92f2b5f0b91fa23fb14ddee4e8664cdf.mp3?hdnea=exp=1783509229~acl=/api/1/1/9/2/f/0/92f2b5f0b91fa23fb14ddee4e8664cdf.mp3*~data=user_id=0,application_id=42~hmac=bfb24edf4c70280ec5cb775325829bb0180534fcd045fab4b2edd85f0763d838	465	2026-07-08 10:58:50.481196	2026-07-08 10:58:50.481196
578	4058569711	Кольє	201	\N	https://cdn-images.dzcdn.net/images/cover/31f8c9a7b27f75e151ce453b9842f2c2/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/d/a/0/0da332f135f06c55f45f9b3b2470a9b1.mp3?hdnea=exp=1783509229~acl=/api/1/1/0/d/a/0/0da332f135f06c55f45f9b3b2470a9b1.mp3*~data=user_id=0,application_id=42~hmac=230af7fd5f277da993432178ddf56224795093ace978c73fedfa63a8ab90d438	466	2026-07-08 10:58:50.481196	2026-07-08 10:58:50.481196
579	4019227231	Людина для мене	267	\N	https://cdn-images.dzcdn.net/images/cover/20fb5b4abb4e3632d56d69282bca07f4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/a/a/0/3aae285ca7d1e6b9b4bf2f61c775725d.mp3?hdnea=exp=1783509229~acl=/api/1/1/3/a/a/0/3aae285ca7d1e6b9b4bf2f61c775725d.mp3*~data=user_id=0,application_id=42~hmac=7729e2005cd2a780d64596b29ad334653db9bf0989c4680eaedf485a95ebc083	467	2026-07-08 10:58:50.481196	2026-07-08 10:58:50.481196
580	3808284612	Закоханий	228	\N	https://cdn-images.dzcdn.net/images/cover/5e8e59954ce49377da69288dcf9cd4e8/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/a/5/0/aa58579607abc250b8a2b6a2f6b19d26.mp3?hdnea=exp=1783509229~acl=/api/1/1/a/a/5/0/aa58579607abc250b8a2b6a2f6b19d26.mp3*~data=user_id=0,application_id=42~hmac=bc1a804db16eb5d346e744c7520f1ea8142950ca99fd8a776faa76269b6facbc	468	2026-07-08 10:58:50.481196	2026-07-08 10:58:50.481196
581	3654296672	Колишній	220	\N	https://cdn-images.dzcdn.net/images/cover/5d1c7b5d62fa0da3beaedbbf36cdf29f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/b/2/0/bb20f95334c647c9247b52f56445be5f.mp3?hdnea=exp=1783509229~acl=/api/1/1/b/b/2/0/bb20f95334c647c9247b52f56445be5f.mp3*~data=user_id=0,application_id=42~hmac=2ed59bcff19d7fa976f08a4c208660f02e16885adadf7071a313fa89c9e0e0fc	469	2026-07-08 10:58:50.481196	2026-07-08 10:58:50.481196
611	1015632532	2002	138	20	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/c/0/0/6c08a4ac8966364eceab9fd08ce36457.mp3?hdnea=exp=1783530325~acl=/api/1/1/6/c/0/0/6c08a4ac8966364eceab9fd08ce36457.mp3*~data=user_id=0,application_id=42~hmac=cfd2eae1c07742d55fa7eb03840495571c1789b286263382d271a1e6f980388a	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
612	1015632542	Vaisseau spatial	158	21	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/2/4/0/5247324f7f764022fb12b8e8b85d80db.mp3?hdnea=exp=1783530325~acl=/api/1/1/5/2/4/0/5247324f7f764022fb12b8e8b85d80db.mp3*~data=user_id=0,application_id=42~hmac=e8edab4d8428662c0a14424acd0e778b805ecfca5c378a643d1665bc94c822de	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
613	1015632552	Fenêtre (Pt, 2)	116	22	https://cdn-images.dzcdn.net/images/cover/826254f5c8915394490b16f8de0bc3d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/6/0/1465518ba069eeda3d2fe8119a184843.mp3?hdnea=exp=1783530325~acl=/api/1/1/1/4/6/0/1465518ba069eeda3d2fe8119a184843.mp3*~data=user_id=0,application_id=42~hmac=19a934567255ba4bffff5463648598c15e711a6efa091f365a3aac6ec4901fbd	424	2026-07-08 16:50:25.202057	2026-07-08 16:50:25.202057
983	14525574	We Found Love (Album Version)	216	\N	https://cdn-images.dzcdn.net/images/cover/5199f89d5113a83b5086463d5d0c9415/1000x1000-000000-80-0-0.jpg	\N	616	2026-07-11 15:22:57.680178	2026-07-11 15:22:57.680178
984	62847142	Titanium (feat. Sia)	245	\N	https://cdn-images.dzcdn.net/images/cover/52330286cb5008805253fd77c7111d3f/1000x1000-000000-80-0-0.jpg	\N	617	2026-07-11 15:22:57.680178	2026-07-11 15:22:57.680178
985	12724819	Moves Like Jagger (Studio Recording From "The Voice" Performance)	201	\N	https://cdn-images.dzcdn.net/images/cover/86fb42ca017f0266d0885c1bede988bf/1000x1000-000000-80-0-0.jpg	\N	618	2026-07-11 15:22:57.680178	2026-07-11 15:22:57.680178
206	65440509	Tap Out	222	1	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/1/6/0/116d57c31c9b5dd87f05e588e30acd86.mp3?hdnea=exp=1776868196~acl=/api/1/1/1/1/6/0/116d57c31c9b5dd87f05e588e30acd86.mp3*~data=user_id=0,application_id=42~hmac=6d09521b095acf03241caf1e82ee26d49d203c7e8e94c3e47ba533f442faa259	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
582	16204632	Get A Way	226	\N	https://cdn-images.dzcdn.net/images/cover/f49a4b819f2c8653cf2a96e4bf419d1e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/8/d/0/18d72004ddcba1becd59563d15598361.mp3?hdnea=exp=1783509235~acl=/api/1/1/1/8/d/0/18d72004ddcba1becd59563d15598361.mp3*~data=user_id=0,application_id=42~hmac=7a9bd39bdf0ddc9dfda55a15677c02a8a1445f3090b6a3987c24ead363def722	470	2026-07-08 10:58:56.669888	2026-07-08 10:58:56.669888
583	717675152	Ma Chérie (DJ Antoine & Mad Mark 2K12 Radio Edit)	191	\N	https://cdn-images.dzcdn.net/images/cover/fef344675f60f7357b328fc6f43bb5eb/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/3/e/0/a3e27dea8f828b8c59c631432b4eaf66.mp3?hdnea=exp=1783509235~acl=/api/1/1/a/3/e/0/a3e27dea8f828b8c59c631432b4eaf66.mp3*~data=user_id=0,application_id=42~hmac=8c374b62c3638a790951c4481c55c8de5ffd66d53f0b3df2a70f66c30875e901	471	2026-07-08 10:58:56.669888	2026-07-08 10:58:56.669888
584	3919388491	Freaky 1	232	\N	https://cdn-images.dzcdn.net/images/cover/3165968b80c20fe612bc5f361e5e7fa5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/4/8/0/f48adbf76ca650cb2f005d810cd6a060.mp3?hdnea=exp=1783509235~acl=/api/1/1/f/4/8/0/f48adbf76ca650cb2f005d810cd6a060.mp3*~data=user_id=0,application_id=42~hmac=1875881de28ef2c021d086c880bbe9e16a58c03c9d3c1f91a9aaf05a1dac046a	472	2026-07-08 10:58:56.669888	2026-07-08 10:58:56.669888
585	4019743311	Kame	144	\N	https://cdn-images.dzcdn.net/images/cover/b6d1a93857fe81f962026239de5c83a3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/9/c/0/f9c7724f5468e2349ef26ef230a1a2c6.mp3?hdnea=exp=1783509235~acl=/api/1/1/f/9/c/0/f9c7724f5468e2349ef26ef230a1a2c6.mp3*~data=user_id=0,application_id=42~hmac=326fbcc94697ce016ca872d19f65e547254b386286bb16796423ad2cfe4dcbae	473	2026-07-08 10:58:56.669888	2026-07-08 10:58:56.669888
586	497150662	Richter: On the Nature of Daylight	371	\N	https://cdn-images.dzcdn.net/images/cover/ed07053951a44ce34a5ca9c61a2d680f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/6/e/0/b6e95d9da5a72875a9729eaa8dffab1d.mp3?hdnea=exp=1783509235~acl=/api/1/1/b/6/e/0/b6e95d9da5a72875a9729eaa8dffab1d.mp3*~data=user_id=0,application_id=42~hmac=4ef2cad43c6230ff176336e954eb40a790aded484ff81348552c5724b6ea3e4a	474	2026-07-08 10:58:56.669888	2026-07-08 10:58:56.669888
587	1617237842	Ultima Botella	262	\N	https://cdn-images.dzcdn.net/images/cover/bbc9aac411448b936e19a268d28bc217/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/d/a/0/dda677ef3c7ee0541c67e7fd4d9e75ec.mp3?hdnea=exp=1783509288~acl=/api/1/1/d/d/a/0/dda677ef3c7ee0541c67e7fd4d9e75ec.mp3*~data=user_id=0,application_id=42~hmac=2c5c492c836d70a85d5d25da84a129c80870892ae7e2ed135bd61d504beed963	475	2026-07-08 10:59:50.013879	2026-07-08 10:59:50.013879
588	3740175372	Wherever You Go	183	\N	https://cdn-images.dzcdn.net/images/cover/1a8ac1cfdc24f8d87cbe46498bdd2ef7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/b/9/0/4b93e9e2e4f95dfddfafa0630798d5c7.mp3?hdnea=exp=1783509288~acl=/api/1/1/4/b/9/0/4b93e9e2e4f95dfddfafa0630798d5c7.mp3*~data=user_id=0,application_id=42~hmac=179b7f9f175031e02aedd35f8f0a29130c034144c1389a81d2c664f127b71574	476	2026-07-08 10:59:50.013879	2026-07-08 10:59:50.013879
589	3628235132	The Thing I Love	172	\N	https://cdn-images.dzcdn.net/images/cover/1b6ab9a23f2d3804e8034966e7aa0bc0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/9/5/0/c95f0da34a0668ba75e2fdfd0844498f.mp3?hdnea=exp=1783509288~acl=/api/1/1/c/9/5/0/c95f0da34a0668ba75e2fdfd0844498f.mp3*~data=user_id=0,application_id=42~hmac=133ee9d153d75e0d2299d57482acb380c8df998c53cb109406054edea13e2d30	477	2026-07-08 10:59:50.013879	2026-07-08 10:59:50.013879
590	2599616392	come home	146	\N	https://cdn-images.dzcdn.net/images/cover/aa75eb1c27af65cf0eaf72647fa1a3b1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/2/0/0/920c3c1630c18fbf0af34ce8188a3161.mp3?hdnea=exp=1783509288~acl=/api/1/1/9/2/0/0/920c3c1630c18fbf0af34ce8188a3161.mp3*~data=user_id=0,application_id=42~hmac=6290f40fc9dbf3ce010541bef7204da8bb95b8cc539a4051da41752d5d811283	478	2026-07-08 10:59:50.013879	2026-07-08 10:59:50.013879
591	3595386512	Everywhere	199	\N	https://cdn-images.dzcdn.net/images/cover/31d9e4d4bf3baa6e77b700d6e18a7b7d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/5/2/0/652288fec678eb0a9e0402b27ec36bbe.mp3?hdnea=exp=1783509288~acl=/api/1/1/6/5/2/0/652288fec678eb0a9e0402b27ec36bbe.mp3*~data=user_id=0,application_id=42~hmac=a1855241a8ad8876015d72b8ba7941ecc66984c0dd1de368ba4fcc740f3a57f9	479	2026-07-08 10:59:50.013879	2026-07-08 10:59:50.013879
615	3786359852	Bigmouth Strikes Again (Live)	200	\N	https://cdn-images.dzcdn.net/images/cover/171466a7e722c7d1ca0f79cad3c34e5b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/7/4/0/074f6288616df6718703664313032787.mp3?hdnea=exp=1783589011~acl=/api/1/1/0/7/4/0/074f6288616df6718703664313032787.mp3*~data=user_id=0,application_id=42~hmac=095bf4911cd8bc8dd67b6385354d3af8a0d65d6774bc4f30589b654b187d3d51	483	2026-07-09 09:08:32.252141	2026-07-09 09:08:32.252141
619	13785965	The Queen Is Dead (2011 Remaster)	387	1	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/0/1/0/6010b54c0d695d8a65fa323c571f7c82.mp3?hdnea=exp=1783589055~acl=/api/1/1/6/0/1/0/6010b54c0d695d8a65fa323c571f7c82.mp3*~data=user_id=0,application_id=42~hmac=1c203df6948f0db4029635dd8a63b76694f949903fbec8e49dc2ec00d7a67699	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
620	13785966	Frankly, Mr. Shankly (2011 Remaster)	138	2	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/d/1/0/9d17a75b7de1b3601341873089daa762.mp3?hdnea=exp=1783589055~acl=/api/1/1/9/d/1/0/9d17a75b7de1b3601341873089daa762.mp3*~data=user_id=0,application_id=42~hmac=d194be10d3db06c02074e8c13278053fb1d0457c40bcaeb798231c5cf24196a5	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
616	1895403987	Bigmouth Strikes Again	234	3	https://cdn-images.dzcdn.net/images/cover/beca62e774cb578c8c362e92b6706ce4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/d/8/0/7d8000e0d766f1e93afb7454cafbc611.mp3?hdnea=exp=1783589011~acl=/api/1/1/7/d/8/0/7d8000e0d766f1e93afb7454cafbc611.mp3*~data=user_id=0,application_id=42~hmac=234e39f5f7c168b51cf60b688bb84bde07108dcea7cf42aac8e42449eedac303	484	2026-07-09 09:08:32.252141	2026-07-10 10:54:17.162134
617	13785998	Bigmouth Strikes Again (Live in London, 1986)	354	14	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/e/f/0/2ef40ca401a5004d3d9968eb08e4274c.mp3?hdnea=exp=1783589011~acl=/api/1/1/2/e/f/0/2ef40ca401a5004d3d9968eb08e4274c.mp3*~data=user_id=0,application_id=42~hmac=65dfc3d5b1a1d2a01588a37fb971a0c8e91e0ecb55510c9656b98de5f79a6112	485	2026-07-09 09:08:32.252141	2026-07-11 16:14:17.944989
621	13785967	I Know It's Over (2011 Remaster)	349	3	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/8/b/0/a8ba1f02295bfaf43d65a8886222befe.mp3?hdnea=exp=1783589055~acl=/api/1/1/a/8/b/0/a8ba1f02295bfaf43d65a8886222befe.mp3*~data=user_id=0,application_id=42~hmac=82a741c88688ce84fe70c15524ab20f200e1eac1b8dc9b7d10c5092e202fb22e	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
622	13785968	Never Had No One Ever (2011 Remaster)	218	4	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/2/a/0/72a1eb5976f14120532bb62ac6ec6211.mp3?hdnea=exp=1783589055~acl=/api/1/1/7/2/a/0/72a1eb5976f14120532bb62ac6ec6211.mp3*~data=user_id=0,application_id=42~hmac=adc0a08b647973756602a5a0f0e8a10e2e657f07c9a38d770d93acf3410baf8d	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
623	13785969	Cemetry Gates (2011 Remaster)	161	5	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/a/b/0/eab3c8d361d355eac52af3725e4de47b.mp3?hdnea=exp=1783589055~acl=/api/1/1/e/a/b/0/eab3c8d361d355eac52af3725e4de47b.mp3*~data=user_id=0,application_id=42~hmac=8eed20d411d9d2a28f354986e87b457248bd08e0745a13f076808abe0a84b4a2	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
624	13785970	Bigmouth Strikes Again (2011 Remaster)	193	6	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/6/5/0/5653d68040b7ec8761a29476d6f57a59.mp3?hdnea=exp=1783589055~acl=/api/1/1/5/6/5/0/5653d68040b7ec8761a29476d6f57a59.mp3*~data=user_id=0,application_id=42~hmac=6a1cd1172d0aac24db01b0690b1cc1121101e82b3aef898f7d1d86bb5360da54	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
625	13785971	The Boy with the Thorn in His Side (2011 Remaster)	196	7	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/d/6/0/ed6bab620f832f523785d0af1e903cf5.mp3?hdnea=exp=1783589055~acl=/api/1/1/e/d/6/0/ed6bab620f832f523785d0af1e903cf5.mp3*~data=user_id=0,application_id=42~hmac=95a8864598fe3e31f371f19af47556e4c06f3786b7a95f8088f52f2092e2852c	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
626	13785972	Vicar in a Tutu (2011 Remaster)	144	8	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/5/5/0/955aac208b20024ca5e3f4a1f008370b.mp3?hdnea=exp=1783589055~acl=/api/1/1/9/5/5/0/955aac208b20024ca5e3f4a1f008370b.mp3*~data=user_id=0,application_id=42~hmac=b14547ff77be408c5edc42d250cb4920e7dd80699ecd5c3daae587bf92160d8e	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
627	13785973	There Is a Light That Never Goes Out (2011 Remaster)	244	9	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/0/a/0/30a370e058281fdda3cb8cc9c96f7aa4.mp3?hdnea=exp=1783589055~acl=/api/1/1/3/0/a/0/30a370e058281fdda3cb8cc9c96f7aa4.mp3*~data=user_id=0,application_id=42~hmac=47faef19faf50c6befe99f4bced165689b48c9d51c6f7fc6af5c981fe45f8a08	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
628	13785974	Some Girls Are Bigger Than Others (2011 Remaster)	197	10	https://cdn-images.dzcdn.net/images/cover/7ca9c4c9988765720bf3b722e101d2c3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/5/6/0/b569a3bf9795f12a6da84e55a9fcbd16.mp3?hdnea=exp=1783589055~acl=/api/1/1/b/5/6/0/b569a3bf9795f12a6da84e55a9fcbd16.mp3*~data=user_id=0,application_id=42~hmac=881a04b25f6dfe76972e7c34671dc897bec14854840a7582e1b2df3573f0858e	486	2026-07-09 09:09:15.413317	2026-07-09 09:09:15.413317
986	2012704277	Out of the Hole	186	\N	https://cdn-images.dzcdn.net/images/cover/a98c5495c28a25cfdf8f41f13099357e/1000x1000-000000-80-0-0.jpg	\N	619	2026-07-11 15:28:03.507889	2026-07-11 15:28:03.507889
987	2394739825	Beck: Mongolian Chop Squad	99	\N	https://cdn-images.dzcdn.net/images/cover/14970e95249d6b4104b9d1f54fc370d1/1000x1000-000000-80-0-0.jpg	\N	620	2026-07-11 15:28:03.507889	2026-07-11 15:28:03.507889
988	2014685827	Human Fly	200	\N	https://cdn-images.dzcdn.net/images/cover/7e7725facbea2a6017db08325f1b35d9/1000x1000-000000-80-0-0.jpg	\N	621	2026-07-11 15:28:03.507889	2026-07-11 15:28:03.507889
989	2507167761	Mongolian Chop Squad	145	\N	https://cdn-images.dzcdn.net/images/cover/0f585eca288fb3d53b89d3d717c14ee7/1000x1000-000000-80-0-0.jpg	\N	622	2026-07-11 15:28:03.507889	2026-07-11 15:28:03.507889
952	13785985	The Queen Is Dead (Live in London, 1986)	257	1	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-10 09:45:51.699409	2026-07-11 16:14:17.944989
991	13785986	Panic (Live in London, 1986)	187	2	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
992	13785987	Vicar in a Tutu (Live in London, 1986)	152	3	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
993	13785988	Ask (Live in London, 1986)	202	4	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
994	13785989	His Latest Flame / Rusholme Ruffians (Live in London, 1986; Medley)	235	5	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
995	13785990	The Boy with the Thorn in His Side (Live in London, 1986)	228	6	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
996	13785991	Rubber Ring / What She Said (Live in London, 1986)	229	7	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
997	13785992	Is It Really so Strange? (Live in London, 1986)	217	8	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
998	13785993	Cemetry Gates (Live in London, 1986)	171	9	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
999	13785994	London (Live in London, 1986)	158	10	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
1000	13785995	I Know It's Over (Live in London, 1986; Extended Mix)	466	11	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
1001	13785996	The Draize Train (Live in London, 1986)	267	12	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
1002	13785997	Still Ill (Live in London, 1986)	250	13	https://cdn-images.dzcdn.net/images/cover/0641cf0ba1a9f0c2e712183c3d4a87f2/1000x1000-000000-80-0-0.jpg	\N	485	2026-07-11 16:14:17.944989	2026-07-11 16:14:17.944989
1003	3904353331	Malencunia	208	\N	https://cdn-images.dzcdn.net/images/cover/8bae2b12930ec520454f13df0738b419/1000x1000-000000-80-0-0.jpg	\N	627	2026-07-11 18:08:20.722733	2026-07-11 18:08:20.722733
629	3510911461	Don't Tap The Glass! (feat. Taylor & The Creative)	166	\N	https://cdn-images.dzcdn.net/images/cover/30c4d5c8542bf7a8468bd4500035f97e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/2/7/0/c27dba984657362952f5c1452a10622a.mp3?hdnea=exp=1783589982~acl=/api/1/1/c/2/7/0/c27dba984657362952f5c1452a10622a.mp3*~data=user_id=0,application_id=42~hmac=70b3d9323f548411e5a8dc0a412b2ad4d51e0957d61f14cbf9da0ad935c0573c	488	2026-07-09 09:24:43.580434	2026-07-09 09:24:43.580434
631	1483924972	I Don't Wanna Talk (I Just Wanna Dance)	195	\N	https://cdn-images.dzcdn.net/images/cover/d02cc165fcdaa7cf5b4e4ee929ab99bd/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/b/b/0/2bb775f7d79b9576eade6fe340463e69.mp3?hdnea=exp=1783589982~acl=/api/1/1/2/b/b/0/2bb775f7d79b9576eade6fe340463e69.mp3*~data=user_id=0,application_id=42~hmac=aa8381058143f9b4e641c0f7812307625e30b530e58b64633529ab87f8bcf88e	489	2026-07-09 09:24:43.580434	2026-07-09 09:24:43.580434
633	3470152931	Big Poe (feat. Sk8brd)	182	1	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/f/f/0/cff14b47e9d39cf27796b5fa1bd64288.mp3?hdnea=exp=1783589987~acl=/api/1/1/c/f/f/0/cff14b47e9d39cf27796b5fa1bd64288.mp3*~data=user_id=0,application_id=42~hmac=52bf269a887d571e346a02a78c556b876c58a6aa7a88dd34be3f469237078a0c	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
634	3470152951	Sucka Free	161	3	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/b/d/0/4bdd41d904a54b48c0147e262492dc50.mp3?hdnea=exp=1783589987~acl=/api/1/1/4/b/d/0/4bdd41d904a54b48c0147e262492dc50.mp3*~data=user_id=0,application_id=42~hmac=3293fb1bd17c76ec44cd1dcca200651304cac13ee55c395ed176c019d5fdbfd5	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
635	3470152961	Mommanem	75	4	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/0/b/0/80b7d26382efa412a2779c33c566df8e.mp3?hdnea=exp=1783589987~acl=/api/1/1/8/0/b/0/80b7d26382efa412a2779c33c566df8e.mp3*~data=user_id=0,application_id=42~hmac=5c2a4abcba3dca587577d74470099768abcd5b0d2b2ad6bf5c565a53a914bb0b	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
636	3470152971	Stop Playing With Me	133	5	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/0/3/0/103d2095452ca4f2b65bf176a9255e6f.mp3?hdnea=exp=1783589987~acl=/api/1/1/1/0/3/0/103d2095452ca4f2b65bf176a9255e6f.mp3*~data=user_id=0,application_id=42~hmac=059bbcaf867752fc63d6e384e64520bb9c740186bf76990ee24899fed288f4c1	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
632	3470152981	Ring Ring Ring	201	6	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/c/2/0/ac21737744b9601d90b08ce8efbcc09a.mp3?hdnea=exp=1783589982~acl=/api/1/1/a/c/2/0/ac21737744b9601d90b08ce8efbcc09a.mp3*~data=user_id=0,application_id=42~hmac=9230670958e4b2ed6d3ece1cd67cddba50df29cdcc5879a68bd5ad09e474707b	191	2026-07-09 09:24:43.580434	2026-07-09 09:24:47.172746
630	3470152991	Don't Tap That Glass / Tweakin'	222	7	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/7/0/0/770a5cd7c178b86b3f2b1be7fab1a8f2.mp3?hdnea=exp=1783589982~acl=/api/1/1/7/7/0/0/770a5cd7c178b86b3f2b1be7fab1a8f2.mp3*~data=user_id=0,application_id=42~hmac=b3b8f95f70440a16b2e3988b7e5b4d26cd187f398eaff64459eb026e2e97364d	191	2026-07-09 09:24:43.580434	2026-07-09 09:24:47.172746
637	3470153001	Don't You Worry Baby (feat. Madison McFerrin)	178	8	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/2/a/0/12a04906fa77dbd55abf1c49980a5a97.mp3?hdnea=exp=1783589987~acl=/api/1/1/1/2/a/0/12a04906fa77dbd55abf1c49980a5a97.mp3*~data=user_id=0,application_id=42~hmac=c1feb110275a3e6271ceede8d84860b92a4d8a70a3aa75aaf618b110b7cccd91	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
638	3470153011	I'll Take Care of You (feat. Yebba)	200	9	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/0/b/0/e0beedb4f7a7109cf8a541f49658ad6f.mp3?hdnea=exp=1783589987~acl=/api/1/1/e/0/b/0/e0beedb4f7a7109cf8a541f49658ad6f.mp3*~data=user_id=0,application_id=42~hmac=afd13c17fd556fff8e5ff91bcab6aeffd3951f140b9d3174a06d3a55ddd6ed87	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
639	3470153021	Tell Me What It Is	202	10	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/7/3/0/573f9ee8f143d26d5dd6815b54563ed2.mp3?hdnea=exp=1783589987~acl=/api/1/1/5/7/3/0/573f9ee8f143d26d5dd6815b54563ed2.mp3*~data=user_id=0,application_id=42~hmac=9b370de2534fe860c27d5808228eb633d64580df22650109fa68883442237fa9	191	2026-07-09 09:24:47.172746	2026-07-09 09:24:47.172746
641	3037360171	iPod Touch	156	\N	https://cdn-images.dzcdn.net/images/cover/c37155da3fc4304e892686e482446509/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/8/4/0/784b615f061265b197c241533b3fca2a.mp3?hdnea=exp=1783590266~acl=/api/1/1/7/8/4/0/784b615f061265b197c241533b3fca2a.mp3*~data=user_id=0,application_id=42~hmac=6bcc4f2c1e9886d7454f6b43763c2196e1a5aaba22f3527d4460dc5917d652d9	494	2026-07-09 09:29:28.013014	2026-07-09 09:29:28.013014
642	3681573302	ipodtouch	145	\N	https://cdn-images.dzcdn.net/images/cover/b9fa8ac8c15eac7e4aaab06692d1fe33/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/a/5/0/da59b99be149424f1e9da10f9427db81.mp3?hdnea=exp=1783590266~acl=/api/1/1/d/a/5/0/da59b99be149424f1e9da10f9427db81.mp3*~data=user_id=0,application_id=42~hmac=d30c7661f80cf3229c7406d22492f9d4988a79322905ca71865dcd8e44949e9d	495	2026-07-09 09:29:28.013014	2026-07-09 09:29:28.013014
643	118982540	iPod Touch	260	\N	https://cdn-images.dzcdn.net/images/cover/1c2e7df59aa5f631b068d2d1c9d4af08/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/e/f/0/4ef515166bbdb963a138101c3542f12c.mp3?hdnea=exp=1783590266~acl=/api/1/1/4/e/f/0/4ef515166bbdb963a138101c3542f12c.mp3*~data=user_id=0,application_id=42~hmac=76c228a1c147fe930a1d54dc7cc6cce09407d37b36c3ebfcd51a531e29bb1978	496	2026-07-09 09:29:28.013014	2026-07-09 09:29:28.013014
644	902495712	Funky Stuff	284	\N	https://cdn-images.dzcdn.net/images/cover/af00f0b9e81a3cad8e429cdc98978a79/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/3/3/0/5335d51bec86fede93ee6e538cc6a968.mp3?hdnea=exp=1783590266~acl=/api/1/1/5/3/3/0/5335d51bec86fede93ee6e538cc6a968.mp3*~data=user_id=0,application_id=42~hmac=eac90c33091440b20c7fe7b7b89e8a47d476a6808bcbc59da63de644f6e46a39	497	2026-07-09 09:29:28.013014	2026-07-09 09:29:28.013014
645	3444572991	London Song	195	1	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/0/2/0/c02ab5d737315bcdf8cf0bd72e0ca8c2.mp3?hdnea=exp=1783590297~acl=/api/1/1/c/0/2/0/c02ab5d737315bcdf8cf0bd72e0ca8c2.mp3*~data=user_id=0,application_id=42~hmac=a452b6bc0f485e68044cd8f2814f488a9ab52b4ae68ebaa9218c9846475bc6aa	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
640	3444573001	iPod Touch	196	2	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/b/0/0/5b0b218d5e36a6eab3b27bf64a900658.mp3?hdnea=exp=1783590266~acl=/api/1/1/5/b/0/0/5b0b218d5e36a6eab3b27bf64a900658.mp3*~data=user_id=0,application_id=42~hmac=fdd3c1a56e6c854c983c52a532e0014cbfa3def7210c99c75cf4950c5cb27061	493	2026-07-09 09:29:28.013014	2026-07-09 09:29:57.684474
646	3444573011	Fuck My Computer	190	3	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/4/d/0/04de35129fa73362d76c3e6398eb20d6.mp3?hdnea=exp=1783590297~acl=/api/1/1/0/4/d/0/04de35129fa73362d76c3e6398eb20d6.mp3*~data=user_id=0,application_id=42~hmac=426d9a931f221578863d3f929e288655d3f1dad082ad3075d46b6d993d5a3585	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
647	3444573021	CSIRAC	201	4	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/4/0/144580d278c0a51abda15bf4bcb5a249.mp3?hdnea=exp=1783590297~acl=/api/1/1/1/4/4/0/144580d278c0a51abda15bf4bcb5a249.mp3*~data=user_id=0,application_id=42~hmac=b96a1fbab4612a95afa310fe961baab487406f569a4a707fbdbfac07e94a8d5f	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
648	3444573031	Delete	231	5	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/5/d/0/05d238ac5d7ee047eda32cbf0ae634ae.mp3?hdnea=exp=1783590297~acl=/api/1/1/0/5/d/0/05d238ac5d7ee047eda32cbf0ae634ae.mp3*~data=user_id=0,application_id=42~hmac=1a9c06a73b038f323d4a77185ef082130f66f3e470919b985c09b0175254d900	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
649	3444573041	ฅ^•ﻌ•^ฅ	66	6	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/2/d/0/32d500c28e34503d46512def6bbd63df.mp3?hdnea=exp=1783590297~acl=/api/1/1/3/2/d/0/32d500c28e34503d46512def6bbd63df.mp3*~data=user_id=0,application_id=42~hmac=6e9cdd92d9634a5d09cfd030b35a1a6adb7593e8057d6e60c6885c4356fd4d36	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
650	3444573051	All I Am	182	7	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/e/0/0/9e097cbfd31b58b964603288e133ef01.mp3?hdnea=exp=1783590297~acl=/api/1/1/9/e/0/0/9e097cbfd31b58b964603288e133ef01.mp3*~data=user_id=0,application_id=42~hmac=3dd97383260613f5d22c92b02d3f9742f003c297a7ce1b3d058de83a61ca9756	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
651	3444573061	Infohazard	269	8	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/0/e/0/90e68e6773e1156fbf83b532f2c88f16.mp3?hdnea=exp=1783590297~acl=/api/1/1/9/0/e/0/90e68e6773e1156fbf83b532f2c88f16.mp3*~data=user_id=0,application_id=42~hmac=63ea34317206d032502426c0b09ac201cb9cb9693a5d26cdb4045a8e447ccd09	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
652	3444573071	Battery Death	198	9	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/3/d/0/93d986be88effa53957e08956eb70a02.mp3?hdnea=exp=1783590297~acl=/api/1/1/9/3/d/0/93d986be88effa53957e08956eb70a02.mp3*~data=user_id=0,application_id=42~hmac=729b533b70ab18e684dbb7531fa5d6932238eac768e75e78073a040c50a84e5a	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
653	3444573081	Sing Good	160	10	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/3/2/0/53205f9b70a87b7112abe63297bf4cf7.mp3?hdnea=exp=1783590297~acl=/api/1/1/5/3/2/0/53205f9b70a87b7112abe63297bf4cf7.mp3*~data=user_id=0,application_id=42~hmac=843205ae789f09f85f4c125b101534ca1c115ab3e3763230b54cfe588cf2e2ca	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
654	3444573091	It's You	169	11	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/c/5/0/8c595569ff330018061715533f290d29.mp3?hdnea=exp=1783590297~acl=/api/1/1/8/c/5/0/8c595569ff330018061715533f290d29.mp3*~data=user_id=0,application_id=42~hmac=0ebde082b53f0fe1674c61325f42186c8b064eac5a103f3d8d0339aacbefe3f0	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
655	3444573101	All At Once	326	12	https://cdn-images.dzcdn.net/images/cover/04dc7549927b479188a1af4092dc1e86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/6/0/5c6899e16dde83820c7fb8f0b339e4ef.mp3?hdnea=exp=1783590297~acl=/api/1/1/5/c/6/0/5c6899e16dde83820c7fb8f0b339e4ef.mp3*~data=user_id=0,application_id=42~hmac=1e5ec481b548e60f82f05b360216d528a9394bda3dbdcf214445038dfb51d75c	493	2026-07-09 09:29:57.684474	2026-07-09 09:29:57.684474
1004	79182453	Malencunia	221	\N	https://cdn-images.dzcdn.net/images/cover/a8bd2e4250a873580b00c6e8d74c0e98/1000x1000-000000-80-0-0.jpg	\N	628	2026-07-11 18:08:20.722733	2026-07-11 18:08:20.722733
1005	85904751	Ostatnia Nocka (2014 Remastered)	190	\N	https://cdn-images.dzcdn.net/images/cover/e14473922faec2d2774460027125a562/1000x1000-000000-80-0-0.jpg	\N	629	2026-07-11 18:08:20.722733	2026-07-11 18:08:20.722733
1006	85904743	Sługi Za Szlugi	196	\N	https://cdn-images.dzcdn.net/images/cover/e14473922faec2d2774460027125a562/1000x1000-000000-80-0-0.jpg	\N	629	2026-07-11 18:08:20.722733	2026-07-11 18:08:20.722733
1007	2470681691	Ostatnia nocka (Wersja 2012)	181	\N	https://cdn-images.dzcdn.net/images/cover/bb35c40d0a504b69ec4fd8a3180168ae/1000x1000-000000-80-0-0.jpg	\N	630	2026-07-11 18:08:20.722733	2026-07-11 18:08:20.722733
1008	410932212	Mam Coś Zaśpiewać O Cyrku	218	1	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1009	410932222	Absolutnie	223	2	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1010	410932232	Maraton Sopot - Puck	233	3	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1011	410932242	Żniwna Dziewczyna	221	4	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1012	410932252	Nowa jElita	141	5	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1013	410932262	Co By Tu Jeszcze	230	6	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1014	410932272	Szajba	197	7	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1015	410932282	Jeszcze W Zielone Gramy	261	8	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1016	410932292	W Co Się Bawić	285	9	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1017	410932302	Tupnął Książę	315	10	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1211	12235148	Stupid MF	144	2	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
656	2934378651	Diet Pepsi	169	\N	https://cdn-images.dzcdn.net/images/cover/ee890cf16d00c684be76b0087c7108c4/1000x1000-000000-80-0-0.jpg	\N	501	2026-07-09 09:51:03.401026	2026-07-09 09:51:03.401026
306	871124582	death bed (coffee for your head)	173	1	https://cdn-images.dzcdn.net/images/cover/85380bbb010f1b675c29ac06c6e343ea/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/2/0/0/b204de6fedc9a6f39bcbd53e345cca99.mp3?hdnea=exp=1777189156~acl=/api/1/1/b/2/0/0/b204de6fedc9a6f39bcbd53e345cca99.mp3*~data=user_id=0,application_id=42~hmac=e02dbeba03abf6aee06a4b81800cbab74f7d8d332e5970d9619ad48830b1e861	261	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
307	1641651592	the perfect pair	177	6	https://cdn-images.dzcdn.net/images/cover/61e1093dfaafa599e459ddf4c665e985/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/2/2/0/f22bbd60b96c8b24a330cdbb2a4f4b02.mp3?hdnea=exp=1777189156~acl=/api/1/1/f/2/2/0/f22bbd60b96c8b24a330cdbb2a4f4b02.mp3*~data=user_id=0,application_id=42~hmac=cbaf833e04c05ae7985329cb133f9dca333f5c6ef5496e3028704f36d39ae7e5	262	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
308	3880356121	All I Did Was Dream of You	223	1	https://cdn-images.dzcdn.net/images/cover/4e3e287293e593dac462146d3c92afda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/5/a/0/d5a2aca6656cf38bbf7f26208f2b3016.mp3?hdnea=exp=1777189156~acl=/api/1/1/d/5/a/0/d5a2aca6656cf38bbf7f26208f2b3016.mp3*~data=user_id=0,application_id=42~hmac=91e94150d360d5c82cbb669873b60ee5b69257bda1ac5b635530b8a8d8a6c818	263	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
309	594582722	Tired	199	2	https://cdn-images.dzcdn.net/images/cover/30effb95bd2f00d0637efa5d310ae8aa/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/7/0/0/270ab72c68aa31397211e5e48a8dc267.mp3?hdnea=exp=1777189156~acl=/api/1/1/2/7/0/0/270ab72c68aa31397211e5e48a8dc267.mp3*~data=user_id=0,application_id=42~hmac=97a5c1b6cb573a0415af359edba2cfadb60d7ba762bdec467046d818fb60cfa9	264	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
310	2758747991	Take A Bite	158	1	https://cdn-images.dzcdn.net/images/cover/1ca27b208e5b2ace3f055139f1cae5a6/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/1/4/0/414f90022bc9ca3b3394ff91018133be.mp3?hdnea=exp=1777189156~acl=/api/1/1/4/1/4/0/414f90022bc9ca3b3394ff91018133be.mp3*~data=user_id=0,application_id=42~hmac=e133e56ed780d985e4069f4b0395ecebb04ab4f88e47e282dcbb79d1000d78c0	265	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
311	37027991	Beauty And A Beat	228	10	https://cdn-images.dzcdn.net/images/cover/312ece7b31fb86c7a13afd757e99437c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/1/c/0/a1c35032aab8a465a73991e05ac30db6.mp3?hdnea=exp=1777551987~acl=/api/1/1/a/1/c/0/a1c35032aab8a465a73991e05ac30db6.mp3*~data=user_id=0,application_id=42~hmac=f8f6f56a12503c6129ec28c639f6af75bed138ef8705202eb2113f423c2e0ecf	267	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
312	3454558661	DAISIES	176	2	https://cdn-images.dzcdn.net/images/cover/d0f4411377c5b6a81cdf18d9587a7641/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/8/0/5c8b19ee997114e357b892f062635d60.mp3?hdnea=exp=1777551987~acl=/api/1/1/5/c/8/0/5c8b19ee997114e357b892f062635d60.mp3*~data=user_id=0,application_id=42~hmac=5d37468f0d5f09935c7da10b514d3b669fe164130184d5f5e63e9e2e3622ea77	268	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
313	3541914121	SPEED DEMON	212	1	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/b/1/0/ab119e1f99c617faa905adecb4edd5db.mp3?hdnea=exp=1777551987~acl=/api/1/1/a/b/1/0/ab119e1f99c617faa905adecb4edd5db.mp3*~data=user_id=0,application_id=42~hmac=be03479ea00663f3385fc4b5751e45d2bf0f6222ff271bf3a7c9d5d430f469aa	269	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
314	1425844092	STAY	140	1	https://cdn-images.dzcdn.net/images/cover/dd6fe7fa9267185c4b835bd4f155d1d2/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/2/7/0/c27d817565b9df8ab6393bb8202b58b9.mp3?hdnea=exp=1777551987~acl=/api/1/1/c/2/7/0/c27d817565b9df8ab6393bb8202b58b9.mp3*~data=user_id=0,application_id=42~hmac=beda137b4e03eac1f43a7b02298310235a882311c8b0173226be133d5ad1f763	270	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
657	3501151531	Diet Pepsi (Live from 2025 Las Culturistas Culture Awards)	194	\N	https://cdn-images.dzcdn.net/images/cover/de2e00a34efc9a5caf3a4d30ee40124c/1000x1000-000000-80-0-0.jpg	\N	502	2026-07-09 09:51:03.401026	2026-07-09 09:51:03.401026
658	3398434631	Diet Pepsi (Live at Sirius XMU)	165	\N	https://cdn-images.dzcdn.net/images/cover/626783ce13fd445f8eb4982965cffe5d/1000x1000-000000-80-0-0.jpg	\N	503	2026-07-09 09:51:03.401026	2026-07-09 09:51:03.401026
659	3297309751	Diet Pepsi	146	\N	https://cdn-images.dzcdn.net/images/cover/220c9d6dcd1ffcc7caa46afc9eaa30a0/1000x1000-000000-80-0-0.jpg	\N	504	2026-07-09 09:51:03.401026	2026-07-09 09:51:03.401026
660	3165517071	Diet Pepsi	149	\N	https://cdn-images.dzcdn.net/images/cover/15b46d585139fcee4f43e4647824a713/1000x1000-000000-80-0-0.jpg	\N	505	2026-07-09 09:51:03.401026	2026-07-09 09:51:03.401026
661	3513670841	Carousel	199	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	\N	511	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
662	3513670881	Forget-Me-Not	246	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	\N	511	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
663	3939046321	Clockwork	150	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	\N	311	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
664	3939046451	Sabotage	214	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	\N	311	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
665	3513670851	Silver Lining	197	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	\N	511	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
666	3513670871	Cuckoo Ballet (Interlude)	219	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	\N	511	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
667	2309254555	California and Me	216	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	\N	313	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
668	3939046351	Castle in Hollywood	153	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	\N	311	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
669	1899597987	Fragile	241	\N	https://cdn-images.dzcdn.net/images/cover/ce4203bf02c22e66eaf2a221fb844c87/1000x1000-000000-80-0-0.jpg	\N	392	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
670	3939046381	Too Little, Too Late	233	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	\N	311	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
671	2631148962	Lovesick	225	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	\N	312	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
672	3939046421	A Cautionary Tale	256	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	\N	311	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
673	2816279752	Bewitched	246	\N	https://cdn-images.dzcdn.net/images/cover/6f35ff039de550c8f8c9b678002a6f96/1000x1000-000000-80-0-0.jpg	\N	395	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
674	2309254515	Haunted	200	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	\N	313	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
675	2309254615	Letter To My 13 Year Old Self	262	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	\N	313	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
676	1930038277	Someone New	198	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	\N	382	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
677	3939046551	I'll Forget About You (In Time)	252	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	\N	311	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
678	3041651671	Santa Baby	182	\N	https://cdn-images.dzcdn.net/images/cover/0706de5a7d9c3ceacf17ccb31091ae1f/1000x1000-000000-80-0-0.jpg	\N	375	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
679	3513670931	Clean Air	155	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	\N	511	2026-07-09 11:11:16.587907	2026-07-09 11:11:16.587907
680	3774200692	Колискова Для Лялькових Немовлят	381	1	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
681	3774200702	Фокстрот Льотчик	314	2	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
682	3774200722	Нудьга	289	4	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
683	3774200732	Хата Скраю Села	305	5	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
684	3774200752	Між Землею і Небом	232	7	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
685	3774200762	Лист Додому	185	8	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
686	3774200772	Не Дала Земля	231	9	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
687	3774200782	Пісня Про Жидів	188	10	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
688	3774200792	Серед Тіней	248	11	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
689	3774200802	Остання Пісн	293	12	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
690	3774200812	Відрізана Голова	205	13	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
691	3774200822	Під Облачком	237	14	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
692	3774200832	Змія 2004	259	15	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	\N	251	2026-07-09 11:23:11.322984	2026-07-09 11:23:11.322984
693	3352616011	Тільки мрії	171	\N	https://cdn-images.dzcdn.net/images/cover/66d0fe79881ee5bd4b59e37f288e1646/1000x1000-000000-80-0-0.jpg	\N	512	2026-07-09 11:26:17.881044	2026-07-09 11:26:17.881044
694	662208222	Тільки мій	212	\N	https://cdn-images.dzcdn.net/images/cover/a7832c3d30b1b9a4190821c83abafb34/1000x1000-000000-80-0-0.jpg	\N	513	2026-07-09 11:26:17.881044	2026-07-09 11:26:17.881044
695	2883117342	Чому ти тільки в мріях	145	\N	https://cdn-images.dzcdn.net/images/cover/5b11cc14cbe6b9d0c9617296a8d136b6/1000x1000-000000-80-0-0.jpg	\N	514	2026-07-09 11:26:17.881044	2026-07-09 11:26:17.881044
696	3875892111	Тільки мрії мають крила	209	\N	https://cdn-images.dzcdn.net/images/cover/211e20b8cb0414367b975b38f31911a9/1000x1000-000000-80-0-0.jpg	\N	515	2026-07-09 11:26:17.881044	2026-07-09 11:26:17.881044
1018	410932312	Ballada O Dwóch Koniach	188	11	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1019	410932322	Ballada O Szewcu Dratewce	411	12	https://cdn-images.dzcdn.net/images/cover/2c347e49e5d970eb360969a6cbd9dd8e/1000x1000-000000-80-0-0.jpg	\N	631	2026-07-11 18:08:37.677484	2026-07-11 18:08:37.677484
1020	85904763	Gdzie Są Przyjaciele Moi? (2014 Remastered)	232	\N	https://cdn-images.dzcdn.net/images/cover/e14473922faec2d2774460027125a562/1000x1000-000000-80-0-0.jpg	\N	629	2026-07-11 18:09:25.255761	2026-07-11 18:09:25.255761
1021	555955332	Fajnie	218	\N	https://cdn-images.dzcdn.net/images/cover/46d7d0bffda750963caf5ce9eff0fea0/1000x1000-000000-80-0-0.jpg	\N	634	2026-07-11 18:09:25.255761	2026-07-11 18:09:25.255761
1071	116348454	Something (Remastered 2009)	181	2	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1072	116348456	Maxwell's Silver Hammer (Remastered 2009)	206	3	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1073	116348458	Oh! Darling (Remastered 2009)	207	4	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1074	116348460	Octopus's Garden (Remastered 2009)	169	5	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1075	116348462	I Want You (She's So Heavy) (Remastered 2009)	465	6	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
556	116348464	Here Comes The Sun (Remastered 2009)	184	7	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/7/0/0/d702cdd1d89e261b22fc740f854c1a0f.mp3?hdnea=exp=1783507964~acl=/api/1/1/d/7/0/0/d702cdd1d89e261b22fc740f854c1a0f.mp3*~data=user_id=0,application_id=42~hmac=11b8398db1430d15fab7f584d9c4cc598e0de78435d06a0fc42a5be52bd431d9	438	2026-07-08 10:37:45.121238	2026-07-12 08:33:19.902048
1076	116348466	Because (Remastered 2009)	165	8	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1077	116348468	You Never Give Me Your Money (Remastered 2009)	242	9	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
697	4040103591	Summertime (2026 Remaster)	245	\N	https://cdn-images.dzcdn.net/images/cover/d841606fe5331765b5305ea497e2e35f/1000x1000-000000-80-0-0.jpg	\N	517	2026-07-09 11:44:00.668409	2026-07-09 11:44:00.668409
698	676590	Teenagers	161	\N	https://cdn-images.dzcdn.net/images/cover/0f23ab7de2b53c5298044ef1de148c50/1000x1000-000000-80-0-0.jpg	\N	518	2026-07-09 11:44:00.668409	2026-07-09 11:44:00.668409
699	676573	Welcome to the Black Parade	311	\N	https://cdn-images.dzcdn.net/images/cover/0f23ab7de2b53c5298044ef1de148c50/1000x1000-000000-80-0-0.jpg	\N	518	2026-07-09 11:44:00.668409	2026-07-09 11:44:00.668409
700	676594	Famous Last Words	299	\N	https://cdn-images.dzcdn.net/images/cover/0f23ab7de2b53c5298044ef1de148c50/1000x1000-000000-80-0-0.jpg	\N	518	2026-07-09 11:44:00.668409	2026-07-09 11:44:00.668409
701	3387454721	Fame is a Gun	183	\N	https://cdn-images.dzcdn.net/images/cover/5f8734a22538b6cc1312491b3c9b586d/1000x1000-000000-80-0-0.jpg	\N	521	2026-07-09 12:07:25.229252	2026-07-09 12:07:25.229252
702	3326208711	Headphones On	240	\N	https://cdn-images.dzcdn.net/images/cover/b41ebd8d73d8de9d58df3caef10625fe/1000x1000-000000-80-0-0.jpg	\N	522	2026-07-09 12:07:25.229252	2026-07-09 12:07:25.229252
704	3055752281	Aquamarine	163	\N	https://cdn-images.dzcdn.net/images/cover/8db5fe3314c1b8fa9510a7d3eaa5f778/1000x1000-000000-80-0-0.jpg	\N	524	2026-07-09 12:07:25.229252	2026-07-09 12:07:25.229252
705	3397850481	New York	154	1	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
706	3397850491	Diet Pepsi	169	2	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
707	3397850501	Money is Everything	122	3	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
708	3397850511	Aquamarine	163	4	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
709	3397850521	Lost & Found	48	5	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
703	3397850531	High Fashion	198	6	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:25.229252	2026-07-09 12:07:27.217016
710	3397850541	Summer Forever	228	7	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
711	3397850551	In The Rain	214	8	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
712	3397850561	Fame is a Gun	183	9	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
713	3397850571	Times Like These	234	10	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
714	3397850581	Life's No Fun Through Clear Waters	57	11	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
715	3397850591	Headphones On	240	12	https://cdn-images.dzcdn.net/images/cover/6925f0e9f34b95ce5781480b249fd86d/1000x1000-000000-80-0-0.jpg	\N	523	2026-07-09 12:07:27.217016	2026-07-09 12:07:27.217016
1022	2570360822	Місто розбитих надій	146	\N	https://cdn-images.dzcdn.net/images/cover/a82d88dcacab8a879a96f7ec8f330811/1000x1000-000000-80-0-0.jpg	\N	233	2026-07-12 08:22:42.45699	2026-07-12 08:22:42.45699
1023	4057792831	Пострадянська доба	160	\N	https://cdn-images.dzcdn.net/images/cover/f598fba52bb7095826908acbd7e8bb8d/1000x1000-000000-80-0-0.jpg	\N	649	2026-07-12 08:22:42.45699	2026-07-12 08:22:42.45699
1024	1270715612	Zabierz tę miłość (Storytel "Random")	249	\N	https://cdn-images.dzcdn.net/images/cover/a088f234fc54ab8f2e8b91b61f3d95da/1000x1000-000000-80-0-0.jpg	\N	678	2026-07-12 08:22:58.433871	2026-07-12 08:22:58.433871
1025	3979034911	Z Tobą być (love u like that)	160	\N	https://cdn-images.dzcdn.net/images/cover/3f3d8b5e845ac6ef3a13e86294fdfd92/1000x1000-000000-80-0-0.jpg	\N	679	2026-07-12 08:22:58.433871	2026-07-12 08:22:58.433871
1026	651455922	Fight Fire With Fire	245	\N	https://cdn-images.dzcdn.net/images/cover/ffb04a3bc4868f4bc2499e0da96b3501/1000x1000-000000-80-0-0.jpg	\N	680	2026-07-12 08:22:58.433871	2026-07-12 08:22:58.433871
469	4315309	The View From The Afternoon	222	1	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/2/e/0/d2e923a328a2949826ed3934b75589ff.mp3?hdnea=exp=1783447404~acl=/api/1/1/d/2/e/0/d2e923a328a2949826ed3934b75589ff.mp3*~data=user_id=0,application_id=42~hmac=aa927534ed6f9498598cc68ceff23dad18d0da400b291efddee005e357abf9dc	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
470	4315312	Dancing Shoes	141	4	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/3/9/0/539215bf3c1d09e9c1e02742b2fd65bd.mp3?hdnea=exp=1783447404~acl=/api/1/1/5/3/9/0/539215bf3c1d09e9c1e02742b2fd65bd.mp3*~data=user_id=0,application_id=42~hmac=9dbb43cc56aa2867fa441182948237abe1e39280bac75001ad9290b55ff3413c	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
471	4315313	You Probably Couldn't See For The Lights But You Were Staring Straight At Me	130	5	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/f/a/0/7faf609e17d117ee64d6822f7f6b4b73.mp3?hdnea=exp=1783447404~acl=/api/1/1/7/f/a/0/7faf609e17d117ee64d6822f7f6b4b73.mp3*~data=user_id=0,application_id=42~hmac=594d0e1aaef8e46b1c79ff2c49c1b7e169faa2706c63c08d32af6a2b792e182f	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
472	4315314	Still Take You Home	173	6	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/5/a/0/a5a974d3b2abfe6333bb489dab641e4e.mp3?hdnea=exp=1783447404~acl=/api/1/1/a/5/a/0/a5a974d3b2abfe6333bb489dab641e4e.mp3*~data=user_id=0,application_id=42~hmac=e3491bd9058ae75cbfbbde076080d00748d27eb36c08270d8b06d2625f52ef5b	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
473	4315316	Red Light Indicates Doors Are Secured	143	8	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/9/b/0/b9bd429cecbf66166d25acc2777faa60.mp3?hdnea=exp=1783447404~acl=/api/1/1/b/9/b/0/b9bd429cecbf66166d25acc2777faa60.mp3*~data=user_id=0,application_id=42~hmac=acd23210fb68a78d814c55d6473711655800cf07da7c01eb09a7fbde3ace7f1f	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
474	4315318	Perhaps Vampires Is A Bit Strong But…	268	10	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/7/e/0/57eace7efac96e4f368e65f82a0a5770.mp3?hdnea=exp=1783447404~acl=/api/1/1/5/7/e/0/57eace7efac96e4f368e65f82a0a5770.mp3*~data=user_id=0,application_id=42~hmac=a647d8000e11dca8c5df7eefc1ebb8d68be70e88d6a3fb9d645b686110b4e6e9	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
475	4315319	When The Sun Goes Down	202	11	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/f/6/0/ff639e85a24b793f1fc05d6a037809b1.mp3?hdnea=exp=1783447404~acl=/api/1/1/f/f/6/0/ff639e85a24b793f1fc05d6a037809b1.mp3*~data=user_id=0,application_id=42~hmac=329b7228407889e34909a44c1f7a9a93b946de18d96b894454ff858fa5400359	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
476	4315320	From The Ritz To The Rubble	193	12	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/8/4/0/b841d08586960f786ed9c1ac56071e19.mp3?hdnea=exp=1783447404~acl=/api/1/1/b/8/4/0/b841d08586960f786ed9c1ac56071e19.mp3*~data=user_id=0,application_id=42~hmac=a2897853308b1b9d17e928141dc02f16ca713503f7fba60a1be0093649b8f200	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
477	4315321	A Certain Romance	331	13	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/6/0/0/2605aa8d5279dc6edc91af9a020dd877.mp3?hdnea=exp=1783447404~acl=/api/1/1/2/6/0/0/2605aa8d5279dc6edc91af9a020dd877.mp3*~data=user_id=0,application_id=42~hmac=796f38333fd96f8b67afb4c48664203ec7ef3560f2f09eb31c6d07ae0a1a3f5a	151	2026-07-07 17:48:24.868306	2026-07-09 12:24:03.394153
478	2859555562	3S`	150	1	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/5/7/0/257afd6fdeacd5c5a3d0acb59dcc4bc1.mp3?hdnea=exp=1783447468~acl=/api/1/1/2/5/7/0/257afd6fdeacd5c5a3d0acb59dcc4bc1.mp3*~data=user_id=0,application_id=42~hmac=8ed8eba90a39c3675bf88e7ab134545141abf982b64bd489e21071277e20cae8	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
479	2859555572	Sex for Homework	194	2	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/7/6/0/076ed81fc811fcba7ba81d3beac1b305.mp3?hdnea=exp=1783447468~acl=/api/1/1/0/7/6/0/076ed81fc811fcba7ba81d3beac1b305.mp3*~data=user_id=0,application_id=42~hmac=c9f98295d00da74843aad90cae504bba654edd9411d5e761b8b5b41de60ddc53	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
480	2859555582	Eat Those Words	217	3	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/b/6/0/4b6cbfb434f79b1d56b10b1778e0305a.mp3?hdnea=exp=1783447468~acl=/api/1/1/4/b/6/0/4b6cbfb434f79b1d56b10b1778e0305a.mp3*~data=user_id=0,application_id=42~hmac=3a324c6b25eba739df9ed291e0e961ca4dcd965d8513265fa0136e7f5e76e9be	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
481	2859555602	Frying Pan	168	5	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/1/b/0/b1bdf75d21c043415b08618e76a2f90f.mp3?hdnea=exp=1783447468~acl=/api/1/1/b/1/b/0/b1bdf75d21c043415b08618e76a2f90f.mp3*~data=user_id=0,application_id=42~hmac=8895e963e5f16716d734feae0e78feccc51a93fac27d4136b7ba0579ba9be9e5	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
482	2859555612	Prove Me Wrong	239	6	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/e/0/0/4e05897a020644d061fdceacc805d0d6.mp3?hdnea=exp=1783447468~acl=/api/1/1/4/e/0/0/4e05897a020644d061fdceacc805d0d6.mp3*~data=user_id=0,application_id=42~hmac=f4c329f976491e58862f08fd0fbe5674218ba9b2210a112d40dba6f761017823	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
483	2859555622	Rip Off	106	7	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/d/0/14dddc9afa9ffc75601fbd2182f05669.mp3?hdnea=exp=1783447468~acl=/api/1/1/1/4/d/0/14dddc9afa9ffc75601fbd2182f05669.mp3*~data=user_id=0,application_id=42~hmac=531222138f2b99c9cdce6ea0f69f5f58f9d10ce316f3d5918bb0ae72d0a0cd5f	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
484	2859555632	Disappoint	150	8	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/9/b/0/89b0cc072f42a2ea7b1e6d3341b8beb1.mp3?hdnea=exp=1783447468~acl=/api/1/1/8/9/b/0/89b0cc072f42a2ea7b1e6d3341b8beb1.mp3*~data=user_id=0,application_id=42~hmac=cb346b9441f29aa8c4ac0707d39a240e438905d60e3ba7d8ed911d43aad8f714	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
485	2859555642	Last Gay Song	137	9	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/d/2/0/fd2bc780a63cb739873826e168ebcf42.mp3?hdnea=exp=1783447468~acl=/api/1/1/f/d/2/0/fd2bc780a63cb739873826e168ebcf42.mp3*~data=user_id=0,application_id=42~hmac=7e44ebf48ccd3150d032bf1ce021d1ef150088a17e402e61c83b46d413671030	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
486	2859555652	GENIUZ	150	10	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/8/4/0/d8486bf78452032b9c21a2491478abf7.mp3?hdnea=exp=1783447468~acl=/api/1/1/d/8/4/0/d8486bf78452032b9c21a2491478abf7.mp3*~data=user_id=0,application_id=42~hmac=0f897b36bf64b15fd51674595d4612482df430fd6f07d18f3824e90db6cfc597	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
487	2859555662	My World	199	11	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/2/c/0/a2c9e9dbf24a6437db767f284ee2fdca.mp3?hdnea=exp=1783447468~acl=/api/1/1/a/2/c/0/a2c9e9dbf24a6437db767f284ee2fdca.mp3*~data=user_id=0,application_id=42~hmac=1ee83482014345e571a438dcff6ee7d290c2742d135627d204980f40b3c32abf	186	2026-07-07 17:49:28.959462	2026-07-09 12:24:03.394153
490	3541914131	BETTER MAN	169	2	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/0/4/0/304baf0c6be08a55202e92a269ca78aa.mp3?hdnea=exp=1783448156~acl=/api/1/1/3/0/4/0/304baf0c6be08a55202e92a269ca78aa.mp3*~data=user_id=0,application_id=42~hmac=03d95af7f474b76969e52a96e04f5c748f106efd8b0575a8ae44148b15ec41c3	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
491	3541914141	LOVE SONG	172	3	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/4/e/0/b4e3cab138d8760debecf9d40bae3ec1.mp3?hdnea=exp=1783448156~acl=/api/1/1/b/4/e/0/b4e3cab138d8760debecf9d40bae3ec1.mp3*~data=user_id=0,application_id=42~hmac=c2eea03a969eb619dc30176d71877e3a68e8fdcca87b2d1e4a220c325891a3ad	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
492	3541914151	I DO	224	4	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/5/8/0/c589558678fc6dcffa9baa586fe5dfa3.mp3?hdnea=exp=1783448156~acl=/api/1/1/c/5/8/0/c589558678fc6dcffa9baa586fe5dfa3.mp3*~data=user_id=0,application_id=42~hmac=f90382a53f7849a2653bf9b4c45cd54833e727d8048836c54bacd8775bc3561f	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
493	3541914161	I THINK YOU'RE SPECIAL	164	5	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/6/5/0/d653b2f8eb0298babb05beb9ba623883.mp3?hdnea=exp=1783448156~acl=/api/1/1/d/6/5/0/d653b2f8eb0298babb05beb9ba623883.mp3*~data=user_id=0,application_id=42~hmac=6111d1fa8fefffede864c3ab28df73994ad733ef404eb68c3e2411d30c8a4093	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
494	3541914171	MOTHER IN YOU	206	6	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/1/a/0/a1a29ab255593e7cac246303a7b9042d.mp3?hdnea=exp=1783448156~acl=/api/1/1/a/1/a/0/a1a29ab255593e7cac246303a7b9042d.mp3*~data=user_id=0,application_id=42~hmac=0e873c0fb1954759f4b0eb79504bbd1f4876787f6abb14ef39ee93c8c6cde53f	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
495	3541914181	WITCHYA	163	7	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/4/b/0/74b8243d83352c9cef252b76aa5254ce.mp3?hdnea=exp=1783448156~acl=/api/1/1/7/4/b/0/74b8243d83352c9cef252b76aa5254ce.mp3*~data=user_id=0,application_id=42~hmac=0975c05d03e692995db26455d2d4fad364a5ac1a05671938b53b2b62078951a8	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
496	3541914191	EYE CANDY	229	8	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/0/7/0/a07804e262e940e96198abc0a65afb95.mp3?hdnea=exp=1783448156~acl=/api/1/1/a/0/7/0/a07804e262e940e96198abc0a65afb95.mp3*~data=user_id=0,application_id=42~hmac=6ed241c25acab759baad84a546ee743489eaa88df733e673b552222ff1dec5af	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
497	3541914201	DON'T WANNA	168	9	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/6/b/0/26b427bfac42c72b1aeadd0daf41cf4f.mp3?hdnea=exp=1783448156~acl=/api/1/1/2/6/b/0/26b427bfac42c72b1aeadd0daf41cf4f.mp3*~data=user_id=0,application_id=42~hmac=7d3fc8e463a74a83234fb2e6ee101c89ef2babb1118beffcde116c104fa567e9	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
498	3541914211	BAD HONEY	155	10	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/f/9/0/3f987a97e7c21ebb198c0d0cfdcb00d8.mp3?hdnea=exp=1783448156~acl=/api/1/1/3/f/9/0/3f987a97e7c21ebb198c0d0cfdcb00d8.mp3*~data=user_id=0,application_id=42~hmac=dfb43e2565b903f688bca6a442409178eb686d8ebe3776f702ec47d4072e5d73	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
499	3541914221	NEED IT	219	11	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/6/9/0/3690c069ee281b93c0636eafeed93a8e.mp3?hdnea=exp=1783448156~acl=/api/1/1/3/6/9/0/3690c069ee281b93c0636eafeed93a8e.mp3*~data=user_id=0,application_id=42~hmac=dc7a53fa4e417307dca605c458d77901277cd6fc5595d70c6562f6ca5cd84f6d	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
500	3541914231	OH MAN	192	12	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/9/5/0/b9589d96fc9ac8b4c761fee5d09e7a2b.mp3?hdnea=exp=1783448156~acl=/api/1/1/b/9/5/0/b9589d96fc9ac8b4c761fee5d09e7a2b.mp3*~data=user_id=0,application_id=42~hmac=00e89cc51909186e5797965cf8770bbdfdfaa44afad664ce171c45525b27e108	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
501	3541914241	POPPIN’ MY S***	126	13	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/6/e/0/d6eed98b61b9875a521bf3903e0b22ce.mp3?hdnea=exp=1783448156~acl=/api/1/1/d/6/e/0/d6eed98b61b9875a521bf3903e0b22ce.mp3*~data=user_id=0,application_id=42~hmac=0446a7ea2dbd4154b846d5facbb499ef24adf594d02edaac0459fcf0162cf529	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
502	3541914251	ALL THE WAY	200	14	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/7/0/0/c70d0e413cfc69f7e21d6471da3759fc.mp3?hdnea=exp=1783448156~acl=/api/1/1/c/7/0/0/c70d0e413cfc69f7e21d6471da3759fc.mp3*~data=user_id=0,application_id=42~hmac=51ae8434e222dd5cc18a7e80249f5df79afb774d8d0657a8a1c8c33ce03112bb	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
503	3541914261	PETTING ZOO	198	15	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/9/c/0/59c75da95180bb1103a3ded9aab15514.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/9/c/0/59c75da95180bb1103a3ded9aab15514.mp3*~data=user_id=0,application_id=42~hmac=6ae6a30080b4a78c4972b52c2f9c4d4df35fcabc8c0b4af683c0b87bde49453f	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
504	3541914271	MOVING FAST	203	16	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/b/0/0/fb0bfacbc02a4ecb0794a268a4729fae.mp3?hdnea=exp=1783448156~acl=/api/1/1/f/b/0/0/fb0bfacbc02a4ecb0794a268a4729fae.mp3*~data=user_id=0,application_id=42~hmac=fa1d5a4504b00022524a4c630578635076ef71d205cb18450f9cd9adf06cf24c	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
505	3541914281	SAFE SPACE	194	17	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/0/0/0/c0061887e390baa22d65b3add616e642.mp3?hdnea=exp=1783448156~acl=/api/1/1/c/0/0/0/c0061887e390baa22d65b3add616e642.mp3*~data=user_id=0,application_id=42~hmac=41ec67a73bcaac26747e1c523107ae21d74fb15a9961ccad7ef46e668f7280b5	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
506	3541914291	LYIN'	188	18	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/8/d/0/88d5d24315afdd332427831a073c5076.mp3?hdnea=exp=1783448156~acl=/api/1/1/8/8/d/0/88d5d24315afdd332427831a073c5076.mp3*~data=user_id=0,application_id=42~hmac=8e605d97782a1294fac250dc850a20188c942a7ece1670ad1254b9e622d03f40	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
507	3541914301	DOTTED LINE	146	19	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/4/e/0/84e74c37f581a5f170c7205cd36d06c9.mp3?hdnea=exp=1783448156~acl=/api/1/1/8/4/e/0/84e74c37f581a5f170c7205cd36d06c9.mp3*~data=user_id=0,application_id=42~hmac=299149d7d6e8b892a41d5b434fbdb77fff316191dcbc70e5e07b87b3d335d0e6	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
508	3541914311	OPEN UP YOUR HEART	215	20	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/b/c/0/5bcd7e45671e20ecb259dbfea2889286.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/b/c/0/5bcd7e45671e20ecb259dbfea2889286.mp3*~data=user_id=0,application_id=42~hmac=7dcf4d1ba34f21f33e0fe6fe50d4502d2ee67840fe7e2c20eba7a90b723c4878	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
509	3541914321	WHEN IT'S OVER	156	21	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/9/5/0/c9563896c64c680316a15652dd8b2300.mp3?hdnea=exp=1783448156~acl=/api/1/1/c/9/5/0/c9563896c64c680316a15652dd8b2300.mp3*~data=user_id=0,application_id=42~hmac=b909dbc6c75084032fc2bceb0249b914793e9bf89175d82592d0cfbc14b14259	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
510	3541914331	EVERYTHING HALLELUJAH	248	22	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/d/1/0/dd16f90fcae358c1da5b534525a77398.mp3?hdnea=exp=1783448156~acl=/api/1/1/d/d/1/0/dd16f90fcae358c1da5b534525a77398.mp3*~data=user_id=0,application_id=42~hmac=e4898296944b21ae0fec981678622bf3d76758c8c8228f88d89d9542c7d94941	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
511	3541914341	STORY OF GOD	464	23	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/3/e/0/53eb581f8ee4e20b3d775a6470217e58.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/3/e/0/53eb581f8ee4e20b3d775a6470217e58.mp3*~data=user_id=0,application_id=42~hmac=2e55aa01f4be2951f0b791950b7a6b294da53712e0aee925c8aa2cb50094468d	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
512	3541914351	ALL I CAN TAKE	248	1	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/d/4/0/5d4e17af01b5437d865f1786001969dd.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/d/4/0/5d4e17af01b5437d865f1786001969dd.mp3*~data=user_id=0,application_id=42~hmac=5d75721ab2c5496ad9af6994103e9eefce26b3b56948bbc81c615c25ced8536b	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
1111	2761249741	WORK	201	\N	https://cdn-images.dzcdn.net/images/cover/842b6981905706f21b1411801714e5f3/1000x1000-000000-80-0-0.jpg	\N	721	2026-07-13 09:32:59.466122	2026-07-13 09:32:59.466122
316	103791660	No Other Heart	173	3	https://cdn-images.dzcdn.net/images/cover/a8cc3d9a142cd0119c42eb1aafc974b9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/c/b/0/bcb46454d7a223291153f5268e500027.mp3?hdnea=exp=1780502227~acl=/api/1/1/b/c/b/0/bcb46454d7a223291153f5268e500027.mp3*~data=user_id=0,application_id=42~hmac=12b4bebdc5db817111d713345136ced1e9b59b327d520fa139a71eab90554d2a	275	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
317	347015811	Still Beating	182	6	https://cdn-images.dzcdn.net/images/cover/5e7b8670b572a110d4453e6ac94421d8/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/3/1/0/a31f52873315795ac5f38cd98e3e962e.mp3?hdnea=exp=1780502227~acl=/api/1/1/a/3/1/0/a31f52873315795ac5f38cd98e3e962e.mp3*~data=user_id=0,application_id=42~hmac=184c9dc1d1c58bd9453fd133398afaa3705717b86b26b21345b8226926a365ac	172	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
318	2238153377	From The Start	169	1	https://cdn-images.dzcdn.net/images/cover/497515366a19189203786c2315eb6609/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/e/5/0/6e5ce0e8e1a654857daed25913ae1fcf.mp3?hdnea=exp=1780502248~acl=/api/1/1/6/e/5/0/6e5ce0e8e1a654857daed25913ae1fcf.mp3*~data=user_id=0,application_id=42~hmac=219f35ba7639dc74aa128dfd420595e237868243690339e73e572fcf3802ee86	308	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
319	3513670721	Mr. Eclectic	155	12	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/e/e/0/9eed933c912c97cc8ee2069851293f71.mp3?hdnea=exp=1780502248~acl=/api/1/1/9/e/e/0/9eed933c912c97cc8ee2069851293f71.mp3*~data=user_id=0,application_id=42~hmac=978fdfd9e31ff0554bd04e1eea38a91ca7c388e3365741a2a4a438aa891b6583	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
320	3401301081	Lover Girl	164	1	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/2/e/0/02e2659d9fdc3fd7f4c862b7e32c356f.mp3?hdnea=exp=1780502248~acl=/api/1/1/0/2/e/0/02e2659d9fdc3fd7f4c862b7e32c356f.mp3*~data=user_id=0,application_id=42~hmac=afc9268bea6d5b3b9d7df2121dac4b5cd79287d8113aebbb8de52ae933d8d9d7	310	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
321	3939046471	Madwoman	239	16	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/9/7/0/2971fe82e535231a680dbc98421a3097.mp3?hdnea=exp=1780502248~acl=/api/1/1/2/9/7/0/2971fe82e535231a680dbc98421a3097.mp3*~data=user_id=0,application_id=42~hmac=3c530147420fbc969c0b7065fa87c35c17f1a8014e4b4bfcb1c7892abc22ef91	311	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
322	2631149052	Bored	213	15	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/7/b/0/c7b7490b07da01c401a803e7f23771d8.mp3?hdnea=exp=1780502248~acl=/api/1/1/c/7/b/0/c7b7490b07da01c401a803e7f23771d8.mp3*~data=user_id=0,application_id=42~hmac=00742baa7061cb359b95c82689df7b90af0e65edf16dae6f326e76857adb99b9	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
323	1942565507	Valentine	168	3	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/0/0/0/100775c0aee654254f31cc80dd4dafe7.mp3?hdnea=exp=1782382071~acl=/api/1/1/1/0/0/0/100775c0aee654254f31cc80dd4dafe7.mp3*~data=user_id=0,application_id=42~hmac=cd740b9aaf43e34f0295541a980cf14fb14d9bf93540078e00ed83a2a78eeaba	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
324	1898921297	Falling Behind	173	1	https://cdn-images.dzcdn.net/images/cover/ce4203bf02c22e66eaf2a221fb844c87/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/3/c/0/33cd892024ffff59cc88764d21c969a6.mp3?hdnea=exp=1782382071~acl=/api/1/1/3/3/c/0/33cd892024ffff59cc88764d21c969a6.mp3*~data=user_id=0,application_id=42~hmac=ae224edb9837c6ee06bbb8657bcf7e187b2fd9ebdf355874c529a86884a95677	315	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
513	3541914361	DAISIES	176	2	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/8/0/5c8b19ee997114e357b892f062635d60.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/c/8/0/5c8b19ee997114e357b892f062635d60.mp3*~data=user_id=0,application_id=42~hmac=cee18075fba082f1e9f861259fffd6f060858ddd5f4d57840e3a07c85451abb8	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
514	3541914371	YUKON	164	3	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/7/b/0/57b7080ffab9460ab68c492bd545a85f.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/7/b/0/57b7080ffab9460ab68c492bd545a85f.mp3*~data=user_id=0,application_id=42~hmac=b8be113bfa7f6c6b19bced66025eed7348e58e6a36ea3036a6230f8d7e63f45f	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
515	3541914381	GO BABY	195	4	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/e/0/0/ae0e810a901dfd9d921ad35e19091009.mp3?hdnea=exp=1783448156~acl=/api/1/1/a/e/0/0/ae0e810a901dfd9d921ad35e19091009.mp3*~data=user_id=0,application_id=42~hmac=ee55cc8bd84198932b7326b0b1087ef0629449d95d184f799771947a9c95d5f1	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
516	3541914391	THINGS YOU DO	108	5	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/9/f/0/99fe127e29c77a5dfa2d67fdb40fd6f0.mp3?hdnea=exp=1783448156~acl=/api/1/1/9/9/f/0/99fe127e29c77a5dfa2d67fdb40fd6f0.mp3*~data=user_id=0,application_id=42~hmac=3eaa19e17cd9234ae381fdd6de9885ccd81adcef561f30be9951f85cbb1a6ada	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
517	3541914401	BUTTERFLIES	194	6	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/7/c/0/c7c8c4c9d681b64c7f19ed852b2c585f.mp3?hdnea=exp=1783448156~acl=/api/1/1/c/7/c/0/c7c8c4c9d681b64c7f19ed852b2c585f.mp3*~data=user_id=0,application_id=42~hmac=4b5012f9da97363d308505440c81c9de238fef1766628928fcab15aae586963c	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
518	3541914411	WAY IT IS	195	7	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/7/1/0/871e13277f0281b3c1f6e23b56e34b64.mp3?hdnea=exp=1783448156~acl=/api/1/1/8/7/1/0/871e13277f0281b3c1f6e23b56e34b64.mp3*~data=user_id=0,application_id=42~hmac=8ab7bc790cba7ef5d31d392a92048d81cd59e61213f581eeabc299ac4e79e5d2	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
519	3541914421	FIRST PLACE	200	8	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/2/0/142f4df099ce6e603fb5fa1cd04b0ba3.mp3?hdnea=exp=1783448156~acl=/api/1/1/1/4/2/0/142f4df099ce6e603fb5fa1cd04b0ba3.mp3*~data=user_id=0,application_id=42~hmac=0f0a8d2c9e3b3a544c45641870562b557c5c219e59def667a80eca11a3d56523	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
520	3541914431	SOULFUL	37	9	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/d/5/0/7d5ab2617e0e2599226f26e42e4be251.mp3?hdnea=exp=1783448156~acl=/api/1/1/7/d/5/0/7d5ab2617e0e2599226f26e42e4be251.mp3*~data=user_id=0,application_id=42~hmac=17ed908b1cc2298a76dc4ed5fef44ca52281065b3414de4c7dc2ec2832d5dacc	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
521	3541914441	WALKING AWAY	244	10	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/c/4/0/ac4745897730f35b282465945114de1d.mp3?hdnea=exp=1783448156~acl=/api/1/1/a/c/4/0/ac4745897730f35b282465945114de1d.mp3*~data=user_id=0,application_id=42~hmac=094f015f545f45e2883c541844dd0128a6b9b1df1c9f03b34a88bc7bf858c816	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
522	3541914451	GLORY VOICE MEMO	85	11	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/2/2/0/8225513458bc31cc5d6b6c481dff548b.mp3?hdnea=exp=1783448156~acl=/api/1/1/8/2/2/0/8225513458bc31cc5d6b6c481dff548b.mp3*~data=user_id=0,application_id=42~hmac=af8fa0c041dc76672b5adacf3b74375d9d03e086683af3f7c46f8d71322974a8	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
523	3541914461	DEVOTION	234	12	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/b/8/0/2b8b80cf9ffcc22daabd47b2f6383098.mp3?hdnea=exp=1783448156~acl=/api/1/1/2/b/8/0/2b8b80cf9ffcc22daabd47b2f6383098.mp3*~data=user_id=0,application_id=42~hmac=5786f67cee55162696877a4d421ea7e5a6511bc80e7e5ac26948cbe7e3b882dd	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
524	3541914471	DADZ LOVE	145	13	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/d/5/0/8d5eb7d667ea2ad93a54c747e301809a.mp3?hdnea=exp=1783448156~acl=/api/1/1/8/d/5/0/8d5eb7d667ea2ad93a54c747e301809a.mp3*~data=user_id=0,application_id=42~hmac=525178c61b018caa4521ddcde5c55bc309f5b42e457ce843cdb97d74d2ed59f7	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
525	3541914481	THERAPY SESSION	79	14	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/8/9/0/0896daf35e735f923fab9047edece6ba.mp3?hdnea=exp=1783448156~acl=/api/1/1/0/8/9/0/0896daf35e735f923fab9047edece6ba.mp3*~data=user_id=0,application_id=42~hmac=8bce706996dd686aca14511345e2dcb956bf9c6657f7392f4f805f57498f3d87	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
369	1856908067	Let You Break My Heart Again	269	\N	https://cdn-images.dzcdn.net/images/cover/9825bb50e26e8daae1ba75b7f7a17489/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/3/0/633e9760601a8a16a4fe893860933f77.mp3?hdnea=exp=1782388320~acl=/api/1/1/6/3/3/0/633e9760601a8a16a4fe893860933f77.mp3*~data=user_id=0,application_id=42~hmac=0a2ea5d48c8ca5d5bd5c32664a44b30617efe491de09d6d52a11ea24b1845701	371	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
370	3513670671	Too Little, Too Late	233	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/5/d/0/65d93a41c45f1719614f9fd18168f177.mp3?hdnea=exp=1782388320~acl=/api/1/1/6/5/d/0/65d93a41c45f1719614f9fd18168f177.mp3*~data=user_id=0,application_id=42~hmac=0ff0d244081848d2c1f9ff19a0b4d85456810e76c9fd2e6b8cca59e1f6d212a6	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
371	3467339701	Snow White	193	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/f/6/0/4f607d882d076f5156eaf1c5e9477a4b.mp3?hdnea=exp=1782388320~acl=/api/1/1/4/f/6/0/4f607d882d076f5156eaf1c5e9477a4b.mp3*~data=user_id=0,application_id=42~hmac=6f0e8206c0ff583b2287ebced8553644ddd5e32287652de513a953889868fea6	372	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
373	2309254495	Dreamer	210	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/4/e/0/74ea95a5bc4c05d667dd13897307be40.mp3?hdnea=exp=1782388320~acl=/api/1/1/7/4/e/0/74ea95a5bc4c05d667dd13897307be40.mp3*~data=user_id=0,application_id=42~hmac=0a63b1e6c0c1fe20ccd3b3af2db5fa9d43ac10ba09bcf06682aaae3255165d0f	313	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
526	3541914491	SWEET SPOT	185	15	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/2/f/0/52fba272fa1def7c7978d7ff56a6e708.mp3?hdnea=exp=1783448156~acl=/api/1/1/5/2/f/0/52fba272fa1def7c7978d7ff56a6e708.mp3*~data=user_id=0,application_id=42~hmac=b73ceae65c6bfd420526ace856869da28fe796266f7001fb8dad17444882debd	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
527	3541914501	STANDING ON BUSINESS	50	16	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/6/0/0/360c6cd630896b62254b9d368f03656c.mp3?hdnea=exp=1783448156~acl=/api/1/1/3/6/0/0/360c6cd630896b62254b9d368f03656c.mp3*~data=user_id=0,application_id=42~hmac=9dacdc0906f084bba919b4d0a1b676ffe15492e00f492c8dff0dd91f9af6010a	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
528	3541914511	405	213	17	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/d/9/0/bd9aca63b81db3f1f08994375815c96c.mp3?hdnea=exp=1783448156~acl=/api/1/1/b/d/9/0/bd9aca63b81db3f1f08994375815c96c.mp3*~data=user_id=0,application_id=42~hmac=6454288cd006cdd4aacaf91221afd9ec09f0fc175e7a50ca0207451acdc24e01	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
529	3541914521	SWAG	150	18	https://cdn-images.dzcdn.net/images/cover/67541e55a567744d91f140a7d5bc1727/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/d/6/0/9d6d571b2c3d68feb7f6d0679db1fdaf.mp3?hdnea=exp=1783448156~acl=/api/1/1/9/d/6/0/9d6d571b2c3d68feb7f6d0679db1fdaf.mp3*~data=user_id=0,application_id=42~hmac=573d02e94ed033744b08238e49595d0ae723e55b526843a48c1a676935c8cf4d	269	2026-07-07 18:00:57.172208	2026-07-09 12:24:03.394153
533	70322130	Do I Wanna Know?	272	1	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/3/8/0/f380e7e1a00cd0149000196d2cef3f4c.mp3?hdnea=exp=1783507074~acl=/api/1/1/f/3/8/0/f380e7e1a00cd0149000196d2cef3f4c.mp3*~data=user_id=0,application_id=42~hmac=94baf42079d0adcca1a05288d5188f56250868c1170b94543c443995f3058dc0	429	2026-07-08 10:22:55.18496	2026-07-09 12:24:03.394153
534	70322132	R U Mine?	201	2	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/8/a/0/48a8027358ef346ce6fb6577d0ad62da.mp3?hdnea=exp=1783507074~acl=/api/1/1/4/8/a/0/48a8027358ef346ce6fb6577d0ad62da.mp3*~data=user_id=0,application_id=42~hmac=2d0f7f96c7a9cea7c5605059536aa0673940d1c213da58c0fd1da6f313a7c9d0	429	2026-07-08 10:22:55.18496	2026-07-09 12:24:03.394153
535	70322142	I Wanna Be Yours	183	12	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/0/c/0/80cf1e6bec0b3caded54ddb231041db7.mp3?hdnea=exp=1783507074~acl=/api/1/1/8/0/c/0/80cf1e6bec0b3caded54ddb231041db7.mp3*~data=user_id=0,application_id=42~hmac=81992789ef97946535907d87d907bffc14e483edb7c5406e54c417e4590971cf	429	2026-07-08 10:22:55.18496	2026-07-09 12:24:03.394153
536	70322139	Why'd You Only Call Me When You're High?	161	9	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/e/9/0/1e959605ab4887b73f1a0f65107b8ec8.mp3?hdnea=exp=1783507074~acl=/api/1/1/1/e/9/0/1e959605ab4887b73f1a0f65107b8ec8.mp3*~data=user_id=0,application_id=42~hmac=24ea989ecfd3e2e0cebcf45e761d6ca9bd37ded14fad1efcbc16c866ac95aae0	429	2026-07-08 10:22:55.18496	2026-07-09 12:24:03.394153
537	70322133	One For The Road	206	3	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/0/4/0/204b6afe41577dc5ff685f17242f4302.mp3?hdnea=exp=1783507091~acl=/api/1/1/2/0/4/0/204b6afe41577dc5ff685f17242f4302.mp3*~data=user_id=0,application_id=42~hmac=5ecaad63d53a8af8763477b6dd8743b79905dfc2d6159bf25ea0daf2983697fe	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
538	70322134	Arabella	207	4	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/f/6/0/4f6b19c37dc35ec828f7181d97666315.mp3?hdnea=exp=1783507091~acl=/api/1/1/4/f/6/0/4f6b19c37dc35ec828f7181d97666315.mp3*~data=user_id=0,application_id=42~hmac=bb498beb82eded56d3cbc2f6970b83b83a415dbddd02f0d789e244c4b9034808	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
539	70322135	I Want It All	185	5	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/9/0/6397de9403f54dfdb5f33924be16cab2.mp3?hdnea=exp=1783507091~acl=/api/1/1/6/3/9/0/6397de9403f54dfdb5f33924be16cab2.mp3*~data=user_id=0,application_id=42~hmac=e0c4fb78b0b089b3fc6162f3e175f41920028b247f9860eff5f48f2b08f450ee	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
540	70322136	No. 1 Party Anthem	243	6	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/d/d/0/6dd65c06007ddfeb105a2eed094fed40.mp3?hdnea=exp=1783507091~acl=/api/1/1/6/d/d/0/6dd65c06007ddfeb105a2eed094fed40.mp3*~data=user_id=0,application_id=42~hmac=b27b60c9cb4b03179d54d59896fb4e0a7b19ce167ade1de155cfb9438cef692e	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
541	70322137	Mad Sounds	215	7	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/a/9/0/fa945c04b686a0fbe5a40802c5baa68c.mp3?hdnea=exp=1783507091~acl=/api/1/1/f/a/9/0/fa945c04b686a0fbe5a40802c5baa68c.mp3*~data=user_id=0,application_id=42~hmac=0e60c5036f28e148f6e581d6a9c709d12c8f173541506408d7a11221f9c47f50	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
542	70322138	Fireside	181	8	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/8/5/0/48542658f75dc0d2d3fe721dd355ccc5.mp3?hdnea=exp=1783507091~acl=/api/1/1/4/8/5/0/48542658f75dc0d2d3fe721dd355ccc5.mp3*~data=user_id=0,application_id=42~hmac=e5ed2dd5b9eb7653e5a832da105052aa7622f9d7f299e819949825e32777fb8b	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
543	70322140	Snap Out Of It	193	10	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/d/1/0/fd1035e2daf0a58b7a84d2db0b601109.mp3?hdnea=exp=1783507091~acl=/api/1/1/f/d/1/0/fd1035e2daf0a58b7a84d2db0b601109.mp3*~data=user_id=0,application_id=42~hmac=a2bca8417a6cf5b49b233a69603ede5c16f10e9bb22a8998d8d9cee32ffa326b	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
544	70322141	Knee Socks	257	11	https://cdn-images.dzcdn.net/images/cover/64e54e307bd5e2bdb27ffeb662fd910d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/b/0/63b904b95cc7dbc23e8fb700f0f88988.mp3?hdnea=exp=1783507091~acl=/api/1/1/6/3/b/0/63b904b95cc7dbc23e8fb700f0f88988.mp3*~data=user_id=0,application_id=42~hmac=08a822193680733b1283f2e105bb262ef7b1d3c2cfae0cb91fd24f1fb7db08ed	429	2026-07-08 10:23:11.575347	2026-07-09 12:24:03.394153
386	3812116842	How I Get	219	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/0/4/0/804ef1b509acde4144c0508dfb41d4a1.mp3?hdnea=exp=1782388320~acl=/api/1/1/8/0/4/0/804ef1b509acde4144c0508dfb41d4a1.mp3*~data=user_id=0,application_id=42~hmac=6e413869ba0b4ddee1775c43f8ebb8e4488381d07d42bfe74e7ae558ce3cdc7a	378	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
545	1860754817	Dark Red	173	\N	https://cdn-images.dzcdn.net/images/cover/7514781a2e26062a0edd8ef66c52d768/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/a/9/0/4a9b3ea55d82edd181a6a27160f50311.mp3?hdnea=exp=1783507107~acl=/api/1/1/4/a/9/0/4a9b3ea55d82edd181a6a27160f50311.mp3*~data=user_id=0,application_id=42~hmac=c0479781c302dc8124aa2472341fbd5abfaeec911e64bc3a50c9ffc7ae954026	432	2026-07-08 10:23:28.930304	2026-07-09 12:24:03.394153
546	1817216187	Bad Habit	232	\N	https://cdn-images.dzcdn.net/images/cover/3b60918205a5bb30e2b2427714ec3162/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/5/7/0/957b036a7ce6fcc458e1148b45d982f2.mp3?hdnea=exp=1783507107~acl=/api/1/1/9/5/7/0/957b036a7ce6fcc458e1148b45d982f2.mp3*~data=user_id=0,application_id=42~hmac=df668e73b92c59bdef5bd8470c40d055b2427a4290fe9810fd1143b600bc5449	433	2026-07-08 10:23:28.930304	2026-07-09 12:24:03.394153
547	4114107231	is it cool? (feat. SZA)	174	\N	https://cdn-images.dzcdn.net/images/cover/c64458bda012cdf305dc92a07626a51d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/4/0/63434a9ebb18f8cd026c91956d22fa39.mp3?hdnea=exp=1783507107~acl=/api/1/1/6/3/4/0/63434a9ebb18f8cd026c91956d22fa39.mp3*~data=user_id=0,application_id=42~hmac=878e0a4dd92afb4a5e72f4a056939d4736d59a486b436703ec8ba8a5aaa88bb3	434	2026-07-08 10:23:28.930304	2026-07-09 12:24:03.394153
548	4057589031	the feeling	275	\N	https://cdn-images.dzcdn.net/images/cover/c64458bda012cdf305dc92a07626a51d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/0/1/0/101df6060345337b017c34986c0e7de0.mp3?hdnea=exp=1783507107~acl=/api/1/1/1/0/1/0/101df6060345337b017c34986c0e7de0.mp3*~data=user_id=0,application_id=42~hmac=55654edde70cc2e40506297521bde059bad0c4821918bbebdbb2e171300f54cc	435	2026-07-08 10:23:28.930304	2026-07-09 12:24:03.394153
549	1029729702	Live Without Your Love	205	\N	https://cdn-images.dzcdn.net/images/cover/7080259274eaa1ab0348d8f345152d27/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/0/a/0/d0a896c1ef5163c81fd33624b2a649fe.mp3?hdnea=exp=1783507107~acl=/api/1/1/d/0/a/0/d0a896c1ef5163c81fd33624b2a649fe.mp3*~data=user_id=0,application_id=42~hmac=32d2215ade1cf77cc1c3d2879f7677aafa74b04a064cbcf2bb87ff3911f5612b	436	2026-07-08 10:23:28.930304	2026-07-09 12:24:03.394153
550	116348656	Let It Be (Remastered 2009)	243	\N	https://cdn-images.dzcdn.net/images/cover/fcf05300b7c17ec77a6d01028a4bef61/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/f/5/0/af5b351b100513b1c167e5ed96b7ece3.mp3?hdnea=exp=1783507789~acl=/api/1/1/a/f/5/0/af5b351b100513b1c167e5ed96b7ece3.mp3*~data=user_id=0,application_id=42~hmac=d51678098cad90b0f7545873c8c6c3a814e50ec50e7570f1012b135f9aaba6e7	437	2026-07-08 10:34:50.165638	2026-07-09 12:24:03.394153
560	3897438051	abbey road	158	\N	https://cdn-images.dzcdn.net/images/cover/e8b20eea3bde8c2c8b75cea65845c4f9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/e/9/0/9e9d890bf9b2c463533ce0c934935ec4.mp3?hdnea=exp=1783507988~acl=/api/1/1/9/e/9/0/9e9d890bf9b2c463533ce0c934935ec4.mp3*~data=user_id=0,application_id=42~hmac=ec7b10a67c22949071008c8fcd87cff0b6b87c80043fe4a8e943c39362c8ac2b	449	2026-07-08 10:38:09.641639	2026-07-09 12:24:03.394153
561	3724377722	Abbey Road	249	\N	https://cdn-images.dzcdn.net/images/cover/7e3379694b033ca0f814a301b7738dd8/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/6/4/0/864ca76398e998329eaefb7f5bba58b3.mp3?hdnea=exp=1783507988~acl=/api/1/1/8/6/4/0/864ca76398e998329eaefb7f5bba58b3.mp3*~data=user_id=0,application_id=42~hmac=159f585408379dfcad38adc11ce1fc14f4f5662ea4747d0ce9f0843a64c83928	450	2026-07-08 10:38:09.641639	2026-07-09 12:24:03.394153
1137	3871622581	Цветок	155	\N	https://cdn-images.dzcdn.net/images/cover/043b0120458069b04312cd643177b9c1/1000x1000-000000-80-0-0.jpg	\N	742	2026-07-14 11:32:59.285564	2026-07-14 11:32:59.285564
388	2564193212	Winter Wonderland	132	1	https://cdn-images.dzcdn.net/images/cover/7f917c6ece68040dbcf17117984fe3a5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/5/1/0/951b1b0a3b93de0a38193fb511773804.mp3?hdnea=exp=1782388320~acl=/api/1/1/9/5/1/0/951b1b0a3b93de0a38193fb511773804.mp3*~data=user_id=0,application_id=42~hmac=1210e88c6ad742e4ed970a730eecba55ea02469f7d4229fb5018f3c19f691dc6	380	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
406	3939046401	Forget-Me-Not	246	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/f/0/83fb81934e7782f5970c0b43b93b444e.mp3?hdnea=exp=1782388321~acl=/api/1/1/8/3/f/0/83fb81934e7782f5970c0b43b93b444e.mp3*~data=user_id=0,application_id=42~hmac=26e3ddffece18c649da75cd541d910ce158fdde8f650c86a10e289ab486a6a2f	311	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
551	116348452	Come Together (Remastered 2009)	258	1	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/2/2/0/b2215e49d659c178394641df9945e645.mp3?hdnea=exp=1783507789~acl=/api/1/1/b/2/2/0/b2215e49d659c178394641df9945e645.mp3*~data=user_id=0,application_id=42~hmac=27ad70d6edf5a96bd0998f8968814c4240e363860149715a726603ed1fee0c4d	438	2026-07-08 10:34:50.165638	2026-07-12 08:33:19.902048
1121	1100592462	Compass	152	2	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	\N	163	2026-07-13 10:20:24.531375	2026-07-13 10:20:24.531375
1122	1100592472	Powder Snow	226	3	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	\N	163	2026-07-13 10:20:24.531375	2026-07-13 10:20:24.531375
1123	1100592482	Song of Blue	232	4	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	\N	163	2026-07-13 10:20:24.531375	2026-07-13 10:20:24.531375
1124	1100592492	Sunday	243	5	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	\N	163	2026-07-13 10:20:24.531375	2026-07-13 10:20:24.531375
1125	1100592502	12	276	6	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	\N	163	2026-07-13 10:20:24.531375	2026-07-13 10:20:24.531375
1136	3233016471	ПОВОД	153	\N	https://cdn-images.dzcdn.net/images/cover/3b8f501a672c36d1f916ac67775e72b1/1000x1000-000000-80-0-0.jpg	\N	738	2026-07-14 11:32:59.285564	2026-07-14 11:32:59.285564
1138	1906286377	BUGATTI	190	\N	https://cdn-images.dzcdn.net/images/cover/ffe5fc3fcacda1e048530a71fc6c61c0/1000x1000-000000-80-0-0.jpg	\N	743	2026-07-14 11:32:59.285564	2026-07-14 11:32:59.285564
1139	1391114172	POSOSI	130	\N	https://cdn-images.dzcdn.net/images/cover/a5d527a6893c6b9851ac984333f0059b/1000x1000-000000-80-0-0.jpg	\N	744	2026-07-14 11:32:59.285564	2026-07-14 11:32:59.285564
1140	958111	Hard To Explain	223	\N	https://cdn-images.dzcdn.net/images/cover/700f0375d5ac8570f16a2c7eb128303f/1000x1000-000000-80-0-0.jpg	\N	748	2026-07-15 08:21:06.211354	2026-07-15 08:21:06.211354
1141	3516882481	Hard to Explain (live)	249	\N	https://cdn-images.dzcdn.net/images/cover/a79555895e5dd8f543fb196f962966b2/1000x1000-000000-80-0-0.jpg	\N	749	2026-07-15 08:21:06.211354	2026-07-15 08:21:06.211354
1142	679075292	Hard to Explain	422	\N	https://cdn-images.dzcdn.net/images/cover/e9da3e26c558bff8fae6226d3ec55d02/1000x1000-000000-80-0-0.jpg	\N	750	2026-07-15 08:21:06.211354	2026-07-15 08:21:06.211354
1143	1879841627	Hard to Explain	216	\N	https://cdn-images.dzcdn.net/images/cover/aad8375c844f26cf47e64898af595f2d/1000x1000-000000-80-0-0.jpg	\N	751	2026-07-15 08:21:06.211354	2026-07-15 08:21:06.211354
1144	2900112	Hard To Explain	277	\N	https://cdn-images.dzcdn.net/images/cover/c71a1b646c622fe7d0c3292bc4c1d089/1000x1000-000000-80-0-0.jpg	\N	752	2026-07-15 08:21:06.211354	2026-07-15 08:21:06.211354
716	4315578	Crying Lightning	224	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
717	3783510512	Opening Night	259	\N	https://cdn-images.dzcdn.net/images/cover/ee987bc5ae84a3e3d6143db84e91c0de/1000x1000-000000-80-0-0.jpg	\N	525	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
718	4637218	Baby I'm Yours	152	\N	https://cdn-images.dzcdn.net/images/cover/26eb03c5425cfae62b6c918e75c3c27a/1000x1000-000000-80-0-0.jpg	\N	526	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
719	497736992	Four Out Of Five	312	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
720	4637216	Leave Before The Lights Come On	233	\N	https://cdn-images.dzcdn.net/images/cover/26eb03c5425cfae62b6c918e75c3c27a/1000x1000-000000-80-0-0.jpg	\N	526	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
721	4637222	No Buses	197	\N	https://cdn-images.dzcdn.net/images/cover/0aa4d11b329649549d792124918b9517/1000x1000-000000-80-0-0.jpg	\N	527	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
722	70192214	Stop The World I Wanna Get Off With You	191	\N	https://cdn-images.dzcdn.net/images/cover/3426755cf672f3237a877f19f693a564/1000x1000-000000-80-0-0.jpg	\N	528	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
723	4315583	Cornerstone	197	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
724	1953333127	Body Paint	290	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
725	12713707	Don't Sit Down 'Cause I've Moved Your Chair	183	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
726	4637223	Who The Fuck Are Arctic Monkeys?	336	\N	https://cdn-images.dzcdn.net/images/cover/0aa4d11b329649549d792124918b9517/1000x1000-000000-80-0-0.jpg	\N	527	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
727	4315584	Dance Little Liar	283	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
728	4315586	The Jeweller's Hands	344	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
729	497736952	One Point Perspective	208	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
730	1953333087	There’d Better Be A Mirrorball	265	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
731	4315577	My Propeller	205	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
732	4315582	Fire And The Thud	237	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
733	1953333137	The Car	198	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
734	4637207	The Bakery	176	\N	https://cdn-images.dzcdn.net/images/cover/5f5beea1c209a589796b81dd0d8f86dc/1000x1000-000000-80-0-0.jpg	\N	530	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
735	497736942	Star Treatment	354	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
736	4315580	Secret Door	223	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
737	71991280	Settle For A Draw	200	\N	https://cdn-images.dzcdn.net/images/cover/531dab0d0da6394a148721808dee94a8/1000x1000-000000-80-0-0.jpg	\N	531	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
738	4637220	Cigarette Smoker Fiona	176	\N	https://cdn-images.dzcdn.net/images/cover/0aa4d11b329649549d792124918b9517/1000x1000-000000-80-0-0.jpg	\N	527	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
739	4637228	Bigger Boys and Stolen Sweethearts	180	\N	https://cdn-images.dzcdn.net/images/cover/4101f13e259b9a23cba4dfc54c172f90/1000x1000-000000-80-0-0.jpg	\N	532	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
740	12713703	She's Thunderstorms	234	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
741	4637226	7	128	\N	https://cdn-images.dzcdn.net/images/cover/ed5ac8e597315a96a7743bbfc19ead27/1000x1000-000000-80-0-0.jpg	\N	533	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
742	12713704	Black Treacle	217	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
743	1953333157	Hello You	244	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
744	12713709	All My Own Stunts	232	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
745	12713714	That's Where You're Wrong	256	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
746	72928541	You're So Dark	182	\N	https://cdn-images.dzcdn.net/images/cover/f342d00b4350d8eb28c582160b0b03d0/1000x1000-000000-80-0-0.jpg	\N	534	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
747	1953333147	Big Ideas	237	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
748	4637209	Too Much To Ask	183	\N	https://cdn-images.dzcdn.net/images/cover/5f5beea1c209a589796b81dd0d8f86dc/1000x1000-000000-80-0-0.jpg	\N	530	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
749	12713712	Love is a Laserquest	191	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
750	1120498732	Do I Wanna Know? (Live)	281	\N	https://cdn-images.dzcdn.net/images/cover/aa8ea17eb50583c3ee24e3989385f963/1000x1000-000000-80-0-0.jpg	\N	535	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
751	497736972	Tranquility Base Hotel & Casino	211	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
752	12713711	Piledriver Waltz	203	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
753	1953333117	Jet Skis On The Moat	197	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
754	1953333167	Mr Schwartz	210	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
755	5570976	The Afternoon's Hat	251	\N	https://cdn-images.dzcdn.net/images/cover/aa5d463f4fa6c6bd3de44553d3b11ca4/1000x1000-000000-80-0-0.jpg	\N	536	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
756	4637227	I Bet You Look Good On The Dancefloor	176	\N	https://cdn-images.dzcdn.net/images/cover/4101f13e259b9a23cba4dfc54c172f90/1000x1000-000000-80-0-0.jpg	\N	532	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
757	4315579	Dangerous Animals	210	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
758	497737002	The World's First Ever Monster Truck Front Flip	180	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
759	4637199	Red Right Hand	259	\N	https://cdn-images.dzcdn.net/images/cover/b881de6a063710bf0f376754ab6abc58/1000x1000-000000-80-0-0.jpg	\N	537	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
760	4637221	Despair In The Departure Lounge	202	\N	https://cdn-images.dzcdn.net/images/cover/0aa4d11b329649549d792124918b9517/1000x1000-000000-80-0-0.jpg	\N	527	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
761	497737012	Science Fiction	185	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
762	12713706	The Hellcat Spangled Shalalala	180	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
763	4315581	Potion Approaching	212	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
764	497737022	She Looks Like Fun	182	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
765	1953333107	Sculptures Of Anything Goes	239	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
766	1953333177	Perfect Sense	167	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
767	497737032	Batphone	271	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
768	4637214	Temptation Greets You Like Your Naughty Friend	209	\N	https://cdn-images.dzcdn.net/images/cover/007fefc664c041b0a5c8afdd6ee10cb2/1000x1000-000000-80-0-0.jpg	\N	538	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
769	18253361	Electricity	181	\N	https://cdn-images.dzcdn.net/images/cover/fc5f8a3e97f5fd7d1bac1cd68bedfca6/1000x1000-000000-80-0-0.jpg	\N	539	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
770	1953333097	I Ain’t Quite Where I Think I Am	191	\N	https://cdn-images.dzcdn.net/images/cover/1f137dac0e31b896d5350742b4365f07/1000x1000-000000-80-0-0.jpg	\N	529	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
771	12713708	Library Pictures	142	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
772	12713705	Brick By Brick	179	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
773	4315585	Pretty Visitors	220	\N	https://cdn-images.dzcdn.net/images/cover/13cdeb23547351f3ea543a2f5b4b9a4b/1000x1000-000000-80-0-0.jpg	\N	430	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
774	4637195	Catapult	206	\N	https://cdn-images.dzcdn.net/images/cover/521f322a4b76c550bd1b12d64a8b1066/1000x1000-000000-80-0-0.jpg	\N	540	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
775	12713710	Reckless Serenade	162	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
776	12713713	Suck It and See	225	\N	https://cdn-images.dzcdn.net/images/cover/9751005be2b826746df12c45b761573a/1000x1000-000000-80-0-0.jpg	\N	516	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
777	497737042	The Ultracheese	217	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
778	497736982	Golden Trunks	173	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
779	497736962	American Sports	158	\N	https://cdn-images.dzcdn.net/images/cover/b223decfaa57910ef709736e49eaf0de/1000x1000-000000-80-0-0.jpg	\N	431	2026-07-09 18:23:27.233675	2026-07-09 18:23:27.233675
780	6469965	Clarissa	114	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
781	2421517685	Witness	196	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
782	8025464	What Do They Know?	188	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
783	8025462	Stupid MF	144	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
784	2421517705	It Gets Worse	176	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
785	6469969	Faggot	163	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
788	6469971	Golden I	124	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
792	2421517745	Ala Mode	152	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
793	2421517695	Fuck Machine	204	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
794	2421517735	You're No Fun Anymore Mark Trezona	173	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
786	12235149	Straight To Video	223	3	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-09 18:30:54.020851	2026-07-24 09:31:09.004273
796	6469972	Harry Truman	95	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
797	2421517805	Ass Backwards	175	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
799	6469979	Kill the Rock	120	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
800	6469984	Planet of the Apes	129	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
801	2421517785	Stalkers (slit my wrists)	159	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
802	2421517725	Hey Tomorrow Fuck You and Your Friend Yesterday	160	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
803	2421517755	Casio	134	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
805	2421517815	The Logical Song	241	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
806	8025470	You'll Rebel To Anything	152	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
807	8025472	La-Di Da-Di	229	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
809	6469985	Played	135	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
810	8025467	Bullshit	161	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
811	2421517795	Jack You Up	213	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
812	2421517775	Kill You All In a Hip Hop Rage	149	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
813	8025466	Prom	148	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
814	2421517765	Anonymous	123	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
815	6469983	Masturbates	169	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
816	6469966	Cocaine and Toupees	109	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
818	8025468	Tom Sawyer	144	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
819	6469962	Backmask	159	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
820	8025465	2 Hookers And An 8 Ball	137	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
822	8025471	Microphone Commander	124	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
823	6469975	I'm Your Problem Now	114	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
824	6469973	Holy Shit	112	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
825	6469987	Royally Fucked	109	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
826	6469974	I Hate Jimmy Page	214	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
828	6469986	Ready for Love	122	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
829	6469978	Kick the Bucket	101	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
830	8025473	Make Me Cum (Demo)	169	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
831	6469977	Keepin' up with the Kids	101	\N	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	\N	185	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
833	8093363	Straight to Video (The Birthday Massacre Remix)	223	\N	https://cdn-images.dzcdn.net/images/cover/d61150d721760f27379d13d149e6378d/1000x1000-000000-80-0-0.jpg	\N	557	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
834	8025474	Wack! (Live)	154	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
835	8093358	Straight to Video (KMFDM Remix)	320	\N	https://cdn-images.dzcdn.net/images/cover/d61150d721760f27379d13d149e6378d/1000x1000-000000-80-0-0.jpg	\N	557	2026-07-09 18:30:54.020851	2026-07-09 18:30:54.020851
817	12235155	1989	118	9	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-09 18:30:54.020851	2026-07-24 09:31:09.004273
26	1343803132	Soldier, Poet, King	165	10	https://cdn-images.dzcdn.net/images/cover/ed02c86f4af4ba017b30ff2f210656a7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/4/c/0/d4c2ad95f0cb01290112131c16172557.mp3?hdnea=exp=1775488714~acl=/api/1/1/d/4/c/0/d4c2ad95f0cb01290112131c16172557.mp3*~data=user_id=0,application_id=42~hmac=025651f4e4444fce1fb993422a609e417ba2d7a29462c62b3a421621a5295dd0	25	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
27	2101635277	Remember Me	244	9	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/d/4/0/bd45eccd5185a04ddfaee29b8b92a30c.mp3?hdnea=exp=1775488795~acl=/api/1/1/b/d/4/0/bd45eccd5185a04ddfaee29b8b92a30c.mp3*~data=user_id=0,application_id=42~hmac=6f339fcac7a8f11d2f62a4d427b3a7e818805fd8df5bc56696c725620d4e5256	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
28	909001362	Better Days	247	11	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/a/8/0/6a8a2275a807829b43edac03128389b1.mp3?hdnea=exp=1775488795~acl=/api/1/1/6/a/8/0/6a8a2275a807829b43edac03128389b1.mp3*~data=user_id=0,application_id=42~hmac=1a99b622f7f24f62d25dcdd209fa774f8eefaa84d0a336ef1db0f07035fd96ef	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
29	2101635227	So Alone	238	4	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/b/5/0/9b56f60b348b646c150f323657d50e79.mp3?hdnea=exp=1775488795~acl=/api/1/1/9/b/5/0/9b56f60b348b646c150f323657d50e79.mp3*~data=user_id=0,application_id=42~hmac=546554f3eb4188825ab5721c04e7779bbfebde7032ac46e026b37a9070d5bc66	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
30	3583314871	Making Circles	264	3	https://cdn-images.dzcdn.net/images/cover/ba142c155764fa3b9cc52e1be7e43d47/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/e/d/0/ceda1b1b8c89203f5cedccb8171e3968.mp3?hdnea=exp=1775488795~acl=/api/1/1/c/e/d/0/ceda1b1b8c89203f5cedccb8171e3968.mp3*~data=user_id=0,application_id=42~hmac=60a3b04e5c6052d8afa0b969555af753b999ba0847235f21ebedfdc7243d11a0	28	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
31	2101635207	Living In Tragedy	243	2	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/7/2/0/672135edfde3cd1ec1ab88d0fbdad52d.mp3?hdnea=exp=1775488795~acl=/api/1/1/6/7/2/0/672135edfde3cd1ec1ab88d0fbdad52d.mp3*~data=user_id=0,application_id=42~hmac=f85036840cdfa6b1967d3554b5a343d15e1ab34fb28c113b6e59fbf1ce6b04ab	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
32	2101635217	Unfamiliar	224	3	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/3/7/0/e37b06a17145dd25695cded0bdb20e50.mp3?hdnea=exp=1775488852~acl=/api/1/1/e/3/7/0/e37b06a17145dd25695cded0bdb20e50.mp3*~data=user_id=0,application_id=42~hmac=7048f74f54e4d628b888b52ff7be0a6aad907bd7847e42b6daddcbbc1f460f77	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
33	2101635197	The Death We Seek	245	1	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/8/f/0/d8f7aca420ac8b6b782dee832853367d.mp3?hdnea=exp=1775488852~acl=/api/1/1/d/8/f/0/d8f7aca420ac8b6b782dee832853367d.mp3*~data=user_id=0,application_id=42~hmac=1e025da60fed80cf91a4df4446138c65a4bc74a979dd2948a80f65be9cbedad7	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
34	2101635237	Over And Over	248	5	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/8/4/0/884959ceee78a67321ff5c0943d215c7.mp3?hdnea=exp=1775488852~acl=/api/1/1/8/8/4/0/884959ceee78a67321ff5c0943d215c7.mp3*~data=user_id=0,application_id=42~hmac=16d48ad2307ced11b8c23bec533ad3dffe91c6cb581341b3b4b8114ed9426289	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
35	909001312	Let Me Leave	201	6	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/7/d/0/07db90cbdf92063ae2fd4af1909097a7.mp3?hdnea=exp=1775488852~acl=/api/1/1/0/7/d/0/07db90cbdf92063ae2fd4af1909097a7.mp3*~data=user_id=0,application_id=42~hmac=db3677ab22560bcdf4d8d72c8b4f29e32a9fc4d5230cf6646eb0f61595bc1ef6	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
36	909001352	How I Fall Apart	251	10	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/c/8/0/2c89851ed7ad75fb5d37d20ff5a42fb8.mp3?hdnea=exp=1775488852~acl=/api/1/1/2/c/8/0/2c89851ed7ad75fb5d37d20ff5a42fb8.mp3*~data=user_id=0,application_id=42~hmac=fd0a77d12d6899eaa46b405b65061da3225532b0c0fcb6cfd58794f8936a3ea5	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
37	2101635287	Guide Us Home	251	10	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/8/6/0/c86528d735620dd56b6a076a841850e9.mp3?hdnea=exp=1775488879~acl=/api/1/1/c/8/6/0/c86528d735620dd56b6a076a841850e9.mp3*~data=user_id=0,application_id=42~hmac=8e666cadd3f4837d964e05d42bdbbcb216a167402732bfa46ef1aa18a2629e09	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
38	3521612621	bad luck	252	1	https://cdn-images.dzcdn.net/images/cover/dfa4490a0141a17cf9cd4e57a1e81193/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/1/d/0/11d79bce71ad31c6865e9690e60d002b.mp3?hdnea=exp=1775488879~acl=/api/1/1/1/1/d/0/11d79bce71ad31c6865e9690e60d002b.mp3*~data=user_id=0,application_id=42~hmac=aaefa6b84c21664813fc488c0039f19949a4577670dd395770ab05c9f55f3e25	35	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
39	2101635257	Vengeance	230	7	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/a/2/0/3a2b4edae2be6e35fc26949e744f68df.mp3?hdnea=exp=1775488879~acl=/api/1/1/3/a/2/0/3a2b4edae2be6e35fc26949e744f68df.mp3*~data=user_id=0,application_id=42~hmac=a29e826b82f5a157ae3f97a6b2401f7d7167b6ecf5b7429149cf103b234a1e13	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
40	2101635247	Beyond This Road	248	6	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/3/2/0/1320b8dd7d952660c6a64961abd0e416.mp3?hdnea=exp=1775488879~acl=/api/1/1/1/3/2/0/1320b8dd7d952660c6a64961abd0e416.mp3*~data=user_id=0,application_id=42~hmac=5282d764ae5240bf9334ac1ab857edbcb74ae123425f313cc5c4db2c9973235d	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
41	3583314851	It Only Gets Darker	271	1	https://cdn-images.dzcdn.net/images/cover/ba142c155764fa3b9cc52e1be7e43d47/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/c/6/0/ac68a750f045ce51fd2523c188de7877.mp3?hdnea=exp=1775488879~acl=/api/1/1/a/c/6/0/ac68a750f045ce51fd2523c188de7877.mp3*~data=user_id=0,application_id=42~hmac=396b7e8a1ebafce3f15f936c41c735b444e2ee367dbe1ecaad89e7f0daef3ee0	28	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
837	3725729442	Ulrich Wild (Loud Mix)	192	1	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	\N	559	2026-07-09 18:31:24.200409	2026-07-09 18:31:24.200409
838	3725729452	Electro Hurtz (Mix by COMBICHRIST)	292	2	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	\N	559	2026-07-09 18:31:24.200409	2026-07-09 18:31:24.200409
42	909001302	Kill the Ache	233	5	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/7/6/0/476e2bcc9d8b2f4011698e6c96361835.mp3?hdnea=exp=1775488898~acl=/api/1/1/4/7/6/0/476e2bcc9d8b2f4011698e6c96361835.mp3*~data=user_id=0,application_id=42~hmac=60a54969306ad2d41aeda09e1e6a5cfecfa993c88e2283a4bb4da9c9659d1e77	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
43	2101635267	Gone Astray	218	8	https://cdn-images.dzcdn.net/images/cover/ef52dd225b172390fa890a0ef6219f49/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/6/9/0/1698c71440ec5c99669b43ed393b900e.mp3?hdnea=exp=1775488898~acl=/api/1/1/1/6/9/0/1698c71440ec5c99669b43ed393b900e.mp3*~data=user_id=0,application_id=42~hmac=dd83bb43ba6c8c85282391254b71c273d35ee152fef340aabc8f6db571609adb	26	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
44	909001262	Never There	108	1	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/2/2/0/c22ef65c34b13265f3015e2ba40f1f45.mp3?hdnea=exp=1775488898~acl=/api/1/1/c/2/2/0/c22ef65c34b13265f3015e2ba40f1f45.mp3*~data=user_id=0,application_id=42~hmac=60d39d75ccd12406ac5cf352341cec80598ac49f88118f4dddc88e8c3cdace40	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
45	909001292	Monsters	212	4	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/d/9/0/0d9a3bbc4aae7c0f2414295858375228.mp3?hdnea=exp=1775488898~acl=/api/1/1/0/d/9/0/0d9a3bbc4aae7c0f2414295858375228.mp3*~data=user_id=0,application_id=42~hmac=a8e554f3dd42aff4d5b0c17393a69aaa368873637b04646f696cd204ed90fb9d	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
46	909001282	Poverty of Self	205	3	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/9/6/0/d9621169bc759fb4e49ca3e43a3146bb.mp3?hdnea=exp=1775488898~acl=/api/1/1/d/9/6/0/d9621169bc759fb4e49ca3e43a3146bb.mp3*~data=user_id=0,application_id=42~hmac=0e52a4159bab97cede59ca46784e3248ba58590df4d3ca61738793ec93870651	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
47	909001342	Second Skin	225	9	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/c/7/0/3c712a1f9e1d60a1a65b1fa1ff7cad79.mp3?hdnea=exp=1775488917~acl=/api/1/1/3/c/7/0/3c712a1f9e1d60a1a65b1fa1ff7cad79.mp3*~data=user_id=0,application_id=42~hmac=1a6fb191625da3e55bd54eadd92dfd30352075de3474f463cafa1da5c7939f12	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
48	909001322	Origin	244	7	https://cdn-images.dzcdn.net/images/cover/9a6bd773761abeacdd984b81c6e51e1a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/2/1/0/6211870bd230e4ae9f917ad87c369231.mp3?hdnea=exp=1775488917~acl=/api/1/1/6/2/1/0/6211870bd230e4ae9f917ad87c369231.mp3*~data=user_id=0,application_id=42~hmac=e52e4a8adaf3112679eb8c800100a5bea0fd81c5b81497a36302d204545ac920	27	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
49	2165525477	Currents	204	2	https://cdn-images.dzcdn.net/images/cover/8daf580519b7c8255dbca9dd22ad649e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/c/0/0/8c0a15998fa6dd65c51b6a2f7e6dcd69.mp3?hdnea=exp=1775488917~acl=/api/1/1/8/c/0/0/8c0a15998fa6dd65c51b6a2f7e6dcd69.mp3*~data=user_id=0,application_id=42~hmac=e5b3389f49a21d2de2fd3eaf6e284abdaa398f42f776fc881415cea3f4a597c0	46	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
50	659570072	Forget Me	253	7	https://cdn-images.dzcdn.net/images/cover/3e917ac7780ca460f9bc875ba86d6a3c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/9/e/0/f9e51f42de378700fa46c5708dae605a.mp3?hdnea=exp=1775488917~acl=/api/1/1/f/9/e/0/f9e51f42de378700fa46c5708dae605a.mp3*~data=user_id=0,application_id=42~hmac=4f0408fb9d51c82356f02af2941a5fcf669ec38332f06754807d795c938521c1	30	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
51	651515062	Another Life (Instrumental)	204	11	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/e/0/83e66d838ffbe4ae6af0d1d634e8a125.mp3?hdnea=exp=1775488917~acl=/api/1/1/8/3/e/0/83e66d838ffbe4ae6af0d1d634e8a125.mp3*~data=user_id=0,application_id=42~hmac=6a86fe0495568edb0ef9e679fd4d4fd57863720208e5aa92be292b81af0f4e02	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
52	3917470511	Jane!	187	1	https://cdn-images.dzcdn.net/images/cover/a98d324be4c3aefcaebfb81165e46561/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/3/3/0/333f5c48665452c68ae7cf0c208705a4.mp3?hdnea=exp=1775489373~acl=/api/1/1/3/3/3/0/333f5c48665452c68ae7cf0c208705a4.mp3*~data=user_id=0,application_id=42~hmac=6dfa1c20a827c7c7c33e631db878419ad2baa25d4ce2ec22b03fdac0e383e519	60	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
53	13711280	The Diary Of Jane	198	7	https://cdn-images.dzcdn.net/images/cover/3e0cb6bd5522a9be439722a5b54a573c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/e/2/0/8e2f826d46604f23143871b2d025dd53.mp3?hdnea=exp=1775489373~acl=/api/1/1/8/e/2/0/8e2f826d46604f23143871b2d025dd53.mp3*~data=user_id=0,application_id=42~hmac=cb1d5feffe25be56cc04e8b771b4d03702d02ee8384718734d5560490bd423a1	61	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
54	109176426	Makeba	249	8	https://cdn-images.dzcdn.net/images/cover/cc09c2457ce3e1adc3a7a23f93440e59/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/a/6/0/1a64836be22e29ed21108527f7d0178b.mp3?hdnea=exp=1775489373~acl=/api/1/1/1/a/6/0/1a64836be22e29ed21108527f7d0178b.mp3*~data=user_id=0,application_id=42~hmac=0fc834519966f769cb4c9d6e600420b397ebbed42b8897a00a6908ab1d40c163	62	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
55	16501728	We Are Young (feat. Janelle Monáe)	250	3	https://cdn-images.dzcdn.net/images/cover/5f7bd91e2d91ce2d308ee754d6821ff7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/2/c/0/82c08ccf615f63cca82adfe5d7110dd4.mp3?hdnea=exp=1775489373~acl=/api/1/1/8/2/c/0/82c08ccf615f63cca82adfe5d7110dd4.mp3*~data=user_id=0,application_id=42~hmac=95f2df22ca3210a9320d7f74024095db9761761577c3fd6a4df5dd30e1f271b6	63	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
56	3908590391	Jane! (Slowed & reverb)	253	1	https://cdn-images.dzcdn.net/images/cover/47f59221a7b2c8620a84b5028f765fb4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/0/0/0/e00434152a772847e78dc468ca79f987.mp3?hdnea=exp=1775489373~acl=/api/1/1/e/0/0/0/e00434152a772847e78dc468ca79f987.mp3*~data=user_id=0,application_id=42~hmac=16650d59081c7218591225b522ea6ada90e2a15fe452559a03ebb02af9335383	64	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
57	3911708961	Yoga (Copacabana) - Jersey Club Remix	132	1	https://cdn-images.dzcdn.net/images/cover/490f004d8662ae78141721cfbf3a61d9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/8/d/0/28d00609f25b9ac6cd3ed9fc0dd140dc.mp3?hdnea=exp=1775489458~acl=/api/1/1/2/8/d/0/28d00609f25b9ac6cd3ed9fc0dd140dc.mp3*~data=user_id=0,application_id=42~hmac=22b641af100606cbb6dc85ebac63a4cc4be287bcffc66d03708c71b55a95924c	65	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
58	88902735	Run To You	234	3	https://cdn-images.dzcdn.net/images/cover/f5c062034dbbf74f9c158c51ba783871/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/7/0/0/b70aeca529460e68afafd8cc44f2ef76.mp3?hdnea=exp=1775489458~acl=/api/1/1/b/7/0/0/b70aeca529460e68afafd8cc44f2ef76.mp3*~data=user_id=0,application_id=42~hmac=0c2413026afc99f7343f17545eb1d2b4d2d5c6064a91229c682e6856b4c92b58	66	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
59	109176400	Come	162	1	https://cdn-images.dzcdn.net/images/cover/cc09c2457ce3e1adc3a7a23f93440e59/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/9/1/0/a9112d10a0182836b493effe5e4dbc90.mp3?hdnea=exp=1775489458~acl=/api/1/1/a/9/1/0/a9112d10a0182836b493effe5e4dbc90.mp3*~data=user_id=0,application_id=42~hmac=8c03a49f8d11c6475f214bfa42e51096f475a0e3b00c79999351df48bacc35cd	62	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
60	10114381	Porque te vas	201	2	https://cdn-images.dzcdn.net/images/cover/1265eea6e3ffce493b164ede8600d10c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/9/8/0/198f415b1631d793a14f68157b8e7534.mp3?hdnea=exp=1775489458~acl=/api/1/1/1/9/8/0/198f415b1631d793a14f68157b8e7534.mp3*~data=user_id=0,application_id=42~hmac=11699e99a521f34f62c713a5e0f920e2b54f74de98d73f03c69e1736bf933478	67	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
61	3292493231	JANE!	121	1	https://cdn-images.dzcdn.net/images/cover/ef59668c9557860d0e451ee67cfcca87/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/9/d/0/99da96007146fdd092a30920b9ffdf42.mp3?hdnea=exp=1775489458~acl=/api/1/1/9/9/d/0/99da96007146fdd092a30920b9ffdf42.mp3*~data=user_id=0,application_id=42~hmac=d52b6dcb2f0f08aefdff0e082caa1f75729c36edc9d0b4ec26945c2c2d9a1378	68	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
62	3479690961	JANE! (pxiqzes remix - Instrumental)	167	2	https://cdn-images.dzcdn.net/images/cover/ba336cea18b6baf740868c9f7ddc0575/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/3/9/0/d3935b062a3b24f7d35525ea483da825.mp3?hdnea=exp=1775489477~acl=/api/1/1/d/3/9/0/d3935b062a3b24f7d35525ea483da825.mp3*~data=user_id=0,application_id=42~hmac=26f008571eb6664ca2a35048338ad179d05bf1a49afd32c0591fb55f47b07627	69	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
63	588236412	Mary Jane's Last Dance	273	17	https://cdn-images.dzcdn.net/images/cover/fc7a9b132524c63f26a70d26d15cff58/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/1/6/0/61610be60e48ccca2b292d219c9d2186.mp3?hdnea=exp=1775489477~acl=/api/1/1/6/1/6/0/61610be60e48ccca2b292d219c9d2186.mp3*~data=user_id=0,application_id=42~hmac=a98f73d0185b4b7e7d83071c09950ff74279b0918a08006bac3ba80bf8eb8dac	73	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
64	1822997377	Samba de Janeiro (Album Version)	168	2	https://cdn-images.dzcdn.net/images/cover/c7f9d5dc4aa235c3d02bfbea3539152e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/1/8/0/f188ab5167955f445f7e0b279ddd887f.mp3?hdnea=exp=1775489477~acl=/api/1/1/f/1/8/0/f188ab5167955f445f7e0b279ddd887f.mp3*~data=user_id=0,application_id=42~hmac=ef2fe781dc80361c9503b89354179987639c5ca04c7e33e96b8964797635b3d5	74	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
65	1767733437	Watermelon	110	1	https://cdn-images.dzcdn.net/images/cover/341da7e0d8563d91df8c7b8903411a6c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/2/b/0/f2b34395fe1f995bc504f716f4417d0c.mp3?hdnea=exp=1775489477~acl=/api/1/1/f/2/b/0/f2b34395fe1f995bc504f716f4417d0c.mp3*~data=user_id=0,application_id=42~hmac=833b3fd8115f314f6c8cdd36625cdabb33bad3eea36619728a6eaf11edafb3f5	75	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
66	394080362	Plain Jane	173	8	https://cdn-images.dzcdn.net/images/cover/245dba4a2fac1b5be255951d263d6baa/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/a/8/0/4a8b3faf09b42a2e4e3cce632634b234.mp3?hdnea=exp=1775489477~acl=/api/1/1/4/a/8/0/4a8b3faf09b42a2e4e3cce632634b234.mp3*~data=user_id=0,application_id=42~hmac=72e47064d33faa37e9eb2c9be66a632def2b85b4a6258dc45d961dfd290f7ea0	76	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
67	785938	Helena	204	1	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/8/1/0/d814b1850bb92c860c77ab7a7dac1455.mp3?hdnea=exp=1775660543~acl=/api/1/1/d/8/1/0/d814b1850bb92c860c77ab7a7dac1455.mp3*~data=user_id=0,application_id=42~hmac=918771ce068af51c666a0c6a4d8fc62937ebc845cd0dccc3f3f5dcf17a24b819	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
68	785961	I'm Not Okay (I Promise)	188	5	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/a/d/0/bad956c9a980103195570dd248dfb5e8.mp3?hdnea=exp=1775660543~acl=/api/1/1/b/a/d/0/bad956c9a980103195570dd248dfb5e8.mp3*~data=user_id=0,application_id=42~hmac=ba0c24653b0feee294012db03e3ac8fb3916e0b09d9d258054fbf3e629b2f5ca	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
69	785996	Cemetery Drive	188	12	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/4/b/0/34ba3ea718957aa0024cdc05bb767b14.mp3?hdnea=exp=1775660543~acl=/api/1/1/3/4/b/0/34ba3ea718957aa0024cdc05bb767b14.mp3*~data=user_id=0,application_id=42~hmac=c64a9ef4ea5f54f8ee3f711fbe2a73f182baef9dd014885b770cb81eec2318a2	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
70	785948	To the End	181	3	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/8/d/0/68d8202c1b0c15f5bbf21b6236d7a9f5.mp3?hdnea=exp=1775660543~acl=/api/1/1/6/8/d/0/68d8202c1b0c15f5bbf21b6236d7a9f5.mp3*~data=user_id=0,application_id=42~hmac=ac01d5f56619e209533f2400db09f2589a127183f1909600c8efe7baf7855fac	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
71	785965	The Ghost of You	194	6	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/8/2/0/c82c4c11a016263f369dda368448e315.mp3?hdnea=exp=1775660543~acl=/api/1/1/c/8/2/0/c82c4c11a016263f369dda368448e315.mp3*~data=user_id=0,application_id=42~hmac=2bd2e1affb93a0ad0ff84d4d23ba2f2f25b7c23bf956a44b565da64333ccbbfa	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
72	785942	Give 'Em Hell, Kid	138	2	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/7/0/5c75625944c9fcdea83613c304504d4b.mp3?hdnea=exp=1775660962~acl=/api/1/1/5/c/7/0/5c75625944c9fcdea83613c304504d4b.mp3*~data=user_id=0,application_id=42~hmac=2a86f90e440602989d85384bf049b6df0bd9b018591885afb099194ae2eb6b9f	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
73	785955	You Know What They Do to Guys Like Us in Prison	173	4	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/a/6/0/5a6b29aec5552d37289af16055f1517e.mp3?hdnea=exp=1775660962~acl=/api/1/1/5/a/6/0/5a6b29aec5552d37289af16055f1517e.mp3*~data=user_id=0,application_id=42~hmac=9cb382b175f7f9932695aa40aa6b81461aab1dd59a6166d19fcfe506880d01d7	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
74	785970	The Jetset Life Is Gonna Kill You	217	7	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/e/2/0/de2e7cbeb74c9567fc178f8016212cb4.mp3?hdnea=exp=1775660962~acl=/api/1/1/d/e/2/0/de2e7cbeb74c9567fc178f8016212cb4.mp3*~data=user_id=0,application_id=42~hmac=382c124953da4535f8148861e1644f02cf1cf764d62de94dd9af2674e3ce89c7	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
75	785976	Interlude	57	8	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/2/8/0/1280846078fee49400f905fa6e09d790.mp3?hdnea=exp=1775660962~acl=/api/1/1/1/2/8/0/1280846078fee49400f905fa6e09d790.mp3*~data=user_id=0,application_id=42~hmac=9292e65b0b8537f84c016a7b78465983588528544f519eb2dd05598d8bd7bd9e	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
76	785982	Thank You for the Venom	221	9	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/f/5/0/df5c2cfb3cd7a2768435cbabd0460cf2.mp3?hdnea=exp=1775660962~acl=/api/1/1/d/f/5/0/df5c2cfb3cd7a2768435cbabd0460cf2.mp3*~data=user_id=0,application_id=42~hmac=ca0ddd80e21a44a5c02616bdd5f737a20ed1849459ae5822652e237c3b5d06e4	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
77	785985	Hang 'Em High	167	10	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/d/8/0/3d89560f484c8c7a7aa084ad7ae767a6.mp3?hdnea=exp=1775660962~acl=/api/1/1/3/d/8/0/3d89560f484c8c7a7aa084ad7ae767a6.mp3*~data=user_id=0,application_id=42~hmac=797af9e124836add592d4e82f012e2609c60f086c1a50959446462e46606ec34	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
78	785989	It's Not a Fashion Statement, It's a Deathwish	210	11	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/2/7/0/f27babbbae26d29fbd9f725742b06f39.mp3?hdnea=exp=1775660962~acl=/api/1/1/f/2/7/0/f27babbbae26d29fbd9f725742b06f39.mp3*~data=user_id=0,application_id=42~hmac=34e4f00928f9d47859366f1ef988a0ed61fa355bdabe3a7dc36035bb30babff8	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
79	785999	I Never Told You What I Do for a Living	232	13	https://cdn-images.dzcdn.net/images/cover/9aba5b418a311c0bbefb6699ebc58a4b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/1/2/0/c129be6a5773b02a39714812975a937f.mp3?hdnea=exp=1775660962~acl=/api/1/1/c/1/2/0/c129be6a5773b02a39714812975a937f.mp3*~data=user_id=0,application_id=42~hmac=9d1c80f24c0b39fe5f18af1017948a28e8507c5d2f2884c6fd158b2b5eefc6ff	81	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
80	635507082	Буйно голова	128	6	https://cdn-images.dzcdn.net/images/cover/a58946114be7c5b72d7d22517db75c75/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/6/7/0/9676fc25230c865253f5db0355f3b792.mp3?hdnea=exp=1775661876~acl=/api/1/1/9/6/7/0/9676fc25230c865253f5db0355f3b792.mp3*~data=user_id=0,application_id=42~hmac=658f2fdb8b341e14575db505e5e5a511e1b36054813b2d1c81b6d8aa6b927dd0	82	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
81	1155192392	Катяосадча	179	2	https://cdn-images.dzcdn.net/images/cover/9041f2042adec516ba29153a0f762eff/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/5/e/0/05e1784093e8612982764bb470cbe7c5.mp3?hdnea=exp=1775661876~acl=/api/1/1/0/5/e/0/05e1784093e8612982764bb470cbe7c5.mp3*~data=user_id=0,application_id=42~hmac=6fdc1a87d13b4324123249a7ea432ca126a9a64f479b19f6e9a091c1c14dcd67	83	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
82	449163142	1991	261	11	https://cdn-images.dzcdn.net/images/cover/b3832eb004bed8939f5f161436a0d5bc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/7/e/0/d7eaa04aad07618ae8790e3c2b66d6da.mp3?hdnea=exp=1775661876~acl=/api/1/1/d/7/e/0/d7eaa04aad07618ae8790e3c2b66d6da.mp3*~data=user_id=0,application_id=42~hmac=c25742a8a4cae53e57f29bf3c95a401503f95516177c708b68a4754a18b14e64	84	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
83	449163072	Ні хуйні	235	4	https://cdn-images.dzcdn.net/images/cover/b3832eb004bed8939f5f161436a0d5bc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/6/a/0/66ac00932a626dad773aa7fa8572895e.mp3?hdnea=exp=1775661876~acl=/api/1/1/6/6/a/0/66ac00932a626dad773aa7fa8572895e.mp3*~data=user_id=0,application_id=42~hmac=4b3f65d7ae2883add64b5a0a68a29afbcefa27874e05fec30c29324095ed4e78	84	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
84	646080222	Папі тяжело	224	3	https://cdn-images.dzcdn.net/images/cover/ff6df666b18d017795992dbb72d35b9a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/5/0/0/e502445fc84f71f4c5781606fdb7ffb3.mp3?hdnea=exp=1775661876~acl=/api/1/1/e/5/0/0/e502445fc84f71f4c5781606fdb7ffb3.mp3*~data=user_id=0,application_id=42~hmac=c2979ed0fca05829ed1261a4f500962e4fcb3f6b9b30d25ab9887a0130f03162	85	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
85	2833834772	360	133	1	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/d/f/0/6df461a2309db820e650158cee4f0b70.mp3?hdnea=exp=1775661891~acl=/api/1/1/6/d/f/0/6df461a2309db820e650158cee4f0b70.mp3*~data=user_id=0,application_id=42~hmac=fcf2a1bf626229f5229a9366668949fcb5e9a2733b49c487a2673f5844351546	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
86	2833834782	Club classics	153	2	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/b/2/0/8b23a527a2d492b9bf99b548a8cd1f6e.mp3?hdnea=exp=1775661891~acl=/api/1/1/8/b/2/0/8b23a527a2d492b9bf99b548a8cd1f6e.mp3*~data=user_id=0,application_id=42~hmac=293a215ec5917c78a1c050684c15e2581fb12925092ce3e6080209ac6513d851	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
87	2833834792	Sympathy is a knife	151	3	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/d/9/0/5d9ac003a4b42c62b46cf9af1d100b14.mp3?hdnea=exp=1775661891~acl=/api/1/1/5/d/9/0/5d9ac003a4b42c62b46cf9af1d100b14.mp3*~data=user_id=0,application_id=42~hmac=67b564101d7c2bba21f968067725ce91add8861094b22e44d631c7bab06961ec	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
88	2833834802	I might say something stupid	109	4	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/f/3/0/4f310bb564d3ad2d308b5737edf1693d.mp3?hdnea=exp=1775661891~acl=/api/1/1/4/f/3/0/4f310bb564d3ad2d308b5737edf1693d.mp3*~data=user_id=0,application_id=42~hmac=6e434624aa19f5b8eb40b5152cc0ae8d573f7f736a33a835e75446323b69b047	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
89	2833834812	Talk talk	161	5	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/4/d/0/94db203f6e5fb7c11d59f956992a6297.mp3?hdnea=exp=1775661891~acl=/api/1/1/9/4/d/0/94db203f6e5fb7c11d59f956992a6297.mp3*~data=user_id=0,application_id=42~hmac=03216ba338580fe0db612903361e91ea00d0f14b995afae78604bf5f909af7ed	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
90	2833834822	Von dutch	164	6	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/7/a/0/57adc1a4c05fa745f9939adcc9c892b2.mp3?hdnea=exp=1775661891~acl=/api/1/1/5/7/a/0/57adc1a4c05fa745f9939adcc9c892b2.mp3*~data=user_id=0,application_id=42~hmac=6aa477399b55642637e502ef17179c159819de17168b9a1b4d730d36bd8a3641	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
91	2833834832	Everything is romantic	203	7	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/a/2/0/5a28bbb2b30ae70d63217ee4bccbe103.mp3?hdnea=exp=1775661891~acl=/api/1/1/5/a/2/0/5a28bbb2b30ae70d63217ee4bccbe103.mp3*~data=user_id=0,application_id=42~hmac=edfdc29e5b17a830429359a24eaea870a2534934ef314de6ae9926c97d0a5b51	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
92	2833834842	Rewind	168	8	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/2/4/0/a24ba26f5e79f4a57b037140db8b656e.mp3?hdnea=exp=1775661891~acl=/api/1/1/a/2/4/0/a24ba26f5e79f4a57b037140db8b656e.mp3*~data=user_id=0,application_id=42~hmac=01f29680d2f33896da15afefa8557f3599331809fa1b1463dd2a758a8624815d	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
93	2833834852	So I	211	9	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/8/1/0/4814c44aaea2483f636dd299f882cb86.mp3?hdnea=exp=1775661891~acl=/api/1/1/4/8/1/0/4814c44aaea2483f636dd299f882cb86.mp3*~data=user_id=0,application_id=42~hmac=4bbda1d274f868bb1f819f8458804277a4cd83e05bc8341789d110078841e3bb	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
94	2833834862	Girl, so confusing	174	10	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/a/5/0/ca52e8d9eb71f8a0ad027bbf9650ae52.mp3?hdnea=exp=1775661891~acl=/api/1/1/c/a/5/0/ca52e8d9eb71f8a0ad027bbf9650ae52.mp3*~data=user_id=0,application_id=42~hmac=3a153752cde68a95c287cbb08320cc017d75dcdabf8b867405dea69091dec940	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
95	2833834872	Apple	151	11	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/8/6/0/d863ea5f62d2c02d615fc0553835802a.mp3?hdnea=exp=1775661891~acl=/api/1/1/d/8/6/0/d863ea5f62d2c02d615fc0553835802a.mp3*~data=user_id=0,application_id=42~hmac=20edb67baab4a7d7fb353b78cc8f114e34d39da8fd9edfdcf27b51a5faa9e9b5	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
96	2833834882	B2b	178	12	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/2/0/0/f20d10b6971a1d13ca2b637bd08fc04a.mp3?hdnea=exp=1775661891~acl=/api/1/1/f/2/0/0/f20d10b6971a1d13ca2b637bd08fc04a.mp3*~data=user_id=0,application_id=42~hmac=5e62ea39aeaf30710b609eeee70a7a5a03fcaa41f68bb7aa377d474b5e0579b9	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
97	2833834892	Mean girls	189	13	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/d/5/0/6d5bc979c6e5c72c4fb047804440934d.mp3?hdnea=exp=1775661891~acl=/api/1/1/6/d/5/0/6d5bc979c6e5c72c4fb047804440934d.mp3*~data=user_id=0,application_id=42~hmac=f7afdd23e7e6de6aea40af590f2524d0fc324e400d66b47360265f2d0572ddf3	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
98	2833834902	I think about it all the time	135	14	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/b/c/0/cbcdd900dfbfe3c1d1d9b4f73662a49a.mp3?hdnea=exp=1775661891~acl=/api/1/1/c/b/c/0/cbcdd900dfbfe3c1d1d9b4f73662a49a.mp3*~data=user_id=0,application_id=42~hmac=56285e9a14776b1b95385f614ca5749dbf0aeee94854e4ad2c312ef5b0422012	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
99	2833834912	365	203	15	https://cdn-images.dzcdn.net/images/cover/de9e79511cda59914de9add50946e43c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/a/2/0/2a2937c5c088cd18c7e7cb062ea0494c.mp3?hdnea=exp=1775661891~acl=/api/1/1/2/a/2/0/2a2937c5c088cd18c7e7cb062ea0494c.mp3*~data=user_id=0,application_id=42~hmac=6cea4aeffe7ba9a242370313d7671f3f9f4cec640eb23a09852393ac42e04d17	86	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
100	525334532	Losing It	248	1	https://cdn-images.dzcdn.net/images/cover/b62a06ef55ce19c91c67f1ebaa098886/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/a/d/0/7ad87e96efe096d1202a6d294b0ee140.mp3?hdnea=exp=1775662511~acl=/api/1/1/7/a/d/0/7ad87e96efe096d1202a6d294b0ee140.mp3*~data=user_id=0,application_id=42~hmac=2fc2b46f99ba1bbf66ce302f3fa9fbe927ba868f9d3440f3de07962cfd8e9308	91	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
101	574823082	Losing It (Radio Edit)	163	1	https://cdn-images.dzcdn.net/images/cover/ebac3c7a4baff91f789cfdf053a11938/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/c/c/0/1cce1d2025167c08789f5169606af55b.mp3?hdnea=exp=1775662511~acl=/api/1/1/1/c/c/0/1cce1d2025167c08789f5169606af55b.mp3*~data=user_id=0,application_id=42~hmac=d8c6fe1edb02e5dbf9ebd4da2c51cce37cf88565ebc1cc605cbdc34af90a4012	92	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
102	1976497887	Pretend Lovers	194	4	https://cdn-images.dzcdn.net/images/cover/94c1e0e3c65de5f902dba0310454d450/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/c/7/0/dc78329cf1e3fa453a58ccea32beba1f.mp3?hdnea=exp=1775662511~acl=/api/1/1/d/c/7/0/dc78329cf1e3fa453a58ccea32beba1f.mp3*~data=user_id=0,application_id=42~hmac=7b83578504d22e7f4e524a52a9a283ad40b10a68cb31d06838830db40d971f05	93	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
103	3832441491	Love You Right	165	1	https://cdn-images.dzcdn.net/images/cover/c9f019d78cacdcc236a271602f35476d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/a/4/0/ca48fc8c20dd39ebcae4345e38a885d1.mp3?hdnea=exp=1775662511~acl=/api/1/1/c/a/4/0/ca48fc8c20dd39ebcae4345e38a885d1.mp3*~data=user_id=0,application_id=42~hmac=6e78e454fe75fa6e890bde3de8746a3b439fc6813532c829857dc5418b9771d1	94	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
104	3092824611	i cant tell (love my money)	163	1	https://cdn-images.dzcdn.net/images/cover/94e1fd4a4ffcd04b85bcde1e781d5fd3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/3/b/0/13b9a5d68513f1a8ebeafe28087c4201.mp3?hdnea=exp=1775662511~acl=/api/1/1/1/3/b/0/13b9a5d68513f1a8ebeafe28087c4201.mp3*~data=user_id=0,application_id=42~hmac=37f7d17455948080b542fa960ff0994fcf337cf4c3f842e1b7c540a4363f84e2	95	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
105	1141592672	Atomic Vomit	90	1	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/b/4/0/bb4c712b15d1c92b7f54dcaa047d3055.mp3?hdnea=exp=1775662548~acl=/api/1/1/b/b/4/0/bb4c712b15d1c92b7f54dcaa047d3055.mp3*~data=user_id=0,application_id=42~hmac=a85a4a494fbdb7e8ba09315db699e24da4e88a4f8dc9c7cffb4db1ad0a9d04a7	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
106	1141592682	When I	60	2	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/1/1/0/31184f22acea6f34f263586490266bfd.mp3?hdnea=exp=1775662548~acl=/api/1/1/3/1/1/0/31184f22acea6f34f263586490266bfd.mp3*~data=user_id=0,application_id=42~hmac=315a61281588b16726658c73f039b19e116145a7ea31c4cdca7be56f818f20f7	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
107	1141592692	Thats No Fun	161	3	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/0/3/0/a03fa35811e4935200f9e4a94cc5b259.mp3?hdnea=exp=1775662548~acl=/api/1/1/a/0/3/0/a03fa35811e4935200f9e4a94cc5b259.mp3*~data=user_id=0,application_id=42~hmac=d88b771a4666dd4b9f7a36fd77e372b49000148b8b537c99008c4b2d4109bf8d	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
108	1141592702	Cocky Girl	53	4	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/0/0/0/b005552be4ece6f18569c888873f02a4.mp3?hdnea=exp=1775662548~acl=/api/1/1/b/0/0/0/b005552be4ece6f18569c888873f02a4.mp3*~data=user_id=0,application_id=42~hmac=f4b2c1494967338d64d84ba4b6aeb5c3fc5514435aae429987ccae924819c096	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
109	1141592712	Uuuu	90	5	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/f/3/0/3f3029337573f402999ac9be648b9e12.mp3?hdnea=exp=1775662548~acl=/api/1/1/3/f/3/0/3f3029337573f402999ac9be648b9e12.mp3*~data=user_id=0,application_id=42~hmac=861ce91db8c3c7f1533d72e205e50f751b5e6e537166c0a51b5ef70e176f74bd	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
839	3725729462	The Birthday Massacre (Remix with guest vocals by Chibi)	218	3	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	\N	559	2026-07-09 18:31:24.200409	2026-07-09 18:31:24.200409
110	1141592722	Jars of It	144	6	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/8/b/0/28b31b6c5145f0d1aaa965115ea1e9ae.mp3?hdnea=exp=1775662548~acl=/api/1/1/2/8/b/0/28b31b6c5145f0d1aaa965115ea1e9ae.mp3*~data=user_id=0,application_id=42~hmac=91ae22783b80f8af0288b4dc803744e01cd79b545c7baa2b3e3c739359e89dc2	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
111	1141592732	Bars. 16	46	7	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/7/6/0/076445228c4185711d3b61ce59807a2f.mp3?hdnea=exp=1775662548~acl=/api/1/1/0/7/6/0/076445228c4185711d3b61ce59807a2f.mp3*~data=user_id=0,application_id=42~hmac=689f75b811ef38e378b010af5c22c4acfb26e634d376c5ee1822435ef67539d3	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
112	1141592742	Infrunami	178	8	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/1/c/0/61c454327d68c3af19e7f7d5e71be739.mp3?hdnea=exp=1775662548~acl=/api/1/1/6/1/c/0/61c454327d68c3af19e7f7d5e71be739.mp3*~data=user_id=0,application_id=42~hmac=18f1f87f0917059ba0396fc0e389ed61e43f6cc24a14219b99503cdd6291d759	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
113	1141592752	Hummer	71	9	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/8/1/0/a8131190c2ae3cbc2cf148b89c4c4bc4.mp3?hdnea=exp=1775662548~acl=/api/1/1/a/8/1/0/a8131190c2ae3cbc2cf148b89c4c4bc4.mp3*~data=user_id=0,application_id=42~hmac=6fffb605e1c93e735ff511e7910f1d2420830e4278fd2fce4a4a6c4df875a9b5	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
114	1141592762	4real	144	10	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/c/c/0/8cc84ffa0d69f113a3dd1ddb753010f2.mp3?hdnea=exp=1775662548~acl=/api/1/1/8/c/c/0/8cc84ffa0d69f113a3dd1ddb753010f2.mp3*~data=user_id=0,application_id=42~hmac=df93cf0dcce8186826a49fd828a7eb814f58dc077ebe89067fe02cc180a926f9	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
115	1141592772	I Think I Should	99	11	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/1/4/0/f140cce5e9ef5a3b1c6ebc3df49e334f.mp3?hdnea=exp=1775662548~acl=/api/1/1/f/1/4/0/f140cce5e9ef5a3b1c6ebc3df49e334f.mp3*~data=user_id=0,application_id=42~hmac=085de311bb902045d9d0d34bb80faaa3683f6c52bcb792b5b19eaae0be125daf	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
116	1141592782	Daze	72	12	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/7/e/0/17e890319fb0b7065e5fa557784b4bbe.mp3?hdnea=exp=1775662548~acl=/api/1/1/1/7/e/0/17e890319fb0b7065e5fa557784b4bbe.mp3*~data=user_id=0,application_id=42~hmac=9a4f077ca8167926b1eaae70af7ec4922df37ee4c66eeb6b2ff8c7960e350258	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
117	1141592792	Out of Me Head	141	13	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/8/6/0/086ea2027e1e662c23bf6c37cdd39723.mp3?hdnea=exp=1775662548~acl=/api/1/1/0/8/6/0/086ea2027e1e662c23bf6c37cdd39723.mp3*~data=user_id=0,application_id=42~hmac=be4528026ac31d9415703d26025cf3e70303ace507aa94e8de4f3a935ac10a27	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
118	1141592802	Donchano	98	14	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/e/1/0/6e1b966a1ce5ed7b82e26a228bdf8179.mp3?hdnea=exp=1775662548~acl=/api/1/1/6/e/1/0/6e1b966a1ce5ed7b82e26a228bdf8179.mp3*~data=user_id=0,application_id=42~hmac=95a07ac4d747d5d80f33326074888caa0f0c1c61e5fcc4a2942d1097fe9c7b8f	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
119	1141592812	The Song	66	15	https://cdn-images.dzcdn.net/images/cover/aab27852a05351552e9dcacdbb14ec3a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/a/3/0/3a31820817e7206c47bef7753ab8d789.mp3?hdnea=exp=1775662548~acl=/api/1/1/3/a/3/0/3a31820817e7206c47bef7753ab8d789.mp3*~data=user_id=0,application_id=42~hmac=cce4eb8edee22735c531d7b62d1b5e0410e49c4a08673b2d71a402d202625817	96	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
120	651514962	Apnea (Instrumental)	205	1	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/a/a/0/eaa78a3175489e6c1770826cc576828d.mp3?hdnea=exp=1775662920~acl=/api/1/1/e/a/a/0/eaa78a3175489e6c1770826cc576828d.mp3*~data=user_id=0,application_id=42~hmac=49e501950457600bf39ea25f026c6043a5dafc989c249f67671be2cf66554d81	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
121	651514972	Tremor (Instrumental)	199	2	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/6/6/0/166d38e2cb90064aa443f2323572d533.mp3?hdnea=exp=1775662920~acl=/api/1/1/1/6/6/0/166d38e2cb90064aa443f2323572d533.mp3*~data=user_id=0,application_id=42~hmac=745201e03bd27cdd06c2a8e41a28edc4b32f51d7c5dc7a7a2a8b2b2e99e2ea34	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
122	651514982	Night Terrors (Instrumental)	225	3	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/7/2/0/a72c54b47b7a4380263f628455ec3c93.mp3?hdnea=exp=1775662920~acl=/api/1/1/a/7/2/0/a72c54b47b7a4380263f628455ec3c93.mp3*~data=user_id=0,application_id=42~hmac=4093f2b03381fe0884074dfaf5f6ee9468db93cdf07d590d548dd1fb30491a83	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
123	651514992	Delusion (Instrumental)	242	4	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/6/7/0/c675f0f81385cbc1140478e9d0b8aa7e.mp3?hdnea=exp=1775662920~acl=/api/1/1/c/6/7/0/c675f0f81385cbc1140478e9d0b8aa7e.mp3*~data=user_id=0,application_id=42~hmac=679cb23d14158fd1d2515e9ce75320d7bab33f37338198e3487e223e0fdc3920	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
124	651515002	Withered (Instrumental)	226	5	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/c/9/0/3c9e9b4b889aefaee921f66ea8e941ff.mp3?hdnea=exp=1775662920~acl=/api/1/1/3/c/9/0/3c9e9b4b889aefaee921f66ea8e941ff.mp3*~data=user_id=0,application_id=42~hmac=c952c5a3049024771ac12624e03561eb065a6e241ccb378c4cfebe38578a5438	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
125	651515012	Dreamer (Instrumental)	205	6	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/3/d/0/13d77cb3e173c75f9a899566d2aede5e.mp3?hdnea=exp=1775662920~acl=/api/1/1/1/3/d/0/13d77cb3e173c75f9a899566d2aede5e.mp3*~data=user_id=0,application_id=42~hmac=bfbde68397843ef96d11b313f6bf860003e8b3dea57f7fc1ccc2067061f98847	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
126	651515022	Forget Me (Instrumental)	253	7	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/a/0/0/7a09b4426635bc9f7d1d4f9ec39565bc.mp3?hdnea=exp=1775662920~acl=/api/1/1/7/a/0/0/7a09b4426635bc9f7d1d4f9ec39565bc.mp3*~data=user_id=0,application_id=42~hmac=6bcc215a5d77099db731ac3c1b8f63b40d4afeaa896dfe480677a28b31bb8e90	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
1145	3740319452	dog days	118	1	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	\N	623	2026-07-19 08:27:26.992804	2026-07-19 08:27:26.992804
127	651515032	The Place I Feel Safest (Instrumental)	232	8	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/2/0/0/a2073f4e3f4084fdf6ec0d1f63f22017.mp3?hdnea=exp=1775662920~acl=/api/1/1/a/2/0/0/a2073f4e3f4084fdf6ec0d1f63f22017.mp3*~data=user_id=0,application_id=42~hmac=03452a3e74bdf7c368d3998371b1bf7bba5f22798784f2a82c1e699739ec3223	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
128	651515042	Silence (Instrumental)	247	9	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/c/8/0/ec80611abc6a35bedf4d052da955635c.mp3?hdnea=exp=1775662920~acl=/api/1/1/e/c/8/0/ec80611abc6a35bedf4d052da955635c.mp3*~data=user_id=0,application_id=42~hmac=607cc6ba6cdb8b655bc42646eeeb950929db0377a640d74c98d5aabc6bf12808	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
129	651515052	Best Memory (Instrumental)	265	10	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/0/c/0/20c1e1e7b8253e123e397acd1c321e9f.mp3?hdnea=exp=1775662920~acl=/api/1/1/2/0/c/0/20c1e1e7b8253e123e397acd1c321e9f.mp3*~data=user_id=0,application_id=42~hmac=83709b4e4bc49730c2b7d1fe0745056843fcaa9c3378457953d81d6db0bdfba3	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
130	651515072	I'm Not Waiting (Instrumental)	238	12	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/1/d/0/d1d3f1f48163e424dacbce5502863541.mp3?hdnea=exp=1775662920~acl=/api/1/1/d/1/d/0/d1d3f1f48163e424dacbce5502863541.mp3*~data=user_id=0,application_id=42~hmac=e846557b1e2ab759bc772b4bf77e390119a8177bc817736ac5a21add1d27705a	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
131	651515082	Shattered (Instrumental)	277	13	https://cdn-images.dzcdn.net/images/cover/d6feefda415478a52c615c33f733317e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/5/5/0/f55f69e05180bd91d398295e012126c8.mp3?hdnea=exp=1775662920~acl=/api/1/1/f/5/5/0/f55f69e05180bd91d398295e012126c8.mp3*~data=user_id=0,application_id=42~hmac=abc661ace0edaf30bd7ce32ff6518d1bcae21e773ae0ce80e7d6752495ad73cb	31	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
132	2958579561	Роздуми про стиль	213	7	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/f/4/0/5f46ee198ca06c2bd760058543013e0d.mp3?hdnea=exp=1775665838~acl=/api/1/1/5/f/4/0/5f46ee198ca06c2bd760058543013e0d.mp3*~data=user_id=0,application_id=42~hmac=d7c869cd8c6eabc9d4328e8080c0de7dfb2ba486c48666ade63160d4923dcc97	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
133	2958579501	Десять причин	192	1	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/2/0/0/e2064456a3b076dd52261a8ab109da58.mp3?hdnea=exp=1775665838~acl=/api/1/1/e/2/0/0/e2064456a3b076dd52261a8ab109da58.mp3*~data=user_id=0,application_id=42~hmac=3f912965783e167ca52df7c7136118e4460bac1b7bffcb08a8a76b06ff9811c3	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
134	2958579531	Страхом задуває	179	4	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/7/e/0/f7e83523e10a72f695c553a85d35808d.mp3?hdnea=exp=1775665838~acl=/api/1/1/f/7/e/0/f7e83523e10a72f695c553a85d35808d.mp3*~data=user_id=0,application_id=42~hmac=bf6e37583fb84078064249abba0de3e1fc9241404deae8b576c47458c816e60d	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
135	2958579521	Мрії, бажання, плани, цілі	218	3	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/2/5/0/525fdaf9cfe725e88019c15b8026f9c1.mp3?hdnea=exp=1775665838~acl=/api/1/1/5/2/5/0/525fdaf9cfe725e88019c15b8026f9c1.mp3*~data=user_id=0,application_id=42~hmac=128e75389c67a15fcb705d60120000da1406022b45484a896f326795d270711b	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
136	2958579511	Знову на плато	230	2	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/d/3/0/4d3795d7c1ce13dc7a82b665d5ce4a01.mp3?hdnea=exp=1775665838~acl=/api/1/1/4/d/3/0/4d3795d7c1ce13dc7a82b665d5ce4a01.mp3*~data=user_id=0,application_id=42~hmac=472e352b81196e4f0f1d5f69dd80caade0589691a79707aee6a3d6f35d7dada7	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
137	2958579541	Відчайдушно живий	186	5	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/3/1/0/7310cf94a0ebb909ddf039e71044d0ec.mp3?hdnea=exp=1775665879~acl=/api/1/1/7/3/1/0/7310cf94a0ebb909ddf039e71044d0ec.mp3*~data=user_id=0,application_id=42~hmac=ca2d61f19185ec750e4532e3497e76153a00fba7bb8ad47130adac39b6083199	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
138	2958579551	Угу, ага	178	6	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/9/b/0/29b886deb0fcae6b0762e56a81008135.mp3?hdnea=exp=1775665879~acl=/api/1/1/2/9/b/0/29b886deb0fcae6b0762e56a81008135.mp3*~data=user_id=0,application_id=42~hmac=b7dfe0e9c1e7ae51cb966d4dee0e9f0537ad702f5156539326bdf144dfcb3c57	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
139	2958579571	Залишайся вдома	223	8	https://cdn-images.dzcdn.net/images/cover/a50cdb62bc0cf4855f4502b875155e9e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/1/b/0/b1bd4cc3e51edba81f81cad73a204c62.mp3?hdnea=exp=1775665879~acl=/api/1/1/b/1/b/0/b1bd4cc3e51edba81f81cad73a204c62.mp3*~data=user_id=0,application_id=42~hmac=9d765d85cc45933b1de05dadecd7410bd45e149200f49b116ffed8ba3b58c20a	98	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
140	4315389	505	253	12	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/2/9/0/329517eb3334d90587e141ae5ace1f40.mp3?hdnea=exp=1776155070~acl=/api/1/1/3/2/9/0/329517eb3334d90587e141ae5ace1f40.mp3*~data=user_id=0,application_id=42~hmac=a3660877d9073def5a59020148b970dd36b4f6ba0a1bf51b3fa3b91ac510fc63	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
141	4315378	Brianstorm	172	1	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/2/5/0/e25582132cf097d9dc673e7b014404f6.mp3?hdnea=exp=1776155070~acl=/api/1/1/e/2/5/0/e25582132cf097d9dc673e7b014404f6.mp3*~data=user_id=0,application_id=42~hmac=926bd878f82059e5012f170c227beea5f05b3a2a352e415cefc8bcf1f3f8fa7b	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
142	4315382	Fluorescent Adolescent	183	5	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/f/7/0/ef7220044ffe85c636aa2abbe0fafec3.mp3?hdnea=exp=1776155070~acl=/api/1/1/e/f/7/0/ef7220044ffe85c636aa2abbe0fafec3.mp3*~data=user_id=0,application_id=42~hmac=49b6460373a8bffb53f4b37c8ccee6e6d31a559846d10334d70c588ca7db46e1	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
143	4315388	Old Yellow Bricks	193	11	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/f/c/0/6fc715766b06b8fe16731f35364d9f70.mp3?hdnea=exp=1776155070~acl=/api/1/1/6/f/c/0/6fc715766b06b8fe16731f35364d9f70.mp3*~data=user_id=0,application_id=42~hmac=d0d90bacc6605d254f6fc9bd7e4e3bb53e635fbcec135421596ed4289664a2ff	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
144	4315379	Teddy Picker	165	2	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/4/c/0/b4c87092f14eac8d75d4ff94e5383a1b.mp3?hdnea=exp=1776155070~acl=/api/1/1/b/4/c/0/b4c87092f14eac8d75d4ff94e5383a1b.mp3*~data=user_id=0,application_id=42~hmac=3771216e05875571ca1cb92fdcdf14b2fd5510df1bfb90252a17347dc8810708	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
145	4315380	D is for Dangerous	138	3	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/5/e/0/25e8ebc20785ba3c3864a3e81a04109d.mp3?hdnea=exp=1776155133~acl=/api/1/1/2/5/e/0/25e8ebc20785ba3c3864a3e81a04109d.mp3*~data=user_id=0,application_id=42~hmac=faf0eeaeff6e07826d76f6b9abccc4e32feae46090929659280648af398db915	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
146	4315381	Balaclava	171	4	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/4/0/0/540078a0daa7c33814bf430884eacbeb.mp3?hdnea=exp=1776155133~acl=/api/1/1/5/4/0/0/540078a0daa7c33814bf430884eacbeb.mp3*~data=user_id=0,application_id=42~hmac=2d7bdefb613066db2d0f228fe668244b1892e6e0b3daf0b99c7391f0bb6de3a5	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
147	4315383	Only Ones Who Know	184	6	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/1/8/0/918ab5d9a30d4ea15e2883a1679d93be.mp3?hdnea=exp=1776155133~acl=/api/1/1/9/1/8/0/918ab5d9a30d4ea15e2883a1679d93be.mp3*~data=user_id=0,application_id=42~hmac=cc0ba6a6dec3c7d5505d4908f2f54cb6713529c79d21b31bf948d51f03ac1a82	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
148	4315384	Do Me a Favour	209	7	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/d/4/0/7d41de9692128d778ff01badcfb189f8.mp3?hdnea=exp=1776155133~acl=/api/1/1/7/d/4/0/7d41de9692128d778ff01badcfb189f8.mp3*~data=user_id=0,application_id=42~hmac=3e2c3af42dc35102cded658331c6abbc4cec838af106e5c83c6fd073d8da156e	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
149	4315385	This House is a Circus	191	8	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/6/e/0/16e2b8e847a7b2f9f6e2a87b0d5e0199.mp3?hdnea=exp=1776155133~acl=/api/1/1/1/6/e/0/16e2b8e847a7b2f9f6e2a87b0d5e0199.mp3*~data=user_id=0,application_id=42~hmac=846d9fd71f50fb5c42a06bf0a8fd81c81eb11b4c54f2eb78bd6dc13e51e96a0b	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
150	4315386	If You Were There, Beware	276	9	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/4/7/0/e47f0ea56ef4bf03e89e4f91081c03d9.mp3?hdnea=exp=1776155133~acl=/api/1/1/e/4/7/0/e47f0ea56ef4bf03e89e4f91081c03d9.mp3*~data=user_id=0,application_id=42~hmac=e8827db871e11804dbeb7fbc4e50505e103f537c5b72ed477a8b8cc8b11cc651	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
151	4315387	The Bad Thing	145	10	https://cdn-images.dzcdn.net/images/cover/d7a4f9f1af8736457de34f28d50ef496/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/7/d/0/a7d6abe3baf0fd3f0241ff5da4894b63.mp3?hdnea=exp=1776155133~acl=/api/1/1/a/7/d/0/a7d6abe3baf0fd3f0241ff5da4894b63.mp3*~data=user_id=0,application_id=42~hmac=ba9c684e2fe46d4f2dd957e19eec638e4f53b0b3ef6a46fc5827bc33b2d69d7d	99	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
152	3484517561	Death & Romance	314	5	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/7/d/0/b7dd5c43cb2beae7cb6771ebaa52b2a5.mp3?hdnea=exp=1776264833~acl=/api/1/1/b/7/d/0/b7dd5c43cb2beae7cb6771ebaa52b2a5.mp3*~data=user_id=0,application_id=42~hmac=bdc3a48dbf36cc63d96fd32a4bf235150c6948ff6e8200228ce4c6ec57d7d033	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
153	3484517531	Killing Time	233	2	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/2/6/0/226403edea1357ebbaba4f116384ee2f.mp3?hdnea=exp=1776264833~acl=/api/1/1/2/2/6/0/226403edea1357ebbaba4f116384ee2f.mp3*~data=user_id=0,application_id=42~hmac=e5db7b6536d655ba8b662732ccf3dc022c24eef1dca270c1527f8103a656cfd1	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
154	709290882	Pega pega (Participação especial de Jojo Maronttinni) (Ao vivo)	222	17	https://cdn-images.dzcdn.net/images/cover/3ed961d54f9cef26bdf796a991c495a4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/9/a/0/b9a2cb1675184419927cc0ef6a2d1735.mp3?hdnea=exp=1776264833~acl=/api/1/1/b/9/a/0/b9a2cb1675184419927cc0ef6a2d1735.mp3*~data=user_id=0,application_id=42~hmac=d62f7d01e962fd119973ee4645e054ff902fcf1b71c0540d6b2c2047c7fbae29	101	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
155	3484517641	Cry for Me	307	13	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/9/6/0/4960806a9b83dbf840e6fedfc0494255.mp3?hdnea=exp=1776264833~acl=/api/1/1/4/9/6/0/4960806a9b83dbf840e6fedfc0494255.mp3*~data=user_id=0,application_id=42~hmac=c635f63e59be4937ae1d259df38fe0f6a4d3aed5279221286afe455112148086	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
156	3484517521	She Looked Like Me!	193	1	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/c/7/0/3c7c9d0a81efbcc941a9e341fbc63f9c.mp3?hdnea=exp=1776264833~acl=/api/1/1/3/c/7/0/3c7c9d0a81efbcc941a9e341fbc63f9c.mp3*~data=user_id=0,application_id=42~hmac=700d3c89b87fb688c5535d52281f4b69a17cee5c3f6983dc885b1a1698cd5aed	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
157	3484517541	True Blue Interlude	109	3	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/3/5/0/d35822b5013836043adb6280217cc2c0.mp3?hdnea=exp=1776264865~acl=/api/1/1/d/3/5/0/d35822b5013836043adb6280217cc2c0.mp3*~data=user_id=0,application_id=42~hmac=ac3fd08ce323693b2ea87dea03c58854ab0269728490d16043fe61b35478b1ab	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
158	3484517551	Image	212	4	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/1/0/0/310e5c1192a6371e4b84c0ccb050c6be.mp3?hdnea=exp=1776264865~acl=/api/1/1/3/1/0/0/310e5c1192a6371e4b84c0ccb050c6be.mp3*~data=user_id=0,application_id=42~hmac=da592c035049c0a8dd853e20aa4b58bf529530710db5a851e26c64b076439e9d	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
159	3484517571	Fear, Sex	152	6	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/8/7/0/e875c865be0c5ca0f1ff3578857232e5.mp3?hdnea=exp=1776264865~acl=/api/1/1/e/8/7/0/e875c865be0c5ca0f1ff3578857232e5.mp3*~data=user_id=0,application_id=42~hmac=84ee8b3edc1146d6bb67bd20816c9be2bc98dd4f0be2486c2588a0302bc207a1	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
160	3484517581	Vampire in the Corner	202	7	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/6/e/0/96e40fddfef2dfa0cdd97c1b16d4b75a.mp3?hdnea=exp=1776264865~acl=/api/1/1/9/6/e/0/96e40fddfef2dfa0cdd97c1b16d4b75a.mp3*~data=user_id=0,application_id=42~hmac=fbbeed60acd5b9ac0fc4163567ee1fbc71837580d35fc67b213590b3a000e51c	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
161	3484517591	Watching T.V.	245	8	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/e/4/0/8e4b8b0ed630c941c7c0688253d27c04.mp3?hdnea=exp=1776264865~acl=/api/1/1/8/e/4/0/8e4b8b0ed630c941c7c0688253d27c04.mp3*~data=user_id=0,application_id=42~hmac=1c4e422f45b807f5edd567a1f6985b498b00eeedd2da52803d983d501b6e9853	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
162	3484517601	Tunnel Vision	305	9	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/c/1/0/cc1f24eb0d742d0f6310352383f9f074.mp3?hdnea=exp=1776264865~acl=/api/1/1/c/c/1/0/cc1f24eb0d742d0f6310352383f9f074.mp3*~data=user_id=0,application_id=42~hmac=bc6a6a934b207b318cadc0efe71708ed8a9a9b94281bfccbd68764867f5d364d	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
163	3484517611	Love Is Everywhere	194	10	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/5/b/0/45bd38abd591afad66b673856bd0097b.mp3?hdnea=exp=1776264865~acl=/api/1/1/4/5/b/0/45bd38abd591afad66b673856bd0097b.mp3*~data=user_id=0,application_id=42~hmac=67ca133f533d5905934781eb60f5f32b436333e39e65e2bbfba09ae2f8591765	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
164	3484517621	Feeling DiskInserted?	58	11	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/f/3/0/2f31a6d52f2bdda5dd56e55b2023099f.mp3?hdnea=exp=1776264865~acl=/api/1/1/2/f/3/0/2f31a6d52f2bdda5dd56e55b2023099f.mp3*~data=user_id=0,application_id=42~hmac=cc83098106d44dcc385fb0581b518dc8744316d8fdd8f1d5b27731b7836a3135	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
165	3484517631	That's My Floor	209	12	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/8/f/0/88f7de6b62d599d10e8a0d8dd95728ec.mp3?hdnea=exp=1776264865~acl=/api/1/1/8/8/f/0/88f7de6b62d599d10e8a0d8dd95728ec.mp3*~data=user_id=0,application_id=42~hmac=faf408b056b4b471f2a13394abf36b6fde48f0e048fae193586def2b4a23122a	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
166	3484517651	Angel on a Satellite	243	14	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/e/f/0/5ef019322a3e94a0a9dc929e33567c7a.mp3?hdnea=exp=1776264865~acl=/api/1/1/5/e/f/0/5ef019322a3e94a0a9dc929e33567c7a.mp3*~data=user_id=0,application_id=42~hmac=2a927fda234b1d5651203d23c734064cf1ec4dc60453ab27f784565b2bd6c236	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
167	3484517661	The Ballad of Matt & Mica	240	15	https://cdn-images.dzcdn.net/images/cover/c73ab49a506127eace6cd7dddd39fbda/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/d/7/0/9d770176f60c00df65d524683b9460cb.mp3?hdnea=exp=1776264865~acl=/api/1/1/9/d/7/0/9d770176f60c00df65d524683b9460cb.mp3*~data=user_id=0,application_id=42~hmac=f080d11d30e41be5c13b46321885161d2029406fa7f96fe94df59d0dcf9f40c1	100	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
168	2983763921	Welcome To Hell	83	1	https://cdn-images.dzcdn.net/images/cover/f95e3aea3fc53d4191fb658082b62d50/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/5/4/0/a543c1a17892a52242e3e1d3a0c5a84c.mp3?hdnea=exp=1776325105~acl=/api/1/1/a/5/4/0/a543c1a17892a52242e3e1d3a0c5a84c.mp3*~data=user_id=0,application_id=42~hmac=60687141ab3323ea09e75ab72228ff850fc0918ac90f8002ddc3d070cbf20cee	102	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
169	3768947302	WELCOME TO HELL	209	1	https://cdn-images.dzcdn.net/images/cover/aa1638d9c12ebdf46f50fcabba1d5c84/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/2/b/0/b2b79301f7c51a8afee7c107fb72c3d7.mp3?hdnea=exp=1776325105~acl=/api/1/1/b/2/b/0/b2b79301f7c51a8afee7c107fb72c3d7.mp3*~data=user_id=0,application_id=42~hmac=0cb4d76d3bf253be2e4399320da2e654a697fa870b1aeb7a3dc373422694a02b	103	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
170	495700592	Welcome to Hell	262	2	https://cdn-images.dzcdn.net/images/cover/f7c0aafb90922643da37b071837f65f1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/7/d/0/27d0177733fd94488c1cbbd3fc026026.mp3?hdnea=exp=1776325105~acl=/api/1/1/2/7/d/0/27d0177733fd94488c1cbbd3fc026026.mp3*~data=user_id=0,application_id=42~hmac=05b6f41c1b23ed2b0270d1f986ead4394b62599474cf50aee2a7de1b2779e4d6	104	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
171	623736442	Welcome To Hell	116	10	https://cdn-images.dzcdn.net/images/cover/c6a0130589841326372ac87c6924ed65/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/7/b/0/37bc72958d56faafcab65f0f9f47dccd.mp3?hdnea=exp=1776325105~acl=/api/1/1/3/7/b/0/37bc72958d56faafcab65f0f9f47dccd.mp3*~data=user_id=0,application_id=42~hmac=c98b73ee670063a138111a89c35e32d297cebfdf74aaa2b9d49a1e0777d8d519	105	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
172	11655106	Welcome To Hell	250	1	https://cdn-images.dzcdn.net/images/cover/97cc90f60a0106e49d67e92b4ceb65b1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/b/b/0/1bbd77362170c30f41826a3d9ffe04e4.mp3?hdnea=exp=1776325105~acl=/api/1/1/1/b/b/0/1bbd77362170c30f41826a3d9ffe04e4.mp3*~data=user_id=0,application_id=42~hmac=51f2a8d6de016cd51bd4c729650f8271753aa97a235bcf68fb688b948be420ca	106	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
173	2983763931	Welcome To Hell (Sped Up)	75	2	https://cdn-images.dzcdn.net/images/cover/f95e3aea3fc53d4191fb658082b62d50/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/a/4/0/1a4d274ed7ea2a3100d54b4692a71ed3.mp3?hdnea=exp=1776325125~acl=/api/1/1/1/a/4/0/1a4d274ed7ea2a3100d54b4692a71ed3.mp3*~data=user_id=0,application_id=42~hmac=f8824e06eb9a1f87db84e767ab0d49ac144ee5604b1fb1165f826a2a5664227b	102	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
174	2983763941	Welcome To Hell (Slowed Down)	93	3	https://cdn-images.dzcdn.net/images/cover/f95e3aea3fc53d4191fb658082b62d50/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/b/0/0/2b0042cf41cb3d5b720b602b0bcafe82.mp3?hdnea=exp=1776325125~acl=/api/1/1/2/b/0/0/2b0042cf41cb3d5b720b602b0bcafe82.mp3*~data=user_id=0,application_id=42~hmac=284186a35fdfe888057fef9b4b2d5183e4a3c66ee3607bb52cc734de6a5f29a6	102	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
175	5093604	This Charming Man (Single Version; 2008 Remaster)	163	2	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/b/8/0/cb836f510f8aa8c754947b692d480df5.mp3?hdnea=exp=1776326954~acl=/api/1/1/c/b/8/0/cb836f510f8aa8c754947b692d480df5.mp3*~data=user_id=0,application_id=42~hmac=f03aa74d2468afb53a58283be3c476faa196252eb0543ec491eb5699a29a1e0b	107	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
176	13786035	This Charming Man (John Peel Session 14/09/83)	163	4	https://cdn-images.dzcdn.net/images/cover/75ba5f16ccf6284d129a7fe837220e5a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/9/3/0/2936c35af17372e7a42345d8db0d8cd4.mp3?hdnea=exp=1776326954~acl=/api/1/1/2/9/3/0/2936c35af17372e7a42345d8db0d8cd4.mp3*~data=user_id=0,application_id=42~hmac=60f6efdc5a07f2ab618fabda5dcafaf8ef38ce85ddb31bed1a60598a8dc0da12	108	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
177	5093628	This Charming Man (New York Vocal; 2008 Remaster)	336	26	https://cdn-images.dzcdn.net/images/cover/d1005397b8a3a743fb0c8aad35f42db3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/7/9/0/7796ea38c0af54f92c8bdb32623d634b.mp3?hdnea=exp=1776326954~acl=/api/1/1/7/7/9/0/7796ea38c0af54f92c8bdb32623d634b.mp3*~data=user_id=0,application_id=42~hmac=8dbb0e4fed2d4fa813e451a75efa40b9ce6dc5b2d3b20bb64d383bb22797043e	107	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
178	2522230851	This Charming Man	200	13	https://cdn-images.dzcdn.net/images/cover/73af771a84c36b6b892ba801f7c9fec8/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/4/9/0/5491d1a0ecbef7cbc22a823cecb02919.mp3?hdnea=exp=1776326954~acl=/api/1/1/5/4/9/0/5491d1a0ecbef7cbc22a823cecb02919.mp3*~data=user_id=0,application_id=42~hmac=4b0a5431b510ef025f2139f433fffde23426d080eceb9b4656d77abe5a2d9e63	109	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
179	3805786232	This Charming Man (Live)	185	5	https://cdn-images.dzcdn.net/images/cover/46bbbb94213c6cafd2730a2ddfc29025/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/c/7/0/cc7c1d05cd4b660753225e63d0199aee.mp3?hdnea=exp=1776326954~acl=/api/1/1/c/c/7/0/cc7c1d05cd4b660753225e63d0199aee.mp3*~data=user_id=0,application_id=42~hmac=409d02a159060da652daa4739a8ec4b36d1231bdba32796fbb3d365e38fec452	110	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
180	2622563192	hades in the dead of winter	331	3	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/a/d/0/cad90873653e334b2bdd8669ba4c9f18.mp3?hdnea=exp=1776459429~acl=/api/1/1/c/a/d/0/cad90873653e334b2bdd8669ba4c9f18.mp3*~data=user_id=0,application_id=42~hmac=2f91df8f9d0e2ccf640966d856825f7e7030c2f3903b77dfad79fa99828a2aec	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
181	2622563172	kanojo ga tsumetaku warattara (prologue to the nine stages of change at the deceased remains)	274	1	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/1/b/0/01b84afc69fc2f9ce2346e9c31fa5bbc.mp3?hdnea=exp=1776459451~acl=/api/1/1/0/1/b/0/01b84afc69fc2f9ce2346e9c31fa5bbc.mp3*~data=user_id=0,application_id=42~hmac=23f5e13a2f0f982f305117fc3054c16a613376344e7f288f9b3032b28a65694d	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
182	2622563182	te wo futte	227	2	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/f/4/0/8f4e86abc71d4c7c6cc8b4f4fa6be7d5.mp3?hdnea=exp=1776459451~acl=/api/1/1/8/f/4/0/8f4e86abc71d4c7c6cc8b4f4fa6be7d5.mp3*~data=user_id=0,application_id=42~hmac=55cb4a3160069ec9b584f7de61b0a1aeaef738dd71e7ce84f002761f517a3165	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
183	2622563202	danke	272	4	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/b/b/0/4bbe9a8ec7e27d173788841f44a08bf1.mp3?hdnea=exp=1776459451~acl=/api/1/1/4/b/b/0/4bbe9a8ec7e27d173788841f44a08bf1.mp3*~data=user_id=0,application_id=42~hmac=ec6de6bde93b691532202190e78f75749bf594a5c6218e9b621cdb0eeaffe293	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
184	2622563212	Hong Kong Police	241	5	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/b/0/83b38d3ca4d0937027e84a65dfbe39a5.mp3?hdnea=exp=1776459451~acl=/api/1/1/8/3/b/0/83b38d3ca4d0937027e84a65dfbe39a5.mp3*~data=user_id=0,application_id=42~hmac=6ab2e7e80ba12f43f195bb6ba428a0a39d61296b5f884526792e254bb34eb517	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
185	2622563222	I think about Mary Poppins	396	6	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/b/0/0/1b0d3b34b5ea01338bc1225a97d2b99d.mp3?hdnea=exp=1776459451~acl=/api/1/1/1/b/0/0/1b0d3b34b5ea01338bc1225a97d2b99d.mp3*~data=user_id=0,application_id=42~hmac=9373907b5daea00e8f3594cfc1550a98474f847c24e63920dfb820ec7ea2ff51	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
186	2622563232	incarnation of pessimism	297	7	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/7/f/0/c7f2bd895bfd34bf655ca69e0a5c5411.mp3?hdnea=exp=1776459451~acl=/api/1/1/c/7/f/0/c7f2bd895bfd34bf655ca69e0a5c5411.mp3*~data=user_id=0,application_id=42~hmac=b3fc317b62446818d563b454555c9e055d1114ea6cd52dff578f08a6ebd96116	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
187	2622563242	kanojo ga atsukute kusattara	270	8	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/a/2/0/ea20c132d1c48208fc54183bbfdc1922.mp3?hdnea=exp=1776459451~acl=/api/1/1/e/a/2/0/ea20c132d1c48208fc54183bbfdc1922.mp3*~data=user_id=0,application_id=42~hmac=9324491265220fd2c461047442f7a11817463050f87d8806f284cd35bcd68fe2	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
188	2622563252	yurikago kara hakaba made	224	9	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/3/8/0/f38b2b1dcccfec289943fc992db3a577.mp3?hdnea=exp=1776459451~acl=/api/1/1/f/3/8/0/f38b2b1dcccfec289943fc992db3a577.mp3*~data=user_id=0,application_id=42~hmac=6af198fc16c8ac6a7f7d5c2d820d346e9f8254a74a2a718cfa6bb18549915f23	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
189	2622563262	hakuiki (the last stage of change at the deceased remains)	389	10	https://cdn-images.dzcdn.net/images/cover/a0eb6f9ab40568a0107127d3f2eaf00e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/2/7/0/c274a9614cec7947d1f9a11c1147e40b.mp3?hdnea=exp=1776459451~acl=/api/1/1/c/2/7/0/c274a9614cec7947d1f9a11c1147e40b.mp3*~data=user_id=0,application_id=42~hmac=99c71ce51feaaac22d43716b7a1b6aec8755c34867230abce5c4810ff6259917	116	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
190	680414	Kill All Your Friends	268	3	https://cdn-images.dzcdn.net/images/cover/a9d3a79ddc4e2f6da7896eb571929b6d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/1/5/0/e154a614f4e60c0890c19daa18cf49dd.mp3?hdnea=exp=1776587519~acl=/api/1/1/e/1/5/0/e154a614f4e60c0890c19daa18cf49dd.mp3*~data=user_id=0,application_id=42~hmac=ed070cdfda24661b6a7e78af9b00b19f41db1c555e9aa16b939c7b3b191add00	117	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
191	132357594	Kill All Your Friends (Live Demo)	262	16	https://cdn-images.dzcdn.net/images/cover/2914a662dd00f96969cd3ee6a3330663/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/5/8/0/f584c2164d03b7ef1d36b91d4c05f238.mp3?hdnea=exp=1776587519~acl=/api/1/1/f/5/8/0/f584c2164d03b7ef1d36b91d4c05f238.mp3*~data=user_id=0,application_id=42~hmac=c69d8cdd38bdad4b6ef4ea958bdb6852cd22838cb12dbd674e757f0ed2ffccd5	118	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
192	1962827927	Kill All Your Friends	248	1	https://cdn-images.dzcdn.net/images/cover/d41572b0f17fe6e87cd5d10d9e8f8d5e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/9/b/0/09be917c9d34ea75d598ce7c91b17c5e.mp3?hdnea=exp=1776587519~acl=/api/1/1/0/9/b/0/09be917c9d34ea75d598ce7c91b17c5e.mp3*~data=user_id=0,application_id=42~hmac=bf274fff3818db635fbceecf3a7701118f8b305c848673bda69d719659c8c1f5	119	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
193	2744290001	Kill All Your Friends	69	2	https://cdn-images.dzcdn.net/images/cover/e86f6718a371a55edc92d051ff63b46f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/f/a/0/5faa2fbe943e5c1fa68c7d8079ed802a.mp3?hdnea=exp=1776587519~acl=/api/1/1/5/f/a/0/5faa2fbe943e5c1fa68c7d8079ed802a.mp3*~data=user_id=0,application_id=42~hmac=e59adde4256dda206f3598298f1351ec59a8ed7fbcf4372e054049ce23fa899f	120	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
194	6776494	Kill All Your Friends	110	5	https://cdn-images.dzcdn.net/images/cover/2f2d9c303f69d7d7640fbce90eb08aa4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/b/5/0/db51cd3be436234b116171e9a12bc38f.mp3?hdnea=exp=1776587519~acl=/api/1/1/d/b/5/0/db51cd3be436234b116171e9a12bc38f.mp3*~data=user_id=0,application_id=42~hmac=546090fcf888b458c75102bf591f0a06329839fedb62e4e53389ffcb83fe9cda	121	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
195	2851583222	Sex appeal	207	4	https://cdn-images.dzcdn.net/images/cover/3038277946aa748dccecb0d6127e4863/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/c/8/0/4c82ed7935eb08d67e4fb8e5e8d36cf1.mp3?hdnea=exp=1776595044~acl=/api/1/1/4/c/8/0/4c82ed7935eb08d67e4fb8e5e8d36cf1.mp3*~data=user_id=0,application_id=42~hmac=c32dd0713be003ee3c3b4f9d26cf591b80433352a8ea2f55f45c51f5db54af38	122	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
196	2843813942	Rachida a bien regardé	196	1	https://cdn-images.dzcdn.net/images/cover/389d61c2d5155b36df04457b78816503/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/b/0/0/1b0dc98a8faa57dc563520ef659fdd4f.mp3?hdnea=exp=1776595044~acl=/api/1/1/1/b/0/0/1b0dc98a8faa57dc563520ef659fdd4f.mp3*~data=user_id=0,application_id=42~hmac=b703c93e5291eff761abfc251aaa0846f20fee7385a7c387ebe676ef611d3452	123	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
197	2843357552	Distraction	245	10	https://cdn-images.dzcdn.net/images/cover/4ab54fbc5c58c2531bd9d4737597e068/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/2/4/0/a2429562cae3424c251dde2fb21400f6.mp3?hdnea=exp=1776595044~acl=/api/1/1/a/2/4/0/a2429562cae3424c251dde2fb21400f6.mp3*~data=user_id=0,application_id=42~hmac=c05521a2ed697529980d6551f4ab7b7744f1cc425472a3ffabc5afa179574185	124	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
198	2843357352	La fille à la tête de dinde	184	7	https://cdn-images.dzcdn.net/images/cover/e08e4747cb5b5fba4092a4e54f3ac23a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/6/8/0/8684e7a9f1fe195ddc417ec8182b2b0d.mp3?hdnea=exp=1776595044~acl=/api/1/1/8/6/8/0/8684e7a9f1fe195ddc417ec8182b2b0d.mp3*~data=user_id=0,application_id=42~hmac=b9934465bb472bb7f5d39038724735a168edf06aeddeece03709351fc4c57b0f	125	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
199	2843814242	Rien à foutre	209	11	https://cdn-images.dzcdn.net/images/cover/88676ed155c420f68532e0c4004c3b1d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/d/a/0/3da9fe749880972c16e243dc25b6ce44.mp3?hdnea=exp=1776595044~acl=/api/1/1/3/d/a/0/3da9fe749880972c16e243dc25b6ce44.mp3*~data=user_id=0,application_id=42~hmac=639a20d3be3d7e7514c3a14480de6957d3bbdc82e68f228a185c6c47721addf1	126	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
200	2843357482	Tu Dégages	216	3	https://cdn-images.dzcdn.net/images/cover/4ab54fbc5c58c2531bd9d4737597e068/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/9/0/0/290329a4d2a600ef7e90f1c194a9030b.mp3?hdnea=exp=1776868173~acl=/api/1/1/2/9/0/0/290329a4d2a600ef7e90f1c194a9030b.mp3*~data=user_id=0,application_id=42~hmac=254279dae26b203e912c549f3407c573c90f22d4121701d20e9f8b09724b9e06	124	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
201	2856987432	Calvaire (Fräulein Warrior Version)	261	16	https://cdn-images.dzcdn.net/images/cover/1c65745eec23e4f5d1cc2056fc9e9517/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/3/a/0/a3ac454ca7cb91aa8fdf11877493d1ad.mp3?hdnea=exp=1776868173~acl=/api/1/1/a/3/a/0/a3ac454ca7cb91aa8fdf11877493d1ad.mp3*~data=user_id=0,application_id=42~hmac=a4080daa3e7c249c0e5d21926fba64a6dd6fbd6e9b869eabb0077305c82f4403	127	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
202	2843357492	L'Idole Des Connes	205	4	https://cdn-images.dzcdn.net/images/cover/4ab54fbc5c58c2531bd9d4737597e068/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/6/3/0/663cdfa7044741bbfe9962508e1a92b4.mp3?hdnea=exp=1776868173~acl=/api/1/1/6/6/3/0/663cdfa7044741bbfe9962508e1a92b4.mp3*~data=user_id=0,application_id=42~hmac=067bebf6a99d5f7df8f44c91333b4636b65c0e9e5403aafadf08b27a775305dc	124	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
203	65440513	80's Comedown Machine	298	5	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/6/1/0/561df715ab47e0a1221012d325a87eb1.mp3?hdnea=exp=1776868196~acl=/api/1/1/5/6/1/0/561df715ab47e0a1221012d325a87eb1.mp3*~data=user_id=0,application_id=42~hmac=daa93ff46a3e80cc1f6758e6124e099d53be617bd944cdb891f037eb9e02ac54	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
204	2948434851	Comedown	217	3	https://cdn-images.dzcdn.net/images/cover/642e107e1b653c0f64329db0e7d6e1f1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/1/8/0/218d4a8e2332f13cae56bf13596ea95a.mp3?hdnea=exp=1776868196~acl=/api/1/1/2/1/8/0/218d4a8e2332f13cae56bf13596ea95a.mp3*~data=user_id=0,application_id=42~hmac=65e116397293b24f301c3a264bdf00a942b2f7b238a9215a50e0864fa9ebaa1d	129	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
205	1799072177	The Final Comedown (2012 Remaster)	127	11	https://cdn-images.dzcdn.net/images/cover/f15c4ac33721aaab4905e052dca5c09a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/0/0/0/f006fd449180bc80f69da9cf8d038f50.mp3?hdnea=exp=1776868196~acl=/api/1/1/f/0/0/0/f006fd449180bc80f69da9cf8d038f50.mp3*~data=user_id=0,application_id=42~hmac=7e6b3fa8114ecb52fc529d4b03699a7aa6f090cc832a22266976d216a17f242e	130	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
207	65440511	One Way Trigger	242	3	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/2/9/0/629b855a83a181c8ee0386ff50e36067.mp3?hdnea=exp=1776868196~acl=/api/1/1/6/2/9/0/629b855a83a181c8ee0386ff50e36067.mp3*~data=user_id=0,application_id=42~hmac=0b8cbd5970cb422fec0e0b8372843cce410a71579565e6444e85e2b52c1a90cf	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
208	65440510	All The Time	181	2	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/a/0/0/aa0d49cac9c3d316c836d325bed82c6d.mp3?hdnea=exp=1776868242~acl=/api/1/1/a/a/0/0/aa0d49cac9c3d316c836d325bed82c6d.mp3*~data=user_id=0,application_id=42~hmac=fa5f2df60a82567ead203dd73edb659ea165657de46576a69f0c36f5d1cc685d	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
209	65440512	Welcome To Japan	230	4	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/1/8/0/018ca20c2b82e542db7855f162a94201.mp3?hdnea=exp=1776868242~acl=/api/1/1/0/1/8/0/018ca20c2b82e542db7855f162a94201.mp3*~data=user_id=0,application_id=42~hmac=e43dd1a8813ed77de994d1071046a6702b8b3f15d9646ff1334e1d2a89575223	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
210	65440514	50/50	163	6	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/4/b/0/54bf2a2462874ce95f34b8c1d59e936a.mp3?hdnea=exp=1776868242~acl=/api/1/1/5/4/b/0/54bf2a2462874ce95f34b8c1d59e936a.mp3*~data=user_id=0,application_id=42~hmac=295343f9d494252b2c2bafbcb8fa6f782b90f318b7947eeab6781fce606de8fc	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
211	65440515	Slow Animals	260	7	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/9/9/0/9996898c45dff124f241f733cfa90d49.mp3?hdnea=exp=1776868242~acl=/api/1/1/9/9/9/0/9996898c45dff124f241f733cfa90d49.mp3*~data=user_id=0,application_id=42~hmac=ed79a422373486acf1c4f109ea31af1a2ea43f193e6c02ba9a50d8d2196d744d	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
212	65440516	Partners In Crime	201	8	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/2/4/0/824a59768bf6e4c874ddc8a3f745e5dc.mp3?hdnea=exp=1776868242~acl=/api/1/1/8/2/4/0/824a59768bf6e4c874ddc8a3f745e5dc.mp3*~data=user_id=0,application_id=42~hmac=2926de27efaffa656a88baed3e456a27422a3694bca1291ce95837c8479daa08	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
213	65440517	Chances	216	9	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/7/4/0/b74362a61cf3af63b7a7bbac31be1181.mp3?hdnea=exp=1776868242~acl=/api/1/1/b/7/4/0/b74362a61cf3af63b7a7bbac31be1181.mp3*~data=user_id=0,application_id=42~hmac=3191bee41d99394f11e28676a6a5dc2eea123ba8a1a4238b0f6ffd30b4718cf7	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
214	65440518	Happy Ending	172	10	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/d/4/0/fd4d10468fa45992195a01a6c7006e87.mp3?hdnea=exp=1776868242~acl=/api/1/1/f/d/4/0/fd4d10468fa45992195a01a6c7006e87.mp3*~data=user_id=0,application_id=42~hmac=da61e1ac2b87c69e1e19a45c6e2390e62933ca84a069da169112a4bea783b399	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
215	65440519	Call It Fate, Call It Karma	204	11	https://cdn-images.dzcdn.net/images/cover/7f392e337f26190c66eb03f9135c7592/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/0/1/0/401216800c39af26151e36e26f3f7d2a.mp3?hdnea=exp=1776868242~acl=/api/1/1/4/0/1/0/401216800c39af26151e36e26f3f7d2a.mp3*~data=user_id=0,application_id=42~hmac=39370149355a63119e754b6cfa39224b0df4b87fdb270b3819266b65e2b84654	128	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
216	1223180592	Моргенштерн	165	6	https://cdn-images.dzcdn.net/images/cover/67f7b4cd51f156f7c1c52d58c5c31f73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/5/1/0/5510e6d5c47799a812d241325783f642.mp3?hdnea=exp=1777141876~acl=/api/1/1/5/5/1/0/5510e6d5c47799a812d241325783f642.mp3*~data=user_id=0,application_id=42~hmac=d938836b7557b16078ff6b83f8c98dbca3b1fef079b00b3d9d50404ab67a3726	131	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
218	1711271137	Моргенштерн Скриптонит Легенда	85	1	https://cdn-images.dzcdn.net/images/cover/94dec43c964e781771ad64db6f99a606/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/3/6/0/33682d2b57037330d1f1285f02a8d9ce.mp3?hdnea=exp=1777141876~acl=/api/1/1/3/3/6/0/33682d2b57037330d1f1285f02a8d9ce.mp3*~data=user_id=0,application_id=42~hmac=172fcc4a1546cf2bdf7923866d7e28da5b6925029d162c5fab644b1a85287869	133	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
219	1915441187	Париж	161	4	https://cdn-images.dzcdn.net/images/cover/b4e91b49db8c3414b79a876a9f95eddc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/9/8/0/698145a0e22ffc59ef4292f412c0a1dd.mp3?hdnea=exp=1777141876~acl=/api/1/1/6/9/8/0/698145a0e22ffc59ef4292f412c0a1dd.mp3*~data=user_id=0,application_id=42~hmac=15d2b30fcd2b9a0d804fcc853b1f6dd30bdfd27cb90fa17fb65cedbc9ef7f897	134	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
220	1915441157	Влюблино	181	1	https://cdn-images.dzcdn.net/images/cover/b4e91b49db8c3414b79a876a9f95eddc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/d/4/0/7d46a96242e2a64f15b40acda7084231.mp3?hdnea=exp=1777141876~acl=/api/1/1/7/d/4/0/7d46a96242e2a64f15b40acda7084231.mp3*~data=user_id=0,application_id=42~hmac=be27b646576c74daa26c0625ac4e73d98b5e97b93ddb24dff47a8cc9d60a0483	134	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
221	91637094	Каділак	172	6	https://cdn-images.dzcdn.net/images/cover/c7165e46aa6d7aa3c92757b365be7163/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/e/4/0/be429038f2fe3b5ab17b7f82665dddb7.mp3?hdnea=exp=1777141886~acl=/api/1/1/b/e/4/0/be429038f2fe3b5ab17b7f82665dddb7.mp3*~data=user_id=0,application_id=42~hmac=201c5cbc0b7209f541d9a2e54381178f2502bca18179a5551d065a192f13273f	135	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
222	1460426482	Чёрный пистолет	96	1	https://cdn-images.dzcdn.net/images/cover/86ade36185b70796396bbd002ad5a174/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/2/7/0/8270c8c916e1d535a64e84f772eab011.mp3?hdnea=exp=1777141886~acl=/api/1/1/8/2/7/0/8270c8c916e1d535a64e84f772eab011.mp3*~data=user_id=0,application_id=42~hmac=408079147ec67e670fe6c8ae8f637b128de2f282e8e709e7473a321defd5b255	136	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
223	970503272	Кадилакта	161	4	https://cdn-images.dzcdn.net/images/cover/a1de0bbb791d4e1407d14439b71e880c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/f/a/0/0fa453a80dd46106d3485c70ffe16798.mp3?hdnea=exp=1777141886~acl=/api/1/1/0/f/a/0/0fa453a80dd46106d3485c70ffe16798.mp3*~data=user_id=0,application_id=42~hmac=f415099b09e1b27956549db38b8a0dd198d339185a6fa86a471bb74902c31b35	137	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
224	1091848082	Кандалакша-56	151	43	https://cdn-images.dzcdn.net/images/cover/fcd07825439ba60c21dc5f65a609c4a5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/2/4/0/e243593beb962c1b1641e00ffaef2af6.mp3?hdnea=exp=1777141886~acl=/api/1/1/e/2/4/0/e243593beb962c1b1641e00ffaef2af6.mp3*~data=user_id=0,application_id=42~hmac=948880a9a3cc1dad00469f27d5643a438443d49aeb3c7de1c82b2bba0f1ae756	138	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
225	100699218	Кандалакша	251	7	https://cdn-images.dzcdn.net/images/cover/413fc962453a267876a70867bc8e3745/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/3/e/0/c3e781c286dfd23b9001286857a8e8e5.mp3?hdnea=exp=1777141886~acl=/api/1/1/c/3/e/0/c3e781c286dfd23b9001286857a8e8e5.mp3*~data=user_id=0,application_id=42~hmac=8897b045d3bcce6d3f69f46fe16faf719f57a462d29b9bbe112174eb9722f591	139	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
226	2969992851	Thing	234	1	https://cdn-images.dzcdn.net/images/cover/8bfd83468fea6807d6957e94d1175fc5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/0/e/0/70e3c21205c60c8085a659291acaf13a.mp3?hdnea=exp=1777141964~acl=/api/1/1/7/0/e/0/70e3c21205c60c8085a659291acaf13a.mp3*~data=user_id=0,application_id=42~hmac=9627020380d8d73b3d9f016d536eb177c0be15c9fbaecc55996ba8d69b954966	148	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
227	946048	Fistful Of Love	351	7	https://cdn-images.dzcdn.net/images/cover/ff7e1ca71724a860608a7bf92efd3cf0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/e/e/0/7eee9c548f03f408f1b2f2d9004bf829.mp3?hdnea=exp=1777141964~acl=/api/1/1/7/e/e/0/7eee9c548f03f408f1b2f2d9004bf829.mp3*~data=user_id=0,application_id=42~hmac=d83bbf680156c54f912283fa3c3db65cde84607c43f6cbac7544b2ba12105668	149	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
228	1743658157	Fall in Love with You.	132	1	https://cdn-images.dzcdn.net/images/cover/64afd24464c9ccfffe458b715aae28f5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/d/9/0/fd9b33a9bc11de6246afe3936b596de2.mp3?hdnea=exp=1777141964~acl=/api/1/1/f/d/9/0/fd9b33a9bc11de6246afe3936b596de2.mp3*~data=user_id=0,application_id=42~hmac=96363083be045a2c5685e8ea00376aecde7d2da506ca6e9f06ee4c76c767dd47	97	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
229	1518058732	Whatever People Say That I Am (That's What I'm Not)	277	6	https://cdn-images.dzcdn.net/images/cover/bb3c5ccc889400510e747a5e52a5a2aa/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/b/3/0/8b379b7b5ccaf0fb4334d7d5ca199597.mp3?hdnea=exp=1777141982~acl=/api/1/1/8/b/3/0/8b379b7b5ccaf0fb4334d7d5ca199597.mp3*~data=user_id=0,application_id=42~hmac=5a1ef4743e521a9a0ae55e88df8b1c268aadff45d155f825e6195f6c47a27e83	150	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
230	4315317	Mardy Bum	175	9	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/f/2/0/3f2e4b9651387376f1d9bd5c3511052f.mp3?hdnea=exp=1777141982~acl=/api/1/1/3/f/2/0/3f2e4b9651387376f1d9bd5c3511052f.mp3*~data=user_id=0,application_id=42~hmac=a85f30789bdf4898ddcbcea6e82a2680788c455f7fa43d00d93d177996664701	151	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
231	4315310	I Bet You Look Good On The Dancefloor	173	2	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/6/7/0/667973ef99272d4622145ddddd4f1201.mp3?hdnea=exp=1777141982~acl=/api/1/1/6/6/7/0/667973ef99272d4622145ddddd4f1201.mp3*~data=user_id=0,application_id=42~hmac=7e49c5f1b3f3bc009555d8298da03705ce6e795a200dfcb37c0cb7ceeac4c2e9	151	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
232	4315311	Fake Tales Of San Francisco	177	3	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/d/1/0/9d1e9a0a40f51f6920a15bc6df6f6b4a.mp3?hdnea=exp=1777141982~acl=/api/1/1/9/d/1/0/9d1e9a0a40f51f6920a15bc6df6f6b4a.mp3*~data=user_id=0,application_id=42~hmac=807cbc26fb6e0a938b9c7648044621ad035484ceca686ca989e71a6bb4a9bcee	151	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
233	4315315	Riot Van	134	7	https://cdn-images.dzcdn.net/images/cover/f7a0a1ca91431861989efe5a22aad557/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/e/4/0/3e4bbe53e8f2bc74a4429d0588136580.mp3?hdnea=exp=1777141982~acl=/api/1/1/3/e/4/0/3e4bbe53e8f2bc74a4429d0588136580.mp3*~data=user_id=0,application_id=42~hmac=6097c2854abc364161a5555f6794248d3490dcf30c8949b8a10ee53379126395	151	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
234	1100592452	Haruka Kanata	242	1	https://cdn-images.dzcdn.net/images/cover/d47be963feec05c26ec419a075aedfce/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/e/3/0/1e398e56a4b723f657f81acb706c85db.mp3?hdnea=exp=1777142333~acl=/api/1/1/1/e/3/0/1e398e56a4b723f657f81acb706c85db.mp3*~data=user_id=0,application_id=42~hmac=563b5fe350db4d95579c9412b567d164d8d903123605fa7670a82e6593bc474d	163	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
235	1100590722	Re:Re:	227	8	https://cdn-images.dzcdn.net/images/cover/5b8d294ba72b50db78a4dea82db50438/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/b/a/0/0ba511a318efc69bb74af925b8ef5d81.mp3?hdnea=exp=1777142333~acl=/api/1/1/0/b/a/0/0ba511a318efc69bb74af925b8ef5d81.mp3*~data=user_id=0,application_id=42~hmac=15ed9ce524a51d702fee8b7379b3e20e4a7218d61118d90cb399d6af0085b820	164	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
236	975978822	Re: Re: Single version	332	1	https://cdn-images.dzcdn.net/images/cover/4b6954804e8f4976f75d78ee703f21ce/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/0/b/0/70b2b2705cd370338386ed04c7b0134d.mp3?hdnea=exp=1777142333~acl=/api/1/1/7/0/b/0/70b2b2705cd370338386ed04c7b0134d.mp3*~data=user_id=0,application_id=42~hmac=b22e09617439276d05c790a447cd3a4b0eaced7474dd7370b9c59e858ac40e0c	165	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
237	976006152	Blood Circulator	221	1	https://cdn-images.dzcdn.net/images/cover/230aff850451111a12fff99b7aed98ed/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/9/0/6399f0e6fff721754bf72d922927f746.mp3?hdnea=exp=1777142333~acl=/api/1/1/6/3/9/0/6399f0e6fff721754bf72d922927f746.mp3*~data=user_id=0,application_id=42~hmac=f49a5f32ce7406657f1fa3d8cc4743f6823efd11dfa4b77da05a121c2f6d89f8	166	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
238	3917999131	Skins	245	1	https://cdn-images.dzcdn.net/images/cover/7ccf14966abd98b1fcb363be8b9b9afb/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/1/8/0/218f04fc17e5e8aaf432af7e78933dc0.mp3?hdnea=exp=1777142333~acl=/api/1/1/2/1/8/0/218f04fc17e5e8aaf432af7e78933dc0.mp3*~data=user_id=0,application_id=42~hmac=c04fbc36830696e90ff475d0cb1cabfa71da5ad70cde7f1145b804c4f9e0e70d	167	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
239	675316632	Heart To Heart	211	8	https://cdn-images.dzcdn.net/images/cover/b4b7dd92a404cd45a556b4066f7b8cbd/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/3/f/0/f3f3e11749c8430bc7cbffe28151935c.mp3?hdnea=exp=1777142361~acl=/api/1/1/f/3/f/0/f3f3e11749c8430bc7cbffe28151935c.mp3*~data=user_id=0,application_id=42~hmac=1ff93a9af8689f52b251745361c05dbafba728b2adc77713352df89b27ded0b3	169	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
240	76008448	Chamber Of Reflection	232	9	https://cdn-images.dzcdn.net/images/cover/96f16ccb3da4d231b72bc5de25a16202/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/1/9/0/319c9f6f028ea4d478d0f6c041fb90b1.mp3?hdnea=exp=1777142361~acl=/api/1/1/3/1/9/0/319c9f6f028ea4d478d0f6c041fb90b1.mp3*~data=user_id=0,application_id=42~hmac=b100d9874c9a6241bb4ff7879c0fed8a092c2765778b991b39adc40a3e04bae1	170	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
241	62744398	Freaking Out the Neighborhood	174	3	https://cdn-images.dzcdn.net/images/cover/48dd98d88f1af797d65faf7f3e4beef7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/d/c/0/edc3eb5029a0a3b4c5478ed976e7d18a.mp3?hdnea=exp=1777142361~acl=/api/1/1/e/d/c/0/edc3eb5029a0a3b4c5478ed976e7d18a.mp3*~data=user_id=0,application_id=42~hmac=0f3969743567eb7d06e892ad4fa6d81d17cd89f52b8a6139b4be2e5a5450b345	171	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
242	347015791	For the First Time	182	4	https://cdn-images.dzcdn.net/images/cover/5e7b8670b572a110d4453e6ac94421d8/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/3/a/0/13a4071dc7fd2bbb0c2cc732c797e865.mp3?hdnea=exp=1777142361~acl=/api/1/1/1/3/a/0/13a4071dc7fd2bbb0c2cc732c797e865.mp3*~data=user_id=0,application_id=42~hmac=01b318e31102e78dc73b28871092ecf88fe52ba69b074524ab70fd7f630fa9dc	172	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
243	62744403	My Kind of Woman	191	8	https://cdn-images.dzcdn.net/images/cover/48dd98d88f1af797d65faf7f3e4beef7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/2/c/0/a2c52d86c525b80008141e53724709e1.mp3?hdnea=exp=1777142361~acl=/api/1/1/a/2/c/0/a2c52d86c525b80008141e53724709e1.mp3*~data=user_id=0,application_id=42~hmac=5735b67ecf576105ae2f700f9ce8ace4eeb18bbfb106bfc08776037d0e9c5715	171	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
244	138547415	Creep	238	2	https://cdn-images.dzcdn.net/images/cover/1dd56fd8824492e1a5106c99a00a85ec/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/9/c/0/b9c4cde36fbe176cc3e84dc08fc0611b.mp3?hdnea=exp=1777142371~acl=/api/1/1/b/9/c/0/b9c4cde36fbe176cc3e84dc08fc0611b.mp3*~data=user_id=0,application_id=42~hmac=d71b2a6d72251c8eccc221d564b2cf35a07c1fd7821470f4a17bdcb311304cf4	174	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
245	138539979	Let Down	299	5	https://cdn-images.dzcdn.net/images/cover/05a186e0a859a36f9cd51cdae2158fe1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/9/1/0/991f911408c85213268ebf001476d6b6.mp3?hdnea=exp=1777142371~acl=/api/1/1/9/9/1/0/991f911408c85213268ebf001476d6b6.mp3*~data=user_id=0,application_id=42~hmac=cf89ac68ee0bd0f393a63d7cbb708202d09f7bbdb40202474b7b6ce989378807	175	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
246	138539981	Karma Police	264	6	https://cdn-images.dzcdn.net/images/cover/05a186e0a859a36f9cd51cdae2158fe1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/1/d/0/41dd34fd7d334b1c55b6970ef6db0d2f.mp3?hdnea=exp=1777142371~acl=/api/1/1/4/1/d/0/41dd34fd7d334b1c55b6970ef6db0d2f.mp3*~data=user_id=0,application_id=42~hmac=2fcb27a130e69fdb88b0cd1c6e8e497285d6aa1905cc33919344f2ad34ed60a2	175	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
247	138539157	No Surprises	229	1	https://cdn-images.dzcdn.net/images/cover/7a378976d3ff1b1fd7b21ee0c7f95fa5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/3/0/6339c4be65e78cbf7b53abe2cd83f0b1.mp3?hdnea=exp=1777142371~acl=/api/1/1/6/3/3/0/6339c4be65e78cbf7b53abe2cd83f0b1.mp3*~data=user_id=0,application_id=42~hmac=e88e5a3aea86af9c85579ee57c2658609eba8e7b19ce3b0ed468a3355fd1cf44	176	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
248	138544279	Street Spirit (Fade Out)	253	12	https://cdn-images.dzcdn.net/images/cover/0d2ccaf5f7b35af57f3d9c8f4504a6e6/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/a/3/0/0a38ba04b6fed75bc1e660e1f34e2587.mp3?hdnea=exp=1777142371~acl=/api/1/1/0/a/3/0/0a38ba04b6fed75bc1e660e1f34e2587.mp3*~data=user_id=0,application_id=42~hmac=2165a05c886dcddf6e4bd477a0cb35977fb80a0f3c62385253483a32c00212d6	177	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
249	2791872362	Lady Brown	199	3	https://cdn-images.dzcdn.net/images/cover/1101dad700ff330a9ca2c6915135af4e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/e/8/0/be86d614d1d43c92d880d48390bf67d4.mp3?hdnea=exp=1777142383~acl=/api/1/1/b/e/8/0/be86d614d1d43c92d880d48390bf67d4.mp3*~data=user_id=0,application_id=42~hmac=12ea8768764ad1f6ab044363b97a4ec5c32faad789ec05e84ddace4009baf213	180	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
250	2791984142	Luv (sic)	289	1	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/8/2/0/58223e821976e5b94a189b0027171c78.mp3?hdnea=exp=1777142383~acl=/api/1/1/5/8/2/0/58223e821976e5b94a189b0027171c78.mp3*~data=user_id=0,application_id=42~hmac=b3c9a14967e2a0a9dae4873c89db4e9ba63c3f2b894c919780033f8c6301c02c	181	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
251	2791872482	Peaceland	499	15	https://cdn-images.dzcdn.net/images/cover/1101dad700ff330a9ca2c6915135af4e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/d/c/0/7dc36dfd72fab124c68a0aa84884c97e.mp3?hdnea=exp=1777142383~acl=/api/1/1/7/d/c/0/7dc36dfd72fab124c68a0aa84884c97e.mp3*~data=user_id=0,application_id=42~hmac=a8f851fb25b39ddb0c106057d16ed2cba141ff9c05b0cca36abf97c5d7baa944	180	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
252	2791984162	Luv (sic.) pt3 (feat. Shing02)	374	3	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/7/0/0/e7042aa11c44ffc2120c0c5c583f9fc1.mp3?hdnea=exp=1777142383~acl=/api/1/1/e/7/0/0/e7042aa11c44ffc2120c0c5c583f9fc1.mp3*~data=user_id=0,application_id=42~hmac=7c0ba99d3753bdf281d893ae259e778ff2a6933452d8e1d11e31a9e0160d89b5	181	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
253	2791882262	Far Fowls	264	10	https://cdn-images.dzcdn.net/images/cover/a169eaef1fb5af5792586df290a81143/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/e/a/0/2ea04df8bf042cfc2d247b5501b6abdb.mp3?hdnea=exp=1777142383~acl=/api/1/1/2/e/a/0/2ea04df8bf042cfc2d247b5501b6abdb.mp3*~data=user_id=0,application_id=42~hmac=800d2448db14c76d6a704d51272ce0f2a3d73c2d1a7ee4160c27f6c157cbf9dd	182	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
254	6469963	Bitches	165	2	https://cdn-images.dzcdn.net/images/cover/db96781e2f90556670079b8a7f336e34/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/e/8/0/3e8f7feeb9610889ee8a86b22d6c6fcc.mp3?hdnea=exp=1777142396~acl=/api/1/1/3/e/8/0/3e8f7feeb9610889ee8a86b22d6c6fcc.mp3*~data=user_id=0,application_id=42~hmac=c442c43a9cb4ab30622d35cbdebdf8899074bdf79aaf3bfa543b0dec909ab2e3	185	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
255	2859555592	Seven Minutes in Heaven	134	4	https://cdn-images.dzcdn.net/images/cover/7942735ee7d14235e46b8093fd75c684/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/2/4/0/0248734b20adfadc5ffdb13c465389b5.mp3?hdnea=exp=1777142396~acl=/api/1/1/0/2/4/0/0248734b20adfadc5ffdb13c465389b5.mp3*~data=user_id=0,application_id=42~hmac=652188965fe92faab5f33a96376236a60fefcc8d17f64cd7cdfc3218159eabd2	186	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
256	3657980752	For The Love of God	133	13	https://cdn-images.dzcdn.net/images/cover/0e83c010c8b61529d8dbdaee2c0b6f3b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/e/d/0/9ed949de94bcbb82a7c712a8b69fa1b5.mp3?hdnea=exp=1777142396~acl=/api/1/1/9/e/d/0/9ed949de94bcbb82a7c712a8b69fa1b5.mp3*~data=user_id=0,application_id=42~hmac=1939f2a3d2e8ea9a491d311c0d8955db064a401e9181039e8097f5ace8e961bd	187	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
257	3783894292	Tight	167	4	https://cdn-images.dzcdn.net/images/cover/e4b0ec6b60e3409db28aa23ee113045d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/1/c/0/51c7641cab1eddf0f3759cb75d753da1.mp3?hdnea=exp=1777142396~acl=/api/1/1/5/1/c/0/51c7641cab1eddf0f3759cb75d753da1.mp3*~data=user_id=0,application_id=42~hmac=aa725cac1a2316d70d0eb82ebfe7fabaefbdfab7c02af16aa6605e79eec41c8b	188	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
258	8025461	Shut Me Up	168	1	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/8/8/0/68825bb3b344eff006d0da608305d4a5.mp3?hdnea=exp=1777142396~acl=/api/1/1/6/8/8/0/68825bb3b344eff006d0da608305d4a5.mp3*~data=user_id=0,application_id=42~hmac=5a2579e862046e1862da791f828572f49ce674f268d5d5da14dace9e0056fb35	189	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
259	3470152941	Sugar On My Tongue	153	2	https://cdn-images.dzcdn.net/images/cover/d79052872c09468fd80bd288928962c9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/f/d/0/2fd3ba3b1617860c6e8d856b96a44bb7.mp3?hdnea=exp=1777142472~acl=/api/1/1/2/f/d/0/2fd3ba3b1617860c6e8d856b96a44bb7.mp3*~data=user_id=0,application_id=42~hmac=7d4fc482a685a440869ae580b97d8262ef71fd25fc0481ad3cff1183b6aa0371	191	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
260	3064010401	Like Him (feat. Lola Young)	278	12	https://cdn-images.dzcdn.net/images/cover/cb415a59a7bc198ec4aab01f02600691/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/4/c/0/34cb4691b89ff66fe892c224208e12a1.mp3?hdnea=exp=1777142472~acl=/api/1/1/3/4/c/0/34cb4691b89ff66fe892c224208e12a1.mp3*~data=user_id=0,application_id=42~hmac=e2f3b9d955836d73d5b1d2e753661fcf59e1cd9195d3350bfe9c3e84c6140cc1	192	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
261	384157591	See You Again (feat. Kali Uchis)	180	4	https://cdn-images.dzcdn.net/images/cover/a7a16b8f63b1ec0e9fbd327619966737/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/5/2/0/152df582229560f1ef355fab43102a1e.mp3?hdnea=exp=1777142472~acl=/api/1/1/1/5/2/0/152df582229560f1ef355fab43102a1e.mp3*~data=user_id=0,application_id=42~hmac=0434348c3411f67b8168dfcc910e1a7fb91309d28392b8a03836042c2bd22d43	193	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
262	681009652	EARFQUAKE	190	2	https://cdn-images.dzcdn.net/images/cover/041ab5ceb6fb6ebf9512966835be9e1b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/c/0/5ccb6775df9a07a06e8b5f94b9affec1.mp3?hdnea=exp=1777142472~acl=/api/1/1/5/c/c/0/5ccb6775df9a07a06e8b5f94b9affec1.mp3*~data=user_id=0,application_id=42~hmac=b46277650efffb5ed76a6d60211ad8c78c685df56eeed093263f4afc14c562ff	194	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
263	681009692	NEW MAGIC WAND	195	6	https://cdn-images.dzcdn.net/images/cover/041ab5ceb6fb6ebf9512966835be9e1b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/9/8/0/498bfe694cd260b9169baec151e771e2.mp3?hdnea=exp=1777142472~acl=/api/1/1/4/9/8/0/498bfe694cd260b9169baec151e771e2.mp3*~data=user_id=0,application_id=42~hmac=6d84811cbab201911b36af3ae465f2cd39c3f785d4f9ec73f4bf767369c21d2d	194	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
264	3818963601	Dracula (JENNIE Remix)	209	1	https://cdn-images.dzcdn.net/images/cover/b868399da682f34dcd7d98af1c0de80b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/2/5/0/6254df268039f4200674df6d63701e33.mp3?hdnea=exp=1777142935~acl=/api/1/1/6/2/5/0/6254df268039f4200674df6d63701e33.mp3*~data=user_id=0,application_id=42~hmac=1560d9c0e3af471c7127432a4cfe4b935eef3406c4fb7973497b01340284e892	202	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
1146	3740319462	follow me	185	2	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	\N	623	2026-07-19 08:27:26.992804	2026-07-19 08:27:26.992804
265	3567385391	Dracula	205	1	https://cdn-images.dzcdn.net/images/cover/b428fa5da7496083cd2c2e87b94e2ceb/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/2/d/0/72d9c71556ab7b935a6914bda5029ed2.mp3?hdnea=exp=1777142935~acl=/api/1/1/7/2/d/0/72d9c71556ab7b935a6914bda5029ed2.mp3*~data=user_id=0,application_id=42~hmac=d37d2c31ae61d8db0cf4ce7db0cfd7189e3efab8eab6c184fa21beb4fa0a3181	203	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
266	103052650	Let It Happen	469	1	https://cdn-images.dzcdn.net/images/cover/de5b9b704cd4ec36f8bf49beb3e17ba2/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/a/e/0/6aee42a038480ecdcf2d6168f95810f2.mp3?hdnea=exp=1777142935~acl=/api/1/1/6/a/e/0/6aee42a038480ecdcf2d6168f95810f2.mp3*~data=user_id=0,application_id=42~hmac=5957b28c353e66f5dcaf1b83f44023c793952895c15f9b11e487755dfe519e5b	29	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
267	103052662	The Less I Know The Better	217	7	https://cdn-images.dzcdn.net/images/cover/de5b9b704cd4ec36f8bf49beb3e17ba2/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/7/e/0/d7e09f788f6834e38f61f8a589b0390a.mp3?hdnea=exp=1777142935~acl=/api/1/1/d/7/e/0/d7e09f788f6834e38f61f8a589b0390a.mp3*~data=user_id=0,application_id=42~hmac=3831e5db8c72ff07a2b95afbc108cfc1c4b3ede868417532f0e2484f41b4747b	29	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
268	872345282	Borderline	240	3	https://cdn-images.dzcdn.net/images/cover/d8eb61bd4becf79a602a75b69eebde7d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/f/e/0/efe16471ba48ab8dd697e33793a7d039.mp3?hdnea=exp=1777142935~acl=/api/1/1/e/f/e/0/efe16471ba48ab8dd697e33793a7d039.mp3*~data=user_id=0,application_id=42~hmac=4c27e4a60257ab7be369c8617b889ef8cee005ddcf730e8b6d9db7fa54f83653	204	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
269	3929283701	Crush on you	125	1	https://cdn-images.dzcdn.net/images/cover/d246732856fbe6109c4a78fbd02d147d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/6/8/0/668c7de8ba2e0332f55d58cfe867dacc.mp3?hdnea=exp=1777187602~acl=/api/1/1/6/6/8/0/668c7de8ba2e0332f55d58cfe867dacc.mp3*~data=user_id=0,application_id=42~hmac=d2c8ac5278bc7512f35e392b7d1c55fc84f8c3a442d62be858ec1aa0bc4dbc00	210	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
270	3256939871	Счастливая	121	1	https://cdn-images.dzcdn.net/images/cover/97ce2ddd038b03aca5497746b4cd06b5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/5/1/0/851b9c9b646048f87ec3f5d5b6d30b7b.mp3?hdnea=exp=1777187602~acl=/api/1/1/8/5/1/0/851b9c9b646048f87ec3f5d5b6d30b7b.mp3*~data=user_id=0,application_id=42~hmac=6d18d0dba8a5fa09490944beec131c0da4bc6a5cb8fcb6475d56b3295f32c30d	211	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
271	65279912	Отойди	282	4	https://cdn-images.dzcdn.net/images/cover/3ae85cec86675b5b441190d7f9ef01e3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/6/6/0/866957dfab27b7f1103d04e7aebb0532.mp3?hdnea=exp=1777187602~acl=/api/1/1/8/6/6/0/866957dfab27b7f1103d04e7aebb0532.mp3*~data=user_id=0,application_id=42~hmac=9156c92b75a33730866339fea7060e0bb4597b1113ec64dad4dad58644055ed5	212	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
272	125491414	Отойди, отойди, грусть-печаль	147	2	https://cdn-images.dzcdn.net/images/cover/972181cf751de9dcefce3e4acdb5da5c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/f/c/0/3fc853a986ade69da8b3b7e62f837239.mp3?hdnea=exp=1777187602~acl=/api/1/1/3/f/c/0/3fc853a986ade69da8b3b7e62f837239.mp3*~data=user_id=0,application_id=42~hmac=2bbec7bfc9a6f5c8d4d657da7ac8cf46e593d89f3c408d857e40aedff05831e4	213	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
273	117674210	Отойди	232	4	https://cdn-images.dzcdn.net/images/cover/5a337e971510d565ffe8d92ec850da86/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/4/4/0/5444956254f152a4c59db5022fb35f52.mp3?hdnea=exp=1777187602~acl=/api/1/1/5/4/4/0/5444956254f152a4c59db5022fb35f52.mp3*~data=user_id=0,application_id=42~hmac=ced39970c93767bebdb1976f5d79a7e274850de7c6aa6ea65487d405fb376758	214	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
274	3952958871	На двох	150	1	https://cdn-images.dzcdn.net/images/cover/f4440d667a734e057787635e8e76f5d0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/d/4/0/9d443b2373b26146cdba71c67f548f4e.mp3?hdnea=exp=1777187617~acl=/api/1/1/9/d/4/0/9d443b2373b26146cdba71c67f548f4e.mp3*~data=user_id=0,application_id=42~hmac=455a100566ff0af527ca05ebd954a49ea8f1ac0f66d18a45c6d73d2368d69b29	219	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
275	2618842312	пащека	186	2	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/5/e/0/55e60a579c18a38a62eb489edb51c8a1.mp3?hdnea=exp=1777187617~acl=/api/1/1/5/5/e/0/55e60a579c18a38a62eb489edb51c8a1.mp3*~data=user_id=0,application_id=42~hmac=8a0859cf0118cdecd6e3f25ba177c456e0f2963b119bd45b6bae55f97408045c	220	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
276	145049016	Otoi	252	1	https://cdn-images.dzcdn.net/images/cover/7f7527c38afb700a2128ec6e38d0f7ca/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/3/0/0/3306a7340670df9d3921ee18a2e02bf8.mp3?hdnea=exp=1777187617~acl=/api/1/1/3/3/0/0/3306a7340670df9d3921ee18a2e02bf8.mp3*~data=user_id=0,application_id=42~hmac=e63ede8a209388d438c04646e2d17752fbafffefa6ac9d91280aae14c3987f3e	221	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
277	799277872	Otoi	343	6	https://cdn-images.dzcdn.net/images/cover/de3d4ef5ba7c4c1fb6c12019764d0c67/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/8/d/0/88dadb18c37dc815f3fa9c38d252b816.mp3?hdnea=exp=1777187617~acl=/api/1/1/8/8/d/0/88dadb18c37dc815f3fa9c38d252b816.mp3*~data=user_id=0,application_id=42~hmac=af13ba7576aaeabc60295779f6ba481fac6888a046b8733dab8cfb0c0a184bdf	222	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
278	2458573015	Судоми	146	1	https://cdn-images.dzcdn.net/images/cover/7cf6cad57141fb00147c3994d08d9f66/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/2/0/0/0208b31c14c641a3a390d8271e91b32f.mp3?hdnea=exp=1777187617~acl=/api/1/1/0/2/0/0/0208b31c14c641a3a390d8271e91b32f.mp3*~data=user_id=0,application_id=42~hmac=3f45ae7e2881f49f60e33324ce9b3396df806cec7535144035ddc49d1f7e930a	223	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
279	2196957517	CHORT	171	6	https://cdn-images.dzcdn.net/images/cover/44927d36b2b160b183cfc21a4bac0187/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/f/4/0/9f4c2d99895aea63b05f871276e9ad81.mp3?hdnea=exp=1777187629~acl=/api/1/1/9/f/4/0/9f4c2d99895aea63b05f871276e9ad81.mp3*~data=user_id=0,application_id=42~hmac=8535f379dd97cdaf17a37f65ff1c71c1470621fdca376be3cef92566572f3304	226	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
280	3440584641	Пекло	210	1	https://cdn-images.dzcdn.net/images/cover/16d323ce498287a3ad46511c889e5511/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/2/3/0/b23c0c4939ee9c559da3ae2bf2dd38e0.mp3?hdnea=exp=1777187629~acl=/api/1/1/b/2/3/0/b23c0c4939ee9c559da3ae2bf2dd38e0.mp3*~data=user_id=0,application_id=42~hmac=00dd4de71ae89069335dccb939692c7cd8fd7d744b05650db5f96fc87c3b9a48	227	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
281	3402065411	Забудуться жалі	163	1	https://cdn-images.dzcdn.net/images/cover/fd5d51409df03bf74814f247b60232b1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/e/6/0/9e6c1a2a1d90126652b7b77d39fa2262.mp3?hdnea=exp=1777187709~acl=/api/1/1/9/e/6/0/9e6c1a2a1d90126652b7b77d39fa2262.mp3*~data=user_id=0,application_id=42~hmac=512d24a0784dee24bd6f152caa71c7bee6d1963d4f4b2eeefa1509cf77765abb	228	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
282	2210764257	Безодня	130	1	https://cdn-images.dzcdn.net/images/cover/366ddb808331d495be759a092092af12/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/9/a/0/c9a5abb6160136fb87b19329ff888691.mp3?hdnea=exp=1777187709~acl=/api/1/1/c/9/a/0/c9a5abb6160136fb87b19329ff888691.mp3*~data=user_id=0,application_id=42~hmac=7284d21308ec81d911047d6cbb429fdf92957feab54f7c80df2bf36426d2246f	229	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
283	3947662241	Совковий модернізм	163	1	https://cdn-images.dzcdn.net/images/cover/65ed68e35a1b1feb2ee55bcbaf78c1e1/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/7/b/0/87bf11126ed4da23df291fcda102f6ae.mp3?hdnea=exp=1777187709~acl=/api/1/1/8/7/b/0/87bf11126ed4da23df291fcda102f6ae.mp3*~data=user_id=0,application_id=42~hmac=a92a4040cbdc1419977445bae7e7de7908d4ec281365499a1f0abd207722ce24	230	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
284	3745081472	Хороший громадянин	166	1	https://cdn-images.dzcdn.net/images/cover/ad6ea35d1cc8e9a5a53b83267c70e232/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/3/c/0/63c2c5c6b70f2fed74fa43b71f6e8335.mp3?hdnea=exp=1777187709~acl=/api/1/1/6/3/c/0/63c2c5c6b70f2fed74fa43b71f6e8335.mp3*~data=user_id=0,application_id=42~hmac=53923258eff7abbf210d43946a0ab3f251c76be82dc294105a0fcefd3eb347c4	231	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
285	3449822261	Кінець фільму	178	1	https://cdn-images.dzcdn.net/images/cover/b51f92904cf2063cf83f7e0596354e02/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/3/a/0/e3a3f3d963dde4084d2abf393bad415d.mp3?hdnea=exp=1777187709~acl=/api/1/1/e/3/a/0/e3a3f3d963dde4084d2abf393bad415d.mp3*~data=user_id=0,application_id=42~hmac=a7f7217017f9ed30f393ea2dddba42272653f34b2612097016a478928e76510d	232	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
286	3012340061	Тихохода	185	3	https://cdn-images.dzcdn.net/images/cover/0fe7540c6c7ad6c6aef3684ed1a16492/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/7/e/0/17e450994c9c0e4f8ecf7e30e127fa10.mp3?hdnea=exp=1777187816~acl=/api/1/1/1/7/e/0/17e450994c9c0e4f8ecf7e30e127fa10.mp3*~data=user_id=0,application_id=42~hmac=aab61c545648e1964ccb1c76ee424db5d0f287d143883e0b07bd1bf6e06e23d1	235	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
287	3130425871	Тиха вода	288	1	https://cdn-images.dzcdn.net/images/cover/695536359e9d936b7eeeaaef08010888/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/d/2/0/fd2c5674fdce21fc26a5c7d7378a296c.mp3?hdnea=exp=1777187816~acl=/api/1/1/f/d/2/0/fd2c5674fdce21fc26a5c7d7378a296c.mp3*~data=user_id=0,application_id=42~hmac=db8070ec61ce24c99ebfbcda7f05518a1f88c9ed429c594c44106be6ed975c31	236	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
288	2587705962	Тиха вода	238	7	https://cdn-images.dzcdn.net/images/cover/54b607f056631d6fc3ac7d5db45c6416/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/1/6/0/d1622bf6a58598edaaa14895bfc0eb4c.mp3?hdnea=exp=1777187816~acl=/api/1/1/d/1/6/0/d1622bf6a58598edaaa14895bfc0eb4c.mp3*~data=user_id=0,application_id=42~hmac=4b6d2214ee63e68477d7afb9fa353e3188bfa30c80a105f1ac7b1f5f4c889626	237	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
289	2433718395	Тиха Вода	212	1	https://cdn-images.dzcdn.net/images/cover/93c6e38e5213c47dfab9431d1fc827f3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/6/5/0/e65a2fd5f576eafcf664db75dc348211.mp3?hdnea=exp=1777187816~acl=/api/1/1/e/6/5/0/e65a2fd5f576eafcf664db75dc348211.mp3*~data=user_id=0,application_id=42~hmac=494b17263d572c2120bae66e5e60a3b044e6aa53a3ec5e2704525aa2be178ad1	238	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
290	107436088	Тиха вода	201	7	https://cdn-images.dzcdn.net/images/cover/fd9ab31f91ef6d0f6c9108456459271c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/2/8/0/0281fd77437d688b14c75d72eff76c44.mp3?hdnea=exp=1777187816~acl=/api/1/1/0/2/8/0/0281fd77437d688b14c75d72eff76c44.mp3*~data=user_id=0,application_id=42~hmac=1872f728155ec3c986da55eb872bd978b1342192bfd3095fbabebaff934a61fa	239	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
291	601664312	Мексиканець	236	1	https://cdn-images.dzcdn.net/images/cover/f5a0b686e228612b5aada0cad54c8e05/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/f/c/0/afc35ee68c775acc8a0826be16f61298.mp3?hdnea=exp=1777187936~acl=/api/1/1/a/f/c/0/afc35ee68c775acc8a0826be16f61298.mp3*~data=user_id=0,application_id=42~hmac=22dd24509af2988447cbb31a22bde97e070887535d94d20e0bf296b7fbc78c85	243	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
292	2553734662	Танцюй і пий	274	1	https://cdn-images.dzcdn.net/images/cover/5fb6cc3fc672404c72bf42029328ca1e/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/f/7/0/af7d43761ad5a273c628d5bf695b12cf.mp3?hdnea=exp=1777187936~acl=/api/1/1/a/f/7/0/af7d43761ad5a273c628d5bf695b12cf.mp3*~data=user_id=0,application_id=42~hmac=375f51cc31b3f6e886983d309dc949f81a376552313ff855cf1c0e474ecdcd65	244	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
293	3380246611	Потяг на Південь	206	1	https://cdn-images.dzcdn.net/images/cover/c484012d0dc2784f5c6782def35026e9/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/e/3/0/ce3f51b4a7c1cf77d5d3ab782b97458f.mp3?hdnea=exp=1777187936~acl=/api/1/1/c/e/3/0/ce3f51b4a7c1cf77d5d3ab782b97458f.mp3*~data=user_id=0,application_id=42~hmac=ddc41f4a4dfb2fd8e0482979024efffb5a6b60b864794e1198067677e2d7d136	245	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
294	2486842921	Госпел	215	3	https://cdn-images.dzcdn.net/images/cover/a61030910e83fff9445929e6bea19952/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/a/b/0/bab49a92e658aafd340012e745cbce54.mp3?hdnea=exp=1777187936~acl=/api/1/1/b/a/b/0/bab49a92e658aafd340012e745cbce54.mp3*~data=user_id=0,application_id=42~hmac=f266f415e6836c2894630be77d85afec339ffd4816c39f3ccd0c14919d12a6db	246	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
295	3068417241	Золото і блакить	230	7	https://cdn-images.dzcdn.net/images/cover/81f7e046d09d7548ec4c66cafd1f5800/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/e/9/0/be9b2089de9d1f26134b117e5807528d.mp3?hdnea=exp=1777187936~acl=/api/1/1/b/e/9/0/be9b2089de9d1f26134b117e5807528d.mp3*~data=user_id=0,application_id=42~hmac=d561a9decfa1e8f9beb3a1f8682511bc1120745bc666a1246564a01f11e0919b	247	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
296	3281754281	Контузія	166	13	https://cdn-images.dzcdn.net/images/cover/c3430697ff4515b23c02385b3af634d6/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/4/2/0/f42c663276a9c3a8c95caaa720374a68.mp3?hdnea=exp=1777187954~acl=/api/1/1/f/4/2/0/f42c663276a9c3a8c95caaa720374a68.mp3*~data=user_id=0,application_id=42~hmac=99fccdd285a08688c585a144dd9715ad722c9c53b7dcb08b84721251784ab7ee	249	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
297	3405994371	Війни	155	1	https://cdn-images.dzcdn.net/images/cover/16ac2aacc116c0dafae5009d194be03b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/b/4/0/cb479c0da058bdde8e3c5c5680eb57b7.mp3?hdnea=exp=1777187954~acl=/api/1/1/c/b/4/0/cb479c0da058bdde8e3c5c5680eb57b7.mp3*~data=user_id=0,application_id=42~hmac=f108d4e19beffca988d0f90b6976fd13fde9a813212e3dd93b12b3b62d0b9ceb	250	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
298	3774200712	Вогняне Коло	194	3	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/1/6/0/b164383b97a4f5232b0d7a35a2951ecc.mp3?hdnea=exp=1777187954~acl=/api/1/1/b/1/6/0/b164383b97a4f5232b0d7a35a2951ecc.mp3*~data=user_id=0,application_id=42~hmac=e90b309a72b4773c083c2ab134063b53fbd7cc9bbbd2e757b1fcf6812ab0ed87	251	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
299	3745458102	Очі Відьми	317	3	https://cdn-images.dzcdn.net/images/cover/48def83a99d438e5328e64b52a94f573/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/6/b/0/f6b15c034bed002fc30443143e53e916.mp3?hdnea=exp=1777187954~acl=/api/1/1/f/6/b/0/f6b15c034bed002fc30443143e53e916.mp3*~data=user_id=0,application_id=42~hmac=a43eb923554e9712433cb5d83464f89751c1018d2d1ae97a91c2162c8aec09ba	252	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
300	3774200742	Як Летіли Бугаї	209	6	https://cdn-images.dzcdn.net/images/cover/228300bfe40ee173a6465fc6fd2ab647/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/e/e/0/feeb034b848cf86c6d561b6e4561d5d1.mp3?hdnea=exp=1777187954~acl=/api/1/1/f/e/e/0/feeb034b848cf86c6d561b6e4561d5d1.mp3*~data=user_id=0,application_id=42~hmac=c0f6d1373e832c16cb6960487537d992f9218eba5a57f54b84adad10c6f9d0c8	251	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
301	2113690087	Шибеник	186	1	https://cdn-images.dzcdn.net/images/cover/2fad3c50a24ab5e0bcdcbf90b175eb46/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/5/4/0/054057c618b63be8149f98cc69207659.mp3?hdnea=exp=1777188587~acl=/api/1/1/0/5/4/0/054057c618b63be8149f98cc69207659.mp3*~data=user_id=0,application_id=42~hmac=e906dc60e5ffc171f04d3f7f2f4e0c2bc750af7a7d0eca679e0804aba6a16724	253	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
302	2113690107	Від зими до літа	146	3	https://cdn-images.dzcdn.net/images/cover/2fad3c50a24ab5e0bcdcbf90b175eb46/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/e/2/0/5e256fb094d41617ea089862553adb4d.mp3?hdnea=exp=1777188587~acl=/api/1/1/5/e/2/0/5e256fb094d41617ea089862553adb4d.mp3*~data=user_id=0,application_id=42~hmac=0879d2460f4ce39039060adb199fa9b64f7d542357d4337db9ba7523623389e1	253	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
303	1463465352	Лебеді	203	1	https://cdn-images.dzcdn.net/images/cover/f17be3334e8d8164ddc8f2c6fc3e50cf/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/9/4/0/0942a45aa28aca5b394fd7a976336424.mp3?hdnea=exp=1777188587~acl=/api/1/1/0/9/4/0/0942a45aa28aca5b394fd7a976336424.mp3*~data=user_id=0,application_id=42~hmac=63d3e6b75cee44b00e7cd942e8362ea7c53fa606f20db0760a1c25cf92d0caef	254	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
304	2113690127	Жбурляю	203	5	https://cdn-images.dzcdn.net/images/cover/2fad3c50a24ab5e0bcdcbf90b175eb46/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/7/d/0/c7d094ce99d2d68fca6188323c871a3b.mp3?hdnea=exp=1777188587~acl=/api/1/1/c/7/d/0/c7d094ce99d2d68fca6188323c871a3b.mp3*~data=user_id=0,application_id=42~hmac=4b9b90021e8a5825ee337b5c7c824f95de7c60b2ecc4d52f4ce72620d75c4631	253	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
305	3945707331	Моровиця	146	1	https://cdn-images.dzcdn.net/images/cover/55bcfc60282a40a661a0dd238666196b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/3/4/0/b344716732a5250f205400f61613a55a.mp3?hdnea=exp=1777188587~acl=/api/1/1/b/3/4/0/b344716732a5250f205400f61613a55a.mp3*~data=user_id=0,application_id=42~hmac=70234ee6870c9134cfb8fcd7df84e99c1c7ceefd6223a27803c46bceb729d9a8	255	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
315	5606967	Baby	216	1	https://cdn-images.dzcdn.net/images/cover/39aa26b45fa69cd89b8ef1a46f106c43/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/3/7/0/1377b0443b2c324b239425d106ee569c.mp3?hdnea=exp=1777551987~acl=/api/1/1/1/3/7/0/1377b0443b2c324b239425d106ee569c.mp3*~data=user_id=0,application_id=42~hmac=a798f10cfc8fdf555526bdf428b8d4861c984f7fc580097bffbc77201a94c953	271	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
325	2311074615	Promise	234	1	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/2/6/0/b26ec4e400179780fbf1cc2a59b9e176.mp3?hdnea=exp=1782382071~acl=/api/1/1/b/2/6/0/b26ec4e400179780fbf1cc2a59b9e176.mp3*~data=user_id=0,application_id=42~hmac=b3bf6a9665a1100b1d30e29ac0c8ebd449c754f37f6f917d649ad6190d9006ad	316	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
356	1942565497	Beautiful Stranger	201	2	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/2/7/0/7274ee6204ee4ba9eb83ecfb02d40e68.mp3?hdnea=exp=1782386212~acl=/api/1/1/7/2/7/0/7274ee6204ee4ba9eb83ecfb02d40e68.mp3*~data=user_id=0,application_id=42~hmac=fdc26f368b1e64687d43b8da72a16c9788f7c76bd3590402c739dcf679641660	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
357	1942565617	Slow Down	145	14	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/7/3/0/873dcc0c4065b79b3cc2a265ff167a7f.mp3?hdnea=exp=1782388319~acl=/api/1/1/8/7/3/0/873dcc0c4065b79b3cc2a265ff167a7f.mp3*~data=user_id=0,application_id=42~hmac=683bd37a9917bfeb5965b3539cf56c8b4c0d0cf2997889d1652ad2591efffc3d	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
358	1942565627	Lucky for Me	144	15	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/9/5/0/f95bc9aa326d2978bab8a160733b9388.mp3?hdnea=exp=1782388319~acl=/api/1/1/f/9/5/0/f95bc9aa326d2978bab8a160733b9388.mp3*~data=user_id=0,application_id=42~hmac=e8f560bcfd476e50c23dbaed95694866dfc6fc4873d3369f0744cd5fd34b64a0	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
359	1942565607	Night Light	242	13	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/1/9/0/119fd56e4aba7f7a939630f397726fb8.mp3?hdnea=exp=1782388320~acl=/api/1/1/1/1/9/0/119fd56e4aba7f7a939630f397726fb8.mp3*~data=user_id=0,application_id=42~hmac=5a0609d52c8b1c1d004916298ba3caa27eb3ff3980110676a91e85a57d2929f5	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
360	1942565637	Questions For The Universe	203	16	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/8/4/0/08491c1a850defd89418b889a01ddacf.mp3?hdnea=exp=1782388320~acl=/api/1/1/0/8/4/0/08491c1a850defd89418b889a01ddacf.mp3*~data=user_id=0,application_id=42~hmac=33f0f09124e9ed6b55d8b7d9463c52abf35fd0a08265a06cb9e7e41544832fa8	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
361	1942565517	Above The Chinese Restaurant	223	4	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/7/0/0/870d46342a952bd21d648c72d3ee0b02.mp3?hdnea=exp=1782388320~acl=/api/1/1/8/7/0/0/870d46342a952bd21d648c72d3ee0b02.mp3*~data=user_id=0,application_id=42~hmac=7be21d21e5c70665a8e79534633b7b9e604f692a456c5461ffec1bc48b0513de	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
362	1942565597	Dance With You Tonight	158	12	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/7/6/0/c7628af8fa2eee8acbd6dc5f31dd5032.mp3?hdnea=exp=1782388320~acl=/api/1/1/c/7/6/0/c7628af8fa2eee8acbd6dc5f31dd5032.mp3*~data=user_id=0,application_id=42~hmac=5e8e1155cddb3258238c7d68fcee38065cdf588e2e614d1a7c842b76047932cf	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
363	1942565487	Fragile	241	1	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/f/4/0/7f45e7121c0d01a49a2ff4f4dc4e36fc.mp3?hdnea=exp=1782388320~acl=/api/1/1/7/f/4/0/7f45e7121c0d01a49a2ff4f4dc4e36fc.mp3*~data=user_id=0,application_id=42~hmac=3402685f4da21e41b28d8026f5aca20636822cc5ba99f61ad39908ce315dcb88	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
364	1942565567	Everything I Know About Love	209	9	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/d/c/0/edc3578ab6c3fbb80895d9a6719a70c4.mp3?hdnea=exp=1782388320~acl=/api/1/1/e/d/c/0/edc3578ab6c3fbb80895d9a6719a70c4.mp3*~data=user_id=0,application_id=42~hmac=a2d25c26aadadeef2c48404b6cefdb7de154aa9f79fe9843e07cedf4d951e580	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
365	1942565537	What Love Will Do to You	171	6	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/6/5/0/265d6205cbb4eaf6b9ceaaeef78b6b23.mp3?hdnea=exp=1782388320~acl=/api/1/1/2/6/5/0/265d6205cbb4eaf6b9ceaaeef78b6b23.mp3*~data=user_id=0,application_id=42~hmac=c6110c774329a209b0ec424529b6890721be54c3e558ae36fa2da8adda00a0df	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
366	1942565547	I've Never Been In Love Before	222	7	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/6/f/0/a6f499a786bb4fe030d67c8cede3d57d.mp3?hdnea=exp=1782388320~acl=/api/1/1/a/6/f/0/a6f499a786bb4fe030d67c8cede3d57d.mp3*~data=user_id=0,application_id=42~hmac=7b75d46b3de5b2cc37af6c89e6ae53e9458e31814ccf17789b34e93c73c95197	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
367	1942565557	Just Like Chet	216	8	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/6/1/0/9617fb1664caa53c2243fa2c8bd44f25.mp3?hdnea=exp=1782388320~acl=/api/1/1/9/6/1/0/9617fb1664caa53c2243fa2c8bd44f25.mp3*~data=user_id=0,application_id=42~hmac=c8ed3fe126ac5417fbe4563ae4f523a0cbce45fa1839df59dd8771222ca8292d	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
368	1942565587	Hi	193	11	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/c/b/0/7cb21355c4c87680e64b3c01ba96aa4d.mp3?hdnea=exp=1782388320~acl=/api/1/1/7/c/b/0/7cb21355c4c87680e64b3c01ba96aa4d.mp3*~data=user_id=0,application_id=42~hmac=518e2b2e53863347bfff01191ece4ce0a6b4b377c662194381aa02570f31ab3f	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
372	1942565527	Dear Soulmate	260	5	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/0/4/0/e0440855725b0dc6eefd533c0f017c96.mp3?hdnea=exp=1782388320~acl=/api/1/1/e/0/4/0/e0440855725b0dc6eefd533c0f017c96.mp3*~data=user_id=0,application_id=42~hmac=6e4084255320f9614c25a44d2371e459546f6e7fe7a3fb4ada81655fcc53b9ec	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
374	2631149032	Letter To My 13 Year Old Self	262	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/a/2/0/3a208979ba6e253c8d4b54d0bb33b789.mp3?hdnea=exp=1782388320~acl=/api/1/1/3/a/2/0/3a208979ba6e253c8d4b54d0bb33b789.mp3*~data=user_id=0,application_id=42~hmac=8b6f153e5d685909cf10b8d0c17f8e3aad848b49578f4649286d8be0a9fc6de6	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
375	2485532771	A Night To Remember	233	\N	https://cdn-images.dzcdn.net/images/cover/fe4b7355b4cc565a34d59fe67211dfa0/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/f/e/0/6fef98a2532181a36b527dc50a7f926c.mp3?hdnea=exp=1782388320~acl=/api/1/1/6/f/e/0/6fef98a2532181a36b527dc50a7f926c.mp3*~data=user_id=0,application_id=42~hmac=2d6c8c18816f2e2d2d0bb460277bcbe717054de844319297fba3b3a40dd2e03a	373	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
376	2631148932	Haunted	200	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/8/c/0/98c19a445481f85486730b36d35db08e.mp3?hdnea=exp=1782388320~acl=/api/1/1/9/8/c/0/98c19a445481f85486730b36d35db08e.mp3*~data=user_id=0,application_id=42~hmac=28880e67cb3b9981cf492112e441aae0e39a13d3163974bab107721d4f47ac58	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
377	2631149012	Misty	209	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/f/c/0/7fc845239725b82623a3f1840ea582bd.mp3?hdnea=exp=1782388320~acl=/api/1/1/7/f/c/0/7fc845239725b82623a3f1840ea582bd.mp3*~data=user_id=0,application_id=42~hmac=e97c3a1125b1d7b4c2aefe3a69d919b63dac85e1bcf7aea5677f588354bc6763	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
378	2631149022	Serendipity	219	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/7/2/0/f72c18be3b92363b5da6bc9a2a02c587.mp3?hdnea=exp=1782388320~acl=/api/1/1/f/7/2/0/f72c18be3b92363b5da6bc9a2a02c587.mp3*~data=user_id=0,application_id=42~hmac=434c3998967773dfdec822d63bac0749b9d7a24efe9ea1d68f59a6e2fd02475e	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
379	3939294151	I Wait, I Wait, I Wait	209	\N	https://cdn-images.dzcdn.net/images/cover/99f872f6a3e9493e21014a879369ac1f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/f/7/0/8f7800f8a253ca9c51e484aa9f4e8c0f.mp3?hdnea=exp=1782388320~acl=/api/1/1/8/f/7/0/8f7800f8a253ca9c51e484aa9f4e8c0f.mp3*~data=user_id=0,application_id=42~hmac=3c462e9e651017038d2bb8904e52de7a5175d89856555a2bece858c9c5cb0a51	374	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
380	2309254505	Second Best	204	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/5/a/0/05ae203fd81ec33504743ca0618ff123.mp3?hdnea=exp=1782388320~acl=/api/1/1/0/5/a/0/05ae203fd81ec33504743ca0618ff123.mp3*~data=user_id=0,application_id=42~hmac=2340b7d4f5a71f9839fc8873ccc8293ccc21897bc678d94502701acb834790c6	313	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
381	3041651711	Love to Keep Me Warm	158	\N	https://cdn-images.dzcdn.net/images/cover/0706de5a7d9c3ceacf17ccb31091ae1f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/6/8/0/d6819d7d228aabd63a2784de44f92cf1.mp3?hdnea=exp=1782388320~acl=/api/1/1/d/6/8/0/d6819d7d228aabd63a2784de44f92cf1.mp3*~data=user_id=0,application_id=42~hmac=92773e2f4c52e640a214a6e61f45cc119d094837c9af6152f5c0e735fd0ff4e9	375	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
382	2309254535	While You Were Sleeping	177	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/6/6/0/e6669c3df63ec4a35e0abc5528e84cfb.mp3?hdnea=exp=1782388320~acl=/api/1/1/e/6/6/0/e6669c3df63ec4a35e0abc5528e84cfb.mp3*~data=user_id=0,application_id=42~hmac=33b3ee2bee0202421a4419e30a2008eea4c45b4da1011374b8bbf796dc007009	313	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
383	2631149062	Trouble	171	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/7/d/0/77d6fc9a4501570263c35bbcc204998e.mp3?hdnea=exp=1782388320~acl=/api/1/1/7/7/d/0/77d6fc9a4501570263c35bbcc204998e.mp3*~data=user_id=0,application_id=42~hmac=0b44074665c37a68dc7fd993c605d0068e83c935fc2865ef45e9cdcd54f88676	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
384	3338890701	Tough Luck	192	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/2/7/0/b2742c5a4ab7e3ef688043261dee75cf.mp3?hdnea=exp=1782388320~acl=/api/1/1/b/2/7/0/b2742c5a4ab7e3ef688043261dee75cf.mp3*~data=user_id=0,application_id=42~hmac=742548776b6f5663ff8a046b5c9ce560de71f6c37b7e710954ff489b8afe3be2	376	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
385	2632715742	Goddess	267	1	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/7/9/0/47907747fa43da20df54d3a39e0e81f5.mp3?hdnea=exp=1782388320~acl=/api/1/1/4/7/9/0/47907747fa43da20df54d3a39e0e81f5.mp3*~data=user_id=0,application_id=42~hmac=fe7a63a2d2bd15735a758dcc752b206f4c7e06593197e224419c370b648480c3	377	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
387	3427315731	Letter To My 13 Year Old Self	296	\N	https://cdn-images.dzcdn.net/images/cover/bf1c90831483e99771c3562c92908eef/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/e/d/0/deda41653eaac587bbeda8066d18f801.mp3?hdnea=exp=1782388320~acl=/api/1/1/d/e/d/0/deda41653eaac587bbeda8066d18f801.mp3*~data=user_id=0,application_id=42~hmac=b367287bd0a2e5fc6d164b8e77ea7675ddba6ad689baf87c75a557b7d6959f53	379	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
389	2631148972	California and Me	216	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/9/4/0/094f666fd1cfba18aabd05062a95b0b2.mp3?hdnea=exp=1782388320~acl=/api/1/1/0/9/4/0/094f666fd1cfba18aabd05062a95b0b2.mp3*~data=user_id=0,application_id=42~hmac=fe8a42fb5517c379fd295410d547e43814ea1d6cf0f25d6a7a3a0935c0488df0	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
390	2309254545	Lovesick	225	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/5/a/0/35ad232a00fd516f9a72f48482c04c02.mp3?hdnea=exp=1782388320~acl=/api/1/1/3/5/a/0/35ad232a00fd516f9a72f48482c04c02.mp3*~data=user_id=0,application_id=42~hmac=1542ff6ecc6f5eb39a6fdbe9efb27d127348f67698367d958089f17bbcf6b904	313	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
391	3513670611	Clockwork	150	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/2/7/0/82704d1c51ff0f53686741f1474ee253.mp3?hdnea=exp=1782388320~acl=/api/1/1/8/2/7/0/82704d1c51ff0f53686741f1474ee253.mp3*~data=user_id=0,application_id=42~hmac=b4570f91fc444627acdad4764a54f152c4bc0c5c91ccf59fa9bfd08c2fb4522f	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
392	2317963625	Bewitched	246	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/4/8/0/a48fc5d3d2207443a2470c4fe7d57856.mp3?hdnea=exp=1782388320~acl=/api/1/1/a/4/8/0/a48fc5d3d2207443a2470c4fe7d57856.mp3*~data=user_id=0,application_id=42~hmac=a1f3c63870a37a6eab65a3630a2c19cba6e79b25b4c7e66147c158faa71226e2	381	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
393	3513670741	Sabotage	214	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/5/0/5c57f28575b4274a1d119ae3ddb2341d.mp3?hdnea=exp=1782388321~acl=/api/1/1/5/c/5/0/5c57f28575b4274a1d119ae3ddb2341d.mp3*~data=user_id=0,application_id=42~hmac=b1d790c70e936909417a360e636b28e3003816841cdff5779d6af5ca89853f63	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
394	3513670711	A Cautionary Tale	256	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/2/0/832c52591ba1a2b146b3de97c0c13a6b.mp3?hdnea=exp=1782388321~acl=/api/1/1/8/3/2/0/832c52591ba1a2b146b3de97c0c13a6b.mp3*~data=user_id=0,application_id=42~hmac=ab4c49ba5158cf069ca1a0794c09c78b4e587330f5ed60bfb91b368228b75e7c	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
395	3513670691	Forget-Me-Not	246	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/1/e/0/91e6c36fe1983ff9597842fd805c7573.mp3?hdnea=exp=1782388321~acl=/api/1/1/9/1/e/0/91e6c36fe1983ff9597842fd805c7573.mp3*~data=user_id=0,application_id=42~hmac=521dfbb04ccbc39733c6f0c708e203b403f68d33633315f610520aef1c018be9	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
396	3513670641	Castle in Hollywood	153	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/e/7/0/4e7fe0c888be3ae90792d2d3000cfa3e.mp3?hdnea=exp=1782388321~acl=/api/1/1/4/e/7/0/4e7fe0c888be3ae90792d2d3000cfa3e.mp3*~data=user_id=0,application_id=42~hmac=cac0c18bf0109220814bf4f9c08ce7d8a9c80a208a4d6dfe2a0a386219eab297	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
397	1930038247	Like the Movies	162	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/1/d/0/a1d29509e9d08aa869bcd5baad5706fa.mp3?hdnea=exp=1782388321~acl=/api/1/1/a/1/d/0/a1d29509e9d08aa869bcd5baad5706fa.mp3*~data=user_id=0,application_id=42~hmac=63a48709b15d48d2bd1383689b7d4096d00ff54f6371449ccd1b0a3c058e83b8	382	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
398	3939294171	I'll Forget About You (In Time)	252	\N	https://cdn-images.dzcdn.net/images/cover/99f872f6a3e9493e21014a879369ac1f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/3/e/0/93ecbbc7200e6e03f344c8cafa51d97b.mp3?hdnea=exp=1782388321~acl=/api/1/1/9/3/e/0/93ecbbc7200e6e03f344c8cafa51d97b.mp3*~data=user_id=0,application_id=42~hmac=4a73659c282e0c2fea450ede8f190012bacb86e7e2a12d71009d9af0b482e8d2	374	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
399	3513670651	Carousel	199	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/f/e/0/bfe5d60448fa007b7336dd8109967bfe.mp3?hdnea=exp=1782388321~acl=/api/1/1/b/f/e/0/bfe5d60448fa007b7336dd8109967bfe.mp3*~data=user_id=0,application_id=42~hmac=ecbc2b73b46e57a92064182a9f2b1ffa8de01bfc1b6f26c9c600d3b6a07610d3	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
400	3513670661	Silver Lining	197	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/5/6/0/f568284f47a29000c0baf6547e2aa3bc.mp3?hdnea=exp=1782388321~acl=/api/1/1/f/5/6/0/f568284f47a29000c0baf6547e2aa3bc.mp3*~data=user_id=0,application_id=42~hmac=cab4a680cff2c5ea9d84681859f03f5ce9abc09d0890d990faf6ab4244be385a	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
401	3513670681	Cuckoo Ballet (Interlude)	219	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/b/e/0/5bef09ea83cc87279d6da3159c99c0f6.mp3?hdnea=exp=1782388321~acl=/api/1/1/5/b/e/0/5bef09ea83cc87279d6da3159c99c0f6.mp3*~data=user_id=0,application_id=42~hmac=9fbbf85503a1db187634afcc48cf96ea0a14af196355406c0bbcdd24e5fc880f	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
402	2526506641	Have Yourself A Merry Little Christmas	258	\N	https://cdn-images.dzcdn.net/images/cover/bb43aa3eefb87cbf692c56561d215fb5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/0/b/0/70bf94fc3b6b8b5c7f418a6708825ef4.mp3?hdnea=exp=1782388321~acl=/api/1/1/7/0/b/0/70bf94fc3b6b8b5c7f418a6708825ef4.mp3*~data=user_id=0,application_id=42~hmac=79d2547bbabae260cfa80831394c4b2bed1e70f586d303c40de6df9ef8ed96e9	383	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
403	1930038237	Magnolia	180	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/f/1/0/ff17bddea1c89c9c95464273cd553932.mp3?hdnea=exp=1782388321~acl=/api/1/1/f/f/1/0/ff17bddea1c89c9c95464273cd553932.mp3*~data=user_id=0,application_id=42~hmac=da46f1900b587e514dc85b0f0126c56da888d3ba6030f129823e95b87e284624	382	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
404	3614163372	Santa Baby	182	\N	https://cdn-images.dzcdn.net/images/cover/45ad16772d73fe7c97f977f6ca0c458f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/2/c/0/72c29f25ec96ae65d25500f0a3fc576f.mp3?hdnea=exp=1782388321~acl=/api/1/1/7/2/c/0/72c29f25ec96ae65d25500f0a3fc576f.mp3*~data=user_id=0,application_id=42~hmac=296189823e312c0cd59bba32808f441ce474f557c9792e05d54d714b331675fd	384	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
405	3513670731	Clean Air	155	\N	https://cdn-images.dzcdn.net/images/cover/4d8199579dcf2790bf250e3427db8e73/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/e/5/0/6e5643a1fede8485233f4ff432a0b368.mp3?hdnea=exp=1782388321~acl=/api/1/1/6/e/5/0/6e5643a1fede8485233f4ff432a0b368.mp3*~data=user_id=0,application_id=42~hmac=a9309bb52727a11fdba35d6cca06be5913dcb04d8b9c061e92c220478329ea0e	309	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
407	2879865462	Where or When	203	\N	https://cdn-images.dzcdn.net/images/cover/bded88a124732a9c8ea77cdfef7439c6/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/8/f/0/f8f05492a554e4ed68a3fabe7b5de417.mp3?hdnea=exp=1782388321~acl=/api/1/1/f/8/f/0/f8f05492a554e4ed68a3fabe7b5de417.mp3*~data=user_id=0,application_id=42~hmac=bbf890d08dd73a452ce8c73471bd94e24f0c5453d9bed31af37be00ac898f839	385	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
408	1930038257	I Wish You Love	155	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/7/e/0/77e28e637f5c8c74703ec51d48687b20.mp3?hdnea=exp=1782388321~acl=/api/1/1/7/7/e/0/77e28e637f5c8c74703ec51d48687b20.mp3*~data=user_id=0,application_id=42~hmac=d4c341a4519855552ffcf62a02c27afd7fa5701a1c85c51ed50bdd3974f8f1a0	382	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
409	2454854675	No One Knows	239	\N	https://cdn-images.dzcdn.net/images/cover/f3474c53cd2d30dcdb1c4d68171fc627/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/e/3/0/8e3c6e53b8d5ce10830609fe9799205d.mp3?hdnea=exp=1782388321~acl=/api/1/1/8/e/3/0/8e3c6e53b8d5ce10830609fe9799205d.mp3*~data=user_id=0,application_id=42~hmac=b812f0485932b2c2976c3d32a45eb326d08e86b400d65f719d5ff14822fa7ff5	386	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
410	1930038227	Street by Street	224	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/d/e/0/bdef3823ef7ba3746b5fe4a2afe2c2d1.mp3?hdnea=exp=1782388321~acl=/api/1/1/b/d/e/0/bdef3823ef7ba3746b5fe4a2afe2c2d1.mp3*~data=user_id=0,application_id=42~hmac=94fc8b855115d9c3c80112aa1f557fc5955468e0fdf99e0d919fb132e477cdbc	382	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
411	2309254525	Must Be Love	184	\N	https://cdn-images.dzcdn.net/images/cover/3fc1aa2cb42822f6ca053b1dc9f0fdf3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/5/2/0/e5266a78ce86e1d10e801221850889cd.mp3?hdnea=exp=1782388321~acl=/api/1/1/e/5/2/0/e5266a78ce86e1d10e801221850889cd.mp3*~data=user_id=0,application_id=42~hmac=2bf8717509d22c77316bc80ac3f7e75a566451a7afdb789ad9b1b5189ee7e184	313	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
412	2631149072	It Could Happen To You	127	\N	https://cdn-images.dzcdn.net/images/cover/d24bc027d049dca1591200130a54dd8f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/3/2/0/532cb94bd125bd9c0026ff36994ba4ae.mp3?hdnea=exp=1782388321~acl=/api/1/1/5/3/2/0/532cb94bd125bd9c0026ff36994ba4ae.mp3*~data=user_id=0,application_id=42~hmac=1f06136eb7ca7bd33f54897d9cbce8753d1333a4a8972077b94c305a6b4ce886	312	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
413	2526506651	Better Than Snow	166	\N	https://cdn-images.dzcdn.net/images/cover/bb43aa3eefb87cbf692c56561d215fb5/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/1/0/0/710387c031493e72023711c3b2210ce1.mp3?hdnea=exp=1782388321~acl=/api/1/1/7/1/0/0/710387c031493e72023711c3b2210ce1.mp3*~data=user_id=0,application_id=42~hmac=294b9ec282f505192da88146f3a9ccf3eef688afe723efb0244d6bd206a79618	383	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
414	3116509371	While You Were Sleeping (Live at the Hollywood Bowl)	175	2	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/0/d/0/90d7047043aae85aa566feab51ba5d2c.mp3?hdnea=exp=1782388321~acl=/api/1/1/9/0/d/0/90d7047043aae85aa566feab51ba5d2c.mp3*~data=user_id=0,application_id=42~hmac=d492c8f435088171078a48ba689b1cee83f5c590a9473bda376713e23984648d	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
415	1930038267	James	175	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/c/4/0/4c4dd3c8b889c53f735ba44c53f3e096.mp3?hdnea=exp=1782388321~acl=/api/1/1/4/c/4/0/4c4dd3c8b889c53f735ba44c53f3e096.mp3*~data=user_id=0,application_id=42~hmac=fa2c17a0972a0066257e320c62f5ceba6d596f629073bd433d7edf10962baec3	382	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
416	3939046461	Seems Like Old Times	179	\N	https://cdn-images.dzcdn.net/images/cover/174248566aea23620f1a4aa8fc70464f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/4/6/0/b46bdf16d2dffc4a2bb0472ca6afac31.mp3?hdnea=exp=1782388321~acl=/api/1/1/b/4/6/0/b46bdf16d2dffc4a2bb0472ca6afac31.mp3*~data=user_id=0,application_id=42~hmac=c5b5a9be3c339df7b27b2af65e2a050863826782f4de828ef27121a42c57aa9f	311	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
417	3116509391	Fragile (Live at the Hollywood Bowl)	243	4	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/a/8/0/ca8aa57f40ac1607c2e74f04b90d274a.mp3?hdnea=exp=1782388321~acl=/api/1/1/c/a/8/0/ca8aa57f40ac1607c2e74f04b90d274a.mp3*~data=user_id=0,application_id=42~hmac=5223195407e7545373ad6cbda7996bc628200ba54bddc44818d300a9e1f4bca0	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
418	3614163362	Santa Claus Is Comin' To Town	159	\N	https://cdn-images.dzcdn.net/images/cover/45ad16772d73fe7c97f977f6ca0c458f/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/9/9/0/99980f50a58a17181b253aaaf01e6a64.mp3?hdnea=exp=1782388321~acl=/api/1/1/9/9/9/0/99980f50a58a17181b253aaaf01e6a64.mp3*~data=user_id=0,application_id=42~hmac=84185ec435f665997a2a81c7e402825ec52714c4591c165f01e14f8701b12794	384	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
419	2135442087	I Wish You Love (Live at The Symphony)	169	4	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/4/2/0/442a314c74f279704e1124e52b355b8d.mp3?hdnea=exp=1782388321~acl=/api/1/1/4/4/2/0/442a314c74f279704e1124e52b355b8d.mp3*~data=user_id=0,application_id=42~hmac=d7254022a82cc80f5991c5ce69ac1df447ef280688919aafa40e445272be63be	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
420	3557026091	The Risk	238	\N	https://cdn-images.dzcdn.net/images/cover/65aa1ec6cb0a79acda7fdeb02a108499/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/1/0/0/0102e547c26b7a3d664b6cc013ce2421.mp3?hdnea=exp=1782388321~acl=/api/1/1/0/1/0/0/0102e547c26b7a3d664b6cc013ce2421.mp3*~data=user_id=0,application_id=42~hmac=3588a4b7776fe48bcd528e43411735d830581712c47a67596563c3ebebe6eb82	389	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
421	3557026121	Let's Dream in the Moonlight (Take 1)	168	\N	https://cdn-images.dzcdn.net/images/cover/65aa1ec6cb0a79acda7fdeb02a108499/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/1/7/0/81713c054ec1c47c867084c040cde78f.mp3?hdnea=exp=1782388321~acl=/api/1/1/8/1/7/0/81713c054ec1c47c867084c040cde78f.mp3*~data=user_id=0,application_id=42~hmac=c77bf1c451d462f44f9d2f7bbdcaab39dc600aa3de44e002dda0b33c3eef68ae	389	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
422	3557026111	But Beautiful	272	\N	https://cdn-images.dzcdn.net/images/cover/65aa1ec6cb0a79acda7fdeb02a108499/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/b/4/0/cb46486717668a1944b73a97a93871ec.mp3?hdnea=exp=1782388321~acl=/api/1/1/c/b/4/0/cb46486717668a1944b73a97a93871ec.mp3*~data=user_id=0,application_id=42~hmac=3d84b7ec393a04f65a2516bde1a63e3de10e3db9b58e165738d82cd7472c6d4d	389	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
423	1930038287	Best Friend	164	\N	https://cdn-images.dzcdn.net/images/cover/823a340856f4242cd7195a2582b395e7/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/d/d/0/bdd038826a1b1eacd889acd4e884a1ab.mp3?hdnea=exp=1782388321~acl=/api/1/1/b/d/d/0/bdd038826a1b1eacd889acd4e884a1ab.mp3*~data=user_id=0,application_id=42~hmac=b7262dee5008b63098d7721e8fc00443ce59142256802c1d5a926dc3d6ff1972	382	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
424	1855640917	Someone New	198	\N	https://cdn-images.dzcdn.net/images/cover/0ef9646a87ab053ed8fd9f9de174183d/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/f/2/0/ff21af3a6e0ef78e2e45509124e40762.mp3?hdnea=exp=1782388321~acl=/api/1/1/f/f/2/0/ff21af3a6e0ef78e2e45509124e40762.mp3*~data=user_id=0,application_id=42~hmac=bc454f032cabf964759ba0ac18c63fbbe2f90018853a46107e318f31e391ce3b	390	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
425	1942565577	Falling Behind	173	10	https://cdn-images.dzcdn.net/images/cover/274aa382459107ae1024106e33a10d7a/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/3/6/0/d361e68f56721567cfd1d647706259b1.mp3?hdnea=exp=1782390405~acl=/api/1/1/d/3/6/0/d361e68f56721567cfd1d647706259b1.mp3*~data=user_id=0,application_id=42~hmac=7ee29379c56f96b3e5bb168156d3cd8873fc4875394d204f66f49379a2d25a9d	314	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
426	3116509361	Dreamer (Live at the Hollywood Bowl)	215	1	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/b/e/0/7be47cd2c32d9ec546488369cd7409b5.mp3?hdnea=exp=1782390558~acl=/api/1/1/7/b/e/0/7be47cd2c32d9ec546488369cd7409b5.mp3*~data=user_id=0,application_id=42~hmac=e31af1004479c06c1036542c4455b065e4300066c315243db92b65902f33cb28	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
427	3116509381	Falling Behind (Live at the Hollywood Bowl)	171	3	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/a/6/0/ba65efe7d2abf88b0083fc2aea3ff87a.mp3?hdnea=exp=1782390558~acl=/api/1/1/b/a/6/0/ba65efe7d2abf88b0083fc2aea3ff87a.mp3*~data=user_id=0,application_id=42~hmac=877a858cb0c7b5dee42a96953ba8ad6824778a21ab4393d617a5a0ad328ae0c4	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
428	3116509401	Let You Break My Heart Again (Live at the Hollywood Bowl)	304	5	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/f/7/0/ef77fac9beb45762858567b39a70e387.mp3?hdnea=exp=1782390558~acl=/api/1/1/e/f/7/0/ef77fac9beb45762858567b39a70e387.mp3*~data=user_id=0,application_id=42~hmac=984e00c91b2734d24cebcc14bf04cd7e6002ece49bc7d2735815d02922b430d0	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
429	3116509411	Valentine (Live at the Hollywood Bowl)	191	6	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/b/b/0/6bb374a7292c34afe443399c4308c18f.mp3?hdnea=exp=1782390558~acl=/api/1/1/6/b/b/0/6bb374a7292c34afe443399c4308c18f.mp3*~data=user_id=0,application_id=42~hmac=843799f0f442e80a37a73acf96cfe80f2640e3a4025fc0979cea6a1265b48ad6	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
430	3116509421	I Wish You Love (Live at the Hollywood Bowl)	157	7	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/2/8/0/028ace7974069515219a716fed435a1c.mp3?hdnea=exp=1782390558~acl=/api/1/1/0/2/8/0/028ace7974069515219a716fed435a1c.mp3*~data=user_id=0,application_id=42~hmac=b5a6a2a5f5058165cbd80c3de7f289df1edb3d0754adecdfd010e364a31577f1	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
431	3116509431	Promise (Live at the Hollywood Bowl)	233	8	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/d/f/0/4df6ed8ef734ad7ed5ea750867022ad4.mp3?hdnea=exp=1782390558~acl=/api/1/1/4/d/f/0/4df6ed8ef734ad7ed5ea750867022ad4.mp3*~data=user_id=0,application_id=42~hmac=d61165c4bb3315aadd5bcc7d72e443d1318e69ba24e4422b6dee7d9961e87e1f	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
432	3116509441	California and Me (Live at the Hollywood Bowl)	225	9	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/9/0/14905a81f77c4bec4bc544b84b15a9ca.mp3?hdnea=exp=1782390558~acl=/api/1/1/1/4/9/0/14905a81f77c4bec4bc544b84b15a9ca.mp3*~data=user_id=0,application_id=42~hmac=e1b9f434b17b234543d86affe4b5fcfdfd8f810923e51c2c694d975eb59e12ef	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
433	3116509451	Goddess (Live at the Hollywood Bowl)	304	10	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/6/5/9/0/65903f9273f13e01cb1b41dce4c6f29b.mp3?hdnea=exp=1782390558~acl=/api/1/1/6/5/9/0/65903f9273f13e01cb1b41dce4c6f29b.mp3*~data=user_id=0,application_id=42~hmac=94346408260b1a0387e5cc13df6b6366fd27cad8848acdbab85477aa5a800b2a	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
434	3116509461	It Could Happen To You (Live at the Hollywood Bowl)	125	11	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/5/0/8356639ee14a34c1fab061337e74a120.mp3?hdnea=exp=1782390558~acl=/api/1/1/8/3/5/0/8356639ee14a34c1fab061337e74a120.mp3*~data=user_id=0,application_id=42~hmac=e012740a5a1f3a1237b174a094b628fd50fb812084d1c436411c0d5f7c3740c5	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
435	3116509471	Bored (Live at the Hollywood Bowl)	229	12	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/f/8/0/bf8e3a7a540ec6b0b59aa5155939733b.mp3?hdnea=exp=1782390558~acl=/api/1/1/b/f/8/0/bf8e3a7a540ec6b0b59aa5155939733b.mp3*~data=user_id=0,application_id=42~hmac=7419d26882bbdc62dce2fa99efa1975ff8d6c99e84e4a94a82b7dace06e1208c	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
436	3116509481	Lovesick (Live at the Hollywood Bowl)	225	13	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/a/e/0/cae61ea070130648aea0146d5616773f.mp3?hdnea=exp=1782390558~acl=/api/1/1/c/a/e/0/cae61ea070130648aea0146d5616773f.mp3*~data=user_id=0,application_id=42~hmac=4d1bb93cfcc3bbc2e2266699738695c35d7ca7213e2e2dab517eedb1a34c9b6d	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
437	3116509491	Bewitched (Live at the Hollywood Bowl)	255	14	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/4/2/0/f42b8f816c476d1eb8757b710638afcb.mp3?hdnea=exp=1782390558~acl=/api/1/1/f/4/2/0/f42b8f816c476d1eb8757b710638afcb.mp3*~data=user_id=0,application_id=42~hmac=a7e7ced284709c4a413f3d0c11457e4f6088603a641805dd33fd86421e95478f	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
840	3725729472	Tommie Sunshine (TSMV TSMV Remix)	433	4	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	\N	559	2026-07-09 18:31:24.200409	2026-07-09 18:31:24.200409
438	3116509501	From The Start (Live at the Hollywood Bowl)	198	15	https://cdn-images.dzcdn.net/images/cover/f0f5c3f1a56bb2dccc834db5b07ad07b/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/2/1/0/121d24dc77922807f8b313c9a1381a7c.mp3?hdnea=exp=1782390558~acl=/api/1/1/1/2/1/0/121d24dc77922807f8b313c9a1381a7c.mp3*~data=user_id=0,application_id=42~hmac=0dc21c8d758ffedc0ef63ea83a32eb12ec77f752162c5dacb2dc74875a7660d4	387	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
439	2135442057	Fragile (Live at The Symphony)	249	1	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/c/9/0/3c961aa6c690f0bc8ef369385572d821.mp3?hdnea=exp=1782391511~acl=/api/1/1/3/c/9/0/3c961aa6c690f0bc8ef369385572d821.mp3*~data=user_id=0,application_id=42~hmac=c7bfff0ce88de302c7f507a22bd1f2d918aa7dbb1e3ba839c70727c25aad6caa	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
440	2135442067	Valentine (Live at The Symphony)	180	2	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/7/7/0/d77928e08130b5eecc701365e73b6619.mp3?hdnea=exp=1782391511~acl=/api/1/1/d/7/7/0/d77928e08130b5eecc701365e73b6619.mp3*~data=user_id=0,application_id=42~hmac=0e5254470b0f13c1221cfe0f5ddc136a1426acfa3c098da3f7356e25576b222c	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
441	2135442077	Dear Soulmate (Live at The Symphony)	292	3	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/f/a/7/0/fa708471441750fce28d6105ac56ee4f.mp3?hdnea=exp=1782391511~acl=/api/1/1/f/a/7/0/fa708471441750fce28d6105ac56ee4f.mp3*~data=user_id=0,application_id=42~hmac=de5774c6ed43d8b7a9fcb9ba2b99209217ac0a627561e78058f248256d6477a1	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
442	2135442097	Night Light (Live at The Symphony)	247	5	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/f/0/0/9f04a5331e9fa75d28cb88b0c9cdc15b.mp3?hdnea=exp=1782391511~acl=/api/1/1/9/f/0/0/9f04a5331e9fa75d28cb88b0c9cdc15b.mp3*~data=user_id=0,application_id=42~hmac=e3e9683c38c71994f32a92fcdd3d9c995afdc62eb23bdb6c3186423b3d7130bf	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
443	2135442107	Ég Veit Þú Kemur (Live at The Symphony)	216	6	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/4/4/0/e44ac2d52a405d7a46ab6d59ecaa40fb.mp3?hdnea=exp=1782391511~acl=/api/1/1/e/4/4/0/e44ac2d52a405d7a46ab6d59ecaa40fb.mp3*~data=user_id=0,application_id=42~hmac=15babbc965f458d50220fc1df9ea124e2ddd97726e7f13b5b96297b35a3b88cb	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
444	2135442117	Falling Behind (Live at The Symphony)	175	7	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/f/0/0/8f0d9820a04bbb57414423b431529f32.mp3?hdnea=exp=1782391511~acl=/api/1/1/8/f/0/0/8f0d9820a04bbb57414423b431529f32.mp3*~data=user_id=0,application_id=42~hmac=b068ee41942733e126d0538eeae0431d899d484680eb4c3e37d383496c07f9f3	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
445	2135442127	Best Friend (Live at The Symphony)	179	8	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/b/4/0/7b46cf697dca992ba64f71f74ecd1ee5.mp3?hdnea=exp=1782391511~acl=/api/1/1/7/b/4/0/7b46cf697dca992ba64f71f74ecd1ee5.mp3*~data=user_id=0,application_id=42~hmac=f265b5371458120f2cc2fe1f1b27c7e995f9855f4bbced09aa7d6a3d4b108cf6	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
446	2135442137	Like the Movies (Live at The Symphony)	212	9	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/d/6/0/ed66ddf8d01bf213675613cbd8d2581d.mp3?hdnea=exp=1782391511~acl=/api/1/1/e/d/6/0/ed66ddf8d01bf213675613cbd8d2581d.mp3*~data=user_id=0,application_id=42~hmac=8d6ad9a5bb0387e8aecd1a341cbe328339490c44742145393bae32df4a2ff334	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
447	2135442147	The Nearness of You (Live at The Symphony)	168	10	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/1/0/141c311658fc720ca00987f5e33a2cfd.mp3?hdnea=exp=1782391511~acl=/api/1/1/1/4/1/0/141c311658fc720ca00987f5e33a2cfd.mp3*~data=user_id=0,application_id=42~hmac=7f30fda78070c3d6e4ad73ec31c47a376341ce972286c32e396af34d9a5fd1e9	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
448	2135442157	Let You Break My Heart Again (Live at The Symphony)	302	11	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/5/c/1/0/5c1b62749f581cad63730031112b1ec4.mp3?hdnea=exp=1782391511~acl=/api/1/1/5/c/1/0/5c1b62749f581cad63730031112b1ec4.mp3*~data=user_id=0,application_id=42~hmac=b0f635c0ff2b03d9fe95639a19150dc4b6c3f0a7fab69469f46995f790a9fe2a	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
449	2135442167	What Love Will Do to You (Live at The Symphony)	180	12	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/0/c/0/90c8e1bbeea479c7da9d544d5d086e8f.mp3?hdnea=exp=1782391511~acl=/api/1/1/9/0/c/0/90c8e1bbeea479c7da9d544d5d086e8f.mp3*~data=user_id=0,application_id=42~hmac=f4ab412a32db320d9e316e9be1d2edc315de66aa6711789c306a0e6d6ec4bbbc	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
450	2135442177	Beautiful Stranger (Live at The Symphony)	211	13	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/2/f/6/0/2f665ed4b00a89ef5a45cef9f36bd3f8.mp3?hdnea=exp=1782391511~acl=/api/1/1/2/f/6/0/2f665ed4b00a89ef5a45cef9f36bd3f8.mp3*~data=user_id=0,application_id=42~hmac=d8d9fa336aa4edb7c388c24de5d247a96a26cf34a92c3a91b39ee312a6f72510	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
451	2135442187	Everytime We Say Goodbye (Live at The Symphony)	273	14	https://cdn-images.dzcdn.net/images/cover/c8db50be5ef05fcca645b3c41a930578/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/3/2/0/83204fb49fe6e010009b991411177528.mp3?hdnea=exp=1782391511~acl=/api/1/1/8/3/2/0/83204fb49fe6e010009b991411177528.mp3*~data=user_id=0,application_id=42~hmac=a6c0ab006312fb9f28b87b57827171d3b9564650ad977dec94e1ff95065b0073	388	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
452	635259462	~	89	\N	https://cdn-images.dzcdn.net/images/cover/401b6e6a78863b74d41d4b04170e67fc/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/c/e/6/0/ce6f644aa22ce8bbdccfe137f6a5fa06.mp3?hdnea=exp=1782743440~acl=/api/1/1/c/e/6/0/ce6f644aa22ce8bbdccfe137f6a5fa06.mp3*~data=user_id=0,application_id=42~hmac=a919c16be6157f64c9d3477b48b1edef76d4882f04c5633869afebc6652514ee	405	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
453	3516066621	~metal dream	182	\N	https://cdn-images.dzcdn.net/images/cover/c4ba2ef789f09b0ac549867d97f4a229/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/6/6/0/866a40686ca38c26dfe87550c1797690.mp3?hdnea=exp=1782743440~acl=/api/1/1/8/6/6/0/866a40686ca38c26dfe87550c1797690.mp3*~data=user_id=0,application_id=42~hmac=cda9a816154be2499c9730a62dcc740187c096444af45773316821445176a76d	406	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
841	3725729482	Spider Mix	514	5	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	\N	559	2026-07-09 18:31:24.200409	2026-07-09 18:31:24.200409
454	3776814452	~	65	\N	https://cdn-images.dzcdn.net/images/cover/8b00e03400711d00290ab95c7bc707ce/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/0/4/8/0/0483b5b1c6353746b69143a32dbabbc4.mp3?hdnea=exp=1782743440~acl=/api/1/1/0/4/8/0/0483b5b1c6353746b69143a32dbabbc4.mp3*~data=user_id=0,application_id=42~hmac=d1f189f1cdd0f5d974bc79ba7158066431e22c5930a96db6f048c9c37c14309f	407	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
455	1460822842	~	120	\N	https://cdn-images.dzcdn.net/images/cover/f838a8f0c27cc7b870cb643ecfe9db14/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/7/e/0/37eafe10b94b025ef98a38623a7cd4c7.mp3?hdnea=exp=1782743440~acl=/api/1/1/3/7/e/0/37eafe10b94b025ef98a38623a7cd4c7.mp3*~data=user_id=0,application_id=42~hmac=6d8eed7093661f1486ac62aa2219575227e49a1d06088452602afdd0c3f4b693	408	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
456	576265182	~ (Live)	97	\N	https://cdn-images.dzcdn.net/images/cover/4ccefb038b2dadca2228ad4e2058bc37/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/7/5/0/9751b94a243e3b67ec8f9588414b8779.mp3?hdnea=exp=1782743440~acl=/api/1/1/9/7/5/0/9751b94a243e3b67ec8f9588414b8779.mp3*~data=user_id=0,application_id=42~hmac=50189adf12f007760b1642add722a3d32982f1413cd26614bda6b80e67588dca	409	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
457	4005996151	malice mizer	112	\N	https://cdn-images.dzcdn.net/images/cover/3724396b09aee98edf0d42ec63dc6cea/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/b/7/0/3b7ea20fff97baeab532ceccb3cae265.mp3?hdnea=exp=1782743709~acl=/api/1/1/3/b/7/0/3b7ea20fff97baeab532ceccb3cae265.mp3*~data=user_id=0,application_id=42~hmac=fce80fdb5498582a5d43e9c06583c6d118befbbb7bc1a51835601add0ff3215f	415	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
458	2388623665	GEKKA NO YASO KYOKU (Cover)	111	\N	https://cdn-images.dzcdn.net/images/cover/b31800e179fa55343f8d603dd69102ac/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/d/6/8/0/d687a9fde2a02987839f4d716b31532c.mp3?hdnea=exp=1782743709~acl=/api/1/1/d/6/8/0/d687a9fde2a02987839f4d716b31532c.mp3*~data=user_id=0,application_id=42~hmac=364bd44c064bc12b1c688b3e93308851e70d27e54b532f5db9173a7fd856cb9b	416	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
459	4010094321	ma chérie ～愛しい君へ～	274	\N	https://cdn-images.dzcdn.net/images/cover/7de32f482f7d8bf43873baa2d766e459/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/1/4/e/0/14efe57f0757838e5a347a9da2735195.mp3?hdnea=exp=1782743709~acl=/api/1/1/1/4/e/0/14efe57f0757838e5a347a9da2735195.mp3*~data=user_id=0,application_id=42~hmac=b612637cdb1d75d914953638b06a5eafe3e6d8463b7f5f9d552b27d7517b0c9f	417	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
460	3947847611	Prologue～回想～	346	\N	https://cdn-images.dzcdn.net/images/cover/877b0a2795289cd8adb2e1ee2e6e266c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/7/6/9/0/7692685ae6adbbce70e56c43b5f9e6b4.mp3?hdnea=exp=1782743709~acl=/api/1/1/7/6/9/0/7692685ae6adbbce70e56c43b5f9e6b4.mp3*~data=user_id=0,application_id=42~hmac=eb821cbe2081851fe7d0e9e89c9d0c44b85b9f7a653596f5efe12a9b814d1058	418	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
461	3947847601	Houkai jokyoku	295	\N	https://cdn-images.dzcdn.net/images/cover/877b0a2795289cd8adb2e1ee2e6e266c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/4/f/4/0/4f4b25f7710c4a34cfde43e0966de1b2.mp3?hdnea=exp=1782743709~acl=/api/1/1/4/f/4/0/4f4b25f7710c4a34cfde43e0966de1b2.mp3*~data=user_id=0,application_id=42~hmac=3925eb80eaba888cc9276a3dd1b0bb446a3cc0a3596506ffdb34fa3187683207	418	2026-07-06 13:33:02.149504	2026-07-07 13:32:49.856166
462	3025678011	Hymne à l'amour (Live aux Jeux Olympiques de Paris 2024 / Live from the Olympic Games Paris 2024)	229	\N	https://cdn-images.dzcdn.net/images/cover/643d861edc0a6aa60d235344b65d28cd/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/e/4/f/0/e4f8c8c3ac53a5016dba3fa28c82621d.mp3?hdnea=exp=1783345865~acl=/api/1/1/e/4/f/0/e4f8c8c3ac53a5016dba3fa28c82621d.mp3*~data=user_id=0,application_id=42~hmac=57f4c9a257fa3dad42c0533105bb0986a6104d02415cb58038fbd3bb7f1afb6f	419	2026-07-06 13:36:06.501496	2026-07-07 13:32:49.856166
463	4097820141	Le ciel s’effondre	157	\N	https://cdn-images.dzcdn.net/images/cover/7d6cdcaf8653ac2774850a9de51f10a3/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/4/5/0/b45f306037d708978e0506dc279fa277.mp3?hdnea=exp=1783345865~acl=/api/1/1/b/4/5/0/b45f306037d708978e0506dc279fa277.mp3*~data=user_id=0,application_id=42~hmac=536b077e3ce8642d228bdf2a446bd6870dbe1193b30d728e58c27b876a8a279c	420	2026-07-06 13:36:06.501496	2026-07-07 13:32:49.856166
464	532589062	Le temps est bon	210	\N	https://cdn-images.dzcdn.net/images/cover/91a0814b55c7d9d89dcf20840cf0fda2/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/3/7/d/0/37de80c1f678c8097d2fbb82156eb15f.mp3?hdnea=exp=1783345865~acl=/api/1/1/3/7/d/0/37de80c1f678c8097d2fbb82156eb15f.mp3*~data=user_id=0,application_id=42~hmac=dc783ad2a718637769ee7d4f45013920667985115e139e30ce7305405ee93fff	421	2026-07-06 13:36:06.501496	2026-07-07 13:32:49.856166
465	4117899721	le ciel	300	\N	https://cdn-images.dzcdn.net/images/cover/30b147ccefae586fb9d5840dceb2d7e4/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/8/0/4/0/804ffcca65ff521c9a95e639d12f1fda.mp3?hdnea=exp=1783345865~acl=/api/1/1/8/0/4/0/804ffcca65ff521c9a95e639d12f1fda.mp3*~data=user_id=0,application_id=42~hmac=88908ce325c404bcef51f1fa810dd42b93511d1911a0ee9f9cfc19aa13bd337a	422	2026-07-06 13:36:06.501496	2026-07-07 13:32:49.856166
466	441137172	Christine	234	\N	https://cdn-images.dzcdn.net/images/cover/d9fcaf9ab19436cce27af945d86eea98/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/b/6/a/0/b6a07e0076728f671cfac242a3f95198.mp3?hdnea=exp=1783345865~acl=/api/1/1/b/6/a/0/b6a07e0076728f671cfac242a3f95198.mp3*~data=user_id=0,application_id=42~hmac=5d470137ad91e37147ef31fd65d57b6193f51b21b3ce5482b92c38bdb925dfd0	423	2026-07-06 13:36:06.501496	2026-07-07 13:32:49.856166
467	3947847591	Gardenia	314	\N	https://cdn-images.dzcdn.net/images/cover/877b0a2795289cd8adb2e1ee2e6e266c/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/9/2/0/0/920f36c5c63760eb70624db8dfa09ba8.mp3?hdnea=exp=1783345896~acl=/api/1/1/9/2/0/0/920f36c5c63760eb70624db8dfa09ba8.mp3*~data=user_id=0,application_id=42~hmac=81ec038eb511a14abf1c1d9de5841651df08e0039ad6086b5f192b365964d569	418	2026-07-06 13:36:37.608388	2026-07-07 13:32:49.856166
468	4010094391	Le Ciel	305	\N	https://cdn-images.dzcdn.net/images/cover/7de32f482f7d8bf43873baa2d766e459/1000x1000-000000-80-0-0.jpg	https://cdnt-preview.dzcdn.net/api/1/1/a/3/0/0/a3066dac9c56d97359ea8ef1e35d541f.mp3?hdnea=exp=1783345896~acl=/api/1/1/a/3/0/0/a3066dac9c56d97359ea8ef1e35d541f.mp3*~data=user_id=0,application_id=42~hmac=bddaf08cfa81e2278e0b19ce811de2cad4ae01db67ede2a891331447806d9f80	417	2026-07-06 13:36:37.608388	2026-07-07 13:32:49.856166
842	3725729492	The Birthday Massacre (Accapella Mix)	160	6	https://cdn-images.dzcdn.net/images/cover/6e8a7b70c1e088ddaa91c584a1ddbfea/1000x1000-000000-80-0-0.jpg	\N	559	2026-07-09 18:31:24.200409	2026-07-09 18:31:24.200409
1078	116348470	Sun King (Remastered 2009)	146	10	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1079	116348472	Mean Mr Mustard (Remastered 2009)	66	11	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1080	116348474	Polythene Pam (Remastered 2009)	72	12	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1081	116348476	She Came In Through The Bathroom Window (Remastered 2009)	117	13	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1082	116348478	Golden Slumbers (Remastered 2009)	91	14	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1083	116348480	Carry That Weight (Remastered 2009)	96	15	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1084	116348482	The End (Remastered 2009)	142	16	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1085	116348484	Her Majesty (Remastered 2009)	25	17	https://cdn-images.dzcdn.net/images/cover/aa94ab293730bb7845d2aa8c672b2c29/1000x1000-000000-80-0-0.jpg	\N	438	2026-07-12 08:33:19.902048	2026-07-12 08:33:19.902048
1086	3769101132	Never Wanted To Dance	188	1	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1087	3769101142	Evening Wear	211	2	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1088	3769101152	Lights Out	157	3	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1089	3769101162	Prescription	185	4	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1090	3769101172	Issues	184	5	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1091	3769101182	Get It Up	155	6	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1092	3769101192	Revenge	188	7	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1093	3769101202	Animal	164	8	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1094	3769101212	Mastermind	179	9	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1095	3769101222	On It	181	10	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1096	3769101232	Pay For It	213	11	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1097	3769101242	Due	130	12	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1098	3769101252	Money	173	13	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1099	3769101262	Bomb This Track	200	14	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1100	3769101272	Mark David Chapmen	194	15	https://cdn-images.dzcdn.net/images/cover/e4b5d18a4104ee3a97c5747e3a4578b0/1000x1000-000000-80-0-0.jpg	\N	190	2026-07-12 09:26:41.924924	2026-07-12 09:26:41.924924
1101	2618842302	держава живе людина існує	142	1	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1102	2618842322	аїд	166	3	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1103	2618842332	звіру дякую	177	4	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1104	2618842342	хліба та видовищ	214	5	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1105	2618842352	покажи реп	149	6	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1106	2618842362	жаль	150	7	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1107	2618842372	independence	156	8	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1108	2618842382	police country	137	9	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1109	2618842392	безумства	148	10	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1110	2618842402	хочеш - епілог	102	11	https://cdn-images.dzcdn.net/images/cover/0a6ba8358dccad0918a99cab6da134d4/1000x1000-000000-80-0-0.jpg	\N	220	2026-07-12 14:52:20.107691	2026-07-12 14:52:20.107691
1112	503180042	A Double Suicide	192	\N	https://cdn-images.dzcdn.net/images/cover/65a014c2247a839964bbc3627d3876de/1000x1000-000000-80-0-0.jpg	\N	722	2026-07-13 09:32:59.466122	2026-07-13 09:32:59.466122
1113	4130015221	naked	197	\N	https://cdn-images.dzcdn.net/images/cover/f2bbf239b1cda8d5c3cc6b26449587a3/1000x1000-000000-80-0-0.jpg	\N	723	2026-07-13 09:32:59.466122	2026-07-13 09:32:59.466122
1114	503180002	Ma Vie, Mes Rêves	194	\N	https://cdn-images.dzcdn.net/images/cover/65a014c2247a839964bbc3627d3876de/1000x1000-000000-80-0-0.jpg	\N	722	2026-07-13 09:32:59.466122	2026-07-13 09:32:59.466122
1115	799446412	Crime And Punishment	281	\N	https://cdn-images.dzcdn.net/images/cover/fdbff2a426d6138a067806a5c2d3c736/1000x1000-000000-80-0-0.jpg	\N	724	2026-07-13 09:32:59.466122	2026-07-13 09:32:59.466122
1116	3880023611	La velada legendaria	378	\N	https://cdn-images.dzcdn.net/images/cover/7925ce48499657b150d7457141b27e35/1000x1000-000000-80-0-0.jpg	\N	725	2026-07-13 09:33:04.46928	2026-07-13 09:33:04.46928
1117	503181032	Consciously	160	\N	https://cdn-images.dzcdn.net/images/cover/27a0de9715bb8e20060d72233c3f3297/1000x1000-000000-80-0-0.jpg	\N	727	2026-07-13 09:33:04.46928	2026-07-13 09:33:04.46928
1118	3880023621	downers or uppers	209	\N	https://cdn-images.dzcdn.net/images/cover/7925ce48499657b150d7457141b27e35/1000x1000-000000-80-0-0.jpg	\N	725	2026-07-13 09:33:04.46928	2026-07-13 09:33:04.46928
1119	3880023771	antiwar	187	\N	https://cdn-images.dzcdn.net/images/cover/7925ce48499657b150d7457141b27e35/1000x1000-000000-80-0-0.jpg	\N	725	2026-07-13 09:33:04.46928	2026-07-13 09:33:04.46928
1120	503180032	Le Vœu D'amour	244	\N	https://cdn-images.dzcdn.net/images/cover/65a014c2247a839964bbc3627d3876de/1000x1000-000000-80-0-0.jpg	\N	722	2026-07-13 09:33:04.46928	2026-07-13 09:33:04.46928
1126	8025463	Straight To Video	223	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-14 11:31:20.782301	2026-07-14 11:31:20.782301
1127	8025469	1989	118	\N	https://cdn-images.dzcdn.net/images/cover/8e2ce2e94480d39fe00b17d5e1c0c686/1000x1000-000000-80-0-0.jpg	\N	189	2026-07-14 11:31:20.782301	2026-07-14 11:31:20.782301
1128	1396680942	Cadillac	177	\N	https://cdn-images.dzcdn.net/images/cover/323dae988c88cda6b6b90fd7b0bc0f71/1000x1000-000000-80-0-0.jpg	\N	731	2026-07-14 11:32:33.543759	2026-07-14 11:32:33.543759
1129	1390581002	RATATATATA	118	\N	https://cdn-images.dzcdn.net/images/cover/c05bc7d37f1bca6c8f9d5b9d18adb9f5/1000x1000-000000-80-0-0.jpg	\N	732	2026-07-14 11:32:33.543759	2026-07-14 11:32:33.543759
1130	1390591922	Cristal & MOYOT	137	\N	https://cdn-images.dzcdn.net/images/cover/c011ffbe3a5a78892f86c21b53c7e01f/1000x1000-000000-80-0-0.jpg	\N	733	2026-07-14 11:32:33.543759	2026-07-14 11:32:33.543759
1131	2290644765	ПОЙДЕТ	120	\N	https://cdn-images.dzcdn.net/images/cover/8b3349e4784a7328478c7bb0f511047b/1000x1000-000000-80-0-0.jpg	\N	734	2026-07-14 11:32:33.543759	2026-07-14 11:32:33.543759
1132	2126923567	El Problema	136	\N	https://cdn-images.dzcdn.net/images/cover/4eaac630af063ac7acec9094068cdefc/1000x1000-000000-80-0-0.jpg	\N	735	2026-07-14 11:32:33.543759	2026-07-14 11:32:33.543759
1133	3363489311	Morgen	190	\N	https://cdn-images.dzcdn.net/images/cover/5e1ff11c8690c36ed742a599f8348402/1000x1000-000000-80-0-0.jpg	\N	739	2026-07-14 11:32:58.484143	2026-07-14 11:32:58.484143
1134	1566201462	Mörge!	240	\N	https://cdn-images.dzcdn.net/images/cover/4ff04fb191c33744a672251328494d66/1000x1000-000000-80-0-0.jpg	\N	740	2026-07-14 11:32:58.484143	2026-07-14 11:32:58.484143
1135	630594532	Morgenstern	239	\N	https://cdn-images.dzcdn.net/images/cover/633b009c486f17d1aef7fef6b1151201/1000x1000-000000-80-0-0.jpg	\N	741	2026-07-14 11:32:58.484143	2026-07-14 11:32:58.484143
990	3740319482	mongolian chop squad	141	3	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	\N	623	2026-07-11 15:28:03.507889	2026-07-19 08:27:26.992804
1147	3740319492	superbad	98	4	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	\N	623	2026-07-19 08:27:26.992804	2026-07-19 08:27:26.992804
1148	3740319502	aint it cool	115	5	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	\N	623	2026-07-19 08:27:26.992804	2026-07-19 08:27:26.992804
1149	3740319512	show em	123	6	https://cdn-images.dzcdn.net/images/cover/5cbbafedb16126a870b25a979c8c37e1/1000x1000-000000-80-0-0.jpg	\N	623	2026-07-19 08:27:26.992804	2026-07-19 08:27:26.992804
1150	2791984152	Luv (sic) pt2	275	2	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1151	2791984172	Luv (sic) pt4 (feat. Shing02)	312	4	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1152	2791984182	Luv (sic) pt5 (feat. Shing02)	349	5	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1153	2791984192	Luv (sic) Grand Finale (feat. Shing02)	316	6	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1154	2791984202	Luv (sic) 12" Remix	297	7	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1155	2791984212	Luv (sic) pt2 Acoustica	393	8	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1156	2791984222	Luv (sic.) pt3 Ta-ku Remix	296	9	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1157	2791984232	Luv (sic) pt4 LASTorder Remix	278	10	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1158	2791984242	Luv (sic) pt5 Jumpster Remix	278	11	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1159	2791984252	Luv (sic) pt6 Uyama Hiroto Remix	278	12	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1160	2791984262	Perfect Circle	240	13	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1161	2791984272	Luv (sic) Instrumentals	286	1	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1162	2791984282	Luv (sic) pt 2 Instrumentals	273	2	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1163	2791984292	Luv (sic.) pt 3 Instrumentals	374	3	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1164	2791984302	Luv (sic) pt 4 Instrumentals	310	4	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1165	2791984312	Luv (sic) pt5 Instrumentals	349	5	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1166	2791984322	Luv (sic) Grand Finale Instrumentals	316	6	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1167	2791984332	Luv (sic) 12" Remix Instrumentals	297	7	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1168	2791984342	Luv (sic) pt2 Acoustica Instrumentals	391	8	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1169	2791984352	Luv (sic.) pt3 Ta-ku Remix Instrumentals	296	9	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1170	2791984362	Luv (sic) pt 4 LASTorder Remix Instrumentals	278	10	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1171	2791984372	Luv (sic) pt5 Jumpster Remix Instrumentals	279	11	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1172	2791984382	Luv(sic) pt6 Uyama Hiroto Remix Instrumentals	278	12	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1173	2791984392	Perfect Circle Instrumentals	240	13	https://cdn-images.dzcdn.net/images/cover/201983bc07578a0e374c993c91013533/1000x1000-000000-80-0-0.jpg	\N	181	2026-07-19 08:27:45.050899	2026-07-19 08:27:45.050899
1174	3013502331	Я вже не ти	162	1	https://cdn-images.dzcdn.net/images/cover/a87ea227fd69bcbddd59c2c7fe657de7/1000x1000-000000-80-0-0.jpg	\N	753	2026-07-19 10:22:31.536686	2026-07-19 10:22:31.536686
1207	2421517715	I Want To Be Black	129	\N	https://cdn-images.dzcdn.net/images/cover/82615f22e2b0b4a8247942976a998d61/1000x1000-000000-80-0-0.jpg	\N	555	2026-07-19 13:34:43.587932	2026-07-19 13:34:43.587932
1208	129632340	Let Me Love You	205	\N	https://cdn-images.dzcdn.net/images/cover/6a52e1bbddc750c996a66b0ccfa4370c/1000x1000-000000-80-0-0.jpg	\N	786	2026-07-19 13:35:28.257368	2026-07-19 13:35:28.257368
1209	112662364	What Do You Mean?	205	\N	https://cdn-images.dzcdn.net/images/cover/340283aafac320864b207c420124ee46/1000x1000-000000-80-0-0.jpg	\N	787	2026-07-19 13:35:28.257368	2026-07-19 13:35:28.257368
1212	12235150	What Do They Know?	188	4	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
1213	12235151	2 Hookers And An 8 Ball	137	5	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
1214	12235152	Prom	148	6	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
1215	12235153	Bullshit	161	7	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
1216	12235154	Tom Sawyer	144	8	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
1217	12235156	You'll Rebel To Anything	152	10	https://cdn-images.dzcdn.net/images/cover/ab0c81d100591df1fbaa078ecc39bd3f/1000x1000-000000-80-0-0.jpg	\N	556	2026-07-24 09:31:09.004273	2026-07-24 09:31:09.004273
1218	1225581432	Killshot (Slowed + Reverb)	278	\N	https://cdn-images.dzcdn.net/images/cover/23b8217031ed6b93d2a8068ed247625b/1000x1000-000000-80-0-0.jpg	\N	788	2026-07-24 13:48:29.286751	2026-07-24 13:48:29.286751
1219	902272062	Killshot	236	\N	https://cdn-images.dzcdn.net/images/cover/bfe8069fbbf5226c9c6e589c8a7504b4/1000x1000-000000-80-0-0.jpg	\N	789	2026-07-24 13:48:29.286751	2026-07-24 13:48:29.286751
1220	3484519931	Image	212	\N	https://cdn-images.dzcdn.net/images/cover/a1e2df90b6ac6e57bfadb965d9aa503a/1000x1000-000000-80-0-0.jpg	\N	790	2026-07-24 13:48:29.286751	2026-07-24 13:48:29.286751
1221	4116951	Monster	178	\N	https://cdn-images.dzcdn.net/images/cover/fce6fe4cf02a3c78cedb8eb32fa4fa31/1000x1000-000000-80-0-0.jpg	\N	795	2026-07-24 14:42:40.344925	2026-07-24 14:42:40.344925
1222	3910168591	Dead Man Walking	164	\N	https://cdn-images.dzcdn.net/images/cover/e7f3b75a4710c53686f323e419223fb1/1000x1000-000000-80-0-0.jpg	\N	796	2026-07-24 14:42:40.344925	2026-07-24 14:42:40.344925
1223	3884346631	Skill	144	\N	https://cdn-images.dzcdn.net/images/cover/139c56818176a31cd90081b33d32d09e/1000x1000-000000-80-0-0.jpg	\N	797	2026-07-24 14:42:40.344925	2026-07-24 14:42:40.344925
1224	2751425071	I Just Want To Dance	149	\N	https://cdn-images.dzcdn.net/images/cover/df01892eba28751796d3e2c7c47b23ef/1000x1000-000000-80-0-0.jpg	\N	798	2026-07-24 14:42:40.344925	2026-07-24 14:42:40.344925
1225	3847241511	The Hunt	152	\N	https://cdn-images.dzcdn.net/images/cover/2ff1d0421f771b90836cfc39ce572199/1000x1000-000000-80-0-0.jpg	\N	799	2026-07-24 14:42:40.344925	2026-07-24 14:42:40.344925
1226	34991481	1989 (Clean Version)	117	\N	https://cdn-images.dzcdn.net/images/cover/a59fadeda468b0c58e1179cc728f98c5/1000x1000-000000-80-0-0.jpg	\N	560	2026-07-29 08:43:28.503723	2026-07-29 08:43:28.503723
1227	34991491	Straight To Video (Clean Version)	224	\N	https://cdn-images.dzcdn.net/images/cover/a59fadeda468b0c58e1179cc728f98c5/1000x1000-000000-80-0-0.jpg	\N	560	2026-07-29 08:43:28.503723	2026-07-29 08:43:28.503723
1228	34991541	2 H******s And An 8 B*** (Clean Version)	137	\N	https://cdn-images.dzcdn.net/images/cover/a59fadeda468b0c58e1179cc728f98c5/1000x1000-000000-80-0-0.jpg	\N	560	2026-07-29 08:43:28.503723	2026-07-29 08:43:28.503723
1229	34991501	Tom Sawyer (Clean Version)	144	\N	https://cdn-images.dzcdn.net/images/cover/a59fadeda468b0c58e1179cc728f98c5/1000x1000-000000-80-0-0.jpg	\N	560	2026-07-29 08:43:28.503723	2026-07-29 08:43:28.503723
1259	2223211057	Bach (Mandragora & Devochka Remix)	339	\N	https://cdn-images.dzcdn.net/images/cover/051e6cc55ed73d5bfcc73a4aeb92114b/1000x1000-000000-80-0-0.jpg	\N	801	2026-08-07 12:26:39.208958	2026-08-07 12:26:39.208958
1260	1753549417	La Bachata	162	\N	https://cdn-images.dzcdn.net/images/cover/88390e8360f6f28138ab200efd1f9a6f/1000x1000-000000-80-0-0.jpg	\N	802	2026-08-07 12:26:39.208958	2026-08-07 12:26:39.208958
1261	836537162	Bach (Première variation)	81	\N	https://cdn-images.dzcdn.net/images/cover/bfcf260f3ca1eaea676a1f9f83927798/1000x1000-000000-80-0-0.jpg	\N	803	2026-08-07 12:26:39.208958	2026-08-07 12:26:39.208958
1262	836537262	Bach (Deuxième variation)	90	\N	https://cdn-images.dzcdn.net/images/cover/bfcf260f3ca1eaea676a1f9f83927798/1000x1000-000000-80-0-0.jpg	\N	803	2026-08-07 12:26:39.208958	2026-08-07 12:26:39.208958
1263	71481358	Bach (Original Mix)	415	\N	https://cdn-images.dzcdn.net/images/cover/aef04736b26bcc467800566619626655/1000x1000-000000-80-0-0.jpg	\N	804	2026-08-07 12:26:39.208958	2026-08-07 12:26:39.208958
1272	923175682	Moonlight Sonata	331	\N	https://cdn-images.dzcdn.net/images/cover/a5581fca84c28ea419efc8b6cb788172/1000x1000-000000-80-0-0.jpg	\N	814	2026-08-07 12:27:51.207031	2026-08-07 12:27:51.207031
1273	969717102	Moonlight Sonata (First Movement)	302	\N	https://cdn-images.dzcdn.net/images/cover/b523e17e7991aff979b47d2d9f675310/1000x1000-000000-80-0-0.jpg	\N	815	2026-08-07 12:27:51.207031	2026-08-07 12:27:51.207031
1274	71548227	Moonlight Sonata	447	\N	https://cdn-images.dzcdn.net/images/cover/c6b54ae7af4992902349d909da34c0e2/1000x1000-000000-80-0-0.jpg	\N	816	2026-08-07 12:27:51.207031	2026-08-07 12:27:51.207031
1275	969717122	Moonlight Sonata (Third Movement)	411	\N	https://cdn-images.dzcdn.net/images/cover/b523e17e7991aff979b47d2d9f675310/1000x1000-000000-80-0-0.jpg	\N	815	2026-08-07 12:27:51.207031	2026-08-07 12:27:51.207031
1276	1966820247	Moonlight Sonata (3rd Movement)	364	\N	https://cdn-images.dzcdn.net/images/cover/8c98651f639be65ab35f5bf2fb3b8cca/1000x1000-000000-80-0-0.jpg	\N	817	2026-08-07 12:27:51.207031	2026-08-07 12:27:51.207031
1281	654739482	Bach, JS: Violin Sonata No. 4 in C Minor, BWV 1017: I. Siciliano. Largo	234	\N	https://cdn-images.dzcdn.net/images/cover/e8d282ccf7ef470d5aec53f806843e25/1000x1000-000000-80-0-0.jpg	\N	810	2026-08-07 12:39:32.60196	2026-08-07 12:39:32.60196
1282	14519841	Bach Sonata No 1 In G Minor - Siciliano	180	\N	https://cdn-images.dzcdn.net/images/cover/bf38372e8557860687203f225d84ef78/1000x1000-000000-80-0-0.jpg	\N	811	2026-08-07 12:39:32.60196	2026-08-07 12:39:32.60196
1283	14519839	Bach Sonata No 1 In G Minor - Adagio	261	\N	https://cdn-images.dzcdn.net/images/cover/bf38372e8557860687203f225d84ef78/1000x1000-000000-80-0-0.jpg	\N	811	2026-08-07 12:39:32.60196	2026-08-07 12:39:32.60196
1284	2883372982	Bach, JS: Flute Sonata in E-Flat Major, BWV 1031: II. Siciliano (Transcr. Tharaud for Piano)	186	\N	https://cdn-images.dzcdn.net/images/cover/ed497dcdf68b15c0542e492cb2d4ac1e/1000x1000-000000-80-0-0.jpg	\N	812	2026-08-07 12:39:32.60196	2026-08-07 12:39:32.60196
1285	549264892	Organ Sonata No. 4, BWV 528 : J.S. Bach: Organ Sonata No. 4, BWV 528: II. Andante [Adagio] (Transcr. by August Stradal)	326	\N	https://cdn-images.dzcdn.net/images/cover/e1cb539536a6916a3a45d0151a4b1d92/1000x1000-000000-80-0-0.jpg	\N	813	2026-08-07 12:39:32.60196	2026-08-07 12:39:32.60196
\.


--
-- Data for Name: tokenblocklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokenblocklist (id, jti, created_at) FROM stdin;
\.


--
-- Data for Name: tolisten; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tolisten (id, note, user_id, album_id, created_at, updated_at, listened) FROM stdin;
2	welcome to heeeeeeellllll	1	102	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	f
3	super vibey cool album	1	116	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	f
4	super vibey cool album	1	186	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	f
5	super vibey cool album	2	186	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	f
8		5	466	2026-07-08 11:00:19.966058	2026-07-08 11:00:19.966058	f
9		5	151	2026-07-09 10:52:29.896264	2026-07-09 10:52:29.896264	f
17	wanna	3	624	2026-07-11 15:28:20.058304	2026-07-11 15:28:20.058304	f
7		4	438	2026-07-08 10:34:53.591502	2026-07-12 08:33:58.11103	t
18	asdas	4	631	2026-07-11 18:09:13.042545	2026-07-12 08:34:00.528917	f
20	danka vstanka told me to listen, norm 6767	2	190	2026-07-14 11:29:35.374358	2026-07-14 11:32:05.231101	t
21		2	731	2026-07-14 11:32:48.387182	2026-07-14 11:32:48.387182	f
10	hz	3	251	2026-07-09 11:24:46.715809	2026-07-19 10:24:05.13881	f
11		3	512	2026-07-09 11:26:45.975554	2026-07-19 10:24:05.797529	f
6	super vibey cool album 2к17, maksim lox	3	253	2026-07-06 13:33:02.149504	2026-07-19 10:24:06.703894	f
23		7	556	2026-07-19 13:34:34.649379	2026-07-19 13:34:34.649379	f
22	asafaff	7	190	2026-07-19 13:32:32.836705	2026-07-19 13:35:08.91968	t
19	asdadsad	3	482	2026-07-12 08:51:12.811877	2026-07-28 19:49:19.034883	t
12		3	485	2026-07-10 10:41:51.944389	2026-07-28 19:49:20.776983	f
15	monkje 67	3	99	2026-07-11 15:23:38.17689	2026-07-28 19:49:25.019093	t
16	simgo	3	429	2026-07-11 15:24:17.039418	2026-07-28 19:49:26.09637	t
14	cool shite 322	3	96	2026-07-11 15:23:04.814031	2026-07-28 19:49:26.784721	t
13	Cause it fockin MSI, even though they are kinda freaky, and weird...	3	186	2026-07-11 15:21:59.320155	2026-07-28 19:49:30.345966	t
24		3	190	2026-08-07 12:25:32.810135	2026-08-07 12:25:53.580137	t
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, email, role, password, age, gender, location, created_at, updated_at, bio) FROM stdin;
1	Ostap	ostap@gmail.com	USER	c6a20c3f56a85d86bf9b5eb3f22af278bba756f12f24b997f5459184c97440dd	16	PREFER_NOT_TO_SAY	Ukraine	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	\N
2	Svyatoslav	slavik@gmail.com	USER	0534a115f2161c1c28d17a882ea86b2b95c934578535c2dbcc7fc3dd7f1de72d	18	PREFER_NOT_TO_SAY	Ukraine	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	\N
3	Maksimus	max@gmail.com	USER	334282ed503f4c5d9e243cf9e6261f2e7d7e5329270c72f593c91899ae305fac	18	PREFER_NOT_TO_SAY	Kamboja	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	\N
4	Bogodan	bog@gmail.com	USER	0c30865f32fc31220db3a5011ab342f3daf7cd8683eabb96478ad97a34a430ab	18	PREFER_NOT_TO_SAY	Ukraine	2026-07-06 13:33:02.149504	2026-07-06 13:33:02.149504	\N
5	Olena	olena@gmail.com	USER	e51c7bc74684732ad8dd8a532d44620755904889a56ccb43813936ed96dbb608	\N	MALE	\N	2026-07-08 10:56:40.974509	2026-07-08 10:56:40.974509	\N
6	danik	danik@gmail.com	USER	7e0809a74211c864448f215da55ea359b07dbe281addc5896abf4cbd53d34561	\N	MALE	\N	2026-07-18 12:08:32.47798	2026-07-18 12:08:32.47798	\N
7	bogodan	bogdan@gmail.com	USER	9a687bff2286dc4a04186089f045f7a6757787a1ae7f7ded64d60ce07854c1ce	\N	MALE	\N	2026-07-19 13:26:56.249481	2026-07-24 10:04:13.183882	programista
\.


--
-- Name: action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.action_id_seq', 263, true);


--
-- Name: album_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.album_id_seq', 822, true);


--
-- Name: artist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artist_id_seq', 469, true);


--
-- Name: genre_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genre_id_seq', 39, true);


--
-- Name: rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rating_id_seq', 31, true);


--
-- Name: song_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.song_id_seq', 1285, true);


--
-- Name: tokenblocklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokenblocklist_id_seq', 1, false);


--
-- Name: tolisten_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tolisten_id_seq', 24, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 7, true);


--
-- Name: action action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_pkey PRIMARY KEY (id);


--
-- Name: album album_dzid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_dzid_key UNIQUE (dzid);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: artist artist_dzid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_dzid_key UNIQUE (dzid);


--
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);


--
-- Name: artist_song_association artist_song_association_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_pkey PRIMARY KEY (artist_id, song_id);


--
-- Name: genre genre_dzid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_dzid_key UNIQUE (dzid);


--
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);


--
-- Name: song song_dzid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_dzid_key UNIQUE (dzid);


--
-- Name: song song_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_pkey PRIMARY KEY (id);


--
-- Name: tokenblocklist tokenblocklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenblocklist
    ADD CONSTRAINT tokenblocklist_pkey PRIMARY KEY (id);


--
-- Name: tolisten tolisten_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_pkey PRIMARY KEY (id);


--
-- Name: album_genre_association uq_album_genre; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_genre_association
    ADD CONSTRAINT uq_album_genre PRIMARY KEY (album_id, genre_id);


--
-- Name: tolisten uq_tolisten_albumid_userid; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT uq_tolisten_albumid_userid UNIQUE (user_id, album_id);


--
-- Name: rating uq_user_album_rating; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT uq_user_album_rating UNIQUE (user_id, album_id);


--
-- Name: rating uq_user_song_rating; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT uq_user_song_rating UNIQUE (user_id, song_id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_tokenblocklist_jti; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tokenblocklist_jti ON public.tokenblocklist USING btree (jti);


--
-- Name: action action_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: album album_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: album_genre_association album_genre_association_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_genre_association
    ADD CONSTRAINT album_genre_association_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: album_genre_association album_genre_association_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_genre_association
    ADD CONSTRAINT album_genre_association_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genre(id);


--
-- Name: artist_song_association artist_song_association_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: artist_song_association artist_song_association_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: rating rating_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: rating rating_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: rating rating_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: song song_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: tolisten tolisten_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: tolisten tolisten_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict hbgCwQQZ6a48qUK6lHfMhk9prZA0oRR3Uu71PK71AtI4CI4bkuGpULUPGW1EfsI

