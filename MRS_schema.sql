--
-- PostgreSQL database dump
--

\restrict pdWByBiYXBvUK0tzCDIrWBWig80B7pb5okPHyvHX662BUAMqBf9DagMnrAZjwnC

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: draniksama
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO draniksama;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: draniksama
--

CREATE TYPE public.user_role_enum AS ENUM (
    'ADMIN',
    'USER'
);


ALTER TYPE public.user_role_enum OWNER TO draniksama;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: album; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.album (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    artist_id integer NOT NULL
);


ALTER TABLE public.album OWNER TO draniksama;

--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.album_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.album_id_seq OWNER TO draniksama;

--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.album_id_seq OWNED BY public.album.id;


--
-- Name: artist; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.artist (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1200),
    age integer,
    gender character varying,
    location character varying NOT NULL
);


ALTER TABLE public.artist OWNER TO draniksama;

--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artist_id_seq OWNER TO draniksama;

--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.artist_id_seq OWNED BY public.artist.id;


--
-- Name: artist_song_association; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.artist_song_association (
    artist_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE public.artist_song_association OWNER TO draniksama;

--
-- Name: playlist; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.playlist (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    description character varying(200) NOT NULL
);


ALTER TABLE public.playlist OWNER TO draniksama;

--
-- Name: playlist_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.playlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.playlist_id_seq OWNER TO draniksama;

--
-- Name: playlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.playlist_id_seq OWNED BY public.playlist.id;


--
-- Name: playlist_song_association; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.playlist_song_association (
    playlist_id integer NOT NULL,
    song_id integer NOT NULL
);


ALTER TABLE public.playlist_song_association OWNER TO draniksama;

--
-- Name: rating; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.rating (
    id integer NOT NULL,
    score integer NOT NULL,
    description text,
    album_id integer NOT NULL,
    song_id integer NOT NULL,
    CONSTRAINT ck_rating_score_range CHECK (((score >= 0) AND (score <= 10)))
);


ALTER TABLE public.rating OWNER TO draniksama;

--
-- Name: rating_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.rating_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rating_id_seq OWNER TO draniksama;

--
-- Name: rating_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.rating_id_seq OWNED BY public.rating.id;


--
-- Name: song; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.song (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    length integer NOT NULL,
    genre character varying NOT NULL,
    artist_id integer NOT NULL,
    album_id integer NOT NULL
);


ALTER TABLE public.song OWNER TO draniksama;

--
-- Name: song_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.song_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.song_id_seq OWNER TO draniksama;

--
-- Name: song_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.song_id_seq OWNED BY public.song.id;


--
-- Name: tolisten; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.tolisten (
    id integer NOT NULL,
    note character varying(300) NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.tolisten OWNER TO draniksama;

--
-- Name: tolisten_album_association; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public.tolisten_album_association (
    tolisten_id integer NOT NULL,
    album_id integer NOT NULL
);


ALTER TABLE public.tolisten_album_association OWNER TO draniksama;

--
-- Name: tolisten_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.tolisten_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tolisten_id_seq OWNER TO draniksama;

--
-- Name: tolisten_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.tolisten_id_seq OWNED BY public.tolisten.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: draniksama
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    role public.user_role_enum NOT NULL,
    password character varying NOT NULL,
    age integer NOT NULL,
    gender character varying(30),
    location character varying(100)
);


ALTER TABLE public."user" OWNER TO draniksama;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: draniksama
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO draniksama;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: draniksama
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: album id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.album ALTER COLUMN id SET DEFAULT nextval('public.album_id_seq'::regclass);


--
-- Name: artist id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.artist ALTER COLUMN id SET DEFAULT nextval('public.artist_id_seq'::regclass);


--
-- Name: playlist id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.playlist ALTER COLUMN id SET DEFAULT nextval('public.playlist_id_seq'::regclass);


--
-- Name: rating id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.rating ALTER COLUMN id SET DEFAULT nextval('public.rating_id_seq'::regclass);


--
-- Name: song id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.song ALTER COLUMN id SET DEFAULT nextval('public.song_id_seq'::regclass);


--
-- Name: tolisten id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.tolisten ALTER COLUMN id SET DEFAULT nextval('public.tolisten_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id);


--
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);


--
-- Name: artist_song_association artist_song_association_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_pkey PRIMARY KEY (artist_id, song_id);


--
-- Name: playlist playlist_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_pkey PRIMARY KEY (id);


--
-- Name: playlist_song_association playlist_song_association_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.playlist_song_association
    ADD CONSTRAINT playlist_song_association_pkey PRIMARY KEY (playlist_id, song_id);


--
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);


--
-- Name: song song_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_pkey PRIMARY KEY (id);


--
-- Name: tolisten_album_association tolisten_album_association_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.tolisten_album_association
    ADD CONSTRAINT tolisten_album_association_pkey PRIMARY KEY (tolisten_id, album_id);


--
-- Name: tolisten tolisten_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: album album_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: artist_song_association artist_song_association_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: artist_song_association artist_song_association_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.artist_song_association
    ADD CONSTRAINT artist_song_association_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: playlist_song_association playlist_song_association_playlist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.playlist_song_association
    ADD CONSTRAINT playlist_song_association_playlist_id_fkey FOREIGN KEY (playlist_id) REFERENCES public.playlist(id);


--
-- Name: playlist_song_association playlist_song_association_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.playlist_song_association
    ADD CONSTRAINT playlist_song_association_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: rating rating_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: rating rating_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.song(id);


--
-- Name: song song_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: song song_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.song
    ADD CONSTRAINT song_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id);


--
-- Name: tolisten_album_association tolisten_album_association_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.tolisten_album_association
    ADD CONSTRAINT tolisten_album_association_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(id);


--
-- Name: tolisten_album_association tolisten_album_association_tolisten_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.tolisten_album_association
    ADD CONSTRAINT tolisten_album_association_tolisten_id_fkey FOREIGN KEY (tolisten_id) REFERENCES public.tolisten(id);


--
-- Name: tolisten tolisten_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: draniksama
--

ALTER TABLE ONLY public.tolisten
    ADD CONSTRAINT tolisten_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

\unrestrict pdWByBiYXBvUK0tzCDIrWBWig80B7pb5okPHyvHX662BUAMqBf9DagMnrAZjwnC

