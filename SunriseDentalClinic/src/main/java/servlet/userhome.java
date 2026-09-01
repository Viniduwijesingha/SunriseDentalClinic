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
import model.bill;
import model.patient;
import services.appointmentService;
import services.billService;
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

        patientService patService = new patientService();
        ArrayList<patient> patientList = patService.getAllPatients();

        appointmentService apptService = new appointmentService();


        ArrayList<appointment> appointmentList =
                apptService.getAllAppointments();

        billService billServ = new billService();
        ArrayList<bill> billList = billServ.getAllBills();

        int totalPatients = patientList.size();

        int activePatients = 0;

        for (patient p : patientList) {

            String status = p.getStatus();

            if (status == null || status.equalsIgnoreCase("Active")) {
                activePatients++;
            }
        }

        int totalAppointments = appointmentList.size();

        BigDecimal totalRevenue = BigDecimal.ZERO;

        for (bill b : billList) {

            if (b.getStatus() != null &&
                    b.getStatus().equalsIgnoreCase("Paid") &&
                    b.getAmount() != null) {

                totalRevenue = totalRevenue.add(b.getAmount());
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