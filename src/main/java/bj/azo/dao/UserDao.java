package bj.azo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import bj.azo.config.Database;
import bj.azo.model.User;

/**
 * Accès JDBC à la table {@code "User"}.
 *
 * <p>Toutes les requêtes passent par {@link PreparedStatement} (aucune concaténation
 * de chaîne dans le SQL) et toutes les connexions proviennent du pool JNDI
 * {@code java:comp/env/jdbc/azo}.</p>
 */
public class UserDao {

    private static final String SELECT_BY_EMAIL = """
            SELECT "id", "name", "email", "phone", "passwordHash", "role",
                   "suspended", "city", "createdAt"
            FROM "User"
            WHERE LOWER("email") = LOWER(?)
            """;

    private static final String COUNT_ALL = "SELECT COUNT(*) FROM \"User\"";

    private static final String INSERT = """
            INSERT INTO "User"
                ("id", "name", "email", "phone", "passwordHash", "role", "suspended", "city", "createdAt")
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

    /** Recherche un compte par adresse e-mail (insensible à la casse), ou {@code null}. */
    public User findByEmail(String email) throws SQLException {
        if (email == null || email.isBlank()) {
            return null;
        }
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(SELECT_BY_EMAIL)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    /** Nombre de comptes — sert à décider si le jeu de démonstration doit être injecté. */
    public long count() throws SQLException {
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(COUNT_ALL);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0L;
        }
    }

    /** Insère un compte (utilisé uniquement par le seed de démonstration). */
    public void insert(User user) throws SQLException {
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {
            ps.setString(1, user.getId());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPasswordHash());
            ps.setString(6, user.getRole());
            ps.setBoolean(7, user.isSuspended());
            ps.setString(8, user.getCity());
            ps.setTimestamp(9, Timestamp.from(user.getCreatedAt()));
            ps.executeUpdate();
        }
    }

    private static User map(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getString("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPasswordHash(rs.getString("passwordHash"));
        user.setRole(rs.getString("role"));
        user.setSuspended(rs.getBoolean("suspended"));
        user.setCity(rs.getString("city"));
        Timestamp createdAt = rs.getTimestamp("createdAt");
        user.setCreatedAt(createdAt == null ? null : createdAt.toInstant());
        return user;
    }
}
