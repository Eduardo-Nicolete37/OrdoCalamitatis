<?php 
require_once __DIR__ . '/../../login/verifica_user.php';
require_once __DIR__ . '/../../includes/helpers.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pathImage = null;
    try {
        $pathImage = downloadImage();

        $name = trim($_POST['name'] ?? '');
        $pd_gasto = $_POST['pd_gasto'] ?? null;
        $dano = trim($_POST['dano'] ?? '');
        $effect = trim($_POST['effect'] ?? '');
        $description = trim($_POST['description'] ?? '');
        $foto = $_FILES['foto'] ?? null;

        $element = trim($_POST['element'] ?? '');
        $element_validos = ['Sangue', 'Morte', 'Conhecimento', 'Energia', 'Medo'];
        if (!in_array($element, $element_validos, true)) {
            throw new Exception("Elemento inválido.");
        }

        $ritual_type = trim($_POST['ritual_type'] ?? '');
        $ritual_type_validos = ['1º Círculo', '2º Círculo', '3º Círculo', '4º Círculo'];
        if (!in_array($ritual_type, $ritual_type_validos, true)) {
            throw new Exception("Círculo inválido.");
        }
        if ($name === '' || $description === '') {
            throw new Exception("Nome e descrição são obrigatórios.");
        }

        if ($pd_gasto === false || $pd_gasto === null || $pd_gasto < 0) {
            throw new Exception("Custo em PD inválido.");
        }
        criaRitual($conexao, $name, $pathImage, $element, $ritual_type, $pd_gasto, $dano, $effect, $description);
        header('Location: /OrdoCalamitatis/app/adm/creations.php');
        exit;

    }  catch (Throwable $e) {
    echo '<pre>';
    echo htmlspecialchars($e->__toString());
    echo '</pre>';
    exit;
    }
}


?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/style/style.css">
    <title>Novo Ritual - Ordo Calamitatis</title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../includes/header.php"; ?>
        <h1>Novo Ritual</h1>
    </header>
    <main>
        <form action="" method="post" class="create" enctype="multipart/form-data">
            <label for="name">Nome: </label>
            <input type="text" name="name" id="name" required maxlength="255" placeholder="Chama Pálida">

            <label for="foto">Imagem:</label>
            <input type="file" name="foto" id="foto" accept="image/*">

            <label for="element">Elemento: </label>
            <select name="element" id="element" required>
                <option value="" disabled selected>Selecione...</option>
                <option value="Sangue">Sangue</option>
                <option value="Morte">Morte</option>
                <option value="Conhecimento">Conhecimento</option>
                <option value="Energia">Energia</option>
                <option value="Medo">Medo</option>
            </select>

            <label for="ritual_type">Círculo: </label>
            <select name="ritual_type" id="ritual_type" required>
                <option value="" disabled selected>Selecione...</option>
                <option value="1º Círculo">1º Círculo</option>
                <option value="2º Círculo">2º Círculo</option>
                <option value="3º Círculo">3º Círculo</option>
                <option value="4º Círculo">4º Círculo</option>
            </select>

            <label for="pd_gasto">Custo (PD): </label>
            <input type="number" name="pd_gasto" id="pd_gasto" required min="0" placeholder="5">

            <label for="dano">Dano: </label>
            <input type="text" name="dano" id="dano" maxlength="255" placeholder="2d6">

            <label for="effect">Efeito: </label>
            <input type="text" name="effect" id="effect" maxlength="255" placeholder="Alvo fica amedrontado">

            <label for="description">Descrição: </label>
            <textarea name="description" id="description" required></textarea>

            <input type="submit" value="Enviar">
        </form>
    </main>
</body>

</html>