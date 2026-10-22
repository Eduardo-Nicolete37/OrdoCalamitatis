<?php
$host = "localhost";
$dbname = "calamitatisdb";
$user = "ordo";
$password = "ADICIONE SUA SENHA AQUI";
try {
    $conexao = new PDO(
        "pgsql:host=$host;dbname=$dbname",
        $user,
        $password
    );
    // echo "Conexão estabelecida com sucesso!";
} catch (PDOException $e) {
    echo "Erro: " . $e->getMessage();
} ?>