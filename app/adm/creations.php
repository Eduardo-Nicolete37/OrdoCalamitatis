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
        <?php include_once __DIR__ . '/../../includes/header.php';?>
        <nav aria-label="Menu de filtro" style="text-align: center;">
            <a href="./creations.php">Todos</a>
            <a href="./creations.php?personagens">Personagens</a>
            <a href="./creations.php?armas">Armas</a>
            <a href="./creations.php?Rituais">Rituais</a>
        </nav>
        <h1>Suas criações</h1>
    </header>

    <main>

        <?php 
        $id_user = $_SESSION['id'];
            if (isset($_GET['personagens'])) {
                //readPersonagens($conexao, $id_user);
            } elseif (isset($_GET['armas'])) {
                //readArmas($conexao, $id_user);
            } elseif (isset($_GET['rituais'])) {
                //readRituais($conexao, $id_user);
            } else {
                //readPersonagens();
                //readArmas();
                //readRituais();
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