<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("loggedInUser");
    String userEmail = (String) session.getAttribute("userEmail");

    if (userName == null || userName.trim().isEmpty()) {
        response.sendRedirect("userlogin.jsp");
        return;
    }

    String profileLetter = userName.substring(0, 1).toUpperCase();
    if (userEmail == null) { userEmail = ""; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sunrise Dental</title>
    <link rel="stylesheet" href="CSS/userhome.css">
</head>
<body>

<aside class="sidebar">
    <div class="logo">
        <div class="logo-icon">+</div>
        <div class="logo-text">
            <h2>Sunrise Dental</h2>
            <span>Dental Clinic</span>
        </div>
    </div>

    <nav class="navigation">
        <div class="nav-section-title">Main Menu</div>
        <a href="userhome.jsp" class="nav-item active"><span class="nav-icon">⌂</span><span>Dashboard</span></a>
        <a href="manageusers.jsp" class="nav-item"><span class="nav-icon">♙</span><span>Manage Users</span></a>
        <a href="manageappointments.jsp" class="nav-item"><span class="nav-icon">▣</span><span>Appointments</span></a>
        <a href="managebills.jsp" class="nav-item"><span class="nav-icon">$</span><span>Manage Bills</span></a>
        <a href="helpandsupport.jsp" class="nav-item"><span class="nav-icon">?</span><span>Help & Support</span></a>
    </nav>

    <div class="sidebar-bottom">
        <a href="logout" class="logout" onclick="return confirmLogout();"><span class="nav-icon">↪</span><span>Logout</span></a>
    </div>
</aside>

<main class="main-content">

    <header class="topbar">
        <div class="topbar-left">
            <div class="mobile-logo">
                <div class="mobile-logo-icon">+</div>
                <span>Sunrise Dental</span>
            </div>

            <div class="topbar-title">
                <h1>Dashboard</h1>
                <div class="breadcrumb">
                </div>
            </div>
        </div>

        <div class="topbar-right">
            <button class="notification" type="button" title="Notifications" onclick="showNotification();">🔔</button>
            <div class="profile" title="<%= userEmail %>">
                <div class="profile-icon"><%= profileLetter %></div>
                <div class="profile-info">
                    <strong><%= userName %></strong>
                </div>
                <span class="profile-arrow">▾</span>
            </div>
        </div>
    </header>

    <section class="dashboard-content">

        <div class="welcome-section">
            <div class="welcome-content">
                <p class="welcome-small">Welcome back,</p>
                <h1><%= userName %> 👋</h1>
                <p class="welcome-description">Manage your dental appointments, bills and account information from one convenient place.</p>
            </div>
            <div class="welcome-icon">🦷</div>
        </div>

        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon patient-icon">♙</div>
                <div class="stat-info">
                    <span>Total Patients</span>
                    <h2>0</h2>
                    <small>Registered patients</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon appointment-icon">📅</div>
                <div class="stat-info">
                    <span>Total Appointments</span>
                    <h2>0</h2>
                    <small>Scheduled appointments</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon revenue-icon">Rs.</div>
                <div class="stat-info">
                    <span>Total Revenue</span>
                    <h2>Rs. 0.00</h2>
                    <small>Total clinic revenue</small>
                </div>
            </div>
        </div>

        <div class="section-header">
            <div>
                <h2>Quick Actions</h2>
            </div>
        </div>

        <div class="cards-container">
            <a href="manageusers.jsp" class="dashboard-card">
                <div class="card-icon blue-icon">♙</div>
                <div class="card-content">
                    <h3>Manage Users</h3>
                    <p>View and manage your account information and registered user details.</p>
                </div>
                <span class="arrow">→</span>
            </a>

            <a href="manageappointments.jsp" class="dashboard-card">
                <div class="card-icon appointment-card-icon">📅</div>
                <div class="card-content">
                    <h3>Manage Appointments</h3>
                    <p>Book, view and manage your dental appointments.</p>
                </div>
                <span class="arrow">→</span>
            </a>

            <a href="managebills.jsp" class="dashboard-card">
                <div class="card-icon revenue-card-icon">$</div>
                <div class="card-content">
                    <h3>Manage Bills</h3>
                    <p>View dental bills, payment information and billing history.</p>
                </div>
                <span class="arrow">→</span>
            </a>

            <a href="helpandsupport.jsp" class="dashboard-card">
                <div class="card-icon support-card-icon">?</div>
                <div class="card-content">
                    <h3>Help & Support</h3>
                    <p>Get assistance with appointments, payments and dental services.</p>
                </div>
                <span class="arrow">→</span>
            </a>
        </div>


    </section>
</main>

<script>
    function confirmLogout() {
        return confirm("Are you sure you want to logout?");
    }
    function showNotification() {
        alert("You currently have no new notifications.");
    }
</script>

</body>
</html>
