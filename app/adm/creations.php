<?php
require_once __DIR__ . '/../../login/verifica_user.php';
require_once __DIR__ . '/../../includes/helpers.php';
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Suas Criações - Ordo Calamitatis</title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . '/../../includes/header.php'; ?>
        <nav aria-label="Menu de filtro">
            <a href="./creations.php">Todos</a>
            <a href="./creations.php?personagens">Personagens</a>
            <a href="./creations.php?items">Items</a>
            <a href="./creations.php?rituais">Rituais</a>
</nav>
        <br>
        <h1>Suas criações</h1>
    </header>
    <main class=creations>

        <?php
        $id_user = $_SESSION['id'];
        if (isset($_GET['personagens'])) {
            $characters_list = readPersonagens($conexao, $id_user);
            if (count($characters_list) > 0){
                echo "<strong>Personagens: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($characters_list as $p) {
                echo "<li>" . "<a href='./char_adm.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";} 
                echo "</ol>";
            } else {
                echo "<p>Nenhum personagem encontrado!</p>";
                echo "<p><a href='/OrdoCalamitatis/app/adm/chars/new_char.php'>Crie um novo aqui</a></p>";
            }
        } elseif (isset($_GET['items'])) {
            $items_list = readItems($conexao, $id_user);
            if (count($items_list) > 0){
                echo "<strong>Items: </strong>";
                echo '<hr>';
                echo '<ol>';
                foreach ($items_list as $p) {
                echo "<li>" . "<a href='./items_adm.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";}
                echo "</ol>";
            } else {
                echo "<p>Nenhum items encontrado!</p>";
                echo "<p><a href='/OrdoCalamitatis/app/adm/items/new_item.php'>Crie um novo aqui</a></p>";
            }
        } elseif (isset($_GET['rituais'])) {
            $rituals_list = readRituals($conexao, $id_user);
            if (count($rituals_list) > 0){
                echo "<strong>Rituais: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($rituals_list as $p) {
                echo "<li>" . "<a href='./ritual_adm.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";}
                echo "</ol>";
            } else {
                echo "<p>Nenhum ritual encontrado!</p>";
                echo "<p><a href='/OrdoCalamitatis/app/adm/rituals/new_ritual.php'>Crie um novo aqui</a></p>";
            }
        } else {
            $characters_list = readPersonagens($conexao, $id_user);
            $items_list = readItems($conexao, $id_user);
            $rituals_list = readRituals($conexao, $id_user);
            if (count($characters_list) + count($items_list) + count($rituals_list)) {
                echo "<strong>Personagens: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($characters_list as $p) {
                    echo "<li>" . "<a href='/OrdoCalamitatis/app/adm/chars/char_adm.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";
                }
                echo "</ol>";
                echo '<hr>';
                echo "<strong>Items: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($items_list as $p) {
                    echo "<li>" . "<a href='/OrdoCalamitatis/app/adm/items/items_adm.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";
                }
                echo "</ol>";
                echo '<hr>';
                echo "<strong>Rituais: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($rituals_list as $p) {
                    echo "<li>" . "<a href='/OrdoCalamitatis/app/adm/rituals/rituals_adm.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";
                }
                echo "</ol>";
            } else {
                echo "<p>Nenhuma criação encontrada!</p>";
                echo "<p><a href='/OrdoCalamitatis/app/adm/chars/new_char.php'>Crie um novo personagem aqui</a></p>";
                echo "<p><a href='/OrdoCalamitatis/app/adm/items/new_item.php'>Crie um novo item aqui</a></p>";
                echo "<p><a href='/OrdoCalamitatis/app/adm/rituals/new_ritual.php'>Crie um novo ritual aqui</a></p>";
            }
        }
        ?>
    </main>
    <footer>
        <?php
        include_once  __DIR__ . '/../../includes/footer.php';
        ?>
    </footer>
</body>

</html>