package com.smartmart.model;

/**
 * POJO representing a single line item within an order.
 */
public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int productId;
    private String productName;   // populated via JOIN for display
    private int quantity;
    private double price;         // price at time of order

    public OrderItem() {}

    public OrderItem(int productId, int quantity, double price) {
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
    }

    // ── Getters & Setters ──────────────────────────────────────
    public int getOrderItemId()                       { return orderItemId; }
    public void setOrderItemId(int orderItemId)       { this.orderItemId = orderItemId; }

    public int getOrderId()                           { return orderId; }
    public void setOrderId(int orderId)               { this.orderId = orderId; }

    public int getProductId()                         { return productId; }
    public void setProductId(int productId)           { this.productId = productId; }

    public String getProductName()                    { return productName; }
    public void setProductName(String productName)    { this.productName = productName; }

    public int getQuantity()                          { return quantity; }
    public void setQuantity(int quantity)             { this.quantity = quantity; }

    public double getPrice()                          { return price; }
    public void setPrice(double price)                { this.price = price; }

    /** Convenience: quantity × price */
    public double getSubtotal()                       { return quantity * price; }
}
