<?php
require_once __DIR__ . "/../../../login/verifica_user.php";
require_once __DIR__ . "/../../../includes/helpers.php";

if (!isset($_GET['id']) || !ctype_digit((string) $_GET['id'])) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$id_ritual = (int) $_GET['id'];
$id_user = (int) $_SESSION['id'];

$ritual = readSpecificRitual($conexao, $id_user, $id_ritual);

if (!$ritual) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pathImage = $ritual['img'];
    $imagemNova = false;

    try {
        if (
            isset($_FILES['foto']) &&
            $_FILES['foto']['error'] !== UPLOAD_ERR_NO_FILE
        ) {
            $pathImage = downloadImage();
            $imagemNova = true;
        }

        $name = trim($_POST['name'] ?? '');
        $element = trim($_POST['element'] ?? '');
        $ritual_type = trim($_POST['ritual_type'] ?? '');
        $pd_gasto = trim($_POST['pd_gasto'] ?? '');
        $dano = trim($_POST['dano'] ?? '');
        $effect = trim($_POST['effect'] ?? '');
        $description = trim($_POST['description'] ?? '');

        if ($name === '' || $description === '') {
            throw new Exception("Nome e descrição são obrigatórios.");
        }

        $elementos_validos = [
            'Sangue',
            'Morte',
            'Conhecimento',
            'Energia',
            'Medo'
        ];

        if (!in_array($element, $elementos_validos, true)) {
            throw new Exception("Elemento inválido.");
        }

        if ($ritual_type === '') {
            throw new Exception("O círculo do ritual é obrigatório.");
        }

        updateRitualADM($conexao, $id_ritual, $id_user, $name, $pathImage, $pd_gasto, $dano, $effect, $description, $element, $ritual_type);

        // Remove a imagem antiga somente após salvar com sucesso.
        if ($imagemNova) {
            deleteImage($ritual['img']);
        }

        header("Location: /OrdoCalamitatis/app/adm/creations.php");
        exit;

    } catch (Throwable $e) {
        // Se o banco falhou, remove a imagem recém-enviada.
        if ($imagemNova) {
            deleteImage($pathImage);
        }

        $erro = $e->getMessage();

        // Mantém os dados enviados no formulário.
        $ritual = array_merge($ritual, [
            'name' => $name ?? $ritual['name'],
            'element' => $element ?? $ritual['element'],
            'ritual_type' => $ritual_type ?? $ritual['ritual_type'],
            'pd_gasto' => $pd_gasto ?? $ritual['pd_gasto'],
            'dano' => $dano ?? $ritual['dano'],
            'effect' => $effect ?? $ritual['effect'],
            'description' => $description ?? $ritual['description']
        ]);
    }
}
?>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>
        Atualizar ritual - <?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?>
    </title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../../includes/header.php"; ?>
        <h1>
            Atualizar o <?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?>
        </h1>
    </header>

    <main>
        <?php if (!empty($erro)): ?>
            <p class="erro">
                <?= htmlspecialchars($erro, ENT_QUOTES, 'UTF-8') ?>
            </p>
        <?php endif; ?>

        <form action="" method="post" class="create" enctype="multipart/form-data">

            <label for="name">Nome:</label>
            <input
                type="text"
                name="name"
                id="name"
                required
                maxlength="255"
                value="<?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?>"
            >

            <label for="foto">Imagem (opcional):</label>
            <input
                type="file"
                id="foto"
                name="foto"
                accept="image/jpeg,image/png,image/gif,image/webp"
            >

            <label>Imagem atual:</label>
            <img
                class="ficha-foto"
                src="/OrdoCalamitatis/<?= htmlspecialchars($ritual['img'], ENT_QUOTES, 'UTF-8') ?>"
                alt="Imagem atual do ritual"
            >

            <label for="element">Elemento:</label>
            <select name="element" id="element" required>
                <?php foreach (
                    ['Sangue', 'Morte', 'Conhecimento', 'Energia', 'Medo']
                    as $elemento
                ): ?>
                    <option
                        value="<?= htmlspecialchars($elemento, ENT_QUOTES, 'UTF-8') ?>"
                        <?= ($ritual['element'] ?? '') === $elemento ? 'selected' : '' ?>
                    >
                        <?= htmlspecialchars($elemento, ENT_QUOTES, 'UTF-8') ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="ritual_type">Círculo:</label>
            <select name="ritual_type" id="ritual_type" required>
                <?php foreach (
                    ['1º Círculo', '2º Círculo', '3º Círculo', '4º Círculo']
                    as $circulo
                ): ?>
                    <option
                        value="<?= htmlspecialchars($circulo, ENT_QUOTES, 'UTF-8') ?>"
                        <?= ($ritual['ritual_type'] ?? '') === $circulo ? 'selected' : '' ?>
                    >
                        <?= htmlspecialchars($circulo, ENT_QUOTES, 'UTF-8') ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label for="pd_gasto">PE gastos:</label>
            <input
                type="text"
                name="pd_gasto"
                id="pd_gasto"
                maxlength="255"
                value="<?= htmlspecialchars((string) ($ritual['pd_gasto'] ?? ''), ENT_QUOTES, 'UTF-8') ?>"
            >

            <label for="dano">Dano:</label>
            <input
                type="text"
                name="dano"
                id="dano"
                maxlength="255"
                value="<?= htmlspecialchars((string) ($ritual['dano'] ?? ''), ENT_QUOTES, 'UTF-8') ?>"
            >

            <label for="effect">Efeito:</label>
            <textarea
                name="effect"
                id="effect"
            ><?= htmlspecialchars($ritual['effect'] ?? '', ENT_QUOTES, 'UTF-8') ?></textarea>

            <label for="description">Descrição:</label>
            <textarea name="description" id="description" required><?= htmlspecialchars($ritual['description'] ?? '', ENT_QUOTES, 'UTF-8') ?></textarea>

            <input type="submit" value="Salvar alterações">
        </form>
    </main>

    <footer>
        <?php include_once __DIR__ . "/../../../includes/footer.php"; ?>
    </footer>
</body>

</html>