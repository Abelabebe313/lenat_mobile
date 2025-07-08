import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class EachSubscription extends StatefulWidget {
  const EachSubscription({
    super.key,
    required this.id,
    required this.price,
    required this.duration,
    required this.recommended,
    required this.isSelected,
  });

  final String id;
  final String price;
  final String duration;
  final bool recommended;
  final bool isSelected;

  @override
  State<EachSubscription> createState() => _EachSubscriptionState();
}

class _EachSubscriptionState extends State<EachSubscription> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: widget.isSelected ? Primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      )
                    : Container(
                        width: 24.0,
                      ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${widget.duration} ወር",
                          style: TextStyle(
                            color:
                                widget.isSelected ? Colors.white : Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        widget.recommended
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Text(
                                  "ተመረጠ",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Text(
                      "• Lorem Ipsum dolor sit amet",
                      style: TextStyle(
                        color: widget.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "• Lorem Ipsum dolor sit amet",
                      style: TextStyle(
                        color: widget.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "• Lorem Ipsum dolor sit amet",
                      style: TextStyle(
                        color: widget.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.price,
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    "Birr",
                    style: TextStyle(
                      color: widget.isSelected ? Colors.white : Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
