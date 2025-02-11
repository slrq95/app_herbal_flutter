class Patient {
  final String id;
  final String name;
  final String phone;
  final String birthDate;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.birthDate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id_patient']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      birthDate: json['birth_date'] ?? '',
    );
  }
}