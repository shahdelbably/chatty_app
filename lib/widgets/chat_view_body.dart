import 'dart:math';
import 'package:chatty/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as core;
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatty/cubits/chat_cubit/chat_cubit.dart';
import 'package:chatty/models/message_model.dart';
import 'package:chatty/models/user_model.dart';

class ChatViewBody extends StatefulWidget {
  final UserModel chattingWithUser;

  const ChatViewBody({super.key, required this.chattingWithUser});

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  late String _currentUserId;
  final _chatController = InMemoryChatController();

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;

    BlocProvider.of<ChatCubit>(
      context,
    ).getMessages(receiverUid: widget.chattingWithUser.uid!);
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatSuccess) {
          final convertedMessages =
              state.messages
                  .map((msg) => messageModelToCoreTextMessage(msg))
                  .toList();
          _chatController.setMessages(convertedMessages.toList());
        } else if (state is ChatFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
        }
      },
      child: Chat(
        theme: ChatTheme(
          colors: ChatColors(
            primary: primaryColor,
            onPrimary: whiteColor,
            surface: const Color(0xFFFBFBFB),
            onSurface: Colors.black,
            surfaceContainer: Colors.grey.shade300,
            surfaceContainerLow: whiteColor,
            surfaceContainerHigh: Colors.grey[100]!,
          ),
          typography: ChatTypography.standard(),
          shape: BorderRadius.circular(20),
        ),
        currentUserId: _currentUserId,
        chatController: _chatController,
        resolveUser: (UserID id) async {
          if (id == _currentUserId) {
            return core.User(id: id, name: 'You');
          } else {
            return core.User(id: id, name: widget.chattingWithUser.name);
          }
        },
        onMessageSend: (text) {
          BlocProvider.of<ChatCubit>(context).sendMessage(
            content: text,
            receiverUid: widget.chattingWithUser.uid!,
          );
        },
      ),
    );
  }
}

TextMessage messageModelToCoreTextMessage(MessageModel model) {
  return TextMessage(
    authorId: model.senderId ?? '',
    createdAt:
        model.timestamp?.millisecondsSinceEpoch != null
            ? DateTime.fromMillisecondsSinceEpoch(
              model.timestamp!.millisecondsSinceEpoch,
              isUtc: true,
            )
            : DateTime.now().toUtc(),
    id: model.id ?? Random().nextInt(10000).toString(),
    text: model.content ?? '',
  );
}
