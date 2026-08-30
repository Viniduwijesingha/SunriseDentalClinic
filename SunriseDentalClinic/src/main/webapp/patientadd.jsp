<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Add Patient - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/patientadd.css">

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

                <h1>Add Patient</h1>

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

                    <h2>Add New Patient</h2>

                    <p>
                        Enter the patient's details to register them at Sunrise Dental.
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


            <form action="patientadd"
                  method="post"
                  class="patient-form">

                <div class="form-row">

                    <div class="form-group">

                        <label for="p_name">
                            Patient Name <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="p_name"
                               name="p_name"
                               placeholder="Enter full name"
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

                            <option value=""
                                    disabled
                                    selected
                                    hidden>

                                Select gender

                            </option>

                            <option value="Male">Male</option>

                            <option value="Female">Female</option>

                            <option value="Other">Other</option>

                        </select>

                    </div>


                    <div class="form-group">

                        <label for="status">
                            Status
                        </label>

                        <select id="status"
                                name="status">

                            <option value="Active" selected>Active</option>

                            <option value="Inactive">Inactive</option>

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

                        Save Patient

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
