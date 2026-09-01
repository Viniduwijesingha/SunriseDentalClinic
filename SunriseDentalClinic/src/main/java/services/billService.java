package services;

import controller.DataBaseConnect;
import model.bill;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class billService {

    public ArrayList<bill> getAllBills() {

        ArrayList<bill> billList = new ArrayList<>();

        String sql =
                "SELECT b.b_id, b.b_number, b.amount, b.status, b.issued_date, " +
                "a.a_id, a.a_number, a.a_datetime, " +
                "p.p_id, p.p_name, p.contact_number, " +
                "d.d_id, d.d_name " +
                "FROM bill b " +
                "INNER JOIN appointment a ON b.a_id = a.a_id " +
                "INNER JOIN patient p ON a.p_id = p.p_id " +
                "INNER JOIN dentist d ON a.d_id = d.d_id " +
                "ORDER BY b.b_id DESC";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            while (rs.next()) {
                billList.add(mapRow(rs));
            }

        } catch (Exception e) {

            System.out.println("ERROR loading bills: " + e.getMessage());

            e.printStackTrace();
        }

        return billList;
    }


    public bill getBillById(int billId) {

        bill result = null;

        String sql =
                "SELECT b.b_id, b.b_number, b.amount, b.status, b.issued_date, " +
                "a.a_id, a.a_number, a.a_datetime, " +
                "p.p_id, p.p_name, p.contact_number, " +
                "d.d_id, d.d_name " +
                "FROM bill b " +
                "INNER JOIN appointment a ON b.a_id = a.a_id " +
                "INNER JOIN patient p ON a.p_id = p.p_id " +
                "INNER JOIN dentist d ON a.d_id = d.d_id " +
                "WHERE b.b_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, billId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    result = mapRow(rs);
                }
            }

        } catch (Exception e) {

            System.out.println("ERROR getting bill: " + e.getMessage());

            e.printStackTrace();
        }

        return result;
    }


    public ArrayList<bill> searchBills(String keyword) {

        ArrayList<bill> billList = new ArrayList<>();

        String sql =
                "SELECT b.b_id, b.b_number, b.amount, b.status, b.issued_date, " +
                "a.a_id, a.a_number, a.a_datetime, " +
                "p.p_id, p.p_name, p.contact_number, " +
                "d.d_id, d.d_name " +
                "FROM bill b " +
                "INNER JOIN appointment a ON b.a_id = a.a_id " +
                "INNER JOIN patient p ON a.p_id = p.p_id " +
                "INNER JOIN dentist d ON a.d_id = d.d_id " +
                "WHERE b.b_number LIKE ? " +
                "OR a.a_number LIKE ? " +
                "OR p.p_name LIKE ? " +
                "OR p.contact_number LIKE ? " +
                "OR d.d_name LIKE ? " +
                "OR b.status LIKE ? " +
                "ORDER BY b.b_id DESC";

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
            stmt.setString(6, search);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    billList.add(mapRow(rs));
                }
            }

        } catch (Exception e) {

            System.out.println("ERROR searching bills: " + e.getMessage());

            e.printStackTrace();
        }

        return billList;
    }


    /**
     * Works out the next bill number by looking at the most recently
     * inserted one (e.g. "BILL-0007" -> "BILL-0008"). Falls back to
     * "BILL-0001" if there are no bills yet.
     */
    public String generateNextBillNumber() {

        String prefix = "BILL-";
        int nextSeq = 1;

        String sql =
                "SELECT b_number FROM bill " +
                "ORDER BY b_id DESC LIMIT 1";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()
        ) {

            if (rs.next()) {

                String lastNumber = rs.getString("b_number");

                if (lastNumber != null) {

                    Matcher matcher =
                            Pattern.compile("(\\d+)$").matcher(lastNumber.trim());

                    if (matcher.find()) {
                        nextSeq = Integer.parseInt(matcher.group(1)) + 1;
                    }

                    Matcher prefixMatcher =
                            Pattern.compile("^(\\D*)\\d+$").matcher(lastNumber.trim());

                    if (prefixMatcher.find() &&
                            !prefixMatcher.group(1).isEmpty()) {

                        prefix = prefixMatcher.group(1);
                    }
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR generating bill number: " + e.getMessage()
            );

            e.printStackTrace();
        }

        return prefix + String.format("%04d", nextSeq);
    }


    /**
     * Raises a new bill for an appointment. The amount is computed
     * automatically from the sum of the treatments linked to that
     * appointment, the same total shown on the appointment list/view.
     */
    public boolean addBill(int appointmentId, String status) {

        String totalSql =
                "SELECT COALESCE(SUM(t.priceLkr), 0) AS totalPrice " +
                "FROM treatment_appointment ta " +
                "INNER JOIN apptreatment t ON ta.t_id = t.t_id " +
                "WHERE ta.a_id = ?";

        String insertSql =
                "INSERT INTO bill " +
                "(b_number, a_id, amount, status, issued_date) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DataBaseConnect.getConnection()) {

            BigDecimal amount = BigDecimal.ZERO;

            try (PreparedStatement totalStmt = conn.prepareStatement(totalSql)) {

                totalStmt.setInt(1, appointmentId);

                try (ResultSet rs = totalStmt.executeQuery()) {

                    if (rs.next()) {
                        amount = rs.getBigDecimal("totalPrice");
                    }
                }
            }

            String billNumber = generateNextBillNumber();

            String billStatus = status;

            if (billStatus == null || billStatus.trim().isEmpty()) {
                billStatus = "Unpaid";
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {

                insertStmt.setString(1, billNumber);
                insertStmt.setInt(2, appointmentId);
                insertStmt.setBigDecimal(3, amount);
                insertStmt.setString(4, billStatus);
                insertStmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));

                return insertStmt.executeUpdate() > 0;
            }

        } catch (Exception e) {

            System.out.println("ERROR adding bill: " + e.getMessage());

            e.printStackTrace();

            return false;
        }
    }


    public boolean updateBillStatus(int billId, String status) {

        String sql = "UPDATE bill SET status = ? WHERE b_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setString(1, status);
            stmt.setInt(2, billId);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR updating bill status: " + e.getMessage()
            );

            e.printStackTrace();

            return false;
        }
    }


    public boolean deleteBill(int billId) {

        String sql = "DELETE FROM bill WHERE b_id = ?";

        try (
                Connection conn = DataBaseConnect.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)
        ) {

            stmt.setInt(1, billId);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println("ERROR deleting bill: " + e.getMessage());

            e.printStackTrace();

            return false;
        }
    }


    private bill mapRow(ResultSet rs) throws Exception {

        bill b = new bill();

        b.setB_id(rs.getInt("b_id"));
        b.setB_number(rs.getString("b_number"));
        b.setAmount(rs.getBigDecimal("amount"));
        b.setStatus(rs.getString("status"));
        b.setIssuedDate(rs.getTimestamp("issued_date"));

        b.setA_id(rs.getInt("a_id"));
        b.setA_number(rs.getString("a_number"));
        b.setA_datetime(rs.getTimestamp("a_datetime"));

        b.setP_id(rs.getInt("p_id"));
        b.setP_name(rs.getString("p_name"));
        b.setContact_number(rs.getString("contact_number"));

        b.setD_id(rs.getInt("d_id"));
        b.setD_name(rs.getString("d_name"));

        return b;
    }
}