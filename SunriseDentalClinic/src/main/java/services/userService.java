package services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import controller.DataBaseConnect;
import model.user;

public class userService {

    public user validateUser(String email, String password) {

        user usr = null;

        System.out.println("Checking login for Email: " + email);
        System.out.println("Password: " + password);

        try (Connection con = DataBaseConnect.getConnection()) {

            String query = "SELECT * FROM user WHERE u_email = ? AND u_password = ?";

            PreparedStatement pst = con.prepareStatement(query);

            pst.setString(1, email.trim());
            pst.setString(2, password.trim());

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {

                System.out.println("Login success: user found in DB.");

                usr = new user();

                usr.setU_name(rs.getString("u_name"));
                usr.setU_email(rs.getString("u_email"));
                usr.setU_password(rs.getString("u_password"));

            } else {

                System.out.println("Login failed. Please check your email and password and try again.");

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return usr;
    }
}