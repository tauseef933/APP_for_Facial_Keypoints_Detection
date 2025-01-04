import 'package:flutter/material.dart';
import 'package:myapp/student/forget_password.dart';
import 'package:myapp/student/apperence_screen.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';
import 'package:myapp/student/notification_screen.dart'; // Import the NotificationsPage
import 'package:myapp/student/about.dart'; // Import the SettingsScreen

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 26, 12, 54),
        title: reusableappBar(context),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              // await _auth.signOut();
            },
            label: const Text(
              "",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 63, 255),
                fontSize: 16,
              ),
            ),
            icon: const Icon(
              Icons.logout_outlined,
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
          child: ListView(
            children: [
              // Profile Section
              // ListTile(
              //   leading: const Icon(Icons.account_circle, color: Colors.white),
              //   title: const Text(
              //     'Profile',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   subtitle: const Text('View and edit your profile'),
              //   onTap: () {
              //     // Navigate to the Profile Edit screen (if any)
              //   },
              // ),
              // const Divider(color: Colors.white),

              // Security Section
              ListTile(
                leading: const Icon(Icons.security, color: Colors.white),
                title: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Update your login password'),
                onTap: () {
                  // Navigate to change password screen (if available)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen()),
                  );
                },
              ),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.face, color: Colors.white),
                title: const Text(
                  'Face Recognition',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Re-enroll or update face data'),
                onTap: () {
                  // Navigate to face recognition update screen
                },
              ),
              const Divider(color: Colors.white),

              // Notification Settings Section
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: const Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Manage push notification preferences'),
                onTap: () {
                  // Navigate to notifications settings screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()),
                  );
                },
              ),
              const Divider(color: Colors.white),

              // Privacy Section
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text(
                  'Privacy Settings',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Manage your data and privacy'),
                onTap: () {
                  // Navigate to privacy settings screen
                },
              ),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.white),
                title: const Text(
                  'Clear Face Data',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Delete your stored face data'),
                onTap: () {
                  // Implement clear face data functionality
                },
              ),
              const Divider(color: Colors.white),

              // General Settings Section
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: const Text(
                  'Language',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Choose your preferred language'),
                onTap: () {
                  // Navigate to language settings screen
                },
              ),
              const Divider(color: Colors.white),
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.white),
                title: const Text(
                  'Theme',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('Switch between dark and light modes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => ThemeSwitcherScreen()),
                  );
                  // Implement theme toggle functionality
                },
              ),
              const Divider(color: Colors.white),

              // About Section
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text('App version and legal information'),
                onTap: () {
                  // Navigate to about screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutScreen()),
                  );
                },
              ),
              const Divider(color: Colors.white),

              // Logout
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Implement logout functionality
                  //       onPressed: () async {
                  //   await _auth.signOut();
                  // },
                },
              ),
              const Divider(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
