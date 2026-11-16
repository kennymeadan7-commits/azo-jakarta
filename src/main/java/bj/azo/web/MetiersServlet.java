package bj.azo.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import bj.azo.dao.StatsDao;
import bj.azo.model.Agg;

/**
 * Page « Métiers » : agrégation JDBC {@code GROUP BY "trade"} sur la table
 * {@code WorkerProfile}, avec le nombre d'ouvriers, la note moyenne et le
 * tarif le plus bas de chaque métier.
 */
@WebServlet(name = "MetiersServlet", urlPatterns = {"/metiers"})
public class MetiersServlet extends HttpServlet {

    private final StatsDao statsDao = new StatsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Agg> trades = statsDao.countByTrade();
            Agg global = statsDao.global();

            request.setAttribute("trades", trades);
            request.setAttribute("global", global);
            request.setAttribute("workerCount", global.getCount());
            request.getRequestDispatcher("/metiers.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Erreur JDBC sur les métiers", e);
            fail(request, response, e);
        }
    }

    static void fail(HttpServletRequest request, HttpServletResponse response, SQLException e)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", "Impossible de lire les données.");
        request.setAttribute("errorDetail", e.getMessage());
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}
