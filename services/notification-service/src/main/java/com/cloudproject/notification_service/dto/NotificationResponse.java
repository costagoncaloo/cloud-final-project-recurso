package com.cloudproject.notification_service.dto;

import com.cloudproject.notification_service.model.NotificationStatus;

import java.time.LocalDateTime;

public class NotificationResponse {

    private String message;
    private NotificationStatus status;
    private LocalDateTime processedAt;

    public NotificationResponse() {
    }

    public NotificationResponse(String message, NotificationStatus status, LocalDateTime processedAt) {
        this.message = message;
        this.status = status;
        this.processedAt = processedAt;
    }

    public String getMessage() {
        return message;
    }

    public NotificationStatus getStatus() {
        return status;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }
}