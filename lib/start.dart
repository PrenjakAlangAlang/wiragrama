import 'package:flutter/material.dart';
import 'package:wiragrama/LoginRegistrasi/registrasi.dart';
import 'package:wiragrama/authpage.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Set a background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const SizedBox(height: 30),
              Image.asset(
                'images/wiragrama.png', // Ensure this path is correct
                height: 150,
              ),
              const SizedBox(height: 0),

              // Main Text
              const Text(
                'Welcome to wiragrama',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),

              // Sub Text
              const Text(
                'Simple access anytime and anywhere',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 250),

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Authpage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get started',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),

              const SizedBox(height: 5),

              // Login Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account yet?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Registrasi()));
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color:
                            Colors.white, // You can change the color if needed
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
