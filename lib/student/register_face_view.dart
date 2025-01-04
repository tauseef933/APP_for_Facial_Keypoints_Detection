import 'dart:convert';

import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/common/utils/custom_snackbar.dart';
import 'package:myapp/student/common/utils/extract_face_feature.dart';
import 'package:myapp/student/common/views/camera_view.dart';
import 'package:myapp/student/common/views/custom_button.dart';
import 'package:myapp/student/common/utils/extensions/size_extension.dart';
import 'package:myapp/student/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:myapp/student/student_services/auth.dart';

class RegisterFaceView extends StatefulWidget {
  RegisterFaceView(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      Key? key})
      : super(key: key);

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  @override
  State<RegisterFaceView> createState() => _RegisterFaceViewState();
}

class _RegisterFaceViewState extends State<RegisterFaceView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  String? _image;
  FaceFeatures? _faceFeatures;

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Register User"),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scaffoldTopGradientClr,
              scaffoldBottomGradientClr,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 0.82.sh,
                width: double.infinity,
                padding:
                    EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0.04.sh),
                decoration: BoxDecoration(
                  color: overlayContainerClr,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.03.sh),
                    topRight: Radius.circular(0.03.sh),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CameraView(
                      onImage: (image) {
                        setState(() {
                          _image = base64Encode(image);
                        });
                      },
                      onInputImage: (inputImage) async {
                        print("before extraction 1");
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(
                              color: accentColor,
                            ),
                          ),
                        );
                        print("before extraction");
                        _faceFeatures = await extractFaceFeatures(
                            inputImage, _faceDetector);
                        setState(() {});
                        print("afterExtraction");
                        print(_faceFeatures);
                        if (mounted) Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    if (_image != null)
                      CustomButton(
                        text: "Start Registering",
                        onTap: () async {
                          print("button pressed");
                          if (_faceFeatures == null) {
                            print("no face");
                          }
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => EnterDetailsView(
                          //       image: _image!,
                          //       faceFeatures: _faceFeatures!,
                          //     ),
                          //   ),
                          // );
                          final StudentAuthService _auth = StudentAuthService();
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(
                                  widget.firstName,
                                  widget.lastName,
                                  widget.email,
                                  widget.password,
                                  _image!,
                                  _faceFeatures!)
                              .whenComplete(() {
                            print("registering");
                            // CustomSnackBar.successSnackBar(
                            //     "Registration Success!");
                            // Future.delayed(const Duration(seconds: 2));
                            Navigator.of(context).pop();
                          });

                          if (result == null) {
                            print("didnt reg");
                          }
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
