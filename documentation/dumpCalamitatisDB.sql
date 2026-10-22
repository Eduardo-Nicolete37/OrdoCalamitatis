--
-- PostgreSQL database dump
--

\restrict LAJFJlBwRTx3K0nvp8Mc7MKAoNyJYZSUajUX9kAnMTjqZeXK1Hf2PAv3EEYPZgD

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
    CONSTRAINT characters_class_check CHECK (((class)::text = ANY (ARRAY[('Combatente'::character varying)::text, ('Especialista'::character varying)::text, ('Ocultista'::character varying)::text]))),
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
    effect text,
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
4	1	3	1
5	1	5	1
6	4	3	1
7	5	3	1
\.


--
-- Data for Name: character_rituals; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_rituals (id, character_id, ritual_id) FROM stdin;
16	1	2
17	1	4
19	4	4
20	5	4
\.


--
-- Data for Name: character_skills; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.character_skills (id, character_id, skill) FROM stdin;
143	1	Acrobacia
144	1	Atletismo
145	1	Fortitude
146	1	Furtividade
147	1	Iniciativa
148	1	Luta
149	1	Ocultismo
150	1	Percepção
151	1	Pontaria
152	1	Reflexos
153	1	Sobrevivência
166	4	Artes
167	4	Diplomacia
168	4	Enganação
169	4	Fortitude
170	4	Furtividade
171	4	Intuição
172	4	Investigação
173	4	Ocultismo
174	4	Pilotagem
175	4	Pontaria
176	4	Reflexos
177	4	Vontade
178	5	Atualidades
179	5	Iniciativa
180	5	Investigação
181	5	Ocultismo
182	5	Percepção
183	5	Pontaria
184	5	Reflexos
185	5	Tática
186	5	Tecnologia
187	5	Vontade
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.characters (id, name, img, agi, str, intel, pre, vig, occupation, history, personality, class, nex, created_by) FROM stdin;
1	Joui Jouki	uploads/img_6ad8a3461458c5.69552333.webp	3	3	1	1	3	Atleta	Joui Jouki foi um dos protagonistas da série Ordem Paranormal, presente em O Segredo na Floresta, Desconjuração e Calamidade.\r\n\r\nEle era um ginasta olímpico que, durante uma viagem para o Brasil junto de seus amigos, acabou sofrendo um ataque por uma criatura Paranormal, sendo salvo por Elizabeth Webber e Thiago Fritz.\r\n\r\nOs dois acabam virando seus mentores, e então Joui se junta à Ordo Realitas.\r\n\r\nJoui foi um dos membros designados para o Caso de Carpazinha, fazendo parte da Equipe E junto dos seus mentores.\r\n\r\nEle foi um dos sobreviventes da missão, mesmo ficando à beira da insanidade após ver a trágica cena do fim de Santo Berço.\r\n\r\nEle retornou em Ordem Paranormal: Desconjuração, tendo o objetivo de salvar Elizabeth Webber, que havia sido sequestrada por um misterioso grupo Ocultista chamado Escriptas.\r\n\r\nDurante a missão, Joui se torna o líder da Força D, porém, acaba fazendo um acordo com a Seita das Máscaras, juntando-se ao grupo com duas condições: parar Kian e manter seus companheiros seguros.\r\n\r\nJoui voltou posteriormente no 2º episódio de Calamidade, enraivecido e livre do controle da Seita das Máscaras após ser afetado pelo Ódio do Diabo, sendo responsável pelo assassinato de vários Escriptas na Mansão Leone enquanto estava fora de si.\r\n\r\nEle continuou junto com a Equipe Abutres na busca pelas Relíquias da Calamidade, sendo um dos Marcados do lado da Ordo Realitas.\r\n\r\nJoui Jouki foi morto por Kian durante a batalha do Coliseu, logo após provocá-lo e ser espancado até a morte.	Frio e Calculista, Protetor, Impulsivo, Vingativo, Paranoico	Combatente	70	1
4	Arthur Cervero	uploads/img_6ada7490d91e23.37588955.webp	4	2	3	1	1	Artista	Arthur Cervero é um dos protagonistas da série Ordem Paranormal, presente em O Segredo na Floresta, Desconjuração, Calamidade, O Segredo na Ilha e Hexatombe.\r\n\r\nEle era um músico e membro da gangue de motoqueiros Gaudérios Abutres em Carpazinha, que se juntou a Ordo Realitas após perder seus colegas e família durante uma luta contra o Carniçal Preto da Morte. Após esse incidente, passou a fazer parte da Equipe E, grupo que investigava a manifestação paranormal conhecida como Santo Berço.\r\n\r\nTendo como família apenas sua mãe adotiva, Ivete Beicur, ele se muda para São Paulo e passa a morar com um de seus colegas de equipe, Kaiser. Eles, juntos de mais alguns agentes, formam a Força D, uma equipe destinada a investigar o retorno do primeiro ocultista, Kian.\r\n\r\nUm tempo depois, ele é colocado como líder de um novo grupo, a Equipe Abutres, com o objetivo de encontrar as chamadas Relíquias da Calamidade.	Protetor, Impulsivo, Empático, Excêntrico	Especialista	60	1
5	Cesar "Kaiser" Cohen	uploads/img_6ada77798668b7.95826282.webp	4	2	4	0	1	T.I. (Tecnologia da Informação)	Cesar "Kaiser" Oliveira Cohen foi um dos protagonistas da série Ordem Paranormal, presente em O Segredo na Floresta e Desconjuração.\r\n\r\nCesar era um programador e hacker brasileiro, residente de São Paulo. Após se juntar à Ordo Realitas, é um dos membros designados ao Caso de Carpazinha. Seu pai, Cristopher, também se revela um membro da Ordem e o acompanha na missão.\r\n\r\nRetornou como protagonista em Ordem Paranormal: Desconjuração, assumindo para si um novo alter ego: Kaiser. Segundo ele, esse nome é utilizado para fugir de si mesmo e parar de criar relações com outras pessoas, por medo de perdê-las. Após a entrada de seu melhor amigo Joui Jouki na Seita das Máscaras, é confiado ao hacker o cargo de líder da Força D, equipe esta que o mesmo nomeou.\r\n\r\nKaiser deixou de existir durante o dia final da Desconjuração, após confrontar Kian e ser alvo de um Ritual de Inexistir realizado pelo Escripta, sacrificando-se pra salvar seus amigos.	Metódico, Frio e Calculista, Paranoico, Excêntrico	Especialista	50	1
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.items (id, name, img, type_item, damage, effect, item_range, prestige, description, category, space, critical, damage_type, created_by) FROM stdin;
3	Pistola	uploads/img_6ad8cb0b50be80.47726085.webp	Arma	1d12	Causa perfuração	Curto/Médio	1	É uma arma de fogo de porte leve, semiautomática e de uso com apenas uma mão. No universo de Ordem Paranormal, ela é uma das ferramentas mais comuns e confiáveis da Ordem (Ordo Realitas), sendo a escolha ideal para agentes que buscam equilíbrio entre agilidade e precisão para enfrentar as ameaças do Outro Lado.	I	1	18	Balístico	1
4	Lança-Chamas	uploads/img_6ada7108c60e18.25730478.webp	Arma	6d6	Quando um alvo é atingido pelo ataque do lança-chamas, ele sofre o seguinte efeito mecânico:\r\n• Dano Contínuo: O alvo sofre 1d6 pontos de dano de fogo no início de cada um de seus turnos.\r\n• Como Encerrar: O personagem afetado (ou um aliado adjacente) pode gastar uma ação padrão para apagar o fogo. Fazer isso exige passar em um teste de Reflexos (DT 15).\r\n• Interação com o Ambiente: Se o alvo mergulhar em água ou se houver uma condição climática favorável (como chuva torrencial), o efeito é encerrado automaticamente.	Curto	20	O lança-chamas é uma arma tática pesada composta por um projetor metálico de empunhadura dupla conectado, por mangueiras reforçadas, a tanques pressurizados de combustível líquido carregados nas costas do agente. Ao acionar o gatilho, a chama piloto na ponta do cano incendeia uma coluna violenta e ruidosa de fogo viscoso, projetada para incinerar grupos de criaturas e iluminar as sombras do paranormal com um calor sufocante que adere aos alvos e continua a queimar de forma brutal.	III	2	x2	Fogo	1
5	Katana	uploads/img_6ada72209d6ad5.57348057.webp	Arma	1d10	Mecanicamente no sistema, o efeito da katana é o seu multiplicador de crítico elevado (x3) somado à propriedade de ser uma arma ágil.\r\nQuando você acerta um ataque tirando 19 ou 20 no dado, o dano base de 1d10 é triplicado, tornando-se 3d10 de corte. Além disso, o seu efeito especial permite que ela seja empunhada com apenas uma mão (caso você tenha o poder Ninja Urbano), liberando a outra mão para rituais, escudos ou itens de investigação.	Curto	20	A katana é uma espada de combate corpo a corpo caracterizada por uma lâmina esguia, curva e de gume único, projetada para desferir cortes fluidos, rápidos e de alta precisão. Com uma estrutura leve que prioriza a agilidade e a velocidade do usuário em detrimento da força bruta, ela possui uma empunhadura longa que permite o manuseio firme com uma ou duas mãos, além de um balanço perfeitamente calibrado. Mecanicamente, destaca-se por sua capacidade de causar ferimentos profundos e críticos letais, funcionando como uma arma cirúrgica que transforma o posicionamento correto e o tempo de reação em poder de destruição imediata.	I	2	19/x3	Corte	1
\.


