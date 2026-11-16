<%-- En-tête commun : lien d'évitement, marque, navigation, état d'authentification. --%>
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
    </div>
  </div>
</header>
