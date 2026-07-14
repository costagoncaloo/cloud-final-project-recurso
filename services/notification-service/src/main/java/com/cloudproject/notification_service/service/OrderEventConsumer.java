package com.cloudproject.notification_service.service;

import com.cloudproject.notification_service.dto.OrderCreatedEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.DeleteMessageRequest;
import software.amazon.awssdk.services.sqs.model.Message;
import software.amazon.awssdk.services.sqs.model.ReceiveMessageRequest;

import java.util.List;

@Service
public class OrderEventConsumer {

    private final SqsClient sqsClient;
    private final ObjectMapper objectMapper;
    private final NotificationService notificationService;
    private final String queueUrl;

    public OrderEventConsumer(
            SqsClient sqsClient,
            ObjectMapper objectMapper,
            NotificationService notificationService,
            @Value("${app.sqs.order-events-queue-url:}") String queueUrl
    ) {
        this.sqsClient = sqsClient;
        this.objectMapper = objectMapper;
        this.notificationService = notificationService;
        this.queueUrl = queueUrl;
    }

    @Scheduled(fixedDelay = 5000)
    public void pollOrderEvents() {
        if (!StringUtils.hasText(queueUrl)) {
            return;
        }

        List<Message> messages = sqsClient.receiveMessage(ReceiveMessageRequest.builder()
                .queueUrl(queueUrl)
                .maxNumberOfMessages(5)
                .waitTimeSeconds(10)
                .build()).messages();

        for (Message message : messages) {
            processMessage(message);
        }
    }

    private void processMessage(Message message) {
        try {
            OrderCreatedEvent event = objectMapper.readValue(message.body(), OrderCreatedEvent.class);
            notificationService.processOrderCreatedEvent(event);

            sqsClient.deleteMessage(DeleteMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .receiptHandle(message.receiptHandle())
                    .build());
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("Failed to deserialize order event", exception);
        }
    }
}
