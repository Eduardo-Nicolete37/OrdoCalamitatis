CREATE DOMAIN typeEmail AS TEXT
CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'); 
-- O trecho "[A-Za-z0-9._%+-]" define que pode ser escrito qualquer coisa com esses caractéres
-- Já o trecho "+@[A-Za-z0-9.-]" diz que tem que ter um @, e pode ser qualquer coisa depois (@proton, @gmail, etc)
-- Por fim, o trecho "\.[A-Za-z]{2,}$')" define que tem que ter um ., se colocasse-mos só um ., significaria que qualquer coisa poderia ser colocada nesse local, e depois, pode ir qualquer coisa, porém, tem que ter mais de 1 caractere

CREATE TABLE userTabela (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Foi usado IDENTITY no lugar do SERIAL pois ele segue o padrão SQL e não permite sobrescrever o id manualmente (o SERIAL permite, não segue o padrão SQL, etc)
    username VARCHAR(255) UNIQUE NOT NULL,
    email typeEmail UNIQUE NOT NULL,
    passwd TEXT NOT NULL);

CREATE TABLE temporadas (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(255) NOT NULL UNIQUE,
    ano_de_comeco INTEGER NOT NULL,
    ano_de_fim    INTEGER,
    CHECK (ano_de_fim IS NULL OR ano_de_fim >= ano_de_comeco) -- Checa se o ano fim é maior do que o ano de começo
);

CREATE TABLE players (
    id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name  VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE characters (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    img         VARCHAR(255),
    agi         INTEGER NOT NULL CHECK (agi >= 0),
    str         INTEGER NOT NULL CHECK (str >= 0),
    intel       INTEGER NOT NULL CHECK (intel >= 0),
    pre         INTEGER NOT NULL CHECK (pre >= 0),
    vig         INTEGER NOT NULL CHECK (vig >= 0),
    occupation  VARCHAR(255) NOT NULL,
    history     TEXT NOT NULL,      
    personality VARCHAR(255) NOT NULL,  
    class       VARCHAR(12) NOT NULL CHECK (class IN ('Combatente', 'Especialista', 'Ocultista')),
    nex         INTEGER NOT NULL CHECK (nex BETWEEN 0 AND 99)
);

CREATE TABLE items (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    img          VARCHAR(255),
    type_item    VARCHAR(255) NOT NULL,
    damage       VARCHAR(255), -- Só armas têm dano, efeito e alcance, por isso aceitam NULL
    effect       VARCHAR(255),
    item_range   VARCHAR(255), 
    prestige     INTEGER NOT NULL DEFAULT 0,
    description  TEXT NOT NULL,
    category     VARCHAR(3),
    space        INTEGER NOT NULL DEFAULT 1 CHECK (space >= 0),
    critical     VARCHAR(10),
    damage_type  VARCHAR(20)
);

CREATE TABLE rituals (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    img          VARCHAR(255),
    element      VARCHAR(255) NOT NULL,
    pd_gasto     INTEGER NOT NULL,
    ritual_type  VARCHAR(255) NOT NULL, 
    dano         VARCHAR(255),
    effect       VARCHAR(255),
    description  TEXT NOT NULL
);

-- Tabelas de conexão
CREATE TABLE player_temporadas (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id    INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE, -- Conecta com a tabela, fazendo que se o dado pai for deletado, os filhos também são
    temporada_id INTEGER NOT NULL REFERENCES temporadas(id) ON DELETE CASCADE,
    UNIQUE (player_id, temporada_id)
);

CREATE TABLE player_characters (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    player_id    INTEGER NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    UNIQUE (player_id, character_id)
);

CREATE TABLE character_rituals (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    ritual_id    INTEGER NOT NULL REFERENCES rituals(id) ON DELETE CASCADE,
    UNIQUE (character_id, ritual_id)
);

CREATE TABLE character_items (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    item_id      INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    quantity     INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    UNIQUE (character_id, item_id)
);

CREATE TABLE character_skills (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    character_id INTEGER NOT NULL REFERENCES characters(id) ON DELETE CASCADE,
    skill        VARCHAR(30) NOT NULL,
    UNIQUE (character_id, skill)
);

-- Índices nas FKs (o Postgres não cria automaticamente)
CREATE INDEX idx_player_temporadas_temporada ON player_temporadas(temporada_id);
CREATE INDEX idx_player_characters_character ON player_characters(character_id);
CREATE INDEX idx_character_rituals_ritual    ON character_rituals(ritual_id);
CREATE INDEX idx_character_items_item        ON character_items(item_id);

SELECT * FROM userTabela;