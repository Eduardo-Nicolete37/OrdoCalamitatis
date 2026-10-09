<?php
require_once __DIR__ . '/../../login/verifica_user.php';
require_once __DIR__ . '/../../includes/helpers.php';

$erro = null;

$grupos_tracos = [
    'Racionais'  => ['Cético', 'Metódico', 'Frio e Calculista'],
    'Impulsivos' => ['Protetor', 'Impulsivo', 'Vingativo'],
    'Instáveis'  => ['Paranoico', 'Empático', 'Excêntrico'],
];

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
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $pathImage = null;

    try {
        $pathImage = downloadImage();
        $player_id = (int) ($_POST['player_id'] ?? 0);
        if (!in_array($player_id, array_map('intval', array_column($players, 'id')), true)) {
            throw new Exception("Jogador inválido.");
        }

        // O trim serve para 2 funções principais:
        //  1. Remover espaços inúteis no começo e/ou fim do input
        //  2. Para evitar o recebimento de mensagens somente com espaços, como '     '. O trim faz com que a string fique vazia, retornando a mensagem que o campo é obrigatório
        // O ?? serve para usar o $_POST somente caso ele exista, senão enviar um espaço vazio, que vai retornar erro
        $name       = trim($_POST['name'] ?? '');
        $agi        = (int) ($_POST['agi'] ?? 0);
        $str        = (int) ($_POST['str'] ?? 0);
        $intel      = (int) ($_POST['intel'] ?? 0);
        $pre        = (int) ($_POST['pre'] ?? 0);
        $vig        = (int) ($_POST['vig'] ?? 0);
        $occupation = trim($_POST['occupation'] ?? '');
        $history    = trim($_POST['history'] ?? '');
        $nex        = (int) ($_POST['nex'] ?? 0);

        // Classe: só aceita valores da lista
        $class = trim($_POST['class'] ?? '');
        $classes_validas = ['Combatente', 'Especialista', 'Ocultista'];
        if (!in_array($class, $classes_validas, true)) {
            throw new Exception("Classe inválida.");
        }

        // Traços: filtra pelo permitido e junta em uma string
        $tracos_validos = array_merge(...array_values($grupos_tracos));
        $tracos = array_intersect($_POST['tracos'] ?? [], $tracos_validos);
        if (empty($tracos)) {
            throw new Exception("Selecione ao menos um traço de personalidade.");
        }
        $personality = implode(', ', $tracos);

        $pericias = array_values(array_intersect($_POST['pericias'] ?? [], $lista_pericias));

        if ($nex < 0 || $nex > 99) {
            throw new Exception("NEX deve estar entre 0 e 99.");
        }

        criaPersonagem($conexao, $player_id, $name, $pathImage, $agi, $str, $intel, $pre, $vig, $history, $occupation, $personality, $class, $nex, $pericias);

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
    }
}
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./../../style/style.css">
    <title>Novo Personagem - Ordo Calamitatis</title>
</head>

<body>
    <header>
        <?php
        include_once __DIR__ . "/../../includes/header.php";
        ?>
        <h1>Novo Personagem</h1>
    </header>
    <main>
        <?php if ($erro): ?>
            <p class="erro"><?= htmlspecialchars($erro) ?></p>
        <?php endif; ?>

        <form action="" method="post" class="create" enctype="multipart/form-data">
            <label for="name">Nome: </label>
            <input type="text" name="name" id="name" required placeholder="Fulano de Tal">

            <label for="foto">Imagem:</label>
            <input type="file" id="foto" name="foto" accept="image/*" required>

            <label for="agi">Agilidade: </label>
            <input type="number" name="agi" id="agi" required min="0" placeholder="0">

            <label for="str">Força: </label>
            <input type="number" name="str" id="str" required min="0" placeholder="0">

            <label for="intel">Inteligência: </label>
            <input type="number" name="intel" id="intel" required min="0" placeholder="0">

            <label for="pre">Presença: </label>
            <input type="number" name="pre" id="pre" required min="0" placeholder="0">

            <label for="vig">Vigor: </label>
            <input type="number" name="vig" id="vig" required min="0" placeholder="0">
            <label for="player_id">Jogador (dono do personagem): </label>
            <select name="player_id" id="player_id" required>
                <option value="" disabled selected>Selecione...</option>
                <?php foreach ($players as $pl): ?>
                    <option value="<?= (int) $pl['id'] ?>"><?= htmlspecialchars($pl['name']) ?></option>
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
            <input type="text" id="occupation" name="occupation" list="lista-passados"
                required maxlength="255" placeholder="Selecione ou digite...">
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
                        <span class="grupo-titulo"><?= htmlspecialchars($grupo) ?></span>
                        <?php foreach ($tracos_do_grupo as $t): ?>
                            <label>
                                <input type="checkbox" name="tracos[]" value="<?= htmlspecialchars($t) ?>">
                                <?= htmlspecialchars($t) ?>
                            </label>
                        <?php endforeach; ?>
                    </div>
                <?php endforeach; ?>
            </fieldset>

            <fieldset>
                <legend>Perícias treinadas:</legend>
                <?php foreach ($lista_pericias as $p): ?>
                    <label>
                        <input type="checkbox" name="pericias[]" value="<?= htmlspecialchars($p) ?>">
                        <?= htmlspecialchars($p) ?>
                    </label>
                <?php endforeach; ?>
            </fieldset>

            <label for="history">História: </label>
            <textarea name="history" id="history" required placeholder="Era uma vez..."></textarea>

            <label for="nex">NEX: </label>
            <input type="number" name="nex" id="nex" required min="0" max="99" placeholder="99">

            <input type="submit" value="Enviar">
        </form>
    </main>
    <footer>
        <?php 
        include_once  __DIR__ . '/../../includes/footer.php';
        ?>
    </footer>
</body>

</html>