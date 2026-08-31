<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="model.dentist"%>
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

    String nextAppointmentNumber =
            (String) request.getAttribute("nextAppointmentNumber");

    if (nextAppointmentNumber == null) {
        nextAppointmentNumber = "APT-0001";
    }

    // Re-populate previously submitted values on validation error.
    String oldPatientId = request.getParameter("p_id");
    String oldPName = request.getParameter("p_name");
    String oldPAddress = request.getParameter("p_address");
    String oldContact = request.getParameter("contact_number");
    String oldGender = request.getParameter("gender");
    String oldDentistId = request.getParameter("d_id");
    String oldDateTime = request.getParameter("a_datetime");
    String oldStatus = request.getParameter("status");
    String[] oldTreatmentIds = request.getParameterValues("treatmentIds");

    if (oldPatientId == null) { oldPatientId = ""; }
    if (oldPName == null) { oldPName = ""; }
    if (oldPAddress == null) { oldPAddress = ""; }
    if (oldContact == null) { oldContact = ""; }
    if (oldGender == null) { oldGender = ""; }
    if (oldDentistId == null) { oldDentistId = ""; }
    if (oldDateTime == null) { oldDateTime = ""; }
    if (oldStatus == null || oldStatus.trim().isEmpty()) { oldStatus = "Pending"; }

    boolean isExistingPatient = !oldPatientId.trim().isEmpty();

    java.util.Set<String> oldTreatmentIdSet = new java.util.HashSet<String>();

    if (oldTreatmentIds != null) {
        for (String id : oldTreatmentIds) {
            oldTreatmentIdSet.add(id);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>New Appointment - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/appointmentadd.css">

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

                <h1>New Appointment</h1>

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

                        <h2>Schedule New Appointment</h2>

                        <p>
                            Search for the patient first. If they're not
                            registered yet, add their details right here.
                        </p>

                    </div>

                    <a href="manageappointment" class="btn-clear">
                        ← Back to List
                    </a>

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
                            scheduling an appointment.
                        </span>
                    </div>

                <% } %>

            </div>


            <form action="appointmentadd"
                  method="post"
                  id="appointmentForm">

                <input type="hidden" id="p_id" name="p_id" value="<%= oldPatientId %>">


                <!-- ===================== PATIENT LOOKUP ===================== -->

                <div class="form-section">

                    <div class="form-section-title">
                        <span class="step-badge">1</span>
                        <h3>Find the patient</h3>
                    </div>

                    <div class="lookup-row">

                        <div class="search-input lookup-input">

                            <span>🔍</span>

                            <input type="text"
                                   id="lookupQuery"
                                   placeholder="Search by name or phone number">

                        </div>

                        <button type="button" id="lookupBtn" class="btn-search">
                            Check Patient
                        </button>

                    </div>

                    <div id="lookupResults" class="lookup-results"></div>

                    <div id="lookupStatus" class="lookup-status"></div>

                </div>


                <!-- ===================== PATIENT DETAILS ===================== -->

                <div class="form-section">

                    <div class="form-section-title">

                        <span class="step-badge">2</span>
                        <h3>Patient details</h3>

                        <a href="#"
                           id="newPatientLink"
                           class="link-reset <%= isExistingPatient ? "" : "hidden" %>">

                            Not this patient? Register a new one

                        </a>

                    </div>

                    <p id="patientModeHint" class="field-hint">

                        <%
                            if (isExistingPatient) {
                        %>
                            <span class="badge badge-blue">Existing patient</span>
                            Details below are locked.
                        <%
                            } else {
                        %>
                            <span class="badge badge-grey">New patient</span>
                            Fill in the fields below to register, or search above.
                        <%
                            }
                        %>

                    </p>

                    <div class="form-row">

                        <div class="form-group">

                            <label for="p_name">Full Name <span class="required">*</span></label>

                            <input type="text"
                                   id="p_name"
                                   name="p_name"
                                   placeholder="e.g. Nimal Perera"
                                   value="<%= oldPName %>"
                                   <%= isExistingPatient ? "readonly" : "" %>
                                   required>

                        </div>

                        <div class="form-group">

                            <label for="contact_number">Contact Number <span class="required">*</span></label>

                            <input type="text"
                                   id="contact_number"
                                   name="contact_number"
                                   placeholder="e.g. 0771234567"
                                   value="<%= oldContact %>"
                                   <%= isExistingPatient ? "readonly" : "" %>
                                   required>

                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label for="p_address">Address</label>

                            <input type="text"
                                   id="p_address"
                                   name="p_address"
                                   placeholder="e.g. 12 Lake Road, Colombo"
                                   value="<%= oldPAddress %>"
                                   <%= isExistingPatient ? "readonly" : "" %>>

                        </div>

                        <div class="form-group">

                            <label for="gender">Gender</label>

                            <select id="gender"
                                    name="gender"
                                    <%= isExistingPatient ? "disabled" : "" %>>

                                <option value="" <%= oldGender.isEmpty() ? "selected" : "" %>>
                                    Select gender
                                </option>

                                <option value="Male" <%= "Male".equalsIgnoreCase(oldGender) ? "selected" : "" %>>
                                    Male
                                </option>

                                <option value="Female" <%= "Female".equalsIgnoreCase(oldGender) ? "selected" : "" %>>
                                    Female
                                </option>

                                <option value="Other" <%= "Other".equalsIgnoreCase(oldGender) ? "selected" : "" %>>
                                    Other
                                </option>

                            </select>

                            <!--
                                A disabled <select> does not submit its value,
                                so this hidden field carries it through
                                whenever an existing patient is locked in.
                            -->
                            <input type="hidden"
                                   id="gender_hidden"
                                   name="gender_hidden"
                                   value="<%= oldGender %>">

                        </div>

                    </div>

                </div>


                <!-- ===================== APPOINTMENT DETAILS ===================== -->

                <div class="form-section">

                    <div class="form-section-title">
                        <span class="step-badge">3</span>
                        <h3>Appointment details</h3>
                    </div>

                    <div class="form-row">

                        <div class="form-group">

                            <label for="a_number_display">Appointment No</label>

                            <input type="text"
                                   id="a_number_display"
                                   value="<%= nextAppointmentNumber %>"
                                   readonly>

                            <small class="field-hint-plain">
                                Assigned automatically when you save.
                            </small>

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
                                        <%= oldDentistId.isEmpty() ? "selected" : "" %>
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


                <!-- ===================== TREATMENTS ===================== -->

                <div class="form-section form-section-last">

                    <div class="form-section-title">
                        <span class="step-badge">4</span>
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

                                    String tIdStr = String.valueOf(t.getT_id());

                                    boolean isChecked = oldTreatmentIdSet.contains(tIdStr);

                                    BigDecimal price =
                                            t.getPriceLkr() != null ? t.getPriceLkr() : BigDecimal.ZERO;
                            %>

                            <label class="treatment-item">

                                <input type="checkbox"
                                       name="treatmentIds"
                                       value="<%= tIdStr %>"
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
                        Save Appointment
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


// -------------------- Patient lookup --------------------

var pIdField = document.getElementById("p_id");

var pNameField = document.getElementById("p_name");
var pAddressField = document.getElementById("p_address");
var pContactField = document.getElementById("contact_number");
var pGenderField = document.getElementById("gender");
var pGenderHidden = document.getElementById("gender_hidden");

var newPatientLink = document.getElementById("newPatientLink");
var patientModeHint = document.getElementById("patientModeHint");

var lookupResults = document.getElementById("lookupResults");
var lookupStatus = document.getElementById("lookupStatus");


function setPatientFieldsLocked(locked) {

    var editableFields = [pNameField, pAddressField, pContactField];

    for (var i = 0; i < editableFields.length; i++) {

        if (locked) {
            editableFields[i].setAttribute("readonly", "readonly");
        } else {
            editableFields[i].removeAttribute("readonly");
        }
    }

    if (locked) {
        pGenderField.setAttribute("disabled", "disabled");
    } else {
        pGenderField.removeAttribute("disabled");
    }

    if (locked) {
        newPatientLink.classList.remove("hidden");
    } else {
        newPatientLink.classList.add("hidden");
    }
}


function renderPatientModeHint(mode) {

    // Renders the same badge + text markup the JSP prints on first load,
    // so the visual feedback stays consistent whether it comes from the
    // server (page load) or from this JS (after a lookup / reset).
    if (mode === "existing") {

        patientModeHint.innerHTML =
            '<span class="badge badge-blue">Existing patient</span> ' +
            'Details below are locked.';

    } else {

        patientModeHint.innerHTML =
            '<span class="badge badge-grey">New patient</span> ' +
            'Fill in the fields below to register, or search above.';
    }
}


function setLookupStatus(text, tone) {

    // tone: "info" | "success" | "error"
    lookupStatus.textContent = text;
    lookupStatus.className = "lookup-status" + (tone ? " lookup-status-" + tone : "");
}


function selectExistingPatient(patient) {

    pIdField.value = patient.p_id;

    pNameField.value = patient.p_name || "";
    pAddressField.value = patient.p_address || "";
    pContactField.value = patient.contact_number || "";
    pGenderField.value = patient.gender || "";
    pGenderHidden.value = patient.gender || "";

    setPatientFieldsLocked(true);
    renderPatientModeHint("existing");

    lookupResults.innerHTML = "";
    setLookupStatus("Patient selected: " + patient.p_name, "success");
}


function clearPatientSelection() {

    pIdField.value = "";

    pNameField.value = "";
    pAddressField.value = "";
    pContactField.value = "";
    pGenderField.value = "";
    pGenderHidden.value = "";

    setPatientFieldsLocked(false);
    renderPatientModeHint("new");
}


document.getElementById("lookupBtn").addEventListener("click", function () {

    var query = document.getElementById("lookupQuery").value.trim();

    lookupResults.innerHTML = "";

    if (query.length === 0) {
        setLookupStatus("Enter a name or phone number to search.", "error");
        return;
    }

    setLookupStatus("Searching...", "info");

    fetch("patientlookup?query=" + encodeURIComponent(query))
        .then(function (res) { return res.json(); })
        .then(function (matches) {

            if (!matches || matches.length === 0) {

                setLookupStatus(
                    "No matching patient found. Enter their details below to register them.",
                    "error"
                );

                clearPatientSelection();

                return;
            }

            setLookupStatus(matches.length + " matching patient(s) found. Select one:", "info");

            matches.forEach(function (patient) {

                var item = document.createElement("div");

                item.className = "lookup-result-item";

                item.textContent =
                    patient.p_name + " — " + patient.contact_number +
                    (patient.p_address ? " — " + patient.p_address : "");

                item.addEventListener("click", function () {
                    selectExistingPatient(patient);
                });

                lookupResults.appendChild(item);
            });

        })
        .catch(function () {
            setLookupStatus("Could not search for patients right now. Please try again.", "error");
        });

});


newPatientLink.addEventListener("click", function (e) {
    e.preventDefault();
    clearPatientSelection();
    setLookupStatus("", "");
});


pGenderField.addEventListener("change", function () {
    pGenderHidden.value = pGenderField.value;
});


document.getElementById("appointmentForm").addEventListener("submit", function () {

    if (pGenderField.hasAttribute("disabled")) {
        pGenderField.removeAttribute("disabled");
        pGenderField.value = pGenderHidden.value;
    }

});


if (pIdField.value.trim() !== "") {
    setPatientFieldsLocked(true);
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
