import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';

class PantallaFichaClinica extends StatefulWidget {
  const PantallaFichaClinica({super.key});

  @override
  State<PantallaFichaClinica> createState() => _PantallaFichaClinicaState();
}

class _PantallaFichaClinicaState extends State<PantallaFichaClinica> {
  final TextEditingController searchController = TextEditingController();

  // Simulated list of patients
  final List<Map<String, String>> patients = [
    {'name': 'Juan Pérez', 'id': '123', 'diagnosis': 'Caries'},
    {'name': 'María López', 'id': '124', 'diagnosis': 'Ortodoncia'},
    {'name': 'Pedro González', 'id': '125', 'diagnosis': 'Limpieza'},
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
      backgroundColor: CustomTheme.fillColor, // ✅ Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: CustomTheme.containerColor, // ✅ Search bar background
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
                style: const TextStyle(color: Colors.white), // ✅ Text color
                decoration: const InputDecoration(
                  hintText: 'Buscar paciente',
                  hintStyle: TextStyle(color: Colors.grey), // ✅ Placeholder color
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
            const SizedBox(height: 16),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton('Buscar', '/PantallaVistaDatos'),
                _buildButton('Crear', '/PantallaForm'),
                _buildButton('Editar', null),
              ],
            ),

            const SizedBox(height: 20),
            // Title
            const Text(
              'Lista de Pacientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // ✅ White text for visibility
              ),
            ),
            const SizedBox(height: 10),

            // Patient List
            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 80, color: CustomTheme.lettersColor),
                          SizedBox(height: 10),
                          Text(
                            'No se encontraron pacientes',
                            style: TextStyle(fontSize: 16, color: CustomTheme.lettersColor),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Intenta realizar una nueva búsqueda.',
                            style: TextStyle(fontSize: 14, color: CustomTheme.lettersColor),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return Card(
                          color: CustomTheme.containerColor, // ✅ Dark card background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                patient['name']![0],
                                style: const TextStyle(color: CustomTheme.primaryColor),
                              ),
                            ),
                            title: Text(
                              patient['name']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // ✅ White text
                              ),
                            ),
                            subtitle: Text(
                              'Diagnóstico: ${patient['diagnosis']}',
                              style: const TextStyle(fontSize: 14, color: CustomTheme.lettersColor), // ✅ Grey subtitle
                            ),
                            trailing: const Icon(Icons.chevron_right, color: Colors.white),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, String? route) {
    return InkWell(
      onTap: route != null
          ? () => Navigator.of(context).pushReplacementNamed(route)
          : () => print("$label tapped"),
      child: Container(
        width: 120.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // ✅ Button background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
