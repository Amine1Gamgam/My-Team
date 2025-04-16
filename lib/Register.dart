import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Login.dart';
import 'package:test_firebase/firebase.dart/Auth.dart';
import 'package:test_firebase/users_screens/navigation.dart';
import 'package:test_firebase/widgets/toast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fond clair en blueGrey
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // Espacement autour du contenu
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              height: 150,
              child: Center(child: Image.asset('assets/image.png')),
            ),
            const SizedBox(height: 40),
            _buildTextField(usernameController, "Username", Icons.person),
            const SizedBox(height: 20),
            _buildTextField(emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildTextField(passwordController, "Password", Icons.lock, obscureText: true),
            const SizedBox(height: 30),
            _buildButton("Register", _signUp),
            const SizedBox(height: 20),
            _buildTextButton("Vous avez un compte ? Connectez-vous", () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            }),
          ],
        ),
      ),
    );
  }

  // Fonction pour simplifier la création des champs de texte
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey), // Changement de couleur en blueGrey
          prefixIcon: Icon(icon, color: Colors.blueGrey), // Changement de couleur en blueGrey
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blueGrey, width: 2), // Changement de couleur en blueGrey
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 2), // Changement de couleur en blueGrey
          ),
        ),
      ),
    );
  }

  // Fonction pour simplifier la création du bouton
  Widget _buildButton(String label, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                  ),
                ),
      child: Text(label, style: TextStyle(color: Colors.white)), // Texte blanc pour contraster
    );
  }

  // Fonction pour créer un TextButton personnalisé
  Widget _buildTextButton(String label, Function onPressed) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        label,
        style: TextStyle(color: Colors.blueGrey, fontSize: 16), // Changement de couleur en blueGrey
      ),
    );
  }

  // Fonction de gestion de l'inscription
  void _signUp() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
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
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

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
}
