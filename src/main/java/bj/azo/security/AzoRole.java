package bj.azo.security;

import java.security.Principal;

/**
 * Principal JAAS représentant un <b>rôle</b> de sécurité.
 *
 * <p>Séparé de {@link AzoPrincipal} car {@code JAASRealm} collecte les rôles à partir
 * des principals dont la classe figure dans {@code roleClassNames}, et le nom du
 * principal devient la valeur comparée à {@code <security-role>} du {@code web.xml}.</p>
 */
public class AzoRole implements Principal {

    private final String role;

    public AzoRole(String role) {
        this.role = role;
    }

    /** {@code ADMIN}, {@code CLIENT} ou {@code WORKER}. */
    @Override
    public String getName() {
        return role;
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AzoRole)) {
            return false;
        }
        return role.equals(((AzoRole) other).role);
    }

    @Override
    public int hashCode() {
        return role.hashCode();
    }

    @Override
    public String toString() {
        return "AzoRole[" + role + "]";
    }
}
