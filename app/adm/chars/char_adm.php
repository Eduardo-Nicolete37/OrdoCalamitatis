<?php
require_once __DIR__ . '\..\..\..\login\verifica_user.php';
require_once __DIR__ . '\..\..\..\includes\helpers.php';
if (isset($_GET['id'])) {
    $id_char = $_GET['id'];
    $id_user = $_SESSION['id'];
    $char = readSpecificPersonagem($conexao, $id_user, $id_char);
} else {
    header("Location: creations.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <title>Personagem - <?php echo htmlspecialchars($char['name']); ?></title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../../includes/header.php"; ?>
    </header>

    <main>
        <?php
        $atributos = [
            'Agilidade'    => 'agi',
            'Força'        => 'str',
            'Inteligência' => 'intel',
            'Presença'     => 'pre',
            'Vigor'        => 'vig',
        ];
        ?>
        <main class="ficha">
            <h1><?= htmlspecialchars($char['name']) ?></h1>
            <p class="ficha-id">
                #<?= (int) $char['id'] ?> · <?= htmlspecialchars($char['class']) ?> · NEX <?= (int) $char['nex'] ?>%
            </p>

            <img class="ficha-foto" src="/OrdoCalamitatis/<?= htmlspecialchars($char['img']) ?>" alt="Foto de <?= htmlspecialchars($char['name']) ?>">

            <section>
                <h2>Atributos</h2>
                <dl class="atributos">
                    <?php foreach ($atributos as $rotulo => $coluna): ?>
                        <div class="atr-<?= $coluna ?>">
                            <dt><?= $rotulo ?></dt>
                            <dd><?= (int) $char[$coluna] ?></dd>
                        </div>
                    <?php endforeach; ?>
                </dl>
            </section>

            <section>
                <h2>Origem</h2>
                <p><?= htmlspecialchars($char['occupation']) ?></p>
            </section>

            <section>
                <h2>Personalidade</h2>
                <ul class="tags">
                    <?php foreach (explode(', ', $char['personality']) as $traco): //Divide o texto onde tem ,
                    ?>
                        <li><?= htmlspecialchars($traco) ?></li>
                    <?php endforeach; ?>
                </ul>
            </section>

            <section>
                <h2>História</h2>
                <p><?= nl2br(htmlspecialchars($char['history'])) //nl2br funciona como um <br>
                    ?></p>
            </section>

            <section>
                <h2>Perícias</h2>
                <?php if ($char['pericias']): ?>
                    <ul class="tags">
                        <?php foreach ($char['pericias'] as $skill): ?>
                            <li><?= htmlspecialchars($skill) ?></li>
                        <?php endforeach; ?>
                    </ul>
                <?php else: ?>
                    <p>Nenhuma perícia treinada.</p>
                <?php endif; ?>
            </section>

            <section>
                <h2>Jogador</h2>
                <p><?= $char['players'] ? htmlspecialchars(implode(', ', $char['players'])) : 'Sem jogador' // Funciona como um if/else curto. Ele verifica se $char['players'] possui algum valor válido
                    ?></p>
            </section>

            <section>
                <h2>Itens/Armas</h2>
                <?php if ($char['itens']): ?>
                    <ul class="tags">
                        <?php foreach ($char['itens'] as $itens): ?>
                            <li><?= htmlspecialchars($itens) ?></li>
                        <?php endforeach; ?>
                    </ul>
                <?php else: ?>
                    <p>Nenhum item encontrado.</p>
                <?php endif; ?>
            </section>
            <section>
                <h2>Rituais</h2>
                <?php if ($char['rituais']): ?>
                    <ul class="tags">
                        <?php foreach ($char['rituais'] as $rituais): ?>
                            <li><?= htmlspecialchars($rituais) ?></li>
                        <?php endforeach; ?>
                    </ul>
                <?php else: ?>
                    <p>Nenhum ritual aprendido.</p>
                <?php endif; ?>
            </section>
            <section class="acoes">
                <a class="btn" href="/OrdoCalamitatis/app/adm/chars/alter_char.php?id=<?php echo (int)$id_char; ?>">Atualizar personagem</a>
                <form method="post" action="/OrdoCalamitatis/app/adm/chars/dele_char.php?id=<?php echo (int)$id_char;?>"
                    onsubmit="return confirm('Deletar este personagem? Essa ação não pode ser desfeita.');">
                    <input type="hidden" name="id" value="<?php echo (int)$id_char; ?>">
                    <button type="submit" class="btn btn-perigo">Deletar personagem</button>
                </form>
            </section>
        </main>
    </main>
    <footer>
        <?php include_once  __DIR__ . '/../../../includes/footer.php'; ?>
    </footer>

</body>

</html>