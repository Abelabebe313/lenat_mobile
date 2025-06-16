import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  const Blog({
    super.key,
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String title;
  final String body;

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
          Image.asset(
            widget.image,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.0),
          Text(
            "Taking care of kids is a rewarding yet demanding responsibility that requires patience, attentiveness, and love. Providing a safe and nurturing environment is essential for their physical and emotional well-being. This includes ensuring they have nutritious meals, adequate sleep, and regular medical check-ups. Beyond meeting basic needs, engaging with children through play, conversation, and educational activities helps stimulate their development and builds a strong bond of trust and security. Consistency in routines and clear boundaries also contribute to a child's sense of stability and understanding of acceptable behavior.",
          ),
          SizedBox(height: 10.0),
          Text(
            "Emotional support is equally important in child care. Children need encouragement and positive reinforcement to build self-esteem and resilience. Listening to their thoughts and feelings without judgment fosters open communication and helps them navigate challenges. Additionally, role modeling respectful behavior and empathy teaches valuable social skills. Taking care of kids is not just about meeting their immediate needs but also about guiding them to become confident, compassionate, and well-rounded individuals. With dedication and love, caregivers can make a profound difference in a child’s life and future.",
          ),
        ],
      ),
    );
  }
}
