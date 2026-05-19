<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; min-height: 100vh; background: var(--bg-main); padding: 1.5rem; }
        .auth-card { background: var(--bg-card); border-radius: var(--radius-lg); box-shadow: var(--shadow-lg); display: flex; max-width: 900px; width: 100%; overflow: hidden; border: 1px solid var(--border); }
        .auth-left { flex: 1; background: var(--secondary); padding: 3rem; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; gap: 1.5rem; }
        .auth-left .brand { font-size: 2rem; font-weight: 800; display: flex; align-items: center; gap: 0.5rem; }
        .auth-left .brand i { color: var(--primary); }
        .auth-left p { color: rgba(255,255,255,0.7); text-align: center; font-size: 0.95rem; }
        .auth-right { flex: 1.2; padding: 3rem; }
        .auth-right h2 { font-size: 1.75rem; margin-bottom: 0.4rem; }
        .auth-right .subtitle { color: var(--text-muted); margin-bottom: 2rem; font-size: 0.95rem; }
        @media (max-width: 640px) { .auth-left { display: none; } }
    </style>
</head>
<body>
<div class="auth-card">
    <div class="auth-left">
        <div class="brand"><i class="fas fa-shopping-cart"></i> SmartMart</div>
        <p>Your one-stop department store for quality products at great prices.</p>
        <div style="width:100%; height:180px; background:rgba(255,255,255,0.05); border-radius:var(--radius); display:flex; align-items:center; justify-content:center;">
            <i class="fas fa-store fa-5x" style="color:rgba(255,255,255,0.2);"></i>
        </div>
    </div>
    <div class="auth-right">
        <h2>Welcome Back!</h2>
        <p class="subtitle">Sign in to your account to continue</p>

        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
        <% } %>
        <% if (request.getAttribute("invalid") != null) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${invalid}</div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" class="form-control"
                           placeholder="Enter your email" required
                           style="${emailError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("emailError") != null) { %>
                <small style="color:var(--danger);">${emailError}</small>
                <% } %>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-control"
                           placeholder="Enter your password" required
                           style="${passwordError != null ? 'border-color:var(--danger);' : ''}">
                </div>
                <% if (request.getAttribute("passwordError") != null) { %>
                <small style="color:var(--danger);">${passwordError}</small>
                <% } %>
            </div>
            <button type="submit" class="btn btn-dark" style="width:100%; padding:0.9rem; margin-top:0.5rem;">
                <i class="fas fa-sign-in-alt"></i> Sign In
            </button>
        </form>

        <p style="text-align:center; margin-top:1.5rem; font-size:0.875rem; color:var(--text-muted);">
            Don't have an account?
            <a href="signup.jsp" style="color:var(--primary); font-weight:600;">Register here</a>
        </p>
    </div>
</div>
</body>
</html>
