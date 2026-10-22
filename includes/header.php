<head>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Special+Elite&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/OrdoCalamitatis/style/style.css">
</head>
<nav aria-label="Menu principal">
    <div class="navConfig">
        <div class="menuButton">
            <details>
                <summary>Menu</summary>
                <ul>
                    <li><a href="/OrdoCalamitatis/app/user/chars/charlist.php">Personagens</a></li>
                    <li><a href="/OrdoCalamitatis/app/user/items/itemlist.php">Itens</a></li>
                    <li><a href="/OrdoCalamitatis/app/user/rituals/rituallist.php">Rituais</a></li>
                    <li><a href="/OrdoCalamitatis/app/user/assests.php">Dossiês e Adicionais</a></li>
                </ul>
            </details>
        </div>
        <div>
            <a href="/OrdoCalamitatis/" class="logo-navbar">
                <img src="/OrdoCalamitatis/imgs/imgLogo.webp" alt="logo"> 
            </a>
        </div>
        <?php 
if (isset($_SESSION['id'])){ // O menu só aparece caso a sessão esteja começada e com o user logado, do contrário, aparece apenas o botão de login/cadastro
    echo "<div class='authLinks'>";
    echo "<details>";
    echo "<summary>Administrador - " . $_SESSION['username'] . "</summary>";
    echo "<ul>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/chars/new_char.php'>Novo Personagem</a></li>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/items/new_item.php'>Novo Item</a></li>";
    echo "<li><a href='/OrdoCalamitatis/app/adm/rituals/new_ritual.php'>Novo Ritual</a></li>";
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