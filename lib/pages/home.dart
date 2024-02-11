import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:talktime/classes/message.dart';
import 'package:talktime/classes/user.dart' as tt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? initTimer;
  tt.User? currentUser;

  @override
  void initState() {
    super.initState();
    initTimer = Timer(Duration.zero, () async {
      final tmpUserValue =
          await tt.getUserByID(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        currentUser = tmpUserValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343434),
      // appBar: AppBar(),
      body: GestureDetector(
          onTap: () {
            Navigator.popAndPushNamed(context, "/login");
          },
          child: StreamBuilder(
            stream: retreiveMessagesFromUser(
                FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Align(
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ); // Show a loading indicator while fetching data.
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'It\'s lonely here!😶‍🌫️',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final chats = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final lastMessage = chat['content'];
                    final lastMessageTime = chat['timestamp'];
                    final Duration timepassed = DateTime.now().difference(
                      DateTime.fromMillisecondsSinceEpoch(
                        lastMessageTime.millisecondsSinceEpoch,
                      ),
                    );

                    final String timepassedStr = formatDuration(timepassed);
                    final DateTime dateTime =
                        DateTime.fromMillisecondsSinceEpoch(
                      lastMessageTime.millisecondsSinceEpoch,
                    );
                    final String time =
                        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

                    final String otherUid = chat["uid"];
                    final String chatType = chat["type"];
                    final String contenType = chat["contentType"];

                    // TODO: Replace the folowing widget by the chat_tile widget

                    return FutureBuilder(
                      future: tt.getUserByID(otherUid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircleAvatar(
                            radius: 25,
                            child: ClipOval(
                              child: Icon(Icons.error),
                            ),
                          );
                        } else {
                          tt.User otherUser = snapshot.data!;
                          return ListTile(
                            leading: ImageFade(
                              image: NetworkImage(otherUser.profilePictureURL),
                              width: 30,
                              height: 30,
                              duration: const Duration(milliseconds: 100),
                              placeholder: Container(
                                color: const Color(0xFFCFCDCA),
                                alignment: Alignment.center,
                                child: const Icon(Icons.photo,
                                    color: Colors.white30),
                              ),
                              loadingBuilder: (context, progress, chunkEvent) =>
                                  Center(
                                      child: CircularProgressIndicator(
                                          value: progress)),
                              errorBuilder: (context, error) => Container(
                                color: const Color(0xFF6F6D6A),
                                alignment: Alignment.center,
                                child: const Icon(Icons.warning,
                                    color: Colors.black26),
                              ),
                            ),
                            title: Text(otherUser.displayName),
                            subtitle: Container(
                              alignment: AlignmentDirectional.centerStart,
                              child: contenType == "text"
                                  ? Text(
                                      '$lastMessage',
                                      style: TextStyle(
                                        color: chatType == "incoming"
                                            ? Colors.grey
                                            : MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : const Color(0xff353540),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        const Icon(Icons.image),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Sent an image',
                                          style: TextStyle(
                                            color: chatType == "incoming"
                                                ? Colors.grey
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            trailing: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              child: timepassedStr.contains("days")
                                  ? Text(
                                      '$timepassedStr at $time',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  : Text(
                                      timepassedStr,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, "/chat",
                                  arguments: {'uid': otherUid});
                            },
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          )),
    );
  }
}

String formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    final days = duration.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  } else if (duration.inHours > 0) {
    final hours = duration.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
  } else if (duration.inMinutes > 0) {
    final minutes = duration.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
  } else {
    return 'Just now';
  }
}
