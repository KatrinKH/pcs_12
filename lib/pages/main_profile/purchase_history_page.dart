import 'package:flutter/material.dart';
import 'package:pcs_12/pages/main_home/shopping cart/order_service.dart';
import 'package:pcs_12/model/order_model.dart';
import 'package:pcs_12/pages/main_home/shopping cart/order_details_page.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderService orderService = OrderService();
    final List<Order> orders = orderService.orders; // Получаем список заказов

    return Scaffold(
      appBar: AppBar(
        title: const Text('История покупок'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'У вас пока нет заказов.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'Заказ от ${order.orderDate.toLocal()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Количество товаров: ${order.totalQuantity} шт.'),
                        Text('Общая стоимость: \Р${order.totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}