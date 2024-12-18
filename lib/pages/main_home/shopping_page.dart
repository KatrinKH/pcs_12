import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemoveItem; // Функция для удаления товара

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
                  key: ValueKey(item['id']),  // Уникальный ключ для Slidable
                  endActionPane: ActionPane(  // Слайд-акция будет слева направо
                    motion: const DrawerMotion(),  // Эффект сдвига
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          onRemoveItem(index); // Удаляем товар из корзины
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Удалить',
                      ),
                    ],
                  ),
                  child: Card(  // Используем Card для создания одинакового дизайна
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Закругленные углы
                    ),
                    elevation: 5,  // Легкая тень для карточки
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // Закругленные углы для изображения
                        child: Image.network(
                          imageUrl,
                          width: 80,  // Устанавливаем фиксированную ширину изображения
                          height: 80,  // Устанавливаем фиксированную высоту изображения
                          fit: BoxFit.cover, // Изображение должно покрывать область
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
}
