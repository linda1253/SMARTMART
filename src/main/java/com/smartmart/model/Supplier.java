package com.smartmart.model;

/**
 * POJO representing a product supplier.
 */
public class Supplier {
    private int supplierId;
    private String supplierName;
    private String contactName;
    private String email;
    private String phone;
    private String address;

    public Supplier() {}

    public Supplier(int supplierId, String supplierName, String contactName,
                    String email, String phone, String address) {
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.contactName = contactName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    // ── Getters & Setters ──────────────────────────────────────
    public int getSupplierId()                        { return supplierId; }
    public void setSupplierId(int supplierId)         { this.supplierId = supplierId; }

    public String getSupplierName()                   { return supplierName; }
    public void setSupplierName(String supplierName)  { this.supplierName = supplierName; }

    public String getContactName()                    { return contactName; }
    public void setContactName(String contactName)    { this.contactName = contactName; }

    public String getEmail()                          { return email; }
    public void setEmail(String email)                { this.email = email; }

    public String getPhone()                          { return phone; }
    public void setPhone(String phone)                { this.phone = phone; }

    public String getAddress()                        { return address; }
    public void setAddress(String address)            { this.address = address; }
}
