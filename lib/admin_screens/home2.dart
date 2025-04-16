import 'package:flutter/material.dart';
import 'package:test_firebase/users_screens/cart.dart';
import 'package:test_firebase/users_screens/details.dart';
import 'package:test_firebase/users_screens/model_books.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final List<Book> books = [
    Book(
      title: "Clean Code",
      author: "Robert C. Martin",
      image: "https://covers.openlibrary.org/b/id/9643436-L.jpg",
      price: 59.99,
    ),
    Book(
      title: "The Pragmatic Programmer",
      author: "Andrew Hunt",
      image: "https://covers.openlibrary.org/b/id/10420465-L.jpg",
      price: 54.99,
    ),
    Book(
      title: "Flutter for Beginners",
      author: "Alessandro Biessek",
      image: "https://covers.openlibrary.org/b/id/10523389-L.jpg",
      price: 49.99,
    ),
    Book(
      title: "You Don't Know JS",
      author: "Kyle Simpson",
      image: "https://covers.openlibrary.org/b/id/8155431-L.jpg",
      price: 39.99,
    ),
    Book(
      title: "Design Patterns",
      author: "Erich Gamma",
      image: "https://covers.openlibrary.org/b/id/9251980-L.jpg",
      price: 69.99,
    ),
    Book(
      title: "Cracking the Coding Interview",
      author: "Gayle Laakmann McDowell",
      image: "https://covers.openlibrary.org/b/id/10909258-L.jpg",
      price: 64.99,
    ),
    Book(
      title: "Introduction to Algorithms",
      author: "Thomas H. Cormen",
      image: "https://covers.openlibrary.org/b/id/11153250-L.jpg",
      price: 79.99,
    ),
    Book(
      title: "Deep Learning",
      author: "Ian Goodfellow",
      image: "https://covers.openlibrary.org/b/id/9273033-L.jpg",
      price: 74.99,
    ),
    Book(
      title: "Python Crash Course",
      author: "Eric Matthes",
      image: "https://covers.openlibrary.org/b/id/8369251-L.jpg",
      price: 44.99,
    ),
    Book(
      title: "The Clean Coder",
      author: "Robert C. Martin",
      image: "https://covers.openlibrary.org/b/id/8104721-L.jpg",
      price: 52.99,
    ),
  ];

  final List<Book> cart = [];

  void goToDetails(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsPage(book: book, cart: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("📘 Livres recommandés"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.image,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                book.title,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                book.author,
                style: const TextStyle(color: Colors.blueGrey),
              ),
              onTap: () => goToDetails(book),
              trailing: ElevatedButton(
                onPressed: () => goToDetails(book),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Détails",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );  
  }
}
