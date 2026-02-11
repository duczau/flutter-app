import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instanceFor(app: Firebase.app('first_app'));
class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  void _submitMessage() async {
    final enteredText = _messageController.text;
    if (enteredText.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // remove focus and hide keyboard

    final _fbStore = FirebaseFirestore.instanceFor(
      app: Firebase.app('first_app'),
      databaseId: 'dzau',
    );

    final _userInfo = await _fbStore.collection('users').doc(_firebase.currentUser?.uid).get();

    await _fbStore.collection('chat').add({
      'text': enteredText,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': _firebase.currentUser?.uid,
      'email': _userInfo.data()?['email'],
      'userPhotoUrl': _userInfo.data()?['avatarUrl'],
    });
    print('✅ Message sent');
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type message',
                  ),
                  // onChanged: (value) {
                  //   _messageController.text = value;
                  // },
                ),
              ),
              IconButton(
                onPressed: _submitMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
