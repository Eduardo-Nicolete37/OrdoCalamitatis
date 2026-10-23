<?php
require_once __DIR__ . "/../../../login/verifica_user.php";
require_once __DIR__ . "/../../../includes/helpers.php";

// Valida o ID recebido pela URL
if (!isset($_GET['id']) || !ctype_digit((string) $_GET['id'])) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$id_ritual = (int) $_GET['id'];
$id_user = (int) $_SESSION['id'];

// Verifica se o ritual existe e pertence ao usuário
$ritual = readSpecificRitual($conexao, $id_ritual);

if (!$ritual) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
} elseif ($id_user !== $ritual['created_by']) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

try {
    // Exclui o ritual usando o ID do ritual e o ID do usuário
    $result = deleteRitualADM($conexao, $id_ritual, $id_user);

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