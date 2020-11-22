import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String username;

  ChatDetailScreen(this.imageUrl, this.username);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Chat with ${widget.username}",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: GestureDetector(
          child: Center(
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 5.0,
                  width: 5.0,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
