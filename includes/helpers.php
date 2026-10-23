<?php
require_once __DIR__ . "/../database/connect.php";
// Funções relacionadas a criação de personagens (CREATE)
function criaPersonagem(
    $conexao,
    $player_id,
    $name,
    $foto,
    $agi,
    $str,
    $intel,
    $pre,
    $vig,
    $history,
    $occupation,
    $personality,
    $class,
    $nex,
    $pericias,
    $created_by,
    $rituais = [],
    $items = []
) {
    try {
        $conexao->beginTransaction();

        $sql = "INSERT INTO characters (name, img, agi, str, intel, pre, vig, history, occupation, personality, class, nex, created_by)
        VALUES (:name, :img, :agi, :str, :intel, :pre, :vig, :history, :occupation, :personality, :class, :nex, :created_by)
        RETURNING id";
        $stmt = $conexao->prepare($sql);
        $stmt->execute([
            ':name' => $name,
            ':img' => $foto,
            ':agi' => $agi,
            ':str' => $str,
            ':intel' => $intel,
            ':pre' => $pre,
            ':vig' => $vig,
            ':history' => $history,
            ':occupation' => $occupation,
            ':personality' => $personality,
            ':class' => $class,
            ':nex' => $nex,
            ':created_by' => $created_by,
        ]);
        $character_id = $stmt->fetchColumn();

        $stmt = $conexao->prepare("INSERT INTO player_characters (player_id, character_id) VALUES (:p, :c)");
        $stmt->execute([':p' => $player_id, ':c' => $character_id]);

        $stmt = $conexao->prepare("INSERT INTO character_skills (character_id, skill) VALUES (:c, :s)");
        foreach ($pericias as $skill) {
            $stmt->execute([':c' => $character_id, ':s' => $skill]);
        }
        $stmt = $conexao->prepare("INSERT INTO character_rituals (character_id, ritual_id) VALUES (:c, :r)");
        foreach ($rituais as $ritual_id) {
            $stmt->execute([':c' => $character_id, ':r' => $ritual_id]);
        }
        $stmt = $conexao->prepare("INSERT INTO character_items (character_id, item_id, quantity) VALUES (:c, :r, :q)");
        foreach ($items as $item) {
            $stmt->execute([':c' => $character_id, ':r' => $item['item_id'], ':q' => $item['quantity']]);
        }
        $conexao->commit();
        return true;
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) { // serve para verificar se existe uma transação ativa no momento. Ele retorna um valor booleano (true ou false).
            $conexao->rollBack(); // serve para cancelar todas as alterações feitas no banco de dados desde o início da transação.
        }
        throw $e;
    }
}

