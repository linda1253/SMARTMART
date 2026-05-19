package com.smartmart.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for managing HTTP sessions.
 * Provides safe wrappers around HttpSession operations.
 */
public class SessionUtil {

    /** Session timeout: 30 minutes */
    private static final int SESSION_TIMEOUT_SECONDS = 30 * 60;

    /**
     * Stores an attribute in the session, creating the session if it does not exist.
     *
     * @param request the current HTTP request
     * @param key     attribute name
     * @param value   attribute value
     */
    public static void setAttribute(HttpServletRequest request, String key, Object value) {
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);
        session.setAttribute(key, value);
    }

    /**
     * Retrieves an attribute from the existing session.
     *
     * @param request the current HTTP request
     * @param key     attribute name
     * @return the attribute value, or {@code null} if the session or attribute does not exist
     */
    public static Object getAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        return (session != null) ? session.getAttribute(key) : null;
    }

    /**
     * Removes a single attribute from the session.
     *
     * @param request the current HTTP request
     * @param key     attribute name to remove
     */
    public static void removeAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(key);
        }
    }

    /**
     * Invalidates the current session, logging the user out.
     *
     * @param request the current HTTP request
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
