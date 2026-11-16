package bj.azo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bj.azo.config.Database;
import bj.azo.model.Agg;

/**
 * Requêtes d'agrégation JDBC : nombre d'ouvriers par métier et par ville.
 *
 * <p>Ce sont de vraies requêtes SQL agrégées côté PostgreSQL
 * ({@code GROUP BY}), rendues telles quelles dans les pages métier et ville.</p>
 */
public class StatsDao {

    private static final String BY_TRADE = """
            SELECT p."trade" AS "label",
                   COUNT(*) AS "cnt",
                   COALESCE(AVG(p."ratingAvg"), 0) AS "avg",
                   COALESCE(MIN(p."dailyRate"), 0) AS "minrate"
            FROM "WorkerProfile" p
            GROUP BY p."trade"
            ORDER BY COUNT(*) DESC, p."trade"
            """;

    private static final String BY_CITY = """
            SELECT p."city" AS "label",
                   COUNT(*) AS "cnt",
                   COALESCE(AVG(p."ratingAvg"), 0) AS "avg",
                   COALESCE(MIN(p."dailyRate"), 0) AS "minrate"
            FROM "WorkerProfile" p
            GROUP BY p."city"
            ORDER BY COUNT(*) DESC, p."city"
            """;

    public List<Agg> countByTrade() throws SQLException {
        return groupBy(BY_TRADE);
    }

    public List<Agg> countByCity() throws SQLException {
        return groupBy(BY_CITY);
    }

    private static List<Agg> groupBy(String sql) throws SQLException {
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Agg> out = new ArrayList<>();
            while (rs.next()) {
                Agg a = new Agg();
                a.setLabel(rs.getString("label"));
                a.setCount(rs.getInt("cnt"));
                a.setAvgRating(rs.getDouble("avg"));
                a.setMinRate(rs.getInt("minrate"));
                out.add(a);
            }
            return out;
        }
    }

    /** Nombre total d'ouvriers et note moyenne globale. */
    public Agg global() throws SQLException {
        String sql = """
                SELECT COUNT(*) AS "cnt",
                       COALESCE(AVG("ratingAvg"), 0) AS "avg",
                       COALESCE(MIN("dailyRate"), 0) AS "minrate"
                FROM "WorkerProfile"
                """;
        try (Connection con = Database.connection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            Agg a = new Agg();
            if (rs.next()) {
                a.setCount(rs.getInt("cnt"));
                a.setAvgRating(rs.getDouble("avg"));
                a.setMinRate(rs.getInt("minrate"));
            }
            return a;
        }
    }
}