function criaItem($conexao, $name, $pathImage, $type_item, $damage, $damage_type, $critical, $item_range, $effect, $category, $space, $prestige, $description, $created_by, $character_id = null, $quantity = 1)
{
    try {
        $conexao->beginTransaction();

        $sql = "INSERT INTO items (
                    name,
                    img,
                    type_item,
                    damage,
                    damage_type,
                    critical,
                    item_range,
                    effect,
                    category,
                    space,
                    prestige,
                    description, 
                    created_by
                )
                VALUES (
                    :name,
                    :img,
                    :type_item,
                    :damage,
                    :damage_type,
                    :critical,
                    :item_range,
                    :effect,
                    :category,
                    :space,
                    :prestige,
                    :description, 
                    :created_by
                )
                RETURNING id";

        $stmt = $conexao->prepare($sql);

        $stmt->execute([
            ':name'        => $name,
            ':img'         => $pathImage,
            ':type_item'   => $type_item,
            ':damage'      => $damage !== '' ? $damage : null,
            ':damage_type' => $damage_type !== '' ? $damage_type : null,
            ':critical'    => $critical !== '' ? $critical : null,
            ':item_range'  => $item_range !== '' ? $item_range : null,
            ':effect'      => $effect !== '' ? $effect : null,
            ':category'    => $category !== '' ? $category : null,
            ':space'       => $space,
            ':prestige'    => $prestige,
            ':description' => $description,
            ':created_by' => $created_by,
        ]);

        $item_id = $stmt->fetchColumn();

        if ($character_id) {
            $stmt = $conexao->prepare("INSERT INTO character_items (character_id, item_id, quantity) VALUES (:c, :i, :q)");
            $stmt->execute([':c' => $character_id, ':i' => $item_id, ':q' => $quantity]);
        }

        $conexao->commit();

        return $item_id;
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }

        throw $e;
    }
}
function criaRitual($conexao, $name, $pathImage, $element, $ritual_type, $pd_gasto, $dano, $effect, $description, $created_by, $characters_ids = [])
{
    try {
        $conexao->beginTransaction();

        $sql = "INSERT INTO rituals (
                    name,
                    img,
                    element,
                    pd_gasto,
                    ritual_type,
                    dano,
                    effect,
                    description, 
                    created_by
                )
                VALUES (
                    :name,
                    :img,
                    :element,
                    :pd_gasto,
                    :ritual_type,
                    :dano,
                    :effect,
                    :description, 
                    :created_by
                )
                RETURNING id";

        $stmt = $conexao->prepare($sql);

        $stmt->execute([
            ':name'        => $name,
            ':img'         => $pathImage,
            ':element'   => $element,
            ':pd_gasto'      => $pd_gasto,
            ':ritual_type' => $ritual_type,
            ':dano'   => $dano !== '' ? $dano : null,
            ':effect' => $effect !== '' ? $effect : null,
            ':description' => $description,
            ':created_by' => $created_by
        ]);

        $ritual_id = $stmt->fetchColumn();

        $stmt = $conexao->prepare("INSERT INTO character_rituals (character_id, ritual_id) VALUES (:c, :r)");
        foreach ($characters_ids as $character_id) {
            $stmt->execute([':c' => $character_id, ':r' => $ritual_id]);
        }

        $conexao->commit();

        return $ritual_id;
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }

        throw $e;
    }
}
// Funções ligadas a leitura do Banco de Dados (READ) 
function readPersonagens($conexao, $id_user)
{
    $sql = "SELECT id, name, img FROM characters WHERE created_by = :id_user ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->bindParam(":id_user", $id_user);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readPersonagensAll($conexao)
{
    $sql = "SELECT * FROM characters ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readItems($conexao, $id_user)
{
    $sql = "SELECT id, name, img FROM items WHERE created_by = :id_user ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->bindParam(":id_user", $id_user);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readItemsAll($conexao)
{
    $sql = "SELECT * FROM items ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readRituals($conexao, $id_user)
{
    $sql = "SELECT id, name, img FROM rituals WHERE created_by = :id_user ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->bindParam(":id_user", $id_user);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readRitualsAll($conexao)
{
    $sql = "SELECT * FROM rituals ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function listaRituais($conexao)
{
    return $conexao->query("SELECT id, name, ritual_type FROM rituals ORDER BY name, id")->fetchAll(PDO::FETCH_ASSOC);
}
function listaItems($conexao)
{
    return $conexao->query("SELECT * FROM items ORDER BY name, id")->fetchAll(PDO::FETCH_ASSOC);
}
function readRituaisDoPersonagem($conexao, $id_char)
{
    $sql = "SELECT r.id, r.name, r.pd_gasto
            FROM character_rituals cr
            INNER JOIN rituals r ON r.id = cr.ritual_id
            WHERE cr.character_id = :id
            ORDER BY r.name";
    $stmt = $conexao->prepare($sql);
    $stmt->execute([':id' => $id_char]);
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function readSpecificPersonagem($conexao, $id_char)
{
    $sql = "SELECT c.*, u.username AS criador,

    (SELECT pc.player_id FROM player_characters pc WHERE pc.character_id = c.id LIMIT 1) AS player_id,

    (SELECT json_agg(p.name ORDER BY p.name) FROM player_characters pc JOIN players p ON p.id = pc.player_id WHERE pc.character_id = c.id) AS players,

    (SELECT json_agg(skill ORDER BY skill) FROM character_skills WHERE character_id = c.id) AS pericias,

    (SELECT json_agg( json_build_object( 'id', i.id, 'name', i.name, 'quantity', ci.quantity ) ORDER BY i.name) FROM character_items ci JOIN items i ON i.id = ci.item_id WHERE ci.character_id = c.id) AS itens,

    (SELECT json_agg( json_build_object('id', r.id, 'name', r.name) ORDER BY r.name ) FROM character_rituals cr JOIN rituals r ON r.id = cr.ritual_id WHERE cr.character_id = c.id) AS rituais
        FROM characters c
            LEFT JOIN userTabela u ON u.id = c.created_by
            WHERE c.id = :id_char";

    // json_agg() reúne os resultados de várias linhas em um único array JSON.
    // É utilizado para retornar vários registros relacionados ao personagem, como suas perícias, itens e rituais, dentro de um único campo. Assim, evitamos precisar fazer várias consultas separadas ou lidar com várias linhas repetidas para o mesmo personagem.

    //json_build_object() cria um objeto JSON a partir de pares de chave e valor.
    //É utilizado para agrupar informações relacionadas de cada registro, como o ID, o nome e a quantidade de um item. Isso é necessário porque precisamos retornar esses dados juntos e manter a relação entre eles, permitindo recuperar cada informação separadamente no PHP.

    $stmt = $conexao->prepare($sql);

    $stmt->execute([
        ':id_char' => $id_char
    ]);

    $p = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$p) {
        return false;
    }

    foreach (['players', 'pericias', 'itens', 'rituais'] as $campo) {
        // json_decode() converte uma string JSON em dados PHP; o argumento true solicita um array associativo.
        $dados = json_decode($p[$campo] ?? '[]', true);
        $p[$campo] = is_array($dados) ? $dados : [];
    }

    $p['criador'] = $p['criador'] ?? 'desconhecido';

    return $p;
}

function readSpecificItem($conexao, $id_item)
{
    $sql = "SELECT i.*,
                   u.username AS criador
            FROM items i
            LEFT JOIN userTabela u ON u.id = i.created_by
            WHERE i.id = :id_item";

    $stmt = $conexao->prepare($sql);

    $stmt->execute([
        ':id_item' => $id_item
    ]);

    $item = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$item) {
        return false;
    }

    $item['criador'] = $item['criador'] ?? 'desconhecido';

    return $item;
}

function readSpecificRitual($conexao, $id_ritual)
{
    $sql = "SELECT r.*,
                   u.username AS criador
            FROM rituals r
            LEFT JOIN userTabela u ON u.id = r.created_by
            WHERE r.id = :id_ritual";

    $stmt = $conexao->prepare($sql);

    $stmt->execute([
        ':id_ritual' => $id_ritual
    ]);

    $ritual = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$ritual) {
        return false;
    }

    $ritual['criador'] = $ritual['criador'] ?? 'desconhecido';

    return $ritual;
}
// Funções relacionadas a atualização dos cadastros

function updateCharacterADM($conexao, $id_char, $player_id, $name, $pathImage, $agi, $str, $intel, $pre, $vig, $history, $occupation, $personality, $class, $nex, $pericias = [], $rituais = [], $items = [])
{
    try {
        $conexao->beginTransaction();

        // 1. Atualiza os dados do personagem
        $sql = "UPDATE characters SET name = :name, img = :img, agi = :agi, str = :str, intel = :intel, pre = :pre, vig = :vig, history = :history, occupation = :occupation, personality = :personality, class = :class, nex = :nex WHERE id = :id";

        $stmt = $conexao->prepare($sql);
        $stmt->execute([
            ':id' => $id_char,
            ':name' => $name,
            ':img' => $pathImage,
            ':agi' => $agi,
            ':str' => $str,
            ':intel' => $intel,
            ':pre' => $pre,
            ':vig' => $vig,
            ':history' => $history,
            ':occupation' => $occupation,
            ':personality' => $personality,
            ':class' => $class,
            ':nex' => $nex // Corrigido de $foto para $pathImage
        ]);

        // 2. Atualiza vínculo de jogador (Se como ADM você puder trocar quem é o dono do personagem)
        if ($player_id !== null) {
            $stmt = $conexao->prepare("UPDATE player_characters SET player_id = :p WHERE character_id = :c");
            $stmt->execute([':p' => $player_id, ':c' => $id_char]);
        }

        // 3. Atualiza Perícias
        $stmt = $conexao->prepare("DELETE FROM character_skills WHERE character_id = :c");
        $stmt->execute([':c' => $id_char]);

        $stmt = $conexao->prepare("INSERT INTO character_skills (character_id, skill) VALUES (:c, :s)");
        foreach ($pericias as $skill) {
            $stmt->execute([':c' => $id_char, ':s' => $skill]);
        }

        // 4. Atualiza Rituais
        $stmt = $conexao->prepare("DELETE FROM character_rituals WHERE character_id = :c");
        $stmt->execute([':c' => $id_char]);

        $stmt = $conexao->prepare("INSERT INTO character_rituals (character_id, ritual_id) VALUES (:c, :r)");
        foreach ($rituais as $ritual_id) {
            $stmt->execute([':c' => $id_char, ':r' => $ritual_id]);
        }

        // 5. Atualiza Itens
        $stmt = $conexao->prepare(
            "DELETE FROM character_items WHERE character_id = :c"
        );
        $stmt->execute([':c' => $id_char]);

        $stmt = $conexao->prepare(
            "INSERT INTO character_items (character_id, item_id, quantity)
     VALUES (:c, :i, :q)"
        );

        foreach ($items as $item) {
            $stmt->execute([
                ':c' => $id_char,
                ':i' => $item['item_id'],
                ':q' => $item['quantity']
            ]);
        }

        $conexao->commit();
        return true;
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }
        throw $e;
    }
}

function updateItemADM($conexao, $id_item, $id_user, $name, $pathImage, $type_item, $damage, $damage_type, $critical, $item_range, $effect, $category, $space, $prestige, $description)
{
    try {
        $conexao->beginTransaction();

        // 1. Atualiza os dados do item
        $sql = "UPDATE items SET name = :name, img = :img, type_item = :type_item, damage = :damage, damage_type = :damage_type, critical = :critical, item_range = :item_range, effect = :effect, category = :category, space = :space, prestige = :prestige, description = :description WHERE id = :id";

        $stmt = $conexao->prepare($sql);

        $stmt->execute([
            ':id' => $id_item,
            ':name' => $name,
            ':img' => $pathImage,
            ':type_item' => $type_item,
            ':damage' => $damage,
            ':damage_type' => $damage_type,
            ':critical' => $critical,
            ':item_range' => $item_range,
            ':effect' => $effect,
            ':category' => $category,
            ':space' => $space,
            ':prestige' => $prestige,
            ':description' => $description
        ]);

        $conexao->commit();

        return true;
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }

        throw $e;
    }
}

function updateRitualADM($conexao, $id_ritual, $id_user, $name, $pathImage, $pd_gasto, $dano, $effect, $description, $element, $ritual_type)
{
    try {
        $conexao->beginTransaction();

        // 1. Atualiza os dados do ritual
        $sql = "UPDATE rituals SET name = :name, img = :img, pd_gasto = :pd_gasto, dano = :dano, effect = :effect, description = :description, element = :element, ritual_type = :ritual_type WHERE id = :id_ritual AND created_by = :id_user";
        $stmt = $conexao->prepare($sql);

        $stmt->execute([':id_ritual'  => $id_ritual, ':id_user'    => $id_user, ':name'       => $name, ':img'        => $pathImage, ':pd_gasto'   => $pd_gasto, ':dano'       => $dano, ':effect'     => $effect, ':description' => $description, ':element'    => $element, ':ritual_type' => $ritual_type]);

        $conexao->commit();

        return true;
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }

        throw $e;
    }
}

// Funções relacionadas a deletamento de registros


function deleteCharADM($conexao, $id_char, $id_user)
{
    $sql = "SELECT img FROM characters WHERE id = :id AND created_by = :id_user";

    $stmt = $conexao->prepare($sql);
    $stmt->execute([':id' => $id_char, ':id_user' => $id_user]);

    $char = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$char) {
        return false;
    }

    $conexao->beginTransaction();

    try {
        $sql = "DELETE FROM characters
                WHERE id = :id AND created_by = :id_user";

        $stmt = $conexao->prepare($sql);
        $stmt->execute([':id' => $id_char, ':id_user' => $id_user]);

        if ($stmt->rowCount() === 0) {
            $conexao->rollBack();
            return false;
        }

        $conexao->commit();
    } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }
        throw $e;
    }

    // Apaga a foto depois que o banco confirmar a exclusão
    deleteImage($char['img']);
    return true;
}
function deleteItemADM($conexao, $id_item, $id_user)
{
    $sql = "DELETE FROM items WHERE id = :id AND created_by = :id_user RETURNING img";
    $stmt = $conexao->prepare($sql);
    $stmt->execute([':id' => $id_item, ':id_user' => $id_user]);

    $img = $stmt->fetchColumn();
    if ($img === false) {
        return false;
    }

    // Apaga a foto depois que o banco confirmar a exclusão
    deleteImage($img);
    return true;
}
function deleteRitualADM($conexao, $id_ritual, $id_user)
{
    $sql = "DELETE FROM rituals WHERE id = :id AND created_by = :id_user RETURNING img";
    $stmt = $conexao->prepare($sql);
    $stmt->execute([':id' => $id_ritual, ':id_user' => $id_user]);

    $img = $stmt->fetchColumn();
    if ($img === false) {
        return false;
    }

    // Apaga a foto depois que o banco confirmar a exclusão
    deleteImage($img);
    return true;
}


