package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class appointment {

    private int a_id;
    private String a_number;
    private Integer p_id;
    private String p_name;
    private String p_address;
    private String contact_number;
    private String gender;
    private int d_id;
    private String d_name;
    private Timestamp a_datetime;
    private String status;
    private List<Integer> treatmentIds;
    private List<String> treatmentNames;
    private BigDecimal totalPrice;

    public appointment() {
    }

    public appointment(
            int a_id,
            String a_number,
            Integer p_id,
            String p_name,
            String p_address,
            String contact_number,
            String gender,
            int d_id,
            String d_name,
            Timestamp a_datetime,
            String status,
            List<Integer> treatmentIds,
            List<String> treatmentNames,
            BigDecimal totalPrice) {
        this.a_id = a_id;
        this.a_number = a_number;
        this.p_id = p_id;
        this.p_name = p_name;
        this.p_address = p_address;
        this.contact_number = contact_number;
        this.gender = gender;
        this.d_id = d_id;
        this.d_name = d_name;
        this.a_datetime = a_datetime;
        this.status = status;
        this.treatmentIds = treatmentIds;
        this.treatmentNames = treatmentNames;
        this.totalPrice = totalPrice;
    }

    public int getA_id() {
        return a_id;
    }

    public void setA_id(int a_id) {
        this.a_id = a_id;
    }

    public String getA_number() {
        return a_number;
    }

    public void setA_number(String a_number) {
        this.a_number = a_number;
    }

    public Integer getP_id() {
        return p_id;
    }

    public void setP_id(Integer p_id) {
        this.p_id = p_id;
    }

    public String getP_name() {
        return p_name;
    }

    public void setP_name(String p_name) {
        this.p_name = p_name;
    }

    public String getP_address() {
        return p_address;
    }

    public void setP_address(String p_address) {
        this.p_address = p_address;
    }

    public String getContact_number() {
        return contact_number;
    }

    public void setContact_number(String contact_number) {
        this.contact_number = contact_number;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getD_id() {
        return d_id;
    }

    public void setD_id(int d_id) {
        this.d_id = d_id;
    }

    public String getD_name() {
        return d_name;
    }

    public void setD_name(String d_name) {
        this.d_name = d_name;
    }

    public Timestamp getA_datetime() {
        return a_datetime;
    }

    public void setA_datetime(Timestamp a_datetime) {
        this.a_datetime = a_datetime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<Integer> getTreatmentIds() {
        return treatmentIds;
    }

    public void setTreatmentIds(List<Integer> treatmentIds) {
        this.treatmentIds = treatmentIds;
    }

    public List<String> getTreatmentNames() {
        return treatmentNames;
    }

    public void setTreatmentNames(List<String> treatmentNames) {
        this.treatmentNames = treatmentNames;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}