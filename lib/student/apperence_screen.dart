import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/reusable_widgets/reusable_widget.dart';

class ThemeSwitcherScreen extends StatefulWidget {
  const ThemeSwitcherScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ThemeSwitcherScreenState createState() => _ThemeSwitcherScreenState();
}

class _ThemeSwitcherScreenState extends State<ThemeSwitcherScreen> {
  bool _isDarkMode = false;

  // Load the theme preference from SharedPreferences
  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save the theme preference to SharedPreferences
  void _saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // Toggle the theme
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveThemePreference(_isDarkMode);
  }

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Load the saved theme when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
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
                "Back",
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Choose your preferred theme:",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Switch(
                value: _isDarkMode,
                onChanged: (bool value) {
                  _toggleTheme();
                },
              ),
              const SizedBox(height: 40),
              Text(
                _isDarkMode ? "Dark Mode" : "Light Mode",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const ThemeSwitcherScreen());
}
