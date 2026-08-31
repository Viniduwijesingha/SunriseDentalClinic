package servlet;

import java.io.IOException;
import java.sql.Timestamp;
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
import model.patient;
import services.apptreatmentService;
import services.appointmentService;
import services.dentistService;
import services.patientService;

@WebServlet("/appointmentadd")
public class appointmentadd extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public appointmentadd() {
        super();
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

        try {

            String existingPatientId = request.getParameter("p_id");

            String pName = request.getParameter("p_name");
            String pAddress = request.getParameter("p_address");
            String pContact = request.getParameter("contact_number");
            String pGender = request.getParameter("gender");

            String dentistId = request.getParameter("d_id");
            String appointmentDateTime = request.getParameter("a_datetime");
            String status = request.getParameter("status");

            String[] selectedTreatments =
                    request.getParameterValues("treatmentIds");

            boolean usingExistingPatient =
                    existingPatientId != null &&
                    !existingPatientId.trim().isEmpty();

            // Fields that are always required, regardless of whether the
            // patient is new or already registered. The appointment number
            // itself is generated automatically below, not taken from the form.
            if (dentistId == null || dentistId.trim().isEmpty() ||
                    appointmentDateTime == null || appointmentDateTime.trim().isEmpty()) {

                showError(request, response,
                        "Please fill in all required fields.");
                return;
            }

            // If no existing patient was picked via the lookup, the visitor
            // must be registered manually before the appointment is saved.
            if (!usingExistingPatient &&
                    (pName == null || pName.trim().isEmpty() ||
                     pContact == null || pContact.trim().isEmpty())) {

                showError(request, response,
                        "Please search for the patient first, or enter their " +
                        "name and contact number to register them.");
                return;
            }

            patientService patService = new patientService();

            int resolvedPatientId;

            if (usingExistingPatient) {

                resolvedPatientId = Integer.parseInt(existingPatientId.trim());

            } else {

                // Guard against creating a duplicate patient if this contact
                // number is already registered but wasn't picked via search.
                patient duplicate =
                        patService.getPatientByContactNumber(pContact.trim());

                if (duplicate != null) {

                    resolvedPatientId = duplicate.getP_id();

                } else {

                    patient newPatient = new patient();

                    newPatient.setP_name(pName.trim());
                    newPatient.setP_address(
                            pAddress == null ? "" : pAddress.trim()
                    );
                    newPatient.setContact_number(pContact.trim());
                    newPatient.setGender(pGender == null ? "" : pGender.trim());
                    newPatient.setStatus("Active");

                    int newPatientId = patService.addPatientReturnId(newPatient);

                    if (newPatientId == 0) {

                        showError(request, response,
                                "Failed to register the new patient. Please try again.");
                        return;
                    }

                    resolvedPatientId = newPatientId;
                }
            }

            appointmentService service = new appointmentService();

            appointment app = new appointment();

            // Generated right before insert (rather than trusting a value
            // posted from the form) so the number always reflects what's
            // actually in the database at save time.
            app.setA_number(service.generateNextAppointmentNumber());

            app.setP_id(resolvedPatientId);
            app.setD_id(Integer.parseInt(dentistId.trim()));

            // <input type="datetime-local"> submits "yyyy-MM-ddTHH:mm" —
            // Timestamp.valueOf() needs a space, not "T", between date and
            // time, and seconds if they're missing.
            String normalizedDateTime = appointmentDateTime.trim().replace("T", " ");

            if (normalizedDateTime.length() == 16) {
                normalizedDateTime = normalizedDateTime + ":00";
            }

            Timestamp timestamp = Timestamp.valueOf(normalizedDateTime);
            app.setA_datetime(timestamp);

            if (status == null || status.trim().isEmpty()) {
                status = "Pending";
            }

            app.setStatus(status);

            ArrayList<Integer> treatmentIds = new ArrayList<>();

            if (selectedTreatments != null) {

                for (String treatmentId : selectedTreatments) {

                    if (treatmentId != null && !treatmentId.trim().isEmpty()) {
                        treatmentIds.add(Integer.parseInt(treatmentId.trim()));
                    }
                }
            }

            boolean success = service.addAppointment(app, treatmentIds);

            if (success) {

                response.sendRedirect("manageappointment");

            } else {

                showError(request, response,
                        "Failed to add appointment. Please try again.");
            }

        } catch (NumberFormatException e) {

            showError(request, response,
                    "Invalid patient, dentist, or treatment ID.");

        } catch (IllegalArgumentException e) {

            showError(request, response,
                    "Invalid appointment date or time.");

        } catch (Exception e) {

            e.printStackTrace();

            showError(request, response,
                    "An error occurred while adding the appointment.");
        }
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

        loadFormData(request);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("appointmentadd.jsp");

        dispatcher.forward(request, response);
    }


    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);

        loadFormData(request);

        request.getRequestDispatcher("appointmentadd.jsp")
                .forward(request, response);
    }


    private void loadFormData(HttpServletRequest request) {

        dentistService dentService = new dentistService();
        ArrayList<dentist> dentistList = dentService.getAllDentists();
        request.setAttribute("dentistList", dentistList);

        apptreatmentService treatService = new apptreatmentService();
        ArrayList<apptreatment> treatmentList = treatService.getAllTreatments();
        request.setAttribute("treatmentList", treatmentList);

        appointmentService apptService = new appointmentService();
        request.setAttribute(
                "nextAppointmentNumber",
                apptService.generateNextAppointmentNumber()
        );
    }
}