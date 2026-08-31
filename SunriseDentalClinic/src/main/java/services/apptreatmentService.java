package services;

import controller.DataBaseConnect;
import model.apptreatment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class apptreatmentService {

    public ArrayList<apptreatment> getAllTreatments() {

        ArrayList<apptreatment> list = new ArrayList<>();

        String sql =
                "SELECT t_id, t_name, priceLkr, status " +
                "FROM apptreatment " +
                "WHERE status IS NULL OR status <> 'Inactive' " +
                "ORDER BY t_name ASC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                apptreatment t = new apptreatment();

                t.setT_id(rs.getInt("t_id"));
                t.setT_name(rs.getString("t_name"));
                t.setPriceLkr(rs.getBigDecimal("priceLkr"));
                t.setStatus(rs.getString("status"));

                list.add(t);
            }

        } catch (Exception e) {

            System.out.println("ERROR loading treatments: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }


    public apptreatment getTreatmentById(int treatmentId) {

        apptreatment t = null;

        String sql =
                "SELECT t_id, t_name, priceLkr, status " +
                "FROM apptreatment WHERE t_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, treatmentId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    t = new apptreatment();

                    t.setT_id(rs.getInt("t_id"));
                    t.setT_name(rs.getString("t_name"));
                    t.setPriceLkr(rs.getBigDecimal("priceLkr"));
                    t.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {

            System.out.println("ERROR getting treatment: " + e.getMessage());
            e.printStackTrace();
        }

        return t;
    }
}