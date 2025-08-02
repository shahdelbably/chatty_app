import 'package:chatty/helper/colors.dart';
import 'package:chatty/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key, required this.chattingWithUser});

  final UserModel chattingWithUser;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: whiteColor), // لون الأيقونة
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                chattingWithUser.imageUrl != null &&
                        chattingWithUser.imageUrl!.isNotEmpty
                    ? NetworkImage(chattingWithUser.imageUrl!)
                    : null,

            backgroundColor:
                chattingWithUser.imageUrl == null ||
                        chattingWithUser.imageUrl!.isEmpty
                    ? greyColor
                    : null,
            child:
                chattingWithUser.imageUrl == null ||
                        chattingWithUser.imageUrl!.isEmpty
                    ? const Icon(Icons.person, color: whiteColor, size: 22)
                    : null,
          ),
          const SizedBox(width: 10),
          Text(
            chattingWithUser.name ?? 'Chat',
            style: const TextStyle(color: whiteColor, fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
