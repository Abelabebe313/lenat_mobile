import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/auth_service.dart';

class ConsultPageViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final TextEditingController patientNotesController = TextEditingController();
  final TextEditingController patientDayController = TextEditingController();
  final TextEditingController patientTimeController = TextEditingController();
  String choosenPlace = "CALL";
  String selectedDisability = "ጉበት";
  String selectedSurgery = "ትርፍ አንጀት";
  final List<String> disabilities = [
    "ጉበት",
    "ስኳር",
    "ማይግሬን",
    "ኤችአይቪ/ ኤድስ",
    "ዲቪቲ ወይም የደም መርጋት",
  ];
  final List<String> surgeries = ["የጡት", "የልብ", "ትርፍ አንጀት", "የማህፀን ሲስት ማስወገድ"];

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
      notifyListeners();
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

  var isLoading = false;
  void saveAppointment(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final client = GraphQLProvider.of(context).value;

    var currentUser = await _authService.getCurrentUser();

    final result = await client.mutate(MutationOptions(
      document: gql(addAppointmentMutation),
      variables: {
        'type': choosenPlace,
        'description': 'Texting Descriptions...',
        'payment_state': "UnPaid",
        'medical_condition': selectedDisability,
        'surgery_history': selectedSurgery,
        'patient_notes': patientNotesController.text.trim() +
            patientDayController.text.trim() +
            " " +
            patientTimeController.text.trim(),
        'doctor_id': 'd44c1cb6-058e-4edf-b13f-659931801971',
        'user_id': currentUser!.id,
        'scheduled_at': DateTime.now().toIso8601String(),
      },
    ));

    if (result.hasException) {
      print('Error: ${result.exception.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save appointment',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      print(
          'Success! Appointment saved with ID: ${result.data!['insert_consultant_appointments']['id']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Appointment saved successfully',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.greenAccent,
        ),
      );
      patientNotesController.clear();
    }
    isLoading = false;
    notifyListeners();
  }
}
