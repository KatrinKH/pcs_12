import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String price;
  final Function(bool) onCartStatusChanged;

  const ProductCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.onCartStatusChanged,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isInCart = false;

  void _toggleCartStatus() {
    setState(() {
      _isInCart = !_isInCart;
    });
    widget.onCartStatusChanged(_isInCart);
  }

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
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF67BEEA),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 24,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    _isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                    size: 24,
                    color: _isInCart ? Colors.blue : null,
                  ),
                  onPressed: _toggleCartStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}