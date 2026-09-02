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
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Help & Support - Sunrise Dental</title>

    <link rel="stylesheet"
          href="CSS/helpandsupport.css">

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


        <a href="managebills.jsp"
           class="nav-item">

            <span class="nav-icon">$</span>

            <span>Manage Bills</span>

        </a>


        <a href="helpandsupport.jsp"
           class="nav-item active">

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

                <h1>Help & Support</h1>


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

        <div class="contact-grid">

            <div class="contact-card">

                <div class="contact-icon icon-phone">
                    📞
                </div>

                <div>

                    <span class="contact-label">
                        Call Us
                    </span>

                    <strong>
                        +94 11 234 5678
                    </strong>

                    <p>
                        Mon - Sat, 8:00 AM - 8:00 PM
                    </p>

                </div>

            </div>


            <div class="contact-card">

                <div class="contact-icon icon-email">
                    ✉
                </div>

                <div>

                    <span class="contact-label">
                        Email Us
                    </span>

                    <strong>
                        support@sunrisedental.lk
                    </strong>

                    <p>
                        We reply within 24 hours
                    </p>

                </div>

            </div>


            <div class="contact-card">

                <div class="contact-icon icon-location">
                    ⚑
                </div>

                <div>

                    <span class="contact-label">
                        Visit Us
                    </span>

                    <strong>
                        No 3/21, Galle Road, Colombo 05
                    </strong>

                    <p>
                        Open Monday to Saturday
                    </p>

                </div>

            </div>

        </div>


        <div class="table-card faq-card">

            <div class="table-header">

                <div>

                    <h2>Frequently Asked Questions</h2>

                    <p>
                        Quick answers to common questions about using this system.
                    </p>

                </div>

            </div>


            <div class="faq-search">

                <svg class="faq-search-icon"
                     viewBox="0 0 24 24"
                     fill="none"
                     xmlns="http://www.w3.org/2000/svg">

                    <circle cx="11"
                            cy="11"
                            r="7"
                            stroke="currentColor"
                            stroke-width="2"/>

                    <path d="M20 20L16.65 16.65"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"/>

                </svg>

                <input type="text"
                       id="faqSearchInput"
                       placeholder="Search for a topic, e.g. 'appointment' or 'delete'..."
                       oninput="filterFaqs(this.value);">

                <button type="button"
                        id="faqSearchClear"
                        class="faq-search-clear"
                        onclick="clearFaqSearch();"
                        aria-label="Clear search">

                    ✕

                </button>

            </div>


            <div id="faqNoResults"
                 class="faq-no-results">

                No questions match your search. Try a different keyword.

            </div>


            <div class="faq-groups">

                <div class="faq-group"
                     data-group="patients">

                    <div class="faq-group-title">
                        <span class="faq-group-icon">♙</span>
                        Managing Patients
                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>How do I register a new patient?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Go to <strong>Manage Patients</strong> from the sidebar and click
                            <strong>+ Add Patient</strong>. Fill in the patient's name, address,
                            contact number and gender, then save. The new patient will appear
                            at the top of the patient list.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Can I edit or delete a patient's details?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Yes. In the patient list, click <strong>Edit</strong> next to any
                            patient to update their details, or <strong>Delete</strong> to
                            permanently remove their record. Deleting a patient cannot be
                            undone, so use it carefully.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>What does the "Active" vs "Inactive" patient status mean?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            <strong>Active</strong> patients are currently receiving care at
                            the clinic and appear in the Active Patients count on the summary
                            cards. Mark a patient <strong>Inactive</strong> if they're no
                            longer visiting, without deleting their record entirely.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Can two patients share the same contact number?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Each patient record is meant to have its own unique contact
                            number, since it's used to identify them when booking
                            appointments. If a household shares one phone number, add a note
                            in the address field to tell family members apart.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>What happens to a patient's appointments if I delete them?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Deleting a patient removes their record permanently but does not
                            automatically clean up related appointments. Cancel or delete any
                            upcoming appointments for that patient first to keep your
                            appointment list accurate.

                        </div>

                    </div>

                </div>


                <div class="faq-group"
                     data-group="appointments">

                    <div class="faq-group-title">
                        <span class="faq-group-icon">▣</span>
                        Appointments
                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>How do I schedule a new appointment?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Open <strong>Appointments</strong> from the sidebar and click
                            <strong>+ New Appointment</strong>. Select the patient, choose a
                            dentist and treatments, pick a date and time, then save. The new
                            appointment will show up in the appointment list.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>What do the appointment statuses mean?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            <strong>Pending</strong> means the appointment is booked but not
                            yet confirmed. <strong>Confirmed</strong> means the patient has
                            confirmed attendance. <strong>Completed</strong> means the visit
                            took place, and <strong>Cancelled</strong> means it won't happen.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Can I reschedule or cancel an appointment?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Yes. Click <strong>Edit</strong> next to the appointment to change
                            its date, time, dentist or treatments, or set its status to
                            <strong>Cancelled</strong> if it won't be going ahead.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>How is the total appointment price calculated?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            The total shown on each appointment is the sum of the prices of
                            every treatment attached to it. Adding or removing treatments
                            while editing an appointment updates this total automatically.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Can the same dentist have two appointments at once?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            The system doesn't currently block overlapping appointment times
                            for the same dentist, so double-check a dentist's schedule before
                            confirming a new booking to avoid conflicts.

                        </div>

                    </div>

                </div>


                <div class="faq-group"
                     data-group="account">

                    <div class="faq-group-title">
                        <span class="faq-group-icon">⌂</span>
                        Search &amp; Account
                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>How do I search for a patient or appointment?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Use the search bar at the top of the <strong>Manage Patients</strong>
                            or <strong>Appointments</strong> list. You can search by ID, name,
                            contact number, dentist or status. Click <strong>Clear</strong> to
                            reset the search and see the full list again.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Is my data visible to other staff members?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Patient and appointment records are shared across all logged-in
                            staff so the whole clinic stays in sync. Only your account
                            profile (name and email) is private to your login.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Who do I contact if something isn't working?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Call us during working hours or email
                            <strong>support@sunrisedental.lk</strong> using the details above,
                            and our team will get back to you as soon as possible.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>I forgot my password. What do I do?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Contact your clinic administrator to reset your password, since
                            self-service password reset isn't available yet from the login
                            page.

                        </div>

                    </div>


                    <div class="faq-item">

                        <button type="button"
                                class="faq-question"
                                onclick="toggleFaq(this);">

                            <span>Does this system work on mobile devices?</span>

                            <span class="faq-toggle">+</span>

                        </button>

                        <div class="faq-answer">

                            Yes, the layout adapts to smaller screens, so you can view and
                            manage patients and appointments from a tablet or phone browser
                            in addition to desktop.

                        </div>

                    </div>

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


