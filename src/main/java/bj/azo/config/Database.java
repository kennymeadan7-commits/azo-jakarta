package bj.azo.config;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Accès JDBC centralisé.
 *
 * <p>Le {@link DataSource} est déclaré dans {@code META-INF/context.xml} sous le nom
 * JNDI {@code java:comp/env/jdbc/azo}. Les DAO n'utilisent jamais {@code DriverManager} :
 * ils passent par ce pool géré par Tomcat.</p>
 */
public final class Database {

    /** Nom JNDI du pool JDBC (déclaré dans context.xml). */
    public static final String JNDI_NAME = "java:comp/env/jdbc/azo";

    private static volatile DataSource dataSource;

    private Database() {
    }

    /** Retourne le pool JDBC, résolu une seule fois par JVM. */
    public static DataSource dataSource() {
        DataSource ds = dataSource;
        if (ds == null) {
            synchronized (Database.class) {
                ds = dataSource;
                if (ds == null) {
                    try {
                        InitialContext ctx = new InitialContext();
                        ds = (DataSource) ctx.lookup(JNDI_NAME);
                    } catch (NamingException e) {
                        throw new IllegalStateException(
                                "DataSource JDBC introuvable : " + JNDI_NAME
                                        + " — vérifiez META-INF/context.xml", e);
                    }
                    dataSource = ds;
                }
            }
        }
        return ds;
    }

    /** Ouvre une connexion sur le pool. <b>À fermer dans un try-with-resources.</b> */
    public static Connection connection() throws SQLException {
        return dataSource().getConnection();
    }
}
