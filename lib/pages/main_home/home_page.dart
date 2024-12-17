import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pcs_12/components/product_card.dart';
import 'package:pcs_12/widgets/add_product_dialog.dart';
import 'package:pcs_12/pages/main_home/shopping_page.dart';
import 'package:pcs_12/pages/main_home/product_detail_page.dart';

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
  double? _minPrice; // Минимальная цена для фильтра
  double? _maxPrice; // Максимальная цена для фильтра

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => const AddProductDialog(),
    );
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(product);
    });
  }

  List<Map<String, dynamic>> _sortNotes(List<Map<String, dynamic>> notes) {
    switch (_sortCriteria) {
      case 'Дешевле':
        notes.sort((a, b) => (a['Price'] ?? 0).compareTo(b['Price'] ?? 0));
        break;
      case 'Дороже':
        notes.sort((a, b) => (b['Price'] ?? 0).compareTo(a['Price'] ?? 0));
        break;
      case 'По алфавиту':
        notes.sort((a, b) => (a['Name'] ?? '').compareTo(b['Name'] ?? ''));
        break;
      case 'Сбросить':
      default:
        return _originalNotes ?? notes;
    }
    return notes;
  }

  List<Map<String, dynamic>> _filterNotes(List<Map<String, dynamic>> notes) {
    var filteredNotes = notes;

    // Фильтрация по цене
    if (_minPrice != null) {
      filteredNotes = filteredNotes.where((note) => (note['Price'] ?? double.infinity) >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      filteredNotes = filteredNotes.where((note) => (note['Price'] ?? 0) <= _maxPrice!).toList();
    }

    // Фильтрация по поисковому запросу
    if (_searchQuery.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) => note['Name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return filteredNotes;
  }

  void _showSortAndFilterDialog() {
    TextEditingController minPriceController = TextEditingController();
    TextEditingController maxPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Сортировка и фильтр'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Сортировать по:'),
              ListTile(
                title: const Text('Дешевле'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'Дешевле';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Дороже'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'Дороже';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('По алфавиту'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'По алфавиту';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Сбросить сортировку'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'Сбросить';
                  });
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
                setState(() {
                  _minPrice = double.tryParse(minPriceController.text);
                  _maxPrice = double.tryParse(maxPriceController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Применить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: _showSortAndFilterDialog, // Открытие диалога сортировки и фильтрации
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
                  builder: (context) => CartPage(cartItems: _cartItems),
                ),
              );
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

          final sortedNotes = _sortNotes(List.from(notes));
          final filteredNotes = _filterNotes(sortedNotes);

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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
