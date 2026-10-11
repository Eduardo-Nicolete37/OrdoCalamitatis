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
    $created_by
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

        $conexao->commit();
        return true;
         } catch (Throwable $e) {
        if ($conexao->inTransaction()) {
            $conexao->rollBack();
        }
        throw $e;
         }
}

function criaItem($conexao, $name, $pathImage, $type_item, $damage, $damage_type, $critical, $item_range, $effect, $category, $space, $prestige, $description, $created_by, $character_id = null, $quantity = 1) {
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
function criaRitual($conexao, $name, $pathImage, $element, $ritual_type, $pd_gasto, $dano, $effect, $description, $created_by, $character_id = null) {
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
        if ($character_id) {
            $stmt = $conexao->prepare("INSERT INTO character_rituals (character_id, ritual_id) VALUES (:c, :r)");
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
function readPersonagens($conexao, $id_user) {
    $sql = "SELECT id, name, img FROM characters WHERE created_by = :id_user ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->bindParam(":id_user", $id_user);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readItems($conexao, $id_user) {
    $sql = "SELECT id, name, img FROM items WHERE created_by = :id_user ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->bindParam(":id_user", $id_user);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}
function readRituals($conexao, $id_user) {
    $sql = "SELECT id, name, img FROM rituals WHERE created_by = :id_user ORDER BY id"; // Definimos a função que será enviada ao SQL
    $stmt = $conexao->prepare($sql);
    $stmt->bindParam(":id_user", $id_user);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

// Funções relacionadas ao Login
function consultaUser($conexao, $email)
{
    try {
        $sql = "SELECT * FROM usertabela WHERE email = :email;"; // Definimos a função que será enviada ao SQL
        $stmt = $conexao->prepare($sql);
        $stmt->bindParam(":email", $email); // O ID  que será procurado é enviado à database
        $stmt->execute();

        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);
        return $usuario;
    } catch (PDOException $e) {
        if ($e->getCode() == '23502') { // Esse erro apita quando algum campo é enviado como null (Sendo que a coluna é NOT NULL)
            echo "Preencha todos os campos obrigatórios!";
        } elseif ($e->getCode() == '23514') {
            echo "Email inválido! Tente novamente."; // Caso o email enviado vá contra o regex
        } else {

            echo "Erro: " . $e->getMessage();
        }
        return false;
    }
    echo '<br>' . "<a href='/mini_sistema'>Retorne aqui</a>";
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
// Funções Relacionadas ao Download de imagens

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
