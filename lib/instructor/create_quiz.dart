import 'package:flutter/material.dart';
import 'package:myapp/instructor/add_question.dart';
//import 'package:myapp/instructor/instructor_services/auth.dart';
import 'package:myapp/instructor/instructor_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
//import 'package:myapp/reusable_widgets/reusable_widget.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({required this.instructorId, super.key});

  final String? instructorId;

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  //final InstructorAuthService _auth = InstructorAuthService();
  String error = '';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quizTitleTextController =
      TextEditingController();
  final TextEditingController _quizDescTextController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme:
                  const IconThemeData(color: Color.fromARGB(255, 255, 63, 255)),
              backgroundColor: const Color.fromARGB(250, 26, 12, 54),
              elevation: 0.0,
              title: reusableappBar(context),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 26, 12, 52),
                    Color.fromARGB(255, 84, 62, 123),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/think2.png",
                          fit: BoxFit.fitWidth,
                          width: 240,
                          height: 240,
                          // color: Colors.white,
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Quiz Title ';
                            }

                            return null;
                          },
                          controller: _quizTitleTextController,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 181, 29, 181),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.title_sharp,
                              color: Colors.white70,
                            ),
                            labelText: "Quiz Title",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Quiz Description ';
                            }

                            return null;
                          },
                          controller: _quizDescTextController,
                          obscureText: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 181, 29, 181),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.description_sharp,
                              color: Colors.white70,
                            ),
                            labelText: "Quiz Description",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                          ),
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });

                              InstructorDatabaseService
                                  instructorDatabaseService =
                                  InstructorDatabaseService(
                                      uid: widget.instructorId);

                              String? instructorId =
                                  instructorDatabaseService.uid;

                              Map<String, String?> quizMap = {
                                "instructorId": instructorId,
                                "quizTitle": _quizTitleTextController.text,
                                "quizDescription": _quizDescTextController.text,
                              };

                              String? documentId = "";

                              dynamic result = await instructorDatabaseService
                                  .addQuizData(quizMap)
                                  .then((String value) => {
                                        setState(() {
                                          _quizTitleTextController.clear();
                                          _quizDescTextController.clear();
                                          loading = false;
                                          documentId = value.toString();
                                        })
                                      });

                              if (result != null) {
                                if (context.mounted) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddQuestion(
                                              docId: documentId,
                                              instructorId: instructorId)));
                                }
                              }

                              //print(documentId);

                              if (result == null) {
                                setState(() {
                                  error = "Couldnt add Quiz";
                                  loading = false;
                                });
                              } else {}
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 181, 29, 181),
                            foregroundColor:
                                const Color.fromARGB(255, 255, 189, 255),
                          ),
                          icon: const Icon(Icons.create),
                          label: const Text('Create Quiz'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
