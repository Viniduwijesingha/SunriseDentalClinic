package services;

import controller.DataBaseConnect;
import model.patient;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class patientService {


    public ArrayList<patient> getAllPatients() {

        ArrayList<patient> patientList = new ArrayList<>();

        String sql =
                "SELECT p_id, p_name, p_address, contact_number, " +
                "gender, register_datetime, status " +
                "FROM patient " +
                "ORDER BY p_id DESC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                patient pat = new patient();

                pat.setP_id(rs.getInt("p_id"));
                pat.setP_name(rs.getString("p_name"));
                pat.setP_address(rs.getString("p_address"));
                pat.setContact_number(rs.getString("contact_number"));
                pat.setGender(rs.getString("gender"));
                pat.setRegister_datetime(
                        rs.getTimestamp("register_datetime")
                );
                pat.setStatus(rs.getString("status"));

                patientList.add(pat);
            }

            System.out.println(
                    "Patients loaded from database: "
                    + patientList.size()
            );

        } catch (Exception e) {

            System.out.println(
                    "ERROR loading patients: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return patientList;
    }


    public ArrayList<patient> searchPatients(String keyword) {

        ArrayList<patient> patientList = new ArrayList<>();

        String sql =
                "SELECT p_id, p_name, p_address, contact_number, " +
                "gender, register_datetime, status " +
                "FROM patient " +
                "WHERE CAST(p_id AS CHAR) LIKE ? " +
                "OR p_name LIKE ? " +
                "OR contact_number LIKE ? " +
                "ORDER BY p_id DESC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            String search = "%" + keyword.trim() + "%";

            stmt.setString(1, search);
            stmt.setString(2, search);
            stmt.setString(3, search);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    patient pat = new patient();

                    pat.setP_id(rs.getInt("p_id"));
                    pat.setP_name(rs.getString("p_name"));
                    pat.setP_address(rs.getString("p_address"));
                    pat.setContact_number(
                            rs.getString("contact_number")
                    );
                    pat.setGender(rs.getString("gender"));
                    pat.setRegister_datetime(
                            rs.getTimestamp("register_datetime")
                    );
                    pat.setStatus(rs.getString("status"));

                    patientList.add(pat);
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR searching patients: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return patientList;
    }



    public patient getPatientById(int patientId) {

        patient pat = null;

        String sql =
                "SELECT p_id, p_name, p_address, contact_number, " +
                "gender, register_datetime, status " +
                "FROM patient " +
                "WHERE p_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, patientId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    pat = new patient();

                    pat.setP_id(rs.getInt("p_id"));
                    pat.setP_name(rs.getString("p_name"));
                    pat.setP_address(rs.getString("p_address"));
                    pat.setContact_number(
                            rs.getString("contact_number")
                    );
                    pat.setGender(rs.getString("gender"));
                    pat.setRegister_datetime(
                            rs.getTimestamp("register_datetime")
                    );
                    pat.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR getting patient: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return pat;
    }



    public patient getPatientByContactNumber(String contactNumber) {

        patient pat = null;

        if (contactNumber == null ||
                contactNumber.trim().isEmpty()) {

            return null;
        }

        String sql =
                "SELECT p_id, p_name, p_address, contact_number, " +
                "gender, register_datetime, status " +
                "FROM patient " +
                "WHERE contact_number = ? " +
                "LIMIT 1";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, contactNumber.trim());

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    pat = new patient();

                    pat.setP_id(rs.getInt("p_id"));
                    pat.setP_name(rs.getString("p_name"));
                    pat.setP_address(rs.getString("p_address"));
                    pat.setContact_number(
                            rs.getString("contact_number")
                    );
                    pat.setGender(rs.getString("gender"));
                    pat.setRegister_datetime(
                            rs.getTimestamp("register_datetime")
                    );
                    pat.setStatus(rs.getString("status"));
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR looking up patient by contact number: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return pat;
    }


    public boolean addPatient(patient pat) {

        String sql =
                "INSERT INTO patient " +
                "(p_name, p_address, contact_number, gender, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, pat.getP_name());
            stmt.setString(2, pat.getP_address());
            stmt.setString(3, pat.getContact_number());
            stmt.setString(4, pat.getGender());

            String status = pat.getStatus();

            if (status == null ||
                    status.trim().isEmpty()) {

                status = "Active";
            }

            stmt.setString(5, status);

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR adding patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }


    /**
     * Same as addPatient(), but returns the generated p_id so the caller
     * (e.g. the appointment-booking flow) can immediately link the new
     * patient to an appointment. Returns 0 on failure.
     */
    public int addPatientReturnId(patient pat) {

        String sql =
                "INSERT INTO patient " +
                "(p_name, p_address, contact_number, gender, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(
                        sql, PreparedStatement.RETURN_GENERATED_KEYS
                )
        ) {

            stmt.setString(1, pat.getP_name());
            stmt.setString(2, pat.getP_address());
            stmt.setString(3, pat.getContact_number());
            stmt.setString(4, pat.getGender());

            String status = pat.getStatus();

            if (status == null ||
                    status.trim().isEmpty()) {

                status = "Active";
            }

            stmt.setString(5, status);

            int rows = stmt.executeUpdate();

            if (rows == 0) {
                return 0;
            }

            try (ResultSet keys = stmt.getGeneratedKeys()) {

                if (keys.next()) {
                    return keys.getInt(1);
                }
            }

            return 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR adding patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return 0;
        }
    }


    public boolean updatePatient(patient pat) {

        String sql =
                "UPDATE patient SET " +
                "p_name = ?, " +
                "p_address = ?, " +
                "contact_number = ?, " +
                "gender = ?, " +
                "status = ? " +
                "WHERE p_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, pat.getP_name());
            stmt.setString(2, pat.getP_address());
            stmt.setString(3, pat.getContact_number());
            stmt.setString(4, pat.getGender());

            String status = pat.getStatus();

            if (status == null ||
                    status.trim().isEmpty()) {

                status = "Active";
            }

            stmt.setString(5, status);

            stmt.setInt(6, pat.getP_id());

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR updating patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }


    public boolean deletePatient(int patientId) {

        String sql =
                "DELETE FROM patient " +
                "WHERE p_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, patientId);

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR deleting patient: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }
}