// Funções relacionadas ao Login
function consultaUser($conexao, $email)
{
    try {
        $sql = "SELECT * FROM usertabela WHERE email = :email";
        $stmt = $conexao->prepare($sql);
        $stmt->execute([':email' => $email]);

        return $stmt->fetch(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        if ($e->getCode() == '23502') { // Esse erro significa violação de restrição de não nulo
            echo "Preencha todos os campos obrigatórios!";
        } elseif ($e->getCode() == '23514') { // Esse erro significa que ocorreu violação de restrição de verificação
            echo "Um dos campos viola uma regra de validação.";
        } else {
            error_log($e->getMessage());
            echo "Ocorreu um erro ao consultar o usuário.";
        }

        return false;
    }
}


function cadastraUser($conexao, $username, $email, $passwd)
{

    $sql = "INSERT INTO usertabela (username, email, passwd) VALUES (:username, :email, :passwd)";
    // Definimos a função que será enviada ao SQL
    try {
        $stmt = $conexao->prepare($sql);
        $stmt->bindParam(":username", $username);
        $stmt->bindParam(":email", $email); // Aqui, definimos os valores que seram enviados para a table
        $stmt->bindParam(":passwd", $passwd);
        $stmt->execute();
        return True;
    } catch (PDOException $e) {
        if ($e->getCode() == '23505') {
            echo "Registro já existe."; // Caso o registro já exista
        } elseif ($e->getCode() == '23502') {
            echo "Preencha todos os campos obrigatórios!"; // Esse erro apita quando algum campo é enviado como null (Sendo que a coluna é NOT NULL)
        } elseif ($e->getCode() == '23514') {
            echo "Email inválido! Tente novamente."; // Caso o email enviado vá contra o regex
        } else {
            echo "Erro: " . $e->getMessage();
        }
    }
}
// Funções Relacionadas ao gerencialmento de imagens

function downloadImage()
{
    $diretorio_destino = __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'uploads';

    // Cria a pasta caso ela não exista
    if (!is_dir($diretorio_destino)) {
        mkdir($diretorio_destino, 0755, true);
    }

    // Só roda o script no caso de o POST tenha sido feito
    if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_FILES['foto'])) {
        throw new Exception("Nenhum arquivo enviado.");
    }

    $arquivo = $_FILES['foto'];
    // Apita SOMENTE no caso de que nenhuma imagem foi enviada
    if ($arquivo['error'] === UPLOAD_ERR_NO_FILE) {
        throw new Exception("Selecione uma imagem.");
    }
    // Verificação de erros nativos do PHP no upload
    if ($arquivo['error'] !== UPLOAD_ERR_OK) {
        throw new Exception("Erro no envio do arquivo.");
    }

    // Validação do Tamanho (2MB = 2 * 1024 * 1024 bytes)
    $limite_tamanho = 2 * 1024 * 1024;

    if ($arquivo['size'] > $limite_tamanho) {
        throw new Exception("O arquivo é maior do que 2MB!");
    }

    // Definindo o Nome do Arquivo de forma segura
    // Pegamos a extensão original (.jpg, .png, etc)
    $extensao = strtolower(pathinfo($arquivo['name'], PATHINFO_EXTENSION));

    // Aceita só extensões de imagem e confere se o conteúdo é realmente uma imagem
    $permitidas = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    if (!in_array($extensao, $permitidas, true) || getimagesize($arquivo['tmp_name']) === false) {
        throw new Exception("Formato de imagem inválido.");
    }

    // Geramos um nome único usando ID único + timestamp para evitar que arquivos se sobrescrevam
    $novo_nome = uniqid('img_', true) . '.' . $extensao;

    // Definindo o Caminho Completo
    $caminho_completo = $diretorio_destino . DIRECTORY_SEPARATOR . $novo_nome;

    // Move o arquivo da pasta temporária para o destino final
    if (!move_uploaded_file($arquivo['tmp_name'], $caminho_completo)) {
        throw new Exception("Erro ao salvar o arquivo no servidor.");
    }

    // Retorna o caminho relativo, que pode ser gravado no banco e usado no <img>
    return 'uploads/' . $novo_nome;
}


function deleteImage($caminhoImagem)
{
    if (empty($caminhoImagem)) {
        return false;
    }

    // Caminho da pasta uploads, seguindo a estrutura de downloadImage()
    $diretorioUploads = realpath(
        __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'uploads'
    );

    if ($diretorioUploads === false) {
        return false;
    }

    // Aceita somente caminhos relativos da pasta uploads
    $nomeArquivo = basename($caminhoImagem);

    if ($nomeArquivo === '.' || $nomeArquivo === '..') {
        return false;
    }

    $caminhoCompleto = realpath(
        $diretorioUploads . DIRECTORY_SEPARATOR . $nomeArquivo
    );

    // Garante que o arquivo está dentro de uploads
    if (
        $caminhoCompleto === false ||
        !is_file($caminhoCompleto) ||
        dirname($caminhoCompleto) !== $diretorioUploads
    ) {
        return false;
    }

    return unlink($caminhoCompleto);
}
