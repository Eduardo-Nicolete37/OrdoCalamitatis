<?php
require_once __DIR__ . "/../../../login/verifica_user.php";
require_once __DIR__ . "/../../../includes/helpers.php";

// Valida o ID recebido pela URL
if (!isset($_GET['id']) || !ctype_digit((string) $_GET['id'])) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$id_item = (int) $_GET['id'];
$id_user = (int) $_SESSION['id'];

// Verifica se o item existe e pertence ao usuário
$item = readSpecificItem($conexao, $id_item);

if (!$item) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
} elseif ($id_user !== $item['created_by']) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

try {
    // Exclui o item usando o ID do item e o ID do usuário
    $result = deleteItemADM($conexao, $id_item, $id_user);

    if ($result) {
        header("Location: /OrdoCalamitatis/app/adm/creations.php");
        exit;
    }

    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;

} catch (Throwable $e) {
    error_log($e->getMessage());

    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}
?>