class Appointment {
  final String name;
  final String idPatient;
  final String reason;
  final dynamic date;
  final dynamic time;
  final dynamic type;
  final dynamic priority;
  final dynamic status;
  final dynamic rescheduleDate;
  final dynamic rescheduleTime;
  final dynamic createdAt;

  Appointment({
    required this.name,
    required this.idPatient,
    required this.reason,
    required this.date,
    required this.time,
    required this.type,
    required this.priority,
    required this.status,
    this.rescheduleDate,
    this.rescheduleTime,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id_patient": idPatient,
      "reason": reason,
      "date": date,
      "time": time,
      "type": type,
      "priority": priority,
      "status": status,
      "reschedule_date": rescheduleDate,
      "reschedule_time": rescheduleTime,
      "created_at": createdAt,
    };
  }
}