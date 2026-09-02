<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

    ArrayList<appointment> appointmentList =
            (ArrayList<appointment>) request.getAttribute("appointmentList");

    if (appointmentList == null) {
        response.sendRedirect("manageappointment");
        return;
    }

    String searchKeyword = (String) request.getAttribute("searchKeyword");

    if (searchKeyword == null) {
        searchKeyword = "";
    }

    int pendingCount = 0;

    for (appointment a : appointmentList) {

        String s = a.getStatus();

        if (s != null && s.equalsIgnoreCase("Pending")) {
            pendingCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Manage Appointments - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/manageappointments.css">

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


        <a href="managebill"
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

                <h1>Manage Appointments</h1>

                <div class="breadcrumb">

                </div>

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

                <span class="profile-arrow">
                    ▾
                </span>

            </div>

        </div>

    </header>


    <section class="page-content">

        <div class="summary-grid">

            <div class="summary-card">

                <div class="summary-icon icon-total">
                    ▣
                </div>

                <div>

                    <span class="summary-label">
                        Total Appointments
                    </span>

                    <strong>
                        <%= appointmentList.size() %>
                    </strong>

                </div>

            </div>


            <div class="summary-card">

                <div class="summary-icon icon-pending">
                    ⏱
                </div>

                <div>

                    <span class="summary-label">
                        Pending Appointments
                    </span>

                    <strong>
                        <%= pendingCount %>
                    </strong>

                </div>

            </div>

        </div>


        <div class="table-card">

            <div class="table-header">

                <div class="table-header-top">

                    <div>

                        <h2>Appointment List</h2>

                    </div>


                    <a href="appointmentadd"
                       class="btn-primary">

                        + New Appointment

                    </a>

                </div>


                <form action="manageappointment"
                      method="get"
                      class="search-form">

                    <div class="search-input">

                        <span>🔍</span>

                        <input type="text"
                               name="keyword"
                               placeholder="Search by appointment no, patient, dentist or status..."
                               value="<%= searchKeyword %>">

                    </div>


                    <button type="submit"
                            class="btn-search">

                        Search

                    </button>


                    <% if (!searchKeyword.trim().isEmpty()) { %>

                        <a href="manageappointment"
                           class="btn-clear">

                            Clear

                        </a>

                    <% } %>

                </form>

            </div>


            <div class="table-container">

                <table>

                    <thead>

                    <tr>

                        <th>Appointment No</th>
                        <th>Patient</th>
                        <th>Dentist</th>
                        <th>Date & Time</th>
                        <th>Total (Rs.)</th>
                        <th>Status</th>
                        <th>Actions</th>

                    </tr>

                    </thead>


                    <tbody>

                    <%
                        if (appointmentList.isEmpty()) {
                    %>

                    <tr>

                        <td colspan="7"
                            class="no-data">

                            <div class="empty-icon">
                                ▣
                            </div>

                            <h3>No Appointments Found</h3>

                            <p>
                                No appointment records match your search.
                            </p>

                        </td>

                    </tr>

                    <%
                        } else {

                            for (appointment app : appointmentList) {

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

                    <tr>

                        <td>
                            <span class="appointment-no">
                                <%= app.getA_number() %>
                            </span>
                        </td>


                        <td>

                            <div class="patient-name">

                                <div class="patient-avatar">

                                    <%= app.getP_name() != null && !app.getP_name().isEmpty()
                                           ? app.getP_name().substring(0, 1).toUpperCase()
                                           : "?" %>

                                </div>

                                <div>

                                    <strong>
                                        <%= app.getP_name() %>
                                    </strong>

                                    <small>
                                        <%= app.getContact_number() %>
                                    </small>

                                </div>

                            </div>

                        </td>


                        <td>
                            <%= app.getD_name() %>
                        </td>


                        <td>

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

                        </td>


                        <td>
                            Rs. <%= String.format("%.2f",
                                    app.getTotalPrice() != null
                                        ? app.getTotalPrice()
                                        : java.math.BigDecimal.ZERO) %>
                        </td>


                        <td>

                            <span class="status <%= statusClass %>">

                                <%= status %>

                            </span>

                        </td>


                        <td>

                            <div class="action-buttons">

                                <a href="appointmentview?a_id=<%= app.getA_id() %>"
                                   class="btn-view">

                                    View

                                </a>


                                <a href="appointmentupdate?a_id=<%= app.getA_id() %>"
                                   class="btn-edit">

                                    Edit

                                </a>


                                <a href="appointmentdelete?a_id=<%= app.getA_id() %>"
                                   class="btn-delete"
                                   onclick="return confirmDelete('<%= app.getA_number() %>');">

                                    Delete

                                </a>

                            </div>

                        </td>

                    </tr>

                    <%
                            }
                        }
                    %>

                    </tbody>

                </table>

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
