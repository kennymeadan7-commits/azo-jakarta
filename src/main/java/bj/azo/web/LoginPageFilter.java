package bj.azo.web;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Garantit que la page de connexion est toujours atteinte <b>à travers une ressource
 * protégée</b>, comme l'exige l'authentification FORM de la spécification Servlet.
 *
 * <p><b>Pourquoi ce filtre ?</b> Lorsqu'un internaute demande une page protégée
 * ({@code /dashboard}) sans session valide, Tomcat enregistre la requête d'origine,
 * change l'identifiant de session (protection contre la fixation de session) et
 * forward vers {@code /login.jsp}. C'est précisément cette séquence qui pose la note
 * interne {@code org.apache.catalina.authenticator.SESSION_ID} attendue au moment du
 * POST sur {@code j_security_check}.</p>
 *
 * <p>Si l'internaute charge {@code /login.jsp} <b>directement</b> (lien du menu,
 * favori, saisie d'URL), cette séquence n'a pas lieu : la session est jugée expirée et
 * Tomcat répond <b>408</b> (« le temps alloué au processus de login est échu ») au
 * moment de la validation du formulaire.</p>
 *
 * <p>Le filtre redirige donc toute requête <b>GET directe</b> vers {@code /dashboard},
 * ce qui déclenche la séquence normale puis un forward vers {@code /login.jsp}. Comme
 * ce filtre n'est déclaré que pour le dispatcher {@code REQUEST} (valeur par défaut),
 * le forward renvoyé par Tomcat ne le ré-exécute pas : aucune boucle n'est possible.</p>
 */
public class LoginPageFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Rien à initialiser.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        if ("GET".equalsIgnoreCase(req.getMethod())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Rien à libérer.
    }
}
