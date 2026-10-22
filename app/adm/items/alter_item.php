<?php
require_once __DIR__ . "/../../../login/verifica_user.php";
require_once __DIR__ . "/../../../includes/helpers.php";

if (!isset($_GET['id']) || !ctype_digit((string) $_GET['id'])) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$id_item = (int) $_GET['id'];
$id_user = (int) $_SESSION['id'];

$item = readSpecificItem($conexao, $id_item);

if (!$item || (int) $item['created_by'] !== $id_user) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$erro = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Inicializamos os valores antes do try para evitar variáveis indefinidas no catch.
    $pathImage = $item['img'];
    $novaImagem = false;

    $name = trim($_POST['name'] ?? '');
    $type_item = trim($_POST['type_item'] ?? '');
    $damage = trim($_POST['damage'] ?? '');
    $damage_type = trim($_POST['damage_type'] ?? '');
    $critical = trim($_POST['critical'] ?? '');
    $item_range = trim($_POST['item_range'] ?? '');
    $effect = trim($_POST['effect'] ?? '');
    $category = trim($_POST['category'] ?? '');
    $description = trim($_POST['description'] ?? '');

    $space = filter_var($_POST['space'] ?? null, FILTER_VALIDATE_INT); // serve para validar ou sanitizar uma única variável
    $prestige = filter_var($_POST['prestige'] ?? null, FILTER_VALIDATE_INT);

    try {
        if (isset($_FILES['foto']) && $_FILES['foto']['error'] !== UPLOAD_ERR_NO_FILE) {
            $pathImage = downloadImage();
            $novaImagem = true;
        }

        if ($name === '' || $description === '') {
            throw new Exception("Nome e descrição são obrigatórios.");
        }

        if ($effect === '') {
            throw new Exception("O efeito é obrigatório.");
        }

        $tipos_validos = ['Arma', 'Proteção', 'Geral', 'Paranormal'];

        if (!in_array($type_item, $tipos_validos, true)) {
            throw new Exception("Tipo de item inválido.");
        }

        $damage_type_validos = [
            'Corte',
            'Impacto',
            'Perfuração',
            'Balístico',
            'Sangue',
            'Morte',
            'Conhecimento',
            'Energia',
            'Fogo',
            'Frio',
            'Eletricidade',
            'Químico',
            'Mental'
        ];

        if ($damage_type !== '' && !in_array($damage_type, $damage_type_validos, true)) {
            throw new Exception("Tipo de dano inválido.");
        }

        if ($space === false || $space === null || $space < 0) {
            throw new Exception("O espaço deve ser um número inteiro igual ou maior que zero.");
        }

        if ($prestige === false || $prestige === null || $prestige < 0) {
            throw new Exception("O prestígio deve ser um número inteiro igual ou maior que zero.");
        }

        $category_validos = ['0', 'I', 'II', 'III', 'IV'];

        if ($category !== '' && !in_array($category, $category_validos, true)) {
            throw new Exception("Categoria inválida.");
        }

        updateItemADM(
            $conexao,
            $id_item,
            $id_user,
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
            $description
        );

        // A imagem antiga só é apagada depois de a atualização ser concluída.
        if ($novaImagem) {
            deleteImage($item['img']);
        }

        header("Location: /OrdoCalamitatis/app/adm/creations.php");
        exit;
    } catch (Throwable $e) {
        // Remove a imagem nova caso a atualização tenha falhado.
        if ($novaImagem) {
            deleteImage($pathImage);
        }

        $erro = $e->getMessage();
    }

    // Mantém os valores enviados no formulário caso ocorra algum erro.
    $item = array_merge($item, [
        'name' => $name,
        'type_item' => $type_item,
        'damage' => $damage,
        'damage_type' => $damage_type,
        'critical' => $critical,
        'item_range' => $item_range,
        'effect' => $effect,
        'category' => $category,
        'space' => $space === false || $space === null ? $item['space'] : $space,
        'prestige' => $prestige === false || $prestige === null ? $item['prestige'] : $prestige,
        'description' => $description
    ]);
}
?>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Atualizar item - <?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?></title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../../includes/header.php"; ?>
        <h1>Atualizar o <?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?></h1>
    </header>

    <main>
        <?php if (!empty($erro)): ?>
            <p class="erro"><?= htmlspecialchars($erro, ENT_QUOTES, 'UTF-8') ?></p>
        <?php endif; ?>

        <form action="" method="post" class="create" enctype="multipart/form-data">
            <label for="name">Nome:</label>
            <input type="text" name="name" id="name" required maxlength="255"
                value="<?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?>">

            <label for="foto">Imagem (opcional):</label>
            <input type="file" id="foto" name="foto" accept="image/jpeg,image/png,image/gif,image/webp">

            <label>Imagem atual:</label>
            <img class="ficha-foto"
                src="/OrdoCalamitatis/<?= htmlspecialchars($item['img'], ENT_QUOTES, 'UTF-8') ?>"
                alt="Imagem atual do item">

            <label for="type_item">Tipo de item:</label>
            <select name="type_item" id="type_item" required>
                <?php foreach (['Arma', 'Proteção', 'Geral', 'Paranormal'] as $tipo): ?>
                    <option value="<?= $tipo ?>"
                        <?= $item['type_item'] === $tipo ? 'selected' : '' ?>>
                        <?= $tipo ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="damage">Dano:</label>
            <input type="text" name="damage" id="damage" maxlength="255"
                value="<?= htmlspecialchars($item['damage'] ?? '', ENT_QUOTES, 'UTF-8') ?>">


            <label for="damage_type">Tipo de dano:</label>
            <select name="damage_type" id="damage_type">
                <option value="" <?= empty($item['damage_type']) ? 'selected' : '' ?>>Nenhum</option>

                <optgroup label="Mundanos / Físicos">
                    <?php foreach (['Corte', 'Impacto', 'Perfuração', 'Balístico'] as $tipo): ?>
                        <option value="<?= $tipo ?>"
                            <?= ($item['damage_type'] ?? '') === $tipo ? 'selected' : '' ?>>
                            <?= $tipo ?>
                        </option>
                    <?php endforeach; ?>
                </optgroup>

                <optgroup label="Paranormais">
                    <?php foreach (['Sangue', 'Morte', 'Conhecimento', 'Energia'] as $tipo): ?>
                        <option value="<?= $tipo ?>"
                            <?= ($item['damage_type'] ?? '') === $tipo ? 'selected' : '' ?>>
                            <?= $tipo ?>
                        </option>
                    <?php endforeach; ?>
                </optgroup>

                <optgroup label="Ambientais / Especiais">
                    <?php foreach (['Fogo', 'Frio', 'Eletricidade', 'Químico', 'Mental'] as $tipo): ?>
                        <option value="<?= $tipo ?>"
                            <?= ($item['damage_type'] ?? '') === $tipo ? 'selected' : '' ?>>
                            <?= $tipo ?>
                        </option>
                    <?php endforeach; ?>
                </optgroup>
            </select>


            <label for="critical">Crítico:</label>
            <input type="text" name="critical" id="critical" maxlength="10"
                value="<?= htmlspecialchars($item['critical'] ?? '', ENT_QUOTES, 'UTF-8') ?>">

            <label for="item_range">Alcance:</label>
            <input type="text" name="item_range" id="item_range" maxlength="255"
                value="<?= htmlspecialchars($item['item_range'] ?? '', ENT_QUOTES, 'UTF-8') ?>">

            <label for="effect">Efeito:</label>
            <textarea name="effect" id="effect"><?= htmlspecialchars($item['effect'] ?? '', ENT_QUOTES, 'UTF-8') ?></textarea>

            <label for="category">Categoria:</label>
            <select name="category" id="category">
                <option value="" <?= empty($item['category']) ? 'selected' : '' ?>>Nenhuma</option>
                <?php foreach (['0', 'I', 'II', 'III', 'IV'] as $categoria): ?>
                    <option value="<?= $categoria ?>"
                        <?= ($item['category'] ?? '') === $categoria ? 'selected' : '' ?>>
                        <?= $categoria ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="space">Espaço:</label>
            <input type="number" name="space" id="space" required min="0"
                value="<?= (int) $item['space'] ?>">

            <label for="prestige">Prestígio:</label>
            <input type="number" name="prestige" id="prestige" required min="0"
                value="<?= (int) $item['prestige'] ?>">

            <label for="description">Descrição:</label>
            <textarea name="description" id="description" required><?= htmlspecialchars($item['description'], ENT_QUOTES, 'UTF-8') ?></textarea>

            <input type="submit" value="Salvar alterações">
        </form>
    </main>

    <footer>
        <?php include_once __DIR__ . "/../../../includes/footer.php"; ?>
    </footer>
</body>

</html>