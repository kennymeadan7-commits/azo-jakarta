package bj.azo.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import bj.azo.dao.WorkerDao;
import bj.azo.model.WorkerProfile;

/**
 * Page « Nos ouvriers » : lecture JDBC de la table {@code "WorkerProfile"}
 * avec filtre facultatif par métier.
 */
@WebServlet(name = "WorkersServlet", urlPatterns = {"/workers"})
public class WorkersServlet extends HttpServlet {

    private final WorkerDao workerDao = new WorkerDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String trade = request.getParameter("trade");
        String city = request.getParameter("city");

        try {
            List<WorkerProfile> workers;
            if (trade != null && !trade.isBlank()) {
                workers = workerDao.findByTrade(trade);
            } else if (city != null && !city.isBlank()) {
                workers = workerDao.findByCity(city);
            } else {
                workers = workerDao.findAll();
            }

            request.setAttribute("workers", workers);
            request.setAttribute("selectedTrade", trade == null ? "" : trade.trim());
            request.setAttribute("selectedCity", city == null ? "" : city.trim());
            request.setAttribute("totalWorkers", workers.size());
            request.getRequestDispatcher("/workers.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Erreur JDBC sur la liste des ouvriers", e);
            request.setAttribute("errorMessage",
                    "Impossible de lire la base de données des ouvriers.");
            request.setAttribute("errorDetail", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
