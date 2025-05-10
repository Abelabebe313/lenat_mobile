import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class ConsultView extends StatefulWidget {
  const ConsultView({super.key});

  @override
  State<ConsultView> createState() => _ConsultViewState();
}

class _ConsultViewState extends State<ConsultView> {
  String choosenPlace = "በቻት";
  String selectedDisability = "Deaf";
  String selectedSurgery = "Heart";
  final List<String> disabilities = ["Dicapitated", "Paralized", "Deaf"];
  final List<String> surgeries = ["Cranial", "Heart", "Arm"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ቀጠሮ ይያዙ',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          const SizedBox(height: 10.0),
          // Name
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "ስም",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: TextFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "ስም",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                      fontFamily: 'NotoSansEthiopic',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Disability
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "የጤና እክል አለቦት?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: TextFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: TextFieldColor,
                          value: selectedDisability,
                          isExpanded: true,
                          style: TextStyle(
                            fontFamily: 'NotoSansEthiopic',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: disabilities.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDisability = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Surgeries
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "ያደረጉት ቀዶ ህክምና?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: TextFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: TextFieldColor,
                          value: selectedSurgery,
                          isExpanded: true,
                          style: TextStyle(
                            fontFamily: 'NotoSansEthiopic',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: surgeries.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSurgery = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Place
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "የቦታ ዓይነት",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
              Row(
                children: [
                  // Outlined button (Cancel Time)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: choosenPlace == "ኦንላይን ጥሪ"
                            ? Color(0xFF3389E7)
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          choosenPlace = "ኦንላይን ጥሪ";
                        });
                      },
                      child: Text(
                        'ኦንላይን ጥሪ',
                        style: TextStyle(
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Filled button (Continue)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        backgroundColor: choosenPlace == "በቻት"
                            ? Color(0xFF3389E7)
                            : Colors.white, // Use your primary blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          choosenPlace = "በቻት";
                        });
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: choosenPlace == "በቻት"
                            ? Colors.white
                            : Colors.transparent,
                        size: 20,
                      ),
                      label: Text(
                        'በቻት',
                        style: TextStyle(
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: 16,
                          color: choosenPlace == "በቻት"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Price
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "ለኮንሰልቴሽን የሚከፍሉት ክፍያ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 24.0),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.blue[50],
                ),
                onPressed: () {
                  // Handle cancel action
                },
                child: Text(
                  '300 Br',
                  style: TextStyle(
                    fontFamily: 'NotoSansEthiopic',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Message
          Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "መልእክት",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: TextFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "መልእክት",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.5),
                      fontFamily: 'NotoSansEthiopic',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),

          // Submit Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 12,
              ),
            ),
            child: Text(
              "ቀጠሮ ይያዙ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
