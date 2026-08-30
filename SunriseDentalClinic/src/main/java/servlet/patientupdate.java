package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.patient;
import services.patientService;

@WebServlet("/patientupdate")
public class patientupdate extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public patientupdate() {
        super();
    }



    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {


        String id = request.getParameter("p_id");


        if (id == null || id.trim().isEmpty()) {

            response.sendRedirect("managepatient");

            return;
        }


        try {

            int patientId = Integer.parseInt(id);


            patientService service = new patientService();

            patient pat = service.getPatientById(patientId);


            if (pat != null) {

                request.setAttribute("patient", pat);

                RequestDispatcher dispatcher =
                        request.getRequestDispatcher("patientupdate.jsp");

                dispatcher.forward(request, response);

            } else {

                response.sendRedirect("managepatient");
            }


        } catch (NumberFormatException e) {

            response.sendRedirect("managepatient");
        }
    }




    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        String id = request.getParameter("p_id");

        String name = request.getParameter("p_name");

        String address = request.getParameter("p_address");

        String contactNumber =
                request.getParameter("contact_number");

        String gender =
                request.getParameter("gender");

        String status =
                request.getParameter("status");


        try {

            int patientId = Integer.parseInt(id);


            // Create patient object
            patient pat = new patient();

            pat.setP_id(patientId);

            pat.setP_name(name);

            pat.setP_address(address);

            pat.setContact_number(contactNumber);

            pat.setGender(gender);

            pat.setStatus(status);


            // Update
            patientService service =
                    new patientService();

            boolean success =
                    service.updatePatient(pat);


            if (success) {

                response.sendRedirect("managepatient");

            } else {

                request.setAttribute(
                        "errorMessage",
                        "Failed to update patient. Please try again."
                );

                request.setAttribute(
                        "patient",
                        pat
                );

                RequestDispatcher dispatcher =
                        request.getRequestDispatcher(
                                "patientupdate.jsp"
                        );

                dispatcher.forward(request, response);
            }


        } catch (NumberFormatException e) {

            request.setAttribute(
                    "errorMessage",
                    "Invalid patient ID."
            );

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher(
                            "managepatient.jsp"
                    );

            dispatcher.forward(request, response);
        }
    }
}