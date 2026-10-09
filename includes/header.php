<head>
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
    <link href="https://googleapis.com" rel="stylesheet">
</head>
<nav aria-label="Menu principal">
    <div class="navConfig">
        <div class="menuButton">
            <details>
                <summary>Menu</summary>
                <ul>
                    <li><a href="/app/user/rituals.php">Rituais</a></li>
                    <li><a href="/app/user/weapons.php">Armas</a></li>
                    <li><a href="/app/user/history.php">História</a></li>
                    <li><a href="/app/user/charlist.php">Personagens</a></li>
                    <li><a href="/app/user/assests.php">Dossiês e Adicionais</a></li>
                </ul>
            </details>
        </div>
        <div>
            <a href="/OrdoCalamitatis/" class="logo-navbar">
                <img src="/OrdoCalamitatis/" alt="logo"> <!--Placeholder por agora-->
            </a>
        </div>
        <?php 
if (isset($_SESSION['id'])){
    echo "<div class='authLinks'>";
    echo "<details>";
    echo "<summary>Administrador - " . $_SESSION['username'] . "</summary>";
    echo "<ul>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/new_char.php'>Novo Personagem</a></li>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/new_item.php'>Novo Item</a></li>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/new_ritual.php'>Novo Ritual</a></li>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/creations.php'>Suas Criações</a></li>";
    echo "<li><a href='/OrdoCalamitatis/login/logout.php'>Log-Out</a></li>";
    echo "</ul>";
    echo "</details>";
    echo "</div>";
} else {
    echo "<div class='authLinks'>";
    echo "<a href='/OrdoCalamitatis/login/cadastrar.php'>Cadastre-se</a>";
    echo "<a href='/OrdoCalamitatis/login/login.php'>Entre aqui</a>";
    echo "</div>";
}
?>

    </div>
</nav>