class Book {
  String id; // Ajout de l'ID du livre
  String title;
  String author;
  String image;
  double price;

  Book({
    this.id = '', // Default to empty string if not set
    required this.title,
    required this.author,
    required this.image,
    required this.price,
  });
}
