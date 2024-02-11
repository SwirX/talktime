import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String displayName;
  final String profilePictureURL;
  final String email;
  final String bio;
  int followers = 0;
  int following = 0;
  final List<DocumentReference> followersList;
  final List<DocumentReference> followingList;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profilePictureURL,
    required this.email,
    required this.bio,
    required this.followersList,
    required this.followingList,
  });

}
  Stream userSearch(String query) {
    final db = FirebaseFirestore.instance;
    return db
        .collection("users")
        .where("username", isLessThanOrEqualTo: query)
        .snapshots();
  }

  Future<User?> getUserByID(String id) async {
    final db = FirebaseFirestore.instance;
    var snapshot =
        await db.collection("users").where("id", isEqualTo: id).get();
    if (snapshot.docs.isEmpty) {
      return null;
    }

    final data = snapshot.docs.first.data();

    return User(
      id: data["id"],
      username: data["username"],
      displayName: data["displayName"],
      profilePictureURL: data["profilePictureURL"],
      email: data["email"],
      bio: data["bio"],
      followersList: data["followersList"],
      followingList: data["followingList"],
    );
  }

  List<User>? mapFromSnapshot(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    final users = snapshot.data!.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return User(
        id: data["id"],
        username: data["username"],
        displayName: data["displayName"],
        profilePictureURL: data["profileURL"],
        email: data["email"],
        bio: data["bio"],
        followersList: data["followersList"],
        followingList: data["followingList"],
      );
    }).toList();

    return users;
  }
