import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/chat_app/widget/user_image_picker.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  Uint8List? _selectedImage;
  bool _isLogin = true;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // run onPressed method

      if (_isLogin) {
        // login
        if (_email != null && _password != null) {
          try {
            final userCredential = await _firebase
                .signInWithEmailAndPassword(
                  email: _email!,
                  password: _password!,
                )
                .then((e) {
                  print(e.credential);
                });
          } on FirebaseException catch (e) {
            // TODO
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message ?? 'Login error'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        }
      } else {
        // signup
        try {
          // final userCredential = await _firebase.createUserWithEmailAndPassword(
          //   email: _email!,
          //   password: _password!,
          // ).onError((e, s) {
          //   print(e);
          //   print(s);

          // });
          // print(userCredential);
          if (_selectedImage != null) {
            final storageRef = await FirebaseStorage.instance
                .ref()
                .child("place_images")
                .child('${_email}_${DateTime.now().toIso8601String()}.png');
            storageRef.putData(
              _selectedImage!,
              SettableMetadata(contentType: 'image/png'),
            );

            final imageUrl = await storageRef.getDownloadURL();
          }

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup Success user:$_email'),
              duration: const Duration(seconds: 1),
            ),
          );
        } on Exception catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup error: $e'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    }
  }

  void _onAddImage(Uint8List path) {
    _selectedImage = path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: 200,
                child: Image.asset('assets/chat/chat.png'),
              ),
              Card(
                color: Colors.white,
                margin: EdgeInsets.all(50),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          if (!_isLogin)
                            UserImagePicker(onAddImage: _onAddImage),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            autofocus: true,
                            style: TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            style: TextStyle(color: Colors.black),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onSaved: (value) => _password = value,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _handleLogin,
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an account'
                                  : 'I already have an account',
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
