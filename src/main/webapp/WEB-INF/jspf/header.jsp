<%-- En-tête commun : lien d'évitement, marque, navigation, état d'authentification.
     Sur petit écran (< 900px) la navigation replie en un tiroir latéral ouvert par
     le bouton hamburger ; le tiroir et son voile sont placés HORS du <header>
     car backdrop-filter crée un bloc de conteneur pour les enfants fixed. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<a class="skip-link" href="#contenu">Aller au contenu</a>

<header class="site-header">
  <div class="container-page header-inner">
    <a class="brand" href="${pageContext.request.contextPath}/">
      <span class="brand-mark" aria-hidden="true">Az</span>
      <span>Azɔ</span>
    </a>

    <nav class="main-nav" aria-label="Navigation principale">
      <a href="${pageContext.request.contextPath}/"
         <c:if test="${navPage eq 'home'}">aria-current="page"</c:if>>Accueil</a>
      <a href="${pageContext.request.contextPath}/workers"
         <c:if test="${navPage eq 'workers'}">aria-current="page"</c:if>>Nos ouvriers</a>
      <a href="${pageContext.request.contextPath}/metiers"
         <c:if test="${navPage eq 'metiers'}">aria-current="page"</c:if>>Métiers</a>
      <a href="${pageContext.request.contextPath}/villes"
         <c:if test="${navPage eq 'villes'}">aria-current="page"</c:if>>Villes</a>
      <c:if test="${not empty sessionScope.currentUser}">
        <a href="${pageContext.request.contextPath}/mes-missions"
           <c:if test="${navPage eq 'missions'}">aria-current="page"</c:if>>Mes missions</a>
        <a href="${pageContext.request.contextPath}/dashboard"
           <c:if test="${navPage eq 'dashboard'}">aria-current="page"</c:if>>Tableau de bord</a>
      </c:if>
    </nav>

    <div class="header-actions">
      <c:choose>
        <c:when test="${empty sessionScope.currentUser}">
          <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/login.jsp">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
              <polyline points="10 17 15 12 10 7"/>
              <line x1="15" x2="3" y1="12" y2="12"/>
            </svg>
            Connexion
          </a>
        </c:when>
        <c:otherwise>
          <span class="pill pill-green" title="${sessionScope.currentUser.email}">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
            <c:out value="${sessionScope.currentUser.name}"/>
          </span>
          <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/logout">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
              <polyline points="16 17 21 12 16 7"/>
              <line x1="21" x2="9" y1="12" y2="12"/>
            </svg>
            Déconnexion
          </a>
        </c:otherwise>
      </c:choose>

      <%-- Bouton hamburger : visible uniquement sous 900px (voir style.css) --%>
      <button class="nav-toggle" type="button" aria-expanded="false" aria-controls="nav-drawer">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <line x1="4" x2="20" y1="6" y2="6"/>
          <line x1="4" x2="20" y1="12" y2="12"/>
          <line x1="4" x2="20" y1="18" y2="18"/>
        </svg>
        <span class="sr-only">Ouvrir le menu</span>
      </button>
    </div>
  </div>
</header>

<%-- Voile + tiroir mobile (hors <header> : voir note en tête de fichier) --%>
<noscript>
  <%-- Sans JavaScript : on réaffiche la navigation classique qui se replie. --%>
  <style>
    .nav-toggle { display: none !important; }
    .main-nav { display: flex !important; }
    .nav-drawer, .nav-overlay { display: none !important; }
  </style>
</noscript>
<div class="nav-overlay" data-nav-close></div>
<div class="nav-drawer" id="nav-drawer" role="dialog" aria-modal="true"
     aria-label="Menu principal" aria-hidden="true">
  <div class="nav-drawer-head">
    <span class="brand">
      <span class="brand-mark" aria-hidden="true">Az</span>
      <span>Azɔ</span>
    </span>
    <button class="nav-drawer-close" type="button" data-nav-close>
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M18 6 6 18"/>
        <path d="m6 6 12 12"/>
      </svg>
      <span class="sr-only">Fermer le menu</span>
    </button>
  </div>

  <nav class="nav-drawer-nav" aria-label="Navigation principale">
    <a href="${pageContext.request.contextPath}/"
       <c:if test="${navPage eq 'home'}">aria-current="page"</c:if>>Accueil</a>
    <a href="${pageContext.request.contextPath}/workers"
       <c:if test="${navPage eq 'workers'}">aria-current="page"</c:if>>Nos ouvriers</a>
    <a href="${pageContext.request.contextPath}/metiers"
       <c:if test="${navPage eq 'metiers'}">aria-current="page"</c:if>>Métiers</a>
    <a href="${pageContext.request.contextPath}/villes"
       <c:if test="${navPage eq 'villes'}">aria-current="page"</c:if>>Villes</a>
    <c:if test="${not empty sessionScope.currentUser}">
      <a href="${pageContext.request.contextPath}/mes-missions"
         <c:if test="${navPage eq 'missions'}">aria-current="page"</c:if>>Mes missions</a>
      <a href="${pageContext.request.contextPath}/dashboard"
         <c:if test="${navPage eq 'dashboard'}">aria-current="page"</c:if>>Tableau de bord</a>
    </c:if>
  </nav>

  <div class="nav-drawer-actions">
    <c:choose>
      <c:when test="${empty sessionScope.currentUser}">
        <a class="btn btn-primary btn-block" href="${pageContext.request.contextPath}/login.jsp">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
            <polyline points="10 17 15 12 10 7"/>
            <line x1="15" x2="3" y1="12" y2="12"/>
          </svg>
          Espace connecté
        </a>
      </c:when>
      <c:otherwise>
        <p class="nav-drawer-user">
          <c:out value="${sessionScope.currentUser.name}"/>
          <span><c:out value="${sessionScope.currentUser.email}"/></span>
        </p>
        <a class="btn btn-outline btn-block" href="${pageContext.request.contextPath}/logout">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" x2="9" y1="12" y2="12"/>
          </svg>
          Déconnexion
        </a>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  (function () {
    var toggle = document.querySelector(".nav-toggle");
    var drawer = document.getElementById("nav-drawer");
    var overlay = document.querySelector(".nav-overlay");
    if (!toggle || !drawer) return;

    var lastFocus = null;

    function setOpen(open) {
      if (open) lastFocus = document.activeElement;
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
      drawer.setAttribute("aria-hidden", open ? "false" : "true");
      document.body.classList.toggle("nav-open", open);
      drawer.classList.toggle("is-open", open);
      if (overlay) overlay.classList.toggle("is-open", open);

      var focusTarget = open
        ? drawer.querySelector(".nav-drawer-close")
        : lastFocus;
      if (focusTarget && typeof focusTarget.focus === "function") focusTarget.focus();
      lastFocus = null;
    }

    toggle.addEventListener("click", function () {
      setOpen(!drawer.classList.contains("is-open"));
    });

    document.addEventListener("click", function (e) {
      if (e.target && e.target.closest && e.target.closest("[data-nav-close]")) setOpen(false);
    });

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && drawer.classList.contains("is-open")) setOpen(false);
    });

    // Ferme le tiroir au clic sur un lien (la navigation se fait quand même).
    drawer.addEventListener("click", function (e) {
      if (e.target && e.target.closest && e.target.closest("a")) setOpen(false);
    });

    // Si la fenêtre repasse en desktop, on referme proprement.
    var mq = window.matchMedia("(min-width: 900px)");
    var onChange = function () { if (mq.matches) setOpen(false); };
    if (mq.addEventListener) mq.addEventListener("change", onChange);
    else if (mq.addListener) mq.addListener(onChange);
  })();
</script>
