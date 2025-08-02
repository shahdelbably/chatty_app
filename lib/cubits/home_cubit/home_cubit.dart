import 'dart:async';
import 'dart:developer';

import 'package:chatty/models/user_model.dart';
import 'package:chatty/services/chat_service.dart';
import 'package:chatty/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ChatService _chatService;
  final FirestoreService _firestoreService;
  StreamSubscription? _chatRoomsSubscription;
  HomeCubit(this._firestoreService, this._chatService) : super(HomeInitial());
  Future<void> fetchUserChats() async {
    emit(HomeLoading());
    try {
      final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) {
        emit(HomeFailure(error: "User not logged in."));
        return;
      }

      _chatRoomsSubscription = _chatService
          .getUserChatRooms(currentUid)
          .listen(
            (snapshot) async {
              List<UserModel> chatUsers = [];
              for (var doc in snapshot.docs) {
                final List<String> participants = List<String>.from(
                  doc.data()['participants'],
                );
                final String otherUid = participants.firstWhere(
                  (uid) => uid != currentUid,
                );
                final Map<String, dynamic>? otherUserData =
                    await _firestoreService.loadUser(otherUid);
                if (otherUserData != null) {
                  final Map<String, dynamic> lastMessageData =
                      doc.data()['lastMessage'] ?? {};
                  final Map<String, dynamic> unreadCounts =
                      doc.data()['unreadCounts'] ?? {};
                  final int currentUsersUnreadCount =
                      unreadCounts[currentUid] ?? 0;

                  UserModel chatUser = UserModel(
                    uid: otherUserData['uid'],
                    name: otherUserData['name'],
                    email: otherUserData['email'],
                    imageUrl: otherUserData['imageUrl'],
                    lastMessage: lastMessageData,
                    unreadCounter: currentUsersUnreadCount,
                  );
                  chatUsers.add(chatUser);
                }
              }
              chatUsers.sort((a, b) {
                final int? timestampA = a.lastMessage?['timestamp'];
                final int? timestampB = b.lastMessage?['timestamp'];
                if (timestampA == null && timestampB == null) return 0;
                if (timestampA == null) {
                  return 0;
                }
                if (timestampB == null) return -1;
                return timestampB.compareTo(timestampA);
              });

              emit(HomeSuccess(users: chatUsers));
            },
            onError: (error) {
              emit(HomeFailure(error: error.toString()));
              log(error.toString());
            },
          );
    } catch (e) {
      emit(HomeFailure(error: e.toString()));
    }
  }

  Future<void> clearUnreadCounter(String otherUserUid) async {
    final String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUid == null) return;
    final String chatRoomId = ChatService.getChatRoomId(
      currentUid,
      otherUserUid,
    );
    await _chatService.clearUnreadCounter(
      chatRoomId: chatRoomId,
      userUid: currentUid,
    );
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    return super.close();
  }
}
