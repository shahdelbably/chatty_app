import 'package:chatty/helper/colors.dart';
import 'package:chatty/models/user_model.dart';
import 'package:chatty/views/chat_view.dart';
import 'package:flutter/material.dart';

class SearchResultUserTile extends StatelessWidget {
  final UserModel user;

  const SearchResultUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatView(chattingWithUser: user);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage:
                  user.imageUrl != null && user.imageUrl!.isNotEmpty
                      ? NetworkImage(user.imageUrl!)
                      : null,

              backgroundColor:
                  user.imageUrl == null || user.imageUrl!.isEmpty
                      ? Colors.blueGrey
                      : null,
              child:
                  user.imageUrl == null || user.imageUrl!.isEmpty
                      ? const Icon(Icons.person, color: whiteColor, size: 28)
                      : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.name ?? 'Unknown User',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
