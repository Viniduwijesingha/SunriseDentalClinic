<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.apptreatment"%>
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

    appointment app = (appointment) request.getAttribute("appointment");

    if (app == null) {
        response.sendRedirect("managebill");
        return;
    }

    ArrayList<apptreatment> treatmentList =
            (ArrayList<apptreatment>) request.getAttribute("treatmentList");

    if (treatmentList == null) {
        treatmentList = new ArrayList<apptreatment>();
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String appointmentDateTime =
            app.getA_datetime() != null
                    ? dateTimeFormat.format(app.getA_datetime())
                    : "-";

    String issuedToday = dateFormat.format(new java.util.Date());

    BigDecimal total = app.getTotalPrice() != null ? app.getTotalPrice() : BigDecimal.ZERO;

    String status = app.getStatus();

    if (status == null || status.trim().isEmpty()) {
        status = "Pending";
    }

    String statusClass;

    if (status.equalsIgnoreCase("Completed")) {
        statusClass = "status-completed";
    } else if (status.equalsIgnoreCase("Cancelled")) {
        statusClass = "status-cancelled";
    } else if (status.equalsIgnoreCase("Confirmed")) {
        statusClass = "status-confirmed";
    } else {
        statusClass = "status-pending";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Bill - <%= app.getA_number() %> - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/billprint.css">

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
           class="nav-item">

            <span class="nav-icon">▣</span>

            <span>Appointments</span>

        </a>


        <a href="managebill"
           class="nav-item active">

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

                <h1>Bill Preview</h1>

            </div>

        </div>


        <div class="topbar-right">

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

            </div>

        </div>

    </header>

    <section class="page-content">

        <div class="invoice-wrap">

            <div class="invoice-actions">

                <a href="managebill" class="btn-clear">
                    ← Back to Bills
                </a>

                <button type="button"
                        class="btn-primary"
                        onclick="window.print();">

                    🖨 Print Bill

                </button>

            </div>

            <div class="invoice-sheet">

                <div class="invoice-header">

                    <div class="clinic-info">

                        <div class="clinic-name">
                            <span class="clinic-logo">+</span>
                            Sunrise Dental
                        </div>

                        <p>Dental Clinic</p>
                        <p>No. 45, Lake Road, Colombo, Sri Lanka</p>
                        <p>+94 11 234 5678 &nbsp;•&nbsp; hello@sunrisedental.lk</p>

                    </div>

                    <div class="invoice-meta">

                        <h1>BILL</h1>

                        <p><strong>Bill Ref</strong> <%= app.getA_number() %></p>
                        <p><strong>Issued</strong> <%= issuedToday %></p>

                        <span class="status-tag <%= statusClass %>">
                            <%= status %>
                        </span>

                    </div>

                </div>

                <div class="invoice-parties">

                    <div class="party-block">

                        <span class="party-label">Billed To</span>

                        <strong><%= app.getP_name() %></strong>

                        <p>
                            <%= app.getP_address() != null && !app.getP_address().isEmpty()
                                    ? app.getP_address() : "-" %>
                        </p>

                        <p><%= app.getContact_number() %></p>

                    </div>

                    <div class="party-block">

                        <span class="party-label">Appointment</span>

                        <strong><%= app.getD_name() %></strong>

                        <p>Attending Dentist</p>

                        <p><%= appointmentDateTime %></p>

                    </div>

                </div>

                <table class="invoice-table">

                    <thead>

                    <tr>

                        <th class="col-no">#</th>
                        <th>Treatment</th>
                        <th class="align-right">Price (Rs.)</th>

                    </tr>

                    </thead>

                    <tbody>

                    <%
                        if (treatmentList.isEmpty()) {
                    %>

                    <tr>

                        <td colspan="3" class="no-items">
                            No treatments recorded for this appointment.
                        </td>

                    </tr>

                    <%
                        } else {

                            int rowNumber = 1;

                            for (apptreatment t : treatmentList) {

                                BigDecimal price =
                                        t.getPriceLkr() != null ? t.getPriceLkr() : BigDecimal.ZERO;
                    %>

                    <tr>

                        <td class="col-no"><%= rowNumber %></td>
                        <td><%= t.getT_name() %></td>
                        <td class="align-right"><%= String.format("%.2f", price) %></td>

                    </tr>

                    <%
                                rowNumber++;
                            }
                        }
                    %>

                    </tbody>

                </table>


                <div class="invoice-summary">

                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span>Rs. <%= String.format("%.2f", total) %></span>
                    </div>

                    <div class="summary-row total-row">
                        <span>Total Amount</span>
                        <span>Rs. <%= String.format("%.2f", total) %></span>
                    </div>

                </div>

                <div class="invoice-footer">

                    <p>Thank you for choosing Sunrise Dental Clinic.</p>
                    <p>This is a system-generated bill and does not require a signature.</p>

                </div>

            </div>

        </div>

    </section>

</main>

<script>

function confirmLogout() {

    return confirm(
        "Are you sure you want to logout?"
    );

}

</script>

</body>

</html>
