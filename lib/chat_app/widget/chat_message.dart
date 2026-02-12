import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/chat_app/widget/message_bubble.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instanceFor(app: Firebase.app('first_app'));

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool isSelectionMode = false;
  Set<String> selectedMessageIds = {};
  Map<String, String> mapAvatarByEmail = {};

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    print(await fcm.getToken(),); // you could send this token (via http or firestore sdk - in test preview) to a backend

    // Subscribe to topics - send notifications to all subscribed devices
    fcm.subscribeToTopic('chat');
  }

  void setAvatarMap() async {
    await FirebaseFirestore.instanceFor(
      app: Firebase.app('first_app'),
      databaseId: 'dzau',
    ).collection('chat').get().then((snapshot) {
      setState(() {
        for (var element in snapshot.docs) {
          mapAvatarByEmail[element.data()['email']] = element
              .data()['userPhotoUrl'];
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // setupPushNotification();
    setAvatarMap();
  }

  void _toggleSelection(String messageId, bool selected) {
    setState(() {
      if (selected) {
        selectedMessageIds.add(messageId);
        if (!isSelectionMode) {
          isSelectionMode = true;
        }
      } else {
        selectedMessageIds.remove(messageId);
        if (selectedMessageIds.isEmpty) {
          isSelectionMode = false;
        }
      }
    });
  }

  void _deleteSelectedMessages() async {
    // ✅ Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Messages'),
        content: Text(
          'Are you sure you want to delete ${selectedMessageIds.length} message(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final instance = FirebaseFirestore.instanceFor(
        databaseId: 'dzau', // db name
        app: Firebase.app('first_app'), // get default app
      );
      final batch = instance.batch();
      var collection = instance.collection('chat');
      try {
        for (String docId in selectedMessageIds) {
          // 3. Get the document reference and add the delete operation to the batch
          DocumentReference docRef = collection.doc(docId);
          batch.delete(docRef);
        }
        await batch.commit();
      } catch (e) {
        print('❌ Delete batch message failed: $e');
      }
      setState(() {
        // ✅ Delete messages
        // messages.removeWhere((msg) => selectedMessageIds.contains(msg.id));

        // Reset selection
        selectedMessageIds.clear();
        isSelectionMode = false;
      });

      // ✅ Show success message
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Messages deleted')));
      }
    }
  }

  void _cancelSelection(bool e) {
    setState(() {
      if (e == false) {
        selectedMessageIds.clear();
      }
      isSelectionMode = e;
    });
  }

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
            padding: EdgeInsets.all(10),
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ct, index) {
              final chatMessageId = snapshot.data!.docs[index].id;
              final chatMessage = snapshot.data!.docs[index].data();
              final nextChatMessage = index + 1 < snapshot.data!.docs.length
                  ? snapshot.data!.docs[index + 1].data()
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId = nextChatMessage?['userId'];
              final nextUserIdSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIdSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: currentMessageUserId == _firebase.currentUser?.uid,
                  messageId: chatMessageId,
                  isSelectionMode: isSelectionMode,
                  isSelected: selectedMessageIds.contains(chatMessageId),
                  onSelectionChanged: (selected) {
                    _toggleSelection(chatMessageId, selected);
                  },
                );
              } else {
                return Column(
                  children: [
                    Switch(
                      value: isSelectionMode,
                      onChanged: (e) {
                        _cancelSelection(e);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: selectedMessageIds.isEmpty
                          ? null
                          : _deleteSelectedMessages,
                      color: Colors.red,
                    ),
                    MessageBubble.first(
                      // userImage: chatMessage['userPhotoUrl'],
                      userImage:
                          mapAvatarByEmail.containsKey(chatMessage['email'])
                          ? mapAvatarByEmail[chatMessage['email']]
                          : null,
                      username: chatMessage['email'],
                      message: chatMessage['text'],
                      isMe: currentMessageUserId == _firebase.currentUser?.uid,
                      messageId: chatMessageId,
                      isSelectionMode: isSelectionMode,
                      isSelected: selectedMessageIds.contains(chatMessageId),
                      onSelectionChanged: (selected) {
                        _toggleSelection(chatMessageId, selected);
                      },
                    ),
                  ],
                );
              }

              // return ListTile(
              //   title: Text(snapshot.data!.docs[index].data()['text']),
              //   // style: ListTileStyle.list,
              //   isThreeLine: true,
              //   subtitle: Text(snapshot.data!.docs[index].data()['userId']),
              //   leading: ClipRRect(
              //     borderRadius: BorderRadiusGeometry.circular(20),
              //     child: hasImage
              //         ? SizedBox(
              //             width: 30,
              //             height: 30,
              //             child: Image.network(
              //               snapshot.data!.docs[index].data()['userPhotoUrl'],
              //               errorBuilder: (context, error, stackTrace) {
              //                 print(error);
              //                 return const Icon(Icons.error);
              //               },
              //             ),
              //           )
              //         : Icon(Icons.person),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
