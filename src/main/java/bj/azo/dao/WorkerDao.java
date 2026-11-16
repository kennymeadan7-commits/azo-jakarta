package bj.azo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import bj.azo.config.Database;
import bj.azo.model.WorkerProfile;

/**
 * Accès JDBC à la table {@code "WorkerProfile"}, jointurée à {@code "User"}
 * pour récupérer nom, e-mail et téléphone de l'ouvrier.
 */
public class WorkerDao {

    private static final String COLUMNS = """
            SELECT p."id", p."userId", u."name", u."email", u."phone",
                   p."trade", p."headline", p."bio", p."city", p."district",
                   p."dailyRate", p."experience", p."verified", p."verifiedAt",
                   p."available", p."whatsapp", p."ratingAvg", p."ratingCount",
                   p."completedJobs", p."createdAt"
            FROM "WorkerProfile" p
            INNER JOIN "User" u ON u."id" = p."userId"
            """;

    private static final String ORDER_BY_RATING =
            COLUMNS + " ORDER BY p.\"ratingAvg\" DESC, p.\"completedJobs\" DESC";

    private static final String WHERE_ID = COLUMNS + " WHERE p.\"id\" = ?";

    /** Liste des ouvriers, du mieux noté au moins bien noté. */
    public List<WorkerProfile> findAll() throws SQLException {
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(ORDER_BY_RATING);
             ResultSet rs = ps.executeQuery()) {
            List<WorkerProfile> workers = new ArrayList<>();
            while (rs.next()) {
                workers.add(map(rs));
            }
            return workers;
        }
    }

    /** Liste des ouvriers d'un métier donné (requête paramétrée), ou tous si vide. */
    public List<WorkerProfile> findByTrade(String trade) throws SQLException {
        boolean all = trade == null || trade.isBlank();
        String sql = all
                ? ORDER_BY_RATING
                : COLUMNS + " WHERE p.\"trade\" = ? ORDER BY p.\"ratingAvg\" DESC";
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (!all) {
                ps.setString(1, trade.trim().toLowerCase());
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<WorkerProfile> workers = new ArrayList<>();
                while (rs.next()) {
                    workers.add(map(rs));
                }
                return workers;
            }
        }
    }

    /** Liste des ouvriers d'une ville donnée (requête paramétrée). */
    public List<WorkerProfile> findByCity(String city) throws SQLException {
        if (city == null || city.isBlank()) {
            return findAll();
        }
        String sql = COLUMNS + " WHERE p.\"city\" = ? ORDER BY p.\"ratingAvg\" DESC";
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, city.trim());
            try (ResultSet rs = ps.executeQuery()) {
                List<WorkerProfile> workers = new ArrayList<>();
                while (rs.next()) {
                    workers.add(map(rs));
                }
                return workers;
            }
        }
    }

    /** Profil d'un ouvrier précis, ou {@code null}. */
    public WorkerProfile findById(String id) throws SQLException {
        if (id == null || id.isBlank()) {
            return null;
        }
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(WHERE_ID)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /** Insère un profil d'ouvrier (seed de démonstration). */
    public void insert(WorkerProfile p) throws SQLException {
        String sql = """
                INSERT INTO "WorkerProfile"
                    ("id", "userId", "trade", "headline", "bio", "city", "district",
                     "dailyRate", "experience", "verified", "verifiedAt", "available",
                     "whatsapp", "ratingAvg", "ratingCount", "completedJobs",
                     "createdAt", "updatedAt")
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getId());
            ps.setString(2, p.getUserId());
            ps.setString(3, p.getTrade());
            ps.setString(4, p.getHeadline());
            ps.setString(5, p.getBio());
            ps.setString(6, p.getCity());
            ps.setString(7, p.getDistrict());
            ps.setInt(8, p.getDailyRate());
            ps.setInt(9, p.getExperience());
            ps.setBoolean(10, p.isVerified());
            ps.setTimestamp(11, p.getVerifiedAt() == null ? null : Timestamp.from(p.getVerifiedAt()));
            ps.setBoolean(12, p.isAvailable());
            ps.setString(13, p.getWhatsapp());
            ps.setDouble(14, p.getRatingAvg());
            ps.setInt(15, p.getRatingCount());
            ps.setInt(16, p.getCompletedJobs());
            ps.setTimestamp(17, Timestamp.from(p.getCreatedAt()));
            ps.setTimestamp(18, Timestamp.from(java.time.Instant.now()));
            ps.executeUpdate();
        }
    }

    private static WorkerProfile map(ResultSet rs) throws SQLException {
        WorkerProfile p = new WorkerProfile();
        p.setId(rs.getString("id"));
        p.setUserId(rs.getString("userId"));
        p.setName(rs.getString("name"));
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));
        p.setTrade(rs.getString("trade"));
        p.setHeadline(rs.getString("headline"));
        p.setBio(rs.getString("bio"));
        p.setCity(rs.getString("city"));
        p.setDistrict(rs.getString("district"));
        p.setDailyRate(rs.getInt("dailyRate"));
        p.setExperience(rs.getInt("experience"));
        p.setVerified(rs.getBoolean("verified"));
        Timestamp verifiedAt = rs.getTimestamp("verifiedAt");
        p.setVerifiedAt(verifiedAt == null ? null : verifiedAt.toInstant());
        p.setAvailable(rs.getBoolean("available"));
        p.setWhatsapp(rs.getString("whatsapp"));
        p.setRatingAvg(rs.getDouble("ratingAvg"));
        p.setRatingCount(rs.getInt("ratingCount"));
        p.setCompletedJobs(rs.getInt("completedJobs"));
        Timestamp createdAt = rs.getTimestamp("createdAt");
        p.setCreatedAt(createdAt == null ? null : createdAt.toInstant());
        return p;
    }
}
