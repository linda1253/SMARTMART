package com.smartmart.util;

import java.util.regex.Pattern;
import jakarta.servlet.http.Part;

/**
 * Utility class providing input validation methods used across servlets.
 */
public class ValidationUtil {

    /**
     * Returns {@code true} if any of the supplied strings is null or blank.
     *
     * @param values one or more strings to check
     * @return {@code true} if at least one value is null/empty
     */
    public static boolean isNullOrEmpty(String... values) {
        for (String v : values) {
            if (v == null || v.trim().isEmpty()) return true;
        }
        return false;
    }

    /**
     * Returns {@code true} if the string contains only ASCII letters (a-z, A-Z).
     *
     * @param value string to test
     * @return {@code true} if alphabetic
     */
    public static boolean isAlphabetic(String value) {
        return value != null && value.matches("^[a-zA-Z]+$");
    }

    /**
     * Returns {@code true} if the string starts with a letter and contains only
     * letters and digits.
     *
     * @param value string to test
     * @return {@code true} if alphanumeric starting with a letter
     */
    public static boolean isAlphanumericStartingWithLetter(String value) {
        return value != null && value.matches("^[a-zA-Z][a-zA-Z0-9]*$");
    }

    /**
     * Returns {@code true} if the string is a valid email address.
     *
     * @param email email string to validate
     * @return {@code true} if valid email format
     */
    public static boolean isValidEmail(String email) {
        String regex = "^[\\w\\-\\.]+@([\\w\\-]+\\.)+[\\w\\-]{2,4}$";
        return email != null && Pattern.matches(regex, email);
    }

    /**
     * Returns {@code true} if the phone number is a valid Nepal mobile number
     * (starts with 97 or 98, exactly 10 digits).
     *
     * @param number phone number string
     * @return {@code true} if valid Nepal mobile format
     */
    public static boolean isValidPhoneNumber(String number) {
        return number != null && number.matches("^(98|97)\\d{8}$");
    }

    /**
     * Returns {@code true} if the password is at least 8 characters long.
     *
     * @param password password string
     * @return {@code true} if password meets minimum length
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8;
    }

    /**
     * Returns {@code true} if the two password strings are equal.
     *
     * @param password        original password
     * @param confirmPassword confirmation password
     * @return {@code true} if they match
     */
    public static boolean doPasswordsMatch(String password, String confirmPassword) {
        return password != null && password.equals(confirmPassword);
    }

    /**
     * Returns {@code true} if the uploaded file part has an image extension
     * (jpg, jpeg, png, gif).
     *
     * @param imagePart the multipart file part
     * @return {@code true} if the file extension is a supported image type
     */
    public static boolean isValidImageExtension(Part imagePart) {
        if (imagePart == null || isNullOrEmpty(imagePart.getSubmittedFileName())) return false;
        String name = imagePart.getSubmittedFileName().toLowerCase();
        return name.endsWith(".jpg") || name.endsWith(".jpeg")
            || name.endsWith(".png") || name.endsWith(".gif");
    }

    /**
     * Returns {@code true} if the string represents a positive number.
     *
     * @param value string to test
     * @return {@code true} if parseable as a positive double
     */
    public static boolean isPositiveNumber(String value) {
        if (isNullOrEmpty(value)) return false;
        try {
            return Double.parseDouble(value) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Returns {@code true} if the string represents a non-negative integer.
     *
     * @param value string to test
     * @return {@code true} if parseable as a non-negative integer
     */
    public static boolean isNonNegativeInt(String value) {
        if (isNullOrEmpty(value)) return false;
        try {
            return Integer.parseInt(value) >= 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
