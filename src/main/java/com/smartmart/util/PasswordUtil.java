package com.smartmart.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt.
 *
 * <p>BCrypt is a one-way adaptive hashing algorithm. The work factor (log rounds)
 * controls how computationally expensive the hash is — higher is more secure but slower.
 * A value of 12 is a good balance for 2024+ hardware.</p>
 */
public class PasswordUtil {

    /** BCrypt work factor (log2 of iterations). Range: 4–31. */
    private static final int LOG_ROUNDS = 12;

    /**
     * Hashes a plain-text password using BCrypt.
     *
     * <p>Each call generates a unique salt, so the same password produces
     * a different hash every time — this is expected and correct.</p>
     *
     * @param plainPassword the raw password entered by the user
     * @return a BCrypt hash string (60 characters) safe to store in the database
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(LOG_ROUNDS));
    }

    /**
     * Verifies a plain-text password against a stored BCrypt hash.
     *
     * @param plainPassword  the raw password to check
     * @param hashedPassword the BCrypt hash retrieved from the database
     * @return {@code true} if the password matches the hash, {@code false} otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Malformed hash in DB — treat as mismatch
            return false;
        }
    }
}
