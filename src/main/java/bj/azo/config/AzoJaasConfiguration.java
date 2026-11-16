package bj.azo.config;

import java.util.Map;

import javax.security.auth.login.AppConfigurationEntry;
import javax.security.auth.login.Configuration;

/**
 * Configuration JAAS <b>programmatique</b>.
 *
 * <p>Plutôt que d'exiger l'édition de {@code conf/jaas.config} et du system property
 * {@code java.security.auth.login.config} (facile à oublier selon la machine), cette
 * classe enregistre l'entrée {@code Azo} dans la {@link Configuration} globale de la
 * JVM au démarrage du webapp — voir {@link JaasInitializer}.</p>
 *
 * <p>Le nom d'application {@code "Azo"} doit correspondre à {@code appName} du
 * {@code JAASRealm} déclaré dans {@code META-INF/context.xml}.</p>
 */
public class AzoJaasConfiguration extends Configuration {

    /** Nom d'application JAAS partagé entre cette configuration et le Realm. */
    public static final String APP_NAME = "Azo";

    private static final AppConfigurationEntry ENTRY = new AppConfigurationEntry(
            bj.azo.security.AzoLoginModule.class.getName(),
            AppConfigurationEntry.LoginModuleControlFlag.REQUIRED,
            Map.of());

    @Override
    public AppConfigurationEntry[] getAppConfigurationEntry(String name) {
        if (APP_NAME.equals(name)) {
            return new AppConfigurationEntry[] {ENTRY};
        }
        return null;
    }
}
