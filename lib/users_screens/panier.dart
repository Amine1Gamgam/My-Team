import 'package:flutter/material.dart';
import 'package:test_firebase/users_screens/model_books.dart';


class CartPage extends StatelessWidget {
  final List<Book> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Mon Panier"),
        backgroundColor: Colors.blueGrey,
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Votre panier est vide", style: TextStyle(color: Colors.blueGrey, fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final book = cart[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  child: ListTile(
                    leading: Image.asset(book.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(book.title, style: const TextStyle(color: Colors.blueGrey)),
                    subtitle: Text(book.author, style: const TextStyle(color: Colors.blueGrey)),
                  ),
                );
              },
            ),
    );
  }
}
