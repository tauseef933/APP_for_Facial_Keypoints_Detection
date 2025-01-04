import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/student/Models/student_user.dart';

class StudentDatabaseService {
  StudentDatabaseService({required this.uid});
  final String? uid;

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('Students');

  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection("Quizzes");

  final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection("Reports");

  Future updateStudentData(String firstName, String lastName, String email,
      String? image, FaceFeatures? faceFeatures) async {
    try {
      // ignore: prefer_interpolation_to_compose_strings
      //print("adding collection");
      print("${uid} student database service");
      return await studentsCollection.doc(uid).set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'image': image,
        'faceFeatures': faceFeatures?.toJson() ?? {},
      });
    } catch (e) {
      //print(e.toString());
    }
  }

  //get instructor doc stream
  Stream<StudentUserData> get studentData {
    print("stream student");
    return studentsCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //userdata from snapshot
  StudentUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return StudentUserData(
        uid: uid!,
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        email: snapshot['email']);
  }

  getQuizzes() async {
    return await quizCollection.snapshots();
  }

  getQuizData(String quizId) async {
    return await quizCollection.doc(quizId).collection("QNA").get();
  }

  getReports(String? id, int userType) async {
    if (userType == 0) {
      return await reportsCollection.snapshots();
    } else {
      print("error ");
    }
  }

  getReportsData(String reportId) async {
    print(reportId);
    return await reportsCollection
        .doc(reportId)
        .collection("ReportItem")
        .snapshots();
  }

  Future<String> addReportData(Map reportData) async {
    // DocumentReference docref = quizCollection.doc();
    // quizData.addAll({'quizId': docref.id});

    String docRef = "";

    await reportsCollection.add(reportData).then((DocumentReference ref) => {
          docRef = ref.id,
        });
    // print(docRef);

    //quizData.addAll({'quizId': docRef});

    await reportsCollection.doc(docRef).update({'reportId': docRef});

    return docRef;
  }

  Future<void> addReportItem(
      Map<String, String> reportItem, String? reportId) async {
    await reportsCollection
        .doc(reportId)
        .collection("ReportItem")
        .add(reportItem)
        .catchError((e) {
      print(e.toString());
    });
  }
}
