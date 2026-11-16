<%-- Vue « Métiers » : agrégation GROUP BY "trade" reçue de MetiersServlet. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="metiers"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Nos métiers — Azɔ</title>
  <meta name="description" content="Plomberie, électricité, maçonnerie, ménage, climatisation : les métiers couverts par Azɔ au Bénin, avec le nombre d'ouvriers et les tarifs indicatifs.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="section container-page">
  <div class="between" style="margin-bottom: 2rem">
    <div class="stack">
      <span class="eyebrow">Domaines d'intervention</span>
      <h1 class="section-title">Nos métiers</h1>
      <p class="lead">
        Chaque métier regroupe des profils vérifiés, notés après mission.
        Les tarifs indiqués sont les plus bas pratiqués dans le domaine.
      </p>
    </div>
    <span class="pill pill-sand tabular">
      <c:out value="${global.count}"/> ouvrier(s)
    </span>
  </div>

  <c:choose>
    <c:when test="${empty trades}">
      <div class="panel center stack">
        <p class="section-title" style="font-size: 1.35rem">Aucun métier enregistré</p>
        <p class="muted">Aucun profil d'ouvrier n'est encore présent dans l'annuaire.</p>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/workers"
           style="justify-self: center">Voir les ouvriers</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid-3">
        <c:forEach var="t" items="${trades}">
          <article class="card card-hover stack">
            <div class="between">
              <span class="icon-tile-lg" aria-hidden="true">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
                </svg>
              </span>
              <span class="pill pill-gold tabular">
                <c:out value="${t.count}"/> ouvrier(s)
              </span>
            </div>

            <div class="stack" style="gap: 0.35rem">
              <h2 style="font-size: 1.15rem; font-weight: 700; text-transform: capitalize">
                <c:out value="${t.label}"/>
              </h2>
              <p class="muted" style="font-size: 0.9rem">
                Note moyenne de
                <strong class="tabular"><fmt:formatNumber value="${t.avgRating}" maxFractionDigits="1"/></strong>
                sur 5, à partir des avis déposés après mission.
              </p>
            </div>

            <div class="between hairline" style="padding-top: 0.9rem; border-top: 1px solid var(--sand-200)">
              <span class="row" style="gap: 0.35rem; font-size: 0.85rem">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="var(--gold-500)" stroke="var(--gold-600)"
                     stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                </svg>
                <strong class="tabular"><fmt:formatNumber value="${t.avgRating}" maxFractionDigits="1"/></strong>
              </span>
              <span class="muted tabular" style="font-size: 0.85rem">
                dès <c:out value="${t.minRate}"/> F CFA / jour
              </span>
            </div>

            <a class="btn btn-outline"
               href="${pageContext.request.contextPath}/workers?trade=${t.label}">
              Voir les ouvriers
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
