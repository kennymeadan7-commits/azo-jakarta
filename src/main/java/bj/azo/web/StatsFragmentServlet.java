package bj.azo.web;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import bj.azo.config.Database;

/**
 * Fragment de la page d'accueil : trois statistiques lues en JDBC.
 *
 * <p>Inclus par {@code index.jsp} via {@code <jsp:include page="/fragments/stats"/>}.
 * Le contrôleur ne produit qu'un extrait HTML, ce qui permet de garder la vue
 * {@code index.jsp} dépourvue de scriptlets.</p>
 */
@WebServlet(name = "StatsFragmentServlet", urlPatterns = {"/fragments/stats"})
public class StatsFragmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int workerCount = -1;
        int cityCount = -1;
        int tradeCount = -1;

        try (var con = Database.connection(); var st = con.createStatement()) {
            try (var rs = st.executeQuery("SELECT COUNT(*) FROM \"WorkerProfile\"")) {
                if (rs.next()) {
                    workerCount = rs.getInt(1);
                }
            }
            try (var rs = st.executeQuery("SELECT COUNT(DISTINCT \"city\") FROM \"WorkerProfile\"")) {
                if (rs.next()) {
                    cityCount = rs.getInt(1);
                }
            }
            try (var rs = st.executeQuery("SELECT COUNT(DISTINCT \"trade\") FROM \"WorkerProfile\"")) {
                if (rs.next()) {
                    tradeCount = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            getServletContext().log("Statistiques d'accueil indisponibles", e);
        }

        response.setContentType("text/html;charset=UTF-8");
        StringBuilder out = new StringBuilder(512);
        out.append("<div class=\"row\" style=\"gap: 2rem; margin-top: 0.5rem\">");
        appendStat(out, workerCount, "ouvriers enregistrés");
        appendStat(out, cityCount, "villes couvertes");
        appendStat(out, tradeCount, "métiers couverts");
        out.append("</div>");
        response.getWriter().write(out.toString());
    }

    private static void appendStat(StringBuilder out, int value, String label) {
        out.append("<div><p class=\"stat\">")
           .append(value >= 0 ? value : "—")
           .append("</p><p class=\"muted\" style=\"font-size: 0.85rem\">")
           .append(label)
           .append("</p></div>");
    }
}
