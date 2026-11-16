package bj.azo.config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.Instant;
import java.util.List;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import bj.azo.dao.MissionDao;
import bj.azo.dao.UserDao;
import bj.azo.dao.WorkerDao;
import bj.azo.model.User;
import bj.azo.model.WorkerProfile;
import bj.azo.security.PasswordHasher;

/**
 * Initialise la base PostgreSQL au démarrage du webapp :
 *
 * <ol>
 *   <li>exécute {@code schema.sql} (crée les tables si elles n'existent pas) ;</li>
 *   <li>injecte le jeu de démonstration si la table {@code "User"} est vide.</li>
 * </ol>
 *
 * <p>Tout est fait en JDBC natif — c'est l'un des objectifs de l'exercice.</p>
 */
public class DatabaseInitializer implements ServletContextListener {

    /** Mot de passe des trois comptes de démonstration. */
    static final String DEMO_PASSWORD = "demo1234";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            applySchema();
            long users = new UserDao().count();
            if (users == 0) {
                seedDemoData();
                sce.getServletContext().log("Base Azɔ initialisée : comptes de démonstration créés");
            } else {
                sce.getServletContext().log("Base Azɔ prête (" + users + " compte(s))");
            }
        } catch (Exception e) {
            // On ne bloque pas le démarrage : les pages afficheront une erreur SQL
            // explicite, ce qui est plus parlant qu'un webapp qui refuse de démarrer.
            sce.getServletContext().log("Échec d'initialisation de la base Azɔ", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Tomcat avertit si le pilote chargé par le webapp n'est pas désenregistré :
        // on le fait explicitement pour éviter une fuite de mémoire au redéploiement.
        java.util.Enumeration<java.sql.Driver> drivers = java.sql.DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            try {
                java.sql.DriverManager.deregisterDriver(drivers.nextElement());
            } catch (Exception ignored) {
                // Le pilote peut déjà avoir été retiré.
            }
        }
    }

    /** Exécute {@code schema.sql}, statement par statement. */
    private void applySchema() throws IOException, SQLException {
        String sql;
        try (InputStream in = getClass().getResourceAsStream("/schema.sql")) {
            if (in == null) {
                throw new IOException("schema.sql introuvable dans le classpath");
            }
            sql = new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }

        try (Connection con = Database.connection();
             Statement st = con.createStatement()) {
            for (String statement : sql.split(";")) {
                String trimmed = stripComments(statement).trim();
                if (!trimmed.isEmpty()) {
                    st.execute(trimmed);
                }
            }
        }
    }

    /** Les commentaires SQL ne peuvent pas contenir de point-virgule ici. */
    private static String stripComments(String sql) {
        StringBuilder out = new StringBuilder(sql.length());
        try (BufferedReader reader = new BufferedReader(
                new java.io.StringReader(sql))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.startsWith("--")) {
                    continue;
                }
                out.append(line).append('\n');
            }
        } catch (IOException impossible) {
            // StringReader ne lève jamais IOException.
        }
        return out.toString();
    }

    /** Comptes + profils d'ouvriers de démonstration. */
    private void seedDemoData() throws SQLException {
        UserDao users = new UserDao();
        WorkerDao workers = new WorkerDao();
        String hash = PasswordHasher.hash(DEMO_PASSWORD);
        Instant now = Instant.now();

        insertUser(users, "adm1n0azo000000000000000", "Admin Azɔ",
                "admin@azo.bj", "+229 95 00 00 01", hash, "ADMIN", "Cotonou", now);
        insertUser(users, "cl1ent0azo00000000000000", "Aïcha Adjovi",
                "client@azo.bj", "+229 96 11 22 33", hash, "CLIENT", "Cotonou", now);
        insertUser(users, "ouv1er0azo000000000000000", "Jean Kpogli",
                "ouvrier@azo.bj", "+229 97 12 34 56", hash, "WORKER", "Cotonou", now);

        WorkerProfile kpogli = profile("wkr000000000000000000001", "ouv1er0azo000000000000000",
                "plomberie", "Plombier à Cotonou, dépannage 7j/7",
                "Douze ans d'expérience sur les canalisations et sanitaires du Grand Cotonou. "
                        + "Intervention le jour même sur les urgences, devis gratuit.",
                "Cotonou", "Fidjrossè", 15000, 12, true, true, "+229 97 12 34 56",
                4.8, 37, 64, now);
        workers.insert(kpogli);

        insertUser(users, "wkr000000000000000000u002", "Mariam Sanni",
                "mariam.sanni@azo.bj", "+229 98 44 55 66", hash, "WORKER", "Parakou", now);
        workers.insert(profile("wkr000000000000000000002", "wkr000000000000000000u002",
                "electricite", "Électricienne bâtiment certifiée",
                "Installation et mise aux normes des tableaux électriques. "
                        + "Diplômée de l'INPHB, partenaire de trois agences à Parakou.",
                "Parakou", "Zongo", 12500, 8, true, true, "+229 98 44 55 66",
                4.9, 24, 41, now));

        insertUser(users, "wkr000000000000000000u003", "Koffi Dossou",
                "koffi.dossou@azo.bj", "+229 97 77 88 99", hash, "WORKER", "Cotonou", now);
        workers.insert(profile("wkr000000000000000000003", "wkr000000000000000000u003",
                "maconnerie", "Maçon et enduiseur",
                "Gros œuvre, cloisons et enduits. Équipe de trois compagnons, "
                        + "chantiers livrés dans les délais sur Cotonou et Abomey-Calavi.",
                "Cotonou", "Godomey", 13000, 15, true, true, "+229 97 77 88 99",
                4.6, 52, 88, now));

        insertUser(users, "wkr000000000000000000u004", "Rachidatou Bio",
                "rachidatou.bio@azo.bj", "+229 95 21 43 65", hash, "WORKER", "Bohicon", now);
        workers.insert(profile("wkr000000000000000000004", "wkr000000000000000000u004",
                "menage", "Équipe de ménage et repassage",
                "Ménage résidentiel et de bureau, repassage à la demande. "
                        + "Produits écologiques fournis, forfaits à la journée.",
                "Bohicon", null, 7500, 4, false, true, "+229 95 21 43 65",
                4.7, 19, 33, now));

        insertUser(users, "wkr000000000000000000u005", "Sylvain Hounkpatin",
                "sylvain.hounkpatin@azo.bj", "+229 96 90 12 34", hash, "WORKER", "Abomey-Calavi", now);
        workers.insert(profile("wkr000000000000000000005", "wkr000000000000000000u005",
                "climatisation", "Frigoriste et installateur CVC",
                "Pose, entretien et réparation de climatiseurs et groupes froids. "
                        + "Interventions sur les entreprises et les particuliers.",
                "Abomey-Calavi", "Togba", 18000, 10, true, false, "+229 96 90 12 34",
                4.5, 12, 27, now));

        seedMissions();
    }

    /** Missions réparties sur les statuts, pour que le tableau de bord ait du contenu. */
    private void seedMissions() throws SQLException {
        MissionDao missions = new MissionDao();
        String client = "cl1ent0azo00000000000000";
        String client2 = "adm1n0azo000000000000000";

        missions.insert("msn0000000000000000000001", client, "ouv1er0azo000000000000000",
                "Réparation d'une fuite sous l'évier",
                "Fuite d'eau sous l'évier de la cuisine depuis deux jours, le joint "
                        + "d'arrivée semble desséché.",
                "plomberie", "Cotonou", "Fidjrossè", 12000, "COMPLETED", 15000, 42);

        missions.insert("msn0000000000000000000002", client, "wkr000000000000000000u003",
                "Cloison et enduit pour une chambre",
                "Construction d'une cloison en parpaings de 15 sur 4 m² puis enduit "
                        + "à la chaux.",
                "maconnerie", "Cotonou", "Godomey", 45000, "ACCEPTED", 52000, 12);

        missions.insert("msn0000000000000000000003", client2, "wkr000000000000000000u002",
                "Remplacement d'un tableau électrique",
                "Tableau vétuste dans un appartement de trois chambres, mise aux normes "
                        + "et ajout de deux disjoncteurs différentiels.",
                "electricite", "Parakou", "Zongo", 60000, "QUOTED", 68000, 5);

        missions.insert("msn0000000000000000000004", client, "wkr000000000000000000u004",
                "Ménage de fin de mois pour un bureau",
                "Vitres, sols et sanitaires d'un plateau de bureaux de 120 m².",
                "menage", "Bohicon", null, 18000, "IN_PROGRESS", null, 2);

        missions.insert("msn0000000000000000000005", client2, "wkr000000000000000000u005",
                "Entretien annuel de trois climatiseurs",
                "Trois split systems en lieu et charge, nettoyage des filtres et "
                        + "recharge en fluide.",
                "climatisation", "Abomey-Calavi", "Togba", 25000, "PENDING", null, 1);

        missions.insert("msn0000000000000000000006", client, "ouv1er0azo000000000000000",
                "Remplacement d'un ballon d'eau chaude",
                "Ballon 50 L hors service, besoin d'un conseil sur la capacité adaptée.",
                "plomberie", "Cotonou", "Akpakpa", 35000, "CANCELLED", null, 65);
    }

    private static void insertUser(UserDao dao, String id, String name, String email,
            String phone, String hash, String role, String city, Instant now) throws SQLException {
        User u = new User();
        u.setId(id);
        u.setName(name);
        u.setEmail(email);
        u.setPhone(phone);
        u.setPasswordHash(hash);
        u.setRole(role);
        u.setCity(city);
        u.setCreatedAt(now);
        dao.insert(u);
    }

    private static WorkerProfile profile(String id, String userId, String trade,
            String headline, String bio, String city, String district, int dailyRate,
            int experience, boolean verified, boolean available, String whatsapp,
            double ratingAvg, int ratingCount, int completedJobs, Instant now) {
        WorkerProfile p = new WorkerProfile();
        p.setId(id);
        p.setUserId(userId);
        p.setTrade(trade);
        p.setHeadline(headline);
        p.setBio(bio);
        p.setCity(city);
        p.setDistrict(district);
        p.setDailyRate(dailyRate);
        p.setExperience(experience);
        p.setVerified(verified);
        p.setVerifiedAt(verified ? now.minusSeconds(86400L * 30) : null);
        p.setAvailable(available);
        p.setWhatsapp(whatsapp);
        p.setRatingAvg(ratingAvg);
        p.setRatingCount(ratingCount);
        p.setCompletedJobs(completedJobs);
        p.setCreatedAt(now.minusSeconds(86400L * 200));
        return p;
    }

    /** Évite un import inutilisé si le code évolue. */
    static List<String> demoAccounts() {
        return List.of("admin@azo.bj", "client@azo.bj", "ouvrier@azo.bj");
    }
}
