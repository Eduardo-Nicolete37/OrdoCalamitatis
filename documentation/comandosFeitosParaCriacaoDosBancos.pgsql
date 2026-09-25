CREATE DOMAIN typeEmail AS TEXT
CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'); 
-- O trecho "[A-Za-z0-9._%+-]" define que pode ser escrito qualquer coisa com esses caractéres
-- Já o trecho "+@[A-Za-z0-9.-]" diz que tem que ter um @, e pode ser qualquer coisa depois (@proton, @gmail, etc)
-- Por fim, o trecho "\.[A-Za-z]{2,}$')" define que tem que ter um ., se colocasse-mos só um ., significaria que qualquer coisa poderia ser colocada nesse local, e depois, pode ir qualquer coisa, porém, tem que ter mais de 1 caractere

CREATE TABLE userTabela (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email typeEmail UNIQUE NOT NULL,
    passwd TEXT NOT NULL);

SELECT * FROM userTabela;