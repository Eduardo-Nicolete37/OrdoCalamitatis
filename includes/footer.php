<div class="footer-links">
    <a href="/OrdoCalamitatis/">Início</a>
    <?php
    if (isset($_SESSION['id'])) {
        echo "<a href='/OrdoCalamitatis/app/adm/creations.php'>Suas criações</a>";
    } else {
        echo "<a href='/OrdoCalamitatis/app/user/chars/charlist.php'>Personagens</a>";
    }

    echo "<a href='/OrdoCalamitatis/app/user/assests.php'>Livros</a>";
    ?>
</div>

<a class="footer-github" href="https://github.com/Eduardo-Nicolete37/OrdoCalamitatis"
    target="_blank" rel="noopener" aria-label="Código no GitHub">
    <img src="/OrdoCalamitatis/imgs/logotipo-do-github.webp" alt="">
    <span>Código no GitHub</span>
</a>

<p class="footer-note">
    Projeto de fãs, sem fins lucrativos e sem vínculo oficial com os criadores de Ordem Paranormal.
</p>
<p class="footer-note">
    © 2026 Ordo Calamitatis · Desenvolvido por Eduardo Nicolete
</p>