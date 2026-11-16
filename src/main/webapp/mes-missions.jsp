<%-- Vue « Mes missions » : page PROTÉGÉE, lignes selon le rôle du connecté. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="missions"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Mes missions — Azɔ</title>
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="section container-page">
  <div class="between" style="margin-bottom: 2rem">
    <div class="stack">
      <span class="eyebrow">
        <c:choose>
          <c:when test="${user.role eq 'WORKER'}">Espace ouvrier</c:when>
          <c:otherwise>Espace client</c:otherwise>
        </c:choose>
      </span>
      <h1 class="section-title">Mes missions</h1>
      <p class="lead">
        <c:choose>
          <c:when test="${user.role eq 'WORKER'}">
            Les chantiers qui vous sont confiés, de la demande au règlement.
          </c:when>
          <c:otherwise>
            Vos demandes de service, du devis à la réalisation.
          </c:otherwise>
        </c:choose>
      </p>
    </div>
    <div class="row" style="gap: 0.6rem">
      <a class="btn btn-outline" href="${pageContext.request.contextPath}/rapports/missions"
         title="Télécharger mes missions au format PDF">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
          <polyline points="7 10 12 15 17 10"/>
          <line x1="12" x2="12" y1="15" y2="3"/>
        </svg>
        Rapport PDF
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/dashboard">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="m12 19-7-7 7-7"/><path d="M19 12H5"/>
        </svg>
        Tableau de bord
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
      <p class="eyebrow">En cours</p>
      <p class="stat tabular"><c:out value="${openCount}"/></p>
      <p class="muted" style="font-size: 0.85rem">en attente, en devis ou acceptées</p>
    </div>

    <div class="card stack">
      <span class="icon-tile" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <path d="m9 11 3 3L22 4"/>
        </svg>
      </span>
      <p class="eyebrow">Terminées</p>
      <p class="stat tabular"><c:out value="${doneCount}"/></p>
      <p class="muted" style="font-size: 0.85rem">missions soldées et notées</p>
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
      <p class="muted" style="font-size: 0.85rem">somme des devis acceptés</p>
    </div>
  </div>

  <c:choose>
    <c:when test="${empty missions}">
      <div class="panel center stack">
        <span class="icon-tile-lg" aria-hidden="true" style="justify-self: center">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
            <polyline points="14 2 14 8 20 8"/>
          </svg>
        </span>
        <p class="section-title" style="font-size: 1.35rem">Aucune mission pour le moment</p>
        <p class="muted" style="max-width: 46ch">
          <c:choose>
            <c:when test="${user.role eq 'WORKER'}">
              Vous apparaîtrez dans l'annuaire dès votre première mission acceptée.
              En attendant, consultez votre fiche profil.
            </c:when>
            <c:otherwise>
              Publiez votre première demande depuis le tableau de bord : un artisan
              vérifié vous envoie un devis sous 48 heures.
            </c:otherwise>
          </c:choose>
        </p>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/workers"
           style="justify-self: center">Parcourir l'annuaire</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="panel stack">
        <div class="between">
          <span class="eyebrow">Historique</span>
          <span class="pill pill-sand tabular"><c:out value="${missionCount}"/> mission(s)</span>
        </div>
        <div class="table-wrap">
          <table class="data">
            <thead>
              <tr>
                <th scope="col">Mission</th>
                <th scope="col">Métier</th>
                <th scope="col">Ville</th>
                <th scope="col">
                  <c:choose>
                    <c:when test="${user.role eq 'WORKER'}">Client</c:when>
                    <c:otherwise>Ouvrier</c:otherwise>
                  </c:choose>
                </th>
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
                    <span class="muted" style="font-size: 0.8rem">
                      demandée le
                      <fmt:formatDate value="${m.createdDate}" dateStyle="short"/>
                    </span>
                  </td>
                  <td style="text-transform: capitalize"><c:out value="${m.trade}"/></td>
                  <td>
                    <c:out value="${m.city}"/>
                    <c:if test="${not empty m.district}">
                      <span class="muted">· <c:out value="${m.district}"/></span>
                    </c:if>
                  </td>
                  <td><c:out value="${user.role eq 'WORKER' ? m.clientName : m.workerName}"/></td>
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
      </div>
    </c:otherwise>
  </c:choose>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
