import 'package:flutter/material.dart';
import 'package:ticket_app/page/home/message.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     'Chat',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          ChatItem(
            name: "Alex Linderson",
            message: "How are you today?",
            time: "2 min ago",
            avatarUrl: "https://example.com/avatar1.jpg",
            unreadCount: 3,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagePage(
                    name: "Alex Linderson",
                    avatarUrl: "https://example.com/avatar1.jpg",
                  ),
                ),
              );
            },
          ),
          ChatItem(
            name: "Team Align",
            message: "Don't miss to attend the meeting.",
            time: "2 min ago",
            avatarUrl: "https://example.com/avatar2.jpg",
            unreadCount: 4,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagePage(
                    name: "Team Align",
                    avatarUrl: "https://example.com/avatar2.jpg",
                  ),
                ),
              );
            },
          ),
          ChatItem(
            name: "John Ahraham",
            message: "Hey! Can you join the meeting?",
            time: "2 min ago",
            avatarUrl: "https://example.com/avatar3.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagePage(
                    name: "John Ahraham",
                    avatarUrl: "https://example.com/avatar3.jpg",
                  ),
                ),
              );
            },
          ),
          ChatItem(
            name: "Sabila Sayma",
            message: "How are you today?",
            time: "2 min ago",
            avatarUrl: "https://example.com/avatar4.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessagePage(
                    name: "Sabila Sayma",
                    avatarUrl: "https://example.com/avatar4.jpg",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final int? unreadCount;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.unreadCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                if (unreadCount != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4.0),
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}