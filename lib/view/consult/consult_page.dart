// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/core/colors.dart';

class ConsultView extends StatefulWidget {
  const ConsultView({super.key});

  @override
  State<ConsultView> createState() => _ConsultViewState();
}

class _ConsultViewState extends State<ConsultView> {
  String choosenPlace = "TEXT";
  String selectedDisability = "Deaf";
  String selectedSurgery = "Heart";
  final List<String> disabilities = ["Decapitated", "Paralyzed", "Deaf"];
  final List<String> surgeries = ["Cranial", "Heart", "Arm"];
  final TextEditingController patientNotesController = TextEditingController();

  String getAppointmentsQuery = r'''
    query GetAppointments {
      consultant_appointments {
        id
        type
        surgery_history
        payment_state
        patient_notes
        medical_condition
        doctor_id
        created_at
      }
    }
  ''';

  void fetchAppointments(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(
      QueryOptions(document: gql(getAppointmentsQuery)),
    );

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print(result.data);
      // Or use setState to store and display appointments
      setState(() {
        // _result = result.data.toString();
      });
    }
  }

  final String addAppointmentMutation = r'''
    mutation AddAppointment(
      $type: appointment_type!
      $description: String!
      $surgery_history: String!
      $payment_state: enum_generic_state_enum!
      $patient_notes: String!
      $medical_condition: String!
      $doctor_id: uuid!
      $user_id: uuid!
      $scheduled_at: timestamptz!
    ) {
      insert_consultant_appointments(objects: {
        type: $type
        description: $description
        surgery_history: $surgery_history
        payment_state: $payment_state
        patient_notes: $patient_notes
        medical_condition: $medical_condition
        doctor_id: $doctor_id
        user_id: $user_id
        scheduled_at: $scheduled_at
      }) {
        returning {
          id
        }
      }
    }
  ''';

  void saveAppointment(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.mutate(MutationOptions(
      document: gql(addAppointmentMutation),
      variables: {
        'type': choosenPlace,
        'description': 'Texting Descriptions...',
        'payment_state': "UnPaid",
        'medical_condition': selectedDisability,
        'surgery_history': selectedSurgery,
        'patient_notes': patientNotesController.text.trim(),
        'doctor_id': 'f3c9eb8a-33f2-4cd9-9cc2-897ab024d326',
        'user_id': 'f3c9eb8a-33f2-4cd9-9cc2-897ab024d326',
        'scheduled_at': DateTime.now().toIso8601String(),
      },
    ));

    if (result.hasException) {
      print('Error: ${result.exception.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment')),
      );
    } else {
      print(
          'Success! Appointment saved with ID: ${result.data!['insert_consultant_appointments']['id']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ቀጠሮ ይያዙ',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  keyboardType: TextInputType.text,
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
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        backgroundColor: choosenPlace == "CALL"
                            ? Color(0xFF3389E7)
                            : Colors.white, // Use your primary blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          choosenPlace = "CALL";
                        });
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: choosenPlace == "CALL"
                            ? Colors.white
                            : Colors.transparent,
                        size: 20,
                      ),
                      label: Text(
                        'ጥሪ',
                        style: TextStyle(
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: 16,
                          color: choosenPlace == "CALL"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        backgroundColor: choosenPlace == "TEXT"
                            ? Color(0xFF3389E7)
                            : Colors.white, // Use your primary blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          choosenPlace = "TEXT";
                        });
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: choosenPlace == "TEXT"
                            ? Colors.white
                            : Colors.transparent,
                        size: 20,
                      ),
                      label: Text(
                        'በቻት',
                        style: TextStyle(
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: 16,
                          color: choosenPlace == "TEXT"
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
                  controller: patientNotesController,
                  keyboardType: TextInputType.text,
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
            onPressed: () {
              saveAppointment(context);
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
