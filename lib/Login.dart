import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Register.dart';
import 'package:test_firebase/firebase.dart/Auth.dart';
import 'package:test_firebase/navigation.dart';
import 'package:test_firebase/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
    @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 100,),
          Container(
            height: 150, child: Center(child: Image.asset("assets/Logo.jpeg"))),
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller:_emailController,
              decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
            
              )
              ),
            ),
          ),

            SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              )
              ),
            ),
          ),
         SizedBox(height: 25,),
          ElevatedButton(onPressed:_signIn, child: Text("Login")),

        TextButton(onPressed:() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
            }, child: Text("vous n'avez pas une compte  ,  Register"))



        ],
      ),
      

    );

    
  }
    void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Vérifier si tous les champs sont remplis
    if (email.isEmpty || password.isEmpty) {
      showToast(message: "Veuillez remplir tous les champs.");
      return;
    }

    // Vérifier si l'email est valide
    if (!isValidEmail(email)) {
      showToast(message: "Veuillez saisir une adresse e-mail valide.");
      return;
    }

    // Appeler la méthode signInWithEmailAndPassword
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      // Créez ou mettez à jour le document utilisateur dans Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'lastSignInTime': user.metadata.lastSignInTime,
      }, SetOptions(merge: true));

      showToast(message: "Utilisateur connecté avec succès");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigation()),
        (route) => false,
      );
    } else {
      showToast(
          message:
              "Une erreur s'est produite lors de la connexion de l'utilisateur.");
    }
  }

  bool isValidEmail(String email) {
    // Utiliser une expression régulière pour valider l'adresse e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}