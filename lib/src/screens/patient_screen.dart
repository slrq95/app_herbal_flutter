import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:app_herbal_flutter/src/functions/show_patient_dialog.dart';
import 'package:app_herbal_flutter/src/functions/popup_menu.dart';
class PantientPage extends StatefulWidget {
  const PantientPage({super.key});

  @override
  State<PantientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PantientPage> {
   final TextEditingController searchController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  final List<Map<String, String>> patients = [
    {'name': 'Juan Pérez', 'id': '123', 'diagnosis': 'Caries'},

  ];

  List<Map<String, String>> filteredPatients = [];


  @override
  void initState() {
    super.initState();
    filteredPatients = patients;
  }

  void _filterPatients(String query) {
    setState(() {
      filteredPatients = query.isEmpty
          ? patients
          : patients
              .where((patient) =>
                  patient['name']!.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.fillColor,
      body: Stack(
        children: [
          // ✅ Full-screen search bar + list
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120.0),
                  // 🔹 Search Bar with Full Width
                  Container(
                    height: 90.0,
                    decoration: BoxDecoration(
                      color: CustomTheme.containerColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Buscar paciente',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      onChanged: _filterPatients,
                    ),
                  ),


                  
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                    onTap: () {
                      showPopupMenu(context);
                    print("Card tapped");
                        },
                    child: Container(
                    height: MediaQuery.of(context).size.height * 0.2, // 30% of the screen height
                    width: MediaQuery.of(context).size.width * 1, // Adjust width as needed
                    child: CustomCard(
                      child: ListTile( 
                      title: Text(
                        filteredPatients.isNotEmpty ? filteredPatients[0]['name']! : 'No Patient Found',
                        style: const TextStyle(color: Colors.white),
                        ),
                      subtitle: Text(
                        filteredPatients.isNotEmpty ? 'Diagnóstico: ${filteredPatients[0]['diagnosis']}' : '',
                        style: const TextStyle(color: Colors.grey),
                          ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // ✅ Positioned 170x170 InkWell Container (Centered Left)
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 85, // Centered vertically
            left: 10, // 10px from the left
            child: InkWell(
              onTap:(){ showPatientDialog(context);},
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('lib/src/assets/images/ingreso_paciente.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}