<?php require_once __DIR__ . '/../../login/verifica_user.php';?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://googleapis.com" rel="stylesheet">
    <link rel="stylesheet" href="/style/style.css">
    <title>Novo Personagem</title>
</head>
<body>
    <?php
    include_once __DIR__ . "/../../includes/header.php";
    ?>
    <header>
        <h1>Novo Personagem</h1>
    </header>
    <main>
<!--TODO: Criar o input das listas, e terminar de fazer as váriaveis e o header
characters {
    int id PK "Identity"
    varchar(255) name "Not Null"
    varchar(255) img "Null"
    int agi "Not Null"
    int str "Not Null"
    int intel "Not Null"
    int pre "Not Null"
    int vig "Not Null"
    varchar(255) occupation "Not Null"
    text history "Not Null"
    varchar(255) personality "Not Null"
    varchar(12) class "Not Null"
    int nex "Not Null"
    }
-->
        <form action="/includes/upload.php" method="post" class="create" enctype="multipart/form-data">
                <label for="name">Nome: </label>
                <input type="text" name="name" id="name" required placeholder="John Doe">
                <label for="foto">Imagem:</label>
                <input type="file" id="foto" name="foto" accept="image/*">
                <label for="agi">Agilidade: </label>
                <input type="number" name="agi" id="agi" required placeholder="0">
                <label for="str">Força: </label>
                <input type="number" name="str" id="str" required placeholder="0">
                <label for="intel">Inteligencia: </label>
                <input type="number" name="intel" id="intel" required placeholder="0">
                <label for="pre">Presença: </label>
                <input type="number" name="pre" id="pre" required placeholder="0">
                <label for="vig">Vigor: </label>
                <input type="number" name="vig" id="vig" required placeholder="0">
                <label for="history">História: </label>
                <textarea name="history" id="history" required placeholder="Era uma vez..."></textarea>
                <label for="nex">NEX: </label>
                <input type="int" name="nex" id="nex" required placeholder="99%" max="99">
                <input type="submit" value="Enviar">
        </form>
        <?php 
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $name = $_POST['name'];
            $agi = $_POST['agi'];
            $str = $_POST['str'];
            $intel = $_POST['intel'];
            $intel = $_POST['intel'];
            $intel = $_POST['intel'];
            //criaPersonagem($conexao, );
        }
        ?>
    </main>
</body>
</html>