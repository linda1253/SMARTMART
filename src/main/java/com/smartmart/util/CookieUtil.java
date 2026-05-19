package com.smartmart.util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.Arrays;

/**
 * Utility class for managing HTTP cookies.
 * Provides methods to add, retrieve, and delete cookies.
 */
public class CookieUtil {

    /**
     * Adds a cookie to the response.
     *
     * @param response the HTTP response
     * @param name     cookie name
     * @param value    cookie value
     * @param maxAge   lifetime in seconds (use -1 for session cookie, 0 to delete)
     */
    public static void addCookie(HttpServletResponse response, String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);          // correctly uses the supplied maxAge
        cookie.setPath("/");               // available to the entire application
        cookie.setHttpOnly(true);          // not accessible via JavaScript (security)
        response.addCookie(cookie);
    }

    /**
     * Retrieves a cookie by name from the request.
     *
     * @param request the HTTP request
     * @param name    cookie name to look up
     * @return the matching {@link Cookie}, or {@code null} if not found
     */
    public static Cookie getCookie(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
        return Arrays.stream(cookies)
                .filter(c -> name.equals(c.getName()))
                .findFirst()
                .orElse(null);
    }

    /**
     * Returns the string value of a named cookie, or {@code null} if absent.
     *
     * @param request the HTTP request
     * @param name    cookie name
     * @return cookie value string, or {@code null}
     */
    public static String getCookieValue(HttpServletRequest request, String name) {
        Cookie c = getCookie(request, name);
        return (c != null) ? c.getValue() : null;
    }

    /**
     * Deletes a cookie by setting its max-age to 0.
     *
     * @param response the HTTP response
     * @param name     cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
