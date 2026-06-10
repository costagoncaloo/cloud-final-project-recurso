package com.cloudproject.notification_service.service;

import com.cloudproject.notification_service.dto.OrderCreatedEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.DeleteMessageRequest;
import software.amazon.awssdk.services.sqs.model.Message;
import software.amazon.awssdk.services.sqs.model.ReceiveMessageRequest;

@Service
public class OrderCreatedEventConsumer {

    private final SqsClient sqsClient;
    private final ObjectMapper objectMapper;
    private final NotificationService notificationService;
    private final String queueUrl;
    private final boolean pollingEnabled;

    public OrderCreatedEventConsumer(
            SqsClient sqsClient,
            ObjectMapper objectMapper,
            NotificationService notificationService,
            @Value("${sqs.queue.url}") String queueUrl,
            @Value("${sqs.polling.enabled}") boolean pollingEnabled
    ) {
        this.sqsClient = sqsClient;
        this.objectMapper = objectMapper;
        this.notificationService = notificationService;
        this.queueUrl = queueUrl;
        this.pollingEnabled = pollingEnabled;
    }

    @Scheduled(fixedDelayString = "${sqs.polling.delay-ms}")
    public void pollOrderCreatedEvents() {
        if (!pollingEnabled) {
            return;
        }

        var response = sqsClient.receiveMessage(ReceiveMessageRequest.builder()
                .queueUrl(queueUrl)
                .maxNumberOfMessages(5)
                .waitTimeSeconds(5)
                .build());

        for (Message message : response.messages()) {
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
            throw new IllegalStateException("Could not deserialize order-created event", exception);
        }
    }
}
