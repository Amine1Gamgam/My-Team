import 'package:flutter/material.dart';
import 'package:test_firebase/users_screens/cart.dart';
import 'package:test_firebase/users_screens/model_books.dart';

class DetailsPage extends StatefulWidget {
  final Book book;
  final List<Book> cart;

  const DetailsPage({
    super.key,
    required this.book,
    required this.cart,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _quantity = 0;
  double _total = 0.0;

  void _addToCart() {
    setState(() {
      widget.cart.add(widget.book);
      _quantity++;
      _total += widget.book.price;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.book.title} ajouté au panier")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_quantity > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cart: widget.cart),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.book.image,
                width: 200,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.book.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Par ${widget.book.author}",
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Text(
              "Prix : ${widget.book.price.toStringAsFixed(2)} TND",
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            const Text(
              "Description:\n\n"
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text(
                "Ajouter au panier",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (_quantity > 0)
              Text(
                "$_quantity article(s) | Total : ${_total.toStringAsFixed(2)} TND",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
          ],
        ),
      ),
    );
  }
}
