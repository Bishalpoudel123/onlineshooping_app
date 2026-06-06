import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_screen.dart';
import 'widgets/custom_text_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ================= SIGNUP FUNCTION =================

  Future<void> signupHandle() async {

    if (_formKey.currentState!.validate()) {

      setState(() {
        isLoading = true;
      });

      try {

        // Create User in Firebase Authentication

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Save Extra User Data in Firestore

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'createdAt': DateTime.now(),
        });

        // Success Message

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup Successful'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to Main Screen

     if(mounted){
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
     }

      } on FirebaseAuthException catch (e) {

        String message = 'Signup Failed';

        if (e.code == 'email-already-in-use') {
          message = 'Email already exists';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email address';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );

      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );

      } finally {

        setState(() {
          isLoading = false;
        });

      }
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              const SizedBox(height: 20),

              const Icon(
                Icons.shopping_bag,
                size: 80,
                color: Colors.red,
              ),

              const SizedBox(height: 10),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Username

              CustomTextField(
                hintText: 'Username',
                icon: Icons.person,
                controller: nameController,
                validator: (value) {

                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }

                  if (value.trim().length < 3) {
                    return 'Username must be at least 3 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Email

              CustomTextField(
                hintText: 'Email',
                icon: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {

                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }

                  final emailRegex =
                      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Phone

              CustomTextField(
                hintText: 'Phone Number',
                icon: Icons.phone,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {

                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number required';
                  }

                  final phoneRegex =
                      RegExp(r'^\+?[0-9]{7,15}$');

                  if (!phoneRegex.hasMatch(value.trim())) {
                    return 'Enter valid phone number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Password

              CustomTextField(
                hintText: 'Password',
                icon: Icons.lock,
                controller: passwordController,
                obscureText: true,
                validator: (value) {

                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }

                  if (value.length < 6) {
                    return 'Minimum 6 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  onPressed: isLoading ? null : signupHandle,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}