package bj.azo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import bj.azo.config.Database;
import bj.azo.model.Mission;

/**
 * Accès JDBC à la table {@code "Mission"}, jointurée à {@code "User"} pour les noms
 * du client et de l'ouvrier.
 *
 * <p>Toutes les méthodes prennent l'identifiant de l'utilisateur courant : les
 * missions affichées dépendent du rôle, ce qui illustre une requête paramétrée
 * construite selon le profil connecté.</p>
 */
public class MissionDao {

    private static final String COLUMNS = """
            SELECT m."id", m."title", m."description", m."trade", m."city", m."district",
                   m."status", m."budget", m."quoteAmount", m."scheduledFor", m."createdAt",
                   c."name" AS "clientName", w."name" AS "workerName"
            FROM "Mission" m
            INNER JOIN "User" c ON c."id" = m."clientId"
            INNER JOIN "User" w ON w."id" = m."workerId"
            """;

    /** Les {@code limit} dernières missions visibles pour l'utilisateur. */
    public List<Mission> findRecentForUser(String userId, String role, int limit)
            throws SQLException {
        if (userId == null || userId.isBlank()) {
            return List.of();
        }
        boolean isWorker = "WORKER".equals(role);
        String filter = isWorker ? "m.\"workerId\" = ?" : "m.\"clientId\" = ?";
        String sql = COLUMNS + " WHERE " + filter
                + " ORDER BY m.\"createdAt\" DESC LIMIT ?";

        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Mission> missions = new ArrayList<>();
                while (rs.next()) {
                    missions.add(map(rs));
                }
                return missions;
            }
        }
    }

    /** Nombre de missions par statut pour l'utilisateur. */
    public int countForUser(String userId, String role, String status) throws SQLException {
        if (userId == null || userId.isBlank()) {
            return 0;
        }
        boolean isWorker = "WORKER".equals(role);
        String filter = isWorker ? "m.\"workerId\" = ?" : "m.\"clientId\" = ?";
        String sql = "SELECT COUNT(*) FROM \"Mission\" m WHERE " + filter
                + (status == null ? "" : " AND m.\"status\" = ?");

        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            if (status != null) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /** Chiffre d'affaires cumulé des missions terminées (devis acceptés). */
    public int revenueForUser(String userId, String role) throws SQLException {
        if (userId == null || userId.isBlank()) {
            return 0;
        }
        boolean isWorker = "WORKER".equals(role);
        String filter = isWorker ? "m.\"workerId\" = ?" : "m.\"clientId\" = ?";
        String sql = "SELECT COALESCE(SUM(m.\"quoteAmount\"), 0) FROM \"Mission\" m"
                + " WHERE " + filter + " AND m.\"status\" = 'COMPLETED'";

        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private static Mission map(ResultSet rs) throws SQLException {
        Mission m = new Mission();
        m.setId(rs.getString("id"));
        m.setTitle(rs.getString("title"));
        m.setDescription(rs.getString("description"));
        m.setTrade(rs.getString("trade"));
        m.setCity(rs.getString("city"));
        m.setDistrict(rs.getString("district"));
        m.setStatus(rs.getString("status"));
        m.setBudget((Integer) rs.getObject("budget"));
        m.setQuoteAmount((Integer) rs.getObject("quoteAmount"));
        Timestamp scheduled = rs.getTimestamp("scheduledFor");
        m.setScheduledFor(scheduled == null ? null : scheduled.toInstant());
        Timestamp created = rs.getTimestamp("createdAt");
        m.setCreatedAt(created == null ? null : created.toInstant());
        m.setClientName(rs.getString("clientName"));
        m.setWorkerName(rs.getString("workerName"));
        return m;
    }

    /** Insertion utilisée par le seed de démonstration. */
    public void insert(String id, String clientId, String workerId, String title,
            String description, String trade, String city, String district,
            Integer budget, String status, Integer quoteAmount, int daysAgo)
            throws SQLException {
        String sql = """
                INSERT INTO "Mission"
                    ("id", "clientId", "workerId", "title", "description", "trade", "city",
                     "district", "scheduledFor", "budget", "status", "quoteAmount",
                     "quoteDelayDays", "createdAt", "updatedAt")
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            Timestamp now = Timestamp.from(java.time.Instant.now());
            Timestamp created = new Timestamp(now.getTime() - daysAgo * 86400_000L);
            ps.setString(1, id);
            ps.setString(2, clientId);
            ps.setString(3, workerId);
            ps.setString(4, title);
            ps.setString(5, description);
            ps.setString(6, trade);
            ps.setString(7, city);
            ps.setString(8, district);
            ps.setTimestamp(9, new Timestamp(created.getTime() + 3 * 86400_000L));
            ps.setObject(10, budget);
            ps.setString(11, status);
            ps.setObject(12, quoteAmount);
            ps.setObject(13, quoteAmount == null ? null : 2);
            ps.setTimestamp(14, created);
            ps.setTimestamp(15, now);
            ps.executeUpdate();
        }
    }
}
