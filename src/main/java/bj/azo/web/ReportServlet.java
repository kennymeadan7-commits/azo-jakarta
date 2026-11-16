package bj.azo.web;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput;
import net.sf.jasperreports.pdf.JRPdfExporter;

import bj.azo.config.Database;
import bj.azo.model.User;

/**
 * Génération des rapports PDF (JasperReports) : missions et annuaire.
 *
 * <p>Deux URL protégées par le même {@code <security-constraint>} que le tableau de
 * bord — un visiteur non connecté ne peut pas télécharger un rapport. Le rapport
 * « missions » reçoit le rôle et l'identifiant du connecté en paramètres JDBC : la
 * requête SQL du .jrxml ne renvoie donc que le périmètre autorisé.</p>
 *
 * <p>Les .jrxml sont lus dans le classpath ({@code src/main/resources/reports}),
 * compilés une première fois puis mis en cache dans la JVM.</p>
 */
@WebServlet(name = "ReportServlet", urlPatterns = {"/rapports/missions", "/rapports/annuaire"})
public class ReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /** Format d'affichage des dates d'édition. */
    private static final DateTimeFormatter DATE_EDITION =
            DateTimeFormatter.ofPattern("dd/MM/yyyy 'à' HH:mm");

    /** Rapports compilés (.jrxml → .jasper), compilés une seule fois par JVM. */
    private static final Map<String, JasperReport> COMPILATIONS = new ConcurrentHashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session == null
                ? null
                : (User) session.getAttribute(UserSetupFilter.SESSION_USER);

        if (user == null) {
            // Même défense en profondeur que DashboardServlet, après le Realm JAAS.
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        boolean annuaire = request.getServletPath().endsWith("/annuaire");
        String modele = annuaire ? "/reports/annuaire.jrxml" : "/reports/missions.jrxml";
        String nomFichier = annuaire ? "annuaire-azo.pdf" : "missions-azo.pdf";

        Map<String, Object> parametres = new HashMap<>();
        parametres.put("utilisateur", user.getName());
        parametres.put("dateEdition", DATE_EDITION.format(LocalDateTime.now()));
        parametres.put("userId", user.getId());
        parametres.put("role", user.getRole());

        try (Connection con = Database.connection()) {
            JasperReport rapport = compiler(modele);
            JasperPrint impression = JasperFillManager.fillReport(rapport, parametres, con);

            response.reset();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + nomFichier + "\"");
            response.setHeader("Cache-Control", "no-store");

            JRPdfExporter exporteur = new JRPdfExporter();
            exporteur.setExporterInput(new SimpleExporterInput(impression));
            exporteur.setExporterOutput(
                    new SimpleOutputStreamExporterOutput(response.getOutputStream()));
            exporteur.exportReport();
        } catch (JRException | SQLException e) {
            getServletContext().log("Génération du rapport " + nomFichier + " impossible", e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }

    /** Compile le .jrxml demandé, une seule fois par JVM (cache partagé). */
    private JasperReport compiler(String modele) throws JRException, IOException {
        JasperReport rapport = COMPILATIONS.get(modele);
        if (rapport != null) {
            return rapport;
        }
        try (InputStream in = getClass().getResourceAsStream(modele)) {
            if (in == null) {
                throw new JRException("Modèle de rapport introuvable : " + modele);
            }
            rapport = JasperCompileManager.compileReport(in);
        }
        COMPILATIONS.putIfAbsent(modele, rapport);
        return rapport;
    }
}
