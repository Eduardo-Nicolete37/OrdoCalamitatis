<?php 
require_once __DIR__ . '/../../login/verifica_user.php';
require_once __DIR__ . '/../../includes/helpers.php';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pathImage = null;
    try {
    $pathImage = downloadImage();
        // O trim serve para 2 funções principais:
        //  1. Remover espaços inúteis no começo e/ou fim do input
        //  2. Para evitar o recebimento de mensagens somente com espaços, como '     '. O trim faz com que a string fique vazia, retornando a mensagem que o campo é obrigatório
        // O ?? serve para usar o $_POST somente caso ele exista, senão enviar um espaço vazio, que vai retornar erro
        $name = trim($_POST['name'] ?? '');
        $damage= trim($_POST['damage'] ?? '');
        $critical= trim($_POST['critical'] ?? '');
        $item_range= trim($_POST['item_range'] ?? '');
        $effect= trim($_POST['effect'] ?? '');
        $space = (int) ($_POST['space'] ?? 0);
        $prestige = (int) ($_POST['prestige'] ?? 0);
        $description= trim($_POST['description'] ?? '');

        // Classe: só aceita valores da lista
        $type_item = trim($_POST['type_item'] ?? '');
        $tipos_validos = ['Arma', 'Proteção', 'Geral', 'Paranormal'];
        if (!in_array($type_item, $tipos_validos, true)) {
            throw new Exception("Tipo inválido.");
        }

        // Tipo de dano: só aceita os valores da lista
        $damage_type= trim($_POST['damage_type'] ?? '');
        $damage_type_validos = ['Nenhum', 'Corte', 'Impacto', 'Perfuração', 'Balístico'];
        if (!in_array($damage_type, $damage_type_validos, true)) {
            throw new Exception("Tipo de dano inválido.");
        }

        // Categoria: só aceita os valores da lista
        $category= trim($_POST['category'] ?? '');
        $category_validos = ['0', 'I', 'II', 'III', 'IV'];
        if (!in_array($category, $category_validos, true)) {
            throw new Exception("Categoria inválido.");
        }

        criaItem($conexao, $name, $pathImage, $type_item, $damage, $damage_type, $critical, $item_range, $effect, $category, $space, $prestige, $description);

        header('Location: /OrdoCalamitatis/app/adm/creations.php');
        exit;
    } catch (Exception $e) {
        // Apaga a imagem enviada se algo falhou depois do upload
        if ($pathImage) {
            $arquivo = __DIR__ . '/../../' . $pathImage;
            if (is_file($arquivo)) {
                unlink($arquivo);
            }
        }
        $erro = $e->getMessage();
    }}

    
    
    
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
        <?php include_once __DIR__ . '/../../includes/header.php';?>
        <h1>Novo Item</h1>
    </header>
    <main>
        <form action="" method="post" class="create" enctype="multipart/form-data">
    <label for="name">Nome: </label>
    <input type="text" name="name" id="name" required maxlength="255" placeholder="Faca Enferrujada">

    <label for="foto">Imagem:</label>
    <input type="file" name="foto" id="foto" accept="image/*">

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
        <option value="Corte">Corte</option>
        <option value="Impacto">Impacto</option>
        <option value="Perfuração">Perfuração</option>
        <option value="Balístico">Balístico</option>
    </select>

    <label for="critical">Crítico: </label>
    <input type="text" name="critical" id="critical" maxlength="10" placeholder="19/x2">

    <label for="item_range">Alcance: </label>
    <input type="text" name="item_range" id="item_range" maxlength="255" placeholder="Curto">

    <label for="effect">Efeito: </label>
    <input type="text" name="effect" id="effect" maxlength="255" placeholder="Causa sangramento">

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

    <label for="description">Descrição: </label>
    <textarea name="description" id="description" required></textarea>

    <input type="submit" value="Enviar">
</form>
    </main>
    <footer>
        <?php 
        include_once __DIR__ . '/../../includes/footer.php';
        ?>
    </footer>
</body>
</html>