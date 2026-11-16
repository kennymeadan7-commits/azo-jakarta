# Azɔ — Jakarta EE (JSP + JDBC + JAAS)

Application web **Azɔ** (plateforme d'artisans du Bénin) construite en **Jakarta EE avec
JSP**, accès aux données en **JDBC**, authentification **JAAS**, servie par **Apache
Tomcat 10.1** sur **PostgreSQL**.

## Environnement

| Élément | Valeur |
|---|---|
| Serveur | Apache Tomcat **10.1.61** (`C:\Users\LE ROI SIMON\.tools\apache-tomcat-10.1.61`) |
| JDK | Java **21** |
| Maven | 3.9.16 (`%USERPROFILE%\.tools\apache-maven-3.9.16\bin\mvn.cmd`) |
| Base | PostgreSQL 18 — base `azo_java`, utilisateur `azo` / mot de passe `azo` |
| Contexte | `http://localhost:8080/azo` |

## Démarrer

```powershell
# 1. Construire
$mvn = "$env:USERPROFILE\.tools\apache-maven-3.9.16\bin\mvn.cmd"
& $mvn -B package          # produit target/azo.war

# 2. Déployer
$env:CATALINA_HOME = "$env:USERPROFILE\.tools\apache-tomcat-10.1.61"
Remove-Item "$env:CATALINA_HOME\webapps\azo*" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item target\azo.war "$env:CATALINA_HOME\webapps\azo.war" -Force

# 3. Lancer (les variables d'environnement sont OBLIGATOIRES : elles
#    alimentent ${AZO_DB_URL} / ${AZO_DB_USER} / ${AZO_DB_PASSWORD}
#    de META-INF/context.xml)
$env:JAVA_HOME = "C:\Program Files\Java\jdk-21.0.11"
$env:CATALINA_OPTS = "-Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource,org.apache.tomcat.util.digester.SystemPropertySource"
$env:AZO_DB_URL      = "jdbc:postgresql://localhost:5432/azo_java"
$env:AZO_DB_USER     = "azo"
$env:AZO_DB_PASSWORD = "azo"
& "$env:CATALINA_HOME\bin\catalina.bat" run
```

Au premier démarrage, `DatabaseInitializer` crée le schéma et insère les comptes
pré-configurés ainsi que les profils d'ouvriers et l'historique de missions.

> **Pourquoi ces variables ?** Le `context.xml` ne contient plus d'identifiants :
> Tomcat remplace `${AZO_DB_URL}`… à partir de l'environnement, à condition que
> la JVM soit lancée avec la propriété `…digester.PROPERTY_SOURCE` ci-dessus.
> C'est ce que fait `docker/entrypoint.sh` en production — voir `DEPLOIEMENT.md`.

## Comptes pré-configurés

| E-mail | Rôle | Mot de passe |
|---|---|---|
| `admin@azo.bj` | `ADMIN` | `demo1234` |
| `client@azo.bj` | `CLIENT` | `demo1234` |
| `ouvrier@azo.bj` | `WORKER` | `demo1234` |

> Ces identifiants figurent dans un bloc replié sous le formulaire de connexion.
> En production, remplacez-les et désactivez ce bloc.

## Pages

| URL | Accès | Source |
|---|---|---|
| `/` | public | `index.jsp` + fragment `/fragments/stats` (JDBC) |
| `/workers` | public | `WorkersServlet` → `workers.jsp` (filtres `?trade=`, `?city=`) |
| `/worker?id=` | public | `WorkerDetailServlet` → `worker-detail.jsp` |
| `/metiers` | public | `MetiersServlet` → `metiers.jsp` (`GROUP BY "trade"`) |
| `/villes` | public | `VillesServlet` → `villes.jsp` (`GROUP BY "city"`) |
| `/login.jsp` | public | formulaire `j_security_check` — accès direct redirigé par `LoginPageFilter` |
| `/login-error.jsp` | public | `form-error-page` |
| `/dashboard` | **protégé** | `DashboardServlet` → `dashboard.jsp` |
| `/mes-missions` | **protégé** | `MissionsServlet` → `mes-missions.jsp` (selon le rôle) |
| `/rapports/missions` | **protégé** | `ReportServlet` → PDF JasperReports (missions du rôle) |
| `/rapports/annuaire` | **protégé** | `ReportServlet` → PDF JasperReports (annuaire des artisans) |
| `/logout` | public | invalide la session |
| `/error.jsp` | — | 404 / 500 / exceptions |

## Architecture

```
src/main/java/bj/azo
├── config
│   ├── Database.java              JNDI java:comp/env/jdbc/azo → DataSource
│   ├── DatabaseInitializer.java   schema.sql + seed (JDBC)
│   ├── AzoJaasConfiguration.java  Configuration JAAS programmatique (entrée "Azo")
│   └── JaasInitializer.java       installe cette Configuration au démarrage
├── model        User, WorkerProfile, Mission, Agg
├── dao          UserDao, WorkerDao, MissionDao, StatsDao   ← PreparedStatement uniquement
├── security
│   ├── PasswordHasher.java        scrypt (Bouncy Castle) compatible Node.js
│   ├── AzoPrincipal.java          principal « utilisateur »
│   ├── AzoRole.java               principal « rôle »
│   └── AzoLoginModule.java        LoginModule JAAS (login/commit/logout)
└── web          UserSetupFilter + LoginPageFilter + Workers/WorkerDetail/Dashboard/
                 Metiers/Villes/Missions/Report/Logout/StatsFragment
```

### Authentification FORM : le piège du 408

La spécification Servlet impose que la page de connexion soit **atteinte à travers une
ressource protégée**. C'est cette séquence (sauvegarde de la requête + changement
d'identifiant de session, protégeant contre la fixation de session) qui pose la note
interne `org.apache.catalina.authenticator.SESSION_ID` attendue lors du POST.

Or le menu et le pied de page lient directement `/login.jsp`. Sans cette séquence,
Tomcat juge la session expirée et répond **408** (`authenticator.sessionExpired`)
au moment de la validation du formulaire.

`LoginPageFilter` redirige donc tout **GET direct** de `/login.jsp` et
`/login-error.jsp` vers `/dashboard` (protégé) : Tomcat déclenche alors la séquence
normale et forward vers la page de connexion. Le filtre n'est déclaré que pour le
dispatcher `REQUEST` (valeur par défaut) : le forward renvoyé par Tomcat ne le
ré-exécute pas, aucune boucle n'est possible.

### Pages d'erreur

`web.xml` déclare `error.jsp` pour les codes **404**, **500** et pour
`java.lang.Throwable`. Deux pièges EL rencontrés et contournés :

- `${pageContext.exception...}` — `PageContext` n'expose aucune propriété
  `exception` à l'EL (refusée à la **compilation** de la JSP).
- `${obj.class.name}` — l'EL ignore `.class` (propriété JavaBean inexistante).

L'exception est lue dans `requestScope['javax.servlet.error.exception']` et affichée
via `toString()` (qui donne « classe : message »).

### JDBC

- `DataSource` déclaré dans `src/main/webapp/META-INF/context.xml`, publié sous
  `java:comp/env/jdbc/azo`, pool `tomcat-jdbc` avec `validationQuery=SELECT 1`.
- Aucun `DriverManager` : tout passe par `Database.connection()`.
- Requêtes **paramétrées** (`PreparedStatement`) ; les colonnes PostgreSQL sont en
  camelCase entre guillemets (`"passwordHash"`, `"userId"`) et sont reprises telles quelles.
- Agrégations réelles : `GROUP BY "trade"`, `GROUP BY "city"`, `SUM`/`COUNT` sur
  la table `"Mission"`.

### JAAS

1. `JaasInitializer` (écouteur) enregistre `AzoJaasConfiguration` via
   `Configuration.setConfiguration()` → aucune édition de `conf/jaas.config`
   (un fichier de repli est fourni à la racine du projet).
2. `META-INF/context.xml` déclare `JAASRealm` :
   `appName="Azo"`, `userClassNames="bj.azo.security.AzoPrincipal"`,
   `roleClassNames="bj.azo.security.AzoRole"`.
   > Tomcat 10.1 ne lit **pas** `userField`/`roleField` : il compare le **nom de classe**
   > des principaux du `Subject` à ces deux listes.
3. `web.xml` déclare les contraintes `/dashboard`, `/mes-missions` et
   `/rapports/*` + `FORM` (`j_security_check`).
4. `AzoLoginModule.login()` lit `NameCallback`/`PasswordCallback`, interroge la table
   `"User"` en JDBC et vérifie le hachage ; `commit()` ajoute `AzoPrincipal` + `AzoRole`.

### Rapports PDF (JasperReports 7)

Deux rapports **A4 paysage** sont produits à la volée, boutons inclus sur le
tableau de bord et sur `mes-missions.jsp` (icônes SVG Lucide) :

| Rapport | Modèle | Portée |
|---|---|---|
| Missions | `src/main/resources/reports/missions.jrxml` | filtrée par `$P{role}` / `$P{userId}` (identique à `MissionDao`) |
| Annuaire | `src/main/resources/reports/annuaire.jrxml` | tous les ouvriers, triés par note |

- `ReportServlet` (`/rapports/missions`, `/rapports/annuaire`) est ajouté au
  `<security-constraint>` : **aucun PDF sans session**.
- Compilation `JasperCompileManager` mise en cache dans la JVM, remplissage
  `JasperFillManager` sur la connexion JNDI, export `JRPdfExporter`
  (classe `net.sf.jasperreports.pdf.JRPdfExporter`, il n'y a plus de
  `JasperExportManager` en 7).
- Dépendances : `jasperreports` + `-pdf` + `-fonts` (polices **DejaVu**, qui
  couvrent « ɔ », « é », « œ », « — »…) + `-jdt` (compilation des `.jrxml`).
- Toutes les colonnes sont projetées en **TEXT** (`TO_CHAR`, `REPLACE`) :
  dates au format `JJ/MM/AAAA`, montants séparés d'espaces (« 25 000 »),
  donc aucune conversion de type JDBC à l'export.

**Piège JasperReports 7** : le `.jrxml` est lu par Jackson, pas par le parseur
Digester ancien. La racine ne doit **pas** déclarer de `xmlns`, et les
attributs sont ceux du bean Java : `bold` (pas `isBold`), `forPrompting`,
`hTextAlign="Right|Center"`, `vTextAlign="Middle"`, `<query language="SQL">`
(pas `<queryString>`), bandes `<title height="60">` contenant des
`<element kind="textField">`. Vos `.jrxml` 6.x ne compilent pas tels quels.

### Déploiement en ligne (Render.com)

Voir **[DEPLOIEMENT.md](DEPLOIEMENT.md)** — image Docker (Maven → Tomcat 10.1),
`render.yaml` (service web + PostgreSQL managé), variables `AZO_DB_*` dérivées
de `DATABASE_URL`, port `$PORT`, checklist de vérification et dépannage.
Les identifiants ne sont **jamais** versionnés : `context.xml` n'contient que
`${AZO_DB_URL}` / `${AZO_DB_USER}` / `${AZO_DB_PASSWORD}`.

### Compatibilité des mots de passe

Le site Next.js existant utilise `scryptSync(password, saltHex, 64)` où Node encode le
sel **en UTF-8 depuis la chaîne hexadécimale**. `PasswordHasher` reproduit exactement
ce comportement (N=16384, r=8, p=1, 64 octets dérivés) : un hash produit par Node est
bien vérifié par Java, et inversement.

## Vérifications passées

- `mvn package` → `BUILD SUCCESS`, WAR généré (**32,7 Mo**, JasperReports
  inclus) et déployé dans Tomcat 10.1.61.
- Accueil, ouvriers, métiers, villes, fiche, login, erreur : HTTP 200,
  aucun scriptlet ni JSP brut rendu.
- **Connexion en partant de `/login.jsp`** (menu, favori, URL saisie) :
  302 → page de connexion servie depuis `/dashboard` → POST → 200
  `Tableau de bord` — plus aucun **408**.
- Mauvais mot de passe → `Échec de connexion`.
- `/dashboard` et `/mes-missions` sans session → page de connexion
  (contenu protégé non exposé).
- Login `admin` → `Bonjour, Admin Azɔ`, `remoteUser=admin@azo.bj`,
  `authType=FORM`, missions réelles avec pastilles de statut et montants FCFA.
- Rôles `WORKER` (colonne *Client*) et `CLIENT` (colonne *Ouvrier*) sur
  `/mes-missions` ; déconnexion → retour à la page de connexion.
- Filtres métier (`plomberie`, `electricite`, `menage`) et ville (`Cotonou`) :
  requêtes paramétrées.
- **Rapports PDF** : `/rapports/missions` et `/rapports/annuaire` répondent
  `200` / `application/pdf` / en-tête `%PDF-1.5` après connexion, et renvoient
  la page de connexion sans session ; contenu contrôlé hors serveur
  (colonnes alignées, 6 missions pour ADMIN, 4 pour CLIENT, 5 pour WORKER,
  1 page ≈ 40 Ko, glyphes DejaVu complets).
- **`context.xml` paramétré** : démarrage avec
  `-D…PROPERTY_SOURCE=EnvironmentPropertySource` + `AZO_DB_*` en variables
  d'environnement → base atteinte, connexions et rapports identiques à la
  configuration en dur (banc de test de la substitution `${…}`).
- `/error.jsp` : accès direct 200 ; URL inexistante → 404 → `error.jsp` maison.
- Aucune erreur `SEVERE`, aucun `408` et aucune `SQLException` dans les logs
  après le démarrage.
