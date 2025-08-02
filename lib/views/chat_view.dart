import 'package:chatty/cubits/chat_cubit/chat_cubit.dart';
import 'package:chatty/models/user_model.dart';
import 'package:chatty/services/chat_service.dart';
import 'package:chatty/widgets/chat_app_bar.dart';
import 'package:chatty/widgets/chat_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  final UserModel chattingWithUser;

  const ChatView({super.key, required this.chattingWithUser});

  @override
  Widget build(BuildContext context) {
    final ChatService chatService = ChatService();

    return Scaffold(
      appBar: ChatAppBar(chattingWithUser: chattingWithUser),
      body: BlocProvider(
        create: (context) => ChatCubit(chatService),
        child: ChatViewBody(chattingWithUser: chattingWithUser),
      ),
    );
  }
}
