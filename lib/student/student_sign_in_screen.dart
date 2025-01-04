import 'package:flutter/material.dart';
import 'package:myapp/student/authenticate_face/authenticate_face_view.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:myapp/student/forget_password.dart';

class StudentSignIn extends StatefulWidget {
  const StudentSignIn(this.toggleView, {required this.goBack, super.key});

  final void Function() toggleView;
  final void Function() goBack;

  @override
  State<StudentSignIn> createState() => _StudentSignInState();
}

class _StudentSignInState extends State<StudentSignIn> {
  String error = '';
  bool loading = false;
  bool rememberMe = false;
  bool showPassword = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: reusableappBar(context),
              backgroundColor: const Color.fromARGB(250, 26, 12, 54),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    widget.goBack();
                  },
                  label: const Text(
                    "Home",
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
                                    text: '',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(239, 215, 107, 215),
                                        fontWeight: FontWeight.w700)),
                                TextSpan(
                                    text: 'Welcome Back!',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 211, 32, 211),
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '\n \n Enter your credentials to login',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16

                                        //fontWeight: FontWeight.bold
                                        )),
                              ],
                            )),
                        const SizedBox(height: 80),
                        // Email Field
                        TextFormField(
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter an Email'
                              : null,
                          controller: _emailTextController,
                          obscureText: false,
                          cursorColor: Colors.white,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
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
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
// Password Field with "Show Password"
                        TextFormField(
                          validator: (val) => val == null || val.isEmpty
                              ? 'Enter a password'
                              : null,
                          controller: _passwordTextController,
                          obscureText: !showPassword,
                          cursorColor: Colors.white,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white70,
                            ),
                            labelText: "Enter Password",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                  activeColor:
                                      const Color.fromARGB(255, 181, 29, 181),
                                ),
                                const Text(
                                  "Remember Me",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to the ForgetPasswordScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPasswordScreen()),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 181, 29, 181),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthenticateFaceView(
                                    studentId: "",
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
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
                          //icon: const Icon(Icons.arrow_right_alt_sharp),
                          label: const Text('Sign In'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          error,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget
                                  .toggleView, // Navigates to the register screen
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 74,
                                      255), // You can change this color if needed
                                ),
                              ),
                            ),
                          ],
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