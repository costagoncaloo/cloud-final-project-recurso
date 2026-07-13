package com.cloudproject.order_service.service;

import com.cloudproject.order_service.dto.OrderRequest;
import com.cloudproject.order_service.dto.OrderResponse;
import com.cloudproject.order_service.exception.OrderNotFoundException;
import com.cloudproject.order_service.model.Order;
import com.cloudproject.order_service.model.OrderStatus;
import com.cloudproject.order_service.repository.OrderRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    public List<OrderResponse> getAllOrders() {
        return orderRepository.findAll()
                .stream()
                .map(this::mapToResponse)
                .toList();
    }

    public OrderResponse getOrderById(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new OrderNotFoundException(id));

        return mapToResponse(order);
    }

    public OrderResponse createOrder(OrderRequest request) {
        Order order = new Order(
                request.getProductId(),
                request.getQuantity(),
                OrderStatus.CREATED,
                LocalDateTime.now()
        );

        Order savedOrder = orderRepository.save(order);

        return mapToResponse(savedOrder);
    }

    public OrderResponse updateOrder(Long id, OrderRequest request) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new OrderNotFoundException(id));

        order.setProductId(request.getProductId());
        order.setQuantity(request.getQuantity());

        Order updatedOrder = orderRepository.save(order);

        return mapToResponse(updatedOrder);
    }

    public OrderResponse updateOrderStatus(Long id, OrderStatus status) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new OrderNotFoundException(id));

        order.setStatus(status);

        Order updatedOrder = orderRepository.save(order);

        return mapToResponse(updatedOrder);
    }

    public void deleteOrder(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new OrderNotFoundException(id));

        orderRepository.delete(order);
    }

    private OrderResponse mapToResponse(Order order) {
        return new OrderResponse(
                order.getId(),
                order.getProductId(),
                order.getQuantity(),
                order.getStatus(),
                order.getCreatedAt()
        );
    }
}
