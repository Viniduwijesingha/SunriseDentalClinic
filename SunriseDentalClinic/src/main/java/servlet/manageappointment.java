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

import model.appointment;
import services.appointmentService;

@WebServlet("/manageappointment")
public class manageappointment extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public manageappointment() {
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

        String keyword = request.getParameter("keyword");

        appointmentService service =
                new appointmentService();

        ArrayList<appointment> appointmentList;

        if (keyword != null &&
                !keyword.trim().isEmpty()) {

            appointmentList =
                    service.searchAppointments(keyword);

        } else {

            appointmentList =
                    service.getAllAppointments();
        }

        request.setAttribute(
                "appointmentList",
                appointmentList
        );

        request.setAttribute(
                "searchKeyword",
                keyword
        );

        RequestDispatcher dispatcher =
                request.getRequestDispatcher(
                        "manageappointments.jsp"
                );

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
