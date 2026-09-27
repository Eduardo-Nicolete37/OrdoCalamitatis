<?php require_once '../includes/helpers.php'; // Chamamos o helpers.php para podermos usar as funções que estão lá
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../style/style.css">
    <title>Cadastre-se</title>
</head>

<body>
    <div class="create">
        <?php
        include '../includes/header.php'; // Chamamos o header que está nos includes
        ?>
        <header>
            <h1>Registre-se no sistema: </h1>
        </header>
        <hr>
        <main>
            <form action="" method="POST">
                <label for="username">Usuário: </label>
                <input type="text" name="username" id="username" required>
                <label for="email">Email: </label>
                <input type="email" name="email" id="email" required>
                <label for="senha">Senha: </label>
                <input type="password" name="senha" id="senha" required>
                <label for="senhaConfirm">Confirme a senha: </label>
                <input type="password" name="senhaConfirm" id="senhaConfirm" required>
                <input type="reset" value="Limpar">
                <input type="submit" value="Enviar">
            </form>
            <p>Já tem cadastro? <a href="./login.php">Entre aqui</a></p>
            <hr>
            <?php
            include '../includes/footer.php'; //Chamamos o footer que está nos includes
            // Esse if serve para o php somente comece no momento em que o formulário seja submetido
            if ($_SERVER['REQUEST_METHOD'] == "POST") {
                if (!isset($_POST['email']) || !isset($_POST['senha']) || !isset($_POST['username']) || !isset($_POST['senhaConfirm'])) {
                    echo "Formulário inválido! Campos faltando.";
                } else {
                    if ($_POST['senha'] !== $_POST['senhaConfirm']) {
                        echo "Suas senhas não são iguais, tente novamente!";
                    } else {
                        $username = $_POST['username']; // Para facilitar a intepretação do código, inserimos os POSTs dentro de váriaveis
                        $email = $_POST['email'];
                        $passwd = password_hash($_POST['senha'], PASSWORD_DEFAULT); // Colocamos a senha recebida dentro de um HASH
                        if (cadastraUser($conexao, $username, $email, $passwd)) // Chamamos a função do helpers.php 
                        {
                            echo "Cadastro feito com sucesso! <br>";
                            echo "Entre por <a href='./login.php'>aqui</a>";
                        }
                    }
                }
            }

            ?>
        </main>
    </div>
</body>

</html>