import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();
  String? editingBookId;

  void clearFields() {
    _titleController.clear();
    _authorController.clear();
    _imageController.clear();
    _priceController.clear();
    editingBookId = null;
  }

  void addOrUpdateBook() async {
    final book = {
      "title": _titleController.text,
      "author": _authorController.text,
      "image": _imageController.text,
      "price": double.tryParse(_priceController.text) ?? 0.0,
    };

    if (editingBookId == null) {
      // Ajouter
      await FirebaseFirestore.instance.collection("Books").add(book);
    } else {
      // Modifier
      await FirebaseFirestore.instance
          .collection("Books")
          .doc(editingBookId)
          .update(book);
    }

    clearFields();
    setState(() {}); // Refresh UI
  }

  void deleteBook(String id) async {
    await FirebaseFirestore.instance.collection("Books").doc(id).delete();
    if (editingBookId == id) clearFields();
    setState(() {});
  }

  void populateFields(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    _titleController.text = data['title'];
    _authorController.text = data['author'];
    _imageController.text = data['image'];
    _priceController.text = data['price'].toString();
    editingBookId = doc.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📚 Gérer les Livres")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champs du formulaire
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: "Auteur"),
            ),
            TextField(
              controller: _imageController,
              decoration:
                  const InputDecoration(labelText: "URL de l'image"),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Prix"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addOrUpdateBook,
              child: Text(editingBookId == null ? "Ajouter" : "Modifier"),
            ),
            const SizedBox(height: 10),
            const Divider(),

            // Liste des livres
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Books")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Aucun livre trouvé."));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: Image.network(
                          data["image"],
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.book),
                        ),
                        title: Text(data["title"]),
                        subtitle: Text(
                            "Auteur: ${data["author"]} - Prix: ${data["price"]} DT"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => populateFields(doc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteBook(doc.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
