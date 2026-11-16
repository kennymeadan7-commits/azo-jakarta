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
 * Page « Villes » : agrégation JDBC {@code GROUP BY "city"} sur la table
 * {@code WorkerProfile} — couverture territoriale d'Azɔ au Bénin.
 */
@WebServlet(name = "VillesServlet", urlPatterns = {"/villes"})
public class VillesServlet extends HttpServlet {

    private final StatsDao statsDao = new StatsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Agg> cities = statsDao.countByCity();
            Agg global = statsDao.global();

            request.setAttribute("cities", cities);
            request.setAttribute("global", global);
            request.setAttribute("cityCount", cities.size());
            request.getRequestDispatcher("/villes.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Erreur JDBC sur les villes", e);
            MetiersServlet.fail(request, response, e);
        }
    }
}
