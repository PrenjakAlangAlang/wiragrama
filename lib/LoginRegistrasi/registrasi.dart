import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:wiragrama/LoginRegistrasi/login.dart';

class Registrasi extends StatefulWidget {
  const Registrasi({super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  File? _image;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF121212),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/wiragrama.png', height: 200),
            const Text("Please register",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Text("Fill in your email and password correctly!",
                style: TextStyle(fontSize: 15, color: Colors.white)),
            const SizedBox(height: 20),
            _profileImageField(),
            const SizedBox(height: 20),
            _usernameField(),
            const SizedBox(height: 20),
            _emailField(),
            const SizedBox(height: 14),
            _passwordField(),
            const SizedBox(height: 14),
            const Text('Or', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 14),
            _googleButton(),
            const SizedBox(height: 14),
            _registrasiButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[300],
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? const Icon(Icons.camera_alt, color: Colors.white, size: 40)
            : null,
      ),
    );
  }

  Widget _usernameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _registrasiButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () async {
          try {
            UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
              'username': usernameController.text,
              'email': emailController.text,
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          } catch (e) {
            print('Error: $e'); // Debugging
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Registrasi gagal: ${e.toString()}'),
            ));
          }
        },
        child: const Text(
          'Register',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DB954),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _registerWithGoogle,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF494A5F),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: const Size.fromHeight(50),
          ),
          child: Row(
            children: [
              Image.asset('images/google.png', width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Continue with Google',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': usernameController.text,
          'email': userCredential.user!.email,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      print('Error: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Google registration failed. Please try again.'),
      ));
    }
  }
}
