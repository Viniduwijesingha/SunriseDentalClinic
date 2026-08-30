<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

    patient pat = (patient) request.getAttribute("patient");

    if (pat == null) {
        response.sendRedirect("managepatient");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");

    String currentGender = pat.getGender();
    String currentStatus = pat.getStatus();

    if (currentStatus == null || currentStatus.trim().isEmpty()) {
        currentStatus = "Active";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Update Patient - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/patientupdate.css">

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

                <h1>Update Patient</h1>

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

        <div class="form-card">

            <div class="form-header">

                <div>

                    <h2>
                        Update Patient
                        <span class="patient-id-tag">
                            #<%= pat.getP_id() %>
                        </span>
                    </h2>

                    <p>
                        Edit the patient's details and save your changes.
                    </p>

                </div>

                <a href="managepatient"
                   class="btn-secondary">

                    ← Back to List

                </a>

            </div>


            <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>

                <div class="alert-error">
                    <%= errorMessage %>
                </div>

            <% } %>


            <form action="patientupdate"
                  method="post"
                  class="patient-form">

                <input type="hidden"
                       name="p_id"
                       value="<%= pat.getP_id() %>">


                <div class="form-row">

                    <div class="form-group">

                        <label for="p_name">
                            Patient Name <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="p_name"
                               name="p_name"
                               placeholder="Enter full name"
                               value="<%= pat.getP_name() != null ? pat.getP_name() : "" %>"
                               required>

                    </div>


                    <div class="form-group">

                        <label for="contact_number">
                            Contact Number <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="contact_number"
                               name="contact_number"
                               placeholder="e.g. 0771234567"
                               pattern="[0-9]{10}"
                               title="Enter a valid 10-digit contact number"
                               value="<%= pat.getContact_number() != null ? pat.getContact_number() : "" %>"
                               required>

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group form-group-full">

                        <label for="p_address">
                            Address <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="p_address"
                               name="p_address"
                               placeholder="Enter home address"
                               value="<%= pat.getP_address() != null ? pat.getP_address() : "" %>"
                               required>

                    </div>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label for="gender">
                            Gender <span class="required">*</span>
                        </label>

                        <select id="gender"
                                name="gender"
                                required>

                            <option value="Male"
                                    <%= "Male".equalsIgnoreCase(currentGender) ? "selected" : "" %>>

                                Male

                            </option>

                            <option value="Female"
                                    <%= "Female".equalsIgnoreCase(currentGender) ? "selected" : "" %>>

                                Female

                            </option>

                            <option value="Other"
                                    <%= "Other".equalsIgnoreCase(currentGender) ? "selected" : "" %>>

                                Other

                            </option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label for="status">
                            Status
                        </label>

                        <select id="status"
                                name="status">

                            <option value="Active"
                                    <%= "Active".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>

                                Active

                            </option>

                            <option value="Inactive"
                                    <%= "Inactive".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>

                                Inactive

                            </option>

                        </select>

                    </div>

                </div>


                <div class="form-actions">

                    <a href="managepatient"
                       class="btn-cancel">

                        Cancel

                    </a>

                    <button type="submit"
                            class="btn-primary">

                        Save Changes

                    </button>

                </div>

            </form>

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

</script>


</body>

</html>
