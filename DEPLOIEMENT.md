# Déploiement en ligne — Azɔ sur Render.com

Ce document décrit le déploiement **en production** de l'application
**Jakarta EE (JSP) + JDBC + JAAS + JasperReports** sur [Render.com](https://render.com),
avec un **PostgreSQL managé**.

| Élément | Choix retenu |
|---|---|
| Runtime | **Docker** (image construite par Render à partir de `Dockerfile`) |
| Build | Maven 3.9 + JDK 21 → `azo.war` (≈ 33 Mo) |
| Serveur | **Apache Tomcat 10.1** (JRE 21), contexte `/azo` |
| Base | **PostgreSQL managé Render**, `DATABASE_URL` injectée au service |
| HTTPS | Certificat géré par Render (terminaison TLS sur le routeur) |
| Entrée | `docker/entrypoint.sh` (variables d'env → `context.xml`, port `$PORT`) |

---

## 1. Principe

Trois points méritent d'être compris, ils sont spécifiques à ce déploiement.

### 1.1 Les identifiants PostgreSQL ne sont plus écrits dans le code

`src/main/webapp/META-INF/context.xml` ne contient plus de valeurs en dur :

```xml
<Resource name="jdbc/azo" ... 
          url="${AZO_DB_URL}"
          username="${AZO_DB_USER}"
          password="${AZO_DB_PASSWORD}" ... />
```

Tomcat **n'active pas** la substitution `${…}` par défaut : elle doit être
autorisée par la propriété JVM

```
-Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource,org.apache.tomcat.util.digester.SystemPropertySource
```

C'est `docker/entrypoint.sh` qui l'ajoute à `CATALINA_OPTS` (le même `-D` est
à poser en local, voir le README). `EnvironmentPropertySource` résout alors
`${AZO_DB_URL}` avec `System.getenv("AZO_DB_URL")`.

### 1.2 `DATABASE_URL` (Render) → `jdbc:postgresql://…`

Render publie une chaine `postgresql://user:password@host:port/dbname`.
Le pilote JDBC veut un `jdbc:postgresql://host:port/dbname` **et** le compte
séparé (attributs `username` / `password` du pool). Le point d'entrée dérive
les trois variables automatiquement :

```sh
AZO_DB_URL       = jdbc:postgresql://host:port/dbname?sslmode=require
AZO_DB_USER      = user
AZO_DB_PASSWORD  = password
```

Vous pouvez contourner cette dérivation en définissant
`AZO_DB_URL` / `AZO_DB_USER` / `AZO_DB_PASSWORD` vous-même (utile si le mot de
passe contient des caractères réservés `@ : /` à encoder).

### 1.3 Port d'écoute

Render expose la variable `PORT`. Le point d'entrée réécrit le connecteur
Tomcat (`conf/server.xml`) pour qu'il écoute sur `${PORT}` (8080 en local).
`render.yaml` déclare `port: 8080` en cohérence.

---

## 2. Déploiement pas à pas

### Étape 1 — Publier le code

Le dossier n'est pas encore un dépôt Git (`.gitignore` et `.dockerignore` sont
fournis) :

```powershell
cd J:\JAVA\azo-jakarta
git init
git add .
git commit -m "Azɔ : Jakarta EE + JDBC + JAAS + JasperReports"
git remote add origin https://github.com/<votre-compte>/azo-jakarta.git
git branch -M main
git push -u origin main
```

### Étape 2 — Créer le blueprint

1. Dashboard Render → **New (+)** → **Blueprint** → connectez le dépôt GitHub.
2. Render lit `render.yaml` et propose deux ressources :
   - `azo-web` (service web Docker),
   - `azo-db` (PostgreSQL).
3. Choisissez le **plan** (gratuit s'il est proposé, sinon *Starter*) puis
   **Apply**.

> Sans blueprint, la voie manuelle équivalente est : **New → Web Service →
> Connect a repository** (Runtime Docker, Dockerfile path `./Dockerfile`,
> port `8080`, health check `/azo/`) puis **New → PostgreSQL**, et enfin
> renseigner `DATABASE_URL` (ou `AZO_DB_*`) dans *Environment* du service.

### Étape 3 — Suivre le build

Le build Maven télécharge les dépendances au premier passage (2 à 5 minutes) ;
le service passe ensuite `Live`. Journaux attendus au démarrage :

```
AzO - base : jdbc:postgresql://…/azo?sslmode=require (utilisateur azo)
AzO - ecoute sur le port 8080, contexte /azo
… Configuration JAAS enregistrée : Azo
… Base Azɔ initialisée : comptes de démonstration créés   (1er démarrage)
```

`DatabaseInitializer` exécute `schema.sql` (tables `IF NOT EXISTS`) puis, si la
table `"User"` est vide, insère les 3 comptes, les 5 profils d'ouvriers et les
6 missions. Un redéploiement ne touche jamais aux données existantes.

### Étape 4 — Vérifier

| # | Vérification | Attendu |
|---|---|---|
| 1 | `https://<app>.onrender.com/azo/` | 200, page d'accueil, 5 ouvriers / 4 villes / 5 métiers |
| 2 | `…/azo/dashboard` sans session | page de connexion (contenu protégé non exposé) |
| 3 | Connexion `admin@azo.bj` / `demo1234` | tableau de bord, « Bonjour, Admin Azɔ » |
| 4 | `…/azo/rapports/missions` | `application/pdf`, en-tête `%PDF` |
| 5 | `…/azo/rapports/annuaire` | `application/pdf`, en-tête `%PDF` |
| 6 | Mauvais mot de passe | message d'échec, pas de trace système |
| 7 | Journaux du service | aucun `SEVERE`, aucun `408` |

```powershell
# Vérification rapide des deux rapports (après connexion)
Invoke-WebRequest "https://<app>.onrender.com/azo/rapports/missions" -OutFile missions.pdf
```

---

## 3. Variables d'environnement

| Variable | Rôle | Source |
|---|---|---|
| `DATABASE_URL` | chaine PostgreSQL de Render | `fromDatabase` dans `render.yaml` |
| `AZO_DB_URL` | URL JDBC complète (prioritaire) | manuel, optionnel |
| `AZO_DB_USER` | compte PostgreSQL | dérivé de `DATABASE_URL` |
| `AZO_DB_PASSWORD` | mot de passe PostgreSQL | dérivé de `DATABASE_URL` |
| `PORT` | port d'écoute Tomcat | Render (défaut 8080 via `render.yaml`) |
| `CATALINA_OPTS` | heap/metaspace + substitution `${…}` | `Dockerfile` + `entrypoint.sh` |

Aucun secret n'est versionné : le `context.xml` livré ne contient que des
`${PLACEHOLDER}`.

---

## 4. Exécuter le conteneur en local

```powershell
cd J:\JAVA\azo-jakarta
docker build -t azo .
docker run --rm -p 8080:8080 `
  -e DATABASE_URL="postgresql://azo:azo@host.docker.internal:5432/azo_java" `
  azo
# → http://localhost:8080/azo
```

(`host.docker.internal` permet au conteneur d'atteindre PostgreSQL installé sur
la machine hôte ; sous Linux, remplacez-le par l'IP de la machine ou `--network host`.)

---

## 5. Mise en production : ce qui reste à faire

1. **Comptes** : le seed crée `admin@azo.bj`, `client@azo.bj`,
   `ouvrier@azo.bj` avec le mot de passe `demo1234`. Sur la base de
   production, changez immédiatement ces mots de passe (ou videz la table
   `"User"` avant le premier démarrage et insérez vos propres comptes —
   `PasswordHasher` produit le même format que le site Next.js).
2. **Bloc « Comptes de pré-configuration »** sous le formulaire de connexion :
   supprimez-le dans `login.jsp` avant diffusion publique.
3. **Persistance** : conservez les sauvegardes Render (*Backups*) du service
   PostgreSQL ; les plans gratuits expirent — surveillez la date d'échéance.
4. **Domaine** : *Settings → Custom Domain* pour passer de
   `<app>.onrender.com` à `azo.bj`.
5. **Mémoire** : l'image est calibrée pour 512 Mo
   (`-Xmx256m -XX:MaxMetaspaceSize=192m`). Sur une instance plus grande,
   vous pouvez élargir ces valeurs dans le `Dockerfile`.

---

## 6. Dépannage

| Symptôme | Cause probable | Remède |
|---|---|---|
| `ERREUR: ni AZO_DB_URL ni DATABASE_URL n'est definis.` au démarrage du conteneur | variable non injectée | vérifiez `envVars` du service et le bloc `databases` de `render.yaml` |
| `Malformed URL` / `The URL "${AZO_DB_URL}" …` au premier accès | substitution `${…}` inactive | le `-D…digester.PROPERTY_SOURCE` manque dans `CATALINA_OPTS` (voir `docker/entrypoint.sh`) |
| `password authentication failed` | mot de passe contenant `@ : /` mal dérivé | définissez `AZO_DB_USER` / `AZO_DB_PASSWORD` explicitement |
| `FATAL: pour le chiffrement SSL non demandé` (ou l'inverse) | exigence TLS de la base | conservez `?sslmode=require` ajouté par l'entrypoint |
| Service « déploiement échoué » puis `port already in use` | `PORT` ≠ port du connecteur | l'entrypoint réécrit `conf/server.xml` : ne l'écrasez pas |
| OOMKilled au démarrage | instance trop petite | 512 Mo minimum, ou baissez `-Xmx` dans le `Dockerfile` |
| PDF vide / `Unable to load report` | `jasperreports-fonts` absent du WAR | reconstruisez avec `mvn package` (voir README) |
| Page de connexion en boucle sur `/login.jsp` | `LoginPageFilter` court-circuité | redéployez le WAR tel quel, ne pas modifier `web.xml` |

---

## 7. Rapports PDF en production

`ReportServlet` (`/rapports/missions`, `/rapports/annuaire`) est protégé par le
même `<security-constraint>` que le tableau de bord : un visiteur non connecté
reçoit la page de connexion, jamais un PDF. La requête SQL des `.jrxml` est
paramétrée par `$P{role}` / `$P{userId}` — un CLIENT ne récupère que ses
missions, un WORKER les siennes, un ADMIN les toutes.
