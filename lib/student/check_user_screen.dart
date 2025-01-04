import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/student/authenticate_face/authenticate_face_view.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:myapp/student/student_services/database.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({required this.studentId, super.key});

  final String studentId;
  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  String error = '';

  final _formKey = GlobalKey<FormState>();

  // final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: reusableappBar(context),
              backgroundColor: const Color.fromARGB(250, 26, 12, 54),
              actions: <Widget>[
                // TextButton.icon(
                //   onPressed: () {
                //     widget.goBack();
                //   },
                //   label: const Text(
                //     "Home",
                //     style: TextStyle(
                //         color: Color.fromARGB(255, 255, 74, 255), fontSize: 17),
                //   ),
                //   icon: const Icon(
                //     Icons.home,
                //     color: Color.fromARGB(255, 255, 74, 255),
                //   ),
                // ),
              ],
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
                        20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                    child: Column(
                      children: <Widget>[
                        RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(fontSize: 22),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Authenticte',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(239, 215, 107, 215),
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text: 'User',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 211, 32, 211),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '\n Enter Email and face to check AUthentication',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ))
                              ],
                            )),
                        // Image.asset(
                        //   "assets/images/stdlogo-2.png",
                        //   fit: BoxFit.fitWidth,
                        //   width: 240,
                        //   height: 240,
                        //   // color: Colors.white,
                        // ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter an Email ';
                            }

                            return null;
                          },
                          controller: _emailTextController,
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
                              Icons.person_outline,
                              color: Colors.white70,
                            ),
                            labelText: "Enter Email",
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
                          keyboardType: TextInputType.emailAddress,
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // TextFormField(
                        //   validator: (val) {
                        //     if (val == null || val.isEmpty) {
                        //       return 'Enter a password ';
                        //     }

                        //     return null;
                        //   },
                        //   controller: _passwordTextController,
                        //   obscureText: true,
                        //   enableSuggestions: false,
                        //   autocorrect: false,
                        //   cursorColor: Colors.white,
                        //   style:
                        //       TextStyle(color: Colors.white.withOpacity(0.9)),
                        //   decoration: InputDecoration(
                        //     focusedBorder: const OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Color.fromARGB(255, 181, 29, 181),
                        //       ),
                        //     ),
                        //     prefixIcon: const Icon(
                        //       Icons.lock_outline,
                        //       color: Colors.white70,
                        //     ),
                        //     labelText: "Enter Password",
                        //     labelStyle:
                        //         TextStyle(color: Colors.white.withOpacity(0.9)),
                        //     filled: true,
                        //     floatingLabelBehavior: FloatingLabelBehavior.never,
                        //     fillColor: Colors.white.withOpacity(0.3),
                        //     border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(30.0),
                        //         borderSide: const BorderSide(
                        //             width: 0, style: BorderStyle.none)),
                        //   ),
                        //   keyboardType: TextInputType.visiblePassword,
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            StudentDatabaseService sds =
                                StudentDatabaseService(uid: widget.studentId);
                            if (_formKey.currentState!.validate()) {
                              // setState(() {
                              //   loading = false;
                              // });

                              Map<String, String?> quizMap = {
                                "instructorId": _emailTextController.text
                              };

                              dynamic result = await sds.addReportData(quizMap);

                              if (result != null) {}
                              reportID = result;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthenticateFaceView(
                                    studentId: widget.studentId,
                                    email: _emailTextController.text,
                                    password: "",
                                  ),
                                ),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 181, 29, 181),
                            foregroundColor:
                                const Color.fromARGB(255, 255, 189, 255),
                          ),
                          icon: const Icon(Icons.arrow_right_alt_sharp),
                          label: const Text('Check User'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        // TextButton.icon(
                        //   onPressed: () {
                        //     widget.toggleView();
                        //   },
                        //   label: const Text(
                        //     "Register",
                        //     style: TextStyle(
                        //         color: Color.fromARGB(255, 255, 74, 255),
                        //         fontSize: 17),
                        //   ),
                        //   icon: const Icon(
                        //     Icons.person,
                        //     color: Color.fromARGB(255, 255, 74, 255),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}