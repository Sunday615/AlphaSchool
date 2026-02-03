class StudentCardItem {
  final String studentId;
  final String name;
  final String? photoUrl;

  const StudentCardItem({
    required this.studentId,
    required this.name,
    this.photoUrl,
  });
}
