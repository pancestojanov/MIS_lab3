class ExamAppointment {
  final String id;
  final String examName;
  final DateTime? date;
  final String longitude;
  final String latitude;

  ExamAppointment({
    required this.id,
    required this.examName,
    this.date,
    required this.longitude,
    required this.latitude,
  });
}