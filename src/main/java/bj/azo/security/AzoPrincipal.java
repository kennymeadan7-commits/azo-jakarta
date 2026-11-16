package bj.azo.security;

import java.security.Principal;

/**
 * Principal JAAS représentant l'<b>utilisateur</b> authentifié.
 *
 * <p>{@code JAASRealm} (Tomcat 10.1) ne lit pas de champ par réflexion : il compare le
 * <b>nom de classe</b> des principals du {@code Subject} aux listes
 * {@code userClassNames} / {@code roleClassNames} déclarées dans {@code context.xml}.
 * Cette classe est donc déclarée comme classe <em>utilisateur</em> ; son
 * {@link #getName()} alimente {@code request.getRemoteUser()}.</p>
 */
public class AzoPrincipal implements Principal {

    private final String username;
    private final String userId;
    private final String displayName;
    private final String role;

    public AzoPrincipal(String username, String userId, String displayName, String role) {
        this.username = username;
        this.userId = userId;
        this.displayName = displayName;
        this.role = role;
    }

    /** Adresse e-mail, c'est le nom d'utilisateur Azɔ. */
    @Override
    public String getName() {
        return username;
    }

    public String getUserId() {
        return userId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getRole() {
        return role;
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AzoPrincipal)) {
            return false;
        }
        return username.equals(((AzoPrincipal) other).username);
    }

    @Override
    public int hashCode() {
        return username.hashCode();
    }

    @Override
    public String toString() {
        return "AzoPrincipal[" + username + " (" + role + ")]";
    }
}
