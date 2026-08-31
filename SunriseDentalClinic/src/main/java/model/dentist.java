package model;

public class dentist {

    private int d_id;
    private String d_name;
    private String specialization;
    private String dcontact_number;
    private String status;

    public dentist() {

    }

    public dentist(int d_id, String d_name, String specialization,
                   String dcontact_number, String status) {

        this.d_id = d_id;
        this.d_name = d_name;
        this.specialization = specialization;
        this.dcontact_number = dcontact_number;
        this.status = status;
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


    public String getSpecialization() {

        return specialization;
    }

    public void setSpecialization(String specialization) {

        this.specialization = specialization;
    }


    public String getDcontact_number() {

        return dcontact_number;
    }

    public void setDcontact_number(String dcontact_number) {

        this.dcontact_number = dcontact_number;
    }


    public String getStatus() {

        return status;
    }

    public void setStatus(String status) {

        this.status = status;
    }
}