<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="model.appointment"%>
<%@ page import="model.apptreatment"%>

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

    String errorMessage = (String) request.getAttribute("errorMessage");

    appointment app = (appointment) request.getAttribute("appointment");

    ArrayList<apptreatment> treatmentList =
            (ArrayList<apptreatment>) request.getAttribute("treatmentList");

    if (treatmentList == null) {
        treatmentList = new ArrayList<apptreatment>();
    }

    String status = "Pending";
    String statusClass = "status-pending";

    if (app != null) {

        status = app.getStatus();

        if (status == null || status.trim().isEmpty()) {
            status = "Pending";
        }

        if (status.equalsIgnoreCase("Completed")) {
            statusClass = "status-completed";
        } else if (status.equalsIgnoreCase("Cancelled")) {
            statusClass = "status-cancelled";
        } else if (status.equalsIgnoreCase("Confirmed")) {
            statusClass = "status-confirmed";
        } else {
            statusClass = "status-pending";
        }
    }

    BigDecimal totalPrice =
            (app != null && app.getTotalPrice() != null)
                    ? app.getTotalPrice()
                    : BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Appointment Details - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/appointmentview.css">

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

        <div class="nav-section-title">
            Main Menu
        </div>

        <a href="userhome.jsp"
           class="nav-item">

            <span class="nav-icon">⌂</span>

            <span>Dashboard</span>

        </a>


        <a href="managepatient"
           class="nav-item">

            <span class="nav-icon">♙</span>

            <span>Manage Patients</span>

        </a>


        <a href="manageappointment"
           class="nav-item active">

            <span class="nav-icon">▣</span>

            <span>Appointments</span>

        </a>


        <a href="managebills.jsp"
           class="nav-item">

            <span class="nav-icon">$</span>

            <span>Manage Bills</span>

        </a>


        <a href="helpandsupport.jsp"
           class="nav-item">

            <span class="nav-icon">?</span>

            <span>Help & Support</span>

        </a>

    </nav>


    <div class="sidebar-bottom">

        <a href="logout"
           class="logout"
           onclick="return confirmLogout();">

            <span class="nav-icon">↪</span>

            <span>Logout</span>

        </a>

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

                <h1>Appointment Details</h1>

            </div>

        </div>


        <div class="topbar-right">

            <button class="notification"
                    type="button"
                    title="Notifications"
                    onclick="showNotification();">

                🔔

            </button>


            <div class="profile"
                 title="<%= userEmail %>">

                <div class="profile-icon">

                    <%= profileLetter %>

                </div>

                <div class="profile-info">

                    <strong>
                        <%= userName %>
                    </strong>

                </div>

                <span class="profile-arrow">▾</span>

            </div>

        </div>

    </header>


    <section class="page-content">

        <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>

            <div class="alert-error">
                <span class="alert-icon">⚠</span>
                <span><%= errorMessage %></span>
            </div>

            <a href="manageappointment" class="btn-clear">
                ← Back to List
            </a>

        <% } else if (app != null) { %>

        <div class="view-card">

            <div class="view-header">

                <div class="view-header-left">

                    <span class="appointment-no-large">
                        <%= app.getA_number() %>
                    </span>

                    <span class="status <%= statusClass %>">
                        <%= status %>
                    </span>

                </div>

                <div class="view-header-actions">

                    <a href="manageappointment" class="btn-clear">
                        ← Back to List
                    </a>

                    <a href="appointmentupdate.jsp?a_id=<%= app.getA_id() %>"
                       class="btn-primary">

                        Edit Appointment

                    </a>

                    <a href="appointmentdelete?a_id=<%= app.getA_id() %>"
                       class="btn-delete-outline"
                       onclick="return confirmDelete('<%= app.getA_number() %>');">

                        Delete

                    </a>

                </div>

            </div>


            <div class="detail-grid">

                <div class="detail-card">

                    <h3 class="detail-card-title">
                        <span class="detail-icon">▣</span>
                        Appointment Information
                    </h3>

                    <div class="detail-row">
                        <span class="detail-label">Appointment No</span>
                        <span class="detail-value"><%= app.getA_number() %></span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Date & Time</span>
                        <span class="detail-value">
                            <%
                                if (app.getA_datetime() != null) {
                            %>
                                <%= app.getA_datetime() %>
                            <%
                                } else {
                            %>
                                -
                            <%
                                }
                            %>
                        </span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Status</span>
                        <span class="detail-value">
                            <span class="status <%= statusClass %>"><%= status %></span>
                        </span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Total Price</span>
                        <span class="detail-value detail-value-strong">
                            Rs. <%= String.format("%.2f", totalPrice) %>
                        </span>
                    </div>

                </div>


                <div class="detail-card">

                    <h3 class="detail-card-title">
                        <span class="detail-icon">♙</span>
                        Patient Information
                    </h3>

                    <div class="detail-row">
                        <span class="detail-label">Full Name</span>
                        <span class="detail-value"><%= app.getP_name() %></span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Contact Number</span>
                        <span class="detail-value"><%= app.getContact_number() %></span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Address</span>
                        <span class="detail-value">
                            <%
                                if (app.getP_address() != null && !app.getP_address().trim().isEmpty()) {
                            %>
                                <%= app.getP_address() %>
                            <%
                                } else {
                            %>
                                -
                            <%
                                }
                            %>
                        </span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Gender</span>
                        <span class="detail-value">
                            <%
                                if (app.getGender() != null && !app.getGender().trim().isEmpty()) {
                            %>
                                <%= app.getGender() %>
                            <%
                                } else {
                            %>
                                -
                            <%
                                }
                            %>
                        </span>
                    </div>

                </div>


                <div class="detail-card">

                    <h3 class="detail-card-title">
                        <span class="detail-icon">🦷</span>
                        Dentist Information
                    </h3>

                    <div class="detail-row">
                        <span class="detail-label">Dentist Name</span>
                        <span class="detail-value"><%= app.getD_name() %></span>
                    </div>

                </div>

            </div>


            <div class="treatments-card">

                <h3 class="detail-card-title">
                    <span class="detail-icon">$</span>
                    Treatments
                </h3>

                <% if (treatmentList.isEmpty()) { %>

                    <p class="field-hint-plain">
                        No treatments were recorded for this appointment.
                    </p>

                <% } else { %>

                    <div class="treatment-table-container">

                        <table class="treatment-table">

                            <thead>

                            <tr>
                                <th>Treatment</th>
                                <th class="col-price">Price (Rs.)</th>
                            </tr>

                            </thead>

                            <tbody>

                            <%
                                for (apptreatment t : treatmentList) {

                                    BigDecimal price =
                                            t.getPriceLkr() != null ? t.getPriceLkr() : BigDecimal.ZERO;
                            %>

                            <tr>
                                <td><%= t.getT_name() %></td>
                                <td class="col-price">
                                    <%= String.format("%.2f", price) %>
                                </td>
                            </tr>

                            <%
                                }
                            %>

                            </tbody>

                            <tfoot>

                            <tr>
                                <td>Total</td>
                                <td class="col-price">
                                    <%= String.format("%.2f", totalPrice) %>
                                </td>
                            </tr>

                            </tfoot>

                        </table>

                    </div>

                <% } %>

            </div>

        </div>

        <% } %>

    </section>

</main>


<script>

function confirmLogout() {

    return confirm(
        "Are you sure you want to logout?"
    );

}


function showNotification() {

    alert(
        "You currently have no new notifications."
    );

}


function confirmDelete(appointmentNo) {

    return confirm(
        "Are you sure you want to delete appointment '" +
        appointmentNo +
        "'?"
    );

}

</script>


</body>

</html>
