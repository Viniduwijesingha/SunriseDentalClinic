package servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.apptreatment;
import model.appointment;
import services.appointmentService;

@WebServlet("/appointmentview")
public class appointmentview extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public appointmentview() {
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

        appointmentService service = new appointmentService();

        appointment app = service.getAppointmentById(appointmentId);

        ArrayList<apptreatment> treatmentList;

        if (app == null) {

            request.setAttribute(
                    "errorMessage",
                    "Appointment not found. It may have already been deleted."
            );

            treatmentList = new ArrayList<apptreatment>();

        } else {

            treatmentList =
                    service.getTreatmentsByAppointmentId(appointmentId);
        }

        request.setAttribute("appointment", app);
        request.setAttribute("treatmentList", treatmentList);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("appointmentview.jsp");

        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}