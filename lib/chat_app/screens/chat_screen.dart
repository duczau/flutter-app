import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/chat_app/widget/chat_message.dart';
import 'package:first_app/chat_app/widget/new_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _firebase = FirebaseAuth.instanceFor(app: Firebase.app('first_app'));

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _costController = TextEditingController();
  int _count = 0;
  int? _streamSum;

  void _titleInputHandler(String value) async {
    final zz = await FirebaseAuth.instanceFor(app: Firebase.app('first_app')).currentUser?.getIdToken(true);
    print(zz);
    _count = int.tryParse(value) ?? 0;
  }

  late final StreamController<List<int>> stream;

  @override
  void initState() {
    super.initState();
    stream = StreamController.broadcast();
  }

  /**
   *  (1) countStream sẽ return một Steam<Int> bằng việc sử dụng async*.
      (2) Để emit value cho một stream, ta dùng keyword yield.
      (3) Dùng await for để wait value sẽ emit về từ chuỗi stream.
      (4) await for phải nằm trong async function.
   */
  Future<int> sumStream(Stream<List<int>> stream) async {
    // (4)
    var sum = 0;
    await for (var value in stream) {
      // (3)
      print(value);
      await Future.delayed(const Duration(milliseconds: 10));

      sum = value.reduce((a, b) => a + b);
    }
    return sum;
  }

  Stream<List<int>> countStreamAsList(int to) async* {
    final list = <int>[];
    // (1)
    for (int i = 1; i <= to; i++) {
      list.add(i);
      yield List.from(list); // (2)
    }
  }

  @override
  void dispose() {
    stream.close();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Screen')),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatMessage(),
          NewMessage(),
          SizedBox(height: 30),
          Text("------------------------"),
          ElevatedButton(
            onPressed: () async {
              await _firebase.signOut();
            },
            child: Text("Logout"),
          ),
          SizedBox(height: 10),
          TextField(
            style: TextStyle(color: Colors.black),
            controller: _costController,
            onChanged: _titleInputHandler,
            decoration: InputDecoration(labelText: 'Count', prefixText: '\$'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () async {
              // try {
              //   print(Firebase.apps.map((a) => a.name).toList());
              //   print(Firebase.app('first_app'));

              //   final docs =
              //       await FirebaseFirestore.instanceFor(
              //         databaseId: 'tesst',
              //         // app: FirebaseFirestore.instance.app, // same as default app
              //         // app: Firebase.app(),
              //         app: Firebase.app('first_app'),
              //       ).collection('userz').doc('zzzzs').set({
              //         'pong': FieldValue.serverTimestamp(),
              //       });
              // } catch (e, st) {
              //   print('❌ Firestore init test failed: $e');
              //   print(st);
              // }
              setState(() {
                _streamSum = null;
              });
              final countStream = countStreamAsList(_count);

              // this block code has consumed countStream ->
              await for (var list in countStream) {
                await Future.delayed(const Duration(milliseconds: 300));
                stream.add(list);
              }

              // => this block code has no longer countStream to consume => create new stream countStream2
              final countStream2 = countStreamAsList(_count);
              final sum = await sumStream(countStream2);
              print(sum);
              setState(() {
                _streamSum = sum;
              });
            },
            child: Text("Count"),
          ),
          Flexible(
            child: StreamBuilder<List<int>>(
              stream: stream.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.done) {
                  final values = snapshot.data ?? [];
                  if (!context.mounted) {
                    return const Text('Waiting...');
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(), // ✅ Disable scroll
                          physics: const BouncingScrollPhysics(),
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Index $index: ${values[index]}'),
                            );
                          },
                        ),
                        if (_streamSum != null ||
                            snapshot.connectionState == ConnectionState.done)
                          Text('Sum: $_streamSum'),
                        SizedBox(height: 40),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: Text('Enter count and click button'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
