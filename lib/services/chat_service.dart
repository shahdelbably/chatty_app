import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatty/models/message_model.dart';
import 'dart:developer';

class ChatService {
  final _fire = FirebaseFirestore.instance;

  static String getChatRoomId(String user1Uid, String user2Uid) {
    List<String> uids = [user1Uid, user2Uid];
    uids.sort();
    return uids.join('_');
  }

  Future<String> createOrGetChatRoom({
    required String user1Uid,
    required String user2Uid,
  }) async {
    final String chatRoomId = ChatService.getChatRoomId(user1Uid, user2Uid);
    final chatRoomRef = _fire.collection("chatRooms").doc(chatRoomId);

    final chatRoomDoc = await chatRoomRef.get();

    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        "participants": [user1Uid, user2Uid],
        "lastMessage": null,
        "lastMessageTimestamp": null,
        "createdAt": FieldValue.serverTimestamp(),
        "unreadCounts": {user1Uid: 0, user2Uid: 0},
      });
      log("New chat room created: $chatRoomId");
    } else {
      if (!chatRoomDoc.data()!.containsKey('unreadCounts')) {
        await chatRoomRef.update({
          "unreadCounts": {user1Uid: 0, user2Uid: 0},
        });
      }
      log("Chat room already exists: $chatRoomId");
    }
    return chatRoomId;
  }

  saveMessage(Map<String, dynamic> message, String chatRoomId) async {
    try {
      await _fire
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(message);
      log("Message saved successfully to $chatRoomId");
    } catch (e) {
      log("Error saving message: $e");
      rethrow;
    }
  }

  Future<void> updateChatRoomLastMessage({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    try {
      await _fire.collection("chatRooms").doc(chatRoomId).update({
        "lastMessage": message.toMap(),
        "lastMessageTimestamp":
            message.timestamp != null
                ? Timestamp.fromDate(message.timestamp!)
                : null,
      });
      log("Chat room $chatRoomId last message updated.");
    } catch (e) {
      log("Error updating chat room last message: $e");
      rethrow;
    }
  }

  Future<void> updateUnreadCounterForReceiver({
    required String chatRoomId,
    required String receiverUid,
  }) async {
    try {
      await _fire.collection("chatRooms").doc(chatRoomId).update({
        "unreadCounts.$receiverUid": FieldValue.increment(1),
      });
      log(
        "Unread counter incremented for $receiverUid in chat room $chatRoomId",
      );
    } catch (e) {
      log("Error updating unread counter: $e");
      rethrow;
    }
  }

  Future<void> clearUnreadCounter({
    required String chatRoomId,
    required String userUid,
  }) async {
    try {
      await _fire.collection("chatRooms").doc(chatRoomId).update({
        "unreadCounts.$userUid": 0,
      });
      log("Unread counter cleared for $userUid in chat room $chatRoomId");
    } catch (e) {
      log("Error clearing unread counter: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return _fire
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatRooms(
    String currentUid,
  ) {
    return _fire
        .collection("chatRooms")
        .where("participants", arrayContains: currentUid)
        .orderBy("lastMessageTimestamp", descending: true)
        .snapshots();
  }
}
