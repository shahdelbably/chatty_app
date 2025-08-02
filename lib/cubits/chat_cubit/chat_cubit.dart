import 'dart:async';
import 'dart:developer';
import 'package:chatty/models/message_model.dart';
import 'package:chatty/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._chatService) : super(ChatInitial());
  final ChatService _chatService;
  StreamSubscription? _messagesSubscription;
  String? _currentChatRoomId;
  Future<void> getMessages({required String receiverUid}) async {
    emit(ChatLoading());
    try {
      final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) {
        emit(ChatFailure(error: "User not logged in."));
        return;
      }

      _currentChatRoomId = await _chatService.createOrGetChatRoom(
        user1Uid: currentUid,
        user2Uid: receiverUid,
      );

      _messagesSubscription = _chatService
          .getMessages(_currentChatRoomId!)
          .listen(
            (snapshot) {
              final List<MessageModel> messages =
                  snapshot.docs
                      .map((doc) => MessageModel.fromMap(doc.data()))
                      .toList();
              emit(ChatSuccess(messages: messages));
            },
            onError: (error) {
              emit(ChatFailure(error: error.toString()));
              log(error.toString());
            },
          );
    } catch (e) {
      emit(ChatFailure(error: e.toString()));
      log(e.toString());
    }
  }

  Future<void> sendMessage({
    required String content,
    required String receiverUid,
  }) async {
    try {
      final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) {
        emit(ChatFailure(error: "User not logged in."));
        return;
      }

      _currentChatRoomId ??= await _chatService.createOrGetChatRoom(
        user1Uid: currentUid,
        user2Uid: receiverUid,
      );

      final MessageModel message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        senderId: currentUid,
        receiverId: receiverUid,
        timestamp: DateTime.now(),
      );

      await _chatService.saveMessage(message.toMap(), _currentChatRoomId!);

      await _chatService.updateChatRoomLastMessage(
        chatRoomId: _currentChatRoomId!,
        message: message,
      );
      await _chatService.updateUnreadCounterForReceiver(
        chatRoomId: _currentChatRoomId!,
        receiverUid: receiverUid,
      );
    } catch (e) {
      emit(MessageSentFailure(error: e.toString()));
      log(e.toString());
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
