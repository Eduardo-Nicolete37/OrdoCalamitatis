<?php
$host = "192.168.10.46";
$dbname = "calamitatisdb";
$user = "ordo";
$password = "Eduardo@101";

try {
    $conexao = new PDO(
        "pgsql:host=$host;dbname=$dbname",
        $user,
        $password
    );
    // echo "Conexão estabelecida com sucesso!";
} catch (PDOException $e) {
    echo "Erro: " . $e->getMessage();
}
