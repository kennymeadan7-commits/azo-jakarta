package bj.azo.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;

import org.bouncycastle.crypto.generators.SCrypt;

/**
 * Hachage des mots de passe au format <b>Node.js</b> : {@code saltHex:hashHex}.
 *
 * <p>Le site existant (Next.js) utilise {@code scryptSync(password, salt, 64)} où
 * {@code salt} est une <b>chaîne hexadécimale</b> que Node convertit en octets en
 * UTF-8 (et non en décodant l'hexadécimal). Pour rester compatible avec les mots de
 * passe déjà en base, ce décodeur reproduit exactement ce comportement :</p>
 *
 * <ul>
 *   <li>N = 16384, r = 8, p = 1 (valeurs par défaut de Node/OpenSSL) ;</li>
 *   <li>sel = octets UTF-8 de la chaîne hexadécimale (32 caractères → 32 octets) ;</li>
 *   <li>dérivé = 64 octets, écrit en hexadécimal minuscule.</li>
 * </ul>
 */
public final class PasswordHasher {

    private static final int N = 16384;
    private static final int R = 8;
    private static final int P = 1;
    private static final int SALT_HEX_LENGTH = 32; // 16 octets en hexadécimal
    private static final int HASH_BYTES = 64;

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final char[] HEX = "0123456789abcdef".toCharArray();

    private PasswordHasher() {
    }

    /**
     * Génère un nouveau hachage {@code saltHex:hashHex}.
     *
     * <p>Le sel transmis à scrypt est bien les octets UTF-8 de la chaîne
     * hexadécimale (et non les octets bruts décodés) : c'est exactement ce que fait
     * {@code scryptSync(password, salt, 64)} côté Node, et c'est ce que
     * {@link #verify(String, String)} recompose. Sans cette cohérence, un hachage
     * produit ici serait invérifiable.</p>
     */
    public static String hash(String password) {
        byte[] saltBytes = new byte[SALT_HEX_LENGTH / 2];
        RANDOM.nextBytes(saltBytes);
        String saltHex = toHex(saltBytes);
        byte[] salt = saltHex.getBytes(StandardCharsets.UTF_8);
        byte[] derived = SCrypt.generate(
                password.getBytes(StandardCharsets.UTF_8), salt, N, R, P, HASH_BYTES);
        return saltHex + ":" + toHex(derived);
    }

    /**
     * Vérifie un mot de passe contre un hachage stocké.
     *
     * @return {@code true} si le mot de passe correspond ; comparaison à temps constant.
     */
    public static boolean verify(String password, String stored) {
        if (password == null || stored == null) {
            return false;
        }
        int separator = stored.indexOf(':');
        if (separator <= 0 || separator == stored.length() - 1) {
            return false;
        }
        String saltHex = stored.substring(0, separator);
        String hashHex = stored.substring(separator + 1);
        if (saltHex.length() != SALT_HEX_LENGTH || hashHex.isEmpty()) {
            return false;
        }

        // Reproduction du comportement de Node : la chaîne hexadécimale est utilisée
        // telle quelle, encodée en UTF-8, comme sel de scrypt.
        byte[] salt = saltHex.getBytes(StandardCharsets.UTF_8);
        byte[] expected = hexToBytes(hashHex);
        if (expected == null) {
            return false;
        }
        byte[] actual = SCrypt.generate(
                password.getBytes(StandardCharsets.UTF_8), salt, N, R, P, expected.length);
        return MessageDigest.isEqual(expected, actual);
    }

    private static String toHex(byte[] bytes) {
        char[] out = new char[bytes.length * 2];
        for (int i = 0; i < bytes.length; i++) {
            int v = bytes[i] & 0xFF;
            out[i * 2] = HEX[v >>> 4];
            out[i * 2 + 1] = HEX[v & 0x0F];
        }
        return new String(out);
    }

    private static byte[] hexToBytes(String hex) {
        if ((hex.length() & 1) != 0) {
            return null;
        }
        byte[] out = new byte[hex.length() / 2];
        for (int i = 0; i < out.length; i++) {
            int hi = Character.digit(hex.charAt(i * 2), 16);
            int lo = Character.digit(hex.charAt(i * 2 + 1), 16);
            if (hi < 0 || lo < 0) {
                return null;
            }
            out[i] = (byte) ((hi << 4) | lo);
        }
        return out;
    }

    /** Efface un mot de passe en mémoire. */
    public static void clear(char[] secret) {
        if (secret != null) {
            Arrays.fill(secret, '\0');
        }
    }
}
