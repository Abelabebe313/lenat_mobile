import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Blog extends StatefulWidget {
  const Blog({
    super.key,
    required this.image,
    required this.title,
    required this.content,
  });

  final String image;
  final String title;
  final String content;

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        children: [
          // Text(
          //   widget.title,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          CachedNetworkImage(
            imageUrl: widget.image,
            fit: BoxFit.cover,
            errorWidget: (context, state, idk) => Image.asset(
              "assets/images/image.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.0),

          // Text(widget.content),

          Html(
            data: widget.content,
            // style: {
            //   "body": Style(fontSize: FontSize(100.0), color: Colors.amber),
            // },
          ),
        ],
      ),
    );
  }
}
