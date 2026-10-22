
<?php
require_once __DIR__ . '/../../../login/verifica_user.php';
require_once __DIR__ . '/../../../includes/helpers.php';

$created_by = (int) $_SESSION['id'];
$personagens = readPersonagens($conexao, $created_by);
$erro = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pathImage = null;

    try {
        $pathImage = downloadImage();

        // O trim() remove espaços desnecessários no início e no final da string.
        // O ?? fornece uma string vazia caso o campo não tenha sido enviado.
        $name = trim($_POST['name'] ?? '');
        $damage = trim($_POST['damage'] ?? '');
        $critical = trim($_POST['critical'] ?? '');
        $item_range = trim($_POST['item_range'] ?? '');
        $effect = trim($_POST['effect'] ?? '');
        $description = trim($_POST['description'] ?? '');

        // Os filtros abaixo garantem que os campos numéricos sejam inteiros válidos.
        $space = filter_var($_POST['space'] ?? null, FILTER_VALIDATE_INT);
        $prestige = filter_var($_POST['prestige'] ?? null, FILTER_VALIDATE_INT);

        if ($space === false || $space === null || $space < 0) {
            throw new Exception("O espaço deve ser um número inteiro igual ou maior que zero.");
        }

        if ($prestige === false || $prestige === null || $prestige < 0) {
            throw new Exception("O prestígio deve ser um número inteiro igual ou maior que zero.");
        }

        // Tipo de item: só aceita os valores previstos no formulário.
        $type_item = trim($_POST['type_item'] ?? '');
        $tipos_validos = ['Arma', 'Proteção', 'Geral', 'Paranormal'];

        if (!in_array($type_item, $tipos_validos, true)) {
            throw new Exception("Tipo de item inválido.");
        }

        // Tipo de dano: permite vazio quando o item não possui tipo de dano.
        $damage_type = trim($_POST['damage_type'] ?? '');
        $damage_type_validos = [
            'Corte', 'Impacto', 'Perfuração', 'Balístico',
            'Sangue', 'Morte', 'Conhecimento', 'Energia',
            'Fogo', 'Frio', 'Eletricidade', 'Químico', 'Mental'
        ];

        if ($damage_type !== '' && !in_array($damage_type, $damage_type_validos, true)) {
            throw new Exception("Tipo de dano inválido.");
        }

        // Categoria: aceita os valores previstos no formulário ou vazio.
        $category = trim($_POST['category'] ?? '');
        $category_validos = ['0', 'I', 'II', 'III', 'IV'];

        if ($category !== '' && !in_array($category, $category_validos, true)) {
            throw new Exception("Categoria inválida.");
        }

        // O personagem é opcional. Se informado, verificamos se pertence ao usuário.
        $character_id = trim($_POST['character_id'] ?? '');
        $character_id = $character_id !== '' ? filter_var($character_id, FILTER_VALIDATE_INT) : null;

        if ($character_id === false || ($character_id !== null && $character_id < 1)) {
            throw new Exception("Personagem inválido.");
        }

        $quantity = filter_var($_POST['quantity'] ?? 1, FILTER_VALIDATE_INT);

        if ($quantity === false || $quantity < 1) {
            throw new Exception("A quantidade deve ser pelo menos 1.");
        }

        if ($name === '') {
            throw new Exception("O nome do item é obrigatório.");
        }

        if ($description === '') {
            throw new Exception("A descrição é obrigatória.");
        }

        if ($effect === '') {
            throw new Exception("O efeito é obrigatório.");
        }

        if ($character_id !== null) {
            $sql = "SELECT id
                    FROM characters
                    WHERE id = :character_id
                      AND created_by = :created_by";

            $stmt = $conexao->prepare($sql);
            $stmt->execute([
                ':character_id' => $character_id,
                ':created_by' => $created_by
            ]);

            if (!$stmt->fetchColumn()) {
                throw new Exception("Personagem inválido ou não pertence a você.");
            }
        }

        // A função registra o item e, quando informado, o vínculo com o personagem.
        criaItem(
            $conexao,
            $name,
            $pathImage,
            $type_item,
            $damage,
            $damage_type,
            $critical,
            $item_range,
            $effect,
            $category !== '' ? $category : null,
            $space,
            $prestige,
            $description,
            $created_by,
            $character_id,
            $quantity
        );

        header('Location: /OrdoCalamitatis/app/adm/creations.php');
        exit;

    } catch (Throwable $e) {
        // Se algo falhar depois do upload, remove a imagem recém-enviada.
        if ($pathImage) {
            deleteImage($pathImage);
        }

        $erro = $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/style/style.css">
    <title>Novo Item - Ordo Calamitatis</title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . '/../../../includes/header.php'; ?>
        <h1>Novo Item</h1>
    </header>
    <main>
        <?php if ($erro !== ''): ?>
        <p class="erro"><?= htmlspecialchars($erro, ENT_QUOTES, 'UTF-8') ?></p>
        <?php endif; ?>
        <form action="" method="post" class="create" enctype="multipart/form-data">
            <label for="name">Nome: </label>
            <input type="text" name="name" id="name" required maxlength="255" placeholder="Faca Enferrujada">

            <label for="foto">Imagem:</label>
            <input type="file" name="foto" id="foto" accept="image/*" required>

            <label for="type_item">Tipo: </label>
            <select name="type_item" id="type_item" required>
                <option value="" disabled selected>Selecione...</option>
                <option value="Arma">Arma</option>
                <option value="Proteção">Proteção</option>
                <option value="Geral">Geral</option>
                <option value="Paranormal">Paranormal</option>
            </select>

            <label for="damage">Dano: </label>
            <input type="text" name="damage" id="damage" maxlength="255" placeholder="1d8">

        <label for="damage_type">Tipo de dano: </label>
        <select name="damage_type" id="damage_type">
            <option value="">Nenhum</option>
    
            <optgroup label="Mundanos / Físicos">
                <option value="Corte">Corte</option>
                <option value="Impacto">Impacto</option>
                <option value="Perfuração">Perfuração</option>
                <option value="Balístico">Balístico</option>
            </optgroup>

            <optgroup label="Paranormais">
                <option value="Sangue">Sangue</option>
                <option value="Morte">Morte</option>
                <option value="Conhecimento">Conhecimento</option>
                <option value="Energia">Energia</option>
            </optgroup>

            <optgroup label="Ambientais / Especiais">
                <option value="Fogo">Fogo</option>
                <option value="Frio">Frio</option>
                <option value="Eletricidade">Eletricidade</option>
                <option value="Químico">Químico</option>
                <option value="Mental">Mental</option>
        </optgroup>
            </select>

            <label for="critical">Crítico: </label>
            <input type="text" name="critical" id="critical" maxlength="10" placeholder="19/x2">

            <label for="item_range">Alcance: </label>
            <input type="text" name="item_range" id="item_range" maxlength="255" placeholder="Curto">

            <label for="effect">Efeito: </label>
            <textarea name="effect" id="effect" required placeholder="Causa sangramento"></textarea>

            <label for="category">Categoria: </label>
            <select name="category" id="category">
                <option value="">Nenhuma</option>
                <option value="0">0</option>
                <option value="I">I</option>
                <option value="II">II</option>
                <option value="III">III</option>
                <option value="IV">IV</option>
            </select>

            <label for="space">Espaços: </label>
            <input type="number" name="space" id="space" required min="0" value="1">

            <label for="prestige">Prestígio: </label>
            <input type="number" name="prestige" id="prestige" required min="0" value="0">

            <label for="character_id">Personagem dono (opcional): </label>
            <select name="character_id" id="character_id">
                <option value="">Nenhum</option>
                <?php foreach ($personagens as $p): ?>
                    <option value="<?= (int) $p['id'] ?>">
                        <?= htmlspecialchars($p['name']) ?> (#<?= (int) $p['id'] ?>)
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="quantity">Quantidade (vale só se escolher um personagem): </label>
            <input type="number" name="quantity" id="quantity" min="1" value="1">

            <label for="description">Descrição: </label>
            <textarea name="description" id="description" required></textarea>

            <input type="submit" value="Enviar">
        </form>
    </main>
    <footer>
        <?php
        include_once __DIR__ . '/../../../includes/footer.php';
        ?>
    </footer>
</body>

</html>