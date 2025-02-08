import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';


void showPopupMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: CustomTheme.containerColor,
    isScrollControlled: true, // Allows defining custom height
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
        padding: const EdgeInsets.symmetric(vertical: 20), // Padding for spacing
        decoration: const BoxDecoration(
          color: CustomTheme.containerColor,
          borderRadius:  BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust height automatically
          children: [
            _buildMenuItem(
              icon: Icons.edit_calendar_rounded,
              text: "Historial de citas",
              onTap: () {
                print("Historial de citas tapped");
                Navigator.of(context).pushReplacementNamed('/AppointmentPage'); 
              },
            ),
            _buildMenuItem(
              icon: Icons.person,
              text: "Ficha Clinica",
              onTap: () {
                print("Ficha clinica tapped");
                Navigator.of(context).pushReplacementNamed('/ClinicalHistoryPage');
              },
            ),
            _buildMenuItem(
              icon: Icons.history_toggle_off_outlined,
              text: "Plan de tratamiento",

              onTap: () {
                print("Plan de tratamiento tapped");
                Navigator.pop(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.history,
              text: "Historial de pago",
              onTap: () {
                print("Historial de pago tapped");
                Navigator.of(context).pushReplacementNamed('/PaymentHistoryPage');
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
