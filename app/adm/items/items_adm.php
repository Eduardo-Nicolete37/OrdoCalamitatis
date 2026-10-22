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

if (!$item) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Item - <?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?></title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../../includes/header.php"; ?>
    </header>

    <main>
        <main class="ficha">
            <h1><?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?></h1>

            <p class="ficha-id">
                #<?= (int) $item['id'] ?>
                · <?= htmlspecialchars($item['type_item'] ?? '', ENT_QUOTES, 'UTF-8') ?>
                · Categoria: <?= htmlspecialchars($item['category'] ?? 'Não informada', ENT_QUOTES, 'UTF-8') ?>
            </p>

            <img
                class="ficha-foto"
                src="/OrdoCalamitatis/<?= htmlspecialchars($item['img'], ENT_QUOTES, 'UTF-8') ?>"
                alt="Imagem de <?= htmlspecialchars($item['name'], ENT_QUOTES, 'UTF-8') ?>"
            >

            <?php if (!empty($item['damage'])): ?>
                <section>
                    <h2>Dano</h2>
                    <p><?= htmlspecialchars($item['damage'], ENT_QUOTES, 'UTF-8') ?></p>
                </section>
            <?php endif; ?>

            <?php if (!empty($item['damage_type'])): ?>
                <section>
                    <h2>Tipo de dano</h2>
                    <p><?= htmlspecialchars($item['damage_type'], ENT_QUOTES, 'UTF-8') ?></p>
                </section>
            <?php endif; ?>

            <?php if (!empty($item['critical'])): ?>
                <section>
                    <h2>Crítico</h2>
                    <p><?= htmlspecialchars($item['critical'], ENT_QUOTES, 'UTF-8') ?></p>
                </section>
            <?php endif; ?>

            <?php if (!empty($item['item_range'])): ?>
                <section>
                    <h2>Alcance</h2>
                    <p><?= htmlspecialchars($item['item_range'], ENT_QUOTES, 'UTF-8') ?></p>
                </section>
            <?php endif; ?>

            <?php if (!empty($item['effect'])): ?>
                <section>
                    <h2>Efeito</h2>
                    <p><?= nl2br(htmlspecialchars($item['effect'], ENT_QUOTES, 'UTF-8')) ?></p>
                </section>
            <?php endif; ?>

            <section>
                <h2>Prestígio</h2>
                <p><?= (int) ($item['prestige'] ?? 0) ?></p>
            </section>

            <section>
                <h2>Espaço ocupado</h2>
                <p><?= (int) ($item['space'] ?? 1) ?></p>
            </section>

            <section>
                <h2>Descrição</h2>
                <p><?= nl2br(htmlspecialchars($item['description'] ?? '', ENT_QUOTES, 'UTF-8')) ?></p>
            </section>

            <section class="acoes">
                <a
                    class="btn"
                    href="/OrdoCalamitatis/app/adm/items/alter_item.php?id=<?= (int) $id_item ?>"
                >
                    Atualizar item
                </a>

                <form
                    method="post"
                    action="/OrdoCalamitatis/app/adm/items/dele_item.php?id=<?= (int) $id_item ?>"
                    onsubmit="return confirm('Deletar este item? Essa ação não pode ser desfeita.');"
                >
                    <input type="hidden" name="id" value="<?= (int) $id_item ?>">

                    <button type="submit" class="btn btn-perigo">
                        Deletar item
                    </button>
                </form>
            </section>
        </main>
    </main>

    <footer>
        <?php include_once __DIR__ . "/../../../includes/footer.php"; ?>
    </footer>
</body>

</html>
