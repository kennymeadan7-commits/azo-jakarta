<%-- Fiche d'un ouvrier : reçoit ${worker} depuis WorkerDetailServlet. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="workers"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><c:out value="${worker.name}"/> — Azɔ</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="section container-page">
  <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/workers"
     style="margin-bottom: 1.5rem">
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
         stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>
    </svg>
    Retour à la liste
  </a>

  <div class="grid-2" style="grid-template-columns: 1.6fr 1fr; align-items: start">
    <article class="panel stack">
      <div class="row" style="gap: 0.5rem">
        <c:if test="${worker.verified}">
          <span class="pill pill-green">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z"/>
              <path d="m9 12 2 2 4-4"/>
            </svg>
            Profil vérifié
          </span>
        </c:if>
        <span class="pill pill-sand"><c:out value="${worker.trade}"/></span>
        <c:if test="${worker.available}">
          <span class="pill pill-gold">Disponible</span>
        </c:if>
        <c:if test="${!worker.available}">
          <span class="pill pill-danger">Indisponible</span>
        </c:if>
      </div>

      <div>
        <h1 class="section-title"><c:out value="${worker.name}"/></h1>
        <p class="lead" style="margin-top: 0.5rem"><c:out value="${worker.headline}"/></p>
      </div>

      <div class="row" style="gap: 1.5rem">
        <span class="row" style="gap: 0.35rem" title="${worker.ratingAvg} sur 5">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="var(--gold-500)" stroke="var(--gold-600)"
               stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
          </svg>
          <strong class="tabular"><fmt:formatNumber value="${worker.ratingAvg}" maxFractionDigits="1"/></strong>
          <span class="muted tabular">/ 5 · <c:out value="${worker.ratingCount}"/> avis</span>
        </span>
        <span class="muted tabular"><c:out value="${worker.completedJobs}"/> missions terminées</span>
        <span class="muted tabular"><c:out value="${worker.experience}"/> ans d'expérience</span>
      </div>

      <div class="hairline" style="border-top: 1px solid var(--sand-200); padding-top: 1.25rem">
        <p class="eyebrow" style="margin-bottom: 0.5rem">À propos</p>
        <p style="color: var(--ink-soft)"><c:out value="${worker.bio}"/></p>
      </div>

      <div class="grid-3" style="gap: 1rem">
        <div class="card" style="padding: 1rem 1.15rem">
          <p class="eyebrow">Tarif journalier</p>
          <p class="stat tabular" style="font-size: 1.5rem; margin-top: 0.35rem">
            <fmt:formatNumber value="${worker.dailyRate}" type="number"/> F CFA
          </p>
        </div>
        <div class="card" style="padding: 1rem 1.15rem">
          <p class="eyebrow">Ville</p>
          <p style="font-weight: 700; margin-top: 0.35rem">
            <c:out value="${worker.city}"/><c:if test="${not empty worker.district}"> — <c:out value="${worker.district}"/></c:if>
          </p>
        </div>
        <div class="card" style="padding: 1rem 1.15rem">
          <p class="eyebrow">Membre depuis</p>
          <p style="font-weight: 700; margin-top: 0.35rem" class="tabular">
            <fmt:formatDate value="${worker.createdAtDate}" pattern="MMMM yyyy" type="date"/>
          </p>
        </div>
      </div>
    </article>

    <aside class="stack">
      <div class="dark-panel pattern-grid">
        <div class="stack" style="padding: 1.5rem">
          <p class="eyebrow" style="color: var(--gold-400)">Contacter</p>
          <p style="font-family: var(--font-display); font-size: 1.35rem; font-weight: 700">
            <c:out value="${worker.name}"/>
          </p>
          <p style="color: #b9c9c1; font-size: 0.9rem"><c:out value="${worker.phone}"/></p>
          <a class="btn btn-primary" href="tel:${worker.phone}" style="justify-self: start">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>
            </svg>
            Appeler
          </a>
          <c:if test="${not empty worker.whatsapp}">
            <a class="btn btn-secondary" href="https://wa.me/${worker.whatsapp}"
               style="justify-self: start" rel="noopener noreferrer" target="_blank">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                   stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d="M7.9 20A9 9 0 1 0 4 16.1L2 22Z"/>
              </svg>
              WhatsApp
            </a>
          </c:if>
        </div>
      </div>

      <div class="card stack">
        <p class="eyebrow">Données de la fiche</p>
        <p class="hint">
          Cette page est rendue par <code>WorkerDetailServlet</code>, qui exécute une
          requête paramétrée (<code>PreparedStatement</code>) sur les tables
          <code>WorkerProfile</code> et <code>User</code>.
        </p>
        <div class="table-wrap">
          <table class="data">
            <tbody>
              <tr><th scope="row">Identifiant</th><td class="tabular"><code><c:out value="${worker.id}"/></code></td></tr>
              <tr><th scope="row">Métier</th><td><c:out value="${worker.trade}"/></td></tr>
              <tr><th scope="row">E-mail</th><td><c:out value="${worker.email}"/></td></tr>
              <tr><th scope="row">Note moyenne</th><td class="tabular"><fmt:formatNumber value="${worker.ratingAvg}" maxFractionDigits="2"/></td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </aside>
  </div>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
