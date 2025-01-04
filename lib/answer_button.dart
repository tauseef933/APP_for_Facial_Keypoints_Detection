import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.answerText, this.onTap, {super.key});

  final String answerText;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 10,
        ),
        backgroundColor: const Color.fromARGB(255, 188, 34, 199),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      child: Text(
        answerText,
        style: const TextStyle(
          color: Color.fromARGB(255, 250, 250, 250),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
