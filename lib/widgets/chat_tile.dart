import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({
    super.key,
    required this.username,
    required this.message,
    required this.timestamp,
    this.image,
  });

  final String? image;
  final String username;
  final String message;
  final String timestamp;

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    var usn = widget.username;
    var pfp = widget.image ??
        "https://firebasestorage.googleapis.com/v0/b/sx-talktime.appspot.com/o/pfps%2Fdefault.jpg?alt=media&token=6c7c2968-e4f6-4f65-9927-e41f39067a96";
    var msg = widget.message;
    var ts = widget.timestamp;
    return ListTile(
      shape: ShapeBorder.lerp(null, null, 0),
      tileColor: const Color(0xff353535),
      leading: ClipOval(
        child: Image(
          image: NetworkImage(pfp),
        ),
      ),
      title: Text(
        usn,
        style: const TextStyle(color: Color(0xffcdcdcd)),
      ),
      subtitle:
         Text(msg, style: const TextStyle(color: Colors.grey)),
      trailing: Text(ts, style: const TextStyle(color: Colors.grey)),
    );
  }
}
