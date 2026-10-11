--
-- PostgreSQL database dump
--

\restrict 7z2eGp7ORmBu9baKN4rj6Ceb64YBIGtw4jauEnb3lqSiK7hLLinbapAsCxWmL1C

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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
-- Name: typeemail; Type: DOMAIN; Schema: public; Owner: ordo
--

CREATE DOMAIN public.typeemail AS text
	CONSTRAINT typeemail_check CHECK ((VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN public.typeemail OWNER TO ordo;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
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
-- Name: character_rituals; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.character_rituals (
    id integer NOT NULL,
    character_id integer NOT NULL,
    ritual_id integer NOT NULL
);


ALTER TABLE public.character_rituals OWNER TO ordo;

--
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
-- Name: character_skills; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.character_skills (
    id integer NOT NULL,
    character_id integer NOT NULL,
    skill character varying(30) NOT NULL
);


ALTER TABLE public.character_skills OWNER TO ordo;

--
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
-- Name: characters; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.characters (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img character varying(255) NOT NULL,
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
    created_by integer,
    CONSTRAINT chk_characters_attrs CHECK (((agi >= 0) AND (str >= 0) AND (intel >= 0) AND (pre >= 0) AND (vig >= 0))),
    CONSTRAINT chk_characters_class CHECK (((class)::text = ANY ((ARRAY['Combatente'::character varying, 'Especialista'::character varying, 'Ocultista'::character varying])::text[]))),
    CONSTRAINT chk_characters_nex CHECK (((nex >= 0) AND (nex <= 99)))
);


ALTER TABLE public.characters OWNER TO ordo;

--
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
-- Name: items; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img character varying(255) NOT NULL,
    type_item character varying(255) NOT NULL,
    damage character varying(255),
    effect character varying(255),
    item_range character varying(255),
    prestige integer DEFAULT 0 NOT NULL,
    description text NOT NULL,
    category character varying(3),
    space integer DEFAULT 1 NOT NULL,
    critical character varying(10),
    damage_type character varying(20),
    created_by integer,
    CONSTRAINT chk_items_space CHECK ((space >= 0))
);


ALTER TABLE public.items OWNER TO ordo;

--
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
-- Name: player_characters; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.player_characters (
    id integer NOT NULL,
    player_id integer NOT NULL,
    character_id integer NOT NULL
);


ALTER TABLE public.player_characters OWNER TO ordo;

--
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
-- Name: player_temporadas; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.player_temporadas (
    id integer NOT NULL,
    player_id integer NOT NULL,
    temporada_id integer NOT NULL
);


ALTER TABLE public.player_temporadas OWNER TO ordo;

--
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
-- Name: players; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.players (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.players OWNER TO ordo;

--
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
-- Name: rituals; Type: TABLE; Schema: public; Owner: ordo
--

CREATE TABLE public.rituals (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img character varying(255) NOT NULL,
    element character varying(255) NOT NULL,
    pd_gasto integer NOT NULL,
    ritual_type character varying(255) NOT NULL,
    dano character varying(255),
    effect character varying(255),
    description text NOT NULL,
    created_by integer
);


ALTER TABLE public.rituals OWNER TO ordo;

--
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
-- Data for Name: character_items; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_items (id, character_id, item_id, quantity) FROM stdin;
\.


--
-- Data for Name: character_rituals; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_rituals (id, character_id, ritual_id) FROM stdin;
\.


--
-- Data for Name: character_skills; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_skills (id, character_id, skill) FROM stdin;
1	3	Ciências
2	3	Intuição
3	3	Investigação
4	3	Pontaria
5	3	Profissão
6	3	Vontade
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.characters (id, name, img, agi, str, intel, pre, vig, occupation, history, personality, class, nex, created_by) FROM stdin;
2	Joui Jouki	uploads/img_6ac80172b2d870.33286835.png	3	3	3	3	3	Atleta	qefwgnkwbgkjebkbekgbkjvbskbskbkjenv	Protetor, Impulsivo, Empático	Combatente	75	1
3	Elizabeth Webber	uploads/img_6aca97d3e38f70.59725950.webp	3	1	5	0	3	Investigador	Elizabeth era uma médica e cientista forense, extremamente obstinada, inteligente e habilidosa, com uma obsessão por criar teorias e desvendar casos. Trabalhando com o seu parceiro detetive, Gustavo Dohmer, ajudou a resolver alguns casos para a Polícia Federal até que, finalmente, foi recrutada para a Ordo Realitas por Tristan Monteiro.\r\n\r\nDepois de perder quase toda sua equipe em sua primeira missão, acompanhou a Equipe E na investigação que levou à destruição de Santo Berço, onde ficou presa em um vórtice temporal por 22 anos. Após retornar a São Paulo, passou a seguir a pista de algo denominado "Ordem da Desconjuração".\r\n\r\nPosteriormente Liz investiga e acaba sendo capturada pelos Escriptas, um grupo relacionado à Desconjuração. Após ser resgatada por uma equipe da Ordem, Elizabeth foi emboscada pelo grupo ocultista novamente, sendo morta por Gal no 6º episódio de Desconjuração, quando o líder dos Escriptas enfia a katana de Joui Jouki no peito da agente, matando-a lentamente.[4]	Cético, Metódico, Frio e Calculista, Protetor, Paranoico	Especialista	50	1
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.items (id, name, img, type_item, damage, effect, item_range, prestige, description, category, space, critical, damage_type, created_by) FROM stdin;
1	Fuzil de assalto (Calibre Grosso)	uploads/img_6aca99646e77c9.36755815.webp	Arma	2d10+2	Nenhum	Médio	2	É um fuzil militar robusto e visivelmente customizado. Ele possui o cano consideravelmente mais largo e o corpo reforçado com placas de metal extras para suportar o coice da arma. A coronha é mais grossa e emborrachada, feita para aguentar o recuo pesado dos projéteis enormes, que são quase do tamanho de um dedo. É uma arma pesada, intimidadora e feita para destruição bruta.	II	2	19/x3	Balístico	1
\.


--
-- Data for Name: player_characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.player_characters (id, player_id, character_id) FROM stdin;
2	1	2
3	17	3
\.


--
-- Data for Name: player_temporadas; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.player_temporadas (id, player_id, temporada_id) FROM stdin;
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.players (id, name) FROM stdin;
1	Luba
2	Abelha
3	Alanzoka
4	Baghera Jones
5	Bastet
6	Beamom
7	Bela Tiemiau
8	Brino
9	Calango
10	Calígrafo
11	Carol Zaghetti
12	Cellbit
13	Cereaw
14	Cinemagrath
15	Felps
16	Foolish
17	Gabi Cattuzzo
18	Goularte
19	Guaxinim
20	Guilherme Lopes
21	Guto Barbosa
22	Jinki
23	João Miranda
24	João Victor Granja
25	Kalera
26	Karen Padrão
27	Leo Santi
28	LJoga
29	Lorena Orsi
30	Maethe
31	Mount
32	Murilo Choquetta
33	Pac
34	Quackity
35	Rakin
36	Roier
37	T3ddy
38	Triz Pariz
39	Zero
\.


--
-- Data for Name: rituals; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.rituals (id, name, img, element, pd_gasto, ritual_type, dano, effect, description, created_by) FROM stdin;
1	Eletrocussão	uploads/img_6acac9274dc883.85571105.webp	Energia	1	1º Círculo	3d6	Você manifesta e dispara uma corrente elétrica contra o alvo.	Ritual que permite manifestar e disparar uma corrente elétrica contra um ser ou objeto, causando dano de Energia. O alvo pode realizar um teste de resistência de Fortitude para reduzir os efeitos.	1
\.


--
-- Data for Name: temporadas; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.temporadas (id, name, ano_de_comeco, ano_de_fim) FROM stdin;
\.


--
-- Data for Name: usertabela; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.usertabela (id, username, email, passwd) FROM stdin;
1	Eduardo Nicolete	eduardonicolete@gmail.com	$2y$12$MXCKi1rOur3mk2brjVk/I.jZpWYQbaJRbFKYR/JSvmUtaXbU4wQI6
\.


--
-- Name: character_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_items_id_seq', 1, false);


--
-- Name: character_rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_rituals_id_seq', 1, false);


--
-- Name: character_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_skills_id_seq', 6, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.characters_id_seq', 3, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.items_id_seq', 1, true);


--
-- Name: player_characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_characters_id_seq', 3, true);


--
-- Name: player_temporadas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_temporadas_id_seq', 1, false);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.players_id_seq', 39, true);


--
-- Name: rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.rituals_id_seq', 1, true);


--
-- Name: temporadas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.temporadas_id_seq', 1, false);


--
-- Name: usertabela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.usertabela_id_seq', 1, true);


--
-- Name: character_items character_items_character_id_item_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_character_id_item_id_key UNIQUE (character_id, item_id);


--
-- Name: character_items character_items_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_pkey PRIMARY KEY (id);


--
-- Name: character_rituals character_rituals_character_id_ritual_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_character_id_ritual_id_key UNIQUE (character_id, ritual_id);


--
-- Name: character_rituals character_rituals_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_pkey PRIMARY KEY (id);


--
-- Name: character_skills character_skills_character_id_skill_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_skills
    ADD CONSTRAINT character_skills_character_id_skill_key UNIQUE (character_id, skill);


--
-- Name: character_skills character_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_skills
    ADD CONSTRAINT character_skills_pkey PRIMARY KEY (id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: player_characters player_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_pkey PRIMARY KEY (id);


--
-- Name: player_characters player_characters_player_id_character_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_player_id_character_id_key UNIQUE (player_id, character_id);


--
-- Name: player_temporadas player_temporadas_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_pkey PRIMARY KEY (id);


--
-- Name: player_temporadas player_temporadas_player_id_temporada_id_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_player_id_temporada_id_key UNIQUE (player_id, temporada_id);


--
-- Name: players players_name_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_name_key UNIQUE (name);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: rituals rituals_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.rituals
    ADD CONSTRAINT rituals_pkey PRIMARY KEY (id);


--
-- Name: temporadas temporadas_name_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.temporadas
    ADD CONSTRAINT temporadas_name_key UNIQUE (name);


--
-- Name: temporadas temporadas_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.temporadas
    ADD CONSTRAINT temporadas_pkey PRIMARY KEY (id);


--
-- Name: usertabela usertabela_email_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.usertabela
    ADD CONSTRAINT usertabela_email_key UNIQUE (email);


--
-- Name: usertabela usertabela_pkey; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.usertabela
    ADD CONSTRAINT usertabela_pkey PRIMARY KEY (id);


--
-- Name: usertabela usertabela_username_key; Type: CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.usertabela
    ADD CONSTRAINT usertabela_username_key UNIQUE (username);


--
-- Name: idx_character_items_item; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_character_items_item ON public.character_items USING btree (item_id);


--
-- Name: idx_character_rituals_ritual; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_character_rituals_ritual ON public.character_rituals USING btree (ritual_id);


--
-- Name: idx_characters_created_by; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_characters_created_by ON public.characters USING btree (created_by);


--
-- Name: idx_items_created_by; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_items_created_by ON public.items USING btree (created_by);


--
-- Name: idx_player_characters_character; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_player_characters_character ON public.player_characters USING btree (character_id);


--
-- Name: idx_player_temporadas_temporada; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_player_temporadas_temporada ON public.player_temporadas USING btree (temporada_id);


--
-- Name: idx_rituals_created_by; Type: INDEX; Schema: public; Owner: ordo
--

CREATE INDEX idx_rituals_created_by ON public.rituals USING btree (created_by);


--
-- Name: character_items character_items_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: character_items character_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_items
    ADD CONSTRAINT character_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id) ON DELETE CASCADE;


--
-- Name: character_rituals character_rituals_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: character_rituals character_rituals_ritual_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_rituals
    ADD CONSTRAINT character_rituals_ritual_id_fkey FOREIGN KEY (ritual_id) REFERENCES public.rituals(id) ON DELETE CASCADE;


--
-- Name: character_skills character_skills_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.character_skills
    ADD CONSTRAINT character_skills_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: characters characters_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usertabela(id) ON DELETE SET NULL;


--
-- Name: items items_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usertabela(id) ON DELETE SET NULL;


--
-- Name: player_characters player_characters_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id) ON DELETE CASCADE;


--
-- Name: player_characters player_characters_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_characters
    ADD CONSTRAINT player_characters_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE CASCADE;


--
-- Name: player_temporadas player_temporadas_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id) ON DELETE CASCADE;


--
-- Name: player_temporadas player_temporadas_temporada_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.player_temporadas
    ADD CONSTRAINT player_temporadas_temporada_id_fkey FOREIGN KEY (temporada_id) REFERENCES public.temporadas(id) ON DELETE CASCADE;


--
-- Name: rituals rituals_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.rituals
    ADD CONSTRAINT rituals_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usertabela(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 7z2eGp7ORmBu9baKN4rj6Ceb64YBIGtw4jauEnb3lqSiK7hLLinbapAsCxWmL1C

