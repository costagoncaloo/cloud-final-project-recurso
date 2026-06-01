package com.cloudproject.notification_service.controller;

import com.cloudproject.notification_service.dto.NotificationResponse;
import com.cloudproject.notification_service.dto.OrderCreatedEvent;
import com.cloudproject.notification_service.service.NotificationService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @PostMapping("/process-order")
    @ResponseStatus(HttpStatus.CREATED)
    public NotificationResponse processOrderCreatedEvent(@Valid @RequestBody OrderCreatedEvent event) {
        return notificationService.processOrderCreatedEvent(event);
    }
}