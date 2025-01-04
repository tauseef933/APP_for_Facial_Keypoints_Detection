import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/instructor/instructor_services/auth.dart';
import 'package:myapp/providers/recorder.dart';
import 'package:myapp/quiz.dart';
import 'package:myapp/student/common/utils/custom_snackbar.dart';
import 'package:myapp/student/common/utils/screen_size_util.dart';
import 'package:myapp/student/student_services/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  final StudentAuthService _auth = StudentAuthService();
  final InstructorAuthService _auth2 = InstructorAuthService();

  await _auth.signOut();
  await _auth2.signOut();

  final container = ProviderContainer();
  await container.read(recoderProvider).init();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const Quiz(),
    ),
  );
}
