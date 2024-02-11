import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String senderID;
  final String content;
  final String type;
  final Timestamp timestamp;
  final List attachements;
  bool seen = false;
  Timestamp? seenTimestamp;
  List<String>? reactions = [];
  List<String>? edits = [];
  bool edited = false;
  bool nsfw = false;

  ChatMessage({
    required this.senderID,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.seen,
    required this.attachements,
    this.edited = false,
    this.nsfw = false,
    this.edits,
    this.reactions,
    this.seenTimestamp,
  });
}

Future<void> sendMessage(String senderID, String recieverID, String content,
    String type, Timestamp timestamp, List attachements) async {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // TODO: Make an nsfw checker for images (and extend it to text msg too?)

  // UPDATE THE SENDER
  // msg list
  await db
      .collection("messages")
      .doc(senderID)
      .collection(recieverID)
      .doc("${timestamp.millisecondsSinceEpoch}")
      .set({
    "sender": senderID,
    "content": content,
    "type": type,
    "timestamp": timestamp,
    "seen": false,
    "seenTimestamp": null,
    "attachements": attachements,
    "nsfw": false,
    "edited": false,
    "edits": [],
    "reactions": [],
  });
  // status
  FirebaseFirestore.instance
      .collection('last_chats')
      .doc(senderID)
      .collection("chats")
      .doc(recieverID)
      .set({
    'status': '',
  });
  // last chats
  await FirebaseFirestore.instance
      .collection("last_chats")
      .doc(senderID)
      .collection("chats")
      .doc(recieverID)
      .set({
    "content": content,
    "timestamp": Timestamp.now(),
    "type": "outgoing",
    "uid": recieverID,
    "contentType": type,
    "status": "online",
  });

  // UPDATE THE RECEIVER
  // msg list
  await db
      .collection("messages")
      .doc(recieverID)
      .collection(senderID)
      .doc("${timestamp.millisecondsSinceEpoch}")
      .set({
    "sender": senderID,
    "content": content,
    "type": type,
    "timestamp": timestamp,
    "seen": false,
    "seenTimestamp": null,
    "attachements": attachements,
    "nsfw": false,
    "edited": false,
    "edits": [],
    "reactions": [],
  });
  // status
  FirebaseFirestore.instance
      .collection('last_chats')
      .doc(recieverID)
      .collection("chats")
      .doc(senderID)
      .set({
    'status': '',
  });
  // last chats
  await FirebaseFirestore.instance
      .collection("last_chats")
      .doc(recieverID)
      .collection("chats")
      .doc(senderID)
      .set({
    "content": content,
    "timestamp": Timestamp.now(),
    "type": "incoming",
    "uid": senderID,
    "contentType": type,
    "status": "online",
  });
}

Future<ChatMessage?> retreiveLastMessage(
    String senderID, String receiverID) async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final snapshot = await db
      .collection("messages")
      .doc(senderID)
      .collection(receiverID)
      .orderBy("timestamp", descending: true)
      .limit(1)
      .get();
  if (snapshot.docs.isEmpty) {
    return null;
  }
  final latestDocument = snapshot.docs.first;
  final latestData = latestDocument.data();

  return ChatMessage(
    senderID: latestData["sender"],
    content: latestData["content"],
    type: latestData["type"] ?? "text",
    timestamp: latestData["timestamp"],
    seen: latestData["seen"] ?? false,
    attachements: latestData["attachements"] ?? [],
    seenTimestamp: latestData["seenTimestamp"],
    edited: latestData["edited"] ?? false,
    edits: latestData["edits"] ?? [],
    nsfw: latestData["nsfw"] ?? false,
    reactions: latestData["reactions"] ?? [],
  );
}

Stream retreiveMessages(String senderID, String receiverID) {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  return db
      .collection("messages")
      .doc(senderID)
      .collection(receiverID)
      .orderBy("timestamp", descending: false)
      .snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> retreiveMessagesFromUser(
    String senderID) {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  return db
      .collection('last_chats')
      .doc(senderID)
      .collection("chats")
      .snapshots();
}

List<ChatMessage>? mapMessageStream(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  final messages = snapshot.data!.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      senderID: data["sender"],
      content: data["content"],
      type: data["type"] ?? "text",
      timestamp: data["timestamp"],
      seen: data["seen"] ?? false,
      attachements: data["attachements"] ?? [],
      seenTimestamp: data["seenTimestamp"],
      edited: data["edited"] ?? false,
      edits: data["edits"] ?? [],
      nsfw: data["nsfw"] ?? false,
      reactions: data["reactions"] ?? [],
    );
  }).toList();

  return messages;
}
