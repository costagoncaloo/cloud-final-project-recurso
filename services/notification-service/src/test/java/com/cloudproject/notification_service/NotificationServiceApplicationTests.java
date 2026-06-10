package com.cloudproject.notification_service;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(properties = {
        "sqs.polling.enabled=false"
})
class NotificationServiceApplicationTests {

    @Test
    void contextLoads() {
    }

}
