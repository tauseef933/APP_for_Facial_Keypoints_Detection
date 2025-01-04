import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, this.goToInstructor, this.goToStudent,
      {super.key, required this.goBack});

  final void Function() startQuiz;
  final void Function() goToInstructor;
  final void Function() goToStudent;
  final void Function() goBack;

  @override
  Widget build(context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "𝕱𝖆𝖈𝖊𝕲𝖚𝖆𝖗𝖉",
              style: TextStyle(
                color: Color.fromARGB(255, 181, 29, 181),
                fontSize: 45,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Your Face, Your Key",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 122, 255),
                fontSize: 15,
              ),
            ),
            Image.asset(
              'assets/images/img1.png',
              width: 400,
              //color: const Color.fromARGB(104, 149, 23, 188)
              color: Colors.white60,
            ),
            const SizedBox(
              height: 30,
            ),
            // const Text(
            //   "FaceGuard",
            //   style: TextStyle(
            //     color: Color.fromARGB(255, 181, 29, 181),
            //     fontSize: 25,
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // const Text(
            //   "Your Face, Your Key",
            //   style: TextStyle(
            //     color: Color.fromARGB(255, 255, 122, 255),
            //     fontSize: 15,
            //   ),
            // ),
            const SizedBox(
              height: 80,
            ),
            // Expanded(
            //   child: OutlinedButton.icon(
            //     onPressed: goToInstructor,
            //     style: OutlinedButton.styleFrom(
            //       backgroundColor: const Color.fromARGB(255, 181, 29, 181),
            //       foregroundColor: const Color.fromARGB(255, 255, 189, 255),
            //     ),
            //     icon: const Icon(Icons.arrow_right_alt_sharp),
            //     label: const Text('Instructor'),
            //   ),
            // ),
            // const SizedBox(
            //   width: 40,
            // ),
            OutlinedButton.icon(
              onPressed: goToStudent,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 181, 29, 181),
                foregroundColor: const Color.fromARGB(255, 255, 189, 255),
              ),
              //icon: const Icon(Icons.arrow_right_alt_sharp),
              label: const Text('Get Started'),
            )
          ],
        ),
      ),
    );
  }
}
