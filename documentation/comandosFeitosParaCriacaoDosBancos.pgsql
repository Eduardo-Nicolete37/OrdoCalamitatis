CREATE DOMAIN typeEmail AS TEXT
CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'); 
-- O trecho "[A-Za-z0-9._%+-]" define que pode ser escrito qualquer coisa com esses caractéres
-- Já o trecho "+@[A-Za-z0-9.-]" diz que tem que ter um @, e pode ser qualquer coisa depois (@proton, @gmail, etc)
-- Por fim, o trecho "\.[A-Za-z]{2,}$')" define que tem que ter um ., se colocasse-mos só um ., significaria que qualquer coisa poderia ser colocada nesse local, e depois, pode ir qualquer coisa, porém, tem que ter mais de 1 caractere

CREATE TABLE userTabela (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Foi usado INTEGER pois é uma versão mais atualizada do SERIAL, tendo problemas de segurança como permitir sobrescrever o id, não segue o padrão SQL, etc
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
    agi         INTEGER NOT NULL,
    str         INTEGER NOT NULL,
    intel       INTEGER NOT NULL,   
    pre         INTEGER NOT NULL,
    vig         INTEGER NOT NULL,
    occupation  VARCHAR(255) NOT NULL,
    history     TEXT NOT NULL,      
    personality VARCHAR(255) NOT NULL,  
    class       VARCHAR(12) NOT NULL,
    nex         INTEGER NOT NULL
);

CREATE TABLE items (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    img          VARCHAR(255),
    type_item    VARCHAR(255) NOT NULL,
    damage       VARCHAR(255) NOT NULL,
    effect       VARCHAR(255) NOT NULL,
    item_range   VARCHAR(255) NOT NULL, 
    prestige     INTEGER NOT NULL,
    description  TEXT NOT NULL
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

-- Índices nas FKs (o Postgres não cria automaticamente)
CREATE INDEX idx_player_temporadas_temporada ON player_temporadas(temporada_id);
CREATE INDEX idx_player_characters_character ON player_characters(character_id);
CREATE INDEX idx_character_rituals_ritual    ON character_rituals(ritual_id);
CREATE INDEX idx_character_items_item        ON character_items(item_id);

SELECT * FROM userTabela;