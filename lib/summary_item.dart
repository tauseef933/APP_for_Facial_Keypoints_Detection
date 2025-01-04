import 'package:flutter/material.dart';
import 'package:myapp/question_identifier.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem(this.itemData, {super.key});

  final Map<String, Object> itemData;

  @override
  Widget build(BuildContext context) {
    final isCorrect = itemData['user_answer'] == itemData['correct_answer'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionsIdentifier((itemData['question_index'] as int) + 1, isCorrect),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemData['question'] as String,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                itemData['user_answer'] as String,
                style: const TextStyle(
                  color: Color.fromARGB(249, 52, 152, 156),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                itemData['correct_answer'] as String,
                style: const TextStyle(
                  color: Color.fromARGB(255, 137, 74, 137),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
