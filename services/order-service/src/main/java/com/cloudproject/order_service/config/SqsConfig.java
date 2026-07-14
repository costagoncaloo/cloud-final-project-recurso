package com.cloudproject.order_service.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sqs.SqsClient;

@Configuration
public class SqsConfig {

    @Bean
    public SqsClient sqsClient(@Value("${aws.region:eu-west-1}") String awsRegion) {
        return SqsClient.builder()
                .region(Region.of(awsRegion))
                .build();
    }
}
