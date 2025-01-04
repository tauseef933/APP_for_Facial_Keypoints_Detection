import 'package:flutter/material.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:provider/provider.dart';
import 'package:myapp/student/student_home.dart';
import 'package:myapp/student/setting_screen.dart';
import 'package:myapp/student/Models/student_user.dart'; // Import student model

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final StudentAuthService _auth = StudentAuthService();

  int _selectedIndex = 1; // Default to Notifications tab

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),

              // Notification Image (if no notifications)
              Image.asset(
                'assets/images/noti1.png', // Replace with your own asset path
                width: 100,
                height: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your notifications will appear here once you’ve received them.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40.0),

              // List of Notifications (if there are any)
              Expanded(
                child: Center(
                  child: Text(
                    'No notifications available.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
  }
}
