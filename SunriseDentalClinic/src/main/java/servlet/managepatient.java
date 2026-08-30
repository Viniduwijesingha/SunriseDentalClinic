package servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.patient;
import services.patientService;

@WebServlet("/managepatient")
public class managepatient extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public managepatient() {
        super();
    }


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        patientService service = new patientService();

        String keyword = request.getParameter("search");

        ArrayList<patient> patientList;

        if (keyword != null && !keyword.trim().isEmpty()) {

            patientList = service.searchPatients(keyword);

        } else {

            patientList = service.getAllPatients();
        }


        request.setAttribute("patientList", patientList);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("managepatient.jsp");

        dispatcher.forward(request, response);
    }

    
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}