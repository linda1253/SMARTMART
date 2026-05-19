<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; min-height: 100vh; background: var(--bg-main); padding: 2rem 1.5rem; }
        .auth-card { background: var(--bg-card); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); display: flex; max-width: 1000px; width: 100%; overflow: hidden; border: 1px solid var(--border); }
        .auth-left { flex: 1; background: var(--secondary); padding: 3rem; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; gap: 1.5rem; }
        .auth-left .brand { font-size: 2rem; font-weight: 800; display: flex; align-items: center; gap: 0.5rem; }
        .auth-left .brand i { color: var(--primary); }
        .auth-left ul { list-style: none; }
        .auth-left ul li { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem; color: rgba(255,255,255,0.85); font-size: 0.9rem; }
        .auth-left ul li i { color: var(--primary); }
        .auth-right { flex: 1.4; padding: 3rem; }
        .auth-right h2 { font-size: 1.75rem; margin-bottom: 0.4rem; }
        .auth-right .subtitle { color: var(--text-muted); margin-bottom: 2rem; font-size: 0.95rem; }
        @media (max-width: 640px) { .auth-left { display: none; } }
    </style>
</head>
<body>
<div class="auth-card">
    <div class="auth-left">
        <div class="brand"><i class="fas fa-shopping-cart"></i> SmartMart</div>
        <div>
            <h3 style="color:white; margin-bottom:1rem;">Why Join SmartMart?</h3>
            <ul>
                <li><i class="fas fa-check-circle"></i> Quality products at best prices</li>
                <li><i class="fas fa-check-circle"></i> Easy and secure shopping</li>
                <li><i class="fas fa-check-circle"></i> Fast delivery to your door</li>
                <li><i class="fas fa-check-circle"></i> 24/7 customer support</li>
                <li><i class="fas fa-check-circle"></i> Easy returns & refunds</li>
            </ul>
        </div>
    </div>
    <div class="auth-right">
        <h2>Create Account</h2>
        <p class="subtitle">Fill in the details below to get started</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        <% } %>

        <form action="signup" method="post">
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <div class="input-with-icon">
                    <i class="fas fa-user"></i>
                    <input type="text" name="fullName" class="form-control"
                           placeholder="First and Last name" required
                           style="${nameError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("nameError") != null) { %>
                <small style="color:var(--danger);">${nameError}</small>
                <% } %>
            </div>
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" class="form-control"
                           placeholder="your@email.com" required
                           style="${emailError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("emailError") != null) { %>
                <small style="color:var(--danger);">${emailError}</small>
                <% } %>
            </div>
            <div class="form-group">
                <label class="form-label">Phone Number</label>
                <div class="input-with-icon">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="phone" class="form-control"
                           placeholder="98XXXXXXXX" required
                           style="${phoneError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("phoneError") != null) { %>
                <small style="color:var(--danger);">${phoneError}</small>
                <% } %>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-control"
                           placeholder="Min. 8 characters" required
                           style="${passwordError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("passwordError") != null) { %>
                <small style="color:var(--danger);">${passwordError}</small>
                <% } %>
            </div>
            <div class="form-group">
                <label class="form-label">Confirm Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="confirmPassword" class="form-control"
                           placeholder="Re-enter password" required
                           style="${confirmError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("confirmError") != null) { %>
                <small style="color:var(--danger);">${confirmError}</small>
                <% } %>
            </div>
            <button type="submit" class="btn btn-dark" style="width:100%; padding:0.9rem; margin-top:0.5rem;">
                <i class="fas fa-user-plus"></i> Create Account
            </button>
        </form>

        <p style="text-align:center; margin-top:1.5rem; font-size:0.875rem; color:var(--text-muted);">
            Already have an account?
            <a href="login.jsp" style="color:var(--primary); font-weight:600;">Sign in here</a>
        </p>
    </div>
</div>
</body>
</html>
