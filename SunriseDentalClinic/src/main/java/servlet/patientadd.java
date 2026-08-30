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

@WebServlet("/patientadd")
public class patientadd extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public patientadd() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        // Get form data
        String name = request.getParameter("p_name");
        String address = request.getParameter("p_address");
        String contactNumber = request.getParameter("contact_number");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");


        // Create patient object
        patient pat = new patient();

        pat.setP_name(name);
        pat.setP_address(address);
        pat.setContact_number(contactNumber);
        pat.setGender(gender);
        pat.setStatus(status);


        // Call service
        patientService service = new patientService();

        boolean success = service.addPatient(pat);


        if (success) {

            response.sendRedirect("managepatient");

        } else {

            request.setAttribute(
                    "errorMessage",
                    "Failed to add patient. Please try again."
            );

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("patientadd.jsp");

            dispatcher.forward(request, response);
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("patientadd.jsp");

        dispatcher.forward(request, response);
    }
}