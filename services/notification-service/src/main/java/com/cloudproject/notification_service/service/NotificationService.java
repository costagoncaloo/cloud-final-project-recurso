package com.cloudproject.notification_service.service;

import com.cloudproject.notification_service.dto.NotificationResponse;
import com.cloudproject.notification_service.dto.OrderCreatedEvent;
import com.cloudproject.notification_service.model.NotificationStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class NotificationService {

    public NotificationResponse processOrderCreatedEvent(OrderCreatedEvent event) {
        String message = "Notification processed for order "
                + event.getOrderId()
                + " with product "
                + event.getProductId()
                + " and quantity "
                + event.getQuantity();

        System.out.println(message);

        return new NotificationResponse(
                message,
                NotificationStatus.PROCESSED,
                LocalDateTime.now()
        );
    }
}