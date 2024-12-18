import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pcs_12/pages/main_home/shopping cart/checkout_page.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem;

  const CartPage({super.key, required this.cartItems, required this.onRemoveItem});

  @override
  Widget build(BuildContext context) {
    int totalQuantity = cartItems.length;
    double totalPrice = 0.0;

    for (var item in cartItems) {
      totalPrice += item['Price'] ?? 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final name = item['Name'] ?? 'Без названия';
                final imageUrl = item['ImageURL'] ?? '';
                final price = item['Price'] != null ? '\Р${item['Price']}' : 'Цена не указана';

                return Slidable(
                  key: ValueKey(item['id']),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          _showConfirmationDialog(context, index);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Удалить',
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(price),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null // скрываем кнопку, если корзина пуста
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        totalQuantity: totalQuantity,
                        totalPrice: totalPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color(0xFF67BEEA),
                ),
                child: Text(
                  'К оформлению: $totalQuantity игры, \Р${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }

  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить товар?'),
          content: const Text('Вы уверены, что хотите удалить этот товар из корзины?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (index >= 0 && index < cartItems.length) {
                  onRemoveItem(index);
                } else {
                  print('Ошибка: некорректный индекс $index');
                }
                Navigator.of(context).pop();
              },
              child: const Text('Да'),
            ),
          ],
        );
      },
    );
  }
}
