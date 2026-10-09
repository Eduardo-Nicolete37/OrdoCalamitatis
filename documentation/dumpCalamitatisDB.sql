--
-- PostgreSQL database dump
--

\restrict k6vnZoHvTCJHlgSF1WEfnLqfUIEydar8PvJmZz9Ie1eHeuT5GbfaKb7avmMgzFW

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-08 20:58:20

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
-- TOC entry 873 (class 1247 OID 16392)
-- Name: typeemail; Type: DOMAIN; Schema: public; Owner: ordo
--

CREATE DOMAIN public.typeemail AS text
	CONSTRAINT typeemail_check CHECK ((VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN public.typeemail OWNER TO ordo;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 238 (class 1259 OID 16563)
-- Name: character_items; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.character_items (
    id integer NOT NULL,
    character_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    CONSTRAINT character_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.character_items OWNER TO ordo;

--
-- TOC entry 237 (class 1259 OID 16562)
-- Name: character_items_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.character_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.character_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 16542)
-- Name: character_rituals; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.character_rituals (
    id integer NOT NULL,
    character_id integer NOT NULL,
    ritual_id integer NOT NULL
);


ALTER TABLE public.character_rituals OWNER TO ordo;

--
-- TOC entry 235 (class 1259 OID 16541)
-- Name: character_rituals_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.character_rituals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.character_rituals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 16608)
-- Name: character_skills; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.character_skills (
    id integer NOT NULL,
    character_id integer NOT NULL,
    skill character varying(30) NOT NULL
);


ALTER TABLE public.character_skills OWNER TO ordo;

--
-- TOC entry 239 (class 1259 OID 16607)
-- Name: character_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.character_skills ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.character_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16450)
-- Name: characters; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.characters (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img character varying(255),
    agi integer NOT NULL,
    str integer NOT NULL,
    intel integer NOT NULL,
    pre integer NOT NULL,
    vig integer NOT NULL,
    occupation character varying(255) NOT NULL,
    history text NOT NULL,
    personality character varying(255) NOT NULL,
    class character varying(12) NOT NULL,
    nex integer NOT NULL,
    CONSTRAINT chk_characters_attrs CHECK (((agi >= 0) AND (str >= 0) AND (intel >= 0) AND (pre >= 0) AND (vig >= 0))),
    CONSTRAINT chk_characters_class CHECK (((class)::text = ANY ((ARRAY['Combatente'::character varying, 'Especialista'::character varying, 'Ocultista'::character varying])::text[]))),
    CONSTRAINT chk_characters_nex CHECK (((nex >= 0) AND (nex <= 99)))
);


ALTER TABLE public.characters OWNER TO ordo;

--
-- TOC entry 225 (class 1259 OID 16449)
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.characters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16470)
-- Name: items; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img character varying(255),
    type_item character varying(255) NOT NULL,
    damage character varying(255),
    effect character varying(255),
    item_range character varying(255),
    prestige integer DEFAULT 0 NOT NULL,
    description text NOT NULL,
    category character varying(3),
    space integer DEFAULT 1 NOT NULL,
    critical character varying(10),
    damage_type character varying(20)
);


ALTER TABLE public.items OWNER TO ordo;

--
-- TOC entry 227 (class 1259 OID 16469)
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16521)
-- Name: player_characters; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.player_characters (
    id integer NOT NULL,
    player_id integer NOT NULL,
    character_id integer NOT NULL
);


ALTER TABLE public.player_characters OWNER TO ordo;

--
-- TOC entry 233 (class 1259 OID 16520)
-- Name: player_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.player_characters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.player_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16500)
-- Name: player_temporadas; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.player_temporadas (
    id integer NOT NULL,
    player_id integer NOT NULL,
    temporada_id integer NOT NULL
);


ALTER TABLE public.player_temporadas OWNER TO ordo;

--
-- TOC entry 231 (class 1259 OID 16499)
-- Name: player_temporadas_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.player_temporadas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.player_temporadas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16440)
-- Name: players; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.players (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.players OWNER TO ordo;

--
-- TOC entry 223 (class 1259 OID 16439)
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.players ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 16486)
-- Name: rituals; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.rituals (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img character varying(255),
    element character varying(255) NOT NULL,
    pd_gasto integer NOT NULL,
    ritual_type character varying(255) NOT NULL,
    dano character varying(255),
    effect character varying(255),
    description text NOT NULL
);


ALTER TABLE public.rituals OWNER TO ordo;

