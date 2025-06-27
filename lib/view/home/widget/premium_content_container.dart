import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lenat_mobile/view/blog/blog.dart';
import 'package:lenat_mobile/view/premium/premium_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumContentContainer extends StatefulWidget {
  const PremiumContentContainer({
    super.key,
    required this.image,
    required this.title,
    required this.content,
  });

  final String image;
  final String title;
  final String content;

  @override
  State<PremiumContentContainer> createState() =>
      _PremiumContentContainerState();
}

class _PremiumContentContainerState extends State<PremiumContentContainer> {
  bool isPaid = false;
  void checkIfPaid() async {
    final prefs = await SharedPreferences.getInstance();
    isPaid = await prefs.getBool('isPaid') ?? false;
    setState(() {});
  }

  void lockAgain() async {
    print("here3eeeeeeeeee");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPaid', false);
    isPaid = await prefs.getBool('isPaid') ?? false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfPaid();
  }

  @override
  Widget build(BuildContext context) {
    checkIfPaid();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isPaid
                ? Blog(
                    image: widget.image,
                    title: widget.title,
                    content: widget.content,
                  )
                : PremiumView(),
          ),
        );
      },
      child: Container(
        width: 240.0,
        height: 240.0,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.cover,
                width: 240.0,
                height: 240.0,
                errorWidget: (context, state, idk) => Image.asset(
                  "assets/images/image.png",
                  fit: BoxFit.cover,
                  width: 240.0,
                  height: 240.0,
                ),
              ),
            ),
            isPaid
                ? Container()
                : Align(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 240.0,
                // height: 250.0,
                padding: EdgeInsets.symmetric(
                  vertical: 3.0,
                  horizontal: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(115),
                  border: Border.all(color: Colors.transparent),
                  // borderRadius: BorderRadius.circular(20.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    lockAgain();
                  },
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
