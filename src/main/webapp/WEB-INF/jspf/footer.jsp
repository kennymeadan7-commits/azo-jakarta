<%-- Pied de page commun. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="site-footer">
  <div class="container-page footer-inner">
    <div>
      <p class="footer-title">Azɔ</p>
      <p class="footer-list" style="max-width: 34ch">
        La plateforme des artisans et travailleurs indépendants du Bénin.
        Trouvez un professionnel vérifié près de chez vous, en FCFA.
      </p>
    </div>

    <div>
      <p class="footer-title">Navigation</p>
      <ul class="footer-list">
        <li><a href="${pageContext.request.contextPath}/">Accueil</a></li>
        <li><a href="${pageContext.request.contextPath}/workers">Nos ouvriers</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">Espace connecté</a></li>
      </ul>
    </div>

    <div>
      <p class="footer-title">Métiers</p>
      <ul class="footer-list">
        <li><a href="${pageContext.request.contextPath}/workers?trade=plomberie">Plomberie</a></li>
        <li><a href="${pageContext.request.contextPath}/workers?trade=electricite">Électricité</a></li>
        <li><a href="${pageContext.request.contextPath}/workers?trade=maconnerie">Maçonnerie</a></li>
        <li><a href="${pageContext.request.contextPath}/workers?trade=menage">Ménage</a></li>
      </ul>
    </div>

    <div>
      <p class="footer-title">Villes</p>
      <ul class="footer-list">
        <li><a href="${pageContext.request.contextPath}/workers?city=Cotonou">Cotonou</a></li>
        <li><a href="${pageContext.request.contextPath}/workers?city=Abomey-Calavi">Abomey-Calavi</a></li>
        <li><a href="${pageContext.request.contextPath}/workers?city=Parakou">Parakou</a></li>
        <li><a href="${pageContext.request.contextPath}/villes">Toutes les villes</a></li>
      </ul>
    </div>

    <div>
      <p class="footer-title">Légal</p>
      <ul class="footer-list">
        <li><a href="${pageContext.request.contextPath}/">Mentions légales</a></li>
        <li><a href="${pageContext.request.contextPath}/">Confidentialité</a></li>
        <li><a href="${pageContext.request.contextPath}/">Conditions d'utilisation</a></li>
        <li><a href="mailto:support@azo.bj">support@azo.bj</a></li>
      </ul>
    </div>
  </div>

  <div class="container-page footer-bottom">
    <span>&copy; 2026 Azɔ — Cotonou, Bénin</span>
    <span>Tous droits réservés</span>
  </div>
</footer>
