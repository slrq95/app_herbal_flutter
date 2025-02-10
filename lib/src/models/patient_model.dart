class Patient {
  final String id;
  final String name;
  final String diagnosis;

  Patient({
    required this.id,
    required this.name,
    required this.diagnosis,
  });

  // Convert JSON to a Patient object
  factory Patient.fromJson(Map<String, String> json) {
    return Patient(
      id: json['id']!,
      name: json['name']!,
      diagnosis: json['diagnosis']!,
    );
  }

  // Convert a Patient object to JSON
  Map<String, String> toJson() {
    return {
      'id': id,
      'name': name,
      'diagnosis': diagnosis,
    };
  }
}
