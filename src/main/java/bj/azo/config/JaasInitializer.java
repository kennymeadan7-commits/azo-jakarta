package bj.azo.config;

import java.security.Security;

import javax.security.auth.login.Configuration;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

/**
 * Enregistre {@link AzoJaasConfiguration} comme configuration JAAS de la JVM
 * <b>avant</b> la première tentative d'authentification.
 *
 * <p>Le Realm Tomcat n'a pas de {@code configFile} : il crée donc son
 * {@code LoginContext} avec une configuration {@code null}, ce qui le fait retomber sur
 * {@code Configuration.getConfiguration()}. Sans cet écouteur, Tomcat utiliserait le
 * fichier {@code conf/jaas.config} du serveur, absent d'une installation standard.</p>
 *
 * <p>Plan B documenté : si l'on préfère le fichier, il suffit d'exporter
 * {@code CATALINA_OPTS=-Djava.security.auth.login.config=.../jaas.config} et de retirer
 * l'écouteur (le fichier fourni à la racine du projet contient déjà l'entrée {@code Azo}).</p>
 */
public class JaasInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            // Évite un "already installed" si le webapp est redéployé.
            Configuration existing = Configuration.getConfiguration();
            if (existing instanceof AzoJaasConfiguration) {
                return;
            }
            Configuration.setConfiguration(new AzoJaasConfiguration());
            sce.getServletContext().log(
                    "Configuration JAAS enregistrée : " + AzoJaasConfiguration.APP_NAME);
        } catch (SecurityException | IllegalStateException e) {
            // Repli silencieux : Tomcat retombera sur conf/jaas.config si présent.
            sce.getServletContext().log(
                    "Impossible d'installer la configuration JAAS programmatique", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            Security.removeProvider("BC");
        } catch (Exception ignored) {
            // Le fournisseur Bouncy Castle peut déjà avoir été retiré.
        }
    }
}
