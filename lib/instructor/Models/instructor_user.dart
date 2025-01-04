class InstructorUser {
  final String? instructorId;

  InstructorUser(this.instructorId);
}

class InstructorUserData {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? email;

  InstructorUserData(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.email});
}
