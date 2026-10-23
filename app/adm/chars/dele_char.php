<?php
require_once __DIR__ . "/../../../login/verifica_user.php";
require_once __DIR__ . "/../../../includes/helpers.php";

if (!isset($_GET['id']) || !ctype_digit((string) $_GET['id'])) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$id_char = (int) $_GET['id'];
$id_user = (int) $_SESSION['id'];

$char = readSpecificPersonagem($conexao, $id_char);

if (!$char) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
} elseif ($id_user !== $char['created_by']) {
    header("Location: /OrdoCalamitatis/app/adm/creations.php");
    exit;
}

$result = deleteCharADM($conexao, $id_char, $id_user);

if ($result) {
    header("Localtion: /OrdoCalamitatis/app/adm/creations.php");
} else {
    header("Localtion: /OrdoCalamitatis/app/adm/char_adm.php?id=" . $id_char);
}
?>