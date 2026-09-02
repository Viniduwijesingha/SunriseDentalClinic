<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.appointment"%>

<%
    String userName = (String) session.getAttribute("loggedInUser");
    String userEmail = (String) session.getAttribute("userEmail");

    if (userName == null || userName.trim().isEmpty()) {
        response.sendRedirect("userlogin.jsp");
        return;
    }

    if (userEmail == null) {
        userEmail = "";
    }

    String profileLetter = userName.substring(0, 1).toUpperCase();

    Integer totalPatients = (Integer) request.getAttribute("totalPatients");

    if (totalPatients == null) {
        response.sendRedirect("userhome");
        return;
    }

    Integer activePatients = (Integer) request.getAttribute("activePatients");
    Integer totalAppointments = (Integer) request.getAttribute("totalAppointments");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");

    ArrayList<appointment> recentAppointments =
            (ArrayList<appointment>) request.getAttribute("recentAppointments");

    if (activePatients == null) { activePatients = 0; }
    if (totalAppointments == null) { totalAppointments = 0; }
    if (totalRevenue == null) { totalRevenue = BigDecimal.ZERO; }
    if (recentAppointments == null) { recentAppointments = new ArrayList<appointment>(); }
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
        <a href="userhome" class="nav-item active"><span class="nav-icon">⌂</span><span>Dashboard</span></a>
        <a href="managepatient" class="nav-item"><span class="nav-icon">♙</span><span>Manage Patients</span></a>
        <a href="manageappointment" class="nav-item"><span class="nav-icon">▣</span><span>Appointments</span></a>
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
            </div>
        </div>

        <div class="topbar-right">

            <form action="managepatient" method="get" class="search-box">
                <span>🔍</span>
                <input type="text" name="search" placeholder="Quick search patients...">
            </form>

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
                <h2><%= userName %> 👋</h2>
                <br>
                <p class="welcome-description">Manage your dental appointments, bills and account information from one convenient place.</p>
            </div>
            <div class="welcome-icon">🦷</div>
        </div>

        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon patient-icon">♙</div>
                <div class="stat-info">
                    <span>Total Patients</span>
                    <h2><%= totalPatients %></h2>
                    <small><%= activePatients %> active</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon appointment-icon">📅</div>
                <div class="stat-info">
                    <span>Total Appointments</span>
                    <h2><%= totalAppointments %></h2>
                    <small>All scheduled appointments</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon revenue-icon">Rs.</div>
                <div class="stat-info">
                    <span>Billable Revenue</span>
                    <h2>Rs. <%= String.format("%,.2f", totalRevenue) %></h2>
                    <small>Total amount billed across all appointments</small>
                </div>
            </div>
        </div>

        <div class="section-header">
            <div>
                <h2>Quick Actions</h2>
            </div>
        </div>

        <div class="cards-container">
            <a href="managepatient" class="dashboard-card">
                <div class="card-icon blue-icon">♙</div>
                <div class="card-content">
                    <h3>Manage Patients</h3>
                    <p>View and manage registered patient details.</p>
                </div>
                <span class="arrow">→</span>
            </a>

            <a href="manageappointment" class="dashboard-card">
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


        <div class="section-header">
            <div>
                <h2>Recent Appointments</h2>
            </div>
            <a href="manageappointment" class="btn-primary">View All</a>
        </div>

        <div class="dashboard-table">

            <table>

                <thead>
                    <tr>
                        <th>Appointment No</th>
                        <th>Patient</th>
                        <th>Dentist</th>
                        <th>Date & Time</th>
                        <th>Total (Rs.)</th>
                        <th>Status</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (recentAppointments.isEmpty()) { %>

                        <tr>
                            <td colspan="6" style="text-align:center; padding: 26px; color:#94a3b8;">
                                No appointments booked yet.
                            </td>
                        </tr>

                    <% } else {

                        for (appointment app : recentAppointments) {

                            String status = app.getStatus();

                            if (status == null || status.trim().isEmpty()) {
                                status = "Pending";
                            }

                            String statusClass;

                            if (status.equalsIgnoreCase("Completed") ||
                                    status.equalsIgnoreCase("Confirmed")) {

                                statusClass = "status-success";

                            } else if (status.equalsIgnoreCase("Cancelled")) {

                                statusClass = "status-cancelled";

                            } else {

                                statusClass = "status-pending";
                            }
                    %>

                        <tr>
                            <td><%= app.getA_number() %></td>
                            <td><%= app.getP_name() %></td>
                            <td><%= app.getD_name() %></td>
                            <td><%= app.getA_datetime() != null ? app.getA_datetime() : "-" %></td>
                            <td>
                                <%= app.getTotalPrice() != null
                                        ? String.format("%.2f", app.getTotalPrice())
                                        : "0.00" %>
                            </td>
                            <td><span class="status <%= statusClass %>"><%= status %></span></td>
                        </tr>

                    <%  }
                        } %>

                </tbody>

            </table>

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
