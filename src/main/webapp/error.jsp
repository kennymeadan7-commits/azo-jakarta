<%-- Page d'erreur générique (404, 500, exceptions non attrapées). --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<c:set var="navPage" value="error"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Erreur — Azɔ</title>
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="auth-shell container-page">
  <div class="auth-card stack">
    <div class="center stack">
      <span class="icon-tile-lg" aria-hidden="true"
            style="justify-self: center; background-color: var(--danger-bg); color: var(--danger); box-shadow: inset 0 0 0 1px rgba(179,38,30,.25)">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/>
          <path d="M12 9v4"/><path d="M12 17h.01"/>
        </svg>
      </span>
      <h1 class="section-title">Une erreur est survenue</h1>
      <p class="muted" style="font-size: 0.95rem; max-width: 46ch">
        <c:choose>
          <c:when test="${not empty errorMessage}">
            <c:out value="${errorMessage}"/>
          </c:when>
          <c:when test="${not empty pageContext.errorData}">
            La page demandée a échoué
            (statut <c:out value="${pageContext.errorData.statusCode}"/>).
          </c:when>
          <c:otherwise>
            Le serveur n'a pas pu traiter cette requête.
          </c:otherwise>
        </c:choose>
      </p>
    </div>

    <c:if test="${not empty errorDetail}">
      <div class="alert alert-error">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"
             style="flex-shrink: 0; margin-top: 1px">
          <circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/>
        </svg>
        <span><code><c:out value="${errorDetail}"/></code></span>
      </div>
    </c:if>

    <%-- Tomcat dépose l'exception dans la requête : PageContext n'expose aucune
         propriété « exception » à l'EL, et l'EL ignore « .class » (propriété
         JavaBean inexistante) — expressions toutes deux refusées à la
         compilation de la JSP. toString() donne « classe : message ». --%>
    <c:set var="thrown" value="${requestScope['javax.servlet.error.exception']}"/>
    <c:if test="${not empty thrown}">
      <div class="card stack">
        <p class="eyebrow">Détail technique</p>
        <p class="hint" style="word-break: break-word">
          <c:out value="${thrown}"/>
        </p>
      </div>
    </c:if>

    <div class="row" style="justify-content: center">
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/">Retour à l'accueil</a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/workers">Voir les ouvriers</a>
    </div>
    <p class="center muted" style="font-size: 0.85rem">
      Le problème persiste ? Écrivez à <strong>support@azo.bj</strong>.
    </p>
  </div>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
