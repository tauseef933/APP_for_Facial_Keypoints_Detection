import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/instructor/Models/instructor_user.dart';
import 'package:myapp/student/Models/student_user.dart';

class InstructorDatabaseService {
  InstructorDatabaseService({required this.uid});
  final String? uid;

  final CollectionReference instructorsCollection =
      FirebaseFirestore.instance.collection('Instructors');

  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection("Quizzes");

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection("Students");

  Future updateInstructorData(
      String firstName, String lastName, String email) async {
    try {
      // ignore: prefer_interpolation_to_compose_strings
      //print("adding collection");
      print("${uid} Instructor database service");
      return await instructorsCollection.doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
    } catch (e) {
      //print(e.toString());
    }
  }

  //get instructor doc stream
  Stream<InstructorUserData> get instructorData {
    print("instructor Stream");
    return instructorsCollection
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //userdata from snapshot
  InstructorUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return InstructorUserData(
        uid: uid!,
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        email: snapshot['email']);
  }

  Stream<StudentUserData> get studentsData {
    print("stream student");
    return studentsCollection
        .doc(uid)
        .snapshots()
        .map(_studentuserDataFromSnapshot);
  }

  StudentUserData _studentuserDataFromSnapshot(DocumentSnapshot snapshot) {
    return StudentUserData(
        uid: uid!,
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        email: snapshot['email']);
  }

  //add quiz to DataBase
  Future<String> addQuizData(Map quizData) async {
    // DocumentReference docref = quizCollection.doc();
    // quizData.addAll({'quizId': docref.id});

    String docRef = "";

    await quizCollection.add(quizData).then((DocumentReference ref) => {
          docRef = ref.id,
        });

    // print(docRef);

    //quizData.addAll({'quizId': docRef});

    await quizCollection.doc(docRef).update({'quizId': docRef});

    return docRef;
  }

  Future<void> addQuestionData(
      Map<String, String> questionData, String? quizId) async {
    await quizCollection
        .doc(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getStudents() async {
    return await studentsCollection.snapshots();
  }

  getStudentsData(String quizId) async {
    return await studentsCollection.doc(quizId).collection("QNA").get();
  }
}
