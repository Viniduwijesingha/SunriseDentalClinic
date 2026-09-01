package servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.user;
import services.userService;

@WebServlet("/userlogin")
public class userlogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public userlogin() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get email and password from login form
        String email = request.getParameter("uemail");
        String password = request.getParameter("upassword");

        // Create user service object
        userService service = new userService();

        // Validate user login
        user usr = service.validateUser(email, password);

        // Check login result
        if (usr != null) {

            // Create session
            HttpSession session = request.getSession();

            // Store logged-in user's details
            session.setAttribute(
                "loggedInUser",
                usr.getU_name()
            );

            session.setAttribute(
                "userEmail",
                usr.getU_email()
            );

            // Redirect to user home page
            response.sendRedirect("userhome");

        } else {

            // Login failed
            request.setAttribute(
                "errorMessage",
                "Invalid email or password. Please try again."
            );

            // Return to login page
            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("userlogin.jsp");

            dispatcher.forward(request, response);
        }
    }
}