package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.appointment;
import model.patient;
import services.appointmentService;
import services.patientService;

@WebServlet("/userhome")
public class userhome extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int RECENT_APPOINTMENTS_LIMIT = 5;

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

        // Always force a fresh render of the dashboard. Without this,
        // a browser back/forward navigation (or an intermediate proxy)
        // can show a previously cached copy of this page - including a
        // stale Billable Revenue figure - instead of hitting the
        // server again.
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        patientService patService = new patientService();
        ArrayList<patient> patientList = patService.getAllPatients();

        appointmentService apptService = new appointmentService();

        // getAllAppointments() is already ordered a_id DESC,
        // so the first N entries are the most recent appointments.
        ArrayList<appointment> appointmentList =
                apptService.getAllAppointments();

        int totalPatients = patientList.size();
        int activePatients = 0;

        for (patient p : patientList) {

            String status = p.getStatus();

            if (status == null || status.equalsIgnoreCase("Active")) {
                activePatients++;
            }
        }

        int totalAppointments = appointmentList.size();

        // Billable Revenue = the total amount billed across all
        // appointments, based on each appointment's treatment total
        // (the same figure shown in the Total (Rs.) column on the
        // Manage Appointments page). This is intentionally independent
        // of the separate `bill` table - a bill record doesn't need to
        // exist yet for treatment work to count as billable.
        BigDecimal totalRevenue = BigDecimal.ZERO;

        for (appointment app : appointmentList) {

            if (app.getTotalPrice() != null) {
                totalRevenue = totalRevenue.add(app.getTotalPrice());
            }
        }

        ArrayList<appointment> recentAppointments = new ArrayList<>();

        int limit = Math.min(
                RECENT_APPOINTMENTS_LIMIT,
                appointmentList.size()
        );

        for (int i = 0; i < limit; i++) {
            recentAppointments.add(appointmentList.get(i));
        }

        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("activePatients", activePatients);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentAppointments", recentAppointments);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("userhome.jsp");

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