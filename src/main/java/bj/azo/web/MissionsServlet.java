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
import bj.azo.model.Mission;
import bj.azo.model.User;

/**
 * Page « Mes missions » — <b>protégée</b> par le même {@code <security-constraint>}
 * que le tableau de bord (rôle CLIENT, WORKER ou ADMIN).
 *
 * <p>Les lignes affichées dépendent du rôle JAAS du connecté : un ouvrier voit les
 * missions dont il est {@code workerId}, un client celles dont il est {@code clientId}.</p>
 */
@WebServlet(name = "MissionsServlet", urlPatterns = {"/mes-missions"})
public class MissionsServlet extends HttpServlet {

    private final MissionDao missionDao = new MissionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute(UserSetupFilter.SESSION_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String role = user.getRole();
            List<Mission> missions = missionDao.findRecentForUser(user.getId(), role, 50);

            int open = missionDao.countForUser(user.getId(), role, "PENDING")
                    + missionDao.countForUser(user.getId(), role, "QUOTED")
                    + missionDao.countForUser(user.getId(), role, "ACCEPTED");
            int done = missionDao.countForUser(user.getId(), role, "COMPLETED");
            int revenue = missionDao.revenueForUser(user.getId(), role);

            request.setAttribute("user", user);
            request.setAttribute("missions", missions);
            request.setAttribute("openCount", open);
            request.setAttribute("doneCount", done);
            request.setAttribute("revenue", revenue);
            request.setAttribute("missionCount", missions.size());

            request.getRequestDispatcher("/mes-missions.jsp").forward(request, response);
        } catch (SQLException e) {
            getServletContext().log("Erreur JDBC sur les missions", e);
            MetiersServlet.fail(request, response, e);
        }
    }
}
