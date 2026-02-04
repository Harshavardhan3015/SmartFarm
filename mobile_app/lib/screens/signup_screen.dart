import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.person_add,
                size: 80,
                color: Colors.green,
              ),

              const SizedBox(height: 20),

              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              _inputField('Username'),
              const SizedBox(height: 15),
              _inputField('Email'),
              const SizedBox(height: 15),
              _inputField('Password', obscure: true),
              const SizedBox(height: 15),
              _inputField('Confirm Password', obscure: true),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  // Django signup API later
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
