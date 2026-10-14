--
-- PostgreSQL database dump
--

\restrict NbZPY7Qe5U9trRnnFuYfT0WS42vgncBTpfRweb09PS0Lb6tjA9Sv5fQhN40Dgxa

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
    CONSTRAINT characters_agi_check CHECK ((agi >= 0)),
    CONSTRAINT characters_class_check CHECK (((class)::text = ANY ((ARRAY['Combatente'::character varying, 'Especialista'::character varying, 'Ocultista'::character varying])::text[]))),
    CONSTRAINT characters_intel_check CHECK ((intel >= 0)),
    CONSTRAINT characters_nex_check CHECK (((nex >= 0) AND (nex <= 99))),
    CONSTRAINT characters_pre_check CHECK ((pre >= 0)),
    CONSTRAINT characters_str_check CHECK ((str >= 0)),
    CONSTRAINT characters_vig_check CHECK ((vig >= 0))
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
    CONSTRAINT items_space_check CHECK ((space >= 0))
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
    effect text,
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
1	1	2
\.


--
-- Data for Name: character_skills; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_skills (id, character_id, skill) FROM stdin;
1	1	Acrobacia
2	1	Atletismo
3	1	Fortitude
4	1	Furtividade
5	1	Iniciativa
6	1	Luta
7	1	Percepção
8	1	Pontaria
9	1	Reflexos
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.characters (id, name, img, agi, str, intel, pre, vig, occupation, history, personality, class, nex, created_by) FROM stdin;
1	Joui Jouki	uploads/img_6ace76cc964c01.86370499.webp	3	3	1	1	3	Atleta	**Joui Jouki** foi um dos protagonistas da série Ordem Paranormal, presente em O Segredo na Floresta, Desconjuração e Calamidade.\r\n\r\nEle era um ginasta olímpico que, durante uma viagem para o Brasil junto de seus amigos, acabou sofrendo um ataque por uma criatura Paranormal, sendo salvo por Elizabeth Webber e Thiago Fritz.\r\n\r\nOs dois acabam virando seus mentores, e então Joui se junta à Ordo Realitas.\r\n\r\nJoui foi um dos membros designados para o Caso de Carpazinha, fazendo parte da Equipe E junto dos seus mentores.\r\n\r\nEle foi um dos sobreviventes da missão, mesmo ficando à beira da insanidade após ver a trágica cena do fim de Santo Berço.\r\n\r\nEle retornou em Ordem Paranormal: Desconjuração, tendo o objetivo de salvar Elizabeth Webber, que havia sido sequestrada por um misterioso grupo Ocultista chamado Escriptas.\r\n\r\nDurante a missão, Joui se torna o líder da Força D, porém, acaba fazendo um acordo com a Seita das Máscaras, juntando-se ao grupo com duas condições: parar Kian e manter seus companheiros seguros.\r\n\r\nJoui voltou posteriormente no 2º episódio de Calamidade, enraivecido e livre do controle da Seita das Máscaras após ser afetado pelo Ódio do Diabo, sendo responsável pelo assassinato de vários Escriptas na Mansão Leone enquanto estava fora de si.\r\n\r\nEle continuou junto com a Equipe Abutres na busca pelas Relíquias da Calamidade, sendo um dos Marcados do lado da Ordo Realitas.\r\n\r\nJoui Jouki foi morto por Kian durante a batalha do Coliseu, logo após provocá-lo e ser espancado até a morte.	Frio e Calculista, Protetor, Impulsivo, Vingativo, Paranoico	Combatente	70	1
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.items (id, name, img, type_item, damage, effect, item_range, prestige, description, category, space, critical, damage_type, created_by) FROM stdin;
\.


