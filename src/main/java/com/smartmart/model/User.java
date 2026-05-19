package com.smartmart.model;

import java.time.LocalDateTime;

/**
 * POJO representing a system user (Admin or Customer).
 */
public class User {
    private int userId;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String phone;
    private String role;              // "Admin" or "User"
    private String approvalStatus;   // "Pending" or "Approved"
    private LocalDateTime createdAt;

    public User() {}

    public User(int userId, String firstName, String lastName,
                String email, String password, String phone,
                String role, String approvalStatus) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.approvalStatus = approvalStatus;
    }

    // ── Getters & Setters ──────────────────────────────────────
    public int getUserId()                        { return userId; }
    public void setUserId(int userId)             { this.userId = userId; }

    public String getFirstName()                  { return firstName; }
    public void setFirstName(String firstName)    { this.firstName = firstName; }

    public String getLastName()                   { return lastName; }
    public void setLastName(String lastName)      { this.lastName = lastName; }

    /** Convenience: firstName + " " + lastName */
    public String getFullName()                   { return firstName + " " + lastName; }

    public String getEmail()                      { return email; }
    public void setEmail(String email)            { this.email = email; }

    public String getPassword()                   { return password; }
    public void setPassword(String password)      { this.password = password; }

    public String getPhone()                      { return phone; }
    public void setPhone(String phone)            { this.phone = phone; }

    public String getRole()                       { return role; }
    public void setRole(String role)              { this.role = role; }

    public String getApprovalStatus()             { return approvalStatus; }
    public void setApprovalStatus(String s)       { this.approvalStatus = s; }

    public LocalDateTime getCreatedAt()           { return createdAt; }
    public void setCreatedAt(LocalDateTime t)     { this.createdAt = t; }
}
