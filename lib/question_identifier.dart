import 'package:flutter/material.dart';

class QuestionsIdentifier extends StatelessWidget {
  const QuestionsIdentifier(this.questionIndex, this.isCorrect, {super.key});

  final int questionIndex;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isCorrect
            ? const Color.fromARGB(132, 36, 138, 141)
            : const Color.fromARGB(255, 181, 29, 181),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        questionIndex.toString(),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
