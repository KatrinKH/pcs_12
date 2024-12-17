import 'package:flutter/material.dart';

class SortFilterDialog extends StatelessWidget {
  final Function(String) onSortSelected;
  final Function(double?, double?) onFilterApplied;

  const SortFilterDialog({
    required this.onSortSelected,
    required this.onFilterApplied,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController minPriceController = TextEditingController();
    TextEditingController maxPriceController = TextEditingController();

    return AlertDialog(
      title: const Text('Сортировка и фильтр'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Сортировать по:'),
          ListTile(
            title: const Text('Дешевле'),
            onTap: () {
              onSortSelected('Дешевле');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Дороже'),
            onTap: () {
              onSortSelected('Дороже');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('По алфавиту'),
            onTap: () {
              onSortSelected('По алфавиту');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Сбросить сортировку'),
            onTap: () {
              onSortSelected('Сбросить');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
          const Text('Фильтр по цене:'),
          TextField(
            controller: minPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Минимальная цена',
            ),
          ),
          TextField(
            controller: maxPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Максимальная цена',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final minPrice = double.tryParse(minPriceController.text);
            final maxPrice = double.tryParse(maxPriceController.text);
            onFilterApplied(minPrice, maxPrice);
            Navigator.pop(context);
          },
          child: const Text('Применить'),
        ),
      ],
    );
  }
}
