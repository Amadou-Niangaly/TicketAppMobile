import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key, required String name, required String avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jhon Abraham',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Active now',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.phone, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.videocam, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.black),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: const [
                MessageBubble(
                  message: "Hello! Nazrul How are you?",
                  time: "09:25 AM",
                  isMe: false,
                ),
                MessageBubble(
                  message: "You did your job well!",
                  time: "09:25 AM",
                  isMe: true,
                ),
                MessageBubble(
                  message: "Have a great working week!!",
                  time: "09:25 AM",
                  isMe: false,
                ),
                MessageBubble(
                  message: "Hope you like it",
                  time: "09:25 AM",
                  isMe: false,
                ),
                VoiceMessageBubble(
                  time: "09:25 AM",
                  isMe: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.black),
                const SizedBox(width: 16),
                const Icon(Icons.camera_alt, color: Colors.black),
                const SizedBox(width: 16),
                const Icon(Icons.photo, color: Colors.black),
                const SizedBox(width: 16),
                const Icon(Icons.mic, color: Colors.black),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Write your message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.send, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoiceMessageBubble extends StatelessWidget {
  final String time;
  final bool isMe;

  const VoiceMessageBubble({
    super.key,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white24,
                ),
                const SizedBox(width: 8),
                Text(
                  "00:16",
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
