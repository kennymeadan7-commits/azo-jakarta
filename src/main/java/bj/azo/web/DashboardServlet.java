package bj.azo.web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bj.azo.dao.MissionDao;
import bj.azo.dao.StatsDao;
import bj.azo.model.Agg;
import bj.azo.model.Mission;
import bj.azo.model.User;

/**
 * Tableau de bord — <b>page protégée</b> par {@code <security-constraint>} (FORM + JAAS).
 *
 * <p>Un utilisateur non connecté est redirigé vers {@code /login.jsp} par Tomcat avant
 * même que ce code ne s'exécute. Le contenu affiché dépend du rôle, obtenu grâce au
 * principal JAAS.</p>
 */
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final MissionDao missionDao = new MissionDao();
    private final StatsDao statsDao = new StatsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session == null
                ? null
                : (User) session.getAttribute(UserSetupFilter.SESSION_USER);

        if (user == null) {
            // Par sécurité : même si le Realm a accepté, sans profil chargé on ne sert rien.
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setAttribute("user", user);
        request.setAttribute("remoteUser", request.getRemoteUser());
        request.setAttribute("userInAdminRole", request.isUserInRole("ADMIN"));

        try {
            // Missions de l'utilisateur connecté (filtrées selon le rôle).
            List<Mission> missions = missionDao.findRecentForUser(user.getId(), user.getRole(), 5);
            int open = missionDao.countForUser(user.getId(), user.getRole(), "PENDING")
                    + missionDao.countForUser(user.getId(), user.getRole(), "QUOTED")
                    + missionDao.countForUser(user.getId(), user.getRole(), "ACCEPTED")
                    + missionDao.countForUser(user.getId(), user.getRole(), "IN_PROGRESS");
            int done = missionDao.countForUser(user.getId(), user.getRole(), "COMPLETED");
            int revenue = missionDao.revenueForUser(user.getId(), user.getRole());

            request.setAttribute("missions", missions);
            request.setAttribute("openCount", open);
            request.setAttribute("doneCount", done);
            request.setAttribute("revenue", revenue);

            // Chiffre global de l'annuaire.
            Agg global = statsDao.global();
            request.setAttribute("workerCount", global.getCount());
            request.setAttribute("avgRating", global.getAvgRating());
            request.setAttribute("cityCount", statsDao.countByCity().size());
        } catch (SQLException e) {
            getServletContext().log("Statistiques du tableau de bord indisponibles", e);
            request.setAttribute("missions", List.of());
            request.setAttribute("workerCount", null);
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
