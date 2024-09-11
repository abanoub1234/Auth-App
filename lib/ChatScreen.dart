import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? currentUser;

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('messages').add({
            'sender': user.email,
            'text': _controller.text,
            'timestamp': FieldValue.serverTimestamp(),
          });
          _controller.clear();
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs.reversed;
                  List<Widget> messageWidgets = messages.map((msg) {
                    final messageText = msg['text'];
                    final messageSender = msg['sender'];
                    return ListTile(
                      title: Text('$messageSender: $messageText'),
                    );
                  }).toList();

                  return ListView(
                    reverse: true,
                    children: messageWidgets,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Text',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
