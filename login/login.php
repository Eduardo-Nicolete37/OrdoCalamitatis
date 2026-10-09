<?php 
require_once '../includes/helpers.php'; // Chamamos o helpers.php para podermos usar as funções que estão lá
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../style/style.css">
    <title>Ingresse  - Ordo Calamitatis</title>
</head>

<body>
    <div class="create">
        <header>
            <?php
            include '..\includes\header.php'; // Chamamos o header que está nos includes
            ?>
            <h1>Acesse o sistema</h1>
        </header>
        <hr>
        <main>
            <form action="" method="POST">
                <label for="email">Email: </label>
                <input type="email" name="email" id="email" placeholder="seuemail@gmail.com">
                <label for="senha">Senha: </label>
                <input type="password" name="senha" id="senha" required placeholder="********">
                <input type="submit" value="Enviar">
            </form>
            <p>Não tem cadastro? <a href="./cadastrar.php">Cadastre-se aqui</a></p>
            <?php
            // Esse if serve para o php somente comece no momento em que o formulário seja submetido
            if ($_SERVER['REQUEST_METHOD'] == "POST") {
                if (!isset($_POST['email']) || !isset($_POST['senha'])) {
                    echo "Formulário inválido! Tente novamente.";
                } else {
                    $email = $_POST['email']; 
                    $passwd = $_POST['senha'];

                    $usuario = consultaUser($conexao, $email);

                    if ($usuario === false) {
                        $erro = "Usuário não encontrado!";
                    } elseif (!password_verify($passwd, $usuario['passwd'])) {
                        $erro = "Senha incorreta!";
                    } else {
                        session_start();
                        $_SESSION['id'] = $usuario['id'];
                        $_SESSION['username'] = $usuario['username'];
                        sleep(1);
                        header("Location: ../");
                        exit();
                    }
                }
            }

            ?>
        </main>
        <hr>
    </div>
</body>

</html>