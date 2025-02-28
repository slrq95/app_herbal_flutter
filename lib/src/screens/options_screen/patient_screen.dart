import 'package:app_herbal_flutter/src/functions/patient_screen_functions/update_patient_dialog.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/components/custom_card.dart';
import 'package:app_herbal_flutter/src/functions/show_patient_dialog.dart';
import 'package:app_herbal_flutter/src/functions/popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';


class PantientPage extends StatefulWidget {
  const PantientPage({super.key});

  @override
  State<PantientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PantientPage> {
  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    final updateProvider = Provider.of<PatientUpdateProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),

                // 🔹 Search Bar
                Container(
                  height: 60.0,
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
                    controller: patientProvider.searchController,
                    style: const TextStyle(color: Colors.white,fontSize: 28),
                    autocorrect: false, // Disables autocorrect
                    enableSuggestions: false, // Disables word suggestions
                    keyboardType: TextInputType.text, 
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
                    onChanged: (query) => patientProvider.filterPatients(query),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Patient List Card
                Consumer<PatientProvider>(
                  builder: (context, provider, child) {
                    final patients = provider.filteredPatients;

                    if (patients.isEmpty) {
                      return const Center(child: Text('No patients found.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,  // Make sure ListView takes only the required space
                      physics: const NeverScrollableScrollPhysics(),  // Disable internal scroll
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];

                        return InkWell(
                          onTap: () {
                            showPopupMenu(context, patient); // Pass selected patient
                            debugPrint("Card tapped");
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2, // 20% screen height
                            width: double.infinity, // Full width
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: CustomCard(
                              child: ListTile(
                                title: Text(
                                  'Nombre: ${patient.name}',
                                  style: const TextStyle(color: Colors.white, fontSize: 24),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Telefono/celular: ${patient.phone}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 22),
                                    ),
                                    Text(
                                      'Fecha de nacimiento: ${patient.birthDate}',
                                      style: const TextStyle(color: Colors.grey,fontSize: 24),
                                    ),
                                    Text(
                                      'ID: ${patient.id}',
                                      style: const TextStyle(color: Colors.grey,fontSize: 24),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () {
                                    showEditDialog(context, updateProvider, patientProvider, patient);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                // 🔹 InkWell Image Button
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      showPatientDialog(context);
                    },
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}