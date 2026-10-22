<?php
require_once __DIR__ . '/../../../includes/helpers.php';
$rituals_list = readRitualsAll($conexao);
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Rituais - Ordo Calamitatis</title>
</head>
<body>
    <header>
        <?php include_once __DIR__ . '/../../../includes/header.php'; ?>
        <h1>Rituais - Ordo Calamitatis</h1>
    </header>
    <main class=creations>
    <?php 
    if (count($rituals_list) > 0){
                echo "<strong>Itens: </strong>";
                echo '<hr>';
                echo "<ol>";
                foreach ($rituals_list as $i) {
                echo "<li>" . "<a href='./ritual.php?id=" . $i['id'] . "'>" . htmlspecialchars($i['name']) . "</a> </li> <br>";} 
                echo "</ol>";
            } else {
                echo "<p>Nenhum ritual encontrado!</p>";}
    ?>
    </main>
    <footer>
        <?php include_once __DIR__ . '/../../../includes/footer.php'; ?>
    </footer>
</body>
</html>