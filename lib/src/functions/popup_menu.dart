import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/models/patient_model.dart';


void showPopupMenu(BuildContext context,Patient patient) { // Accept patient
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: CustomTheme.containerColor,
    isScrollControlled: true, 
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.symmetric(vertical: 20), 
        decoration: const BoxDecoration(
          color: CustomTheme.containerColor,
          borderRadius:  BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            _buildMenuItem(
              icon: Icons.edit_calendar_rounded,
              text: "Historial de citas",
              onTap: () {
  final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
  selectedPatientProvider.selectPatient(patient, patient.id);
  
     
                Navigator.pushNamed(context, '/AppointmentPage');
              },
            ),
            _buildMenuItem(
              icon: Icons.person,
              text: "Ficha Clinica",
              onTap: () {
  final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
  selectedPatientProvider.selectPatient(patient, patient.id); // ✅ Now passing a Patient object
                Navigator.pushNamed(context, '/ClinicalHistoryPage');
              },
            ),
            _buildMenuItem(
              icon: Icons.history_toggle_off_outlined,
              text: "Plan de tratamiento",
              onTap: () {
  final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
  selectedPatientProvider.selectPatient(patient, patient.id);
                Navigator.pushNamed(context, '/TreatmentPlanPage'
                  
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.history,
              text: "Historial de pago",
              onTap: () {
  final selectedPatientProvider = Provider.of<SelectedPatientProvider>(context, listen: false);
  selectedPatientProvider.selectPatient(patient,patient.id);
                Navigator.of(context).pushNamed(
                  '/PaymentHistoryPage',
                
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
Widget _buildMenuItem({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
  Color iconColor = CustomTheme.lettersColor,
  Color textColor = CustomTheme.lettersColor,
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor, size: 40), // Bigger icons
    title: Text(
      text,
      style: TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.bold), // Larger font
    ),
    onTap: onTap,
  );
}