--
-- TOC entry 229 (class 1259 OID 16485)
-- Name: rituals_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.rituals ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rituals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16428)
-- Name: temporadas; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.temporadas (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    ano_de_comeco integer NOT NULL,
    ano_de_fim integer,
    CONSTRAINT temporadas_check CHECK (((ano_de_fim IS NULL) OR (ano_de_fim >= ano_de_comeco)))
);


ALTER TABLE public.temporadas OWNER TO ordo;

--
-- TOC entry 221 (class 1259 OID 16427)
-- Name: temporadas_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.temporadas ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.temporadas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16412)
-- Name: usertabela; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.usertabela (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email public.typeemail NOT NULL,
    passwd text NOT NULL
);


ALTER TABLE public.usertabela OWNER TO ordo;

--
-- TOC entry 219 (class 1259 OID 16411)
-- Name: usertabela_id_seq; Type: SEQUENCE; Schema: public; Owner: ordo
--

ALTER TABLE public.usertabela ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usertabela_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5036 (class 0 OID 16563)
-- Dependencies: 238
-- Data for Name: character_items; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_items (id, character_id, item_id, quantity) FROM stdin;
\.


--
-- TOC entry 5034 (class 0 OID 16542)
-- Dependencies: 236
-- Data for Name: character_rituals; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_rituals (id, character_id, ritual_id) FROM stdin;
\.


--
-- TOC entry 5038 (class 0 OID 16608)
-- Dependencies: 240
-- Data for Name: character_skills; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_skills (id, character_id, skill) FROM stdin;
\.


--
-- TOC entry 5024 (class 0 OID 16450)
-- Dependencies: 226
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.characters (id, name, img, agi, str, intel, pre, vig, occupation, history, personality, class, nex) FROM stdin;
2	Joui Jouki	uploads/img_6ac80172b2d870.33286835.png	3	3	3	3	3	Atleta	qefwgnkwbgkjebkbekgbkjvbskbskbkjenv	Protetor, Impulsivo, Empático	Combatente	75
\.


--
-- TOC entry 5026 (class 0 OID 16470)
-- Dependencies: 228
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.items (id, name, img, type_item, damage, effect, item_range, prestige, description, category, space, critical, damage_type) FROM stdin;
\.


--
-- TOC entry 5032 (class 0 OID 16521)
-- Dependencies: 234
-- Data for Name: player_characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.player_characters (id, player_id, character_id) FROM stdin;
2	1	2
\.


--
-- TOC entry 5030 (class 0 OID 16500)
-- Dependencies: 232
-- Data for Name: player_temporadas; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.player_temporadas (id, player_id, temporada_id) FROM stdin;
\.


--
-- TOC entry 5022 (class 0 OID 16440)
-- Dependencies: 224
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.players (id, name) FROM stdin;
1	Luba
\.


--
-- TOC entry 5028 (class 0 OID 16486)
-- Dependencies: 230
-- Data for Name: rituals; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.rituals (id, name, img, element, pd_gasto, ritual_type, dano, effect, description) FROM stdin;
\.


--
-- TOC entry 5020 (class 0 OID 16428)
-- Dependencies: 222
-- Data for Name: temporadas; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.temporadas (id, name, ano_de_comeco, ano_de_fim) FROM stdin;
\.


--
-- TOC entry 5018 (class 0 OID 16412)
-- Dependencies: 220
-- Data for Name: usertabela; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.usertabela (id, username, email, passwd) FROM stdin;
1	Eduardo Nicolete	eduardonicolete@gmail.com	$2y$12$MXCKi1rOur3mk2brjVk/I.jZpWYQbaJRbFKYR/JSvmUtaXbU4wQI6
\.


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 237
-- Name: character_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_items_id_seq', 1, false);


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 235
-- Name: character_rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_rituals_id_seq', 1, false);


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 239
-- Name: character_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_skills_id_seq', 1, false);


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 225
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.characters_id_seq', 2, true);


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 227
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.items_id_seq', 1, false);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 233
-- Name: player_characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_characters_id_seq', 2, true);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 231
-- Name: player_temporadas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_temporadas_id_seq', 1, false);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 223
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.players_id_seq', 1, true);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 229
-- Name: rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.rituals_id_seq', 1, false);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 221
-- Name: temporadas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.temporadas_id_seq', 1, false);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 219
-- Name: usertabela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.usertabela_id_seq', 1, true);


--
-- TOC entry 4853 (class 2606 OID 16575)
-- Name: character_items character_items_character_id_item_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_character_id_item_id_key UNIQUE (character_id, item_id);


