import 'package:flutter/material.dart';
import 'package:lenat_mobile/view/blog/blog.dart';
import 'package:lenat_mobile/view/premium/premium_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumContentContainer extends StatefulWidget {
  const PremiumContentContainer({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

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
                    body: "",
                    image: widget.image,
                    title: widget.title,
                  )
                : PremiumView(),
          ),
        );
      },
      child: Container(
        width: 240.0,
        height: 240.0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
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
                  color: Colors.black.withAlpha(50),
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
