package bj.azo.web;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import bj.azo.dao.WorkerDao;
import bj.azo.model.WorkerProfile;

/**
 * Fiche d'un ouvrier : {@code /worker?id=<WorkerProfile.id>}, lecture JDBC unique.
 */
@WebServlet(name = "WorkerDetailServlet", urlPatterns = {"/worker"})
public class WorkerDetailServlet extends HttpServlet {

    private final WorkerDao workerDao = new WorkerDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        try {
            WorkerProfile worker = workerDao.findById(id);
            if (worker == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                request.setAttribute("errorMessage", "Ouvrier introuvable.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            request.setAttribute("worker", worker);
            request.getRequestDispatcher("/worker-detail.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Erreur JDBC sur la fiche ouvrier", e);
            request.setAttribute("errorMessage", "Impossible de lire la fiche de l'ouvrier.");
            request.setAttribute("errorDetail", e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
