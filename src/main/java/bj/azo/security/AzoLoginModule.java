package bj.azo.security;

import java.io.IOException;
import java.security.Principal;
import java.sql.SQLException;
import java.util.Map;

import javax.security.auth.Subject;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.callback.UnsupportedCallbackException;
import javax.security.auth.login.FailedLoginException;
import javax.security.auth.login.LoginException;
import javax.security.auth.spi.LoginModule;

import bj.azo.dao.UserDao;
import bj.azo.model.User;

/**
 * Module de connexion JAAS d'Azɔ.
 *
 * <p>Cycle de vie JAAS :</p>
 * <ol>
 *   <li>{@link #login()} — lit {@code NameCallback}/{@code PasswordCallback} fournis par
 *       {@code JAASRealm}, interroge la table {@code "User"} en <b>JDBC</b> et vérifie le
 *       hachage scrypt ;</li>
 *   <li>{@link #commit()} — injecte {@link AzoPrincipal} (l'utilisateur) et
 *       {@link AzoRole} (son rôle) dans le {@code Subject} ;</li>
 *   <li>{@link #logout()} — retire ces principals.</li>
 * </ol>
 *
 * <p>Une erreur de base de données est remontée en {@link LoginException} (échec de
 * connexion), tandis qu'un identifiant ou un mot de passe invalide l'est en
 * {@link FailedLoginException} : Tomcat traite les deux comme un refus, mais n'en
 * rend pas un « indisponible ».</p>
 */
public class AzoLoginModule implements LoginModule {

    private Subject subject;
    private CallbackHandler callbackHandler;

    private boolean succeeded;
    private boolean commitSucceeded;
    private boolean principalAdded;

    private String username;
    private User user;

    @Override
    public void initialize(Subject subject, CallbackHandler callbackHandler,
            Map<String, ?> sharedState, Map<String, ?> options) {
        this.subject = subject;
        this.callbackHandler = callbackHandler;
    }

    @Override
    public boolean login() throws LoginException {
        if (callbackHandler == null) {
            throw new LoginException("Aucun CallbackHandler fourni à AzoLoginModule");
        }

        NameCallback nameCallback = new NameCallback("Adresse e-mail : ");
        PasswordCallback passwordCallback = new PasswordCallback("Mot de passe : ", false);
        try {
            callbackHandler.handle(new Callback[] {nameCallback, passwordCallback});
        } catch (IOException | UnsupportedCallbackException e) {
            throw new LoginException("Callbacks JAAS non pris en charge : " + e.getMessage());
        }

        username = nameCallback.getName();
        char[] secret = passwordCallback.getPassword();
        passwordCallback.clearPassword();

        if (username == null || username.isBlank() || secret == null || secret.length == 0) {
            PasswordHasher.clear(secret);
            throw new FailedLoginException("Identifiant ou mot de passe vide");
        }

        try {
            UserDao userDao = new UserDao();
            user = userDao.findByEmail(username.trim());

            if (user == null) {
                throw new FailedLoginException("Aucun compte pour cette adresse");
            }
            if (user.isSuspended()) {
                throw new FailedLoginException("Compte suspendu");
            }
            if (!PasswordHasher.verify(new String(secret), user.getPasswordHash())) {
                throw new FailedLoginException("Mot de passe incorrect");
            }
        } catch (SQLException e) {
            // Panne JDBC : distincte d'un refus d'authentification.
            throw new LoginException("Base de données indisponible : " + e.getMessage());
        } finally {
            PasswordHasher.clear(secret);
        }

        succeeded = true;
        return true;
    }

    @Override
    public boolean commit() throws LoginException {
        if (!succeeded) {
            return false;
        }
        if (subject == null) {
            throw new LoginException("Subject JAAS absent");
        }

        // Deux principals distincts : l'utilisateur et son rôle — c'est ce que
        // JAASRealm attend pour remplir request.getUserPrincipal() / isUserInRole().
        Principal userPrincipal = new AzoPrincipal(
                user.getEmail(), user.getId(), user.getName(), user.getRole());
        Principal rolePrincipal = new AzoRole(user.getRole());

        subject.getPrincipals().add(userPrincipal);
        subject.getPrincipals().add(rolePrincipal);
        principalAdded = true;
        commitSucceeded = true;
        return true;
    }

    @Override
    public boolean abort() throws LoginException {
        if (!succeeded) {
            return false;
        }
        cleanup();
        succeeded = false;
        commitSucceeded = false;
        return true;
    }

    @Override
    public boolean logout() throws LoginException {
        cleanup();
        succeeded = false;
        commitSucceeded = false;
        return true;
    }

    private void cleanup() {
        if (principalAdded && subject != null) {
            // Retire exactement les principals ajoutés par ce module.
            for (Principal principal : subject.getPrincipals()) {
                if (principal instanceof AzoPrincipal || principal instanceof AzoRole) {
                    subject.getPrincipals().remove(principal);
                }
            }
        }
        principalAdded = false;
        user = null;
        username = null;
    }
}
