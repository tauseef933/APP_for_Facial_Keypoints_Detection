import 'package:flutter/material.dart';
import 'package:myapp/app.dart';
import 'package:myapp/home.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/attempt_quiz.dart';
import 'package:myapp/student/check_user_screen.dart';
import 'package:myapp/student/reports.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:myapp/reusable_widgets/loading.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:myapp/student/student_services/register_user_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/student/notification_screen.dart'; // Import the NotificationsPage
import 'package:myapp/student/setting_screen.dart'; // Import the SettingsScreen

class StudentHome extends StatefulWidget {
  StudentHome({super.key});

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final StudentAuthService _auth = StudentAuthService();

  int _selectedIndex = 0; // To manage the selected tab index

  // Function to handle tap on BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentHome()),
      );
    } else if (index == 1) {
      // Navigate to Notifications screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationsPage()),
      );
    } else if (index == 2) {
      // Navigate to Messages screen
    } else if (index == 3) {
      // Navigate to Settings screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentUser = Provider.of<StudentUser>(context);

    return StreamBuilder<StudentUserData>(
      stream: StudentDatabaseService(uid: studentUser.studentId).studentData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Snapshot has data");
          StudentUserData? studentUserData = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(250, 26, 12, 54),
              title: reusableappBar(context),
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  label: const Text(
                    "",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 63, 255),
                      fontSize: 16,
                    ),
                  ),
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 255, 63, 255),
                  ),
                ),
              ],
            ),
            body: Container(
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/img1.png',
                              width: 400,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Begin your FaceGuard experience today!\n"
                              "Explore the power of AI to protect your identity, "
                              "enhance security, and unlock a seamless experience—all with just a glance.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Wrap(
                              runSpacing: 10,
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      print(studentUserData?.firstName);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterUser(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 181, 29, 181),
                                      foregroundColor: const Color.fromARGB(
                                          255, 255, 189, 255),
                                    ),
                                    icon: const Icon(Icons.group_add_rounded),
                                    label: const Text('Register'),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckUser(
                                            studentId:
                                                studentUser.studentId ?? "",
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 181, 29, 181),
                                      foregroundColor: const Color.fromARGB(
                                          255, 255, 189, 255),
                                    ),
                                    icon: const Icon(Icons.add_task_sharp),
                                    label: const Text('Authenticate'),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 40,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Reports(
                                            studentId: studentUser.studentId,
                                            userType: 0,
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 181, 29, 181),
                                      foregroundColor: const Color.fromARGB(
                                          255, 255, 189, 255),
                                    ),
                                    icon: const Icon(
                                        Icons.report_gmailerrorred_sharp),
                                    label: const Text('Reports'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color.fromARGB(255, 84, 62, 123),
              selectedItemColor: const Color.fromARGB(255, 244, 47, 244),
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message_rounded),
                  label: 'Message',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'settings',
                ),
              ],
            ),
          );
        } else {
          print("Snapshot has no data");
          return Container();
        }
      },
    );
  }
}
