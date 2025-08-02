import 'package:chatty/cubits/home_cubit/home_cubit.dart';
import 'package:chatty/helper/colors.dart';
import 'package:chatty/models/user_model.dart';
import 'package:chatty/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class CustomContainerHomeChat extends StatelessWidget {
  final UserModel user;
  const CustomContainerHomeChat({super.key, required this.user});

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return DateFormat('hh:mm a').format(dateTime);
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'Yesterday';
    } else if (dateTime.year == now.year) {
      return DateFormat('MMM d').format(dateTime);
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user.uid != null) {
          BlocProvider.of<HomeCubit>(context).clearUnreadCounter(user.uid!);
        }

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
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 14, top: 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: greyColor, width: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundImage:
                    user.imageUrl != null && user.imageUrl!.isNotEmpty
                        ? NetworkImage(user.imageUrl!)
                        : null,

                backgroundColor:
                    user.imageUrl == null || user.imageUrl!.isEmpty
                        ? greyColor
                        : null,
                child:
                    user.imageUrl == null || user.imageUrl!.isEmpty
                        ? const Icon(Icons.person, color: whiteColor, size: 28)
                        : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.lastMessage?['content'] ?? 'No messages yet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTimestamp(user.lastMessage?['timestamp']),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF686A8A),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (user.unreadCounter != null && user.unreadCounter! > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        user.unreadCounter.toString(),
                        style: const TextStyle(
                          color: whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
