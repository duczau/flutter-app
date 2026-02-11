import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/chat_app/widget/message_bubble.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instanceFor(app: Firebase.app('first_app'));

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instanceFor(
          app: Firebase.app('first_app'),
          databaseId: 'dzau',
        ).collection('chat').orderBy('createdAt', descending: true).snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No messages');
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ct, index) {
              bool hasImage =
                  snapshot.data!.docs[index].data()['userPhotoUrl'] != null &&
                  snapshot.data!.docs[index].data()['userPhotoUrl'].isNotEmpty;
              print(snapshot.data!.docs[index].data()['userPhotoUrl']);

              final chatMessage = snapshot.data!.docs[index].data();
              final nextChatMessage = index + 1 < snapshot.data!.docs.length ? snapshot.data!.docs[index + 1].data() : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId = nextChatMessage?['userId'];
              final nextUserIdSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIdSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: currentMessageUserId == _firebase.currentUser?.uid,
                );
              }

              return ListTile(
                title: Text(snapshot.data!.docs[index].data()['text']),
                // style: ListTileStyle.list,
                isThreeLine: true,
                subtitle: Text(snapshot.data!.docs[index].data()['userId']),
                leading: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: hasImage
                      ? SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.network(
                            snapshot.data!.docs[index].data()['userPhotoUrl'],
                            errorBuilder: (context, error, stackTrace) {
                              print(error);
                              return const Icon(Icons.error);
                            },
                          ),
                        )
                      : Icon(Icons.person),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
