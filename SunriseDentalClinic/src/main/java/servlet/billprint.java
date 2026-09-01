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

@WebServlet("/billprint")
public class billprint extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public billprint() {
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

            response.sendRedirect("managebill");
            return;
        }

        int appointmentId;

        try {

            appointmentId = Integer.parseInt(a_idParam.trim());

        } catch (NumberFormatException e) {

            response.sendRedirect("managebill");
            return;
        }

        appointmentService service = new appointmentService();

        appointment app = service.getAppointmentById(appointmentId);

        if (app == null) {

            response.sendRedirect("managebill");
            return;
        }

        ArrayList<apptreatment> treatmentList =
                service.getTreatmentsByAppointmentId(appointmentId);

        request.setAttribute("appointment", app);
        request.setAttribute("treatmentList", treatmentList);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("billprint.jsp");

        dispatcher.forward(request, response);
    }
}