import 'package:flutter/material.dart';
import 'package:pcs_12/model/order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Информация о заказе',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Дата заказа: ${order.orderDate.toLocal()}'),
            const SizedBox(height: 8),
            Text('Количество товаров: ${order.totalQuantity} шт.'),
            const SizedBox(height: 8),
            Text('Общая стоимость: \Р${order.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Контактная информация',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Имя: ${order.name}'),
            const SizedBox(height: 8),
            Text('Адрес доставки: ${order.address}'),
            const SizedBox(height: 8),
            Text('Контактный телефон: ${order.phone}'),
          ],
        ),
      ),
    );
  }
}