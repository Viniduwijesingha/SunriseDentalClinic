<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.dentist"%>
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

    String errorMessage = (String) request.getAttribute("errorMessage");

    appointment app = (appointment) request.getAttribute("appointment");

    if (app == null) {
        response.sendRedirect("manageappointment");
        return;
    }

    ArrayList<dentist> dentistList =
            (ArrayList<dentist>) request.getAttribute("dentistList");

    if (dentistList == null) {
        dentistList = new ArrayList<dentist>();
    }

    ArrayList<apptreatment> treatmentList =
            (ArrayList<apptreatment>) request.getAttribute("treatmentList");

    if (treatmentList == null) {
        treatmentList = new ArrayList<apptreatment>();
    }

    ArrayList<Integer> selectedTreatmentIds =
            (ArrayList<Integer>) request.getAttribute("selectedTreatmentIds");

    if (selectedTreatmentIds == null) {
        selectedTreatmentIds = new ArrayList<Integer>();
    }

    Set<Integer> selectedTreatmentIdSet =
            new HashSet<Integer>(selectedTreatmentIds);

    String oldDentistId = String.valueOf(app.getD_id());

    String oldStatus = app.getStatus();

    if (oldStatus == null || oldStatus.trim().isEmpty()) {
        oldStatus = "Pending";
    }

    String submittedDateTime = (String) request.getAttribute("submittedDateTime");

    String oldDateTime;

    if (submittedDateTime != null) {

        oldDateTime = submittedDateTime;

    } else if (app.getA_datetime() != null) {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        oldDateTime = sdf.format(app.getA_datetime());

    } else {

        oldDateTime = "";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Edit Appointment - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/appointmentupdate.css">

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

                <h1>Edit Appointment</h1>

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

        <div class="form-card">

            <div class="form-header">

                <div class="form-header-top">

                    <div>

                        <h2>Edit Appointment <span class="appointment-no-tag"><%= app.getA_number() %></span></h2>

                        <p>
                            Update the dentist, schedule, status or
                            treatments for this appointment.
                        </p>

                    </div>

                    <div class="header-actions">

                        <a href="appointmentview?a_id=<%= app.getA_id() %>" class="btn-clear">
                            View Appointment
                        </a>

                        <a href="manageappointment" class="btn-clear">
                            ← Back to List
                        </a>

                    </div>

                </div>

                <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>

                    <div class="alert-error">
                        <span class="alert-icon">⚠</span>
                        <span><%= errorMessage %></span>
                    </div>

                <% } %>

                <% if (dentistList.isEmpty()) { %>

                    <div class="alert-warning">
                        <span class="alert-icon">ⓘ</span>
                        <span>
                            No dentists found. Please add a dentist before
                            saving changes.
                        </span>
                    </div>

                <% } %>

            </div>


            <form action="appointmentupdate"
                  method="post"
                  id="appointmentForm">

                <input type="hidden" name="a_id" value="<%= app.getA_id() %>">
                <input type="hidden" name="p_id" value="<%= app.getP_id() %>">


                <!-- ===================== PATIENT (READ ONLY) ===================== -->

                <div class="form-section">

                    <div class="form-section-title">
                        <span class="step-badge">1</span>
                        <h3>Patient</h3>
                    </div>

                    <p class="field-hint">
                        <span class="badge badge-blue">Existing patient</span>
                        Patient details are locked here. To change them,
                        edit the patient from Manage Patients.
                    </p>

                    <div class="form-row">

                        <div class="form-group">

                            <label>Full Name</label>

                            <input type="text"
                                   value="<%= app.getP_name() != null ? app.getP_name() : "" %>"
                                   readonly>

                        </div>

                        <div class="form-group">

                            <label>Contact Number</label>

                            <input type="text"
                                   value="<%= app.getContact_number() != null ? app.getContact_number() : "" %>"
                                   readonly>

                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label>Address</label>

                            <input type="text"
                                   value="<%= app.getP_address() != null ? app.getP_address() : "" %>"
                                   readonly>

                        </div>

                        <div class="form-group">

                            <label>Gender</label>

                            <input type="text"
                                   value="<%= app.getGender() != null ? app.getGender() : "" %>"
                                   readonly>

                        </div>

                    </div>

                </div>


                <div class="form-section">

                    <div class="form-section-title">
                        <span class="step-badge">2</span>
                        <h3>Appointment details</h3>
                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label for="a_number_display">Appointment No</label>

                            <input type="text"
                                   id="a_number_display"
                                   value="<%= app.getA_number() %>"
                                   readonly>

                        </div>

                        <div class="form-group">

                            <label for="a_datetime">Date & Time <span class="required">*</span></label>

                            <input type="datetime-local"
                                   id="a_datetime"
                                   name="a_datetime"
                                   value="<%= oldDateTime %>"
                                   required>

                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label for="d_id">Dentist <span class="required">*</span></label>

                            <select id="d_id" name="d_id" required>

                                <option value=""
                                        disabled
                                        <%= oldDentistId.equals("0") ? "selected" : "" %>
                                        hidden>

                                    Select dentist

                                </option>

                                <%
                                    for (dentist d : dentistList) {

                                        String dIdStr = String.valueOf(d.getD_id());

                                        boolean isSelected = dIdStr.equals(oldDentistId);

                                        String specialization = d.getSpecialization();

                                        String label = d.getD_name();

                                        if (specialization != null && !specialization.trim().isEmpty()) {
                                            label += " - " + specialization;
                                        }
                                %>

                                <option value="<%= dIdStr %>" <%= isSelected ? "selected" : "" %>>
                                    <%= label %>
                                </option>

                                <%
                                    }
                                %>

                            </select>

                        </div>

                        <div class="form-group">

                            <label for="status">Status</label>

                            <select id="status" name="status">

                                <option value="Pending" <%= "Pending".equalsIgnoreCase(oldStatus) ? "selected" : "" %>>
                                    Pending
                                </option>

                                <option value="Confirmed" <%= "Confirmed".equalsIgnoreCase(oldStatus) ? "selected" : "" %>>
                                    Confirmed
                                </option>

                                <option value="Completed" <%= "Completed".equalsIgnoreCase(oldStatus) ? "selected" : "" %>>
                                    Completed
                                </option>

                                <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(oldStatus) ? "selected" : "" %>>
                                    Cancelled
                                </option>

                            </select>

                        </div>

                    </div>

                </div>


                <div class="form-section form-section-last">

                    <div class="form-section-title">
                        <span class="step-badge">3</span>
                        <h3>Treatments</h3>
                    </div>

                    <% if (treatmentList.isEmpty()) { %>

                        <p class="field-hint-plain">
                            No treatments have been set up yet.
                        </p>

                    <% } else { %>

                        <div class="treatment-grid">

                            <%
                                for (apptreatment t : treatmentList) {

                                    boolean isChecked = selectedTreatmentIdSet.contains(t.getT_id());

                                    BigDecimal price =
                                            t.getPriceLkr() != null ? t.getPriceLkr() : BigDecimal.ZERO;
                            %>

                            <label class="treatment-item">

                                <input type="checkbox"
                                       name="treatmentIds"
                                       value="<%= t.getT_id() %>"
                                       data-price="<%= price.toPlainString() %>"
                                       class="treatment-checkbox"
                                       <%= isChecked ? "checked" : "" %>>

                                <span class="treatment-name"><%= t.getT_name() %></span>

                                <span class="treatment-price">
                                    Rs. <%= String.format("%.2f", price) %>
                                </span>

                            </label>

                            <%
                                }
                            %>

                        </div>

                    <% } %>

                    <div class="treatment-total">
                        <span>Total Price</span>
                        <strong id="totalPrice">Rs. 0.00</strong>
                    </div>

                </div>


                <div class="form-actions">

                    <a href="manageappointment" class="btn-clear">Cancel</a>

                    <button type="submit" class="btn-primary btn-large">
                        Update Appointment
                    </button>

                </div>

            </form>

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


// -------------------- Treatment total --------------------

function recalcTotal() {

    var checkboxes = document.querySelectorAll(".treatment-checkbox");

    var total = 0;

    checkboxes.forEach(function (box) {
        if (box.checked) {
            total += parseFloat(box.getAttribute("data-price")) || 0;
        }
    });

    document.getElementById("totalPrice").textContent = "Rs. " + total.toFixed(2);
}

document.querySelectorAll(".treatment-checkbox").forEach(function (box) {
    box.addEventListener("change", recalcTotal);
});

recalcTotal();

</script>


</body>

</html>
