<?php
// Define a pasta de destino
$diretorio_destino = __dir__ . "\..\uploads";

// Cria a pasta caso ela não exista
if (!is_dir($diretorio_destino)) {
    mkdir($diretorio_destino, 0755, true);
}

// Só roda o script no caso de o POST tenha sido feito
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['foto'])) {
    
    $arquivo = $_FILES['foto'];
    
    // Verificação de erros nativos do PHP no upload
    if ($arquivo['error'] !== UPLOAD_ERR_OK) {
        die("Erro no envio do arquivo.");
    }

    // Validação do Tamanho (2MB = 2 * 1024 * 1024 bytes)
    $limite_tamanho = 2 * 1024 * 1024;
    
    if ($arquivo['size'] > $limite_tamanho) {
        die("Erro: O arquivo é maior do que 2MB!");
    }

    // Definindo o Nome do Arquivo de forma segura
    // Pegamos a extensão original (.jpg, .png, etc)
    $extensao = pathinfo($arquivo['name'], PATHINFO_EXTENSION);
    
    // Geramos um nome único usando ID único + timestamp para evitar que arquivos se sobrescrevam
    $novo_nome = uniqid('img_', true) . '.' . $extensao;

    // Definindo o Caminho Completo
    $caminho_completo = $diretorio_destino . $novo_nome;

    // Move o arquivo da pasta temporária para o destino final
    if (move_uploaded_file($arquivo['tmp_name'], $caminho_completo)) {
    } else {
        echo "Erro ao salvar o arquivo no servidor.";
    }
} else {
    echo "Nenhum arquivo enviado.";
}
?>

