import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String price;

  const ProductCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ограничиваем размер изображения, чтобы карточки выглядели одинаково
            Container(
              height: 150, // фиксированная высота изображения
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            // Ограничиваем описание, чтобы оно не выходило за пределы
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Spacer(), // Spacer, чтобы иконки были всегда внизу
            // Иконки внизу
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Иконка сердца
                IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 24, // Размер иконки
                  ),
                  onPressed: () {
                    // Добавьте ваш обработчик для иконки сердца
                  },
                ),
                // Иконка корзины
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 24, // Размер иконки
                  ),
                  onPressed: () {
                    // Добавьте ваш обработчик для иконки корзины
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
