import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
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

  void _showPatientDialog() {
    String timestamp = DateTime.now().toLocal().toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomTheme.containerColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Ingresar Paciente',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInput(
              controller: nameController,
              keyboardType: TextInputType.name,
              labelText: 'Nombre',
              hintText: 'Ingrese nombre',
              icon: Icons.person,
              borderColor: CustomTheme.primaryColor,
              iconColor: CustomTheme.onprimaryColor,
              fillColor: Colors.grey[800]!,
            ),
            const SizedBox(height: 10),
            CustomInput(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              labelText: 'Teléfono',
              hintText: 'Ingrese teléfono',
              icon: Icons.phone,
              borderColor: CustomTheme.primaryColor,
              iconColor: CustomTheme.onprimaryColor,
              fillColor: Colors.grey[800]!,
            ),
            const SizedBox(height: 10),
            CustomInput(
              controller: birthDateController,
              keyboardType: TextInputType.datetime,
              labelText: 'Fecha de Nacimiento',
              hintText: 'YYYY-MM-DD',
              icon: Icons.calendar_today,
              borderColor: CustomTheme.primaryColor,
              iconColor: CustomTheme.onprimaryColor,
              fillColor: Colors.grey[800]!,
            ),
            const SizedBox(height: 10),
            CustomInput(
              controller: TextEditingController(text: timestamp),
              keyboardType: TextInputType.text,
              labelText: 'Timestamp',
              hintText: timestamp,
              icon: Icons.access_time,
              borderColor: CustomTheme.primaryColor,
              iconColor: CustomTheme.onprimaryColor,
              fillColor: Colors.grey[800]!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              // Save logic
              print('Paciente agregado: ${nameController.text}');
              Navigator.pop(context);
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
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
                      // Your onTap function logic here
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
              onTap: _showPatientDialog,
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