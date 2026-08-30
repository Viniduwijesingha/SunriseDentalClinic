package model;

public class patient {

    private int p_id;
    private String p_name;
    private String p_address;
    private String contact_number;
    private String gender;
    private java.sql.Timestamp register_datetime;
    private String status;

    public patient() {

    }

    public patient(int p_id, String p_name, String p_address,
                   String contact_number, String gender,
                   java.sql.Timestamp register_datetime,
                   String status) {

        this.p_id = p_id;
        this.p_name = p_name;
        this.p_address = p_address;
        this.contact_number = contact_number;
        this.gender = gender;
        this.register_datetime = register_datetime;
        this.status = status;
    }


    public int getP_id() {

        return p_id;
    }

    public void setP_id(int p_id) {

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


    public java.sql.Timestamp getRegister_datetime() {

        return register_datetime;
    }

    public void setRegister_datetime(java.sql.Timestamp register_datetime) {

        this.register_datetime = register_datetime;
    }


    public String getStatus() {

        return status;
    }

    public void setStatus(String status) {

        this.status = status;
    }
}