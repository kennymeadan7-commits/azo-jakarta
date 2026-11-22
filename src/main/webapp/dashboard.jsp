<%-- Tableau de bord : page PROTÉGÉE par <security-constraint> (FORM + JAAS). --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="dashboard"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tableau de bord — Azɔ</title>
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261122">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="section container-page">
  <div class="between" style="margin-bottom: 2rem">
    <div class="stack">
      <span class="eyebrow">Espace personnel</span>
      <h1 class="section-title">Bonjour, <c:out value="${user.name}"/></h1>
      <p class="lead">
        <c:choose>
          <c:when test="${user.role eq 'WORKER'}">
            Vos chantiers, vos devis et votre réputation en un coup d'œil.
          </c:when>
          <c:when test="${user.role eq 'ADMIN'}">
            Activité de la plateforme, comptes et missions en cours.
          </c:when>
          <c:otherwise>
            Vos demandes de service et les réponses des artisans vérifiés.
          </c:otherwise>
        </c:choose>
      </p>
    </div>
    <div class="row" style="gap: 0.6rem">
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/mes-missions">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
          <polyline points="14 2 14 8 20 8"/>
        </svg>
        Mes missions
      </a>
      <a class="btn btn-ghost" href="${pageContext.request.contextPath}/logout">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
          <polyline points="16 17 21 12 16 7"/>
          <line x1="21" x2="9" y1="12" y2="12"/>
        </svg>
        Déconnexion
      </a>
    </div>
  </div>

  <div class="grid-3" style="margin-bottom: 2rem">
    <div class="card stack">
      <span class="icon-tile-gold" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
        </svg>
      </span>
      <p class="eyebrow">Missions en cours</p>
      <p class="stat tabular"><c:out value="${openCount}"/></p>
      <p class="muted" style="font-size: 0.85rem">en attente, en devis ou réalisées</p>
    </div>

    <div class="card stack">
      <span class="icon-tile" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <path d="m9 11 3 3L22 4"/>
        </svg>
      </span>
      <p class="eyebrow">Missions terminées</p>
      <p class="stat tabular"><c:out value="${doneCount}"/></p>
      <p class="muted" style="font-size: 0.85rem">devis acceptés et soldés</p>
    </div>

    <div class="card stack">
      <span class="icon-tile" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" x2="12" y1="2" y2="22"/>
          <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
        </svg>
      </span>
      <p class="eyebrow">Montant terminé</p>
      <p class="stat tabular" style="font-size: 1.6rem">
        <fmt:formatNumber value="${revenue}" type="number"/> F CFA
      </p>
      <p class="muted" style="font-size: 0.85rem">cumul des missions soldées</p>
    </div>
  </div>

  <div class="grid-2" style="align-items: start">
    <section class="panel stack">
      <div class="between">
        <span class="eyebrow">Activité récente</span>
        <div class="row" style="gap: 0.5rem">
          <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/rapports/missions"
             title="Télécharger le rapport des missions au format PDF">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
              <polyline points="7 10 12 15 17 10"/>
              <line x1="12" x2="12" y1="15" y2="3"/>
            </svg>
            PDF
          </a>
          <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/mes-missions">
            Tout voir
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>
            </svg>
          </a>
        </div>
      </div>

      <c:choose>
        <c:when test="${empty missions}">
          <div class="center stack" style="padding: 1.5rem 0">
            <p class="muted">Aucune mission enregistrée pour l'instant.</p>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/workers"
               style="justify-self: center">Trouver un artisan</a>
          </div>
        </c:when>
        <c:otherwise>
          <div class="table-wrap">
            <table class="data">
              <thead>
                <tr>
                  <th scope="col">Mission</th>
                  <th scope="col">Ville</th>
                  <th scope="col">Statut</th>
                  <th scope="col" style="text-align: right">Montant</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="m" items="${missions}">
                  <tr>
                    <td>
                      <strong style="font-weight: 600"><c:out value="${m.title}"/></strong>
                      <br>
                      <span class="muted" style="font-size: 0.8rem; text-transform: capitalize">
                        <c:out value="${m.trade}"/>
                      </span>
                    </td>
                    <td><c:out value="${m.city}"/></td>
                    <td>
                      <span class="pill ${m.statusPill}">
                        <c:out value="${m.statusLabel}"/>
                      </span>
                    </td>
                    <td class="tabular" style="text-align: right; white-space: nowrap">
                      <c:choose>
                        <c:when test="${not empty m.amount}">
                          <fmt:formatNumber value="${m.amount}" type="number"/> F CFA
                        </c:when>
                        <c:otherwise><span class="muted">—</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:otherwise>
      </c:choose>
    </section>

    <div class="stack">
      <section class="panel stack">
        <span class="eyebrow">Votre compte</span>
        <h2 class="section-title" style="font-size: 1.4rem">Informations</h2>
        <div class="table-wrap">
          <table class="data">
            <tbody>
              <tr><th scope="row">Nom</th><td><c:out value="${user.name}"/></td></tr>
              <tr><th scope="row">E-mail</th><td><c:out value="${user.email}"/></td></tr>
              <tr><th scope="row">Téléphone</th><td class="tabular"><c:out value="${user.phone}"/></td></tr>
              <tr><th scope="row">Ville</th><td><c:out value="${user.city}"/></td></tr>
              <tr>
                <th scope="row">Rôle</th>
                <td>
                  <span class="pill pill-gold"><c:out value="${user.role}"/></span>
                </td>
              </tr>
              <tr>
                <th scope="row">Compte</th>
                <td>
                  <c:choose>
                    <c:when test="${user.suspended}"><span class="pill pill-danger">Suspendu</span></c:when>
                    <c:otherwise><span class="pill pill-green">Actif</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section class="panel stack">
        <div class="between">
          <span class="eyebrow">Annuaire</span>
          <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/rapports/annuaire"
             title="Télécharger l'annuaire des artisans au format PDF">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
              <polyline points="7 10 12 15 17 10"/>
              <line x1="12" x2="12" y1="15" y2="3"/>
            </svg>
            PDF
          </a>
        </div>
        <h2 class="section-title" style="font-size: 1.4rem">Azɔ en bref</h2>
        <div class="row" style="gap: 2rem">
          <div>
            <p class="stat" style="font-size: 1.5rem">
              <c:choose>
                <c:when test="${empty workerCount}">—</c:when>
                <c:otherwise><c:out value="${workerCount}"/></c:otherwise>
              </c:choose>
            </p>
            <p class="muted" style="font-size: 0.85rem">ouvriers vérifiés</p>
          </div>
          <div>
            <p class="stat" style="font-size: 1.5rem">
              <c:choose>
                <c:when test="${empty cityCount}">—</c:when>
                <c:otherwise><c:out value="${cityCount}"/></c:otherwise>
              </c:choose>
            </p>
            <p class="muted" style="font-size: 0.85rem">villes couvertes</p>
          </div>
          <div>
            <p class="stat" style="font-size: 1.5rem">
              <c:choose>
                <c:when test="${empty avgRating}">—</c:when>
                <c:otherwise>
                  <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
                </c:otherwise>
              </c:choose>
            </p>
            <p class="muted" style="font-size: 0.85rem">note moyenne</p>
          </div>
        </div>
        <div class="alert alert-info">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"
               style="flex-shrink: 0; margin-top: 1px">
            <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
            <path d="m9 12 2 2 4-4"/>
          </svg>
          <span>
            Session sécurisée : identité confirmée par
            <c:out value="${pageContext.request.authType}"/> sous l'identifiant
            <strong><c:out value="${remoteUser}"/></strong>.
          </span>
        </div>
      </section>
    </div>
  </div>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
