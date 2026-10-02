<head>
    <!--<link rel="stylesheet" href="style.css">-->
    <link href="https://googleapis.com" rel="stylesheet">
</head>
<nav>
    <div class="navConfig">
        <div class="menuButton">
            <details>
                <summary>Menu</summary>
                <ul>
                    <li><a href="/app/rituals.php">Rituais</a></li>
                    <li><a href="/app/weapons.php">Armas</a></li>
                    <li><a href="/app/history.php">História</a></li>
                    <li><a href="/app/charlist.php">Personagens</a></li>
                </ul>
            </details>
        </div>
        <div>
            <a href="../" class="logo-navbar">
                <img src=".\images\logo.webp" alt="logo"> <!--Placeholder por agora-->
            </a>
        </div>
        <?php 
if (isset($_SESSION['id'])){
    echo "<div class='authLinks'>";
    echo "<details>";
    echo "<summary>Administrador - " . $_SESSION['username'] . "</summary>";
    echo "<ul>";
    echo "<li><a href='/app/new_char.php'>Novo Personagem</a></li>";
    echo "<li><a href='/app/creations.php'>Suas Criações</a></li>";
    echo "<li><a href='/app/new_item.php'>Novo Item</a></li>";
    echo "<li><a href='/app/new_ritual.php'>Novo Ritual</a></li>";
    echo "<li><a href='../login/logout.php'>Log-Out</a></li>";
    echo "</ul>";
    echo "</details>";
    echo "</div>";
} else {
    echo "<div class='authLinks'>";
    echo "<a href='../login/cadastrar.php'>Cadastre-se</a>";
    echo "<a href='../login/login.php'>Entre aqui</a>";
    echo "</div>";
}
?>

    </div>
</nav>