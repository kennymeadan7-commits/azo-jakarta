#!/bin/sh
# =============================================================================
# Point d'entrée du conteneur Azɔ.
#
# 1. Active la substitution ${VAR} des propriétés de Tomcat : c'est ce qui
#    permet d'écrire ${AZO_DB_URL} dans META-INF/context.xml.
#    Sans ce -D, Tomcat laisse la chaîne littérale "${AZO_DB_URL}" et le pool
#    JDBC échoue au premier usage.
# 2. Prépare la configuration PostgreSQL :
#      - si AZO_DB_URL / AZO_DB_USER / AZO_DB_PASSWORD sont fournis, on les
#        utilise tels quels (cf. valeurs locales) ;
#      - sinon on les dérive de DATABASE_URL (format postgresql://…) publié
#        par le service PostgreSQL managé de Render.
# 3. Fait écouter Tomcat sur $PORT (Render) plutôt que sur 8080.
# =============================================================================
set -eu

CATALINA_HOME="${CATALINA_HOME:-/usr/local/tomcat}"

# --- 1. substitution ${...} dans context.xml -------------------------------
CATALINA_OPTS="${CATALINA_OPTS:-} -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource,org.apache.tomcat.util.digester.SystemPropertySource"
export CATALINA_OPTS

# --- 2. configuration PostgreSQL -------------------------------------------
if [ -z "${AZO_DB_URL:-}" ]; then
    if [ -z "${DATABASE_URL:-}" ]; then
        echo "ERREUR: ni AZO_DB_URL ni DATABASE_URL n'est defini." >&2
        echo "       Definissez AZO_DB_URL/AZO_DB_USER/AZO_DB_PASSWORD," >&2
        echo "       ou DATABASE_URL (chaine de connexion du serveur Postgres)." >&2
        exit 1
    fi

    # postgresql://utilisateur:motdepasse@hote:port/base?params
    URL="${DATABASE_URL}"
    WITHOUT_SCHEME=$(printf '%s' "$URL" | sed -e 's|^[a-zA-Z][a-zA-Z0-9+.-]*://||')
    CREDS=$(printf '%s' "$WITHOUT_SCHEME" | sed -e 's|@.*$||')
    HOSTDB=$(printf '%s' "$WITHOUT_SCHEME" | sed -e 's|^[^@]*@||')

    AZO_DB_USER=$(printf '%s' "$CREDS" | cut -d: -f1)
    AZO_DB_PASSWORD=$(printf '%s' "$CREDS" | cut -d: -f2-)
    if [ "$AZO_DB_PASSWORD" = "$CREDS" ]; then
        # Pas de mot de passe dans l'URL
        AZO_DB_PASSWORD=""
    fi

    DB_HOST=$(printf '%s' "$HOSTDB" | cut -d/ -f1)
    DB_NAME=$(printf '%s' "$HOSTDB" | cut -d/ -f2- | cut -d'?' -f1)

    AZO_DB_URL="jdbc:postgresql://${DB_HOST}/${DB_NAME}?sslmode=require"
    export AZO_DB_URL AZO_DB_USER AZO_DB_PASSWORD
fi

echo "AzO - base : ${AZO_DB_URL} (utilisateur ${AZO_DB_USER:-<inconnu>})"

# --- 3. port d'écoute -------------------------------------------------------
PORT="${PORT:-8080}"
if [ "$PORT" != "8080" ]; then
    sed -i "s|port=\"8080\"|port=\"${PORT}\"|" "$CATALINA_HOME/conf/server.xml"
fi
echo "AzO - ecoute sur le port ${PORT}, contexte /azo"

exec "$CATALINA_HOME/bin/catalina.sh" run
