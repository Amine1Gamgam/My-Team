import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Gestion extends StatefulWidget {
  const Gestion({super.key});

  @override
  State<Gestion> createState() => _GestionState();
}

class _GestionState extends State<Gestion> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  void _showUserDialog({DocumentSnapshot? userDoc}) {
    bool isEditing = userDoc != null;

    if (isEditing) {
      _emailController.text = userDoc['email'];
      _usernameController.text = userDoc['username'];
    } else {
      _emailController.clear();
      _usernameController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Modifier utilisateur' : 'Ajouter utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final username = _usernameController.text.trim();
              final email = _emailController.text.trim();

              if (username.isEmpty || email.isEmpty) return;

              if (isEditing) {
                userDoc!.reference.update({
                  'username': username,
                  'email': email,
                });
              } else {
                usersCollection.add({
                  'username': username,
                  'email': email,
                  'createdAt': Timestamp.now(),
                });
              }

              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Modifier' : 'Ajouter'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(DocumentSnapshot userDoc) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              userDoc.reference.delete();
              Navigator.pop(context);
            },
            child: const Text('Supprimer'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des utilisateurs"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showUserDialog(),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des données'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text('Aucun utilisateur trouvé.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var email = user['email'];
              var username = user['username'];
              var createdAt = user['createdAt'];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(username),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: $email"),
                      Text("Créé le: ${createdAt.toDate()}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showUserDialog(userDoc: user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(user),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
