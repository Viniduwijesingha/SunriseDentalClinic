package model;

import java.math.BigDecimal;

public class apptreatment {

    private int t_id;
    private String t_name;
    private BigDecimal priceLkr;
    private String status;

    public apptreatment() {

    }

    public apptreatment(int t_id, String t_name,
                        BigDecimal priceLkr, String status) {

        this.t_id = t_id;
        this.t_name = t_name;
        this.priceLkr = priceLkr;
        this.status = status;
    }


    public int getT_id() {

        return t_id;
    }

    public void setT_id(int t_id) {

        this.t_id = t_id;
    }


    public String getT_name() {

        return t_name;
    }

    public void setT_name(String t_name) {

        this.t_name = t_name;
    }


    public BigDecimal getPriceLkr() {

        return priceLkr;
    }

    public void setPriceLkr(BigDecimal priceLkr) {

        this.priceLkr = priceLkr;
    }


    public String getStatus() {

        return status;
    }

    public void setStatus(String status) {

        this.status = status;
    }
}