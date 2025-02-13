import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Login.dart';
import 'package:test_firebase/firebase.dart/Auth.dart';
import 'package:test_firebase/navigation.dart';
import 'package:test_firebase/toast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController username1 = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              height: 150,
              child: Center(child: Image.asset("assets/Logo.jpeg")),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: username1,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _signUp, // Correction ici
              child: const Text("Register"),
            ),

            TextButton(onPressed:() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            }, child: Text("vous avez une compte  ,  Login")),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    String username = username1.text.trim();
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