function showNotification() {

    alert(
        "You currently have no new notifications."
    );

}


function toggleFaq(button) {

    var item = button.parentElement;

    var isOpen = item.classList.contains("open");

    var allItems = document.querySelectorAll(".faq-item");

    allItems.forEach(function (el) {
        el.classList.remove("open");
    });

    if (!isOpen) {
        item.classList.add("open");
    }

}


function filterFaqs(query) {

    var normalized = query.trim().toLowerCase();

    var groups = document.querySelectorAll(".faq-group");

    var visibleCount = 0;

    groups.forEach(function (group) {

        var items = group.querySelectorAll(".faq-item");

        var groupHasMatch = false;

        items.forEach(function (item) {

            var text = item.textContent.toLowerCase();

            var matches = normalized === "" || text.indexOf(normalized) !== -1;

            item.style.display = matches ? "" : "none";

            if (matches) {
                groupHasMatch = true;
                visibleCount++;
            }

            if (!matches) {
                item.classList.remove("open");
            }

        });

        group.style.display = groupHasMatch ? "" : "none";

    });

    var noResults = document.getElementById("faqNoResults");

    noResults.classList.toggle("visible", visibleCount === 0);

    var clearButton = document.getElementById("faqSearchClear");

    clearButton.classList.toggle("visible", normalized.length > 0);

}


function clearFaqSearch() {

    var input = document.getElementById("faqSearchInput");

    input.value = "";

    filterFaqs("");

    input.focus();

}

</script>


</body>

</html>
