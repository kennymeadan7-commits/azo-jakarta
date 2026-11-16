<%-- Vue « Villes » : agrégation GROUP BY "city" reçue de VillesServlet. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="villes"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Nos villes — Azɔ</title>
  <meta name="description" content="La couverture territoriale d'Azɔ au Bénin : Cotonou, Abomey-Calavi, Parakou, Bohicon et les villes où des artisans vérifiés sont disponibles.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="section container-page">
  <div class="between" style="margin-bottom: 2rem">
    <div class="stack">
      <span class="eyebrow">Couverture territoriale</span>
      <h1 class="section-title">Nos villes</h1>
      <p class="lead">
        Des artisans vérifiés interviennent dans <c:out value="${cityCount}"/> ville(s)
        du Bénin. Sélectionnez une ville pour filtrer l'annuaire.
      </p>
    </div>
    <span class="pill pill-sand tabular">
      <c:out value="${global.count}"/> ouvrier(s)
    </span>
  </div>

  <c:choose>
    <c:when test="${empty cities}">
      <div class="panel center stack">
        <p class="section-title" style="font-size: 1.35rem">Aucune ville enregistrée</p>
        <p class="muted">Aucun profil d'ouvrier n'est encore présent dans l'annuaire.</p>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/workers"
           style="justify-self: center">Voir les ouvriers</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid-3">
        <c:forEach var="v" items="${cities}">
          <article class="card card-hover stack">
            <div class="between">
              <span class="icon-tile" aria-hidden="true">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0"/>
                  <circle cx="12" cy="10" r="3"/>
                </svg>
              </span>
              <span class="pill pill-green tabular">
                <c:out value="${v.count}"/> profil(s)
              </span>
            </div>

            <div class="stack" style="gap: 0.35rem">
              <h2 style="font-size: 1.15rem; font-weight: 700">
                <c:out value="${v.label}"/>
              </h2>
              <p class="muted" style="font-size: 0.9rem">
                Note moyenne
                <strong class="tabular"><fmt:formatNumber value="${v.avgRating}" maxFractionDigits="1"/></strong>
                sur 5 · tarif journalier dès
                <strong class="tabular"><c:out value="${v.minRate}"/> F CFA</strong>.
              </p>
            </div>

            <a class="btn btn-outline"
               href="${pageContext.request.contextPath}/workers?city=${v.label}">
              Voir les artisans
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