--
-- Data for Name: player_characters; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.player_characters (id, player_id, character_id) FROM stdin;
1	38	1
4	18	4
5	8	5
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
3	Decadência	uploads/img_6acf8816ac96f9.99334352.webp	Morte	6	1º Círculo	2d8 + 2	• Base: Requer toque físico e causa 2d8 + 2 de dano de Morte. • Intermediário: Permite imbuir o ritual em uma arma corpo a corpo. Ao desferir um ataque, o dano do ritual soma-se ao dano da arma no acerto. • Avançado: Eleva o círculo e aumenta o dano para 8d8 + 8, mudando o alcance para uma área de 6 metros que atinge múltiplos alvos.	Ao conjurar o Decadência, o conjurador manifesta uma espiral de fumaça cinzenta e poeira ao redor das mãos, acompanhada por uma súbita queda de temperatura e um odor de terra molhada.\r\nAo tocar o alvo, a energia paranormal drena sua vitalidade instantaneamente:\r\n• A pele murcha, resseca e acinzenta como pergaminho velho.\r\n• Os cabelos embranquecem ou caem no mesmo segundo.\r\n• O corpo sofre um envelhecimento acelerado, enfraquecendo os músculos e deixando o alvo debilitado pelo peso do tempo.	1
2	Ritual de Envelhecimento Localizado	uploads/img_6ace756f659214.40529114.webp	Morte	4	1º Círculo	0	Base: Ao gastar 4 Pontos de Ocultismo, acelera o tempo de uma ferida do alvo, curando 1d6 de vida ou infeccionando ainda mais a ferida. (Não cura lesão grave) \r\nIntermediário: Acelera o tempo de 2 feridas do alvo, curando um total de 2d6+2 de vida ou infeccionando ainda mais a ferida. (Cura lesão grave)	Esse ritual consiste em segurar cinzas humanas em suas mãos e as assoprar sobre uma ferida, fazendo com que a cicatrização aconteça de forma extremamente acelerada, como demonstrada por Dante vista ao cicatrizar uma ferida no ombro de Beatrice que havia sido causada por uma flecha de Joui Jouki, ou ao acelerar o processo de cicatrização da queimadura de Kaiser. Esse ritual aparenta não ser capaz de curar doenças.\r\nConjuração: Ter em mãos cinzas humanas e assoprá-las.	1
4	Ritual de Transcendência	uploads/img_6ad9033a9fbb68.84328081.webp	Morte	0	1º Círculo	0	Ao entrar em comunhão com o Outro Lado e suas entidades, seu usuário é fortalecido dependendo da exposição dele ao paranormal, sendo capaz de aprender um ritual no processo.	O primeiro ritual alguma vez criado, inventado pelo próprio Kian há aproximadamente 4000 anos.\r\n\r\nPara a realização desse ritual, basta ficar sobre o símbolo e se concentrar nele, carregando ou não um objeto amaldiçoado.\r\n\r\nEsse ritual é utilizado por todos os Ocultistas para se fortalecerem e aprenderem outros rituais ao se conectarem com o Outro Lado, compreendendo tudo e esquecendo a maior parte logo após o fim do ritual.\r\n\r\nCaso carregue um objeto amaldiçoado durante o ritual, o Outro Lado vai fazer uma pergunta em troca de uma fração de seu Conhecimento em forma de ritual. O ritual obtido varia de acordo com o objeto amaldiçoado carregado.\r\n\r\nCaso o indivíduo que transcenda seja um Marcado com 50% de exposição paranormal, ele se conectará mais fortemente com sua Marca, que poderá revelar alguma verdade para ele ou conectá-lo com um antigo Marcado que teve a mesma marca, que poderá lhe dizer algo.\r\n\r\nAtingir 50% de exposição paranormal também significa ser escolhido por uma das entidades do Outro Lado, podendo ter uma afinidade aos elementos de Sangue, Morte, Conhecimento e Energia.\r\n\r\nConjuração: Se concentrar no símbolo.\r\nUsuários: Pessoas com experiência paranormal suficiente para se conectar com o Outro Lado.	1
\.


