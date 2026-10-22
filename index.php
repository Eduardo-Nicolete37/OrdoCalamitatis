<?php
require_once __DIR__ . '/includes/helpers.php';
require_once __DIR__ . '/login/verifica_user.php';

$chars_list = readPersonagensAll($conexao);
$items_list = readItemsAll($conexao);
$rituals_list = readRitualsAll($conexao);

$chars_destaque = array_slice($chars_list, 0, 3);
$items_destaque = array_slice($items_list, 0, 3);
$rituals_destaque = array_slice($rituals_list, 0, 3);
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Special+Elite&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Ordo Calamitatis</title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . '/includes/header.php'; ?>
    </header>

    <main class="home">
        <section class="hero">
            <img
                class="hero-img"
                src="/OrdoCalamitatis/imgs/imageFirstPage.webp"
                alt="Imagem de destaque de Ordem Paranormal"
            >

            <div class="hero-text">
                <h1>Ordo<br>Calamitatis</h1>

                <p>
                    Lorem ipsum dolor sit amet, consectetur adipisicing elit.
                    Descubra personagens, rituais, armas e histórias do universo
                    de Ordem Paranormal.
                </p>
            </div>
        </section>

        <section class="destaques">

            <!-- Personagens -->
            <a href="/OrdoCalamitatis/app/user/chars/charlist.php"
               class="card-destaque card--red">

                <h2>Personagens<br>mais procurados</h2>

                <ul>
                    <?php foreach ($chars_destaque as $char): ?>
                        <li>
                            <?= htmlspecialchars($char['name'], ENT_QUOTES, 'UTF-8') ?>
                        </li>
                    <?php endforeach; ?>
                </ul>

                <span class="ver-mais" style="text-align: center;">Clique para ver mais</span>
            </a>

            <!-- Itens -->
            <a href="/OrdoCalamitatis/app/user/items/itemlist.php"
               class="card-destaque card--gold">

                <h2>Itens<br>mais procurados</h2>

                <ul>
                    <?php foreach ($items_destaque as $item): ?>
                        <li>
                            <?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?>
                        </li>
                    <?php endforeach; ?>
                </ul>

                <span class="ver-mais" style="text-align: center;">Clique para ver mais</span>
            </a>

            <!-- Rituais -->
            <a href="/OrdoCalamitatis/app/user/rituals/rituallist.php"
               class="card-destaque card--purple">

                <h2>Rituais<br>mais procurados</h2>

                <ul>
                    <?php foreach ($rituals_destaque as $ritual): ?>
                        <li>
                            <?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?>
                        </li>
                    <?php endforeach; ?>
                </ul>

                <span class="ver-mais" style="text-align: center;">Clique para ver mais</span>
            </a>

        </section>
    </main>
    <footer>
        <?php
        include_once __DIR__ . '/includes/footer.php';
        ?>
    </footer>
</body>

</html>