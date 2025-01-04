import 'package:flutter/material.dart';
//import 'package:myapp/instructor/instructor_services/auth.dart';
import 'package:myapp/instructor/instructor_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion(
      {required this.docId, required this.instructorId, super.key});

  final String? docId;
  final String? instructorId;

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  //final InstructorAuthService _auth = InstructorAuthService();

  String error = '';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quizQuestionTextController =
      TextEditingController();
  final TextEditingController _quizOption1TextController =
      TextEditingController();
  final TextEditingController _quizOption2TextController =
      TextEditingController();
  final TextEditingController _quizOption3TextController =
      TextEditingController();
  final TextEditingController _quizOption4TextController =
      TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              // iconTheme:
              // const IconThemeData(color: Color.fromARGB(255, 255, 63, 255)),
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
                        20, MediaQuery.of(context).size.height * 0.1, 20, 5),
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
                              return 'Enter Quiz Question ';
                            }

                            return null;
                          },
                          controller: _quizQuestionTextController,
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
                            labelText: "Quiz Question",
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
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Quiz option 1 ';
                            }

                            return null;
                          },
                          controller: _quizOption1TextController,
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
                            labelText: "Option 1 (Correct Option)",
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
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Quiz option 2 ';
                            }

                            return null;
                          },
                          controller: _quizOption2TextController,
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
                            labelText: "Option 2",
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
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Quiz option 3 ';
                            }

                            return null;
                          },
                          controller: _quizOption3TextController,
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
                            labelText: "Option 3",
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
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter Quiz option 4 ';
                            }

                            return null;
                          },
                          controller: _quizOption4TextController,
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
                            labelText: "Option 4",
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 181, 29, 181),
                                foregroundColor:
                                    const Color.fromARGB(255, 255, 189, 255),
                              ),
                              icon: const Icon(Icons.upload_file_outlined),
                              label: const Text('Submit Quiz'),
                            ),
                            const SizedBox(width: 50),
                            //
                            //
                            OutlinedButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  InstructorDatabaseService service =
                                      InstructorDatabaseService(
                                          uid: widget.instructorId);

                                  Map<String, String> questionMap = {
                                    "question":
                                        _quizQuestionTextController.text,
                                    "option1": _quizOption1TextController.text,
                                    "option2": _quizOption2TextController.text,
                                    "option3": _quizOption3TextController.text,
                                    "option4": _quizOption4TextController.text,
                                  };

                                  await service
                                      .addQuestionData(
                                          questionMap, widget.docId)
                                      .then((value) => {
                                            setState(() {
                                              loading = false;
                                              _quizQuestionTextController
                                                  .clear();
                                              _quizOption1TextController
                                                  .clear();
                                              _quizOption2TextController
                                                  .clear();
                                              _quizOption3TextController
                                                  .clear();
                                              _quizOption4TextController
                                                  .clear();
                                            })
                                          });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 181, 29, 181),
                                foregroundColor:
                                    const Color.fromARGB(255, 255, 189, 255),
                              ),
                              icon: const Icon(Icons.add_box_sharp),
                              label: const Text('Add Question'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
