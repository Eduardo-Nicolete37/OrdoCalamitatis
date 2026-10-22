<?php
require_once __DIR__ . '/../../../includes/helpers.php';
session_start();
$characters_list = readPersonagensAll($conexao);
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Personagens - Ordo Calamitatis</title>
</head>
<body>
    <header>
        <?php include_once __DIR__ . '/../../../includes/header.php'; ?>
        <h1>Personagens - Ordo Calamitatis</h1>
    </header>
    <main class=creations>
    <?php 
    if (count($characters_list) > 0){
                echo "<strong>Personagens: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($characters_list as $p) {
                echo "<li>" . "<a href='./char.php?id=" . $p['id'] . "'>" . htmlspecialchars($p['name']) . "</a> </li> <br>";} 
                echo "</ol>";
            } else {
                echo "<p>Nenhum personagem encontrado!</p>";}
    ?>
    </main>
    <footer>
        <?php include_once __DIR__ . '/../../../includes/footer.php'; ?>
    </footer>
</body>
</html>