<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.apptreatment"%>
<%@ page import="model.appointment"%>

<%
    String userName = (String) session.getAttribute("loggedInUser");

    if (userName == null || userName.trim().isEmpty()) {
        response.sendRedirect("userlogin.jsp");
        return;
    }

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

<div class="print-toolbar">

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

        </div>

        <div class="invoice-meta">

            <h1>BILL</h1>

            <p><strong>Bill Ref:</strong> <%= app.getA_number() %></p>
            <p><strong>Issued:</strong> <%= issuedToday %></p>

            <span class="status-tag status-<%= status.toLowerCase() %>">
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

            <th>#</th>
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

            <td><%= rowNumber %></td>
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


    <div class="invoice-total">

        <span>Total Amount</span>
        <strong>Rs. <%= String.format("%.2f", total) %></strong>

    </div>


    <div class="invoice-footer">

        <p>Thank you for choosing Sunrise Dental Clinic.</p>
        <p>This is a system-generated bill and does not require a signature.</p>

    </div>

</div>


</body>

</html>
