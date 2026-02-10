import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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
            final userCredential = await _firebase.signInWithEmailAndPassword(
              email: _email!,
              password: _password!,
            );

            print('✅ Signed in: ${userCredential.user?.uid}');
            print('💾 Saving user to Firestore...');
            print('📍 Email: $_email');

            // try {
            //   await FirebaseFirestore.instance
            //       .collection('_test')
            //       .doc('ping')
            //       .set({'ping': FieldValue.serverTimestamp()})
            //       .timeout(
            //         const Duration(seconds: 5),
            //         onTimeout: () =>
            //             throw TimeoutException('Firestore timeout'),
            //       );
            //   print('✅ Firestore ready');
            // } catch (e, st) {
            //   print('❌ Firestore init test failed: $e');
            //   print(st);
            // }
            // await FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(userCredential.user!.uid)
            //     .set({
            //       'email': _email,
            //       'createdAt': FieldValue.serverTimestamp(),
            //     });

            // print('✅ User saved to Firestore');
          } on FirebaseAuthException catch (e) {
            print('❌ Auth error: ${e.code} - ${e.message}');
          } on FirebaseException catch (e) {
            print('❌ Firebase error: ${e.code} - ${e.message}');
          } catch (e) {
            print('❌ Error: $e');
            print('❌ Error type: ${e.runtimeType}');
          }
        }
      } else {
        // signup
        try {
          final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _email!,
            password: _password!,
          );
          if (userCredential.user != null) {
            String? imageUrl;
            if (_selectedImage != null) {
              final storageRef = FirebaseStorage.instance
                  .ref()
                  .child("place_images")
                  .child('${_email}_${DateTime.now().toIso8601String()}.png');
              await storageRef.putData(
                _selectedImage!,
                SettableMetadata(contentType: 'image/png'),
              );

              imageUrl = await storageRef.getDownloadURL();
              print('✅ Avatar uploaded: $imageUrl');
            }

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({'email': _email, 'avatarUrl': imageUrl ?? ''});
            print('✅ User saved to Firestore');
          }

          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Signup Success'),
                  content: Text('user:$_email'),
                );
              },
            );
          }
        } on Exception catch (e) {
          print(e);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup error: $e'),
              duration: const Duration(seconds: 3),
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
