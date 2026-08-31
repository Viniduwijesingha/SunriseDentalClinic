package servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.appointment;
import model.apptreatment;
import model.dentist;
import services.appointmentService;
import services.apptreatmentService;
import services.dentistService;

/**
 * Handles editing an existing appointment: loading it (with the current
 * dentist / treatment selections) for the edit form, and saving changes
 * back to the database. The linked patient is not editable here - only
 * dentist, date/time, status and treatments can change.
 */
@WebServlet("/appointmentupdate")
public class appointmentupdate extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final DateTimeFormatter FORM_DATETIME_FORMAT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    public appointmentupdate() {
        super();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.sendRedirect("userlogin.jsp");
            return;
        }

        String a_idParam = request.getParameter("a_id");

        if (a_idParam == null || a_idParam.trim().isEmpty()) {

            response.sendRedirect("manageappointment");
            return;
        }

        int appointmentId;

        try {

            appointmentId = Integer.parseInt(a_idParam.trim());

        } catch (NumberFormatException e) {

            response.sendRedirect("manageappointment");
            return;
        }

        appointmentService appService = new appointmentService();
        dentistService dentService = new dentistService();
        apptreatmentService treatService = new apptreatmentService();

        appointment app = appService.getAppointmentById(appointmentId);

        if (app == null) {

            response.sendRedirect("manageappointment");
            return;
        }

        ArrayList<dentist> dentistList = dentService.getAllDentists();
        ArrayList<apptreatment> treatmentList = treatService.getAllTreatments();

        ArrayList<Integer> selectedTreatmentIds =
                appService.getTreatmentIdsByAppointmentId(appointmentId);

        request.setAttribute("appointment", app);
        request.setAttribute("dentistList", dentistList);
        request.setAttribute("treatmentList", treatmentList);
        request.setAttribute("selectedTreatmentIds", selectedTreatmentIds);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("appointmentupdate.jsp");

        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.sendRedirect("userlogin.jsp");
            return;
        }

        String a_idParam = request.getParameter("a_id");

        int appointmentId;

        try {

            appointmentId = Integer.parseInt(a_idParam.trim());

        } catch (Exception e) {

            response.sendRedirect("manageappointment");
            return;
        }

        appointmentService appService = new appointmentService();
        dentistService dentService = new dentistService();
        apptreatmentService treatService = new apptreatmentService();

        appointment existing = appService.getAppointmentById(appointmentId);

        if (existing == null) {

            response.sendRedirect("manageappointment");
            return;
        }

        String d_idParam = request.getParameter("d_id");
        String a_datetimeParam = request.getParameter("a_datetime");
        String status = request.getParameter("status");

        String[] treatmentIdParams =
                request.getParameterValues("treatmentIds");

        String errorMessage = null;

        int d_id = existing.getD_id();
        Timestamp a_datetime = null;

        if (d_idParam == null || d_idParam.trim().isEmpty()) {

            errorMessage = "Please select a dentist.";

        } else {

            try {

                d_id = Integer.parseInt(d_idParam.trim());

            } catch (NumberFormatException e) {

                errorMessage = "Invalid dentist selected.";
            }
        }

        if (errorMessage == null) {

            if (a_datetimeParam == null ||
                    a_datetimeParam.trim().isEmpty()) {

                errorMessage = "Please choose a date and time.";

            } else {

                try {

                    LocalDateTime ldt = LocalDateTime.parse(
                            a_datetimeParam.trim(),
                            FORM_DATETIME_FORMAT
                    );

                    a_datetime = Timestamp.valueOf(ldt);

                } catch (DateTimeParseException e) {

                    errorMessage = "Invalid date/time format.";
                }
            }
        }

        ArrayList<Integer> treatmentIds = new ArrayList<>();

        if (treatmentIdParams != null) {

            for (String idStr : treatmentIdParams) {

                try {

                    treatmentIds.add(Integer.parseInt(idStr.trim()));

                } catch (NumberFormatException ignored) {
                    // Skip anything that isn't a valid treatment id.
                }
            }
        }

        if (status == null || status.trim().isEmpty()) {
            status = "Pending";
        }

        if (errorMessage != null) {

            existing.setD_id(d_id);
            existing.setStatus(status);

            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("appointment", existing);
            request.setAttribute("dentistList", dentService.getAllDentists());
            request.setAttribute("treatmentList", treatService.getAllTreatments());
            request.setAttribute("selectedTreatmentIds", treatmentIds);
            request.setAttribute("submittedDateTime", a_datetimeParam);

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("appointmentupdate.jsp");

            dispatcher.forward(request, response);
            return;
        }

        existing.setD_id(d_id);
        existing.setA_datetime(a_datetime);
        existing.setStatus(status);

        boolean success = appService.updateAppointment(existing, treatmentIds);

        if (!success) {

            request.setAttribute(
                    "errorMessage",
                    "Could not update the appointment. Please try again."
            );

            request.setAttribute("appointment", existing);
            request.setAttribute("dentistList", dentService.getAllDentists());
            request.setAttribute("treatmentList", treatService.getAllTreatments());
            request.setAttribute("selectedTreatmentIds", treatmentIds);

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("appointmentupdate.jsp");

            dispatcher.forward(request, response);
            return;
        }

        response.sendRedirect("manageappointment");
    }
}