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
 * En-têtes de cache des ressources statiques (CSS, JS, images).
 *
 * <p>Sans {@code Cache-Control}, le navigateur utilise un cache <b>heuristique</b>
 * (10 % de l'âge du fichier d'après {@code Last-Modified}) : les styles peuvent
 * rester périmés plusieurs heures après une mise à jour, et chaque visite
 * revalide le fichier au serveur. Ici le navigateur réutilise le fichier pendant
 * 24 h sans aucun aller-retour.</p>
 *
 * <p>La version est portée par l'URL ({@code style.css?v=AAAAJJMM}) : toute
 * modification du thème s'accompagne d'un bump de version, ce qui force le
 * rechargement tout en gardant un cache long pour le reste du temps.</p>
 */
public class StaticCacheFilter implements Filter {

    /** Cache public de 24 heures pour les ressources statiques. */
    private static final String CACHE_CONTROL = "public, max-age=86400";

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        if ("GET".equalsIgnoreCase(req.getMethod())) {
            res.setHeader("Cache-Control", CACHE_CONTROL);
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
