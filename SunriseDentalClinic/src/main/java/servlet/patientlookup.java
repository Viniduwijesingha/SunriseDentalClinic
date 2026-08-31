package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.patient;
import services.patientService;


@WebServlet("/patientlookup")
public class patientlookup extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession(false);

        PrintWriter out = response.getWriter();

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("[]");
            return;
        }

        String query = request.getParameter("query");

        if (query == null || query.trim().isEmpty()) {
            out.write("[]");
            return;
        }

        patientService service = new patientService();

        ArrayList<patient> results = service.searchPatients(query.trim());

        StringBuilder json = new StringBuilder();

        json.append("[");

        int limit = Math.min(results.size(), 10);

        for (int i = 0; i < limit; i++) {

            patient p = results.get(i);

            if (i > 0) {
                json.append(",");
            }

            json.append("{");
            json.append("\"p_id\":").append(p.getP_id()).append(",");
            json.append("\"p_name\":\"").append(escape(p.getP_name())).append("\",");
            json.append("\"p_address\":\"").append(escape(p.getP_address())).append("\",");
            json.append("\"contact_number\":\"").append(escape(p.getContact_number())).append("\",");
            json.append("\"gender\":\"").append(escape(p.getGender())).append("\"");
            json.append("}");
        }

        json.append("]");

        out.write(json.toString());
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

    private String escape(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
    }
}