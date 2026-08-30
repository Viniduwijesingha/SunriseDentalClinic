package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import services.patientService;

@WebServlet("/patientdelete")
public class patientdelete extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public patientdelete() {
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


            patientService service =
                    new patientService();


            boolean success =
                    service.deletePatient(patientId);


            if (success) {

                response.sendRedirect("managepatient");

            } else {

                request.setAttribute(
                        "errorMessage",
                        "Patient could not be deleted."
                );

                response.sendRedirect("managepatient");
            }


        } catch (NumberFormatException e) {

            response.sendRedirect("managepatient");
        }
    }
}