# syntax=docker/dockerfile:1
# =============================================================================
# Azɔ — image de production : build Maven puis Apache Tomcat 10.1 (JRE 21).
#
#   Étape 1  : Maven produit target/azo.war à partir des sources.
#   Étape 2  : Tomcat officiel reçoit le WAR + le script d'entrée qui applique
#              les variables d'environnement (base de données, port).
#
#   Voir DEPLOIEMENT.md pour le déploiement sur Render.com.
# =============================================================================

# ---------------------------------------------------------------- étape 1 ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# Couche dédiée aux dépendances : elle n'est refaite que si pom.xml change.
COPY pom.xml ./
RUN mvn -B -q -DskipTests dependency:go-offline || true

COPY src ./src
RUN mvn -B -DskipTests package \
 && ls -l target/azo.war

# ---------------------------------------------------------------- étape 2 ----
FROM tomcat:10.1-jre21-temurin

# Tomcat de base sans les applications de démonstration (docs, examples,
# manager, host-manager) : on ne garde que l'application Azɔ.
RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /build/target/azo.war /usr/local/tomcat/webapps/azo.war
COPY docker/entrypoint.sh /usr/local/bin/azo-entrypoint.sh
RUN chmod +x /usr/local/bin/azo-entrypoint.sh

# Instance Render de base : 512 Mo. On borne la heap et la metaspace pour
# rester dans l'enveloppe (JasperReports compris).
ENV CATALINA_OPTS="-Xmx256m -XX:MaxMetaspaceSize=192m"

EXPOSE 8080

# Le PORT rendu par Render est répercuté sur le connecteur Tomcat par
# docker/entrypoint.sh (8080 par défaut en local).
ENTRYPOINT ["/usr/local/bin/azo-entrypoint.sh"]
