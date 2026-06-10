package com.cloudproject.order_service.dto;

import java.time.LocalDateTime;

public class OrderCreatedEvent {

    private String eventType;
    private Long orderId;
    private Long productId;
    private Integer quantity;
    private LocalDateTime createdAt;

    public OrderCreatedEvent() {
    }

    public OrderCreatedEvent(String eventType, Long orderId, Long productId, Integer quantity, LocalDateTime createdAt) {
        this.eventType = eventType;
        this.orderId = orderId;
        this.productId = productId;
        this.quantity = quantity;
        this.createdAt = createdAt;
    }

    public String getEventType() {
        return eventType;
    }

    public Long getOrderId() {
        return orderId;
    }

    public Long getProductId() {
        return productId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
