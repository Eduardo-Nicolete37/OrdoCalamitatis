CREATE DOMAIN typeEmail AS TEXT
CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'); 
-- [A-Za-z0-9._%+-]+
-- Exige um ou mais caracteres permitidos antes do @.
-- Inclui letras, números, ponto, sublinhado, %, + e -.

-- @
-- Exige o símbolo @ separando o nome do usuário e o domínio.

-- [A-Za-z0-9.-]+
-- Exige um ou mais caracteres permitidos na parte anterior
-- ao último ponto, como "gmail" ou "proton".

-- \.[A-Za-z]{2,}$
-- Exige um ponto literal, seguido de pelo menos duas letras
-- até o final da string.

CREATE TABLE userTabela (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    -- Gera os identificadores automaticamente e impede a inserção manual de valores, exceto em operações explicitamente autorizadas. É uma alternativa padronizada ao SERIAL.
    username VARCHAR(255) UNIQUE NOT NULL,
    email typeEmail UNIQUE NOT NULL,
    passwd TEXT NOT NULL);


CREATE TABLE players (
    id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name  VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE characters (
    id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    img         VARCHAR(255) NOT NULL,
    agi         INTEGER NOT NULL CHECK (agi >= 0),
    str         INTEGER NOT NULL CHECK (str >= 0),
    intel       INTEGER NOT NULL CHECK (intel >= 0),
    pre         INTEGER NOT NULL CHECK (pre >= 0),
    vig         INTEGER NOT NULL CHECK (vig >= 0),
    occupation  VARCHAR(255) NOT NULL,
    history     TEXT NOT NULL,      
    personality VARCHAR(255) NOT NULL,  
    class       VARCHAR(12) NOT NULL CHECK (class IN ('Combatente', 'Especialista', 'Ocultista')),
    nex         INTEGER NOT NULL CHECK (nex BETWEEN 0 AND 99),
    created_by  INTEGER REFERENCES userTabela(id) ON DELETE SET NULL -- Conta que criou o personagem. Se a conta for apagada, o registro continua, só perde o criador
);

CREATE TABLE items (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    img          VARCHAR(255) NOT NULL,
    type_item    VARCHAR(255) NOT NULL,
    damage       VARCHAR(255), -- Só armas têm dano, efeito e alcance, por isso aceitam NULL
    effect       TEXT,
    item_range   VARCHAR(255), 
    prestige     INTEGER NOT NULL DEFAULT 0,
    description  TEXT NOT NULL,
    category     VARCHAR(3),
    space        INTEGER NOT NULL DEFAULT 1 CHECK (space >= 0),
    critical     VARCHAR(10),
    damage_type  VARCHAR(20),
    created_by   INTEGER REFERENCES userTabela(id) ON DELETE SET NULL
);

CREATE TABLE rituals (
    id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    img          VARCHAR(255) NOT NULL,
    element      VARCHAR(255) NOT NULL,
    pd_gasto     INTEGER NOT NULL,
    ritual_type  VARCHAR(255) NOT NULL, 
    dano         VARCHAR(255),
    effect       TEXT,
    description  TEXT NOT NULL,
    created_by   INTEGER REFERENCES userTabela(id) ON DELETE SET NULL
);

-- Tabelas de conexão

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
CREATE INDEX idx_player_characters_character ON player_characters(character_id);
CREATE INDEX idx_character_rituals_ritual    ON character_rituals(ritual_id);
CREATE INDEX idx_character_items_item        ON character_items(item_id);
CREATE INDEX idx_characters_created_by       ON characters(created_by);
CREATE INDEX idx_items_created_by            ON items(created_by);
CREATE INDEX idx_rituals_created_by          ON rituals(created_by);

SELECT * FROM userTabela;