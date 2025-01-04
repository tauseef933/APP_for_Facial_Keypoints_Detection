import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/authenticate_face/scanning_animation/animated_view.dart';
import 'package:myapp/student/common/utils/extensions/size_extension.dart';
import 'package:myapp/student/common/utils/extract_face_feature.dart';
import 'package:myapp/student/common/views/camera_view.dart';
import 'package:myapp/student/common/views/custom_button.dart';
import 'package:myapp/student/constants/theme.dart';
import 'package:myapp/student/play_quiz.dart';
import 'package:myapp/student/student_services/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:screenshot/screenshot.dart';
import 'package:flutter_face_api/face_api.dart' as regula;

class AuthenticateUser extends StatefulWidget {
  const AuthenticateUser({required this.name, required this.password, Key? key})
      : super(key: key);

  final String name;
  final String password;

  @override
  State<AuthenticateUser> createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;
  var image1 = regula.MatchFacesImage();
  var image2 = regula.MatchFacesImage();

  //final TextEditingController _nameController = TextEditingController();
  String _similarity = "";
  bool _canAuthenticate = false;
  List<dynamic> users = [];
  bool userExists = false;
  StudentUserData? loggingUser;
  bool isMatching = false;
  int trialNumber = 1;

  get math => null;

  @override
  void dispose() {
    _faceDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  get _playScanningAudio => _audioPlayer
    ..setReleaseMode(ReleaseMode.loop)
    ..play(AssetSource("scan_beep.wav"));

  get _playFailedAudio => _audioPlayer
    ..stop()
    ..setReleaseMode(ReleaseMode.release)
    ..play(AssetSource("failed.mp3"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Authenticate Face"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => Stack(
          children: [
            Container(
              width: constrains.maxWidth,
              height: constrains.maxHeight,
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
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 0.82.sh,
                      width: double.infinity,
                      padding:
                          EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0),
                      decoration: BoxDecoration(
                        color: overlayContainerClr,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.03.sh),
                          topRight: Radius.circular(0.03.sh),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CameraView(
                                onImage: (image) {
                                  _setImage(image);
                                },
                                onInputImage: (inputImage) async {
                                  setState(() => isMatching = true);
                                  _faceFeatures = await extractFaceFeatures(
                                      inputImage, _faceDetector);
                                  setState(() => isMatching = false);
                                },
                              ),
                              if (isMatching)
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.064.sh),
                                    child: const AnimatedView(),
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          if (_canAuthenticate)
                            CustomButton(
                              text: "Authenticate",
                              onTap: () {
                                setState(() => isMatching = true);
                                _playScanningAudio;
                                _fetchUsersAndMatchFace();
                              },
                            ),
                          SizedBox(height: 0.038.sh),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

    double ratioEar = distEar1 / distEar2;

    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 =
        euclideanDistance(face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 =
        euclideanDistance(face2.noseBase!, face2.bottomMouth!);

    double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio =
        (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;

    return ratio;
  }

// A function to calculate the Euclidean distance between two points
  double euclideanDistance(Points p1, Points p2) {
    final sqr =
        math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  _fetchUsersAndMatchFace() {
    FirebaseFirestore.instance
        .collection("Students")
        .where("name", isEqualTo: widget.name)
        .get()
        .catchError((e) {
      setState(() => isMatching = false);
      _playFailedAudio;
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();

        for (var doc in snap.docs) {
          StudentUserData user = StudentUserData.fromJson(doc.data());
          double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
          if (similarity >= 0.8 && similarity <= 1.5) {
            users.add([user, similarity]);
          }
        }

        setState(() {
          //Sorts the users based on the similarity.
          //More similar face is put first.
          users.sort((a, b) => (((a.last as double) - 1).abs())
              .compareTo(((b.last as double) - 1).abs()));
        });

        _matchFaces();
      } else {
        _showFailureDialog(
          title: "No Users Registered",
          description:
              "Make sure users are registered first before Authenticating.",
        );
      }
    });
  }

  _matchFaces() async {
    bool faceMatched = false;
    for (List user in users) {
      image1.bitmap = (user.first as StudentUserData).image;
      image1.imageType = regula.ImageType.PRINTED;

      //Face comparing logic.
      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = regula.MatchFacesResponse.fromJson(json.decode(value));
      dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);

      var split =
          regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
      setState(() {
        _similarity = split!.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
            : "error";

        if (_similarity != "error" && double.parse(_similarity) > 90.00) {
          faceMatched = true;
          loggingUser = user.first;
        } else {
          faceMatched = false;
        }
      });
      if (faceMatched) {
        _audioPlayer
          ..stop()
          ..setReleaseMode(ReleaseMode.release)
          ..play(AssetSource("success.mp3"));

        setState(() {
          trialNumber = 1;
          isMatching = false;
        });

        if (mounted) {}
        break;
      }
    }
    if (!faceMatched) {
      if (trialNumber == 4) {
        setState(() => trialNumber = 1);
        _showFailureDialog(
          title: "Redeem Failed",
          description: "Face doesn't match. Please try again.",
        );
      } else {
        setState(() => trialNumber++);
        _showFailureDialog(
          title: "Redeem Failed",
          description: "Face doesn't match. Please try again.",
        );
      }
    }
  }

  _fetchUserByName(String orgID) {
    FirebaseFirestore.instance
        .collection("users")
        .where("organizationId", isEqualTo: orgID)
        .get()
        .catchError((e) {
      setState(() => isMatching = false);
      _playFailedAudio;
    }).then((snap) {
      if (snap.docs.isNotEmpty) {
        users.clear();

        for (var doc in snap.docs) {
          setState(() {
            users.add([StudentUserData.fromJson(doc.data()), 1]);
          });
        }
        _matchFaces();
      } else {
        setState(() => trialNumber = 1);
        _showFailureDialog(
          title: "User Not Found",
          description:
              "User is not registered yet. Register first to authenticate.",
        );
      }
    });
  }

  _showFailureDialog({
    required String title,
    required String description,
  }) {
    _playFailedAudio;
    setState(() => isMatching = false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  color: accentColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
