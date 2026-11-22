<%-- Vue d'accueil : 100 % HTML + EL. Les statistiques proviennent du contrôleur
     StatsFragmentServlet (JDBC), inclus ci-dessous. Aucun scriptlet. --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="home"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Azɔ — Les artisans du Bénin, vérifiés et disponibles</title>
  <meta name="description" content="Azɔ met en relation les particuliers et les entreprises du Bénin avec des artisans vérifiés : plomberie, électricité, maçonnerie, ménage.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261122">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu">
  <section class="hero">
    <div class="container-page hero-inner">
      <div class="stack">
        <span class="eyebrow">Bénin · Services à domicile</span>
        <h1>Le bon artisan,<br>vérifié près de chez vous.</h1>
        <p class="lead">
          Azɔ rassemble les travailleurs indépendants du pays — plombiers, électriciens,
          maçons, équipes de ménage — avec des profils vérifiés, des notes réelles et
          des tarifs affichés en FCFA.
        </p>

        <div class="row">
          <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/workers">
            Voir les ouvriers
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>
            </svg>
          </a>
          <a class="btn btn-secondary btn-lg" href="${pageContext.request.contextPath}/login.jsp">
            Espace connecté
          </a>
        </div>

        <jsp:include page="/fragments/stats"/>
      </div>

      <div class="hero-showcase pattern-grid">
        <p class="eyebrow" style="color: var(--gold-400)">Profil du moment</p>
        <p style="font-family: var(--font-display); font-size: 1.5rem; font-weight: 700; margin-top: 0.5rem">
          Jean Kpogli — Plombier
        </p>
        <p style="color: #b9c9c1; font-size: 0.92rem; margin-top: 0.5rem">
          « Douze ans d'expérience sur les canalisations et sanitaires du Grand Cotonou.
          Intervention le jour même sur les urgences, devis gratuit. »
        </p>

        <div class="row" style="margin-top: 1.25rem; gap: 0.5rem">
          <span class="pill pill-gold">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <path d="M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z"/>
              <path d="m9 12 2 2 4-4"/>
            </svg>
            Profil vérifié
          </span>
          <span class="pill pill-sand">Fidjrossè, Cotonou</span>
          <span class="pill pill-sand">15 000 F CFA / jour</span>
        </div>

        <div class="hairline" style="margin-top: 1.5rem; border-color: rgba(255,255,255,0.14)"></div>
        <p style="margin-top: 1rem; font-size: 0.8rem; color: #94a89f">
          Note de 4,8 sur 5 après 27 missions réalisées.
        </p>
      </div>
    </div>
  </section>

  <section class="section container-page">
    <div class="center stack" style="margin-bottom: 2.5rem">
      <span class="eyebrow">Nos métiers</span>
      <h2 class="section-title">Un savoir-faire pour chaque besoin</h2>
      <p class="lead" style="max-width: 56ch">
        Filtrez l'annuaire par métier : chaque fiche indique le tarif journalier,
        l'expérience et les notes laissées après mission.
      </p>
    </div>

    <div class="grid-3">
      <article class="card card-hover stack">
        <span class="icon-tile-lg" aria-hidden="true">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
          </svg>
        </span>
        <h3 style="font-size: 1.1rem; font-weight: 700">Plomberie &amp; sanitaire</h3>
        <p class="muted" style="font-size: 0.92rem">
          Fuites, canalisations, ballons d'eau chaude : intervention rapide
          sur les urgences du Grand Cotonou.
        </p>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/workers?trade=plomberie">
          Voir les plombiers
        </a>
      </article>

      <article class="card card-hover stack">
        <span class="icon-tile-gold" aria-hidden="true">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z"/>
          </svg>
        </span>
        <h3 style="font-size: 1.1rem; font-weight: 700">Électricité</h3>
        <p class="muted" style="font-size: 0.92rem">
          Mise aux normes, tableaux, groupes électrogènes : des professionnels
          certifiés pour particuliers et entreprises.
        </p>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/workers?trade=electricite">
          Voir les électriciens
        </a>
      </article>

      <article class="card card-hover stack">
        <span class="icon-tile" aria-hidden="true">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M2.97 12.92A2 2 0 0 0 2 14.63v3.24a2 2 0 0 0 .97 1.71l3 1.8a2 2 0 0 0 2.06 0L12 19v-5.5l-5-3-4.03 2.42Z"/>
            <path d="m7 17-4.74-2.85"/><path d="M17 17l4.74-2.85"/>
            <path d="M12 18V4l6 3.61"/>
          </svg>
        </span>
        <h3 style="font-size: 1.1rem; font-weight: 700">Maçonnerie</h3>
        <p class="muted" style="font-size: 0.92rem">
          Cloisons, enduits, dallage : des maçons expérimentés pour vos
          travaux neufs et de rénovation.
        </p>
        <a class="btn btn-outline" href="${pageContext.request.contextPath}/workers?trade=maconnerie">
          Voir les maçons
        </a>
      </article>
    </div>

    <div class="center" style="margin-top: 2rem">
      <a class="btn btn-secondary btn-lg" href="${pageContext.request.contextPath}/metiers">
        Tous les métiers
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>
        </svg>
      </a>
    </div>
  </section>

  <section class="section container-page">
    <div class="center stack" style="margin-bottom: 2.5rem">
      <span class="eyebrow">Comment ça marche</span>
      <h2 class="section-title">Trois étapes, sans détour</h2>
    </div>

    <div class="grid-3">
      <article class="card card-hover stack">
        <span class="icon-tile-lg">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M22 21v-2a4 4 0 0 0-3-3.87"/>
            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
          </svg>
        </span>
        <h3 style="font-size: 1.1rem; font-weight: 700">1. Cherchez un métier</h3>
        <p class="muted" style="font-size: 0.92rem">
          Filtrez par métier et par ville. Chaque fiche affiche le tarif journalier,
          l'expérience et les notes laissées après mission.
        </p>
      </article>

      <article class="card card-hover stack">
        <span class="icon-tile-gold">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
            <path d="m9 12 2 2 4-4"/>
          </svg>
        </span>
        <h3 style="font-size: 1.1rem; font-weight: 700">2. Contactez directement</h3>
        <p class="muted" style="font-size: 0.92rem">
          WhatsApp ou appel, sans intermédiaire. Les profils vérifiés ont fourni
          une pièce d'identité et des références de chantier.
        </p>
      </article>

      <article class="card card-hover stack">
        <span class="icon-tile">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
          </svg>
        </span>
        <h3 style="font-size: 1.1rem; font-weight: 700">3. Faites le travail</h3>
        <p class="muted" style="font-size: 0.92rem">
          Une fois la mission terminée, les deux parties se notent. Les notes
          alimentent le classement de la liste des ouvriers.
        </p>
      </article>
    </div>
  </section>

  <section class="section container-page">
    <div class="dark-panel pattern-grid">
      <div class="stack" style="padding: clamp(1.75rem, 5vw, 3.5rem); max-width: 60ch">
        <span class="eyebrow" style="color: var(--gold-400)">Particuliers &amp; entreprises</span>
        <h2 class="section-title" style="color: #fff">
          Confiez vos travaux à un artisan vérifié
        </h2>
        <p style="color: #c6d5ce">
          Décrivez votre besoin, recevez un devis sous 48 heures et suivez
          l'avancement de votre mission jusqu'au règlement. Un accompagnement
          Azɔ en cas de litige.
        </p>
        <div class="row">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/workers">
            Trouver un artisan
          </a>
          <a class="btn btn-secondary" href="${pageContext.request.contextPath}/login.jsp">
            Créer un compte
          </a>
        </div>
      </div>
    </div>
  </section>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
