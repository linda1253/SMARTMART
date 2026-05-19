package com.smartmart.model;

import java.time.LocalDateTime;
import java.util.List;

/**
 * POJO representing a customer order.
 */
public class Order {
    private int orderId;
    private LocalDateTime orderDate;
    private String orderStatus;      // Pending | Processing | Completed | Cancelled
    private double totalAmount;
    private String deliveryAddress;
    private int userId;
    private String customerName;     // populated via JOIN for display
    private List<OrderItem> items;   // populated when full order detail is needed

    public Order() {}

    // ── Getters & Setters ──────────────────────────────────────
    public int getOrderId()                           { return orderId; }
    public void setOrderId(int orderId)               { this.orderId = orderId; }

    public LocalDateTime getOrderDate()               { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public String getOrderStatus()                    { return orderStatus; }
    public void setOrderStatus(String orderStatus)    { this.orderStatus = orderStatus; }

    public double getTotalAmount()                    { return totalAmount; }
    public void setTotalAmount(double totalAmount)    { this.totalAmount = totalAmount; }

    public String getDeliveryAddress()                { return deliveryAddress; }
    public void setDeliveryAddress(String addr)       { this.deliveryAddress = addr; }

    public int getUserId()                            { return userId; }
    public void setUserId(int userId)                 { this.userId = userId; }

    public String getCustomerName()                   { return customerName; }
    public void setCustomerName(String customerName)  { this.customerName = customerName; }

    public List<OrderItem> getItems()                 { return items; }
    public void setItems(List<OrderItem> items)       { this.items = items; }
}
