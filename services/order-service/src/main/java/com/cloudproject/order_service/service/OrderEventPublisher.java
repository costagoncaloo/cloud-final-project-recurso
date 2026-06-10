package com.cloudproject.order_service.service;

import com.cloudproject.order_service.dto.OrderCreatedEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

@Service
public class OrderEventPublisher {

    private final SqsClient sqsClient;
    private final ObjectMapper objectMapper;
    private final String queueUrl;

    public OrderEventPublisher(
            SqsClient sqsClient,
            ObjectMapper objectMapper,
            @Value("${sqs.queue.url}") String queueUrl
    ) {
        this.sqsClient = sqsClient;
        this.objectMapper = objectMapper;
        this.queueUrl = queueUrl;
    }

    public void publishOrderCreated(OrderCreatedEvent event) {
        try {
            String messageBody = objectMapper.writeValueAsString(event);
            sqsClient.sendMessage(SendMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .messageBody(messageBody)
                    .build());
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("Could not serialize order-created event", exception);
        }
    }
}
