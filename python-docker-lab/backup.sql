--
-- PostgreSQL database dump
--

\restrict u3q4OS89HkyQ0DCqyyDjxXySeRsMNwfQgxAhd82ecpeKceWae32kGHvXDEr5UBC

-- Dumped from database version 13.23 (Debian 13.23-1.pgdg13+1)
-- Dumped by pg_dump version 13.23 (Debian 13.23-1.pgdg13+1)

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
-- Name: visitors; Type: TABLE; Schema: public; Owner: flaskuser
--

CREATE TABLE public.visitors (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    visit_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ip_address inet,
    user_agent text
);


ALTER TABLE public.visitors OWNER TO flaskuser;

--
-- Name: visitors_id_seq; Type: SEQUENCE; Schema: public; Owner: flaskuser
--

CREATE SEQUENCE public.visitors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.visitors_id_seq OWNER TO flaskuser;

--
-- Name: visitors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flaskuser
--

ALTER SEQUENCE public.visitors_id_seq OWNED BY public.visitors.id;


--
-- Name: visitors id; Type: DEFAULT; Schema: public; Owner: flaskuser
--

ALTER TABLE ONLY public.visitors ALTER COLUMN id SET DEFAULT nextval('public.visitors_id_seq'::regclass);


--
-- Data for Name: visitors; Type: TABLE DATA; Schema: public; Owner: flaskuser
--

COPY public.visitors (id, name, visit_time, ip_address, user_agent) FROM stdin;
1	Docker Lab Student	2026-01-12 07:14:43.680335	127.0.0.1	\N
2	Container Enthusiast	2026-01-12 07:14:43.680335	192.168.1.100	\N
3	Python Developer	2026-01-12 07:14:43.680335	10.0.0.1	\N
\.


--
-- Name: visitors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flaskuser
--

SELECT pg_catalog.setval('public.visitors_id_seq', 3, true);


--
-- Name: visitors visitors_pkey; Type: CONSTRAINT; Schema: public; Owner: flaskuser
--

ALTER TABLE ONLY public.visitors
    ADD CONSTRAINT visitors_pkey PRIMARY KEY (id);


--
-- Name: idx_visitors_visit_time; Type: INDEX; Schema: public; Owner: flaskuser
--

CREATE INDEX idx_visitors_visit_time ON public.visitors USING btree (visit_time);


--
-- PostgreSQL database dump complete
--

\unrestrict u3q4OS89HkyQ0DCqyyDjxXySeRsMNwfQgxAhd82ecpeKceWae32kGHvXDEr5UBC

