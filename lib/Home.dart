import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _commentController = TextEditingController();
  List<String> _comments = []; // Liste pour stocker les commentaires

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maldives'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image qui occupe 50% de l'écran
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image1.jpg'), // Remplace par le chemin de ton image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Description sous l'image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Les Maldives, un paradis tropical avec des plages de sable fin et des eaux cristallines. "
                "Venez découvrir un lieu unique de détente et de luxe.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),

            // Afficher les commentaires en temps réel sous la description
            Column(
              children: _comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(comment, style: TextStyle(fontSize: 14)),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // 5 icônes jaunes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 30,
                );
              }),
            ),
            SizedBox(height: 20),

            // Champ de texte pour ajouter un commentaire
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Ajouter un commentaire',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Bouton pour ajouter un commentaire
            ElevatedButton(
              onPressed: _addComment,
              child: const Text('Ajouter Commentaire'),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour ajouter un commentaire dans la liste
  void _addComment() {
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      return; // Ne rien faire si le champ est vide
    }

    setState(() {
      _comments.add(commentText); // Ajouter le commentaire à la liste
    });

    _commentController.clear(); // Effacer le champ après ajout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Commentaire ajouté avec succès")),
    );
  }
}
