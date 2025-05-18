import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  String pregnancy = "yes";
  bool isChecked = false;
  String selectedValue = "1ኛ ሳምንት";
  final List<String> options = [
    "1ኛ ሳምንት",
    "2ኛ ሳምንት",
    "3ኛ ሳምንት",
    "4ኛ ሳምንት",
    "5ኛ ሳምንት",
    "6ኛ ሳምንት",
    "7ኛ ሳምንት",
    "8ኛ ሳምንት",
    "9ኛ ሳምንት",
    "10ኛ ሳምንት",
    "11ኛ ሳምንት",
    "12ኛ ሳምንት",
    "13ኛ ሳምንት",
    "14ኛ ሳምንት",
    "15ኛ ሳምንት",
    "16ኛ ሳምንት",
    "17ኛ ሳምንት",
    "18ኛ ሳምንት",
    "19ኛ ሳምንት",
    "20ኛ ሳምንት",
    "21ኛ ሳምንት",
    "22ኛ ሳምንት",
    "23ኛ ሳምንት",
    "24ኛ ሳምንት",
    "25ኛ ሳምንት",
    "26ኛ ሳምንት",
    "27ኛ ሳምንት",
    "28ኛ ሳምንት",
    "29ኛ ሳምንት",
    "30ኛ ሳምንት"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "ወደ ኋላ ይመለሱ",
          style: TextStyle(
            fontFamily: 'NotoSansEthiopic',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              const Text(
                "መጨረሻ መገለጫ ይሙሉ",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "እባኮትን ይሙሉ የሚለው የእንቅስቃሴ ጽሁፍ ነው። ይህ የእንቅስቃሴ ጽሁፍ እንደ ምሳሌ ይሆናል።",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ሙሉ ስም",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: TextFieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "lenat user",
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
                  // pregnancy question
                  const SizedBox(height: 20),
                  Text(
                    "እርጉዝ ኖት?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pregnancyCard(
                        label: "አዎን",
                        value: "yes",
                      ),
                      pregnancyCard(
                        label: "አይደለሁም",
                        value: "no",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "የእርግዝና ሳምንት",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowMoveDownRight,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                              value: selectedValue,
                              isExpanded: true,
                              style: TextStyle(
                                fontFamily: 'NotoSansEthiopic',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: options.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar04,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // age field
                  Text(
                    "ዕድሜ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Min Age
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: TextFieldColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "ከ",
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
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        " - ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      // Max Age
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: TextFieldColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "እስከ",
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
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // acceopt terms and conditions
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Colors.blue,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "የውል እና ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextSpan(
                          text: "የአስተዳደር ደረሰኝ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Primary,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextSpan(
                          text: "ይህ ነው። የግል የውል ይህ ነው።\n",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextSpan(
                          text: "እባኮትን ይሙሉ የሚለው የእንቅስቃሴ ጽሁፍ ነው። \n ይህ ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextSpan(
                          text: "የእንቅስቃሴ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Primary,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextSpan(
                          text: "ጽሁፍ እንደ ምሳሌ ይሆናል።",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              /// Continue button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/main");
                },
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
                  "ጉዞዎን ይጀምሩ",
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
        ),
      ),
    );
  }

  Widget pregnancyCard({
    required String label,
    required String value,
  }) {
    final bool isSelected = pregnancy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          pregnancy = value;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'NotoSansEthiopic',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
