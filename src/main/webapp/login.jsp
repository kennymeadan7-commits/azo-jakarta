<%-- Page de connexion : le formulaire est traité par Tomcat (j_security_check). --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="login"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Connexion — Azɔ</title>
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/jspf/header.jsp"/>

<main id="contenu" class="auth-shell container-page">
  <div class="auth-card stack">
    <div class="center stack">
      <span class="icon-tile-lg" aria-hidden="true" style="justify-self: center">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"/>
          <path d="m9 12 2 2 4-4"/>
        </svg>
      </span>
      <h1 class="section-title">Connexion</h1>
      <p class="muted" style="font-size: 0.92rem">
        Accédez à votre espace personnel Azɔ.
      </p>
    </div>

    <div class="panel">
      <%-- Noms imposés par la spécification Servlet pour l'authentification FORM. --%>
      <form class="form-grid" method="post"
            action="${pageContext.request.contextPath}/j_security_check"
            autocomplete="on">
        <div>
          <label class="label" for="j_username">Adresse e-mail</label>
          <input class="field" type="email" id="j_username" name="j_username"
                 placeholder="vous@exemple.bj" required autofocus
                 autocomplete="username">
        </div>

        <div>
          <label class="label" for="j_password">Mot de passe</label>
          <input class="field" type="password" id="j_password" name="j_password"
                 placeholder="Votre mot de passe" required
                 autocomplete="current-password">
        </div>

        <button class="btn btn-primary btn-lg" type="submit">
          Se connecter
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
               stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
            <polyline points="10 17 15 12 10 7"/>
            <line x1="15" x2="3" y1="12" y2="12"/>
          </svg>
        </button>
      </form>

      <p class="hint" style="margin-top: 1rem">
        Vos identifiants sont vérifiés côté serveur. En cas d'oubli,
        contactez le support Azɔ à <strong>support@azo.bj</strong>.
      </p>
    </div>

    <details class="panel" style="padding: 0.9rem 1.1rem">
      <summary style="cursor: pointer; font-size: 0.85rem; font-weight: 600">
        Comptes de pré-configuration
      </summary>
      <ul class="demo-list" style="margin-top: 0.75rem">
        <li>Administrateur — <code>admin@azo.bj</code> / <code>demo1234</code></li>
        <li>Client — <code>client@azo.bj</code> / <code>demo1234</code></li>
        <li>Ouvrier — <code>ouvrier@azo.bj</code> / <code>demo1234</code></li>
      </ul>
    </details>

    <p class="center muted" style="font-size: 0.85rem">
      <a href="${pageContext.request.contextPath}/">Retour à l'accueil</a>
    </p>
  </div>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
