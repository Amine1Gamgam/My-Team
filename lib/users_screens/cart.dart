import 'package:flutter/material.dart';
import 'model_books.dart';

class CartPage extends StatelessWidget {
  final List<Book> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double totalPrice = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Panier"),
        backgroundColor: Colors.blueGrey,
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Votre panier est vide."))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final book = cart[index];
                return ListTile(
                  leading: Image.network(book.image, width: 50, fit: BoxFit.cover),
                  title: Text(book.title),
                  subtitle: Text("Prix : ${book.price.toStringAsFixed(2)} TND"),
                );
              },
            ),
      bottomNavigationBar: cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("${totalPrice.toStringAsFixed(2)} TND", style: const TextStyle(fontSize: 18)),
                ],
              ),
            )
          : null,
    );
  }
}
