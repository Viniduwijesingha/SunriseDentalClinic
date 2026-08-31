package services;

import controller.DataBaseConnect;
import model.appointment;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class appointmentService {

    public ArrayList<appointment> getAllAppointments() {

        ArrayList<appointment> appointmentList = new ArrayList<>();

        String sql =
                "SELECT a.a_id, a.a_number, " +
                "p.p_id, p.p_name, p.p_address, p.contact_number, p.gender, " +
                "d.d_id, d.d_name, " +
                "a.a_datetime, a.status, " +
                "COALESCE(SUM(t.priceLkr), 0) AS totalPrice " +
                "FROM appointment a " +
                "INNER JOIN patient p ON a.p_id = p.p_id " +
                "INNER JOIN dentist d ON a.d_id = d.d_id " +
                "LEFT JOIN treatment_appointment ta ON a.a_id = ta.a_id " +
                "LEFT JOIN apptreatment t ON ta.t_id = t.t_id " +
                "GROUP BY a.a_id, a.a_number, p.p_id, p.p_name, " +
                "p.p_address, p.contact_number, p.gender, " +
                "d.d_id, d.d_name, a.a_datetime, a.status " +
                "ORDER BY a.a_id DESC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {

                appointment app = new appointment();

                app.setA_id(rs.getInt("a_id"));
                app.setA_number(rs.getString("a_number"));

                app.setP_id(rs.getInt("p_id"));
                app.setP_name(rs.getString("p_name"));
                app.setP_address(rs.getString("p_address"));
                app.setContact_number(rs.getString("contact_number"));
                app.setGender(rs.getString("gender"));

                app.setD_id(rs.getInt("d_id"));
                app.setD_name(rs.getString("d_name"));

                app.setA_datetime(rs.getTimestamp("a_datetime"));
                app.setStatus(rs.getString("status"));

                app.setTotalPrice(rs.getBigDecimal("totalPrice"));

                appointmentList.add(app);
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR loading appointments: " + e.getMessage()
            );

            e.printStackTrace();
        }

        return appointmentList;
    }


    public appointment getAppointmentById(int appointmentId) {

        appointment app = null;

        String sql =
                "SELECT a.a_id, a.a_number, " +
                "p.p_id, p.p_name, p.p_address, p.contact_number, p.gender, " +
                "d.d_id, d.d_name, " +
                "a.a_datetime, a.status, " +
                "COALESCE(SUM(t.priceLkr), 0) AS totalPrice " +
                "FROM appointment a " +
                "INNER JOIN patient p ON a.p_id = p.p_id " +
                "INNER JOIN dentist d ON a.d_id = d.d_id " +
                "LEFT JOIN treatment_appointment ta ON a.a_id = ta.a_id " +
                "LEFT JOIN apptreatment t ON ta.t_id = t.t_id " +
                "WHERE a.a_id = ? " +
                "GROUP BY a.a_id, a.a_number, p.p_id, p.p_name, " +
                "p.p_address, p.contact_number, p.gender, " +
                "d.d_id, d.d_name, a.a_datetime, a.status";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, appointmentId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    app = new appointment();

                    app.setA_id(rs.getInt("a_id"));
                    app.setA_number(rs.getString("a_number"));

                    app.setP_id(rs.getInt("p_id"));
                    app.setP_name(rs.getString("p_name"));
                    app.setP_address(rs.getString("p_address"));
                    app.setContact_number(
                            rs.getString("contact_number")
                    );
                    app.setGender(rs.getString("gender"));

                    app.setD_id(rs.getInt("d_id"));
                    app.setD_name(rs.getString("d_name"));

                    app.setA_datetime(
                            rs.getTimestamp("a_datetime")
                    );

                    app.setStatus(rs.getString("status"));

                    app.setTotalPrice(
                            rs.getBigDecimal("totalPrice")
                    );
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR getting appointment: " + e.getMessage()
            );

            e.printStackTrace();
        }

        return app;
    }


    public ArrayList<appointment> searchAppointments(String keyword) {

        ArrayList<appointment> appointmentList = new ArrayList<>();

        String sql =
                "SELECT a.a_id, a.a_number, " +
                "p.p_id, p.p_name, p.p_address, p.contact_number, p.gender, " +
                "d.d_id, d.d_name, " +
                "a.a_datetime, a.status, " +
                "COALESCE(SUM(t.priceLkr), 0) AS totalPrice " +
                "FROM appointment a " +
                "INNER JOIN patient p ON a.p_id = p.p_id " +
                "INNER JOIN dentist d ON a.d_id = d.d_id " +
                "LEFT JOIN treatment_appointment ta ON a.a_id = ta.a_id " +
                "LEFT JOIN apptreatment t ON ta.t_id = t.t_id " +
                "WHERE a.a_number LIKE ? " +
                "OR p.p_name LIKE ? " +
                "OR p.contact_number LIKE ? " +
                "OR d.d_name LIKE ? " +
                "OR a.status LIKE ? " +
                "GROUP BY a.a_id, a.a_number, p.p_id, p.p_name, " +
                "p.p_address, p.contact_number, p.gender, " +
                "d.d_id, d.d_name, a.a_datetime, a.status " +
                "ORDER BY a.a_id DESC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            String search = "%" + keyword.trim() + "%";

            stmt.setString(1, search);
            stmt.setString(2, search);
            stmt.setString(3, search);
            stmt.setString(4, search);
            stmt.setString(5, search);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    appointment app = new appointment();

                    app.setA_id(rs.getInt("a_id"));
                    app.setA_number(rs.getString("a_number"));

                    app.setP_id(rs.getInt("p_id"));
                    app.setP_name(rs.getString("p_name"));
                    app.setP_address(rs.getString("p_address"));
                    app.setContact_number(
                            rs.getString("contact_number")
                    );
                    app.setGender(rs.getString("gender"));

                    app.setD_id(rs.getInt("d_id"));
                    app.setD_name(rs.getString("d_name"));

                    app.setA_datetime(
                            rs.getTimestamp("a_datetime")
                    );

                    app.setStatus(rs.getString("status"));

                    app.setTotalPrice(
                            rs.getBigDecimal("totalPrice")
                    );

                    appointmentList.add(app);
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR searching appointments: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return appointmentList;
    }


    public boolean addAppointment(
            appointment app,
            ArrayList<Integer> treatmentIds) {

        String sql =
                "INSERT INTO appointment " +
                "(a_number, p_id, d_id, a_datetime, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;

        try {

            conn = DataBaseConnect.getConnection();

            conn.setAutoCommit(false);

            try (
                    PreparedStatement stmt =
                            conn.prepareStatement(
                                    sql,
                                    PreparedStatement.RETURN_GENERATED_KEYS
                            )
            ) {

                stmt.setString(1, app.getA_number());
                stmt.setInt(2, app.getP_id());
                stmt.setInt(3, app.getD_id());
                stmt.setTimestamp(4, app.getA_datetime());

                String status = app.getStatus();

                if (status == null ||
                        status.trim().isEmpty()) {

                    status = "Pending";
                }

                stmt.setString(5, status);

                int rows = stmt.executeUpdate();

                if (rows == 0) {

                    conn.rollback();

                    return false;
                }

                int appointmentId = 0;

                try (ResultSet keys = stmt.getGeneratedKeys()) {

                    if (keys.next()) {

                        appointmentId = keys.getInt(1);
                    }
                }

                if (appointmentId == 0) {

                    conn.rollback();

                    return false;
                }

                if (treatmentIds != null &&
                        !treatmentIds.isEmpty()) {

                    String treatmentSql =
                            "INSERT INTO treatment_appointment " +
                            "(a_id, t_id) VALUES (?, ?)";

                    try (
                            PreparedStatement treatmentStmt =
                                    conn.prepareStatement(treatmentSql)
                    ) {

                        for (Integer treatmentId : treatmentIds) {

                            if (treatmentId != null) {

                                treatmentStmt.setInt(
                                        1,
                                        appointmentId
                                );

                                treatmentStmt.setInt(
                                        2,
                                        treatmentId
                                );

                                treatmentStmt.addBatch();
                            }
                        }

                        treatmentStmt.executeBatch();
                    }
                }

                conn.commit();

                return true;
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR adding appointment: "
                    + e.getMessage()
            );

            e.printStackTrace();

            try {

                if (conn != null) {
                    conn.rollback();
                }

            } catch (Exception rollbackError) {

                rollbackError.printStackTrace();
            }

            return false;

        } finally {

            try {

                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }

            } catch (Exception closeError) {

                closeError.printStackTrace();
            }
        }
    }


    public boolean updateAppointment(
            appointment app,
            ArrayList<Integer> treatmentIds) {

        String updateSql =
                "UPDATE appointment SET " +
                "a_number = ?, " +
                "p_id = ?, " +
                "d_id = ?, " +
                "a_datetime = ?, " +
                "status = ? " +
                "WHERE a_id = ?";

        Connection conn = null;

        try {

            conn = DataBaseConnect.getConnection();

            conn.setAutoCommit(false);

            try (
                    PreparedStatement stmt =
                            conn.prepareStatement(updateSql)
            ) {

                stmt.setString(1, app.getA_number());
                stmt.setInt(2, app.getP_id());
                stmt.setInt(3, app.getD_id());
                stmt.setTimestamp(4, app.getA_datetime());

                String status = app.getStatus();

                if (status == null ||
                        status.trim().isEmpty()) {

                    status = "Pending";
                }

                stmt.setString(5, status);
                stmt.setInt(6, app.getA_id());

                int rows = stmt.executeUpdate();

                if (rows == 0) {

                    conn.rollback();

                    return false;
                }
            }

            String deleteTreatmentSql =
                    "DELETE FROM treatment_appointment " +
                    "WHERE a_id = ?";

            try (
                    PreparedStatement deleteStmt =
                            conn.prepareStatement(
                                    deleteTreatmentSql
                            )
            ) {

                deleteStmt.setInt(1, app.getA_id());

                deleteStmt.executeUpdate();
            }

            if (treatmentIds != null &&
                    !treatmentIds.isEmpty()) {

                String insertTreatmentSql =
                        "INSERT INTO treatment_appointment " +
                        "(a_id, t_id) VALUES (?, ?)";

                try (
                        PreparedStatement insertStmt =
                                conn.prepareStatement(
                                        insertTreatmentSql
                                )
                ) {

                    for (Integer treatmentId : treatmentIds) {

                        if (treatmentId != null) {

                            insertStmt.setInt(
                                    1,
                                    app.getA_id()
                            );

                            insertStmt.setInt(
                                    2,
                                    treatmentId
                            );

                            insertStmt.addBatch();
                        }
                    }

                    insertStmt.executeBatch();
                }
            }

            conn.commit();

            return true;

        } catch (Exception e) {

            System.out.println(
                    "ERROR updating appointment: "
                    + e.getMessage()
            );

            e.printStackTrace();

            try {

                if (conn != null) {
                    conn.rollback();
                }

            } catch (Exception rollbackError) {

                rollbackError.printStackTrace();
            }

            return false;

        } finally {

            try {

                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }

            } catch (Exception closeError) {

                closeError.printStackTrace();
            }
        }
    }


    public boolean deleteAppointment(int appointmentId) {

        String sql =
                "DELETE FROM appointment " +
                "WHERE a_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, appointmentId);

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR deleting appointment: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }


    public ArrayList<Integer> getTreatmentIdsByAppointmentId(
            int appointmentId) {

        ArrayList<Integer> treatmentIds =
                new ArrayList<>();

        String sql =
                "SELECT t_id " +
                "FROM treatment_appointment " +
                "WHERE a_id = ? " +
                "ORDER BY ta_id";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, appointmentId);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    treatmentIds.add(
                            rs.getInt("t_id")
                    );
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR loading appointment treatments: "
                    + e.getMessage()
            );

            e.printStackTrace();
        }

        return treatmentIds;
    }


    public boolean updateAppointmentStatus(
            int appointmentId,
            String status) {

        String sql =
                "UPDATE appointment SET status = ? " +
                "WHERE a_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, status);
            stmt.setInt(2, appointmentId);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR updating appointment status: "
                    + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }
}
