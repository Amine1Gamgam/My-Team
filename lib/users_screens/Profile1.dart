import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Login.dart'; // Import de la page Login
import 'package:test_firebase/widgets/toast.dart';
import 'package:test_firebase/firebase.dart/Auth.dart';
import 'package:test_firebase/users_screens/navigation.dart'; // Import de la page Navigation

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController username1 = TextEditingController();
  final TextEditingController emailControllerReg = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      var userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['username'] ?? '';
          _emailController.text = _user!.email ?? '';
        });
      }
    }
  }

  Future<void> _reAuthenticateUser(String currentPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: currentPassword,
      );
      await _user!.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception("Échec de la réauthentification : $e");
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (_user == null) return;

      String newName = _nameController.text.trim();
      String newEmail = _emailController.text.trim();
      String currentPassword = _currentPasswordController.text.trim();

      if (newEmail != _user!.email) {
        if (currentPassword.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Veuillez entrer votre mot de passe actuel pour modifier l'email")),
          );
          return;
        }
        await _reAuthenticateUser(currentPassword);
      }

      await _firestore.collection('users').doc(_user!.uid).update({
        'username': newName,
        'email': newEmail,
      });

      await _user!.updateEmail(newEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mise à jour réussie')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  void _signUp() async {
    String username = username1.text.trim();
    String email = emailControllerReg.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showToast(message: "Veuillez remplir tous les champs.");
      return;
    }

    if (!isValidEmail(email)) {
      showToast(message: "Veuillez saisir une adresse e-mail valide.");
      return;
    }

    if (password.length < 6) {
      showToast(message: "Le mot de passe doit contenir au moins 6 caractères.");
      return;
    }

    try {
      User? user = await _authService.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        showToast(message: "Utilisateur créé avec succès");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Navigation()),
          (route) => false,
        );
      } else {
        showToast(message: "Erreur lors de la création de l'utilisateur.");
      }
    } catch (e) {
      showToast(message: "Erreur : ${e.toString()}");
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_user != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/ena.jpg"),
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomTextField(controller: _nameController, hintText: "Nom d'utilisateur"),
                      SizedBox(height: 10),
                      CustomTextField(controller: _emailController, hintText: "Email"),
                      SizedBox(height: 10),
                      CustomTextField(controller: _currentPasswordController, hintText: "Mot de passe actuel", isPassword: true),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text("Mettre à jour"),
                      ),
                      ElevatedButton(
                        onPressed: _signOut,
                        child: Text("Déconnexion"),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              CustomTextField(controller: username1, hintText: "Nom d'utilisateur"),
              SizedBox(height: 10),
              CustomTextField(controller: emailControllerReg, hintText: "Email"),
              SizedBox(height: 10),
              CustomTextField(controller: passwordController, hintText: "Mot de passe", isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text("S'inscrire"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await _auth.signOut();
      showToast(message: "Déconnexion réussie.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      showToast(message: "Erreur lors de la déconnexion.");
    }
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  CustomTextField({required this.controller, required this.hintText, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(Icons.person), // Ajoutez une icône si nécessaire
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0), // Couleur du bord quand actif
        ),
      ),
    );
  }
}
//flutter build apk --release
//admin@gmail.com
//test@gmail.com