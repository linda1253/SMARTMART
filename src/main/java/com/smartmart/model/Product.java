package com.smartmart.model;

/**
 * POJO representing a product in the store.
 */
public class Product {
    private int productId;
    private String productName;
    private String description;
    private double price;
    private int stock;
    private int categoryId;
    private String categoryName;   // populated via JOIN for display
    private Integer supplierId;
    private String supplierName;   // populated via JOIN for display

    public Product() {}

    // ── Getters & Setters ──────────────────────────────────────
    public int getProductId()                         { return productId; }
    public void setProductId(int productId)           { this.productId = productId; }

    public String getProductName()                    { return productName; }
    public void setProductName(String productName)    { this.productName = productName; }

    public String getDescription()                    { return description; }
    public void setDescription(String description)    { this.description = description; }

    public double getPrice()                          { return price; }
    public void setPrice(double price)                { this.price = price; }

    public int getStock()                             { return stock; }
    public void setStock(int stock)                   { this.stock = stock; }

    public int getCategoryId()                        { return categoryId; }
    public void setCategoryId(int categoryId)         { this.categoryId = categoryId; }

    public String getCategoryName()                   { return categoryName; }
    public void setCategoryName(String categoryName)  { this.categoryName = categoryName; }

    public Integer getSupplierId()                    { return supplierId; }
    public void setSupplierId(Integer supplierId)     { this.supplierId = supplierId; }

    public String getSupplierName()                   { return supplierName; }
    public void setSupplierName(String supplierName)  { this.supplierName = supplierName; }
}
