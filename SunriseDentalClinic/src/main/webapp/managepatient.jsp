<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.patient"%>

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

    ArrayList<patient> patientList =
            (ArrayList<patient>) request.getAttribute("patientList");

    if (patientList == null) {
        response.sendRedirect("managepatient");
        return;
    }

    String searchKeyword = request.getParameter("search");

    if (searchKeyword == null) {
        searchKeyword = "";
    }

    int activePatientCount = 0;

    for (patient p : patientList) {

        String pStatus = p.getStatus();

        if (pStatus == null || pStatus.equalsIgnoreCase("Active")) {
            activePatientCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Manage Patients - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/managepatient.css">

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
           class="nav-item active">

            <span class="nav-icon">♙</span>

            <span>Manage Patients</span>

        </a>


        <a href="manageappointments.jsp"
           class="nav-item">

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

                <h1>Manage Patients</h1>

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
                    ♙
                </div>

                <div>

                    <span class="summary-label">
                        Total Patients
                    </span>

                    <strong>
                        <%= patientList.size() %>
                    </strong>

                </div>

            </div>


            <div class="summary-card">

                <div class="summary-icon icon-active">
                    ✓
                </div>

                <div>

                    <span class="summary-label">
                        Active Patients
                    </span>

                    <strong>
                        <%= activePatientCount %>
                    </strong>

                </div>

            </div>

        </div>


        <div class="table-card">

            <div class="table-header">

                <div class="table-header-top">

                    <div>

                        <h2>Patient List</h2>

                    </div>


                    <a href="patientadd.jsp"
                       class="btn-primary">

                        + Add Patient

                    </a>

                </div>


                <form action="managepatient"
                      method="get"
                      class="search-form">

                    <div class="search-input">

                        <span>🔍</span>

                        <input type="text"
                               name="search"
                               placeholder="Search by ID, name or contact number..."
                               value="<%= searchKeyword %>">

                    </div>


                    <button type="submit"
                            class="btn-search">

                        Search

                    </button>


                    <% if (!searchKeyword.trim().isEmpty()) { %>

                        <a href="managepatient"
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

                        <th>ID</th>

                        <th>Patient Name</th>

                        <th>Address</th>

                        <th>Contact Number</th>

                        <th>Gender</th>

                        <th>Registered Date</th>

                        <th>Status</th>

                        <th>Actions</th>

                    </tr>

                    </thead>


                    <tbody>

                    <%
                        if (patientList.isEmpty()) {
                    %>

                    <tr>

                        <td colspan="8"
                            class="no-data">

                            <div class="empty-icon">
                                ♙
                            </div>

                            <h3>No Patients Found</h3>

                            <p>
                                No patient records match your search.
                            </p>

                        </td>

                    </tr>

                    <%
                        } else {

                            for (patient pat : patientList) {
                    %>

                    <tr>

                        <td>
                            <span class="patient-id">
                                #<%= pat.getP_id() %>
                            </span>
                        </td>


                        <td>

                            <div class="patient-name">

                                <div class="patient-avatar">

                                    <%= pat.getP_name()
                                           .substring(0, 1)
                                           .toUpperCase() %>

                                </div>

                                <strong>
                                    <%= pat.getP_name() %>
                                </strong>

                            </div>

                        </td>


                        <td>
                            <%= pat.getP_address() %>
                        </td>


                        <td>
                            <%= pat.getContact_number() %>
                        </td>


                        <td>

                            <span class="gender">

                                <%= pat.getGender() %>

                            </span>

                        </td>


                        <td>

                            <%
                                if (pat.getRegister_datetime() != null) {
                            %>

                                <%= pat.getRegister_datetime() %>

                            <%
                                } else {
                            %>

                                -

                            <%
                                }
                            %>

                        </td>


                        <td>

                            <%
                                String status = pat.getStatus();

                                if (status == null) {
                                    status = "Active";
                                }

                                String statusClass =
                                    status.equalsIgnoreCase("Active")
                                    ? "status-active"
                                    : "status-inactive";
                            %>

                            <span class="status <%= statusClass %>">

                                <%= status %>

                            </span>

                        </td>


                        <td>

                            <div class="action-buttons">

                                <a href="patientupdate.jsp?id=<%= pat.getP_id() %>"
                                   class="btn-edit">

                                    Edit

                                </a>


                                <a href="patientdelete?id=<%= pat.getP_id() %>"
                                   class="btn-delete"
                                   onclick="return confirmDelete('<%= pat.getP_name() %>');">

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


function confirmDelete(name) {

    return confirm(
        "Are you sure you want to delete patient '" +
        name +
        "'?"
    );

}

</script>


</body>

</html>