--
-- Data for Name: player_characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.player_characters (id, player_id, character_id) FROM stdin;
1	38	1
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
1	Abelha
2	Alanzoka
3	Baghera Jones
4	Bastet
5	Beamom
6	Bela Tiemiau
7	Brino
8	Calango
9	Calígrafo
10	Carol Zaghetti
11	Cellbit
12	Cereaw
13	Cinemagrath
14	Felps
15	Foolish
16	Gabi Cattuzzo
17	Goularte
18	Guaxinim
19	Guilherme Lopes
20	Guto Barbosa
21	Jinki
22	João Miranda
23	João Victor Granja
24	Kalera
25	Karen Padrão
26	Leo Santi
27	LJoga
28	Lorena Orsi
29	Maethe
30	Mount
31	Murilo Choquetta
32	Pac
33	Quackity
34	Rakin
35	Roier
36	T3ddy
37	Triz Pariz
38	Luba
39	Zero
40	Nenhuma das opções
\.


--
-- Data for Name: rituals; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.rituals (id, name, img, element, pd_gasto, ritual_type, dano, effect, description, created_by) FROM stdin;
1	Ritual de Transcendência	uploads/img_6ace707ded9880.68485618.webp	Conhecimento	0	1º Círculo	0	Ao entrar em comunhão com o Outro Lado e suas entidades, seu usuário é fortalecido dependendo da exposição dele ao paranormal, sendo capaz de aprender um ritual no processo.	O primeiro ritual alguma vez criado, inventado pelo próprio Kian há aproximadamente 4000 anos.\r\n\r\nPara a realização desse ritual, basta ficar sobre o símbolo e se concentrar nele, carregando ou não um objeto amaldiçoado.\r\n\r\nEsse ritual é utilizado por todos os Ocultistas para se fortalecerem e aprenderem outros rituais ao se conectarem com o Outro Lado, compreendendo tudo e esquecendo a maior parte logo após o fim do ritual.\r\n\r\nCaso carregue um objeto amaldiçoado durante o ritual, o Outro Lado vai fazer uma pergunta em troca de uma fração de seu Conhecimento em forma de ritual. O ritual obtido varia de acordo com o objeto amaldiçoado carregado.\r\n\r\nCaso o indivíduo que transcenda seja um Marcado com 50% de exposição paranormal, ele se conectará mais fortemente com sua Marca, que poderá revelar alguma verdade para ele ou conectá-lo com um antigo Marcado que teve a mesma marca, que poderá lhe dizer algo.\r\n\r\nAtingir 50% de exposição paranormal também significa ser escolhido por uma das entidades do Outro Lado, podendo ter uma afinidade aos elementos de Sangue, Morte, Conhecimento e Energia.\r\n\r\nConjuração: Se concentrar no símbolo.\r\nUsuários: Pessoas com experiência paranormal suficiente para se conectar com o Outro Lado.	1
2	Ritual de Envelhecimento Localizado	uploads/img_6ace756f659214.40529114.webp	Morte	4	1º Círculo	0	Base: Ao gastar 4 Pontos de Ocultismo, acelera o tempo de uma ferida do alvo, curando 1d6 de vida ou infeccionando ainda mais a ferida. (Não cura lesão grave) Intermediário: Acelera o tempo de 2 feridas do alvo, curando um total de 2d6+2 de vida ou infeccionando ainda mais a ferida. (Cura lesão grave)	Esse ritual consiste em segurar cinzas humanas em suas mãos e as assoprar sobre uma ferida, fazendo com que a cicatrização aconteça de forma extremamente acelerada, como demonstrada por Dante vista ao cicatrizar uma ferida no ombro de Beatrice que havia sido causada por uma flecha de Joui Jouki, ou ao acelerar o processo de cicatrização da queimadura de Kaiser. Esse ritual aparenta não ser capaz de curar doenças.\r\n\r\nConjuração: Ter em mãos cinzas humanas e assoprá-las.	1
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

SELECT pg_catalog.setval('public.character_rituals_id_seq', 1, true);


--
-- Name: character_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_skills_id_seq', 9, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.characters_id_seq', 1, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.items_id_seq', 1, false);


--
-- Name: player_characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_characters_id_seq', 1, true);


--
-- Name: player_temporadas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_temporadas_id_seq', 1, false);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.players_id_seq', 40, true);


--
-- Name: rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.rituals_id_seq', 2, true);


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

\unrestrict NbZPY7Qe5U9trRnnFuYfT0WS42vgncBTpfRweb09PS0Lb6tjA9Sv5fQhN40Dgxa

