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
import jakarta.servlet.http.HttpSession;

/**
 * Recopie l'identité JAAS (principalement {@code request.getRemoteUser()}) dans la
 * session HTTP, pour que les JSP puissent afficher le nom et le rôle sans recharger
 * la base à chaque requête.
 *
 * <p>Pourquoi un filtre ? {@code JAASRealm} renvoie un {@code GenericPrincipal} générique
 * de Tomcat : on ne peut pas y accéder à nos métadonnées métier (rôle, ville…). En
 * revanche {@code getName()} du principal correspond à l'e-mail, ce qui suffit pour
 * recharger l'utilisateur via {@link bj.azo.dao.UserDao} une seule fois par session.</p>
 */
public class UserSetupFilter implements Filter {

    /** Clé de session contenant le {@link bj.azo.model.User} connecté. */
    public static final String SESSION_USER = "currentUser";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Rien à initialiser.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(true);

        String remoteUser = req.getRemoteUser();
        if (remoteUser == null) {
            // Déconnecté (ou session expirée) : on purge l'éventuel reste de session.
            session.removeAttribute(SESSION_USER);
            session.removeAttribute("role");
        } else if (session.getAttribute(SESSION_USER) == null) {
            try {
                bj.azo.model.User user = new bj.azo.dao.UserDao().findByEmail(remoteUser);
                if (user != null) {
                    session.setAttribute(SESSION_USER, user);
                    session.setAttribute("role", user.getRole());
                }
            } catch (java.sql.SQLException e) {
                request.getServletContext().log(
                        "Impossible de charger l'utilisateur " + remoteUser, e);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Rien à libérer.
    }
}
