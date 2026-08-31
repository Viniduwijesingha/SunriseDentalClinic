package services;

import controller.DataBaseConnect;
import model.dentist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class dentistService {

    public ArrayList<dentist> getAllDentists() {

        ArrayList<dentist> dentistList = new ArrayList<>();

        String sql =
                "SELECT d_id, d_name, specialization, dcontact_number, status " +
                "FROM dentist " +
                "WHERE status IS NULL OR status <> 'Inactive' " +
                "ORDER BY d_name ASC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                dentist d = new dentist();

                d.setD_id(rs.getInt("d_id"));
                d.setD_name(rs.getString("d_name"));
                d.setSpecialization(rs.getString("specialization"));
                d.setDcontact_number(rs.getString("dcontact_number"));
                d.setStatus(rs.getString("status"));

                dentistList.add(d);
            }

        } catch (Exception e) {

            System.out.println("ERROR loading dentists: " + e.getMessage());
            e.printStackTrace();
        }

        return dentistList;
    }


    public dentist getDentistById(int dentistId) {

        dentist d = null;

        String sql =
                "SELECT d_id, d_name, specialization, dcontact_number, status " +
                "FROM dentist WHERE d_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, dentistId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    d = new dentist();

                    d.setD_id(rs.getInt("d_id"));
                    d.setD_name(rs.getString("d_name"));
                    d.setSpecialization(rs.getString("specialization"));
                    d.setDcontact_number(rs.getString("dcontact_number"));
                    d.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {

            System.out.println("ERROR getting dentist: " + e.getMessage());
            e.printStackTrace();
        }

        return d;
    }
}