import 'package:flutter/material.dart';

class Book {
  final String title;
  final String author;
  final String imageUrl;
  final double rating;

  Book({required this.title, required this.author, required this.imageUrl, required this.rating});
}

class RecommendedPage extends StatelessWidget {
  final List<Book> recommendedBooks = [
    Book(
      title: "Flutter for Beginners",
      author: "John Smith",
      imageUrl: "https://covers.openlibrary.org/b/id/10523389-L.jpg",
      rating: 4.8,
    ),
    Book(
      title: "Clean Code",
      author: "Robert C. Martin",
      imageUrl: "https://covers.openlibrary.org/b/id/8231856-L.jpg",
      rating: 4.9,
    ),
    Book(
      title: "The Pragmatic Programmer",
      author: "Andrew Hunt",
      imageUrl: "https://covers.openlibrary.org/b/id/5546156-L.jpg",
      rating: 4.7,
    ),
    // Ajoute plus de livres ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("📚 Recommandés"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: recommendedBooks.length,
        itemBuilder: (context, index) {
          final book = recommendedBooks[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  book.imageUrl,
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${book.author}\n⭐ ${book.rating}"),
              isThreeLine: true,
              trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueGrey),
              onTap: () {
                // Tu peux ajouter l'action ici pour aller vers les détails ou panier
              },
            ),
          );
        },
      ),
    );
  }
}
