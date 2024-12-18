import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pcs_12/components/product_card.dart';
import 'package:pcs_12/widgets/add_product_dialog.dart';
import 'package:pcs_12/pages/main_home/product_detail_page.dart';
import 'package:pcs_12/pages/main_home/shopping_page.dart'; 
import 'package:pcs_12/pages/main_home/sort_abd_filter/product_service.dart';
import 'package:pcs_12/pages/main_home/sort_abd_filter/sort_filter_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _notesStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  final List<Map<String, dynamic>> _cartItems = [];
  String _searchQuery = ''; 
  bool _isSearching = false; 

  String _sortCriteria = 'Сбросить'; 
  List<Map<String, dynamic>>? _originalNotes; 
  double? _minPrice;
  double? _maxPrice;

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => const AddProductDialog(),
    );
  }

  void _updateCartStatus(Map<String, dynamic> product, bool isInCart) {
    setState(() {
      if (isInCart) {
        _cartItems.add(product); 
      } else {
        _cartItems.removeWhere((item) => item['id'] == product['id']); 
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      if (index >= 0 && index < _cartItems.length) {
        _cartItems.removeAt(index); 
      } else {
        print('Ошибка: некорректный индекс $index для удаления');
      }
    });
  }

  void _showSortAndFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => SortFilterDialog(
        onSortSelected: (criteria) {
          setState(() {
            _sortCriteria = criteria;
          });
        },
        onFilterApplied: (minPrice, maxPrice) {
          setState(() {
            _minPrice = minPrice;
            _maxPrice = maxPrice;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: _showSortAndFilterDialog,
        ),
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Поиск товаров...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : const Text('Видеоигры'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addNewNote,
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: _cartItems,
                    onRemoveItem: _removeFromCart, 
                  ),
                ),
              ).then((_) {
                setState(() {}); 
              });
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF67BEEA),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data;
          if (notes == null || notes.isEmpty) {
            return const Center(child: Text('Нет товаров'));
          }

          _originalNotes ??= List.from(notes);

          final sortedNotes = ProductService.sortNotes(List.from(notes), _sortCriteria);
          final filteredNotes = ProductService.filterNotes(sortedNotes, _searchQuery, _minPrice, _maxPrice);

          if (filteredNotes.isEmpty) {
            return const Center(child: Text('Товары не найдены'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            padding: const EdgeInsets.all(10.0),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              final name = note['Name'] ?? 'Без названия';
              final imageUrl = note['ImageURL'] ?? '';
              final description = note['Description'] ?? 'Нет описания';
              final price = note['Price'] != null ? '\Р${note['Price']}' : 'Цена не указана';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: note),
                    ),
                  );
                },
                child: ProductCard(
                  name: name,
                  imageUrl: imageUrl,
                  description: description,
                  price: price,
                  onCartStatusChanged: (isInCart) {
                    _updateCartStatus(note, isInCart);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
