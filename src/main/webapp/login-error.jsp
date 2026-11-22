<%-- Affichée par Tomcat après un échec de j_security_check (form-error-page). --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<c:set var="navPage" value="login"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Échec de connexion — Azɔ</title>
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261122">
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
      <h1 class="section-title">Connexion refusée</h1>
      <p class="muted" style="font-size: 0.95rem; max-width: 42ch">
        Ces identifiants ne correspondent à aucun compte actif.
        Vérifiez votre adresse e-mail et votre mot de passe.
      </p>
    </div>

    <div class="alert alert-error">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"
           style="flex-shrink: 0; margin-top: 1px">
        <circle cx="12" cy="12" r="10"/><path d="M12 8v4"/><path d="M12 16h.01"/>
      </svg>
      <span>Échec de l'authentification. Compte inconnu, mot de passe incorrect ou compte suspendu.</span>
    </div>

    <div class="panel">
      <form class="form-grid" method="post"
            action="${pageContext.request.contextPath}/j_security_check">
        <div>
          <label class="label" for="j_username">Adresse e-mail</label>
          <input class="field" type="email" id="j_username" name="j_username"
                 placeholder="vous@exemple.bj" required autofocus autocomplete="username">
        </div>
        <div>
          <label class="label" for="j_password">Mot de passe</label>
          <input class="field" type="password" id="j_password" name="j_password"
                 required autocomplete="current-password">
        </div>
        <button class="btn btn-primary" type="submit">Réessayer</button>
      </form>
    </div>

    <p class="center muted" style="font-size: 0.85rem">
      Mot de passe oublié ? Écrivez à <strong>support@azo.bj</strong>
      · <a href="${pageContext.request.contextPath}/login.jsp">Retour au formulaire</a>
    </p>
  </div>
</main>

<jsp:include page="/WEB-INF/jspf/footer.jsp"/>
</body>
</html>