--
-- TOC entry 4855 (class 2606 OID 16573)
-- Name: character_items character_items_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 16551)
-- Name: character_rituals character_rituals_character_id_ritual_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_character_id_ritual_id_key UNIQUE (character_id, ritual_id);


--
-- TOC entry 4850 (class 2606 OID 16549)
-- Name: character_rituals character_rituals_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 16617)
-- Name: character_skills character_skills_character_id_skill_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_skills
    ADD CONSTRAINT character_skills_character_id_skill_key UNIQUE (character_id, skill);


--
-- TOC entry 4860 (class 2606 OID 16615)
-- Name: character_skills character_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_skills
    ADD CONSTRAINT character_skills_pkey PRIMARY KEY (id);


--
-- TOC entry 4832 (class 2606 OID 16468)
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- TOC entry 4834 (class 2606 OID 16484)
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 16528)
-- Name: player_characters player_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 16530)
-- Name: player_characters player_characters_player_id_character_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_player_id_character_id_key UNIQUE (player_id, character_id);


--
-- TOC entry 4839 (class 2606 OID 16507)
-- Name: player_temporadas player_temporadas_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 16509)
-- Name: player_temporadas player_temporadas_player_id_temporada_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_player_id_temporada_id_key UNIQUE (player_id, temporada_id);


--
-- TOC entry 4828 (class 2606 OID 16448)
-- Name: players players_name_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_name_key UNIQUE (name);


--
-- TOC entry 4830 (class 2606 OID 16446)
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 16498)
-- Name: rituals rituals_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.rituals
    ADD CONSTRAINT rituals_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 16438)
-- Name: temporadas temporadas_name_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.temporadas
    ADD CONSTRAINT temporadas_name_key UNIQUE (name);


--
-- TOC entry 4826 (class 2606 OID 16436)
-- Name: temporadas temporadas_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.temporadas
    ADD CONSTRAINT temporadas_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2606 OID 16426)
-- Name: usertabela usertabela_email_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.usertabela
    ADD CONSTRAINT usertabela_email_key UNIQUE (email);


--
-- TOC entry 4820 (class 2606 OID 16422)
-- Name: usertabela usertabela_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.usertabela
    ADD CONSTRAINT usertabela_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 16424)
-- Name: usertabela usertabela_username_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.usertabela
    ADD CONSTRAINT usertabela_username_key UNIQUE (username);


--
-- TOC entry 4856 (class 1259 OID 16589)
-- Name: idx_character_items_item; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_character_items_item ON public.character_items USING btree (item_id);


--
-- TOC entry 4851 (class 1259 OID 16588)
-- Name: idx_character_rituals_ritual; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_character_rituals_ritual ON public.character_rituals USING btree (ritual_id);


--
-- TOC entry 4842 (class 1259 OID 16587)
-- Name: idx_player_characters_character; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_player_characters_character ON public.player_characters USING btree (character_id);


--
-- TOC entry 4837 (class 1259 OID 16586)
-- Name: idx_player_temporadas_temporada; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_player_temporadas_temporada ON public.player_temporadas USING btree (temporada_id);


--
-- TOC entry 4867 (class 2606 OID 16576)
-- Name: character_items character_items_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- TOC entry 4868 (class 2606 OID 16581)
-- Name: character_items character_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 16552)
-- Name: character_rituals character_rituals_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- TOC entry 4866 (class 2606 OID 16557)
-- Name: character_rituals character_rituals_ritual_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_ritual_id_fkey FOREIGN KEY (ritual_id) REFERENCES public.rituals(id) ON DELETE CASCADE;


--
-- TOC entry 4869 (class 2606 OID 16618)
-- Name: character_skills character_skills_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_skills
    ADD CONSTRAINT character_skills_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- TOC entry 4863 (class 2606 OID 16536)
-- Name: player_characters player_characters_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 16531)
-- Name: player_characters player_characters_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE CASCADE;


--
-- TOC entry 4861 (class 2606 OID 16510)
-- Name: player_temporadas player_temporadas_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE CASCADE;


--
-- TOC entry 4862 (class 2606 OID 16515)
-- Name: player_temporadas player_temporadas_temporada_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_temporada_id_fkey FOREIGN KEY (temporada_id) REFERENCES public.temporadas(id) ON DELETE CASCADE;


-- Completed on 2026-10-08 20:58:25

--
-- PostgreSQL database dump complete
--

\unrestrict k6vnZoHvTCJHlgSF1WEfnLqfUIEydar8PvJmZz9Ie1eHeuT5GbfaKb7avmMgzFW

