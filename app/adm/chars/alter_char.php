<?php
require_once __DIR__ . "/../../../includes/helpers.php";
require_once __DIR__ . "/../../../login/verifica_user.php";
if (isset($_GET['id'])) {
    $id_char = $_GET['id'];
    $id_user = $_SESSION['id'];
    $tracos_selecionados = array_map(
        'trim',
        explode(',', $char['personality'] ?? '')
    );
    $char = readSpecificPersonagem($conexao, $id_user, $id_char);
    $grupos_tracos = [
        'Racionais'  => ['Cético', 'Metódico', 'Frio e Calculista'],
        'Impulsivos' => ['Protetor', 'Impulsivo', 'Vingativo'],
        'Instáveis'  => ['Paranoico', 'Empático', 'Excêntrico'],
    ];
    $rituais_lista = listaRituais($conexao);
    $items_lista = listaItems($conexao);
    $lista_pericias = [
        'Acrobacia',
        'Adestramento',
        'Artes',
        'Atletismo',
        'Atualidades',
        'Ciências',
        'Crime',
        'Diplomacia',
        'Enganação',
        'Fortitude',
        'Furtividade',
        'Iniciativa',
        'Intimidação',
        'Intuição',
        'Investigação',
        'Luta',
        'Medicina',
        'Ocultismo',
        'Percepção',
        'Pilotagem',
        'Pontaria',
        'Profissão',
        'Reflexos',
        'Religião',
        'Sobrevivência',
        'Tática',
        'Tecnologia',
        'Vontade'
    ];
    $players = $conexao->query("SELECT id, name FROM players ORDER BY name")->fetchAll(PDO::FETCH_ASSOC);
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
    <title>Atualizar - <?php echo $char['name']; ?></title>
</head>

<body>
    <header>
        <?php include_once __DIR__ . "/../../../includes/header.php"; ?>
        <h1>Atualize o <?php echo $char['name']; ?></h1>
    </header>
    <main>
        <form action="" method="post" class="create" enctype="multipart/form-data">
            <label for="name">Nome: </label>
            <input type="text" name="name" id="name" required placeholder="Fulano de Tal" value="<?php echo htmlspecialchars($char['name'] ?? '') ?>">

            <label for="foto">Imagem:</label>
            <input type="file" id="foto" name="foto" accept="image/*">

            <label for="agi">Agilidade: </label>
            <input type="number" name="agi" id="agi" required min="0" placeholder="0" value="<?php echo (int)$char['agi'] ?>">

            <label for="str">Força: </label>
            <input type="number" name="str" id="str" required min="0" placeholder="0" value="<?php echo (int)$char['str']; ?>">

            <label for="intel">Inteligência: </label>
            <input type="number" name="intel" id="intel" required min="0" placeholder="0" value="<?php echo (int)$char['intel']; ?>">

            <label for="pre">Presença: </label>
            <input type="number" name="pre" id="pre" required min="0" placeholder="0" value="<?php echo (int)$char['pre']; ?>">

            <label for="vig">Vigor: </label>
            <input type="number" name="vig" id="vig" required min="0" placeholder="0" value="<?php echo (int)$char['vig']; ?>">

            <label for="player_id">Jogador (dono do personagem):</label>

            <select name="player_id" id="player_id" required>
                <option value="" disabled>Selecione...</option>

                <?php foreach ($players as $pl): ?>
                    <option
                        value="<?= (int) $pl['id'] ?>"
                        <?= (int) $pl['id'] === (int) ($char['player_id'] ?? 0) ? 'selected' : '' ?>>
                        <?= htmlspecialchars($pl['name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
            <label for="class">Classe: </label>
            <select name="class" id="class" required>
                <option value="" disabled selected>Selecione...</option>
                <option value="Combatente">Combatente</option>
                <option value="Especialista">Especialista</option>
                <option value="Ocultista">Ocultista</option>
            </select>

            <label for="occupation">Escolha ou digite a sua Origem (Passado):</label>
            <input type="text" id="occupation" name="occupation" list="lista-passados" required maxlength="255" value="<?= htmlspecialchars($char['occupation'] ?? '') ?>" placeholder="Selecione ou digite...">
            <datalist id="lista-passados">
                <option value="Acadêmico"></option>
                <option value="Agente de Saúde"></option>
                <option value="Artista"></option>
                <option value="Atleta"></option>
                <option value="Criminoso"></option>
                <option value="Investigador"></option>
                <option value="Militar"></option>
                <option value="Religioso"></option>
                <option value="T.I. (Tecnologia da Informação)"></option>
            </datalist>

            <fieldset>
                <legend>Traços de Personalidade:</legend>

                <?php foreach ($grupos_tracos as $grupo => $tracos_do_grupo): ?>
                    <div class="grupo-tracos">
                        <span class="grupo-titulo">
                            <?= htmlspecialchars($grupo) ?>
                        </span>

                        <?php foreach ($tracos_do_grupo as $t): ?>
                            <label>
                                <input
                                    type="checkbox"
                                    name="tracos[]"
                                    value="<?= htmlspecialchars($t) ?>"
                                    <?= in_array(
                                        $t,
                                        array_map('trim', explode(',', $char['personality'] ?? '')),
                                        true
                                    ) ? 'checked' : '' ?>>
                                <span><?= htmlspecialchars($t) ?></span>
                            </label>
                        <?php endforeach; ?>
                    </div>
                <?php endforeach; ?>
            </fieldset>

            <?php $pericias_marcadas = $char['pericias'] ?? []; ?>
            <fieldset>
                <legend>Perícias treinadas:</legend>

                <?php foreach ($lista_pericias as $p): ?>
                    <label>
                        <input
                            type="checkbox"
                            name="pericias[]"
                            value="<?= htmlspecialchars($p) ?>"
                            <?= in_array($p, $pericias_marcadas, true) ? 'checked' : '' ?>>
                        <span><?= htmlspecialchars($p) ?></span>
                    </label>
                <?php endforeach; ?>
            </fieldset>

            <fieldset class="rolavel">
                <legend>Rituais dominados (opcional):</legend>
                <?php if (!$rituais_lista): ?>
                    <p style="text-align: center; width: 100%;">Nenhum ritual cadastrado ainda.</p>
                <?php endif; ?>
                <?php foreach ($rituais_lista as $r): ?>
                    <label>
                        <input type="checkbox" name="rituais[]" value="<?= (int) $r['id'] ?>">
                        <?= htmlspecialchars($r['name']) ?>
                    </label>
                <?php endforeach; ?>
            </fieldset>
            <fieldset class="rolavel">
                <legend>Itens portados (opcional):</legend>

                <?php if (!$items_lista): ?>
                    <p style="text-align: center; width: 100%;">Nenhum item cadastrado ainda.</p>
                <?php endif; ?>

                <?php foreach ($items_lista as $i): ?>
                    <div class="item-personagem">
                        <label for="item_<?= (int) $i['id'] ?>">
                            <?= htmlspecialchars($i['name']) ?>
                        </label>

                        <input
                            type="number"
                            id="item_<?= (int) $i['id'] ?>"
                            name="items[<?= (int) $i['id'] ?>]"
                            min="0"
                            value="0">
                    </div>
                <?php endforeach; ?>
            </fieldset>
            <label for="history">História: </label>
            <textarea name="history" id="history" required placeholder="Era uma vez..."><?= htmlspecialchars($char['history'] ?? '') ?></textarea>

            <label for="nex">NEX: </label>
            <input type="number" name="nex" id="nex" required min="0" max="99" placeholder="99" value="<?= (int) ($char['nex'] ?? 0) ?>>

            <input type=" submit" value="Enviar">

            <?php var_dump($char); ?>
        </form>
    </main>
    <footer>
        <?php include_once __DIR__ . "/../../../includes/footer.php"; ?>
    </footer>
</body>

</html>