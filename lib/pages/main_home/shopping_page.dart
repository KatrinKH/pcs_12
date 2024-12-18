import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem; 

  const CartPage({super.key, required this.cartItems, required this.onRemoveItem});

  @override
  Widget build(BuildContext context) {
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
