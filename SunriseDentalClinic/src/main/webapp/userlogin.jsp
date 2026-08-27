<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login - Sunrise Dental</title>
    <link rel="stylesheet" href="CSS/userlogin.css">
</head>
<body>
    <div class="login-container">
        <div class="login-image">
            <div class="image-overlay">
                <h1>Sunrise Dental</h1>
                <p>Your smile is our priority. Book your appointment and manage your dental care easily.</p>
            </div>
        </div>

        <div class="login-form-container">
            <div class="login-form">
                <div class="login-icon">
                    <span>+</span>
                </div>

                <h2>Welcome Back</h2>
                <p class="subtitle">Login to your account</p>

                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <div class="error-message">
                        <%= errorMessage %>
                    </div>
                <%
                    }
                %>

                <form action="userlogin" method="post" id="loginForm">
                    <div class="input-group">
                        <label for="uemail">Email Address</label>
                        <div class="input-wrapper">
                            <span class="input-icon">@</span>
                            <input type="email" id="uemail" name="uemail" placeholder="Enter your email" autocomplete="email" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label for="upassword">Password</label>
                        <div class="password-container">
                            <span class="input-icon">*</span>
                            <input type="password" id="upassword" name="upassword" placeholder="Enter your password" autocomplete="current-password" required>
                            <button type="button" class="show-password" onclick="togglePassword()">Show</button>
                        </div>
                    </div>

                    <div class="login-options">
                        <label class="remember">
                            <input type="checkbox" id="remember" name="remember">
                            <span>Remember me</span>
                        </label>

                        <a href="#">Forgot Password?</a>
                    </div>

                    <button type="submit" class="login-button">Login</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const password = document.getElementById("upassword");
            const button = document.querySelector(".show-password");

            if (password.type === "password") {
                password.type = "text";
                button.textContent = "Hide";
            } else {
                password.type = "password";
                button.textContent = "Show";
            }
        }

        document.getElementById("loginForm").addEventListener("submit", function(event) {
            const email = document.getElementById("uemail").value.trim();
            const password = document.getElementById("upassword").value.trim();

            if (email === "" || password === "") {
                event.preventDefault();
                alert("Please enter your email and password.");
                return;
            }

            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!emailPattern.test(email)) {
                event.preventDefault();
                alert("Please enter a valid email address.");
            }
        });
    </script>
</body>
</html>