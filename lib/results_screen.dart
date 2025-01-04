import 'package:flutter/material.dart';
import 'package:myapp/data/questions.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/questions_summary.dart';
import 'package:myapp/student/student_services/database.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(this.chosenAnswers, this.onGoBack, this.studentId,
      {super.key});

  final List<String> chosenAnswers;
  final void Function() onGoBack;
  final String? studentId;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < widget.chosenAnswers.length; i++) {
      summary.add(
        {
          "question_index": i,
          "question": questions[i].text,
          'correct_answer': questions[i].answers[0],
          'user_answer': widget.chosenAnswers[i],
        },
      );
    }

///////////////////////////////////
    ///
    return summary;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateReport();
  }

  void updateReport() async {
    print("updating");
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = getSummaryData().where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    StudentDatabaseService dbs = StudentDatabaseService(uid: widget.studentId);

    await dbs.reportsCollection
        .doc(reportID)
        .update({'totalMarks': numTotalQuestions.toString()});
    await dbs.reportsCollection
        .doc(reportID)
        .update({'obtainedMarks': numCorrectQuestions.toString()});

    print("Correct $numCorrectQuestions");
    print("total $numTotalQuestions");
  }

  @override
  Widget build(BuildContext context) {
    final summaryData = getSummaryData();
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              style: const TextStyle(
                color: Color.fromARGB(255, 209, 11, 209),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionsSummary(summaryData),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: () {
                widget.onGoBack();
              },
              label: const Text("Go Back",
                  style: TextStyle(
                      color: Color.fromARGB(255, 209, 11, 209),
                      fontWeight: FontWeight.bold)),
              icon: const Icon(Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 209, 11, 209)),
            ),
          ],
        ),
      ),
    );
  }
}
