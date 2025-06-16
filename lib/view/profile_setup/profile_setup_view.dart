import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:lenat_mobile/view/profile_setup/profile_setup_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  String pregnancy = "yes";
  bool isChecked = false;
  String selectedRelationShip = "Father";
  String selectedValue = "1ኛ ሳምንት";
  final TextEditingController fullNameController = TextEditingController();

  final List<String> relationShipOptions = [
    "Father",
    "Grandparent",
    "Guardian",
    "Mother",
    "Other",
  ];

  // Date selector lists
  final List<String> days =
      List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> years = List.generate(
      50, (index) => (DateTime.now().year - 50 + index).toString());

  late String selectedDay;
  late String selectedMonth;
  late String selectedYear;

  @override
  void initState() {
    super.initState();
    selectedDay = days[0];
    selectedMonth = months[0];
    selectedYear = years[0];
  }

  final List<String> options = [
    "1ኛ ወር",
    "2ኛ ወር",
    "3ኛ ወር",
    "4ኛ ወር",
    "5ኛ ወር",
    "6ኛ ወር",
    "7ኛ ወር",
    "8ኛ ወር",
    "9ኛ ወር"
  ];

  @override
  Widget build(BuildContext context) {
    final profileSetUpViewModel = Provider.of<ProfileSetupViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              profileViewModel.isAmharic ? "ወደ ኋላ ይመለሱ" : "go back",
              style: TextStyle(
                fontFamily: 'NotoSansEthiopic',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                profileViewModel.isAmharic ? "መጨረሻ መገለጫ ይሙሉ" : "Profile Setup",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profileViewModel.isAmharic
                    ? "እባኮትን ይሙሉ የሚለው የእንቅስቃሴ ጽሁፍ ነው። ይህ የእንቅስቃሴ ጽሁፍ እንደ ምሳሌ ይሆናል።"
                    : "Please fill in the following details to create your profile. This will be used as an example for the profile.",
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
                    profileViewModel.isAmharic ? "ሙሉ ስም" : "Full Name",
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
                      controller: fullNameController,
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
                  if (profileSetUpViewModel.selectedIndex != "male") ...[
                    Text(
                      profileViewModel.isAmharic
                          ? "እርጉዝ ኖት?"
                          : "Are you pregnant?",
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
                        profileViewModel.isAmharic
                            ? "የእርግዝና ወር"
                            : "Month of Pregnancy",
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
                  ],
                  const SizedBox(height: 20),
                  Text(
                    profileViewModel.isAmharic
                        ? "የእርሶ ድርሻ"
                        : "Who are you signing up as?",
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
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: TextFieldColor,
                        value: selectedRelationShip,
                        isExpanded: true,
                        style: TextStyle(
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: relationShipOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRelationShip = newValue!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // age field
                  Text(
                    profileViewModel.isAmharic ? "የልደት ቀን" : "Date of Birth",
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
                      // Day Selector
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
                              value: selectedDay,
                              isExpanded: true,
                              style: TextStyle(
                                fontFamily: 'NotoSansEthiopic',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: days.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDay = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Month Selector
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
                              value: selectedMonth,
                              isExpanded: true,
                              style: TextStyle(
                                fontFamily: 'NotoSansEthiopic',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMonth = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Year Selector
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
                              value: selectedYear,
                              isExpanded: true,
                              style: TextStyle(
                                fontFamily: 'NotoSansEthiopic',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: years.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedYear = newValue!;
                                });
                              },
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
                onPressed: profileSetUpViewModel.isLoading
                    ? null
                    : () async {
                        try {
                          // Format date of birth
                          final dateOfBirth =
                              "$selectedYear-$selectedMonth-$selectedDay";

                          // Get pregnancy period if applicable
                          int? pregnancyPeriod;
                          if (profileSetUpViewModel.selectedIndex != "male" &&
                              pregnancy == "yes") {
                            pregnancyPeriod =
                                int.parse(selectedValue.split("ኛ")[0].trim());
                          }

                          await profileSetUpViewModel.updateProfile(
                            fullName: fullNameController.text,
                            dateOfBirth: dateOfBirth,
                            relationship: selectedRelationShip,
                            pregnancyPeriod: pregnancyPeriod,
                          );

                          if (context.mounted) {
                            Navigator.pushNamed(context, "/main");
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Failed to update profile: $e")),
                            );
                          }
                        }
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
                child: profileSetUpViewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
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
