<%-- Vue « Nos ouvriers » : reçoit ${workers} depuis WorkersServlet. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="workers"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Nos ouvriers — Azɔ</title>
  <meta name="description" content="Liste des artisans et travailleurs indépendants enregistrés sur Azɔ, classés par note.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261122">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="section container-page">
  <div class="between" style="margin-bottom: 2rem">
    <div class="stack">
      <span class="eyebrow">Annuaire</span>
      <h1 class="section-title">Nos ouvriers</h1>
      <p class="lead">
        <c:choose>
          <c:when test="${not empty selectedCity}">
            Ouvriers disponibles à <strong><c:out value="${selectedCity}"/></strong>.
          </c:when>
          <c:when test="${empty selectedTrade}">
            Tous les profils, du mieux noté au moins bien noté.
          </c:when>
          <c:otherwise>
            Filtre actif sur le métier <strong><c:out value="${selectedTrade}"/></strong>.
          </c:otherwise>
        </c:choose>
      </p>
    </div>
    <span class="pill pill-sand tabular">
      <c:out value="${totalWorkers}"/> profil(s)
    </span>
  </div>

  <%-- Filtres par métier : requêtes paramétrées côté serveur. --%>
  <div class="row" style="margin-bottom: 2rem">
    <a class="btn btn-sm ${empty selectedTrade && empty selectedCity ? 'btn-dark' : 'btn-secondary'}"
       href="${pageContext.request.contextPath}/workers">Tous</a>
    <a class="btn btn-sm ${selectedTrade eq 'plomberie' ? 'btn-dark' : 'btn-secondary'}"
       href="${pageContext.request.contextPath}/workers?trade=plomberie">Plomberie</a>
    <a class="btn btn-sm ${selectedTrade eq 'electricite' ? 'btn-dark' : 'btn-secondary'}"
       href="${pageContext.request.contextPath}/workers?trade=electricite">Électricité</a>
    <a class="btn btn-sm ${selectedTrade eq 'maconnerie' ? 'btn-dark' : 'btn-secondary'}"
       href="${pageContext.request.contextPath}/workers?trade=maconnerie">Maçonnerie</a>
    <a class="btn btn-sm ${selectedTrade eq 'climatisation' ? 'btn-dark' : 'btn-secondary'}"
       href="${pageContext.request.contextPath}/workers?trade=climatisation">Climatisation</a>
    <a class="btn btn-sm ${selectedTrade eq 'menage' ? 'btn-dark' : 'btn-secondary'}"
       href="${pageContext.request.contextPath}/workers?trade=menage">Ménage</a>
  </div>

  <c:choose>
    <c:when test="${empty workers}">
      <div class="panel center stack">
        <p class="section-title" style="font-size: 1.35rem">Aucun ouvrier trouvé</p>
        <p class="muted">
          Aucun profil ne correspond à ce filtre. La table <code>WorkerProfile</code>
          est peut-être encore vide.
        </p>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/workers"
           style="justify-self: center">Voir tous les ouvriers</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid-3">
        <c:forEach var="w" items="${workers}">
          <article class="card card-hover stack">
            <div class="between" style="gap: 0.75rem">
              <span class="icon-tile-lg" aria-hidden="true">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
                </svg>
              </span>
              <div class="row" style="gap: 0.4rem; justify-content: flex-end">
                <c:if test="${w.verified}">
                  <span class="pill pill-green">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                      <path d="M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z"/>
                      <path d="m9 12 2 2 4-4"/>
                    </svg>
                    Vérifié
                  </span>
                </c:if>
                <c:if test="${!w.available}">
                  <span class="pill pill-danger">Indisponible</span>
                </c:if>
              </div>
            </div>

            <div class="stack" style="gap: 0.35rem">
              <h2 style="font-size: 1.1rem; font-weight: 700">
                <c:out value="${w.name}"/>
              </h2>
              <p class="muted" style="font-size: 0.9rem">
                <c:out value="${w.headline}"/>
              </p>
            </div>

            <div class="row" style="gap: 0.5rem">
              <span class="pill pill-sand">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0"/>
                  <circle cx="12" cy="10" r="3"/>
                </svg>
                <c:out value="${w.city}"/>
              </span>
              <span class="pill pill-gold tabular">
                <fmt:formatNumber value="${w.dailyRate}" type="number"/> F CFA
              </span>
            </div>

            <div class="between hairline" style="padding-top: 0.9rem; border-top: 1px solid var(--sand-200)">
              <span class="row" style="gap: 0.35rem; font-size: 0.85rem" title="${w.ratingAvg} sur 5">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="var(--gold-500)" stroke="var(--gold-600)"
                     stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                </svg>
                <strong class="tabular"><fmt:formatNumber value="${w.ratingAvg}" maxFractionDigits="1"/></strong>
                <span class="muted tabular">(<c:out value="${w.ratingCount}"/>)</span>
              </span>
              <span class="muted tabular" style="font-size: 0.85rem">
                <c:out value="${w.completedJobs}"/> missions
              </span>
            </div>

            <a class="btn btn-outline"
               href="${pageContext.request.contextPath}/worker?id=${w.id}">
              Voir la fiche
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                   stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>
              </svg>
            </a>
          </article>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
