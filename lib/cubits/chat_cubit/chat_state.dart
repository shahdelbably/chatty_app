part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageModel> messages;

  ChatSuccess({required this.messages});
}

class ChatFailure extends ChatState {
  final String error;

  ChatFailure({required this.error});
}

class MessageSentSuccess extends ChatState {}

class MessageSentFailure extends ChatState {
  final String error;
  MessageSentFailure({required this.error});
}
