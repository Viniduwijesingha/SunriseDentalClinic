package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import services.appointmentService;


@WebServlet("/appointmentdelete")
public class appointmentdelete extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public appointmentdelete() {
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

        boolean deleted = service.deleteAppointment(appointmentId);

        if (deleted) {

            session.setAttribute(
                    "flashSuccess",
                    "Appointment deleted successfully."
            );

        } else {

            session.setAttribute(
                    "flashError",
                    "Could not delete the appointment. It may have already been removed."
            );
        }

        response.sendRedirect("manageappointment");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}