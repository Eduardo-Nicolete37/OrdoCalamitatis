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
?>

<!DOCTYPE html> 
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Ritual - <?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?></title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../../includes/header.php"; ?>
    </header>
        <main>
        <main class="ficha">
            <h1><?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?></h1>

            <p class="ficha-id">
                #<?= (int) $ritual['id'] ?>
                · <?= htmlspecialchars($ritual['element'] ?? 'Elemento não informado', ENT_QUOTES, 'UTF-8') ?>
                · <?= htmlspecialchars($ritual['ritual_type'] ?? 'Círculo não informado', ENT_QUOTES, 'UTF-8') ?>
            </p>

            <img
                class="ficha-foto"
                src="/OrdoCalamitatis/<?= htmlspecialchars($ritual['img'], ENT_QUOTES, 'UTF-8') ?>"
                alt="Imagem do ritual <?= htmlspecialchars($ritual['name'], ENT_QUOTES, 'UTF-8') ?>"
            >

            <?php if (!empty($ritual['pd_gasto'])): ?>
                <section>
                    <h2>PE gastos</h2>
                    <p><?= htmlspecialchars((string) $ritual['pd_gasto'], ENT_QUOTES, 'UTF-8') ?></p>
                </section>
            <?php endif; ?>

            <?php if (!empty($ritual['dano'])): ?>
                <section>
                    <h2>Dano</h2>
                    <p><?= htmlspecialchars($ritual['dano'], ENT_QUOTES, 'UTF-8') ?></p>
                </section>
            <?php endif; ?>

            <?php if (!empty($ritual['effect'])): ?>
                <section>
                    <h2>Efeito</h2>
                    <p><?= nl2br(htmlspecialchars($ritual['effect'], ENT_QUOTES, 'UTF-8')) ?></p>
                </section>
            <?php endif; ?>

            <section>
                <h2>Descrição</h2>
                <p><?= nl2br(htmlspecialchars($ritual['description'] ?? '', ENT_QUOTES, 'UTF-8')) ?></p>
            </section>

            <section class="acoes">
                <a
                    class="btn"
                    href="/OrdoCalamitatis/app/adm/rituals/alter_ritual.php?id=<?= (int) $id_ritual ?>"
                >
                    Atualizar ritual
                </a>

                <form
                    method="post"
                    action="/OrdoCalamitatis/app/adm/rituals/dele_ritual.php?id=<?= (int) $id_ritual ?>"
                    onsubmit="return confirm('Deletar este ritual? Essa ação não pode ser desfeita.');"
                >
                    <input
                        type="hidden"
                        name="id"
                        value="<?= (int) $id_ritual ?>"
                    >

                    <button type="submit" class="btn btn-perigo">
                        Deletar ritual
                    </button>
                </form>
            </section>
        </main>
        </main>

    </body>

    <footer>
        <?php include_once __DIR__ . "/../../../includes/footer.php"; ?>
    </footer>

</html>