--
-- Data for Name: usertabela; Type: TABLE DATA; Schema: public; Owner: ordo
--

COPY public.usertabela (id, username, email, passwd) FROM stdin;
1	Eduardo Nicolete	eduardonicolete@gmail.com	$2y$12$MXCKi1rOur3mk2brjVk/I.jZpWYQbaJRbFKYR/JSvmUtaXbU4wQI6
2	Livia Pondian	liviapondian@gmail.com	$2y$12$gAV1tgHltbYDUuBCnXgtIOySthASyMcwSC2epcV8R1/XnCYI7jUI2
\.


--
-- Name: character_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_items_id_seq', 7, true);


--
-- Name: character_rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_rituals_id_seq', 20, true);


--
-- Name: character_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.character_skills_id_seq', 187, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.characters_id_seq', 5, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.items_id_seq', 5, true);


--
-- Name: player_characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.player_characters_id_seq', 5, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.players_id_seq', 40, true);


--
-- Name: rituals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.rituals_id_seq', 4, true);


--
-- Name: usertabela_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ordo
--

SELECT pg_catalog.setval('public.usertabela_id_seq', 2, true);


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
-- Name: rituals rituals_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ordo
--

ALTER TABLE ONLY public.rituals
    ADD CONSTRAINT rituals_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.usertabela(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict LAJFJlBwRTx3K0nvp8Mc7MKAoNyJYZSUajUX9kAnMTjqZeXK1Hf2PAv3EEYPZgD

