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


@WebServlet("/managebill")
public class managebill extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public managebill() {
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

        appointmentService service = new appointmentService();

        String keyword = request.getParameter("keyword");

        ArrayList<appointment> appointmentList;

        if (keyword != null && !keyword.trim().isEmpty()) {

            appointmentList = service.searchAppointments(keyword);
            request.setAttribute("searchKeyword", keyword.trim());

        } else {

            appointmentList = service.getAllAppointments();
            request.setAttribute("searchKeyword", "");
        }

        request.setAttribute("appointmentList", appointmentList);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("managebills.jsp");

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