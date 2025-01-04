import 'package:flutter/material.dart';
import 'package:myapp/student/register_face_view.dart';
// import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  // final StudentAuthService _auth = StudentAuthService();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String error = '';

  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme:
                  const IconThemeData(color: Color.fromARGB(255, 255, 63, 255)),
              backgroundColor: const Color.fromARGB(250, 26, 12, 54),
              title: reusableappBar(context),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text(
                    "",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 74, 255), fontSize: 17),
                  ),
                  icon: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 255, 74, 255),
                  ),
                ),
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
                    padding: EdgeInsets.fromLTRB(20,
                        MediaQuery.of(context).size.height * 0.05, 20, 0 * 1),
                    child: Column(
                      children: <Widget>[
                        RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(fontSize: 22),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Register',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(239, 215, 107, 215),
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text: ' a user',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 211, 32, 211),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '\n \n new to FaceGuard?\n enter your details to get\n registered with FACEGUARD.',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16))
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
                              return 'Enter a First Name';
                            }

                            return null;
                          },
                          controller: _firstNameTextController,
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
                            labelText: "First Name",
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter a Last Name';
                            }

                            return null;
                          },
                          controller: _lastNameTextController,
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
                            labelText: "Last Name",
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Enter an email';
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
                            labelText: "Email",
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.length < 6) {
                              return 'Enter a password that is atleast 6 characters long';
                            }

                            return null;
                          },
                          controller: _passwordTextController,
                          obscureText: true,
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
                              Icons.lock_outline,
                              color: Colors.white70,
                            ),
                            labelText: "Department",
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
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // setState(() {
                              //   // loading = true;
                              // });
                              // dynamic result =
                              //     await _auth.registerWithEmailAndPassword(
                              //   _firstNameTextController.text,
                              //   _lastNameTextController.text,
                              //   _emailTextController.text,
                              //   _passwordTextController.text,
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterFaceView(
                                      email: _emailTextController.text,
                                      firstName: _firstNameTextController.text,
                                      lastName: _lastNameTextController.text,
                                      password: _passwordTextController.text),
                                ),
                              );

                              // if (result == null) {
                              //   setState(() {
                              //     loading = false;
                              //     error =
                              //         "please supply valid email and password";
                              //   });
                              // }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 181, 29, 181),
                            foregroundColor:
                                const Color.fromARGB(255, 255, 189, 255),
                          ),
                          icon: const Icon(Icons.arrow_right_alt_sharp),
                          label: const Text('Register'),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                        // TextButton.icon(
                        //   onPressed: () {
                        //     widget.toggleView();
                        //   },
                        //   label: const Text(
                        //     "Sign In",
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
