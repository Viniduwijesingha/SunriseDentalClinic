package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseConnect {
	
public static Connection getConnection() throws ClassNotFoundException, SQLException {
		
		String username = "root";
		String password = "123456";
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sunrise_dental_db?useSSL=false&allowPublicKeyRetrieval=true"
				,username
				,password);
	
		return con;
	}

		public static void main(String[] args) {
		    try {
		        Connection conn = DataBaseConnect .getConnection();
		        if (conn != null) {
		            System.out.println("Database successfully connected!");
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}
}


