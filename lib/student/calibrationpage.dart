import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart';
import 'package:myapp/data/reports.dart';
import 'package:myapp/student/Models/student_user.dart';
import 'package:myapp/student/common/utils/extensions/size_extension.dart';
import 'package:myapp/student/common/utils/extract_face_feature.dart';
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

// // Future<void> main() async {
// //   // WidgetsFlutterBinding.ensureInitialized();

// //   // await Permission.camera.request();
// //   // await Permission.microphone.request();
// //   // runApp(MyApp());

// }

class CalibrationPage extends StatefulWidget {
  CalibrationPage(
      {required this.quizId,
      required this.studentId,
      required this.quizTitle,
      required this.instructorId,
      super.key});
  final String quizId;
  final String? studentId;
  final String? instructorId;
  final String? quizTitle;

  @override
  State<CalibrationPage> createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage>
    with WidgetsBindingObserver {
  late CameraController controller;
  late CameraController controller2;
  String _message = '';
  ScreenshotController screenshotController = ScreenshotController();
  String? downloadUrl;
  int questionNumber = 0;

  late Future<void> initializeControllerFuture;

  bool isCameraInitialized = false;
  bool isCameraInitialized2 = false;

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
  bool notLoading = true;
  int trialNumber = 1;

  File? _image;

  get math => null;

  ///facerec
  ///

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // Notify when the app is minimized
      print("App minimized");

      reportMinimize();

      // You can add any notification logic here
    }

    // if (state == AppLifecycleState.resumed) {
    //   // Notify when the app is minimized
    //   print("App started");
    //   setState(() {
    //     _initializeCamera();
    //   });
    //   showMessage(
    //       context, "Leaving the app will lead to your quiz being cancelled");
    //   // You can add any notification logic here
    //   reportMinimize();
    // }
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    print("initioning camera");
    final cameras = await availableCameras();
    final firstCamera = cameras[0];

    controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    await controller.initialize();

    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> _initializeCamera2() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    print("initioning camera2");
    final cameras = await availableCameras();

    final camera2 = cameras[0];

    controller2 = CameraController(
      camera2,
      ResolutionPreset.medium,
    );

    await controller2.initialize();

    setState(() {
      isCameraInitialized2 = true;
    });
  }

  Future<void> onNewCameraSelected() async {
    setState(() {
      isCameraInitialized = false;
    });
    await Permission.camera.request();
    await Permission.microphone.request();
    final previousCameraController = controller;

    print("ion new  camera");
    final cameras = await availableCameras();

    final camera2 = cameras[1];
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      camera2,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController.dispose();

    // Replace with the new controller

    controller2 = cameraController;

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) {
        setState(() {
          controller2 = cameraController;
        });
      }
    });

    // Initialize controller
    try {
      await controller2.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera new: ');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        //new change  isCameraInitialized = controller2.value.isInitialized;
      });
    }
  }

  Future<void> onBackToOldCamera() async {
    await Permission.camera.request();
    final previousCameraController = controller2;

    print("going to old camera");
    final cameras = await availableCameras();

    final camera2 = cameras[0];
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      camera2,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted)
        setState(() {
          controller = cameraController;
        });
    });

    // Initialize controller
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera old: $e');
    }

    // // Update the Boolean
    if (mounted) {
      setState(() {
        isCameraInitialized = controller.value.isInitialized;
      });
    }
  }

  void showMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> reportMinimize() async {
    print("Reporting Minimize");
    //Uint8List? pic = await screenshotController.capture();
    Uint8List? screenshot = await screenshotController.capture();
    if (screenshot != null) {
      final directory = await getApplicationDocumentsDirectory();
      String fileName =
          'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      File imageFile = File('${directory.path}/$fileName');
      imageFile.writeAsBytesSync(screenshot);

      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('screenshots/$fileName')
          .putFile(imageFile);
      String url = await snapshot.ref.getDownloadURL();
      StudentDatabaseService service =
          StudentDatabaseService(uid: widget.studentId);

      Map<String, String> reportItemMap = {
        "LookAway %": "0",
        "imageUrl": url,
        "message": "Caught Switching Application",
        "timeStamp": DateTime.now().toString(),
      };

      await service.addReportItem(reportItemMap, reportID).then((value) {});

      print('Screenshot uploaded to Firebase Storage. Download URL: $url');
    } else {
      print('Screenshot failed');
    }
  }

  //face authentication
  Future<void> verifyFace(XFile pickedFile) async {
    final path = pickedFile.path;
    bool faceMatched = false;

    print("Verifying face");

    if (path == null) {
      print("path empty faceauth");
    }
    _image = File(path);

    Uint8List imageBytes = _image!.readAsBytesSync();

    await _setImage(imageBytes);

    InputImage inputImage = InputImage.fromFilePath(path);

    _faceFeatures = await extractFaceFeatures(inputImage, _faceDetector).then(
      (result) async {
        print("fetching face and match");
        await FirebaseFirestore.instance
            .collection("Students")
            .where("uid", isEqualTo: widget.studentId)
            .get()
            .catchError((e) {
          print("error ");
        }).then((snap) async {
          if (snap.docs.isNotEmpty) {
            users.clear();
            print(snap.docs.length.toString());
            for (var doc in snap.docs) {
              StudentUserData user = StudentUserData.fromJson(doc.data());
              print(user.faceFeatures!.leftCheek!.x != null
                  ? "usr not null"
                  : " usr null");
              print(
                  result.leftCheek!.x != null ? "valu not null" : "valu null");

              image1.bitmap = user.image;
              image1.imageType = regula.ImageType.PRINTED;

              //Face comparing logic.
              var request = regula.MatchFacesRequest();
              request.images = [image1, image2];
              dynamic value =
                  await regula.FaceSDK.matchFaces(jsonEncode(request));

              var response =
                  regula.MatchFacesResponse.fromJson(json.decode(value));
              dynamic str =
                  await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
                      jsonEncode(response!.results), 0.75);

              var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(
                  json.decode(str));
              setState(() {
                _similarity = split!.matchedFaces.isNotEmpty
                    ? (split.matchedFaces[0]!.similarity! * 100)
                        .toStringAsFixed(2)
                    : "error";
                print("similarity: $_similarity");

                if (_similarity != "error" &&
                    double.parse(_similarity) > 90.00) {
                  faceMatched = true;
                  loggingUser = user;
                } else {
                  faceMatched = false;
                }
              });
              if (faceMatched) {
                print("MATCHED FACe");
              } else {
                print("face not matched");
                Uint8List screenshot = await pickedFile.readAsBytes();
                if (screenshot != null) {
                  final directory = await getApplicationDocumentsDirectory();
                  String fileName =
                      'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
                  File imageFile = File('${directory.path}/$fileName');
                  imageFile.writeAsBytesSync(screenshot);

                  TaskSnapshot snapshot = await FirebaseStorage.instance
                      .ref('screenshots/$fileName')
                      .putFile(imageFile);
                  String url = await snapshot.ref.getDownloadURL();
                  StudentDatabaseService service =
                      StudentDatabaseService(uid: widget.studentId);

                  Map<String, String> reportItemMap = {
                    "imageUrl": url,
                    "message": "Face Not Matched",
                    "timeStamp": DateTime.now().toString(),
                    "LookAway %": "undefined",
                  };

                  await service
                      .addReportItem(reportItemMap, reportID)
                      .then((value) {});

                  print(
                      'Screenshot uploaded to Firebase Storage. Download URL: $url');
                } else {
                  print('Screenshot failed');
                }
              }
            }

            // print(users);

            // //Sorts the users based on the similarity.
            // //More similar face is put first.
            // users.sort((a, b) => (((a.last as double) - 1).abs())
            //     .compareTo(((b.last as double) - 1).abs()));

            // _matchFaces();
          } else {
            print("fil mpty");
          }
        });
      },
    );
  }

  Future<bool> _fetchUsersAndMatchFace() async {
    print("fetching face and match");
    FirebaseFirestore.instance
        .collection("Students")
        .where("uid", isEqualTo: widget.studentId)
        .get()
        .catchError((e) {
      print("Getting User Error: $e");
    }).then((snap) async {
      if (snap.docs.isNotEmpty) {
        users.clear();
        print(snap.docs.length.toString());
        for (var doc in snap.docs) {
          StudentUserData user = StudentUserData.fromJson(doc.data());
          print(user.firstName);
          double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);

          if (similarity >= 0.8 && similarity <= 1.5) {
            users.add([user, similarity]);
          }
        }

        print(users);

        //Sorts the users based on the similarity.
        //More similar face is put first.
        users.sort((a, b) => (((a.last as double) - 1).abs())
            .compareTo(((b.last as double) - 1).abs()));

        return await _matchFaces();
      } else {
        print("fil mpty");
        return (false);
      }
    });
    return (false);
  }

  Future<bool> _matchFaces() async {
    print("matchface called");
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
        print("similarity: $_similarity");

        if (_similarity != "error" && double.parse(_similarity) > 90.00) {
          faceMatched = true;
          loggingUser = user.first;
        } else {
          faceMatched = false;
        }
      });
      if (faceMatched) {
        return (true);
      }
    }
    if (!faceMatched) {
      return (false);
    } else {
      return (true);
    }
  }

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    print("compareface caleed");
    print(face1.leftEar);
    print(face2.rightEar);
    print(
        face1.leftCheek!.x == null ? "usr face1 not null" : " usr face 1 null");
    print(face2.leftCheek!.x == null
        ? "valu face 2 not null"
        : "valu face 2 null");

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

  double euclideanDistance(Points p1, Points p2) {
    final sqr =
        math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }

  Future<void> _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;

    _canAuthenticate = true;
    print(_canAuthenticate);
  }

  Future<void> reportUpload() async {
    print('ReportUpload Called');
    print("Center: $centerCount");
    print("NotCenter: $notCenterCount");

    await onNewCameraSelected().then(
      (value) async {
        print("New Cam selected");

        int total = (centerCount + notCenterCount);

        double notCenterProbability = (notCenterCount / total) * 100;
        XFile pic = await controller2.takePicture();

        await verifyFace(pic);

        if (notCenterProbability > 30) {
          print("not center probabilty in if $notCenterProbability");

          Uint8List screenshot = await pic.readAsBytes();
          if (screenshot != null) {
            final directory = await getApplicationDocumentsDirectory();
            String fileName =
                'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
            File imageFile = File('${directory.path}/$fileName');
            imageFile.writeAsBytesSync(screenshot);

            TaskSnapshot snapshot = await FirebaseStorage.instance
                .ref('screenshots/$fileName')
                .putFile(imageFile);
            String url = await snapshot.ref.getDownloadURL();
            StudentDatabaseService service =
                StudentDatabaseService(uid: widget.studentId);

            Map<String, String> reportItemMap = {
              "imageUrl": url,
              "message": "Caught looking away",
              "timeStamp": DateTime.now().toString(),
              "LookAway %": notCenterProbability.toString(),
            };

            await service
                .addReportItem(reportItemMap, reportID)
                .then((value) {});

            print(
                'Screenshot uploaded to Firebase Storage. Download URL: $url');
            centerCount = 0;
            notCenterCount = 0;
          } else {
            print('Screenshot failed');
          }
          await onBackToOldCamera().then(
            (value) {
              print("Old Camera selected");
            },
          );
        } else {
          print("no need to upload cheating not detected enough");
          centerCount = 0;
          notCenterCount = 0;
          await onBackToOldCamera().then(
            (value) {
              print("Old Camera selected");
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          appBar: AppBar(
            title: Text('GazeCloudAPI Example'),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: isCameraInitialized
                          ? Container(
                              height: 350,
                              child: GazeCloudWebView(
                                controller: controller,
                                quizId: widget.quizId,
                                studentId: widget.studentId,
                                quizTitle: widget.quizTitle,
                                instructorId: widget.instructorId,
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //   child: Container(
                  //       height: 200,
                  //       child: CameraView(controller: controller2)),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 4, 15, 16),
                    child: Container(
                      height: 700,
                      child: PlayQuiz(
                        quizId: widget.quizId,
                        studentId: widget.studentId,
                        upload: reportUpload,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PlayQuiz(quizId: quizId, studentId: studentId),
        ),
      ),
    );
  }
}

bool shouldGen = true;

class GazeCloudWebView extends StatefulWidget {
  GazeCloudWebView(
      {required this.quizId,
      required this.studentId,
      required this.quizTitle,
      required this.instructorId,
      required this.controller,
      super.key});
  final String quizId;
  final String? studentId;
  final String? instructorId;
  final String? quizTitle;
  CameraController controller;

  @override
  _GazeCloudWebViewState createState() => _GazeCloudWebViewState();
}

class _GazeCloudWebViewState extends State<GazeCloudWebView> {
  ChromeSafariBrowser browser = new ChromeSafariBrowser();
  String _message = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldGen) {
        _asyncMethod();
      }
    });
    //_asyncMethod();
  }

  Future<String?> _asyncMethod() async {
    shouldGen = false;
    StudentDatabaseService sds = StudentDatabaseService(uid: widget.studentId);

    String? instructorId = widget.instructorId;

    Map<String, String?> quizMap = {
      "instructorId": instructorId,
      "studentId": widget.studentId,
      "quizTitle": widget.quizTitle,
      "quizId": widget.quizId,
      "totalMarks": "0",
      "obtainedMarks": "0"
    };

    dynamic result = await sds.addReportData(quizMap);

    if (result != null) {}
    reportID = result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GazeCloudAPI WebViewSSSSS'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                  onConsoleMessage: (controller, consoleMessage) async {
                    int count = 0;
                    // Handle console messages from JavaScript

                    //print('Console message: ${consoleMessage.message}');
                    setState(() {
                      _message = consoleMessage.message;

                      //when calibration completes we will move to new quiz
                    });

                    if (_message == 'Center') {
                      centerCount++;
                    } else {
                      notCenterCount++;
                    }

                    ///
                    ///values from api
                  },
                  initialFile: 'assets/gaze.html',
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      userAgent:
                          'Mozilla/5.0', // Use a user agent string compatible with GazeCloudAPI's requirements
                      mediaPlaybackRequiresUserGesture:
                          false, // Ensure media playback is not blocked
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    // Here you can control the web view
                  },
                  onLoadStop: (controller, url) {
                    // WebView has loaded the page
                  },
                  onLoadError: (controller, url, code, message) {
                    // Handle any errors loading the web page
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  }),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "Gaze Direction: $_message",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMessageDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GazeCloudAPI Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CameraView extends StatefulWidget {
  CameraView({required this.controller});
  @override
  State<CameraView> createState() => _CameraViewState();
  CameraController controller;
}

class _CameraViewState extends State<CameraView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: true
          ? CameraPreview(widget.controller)
          : Center(child: CircularProgressIndicator()),
    );
  }
}


// class CameraView extends StatelessWidget<CameraView> {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras[1];

//     _controller = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );

//     _initializeControllerFuture = _controller!.initialize().then((_) {
//       () {
//         _isCameraInitialized = true;
//       };
//     });
//   }

//   Future<String> _startImageCaptureCondition() {
//     return _captureAndUploadImage();
//   }

//   Future<String> _captureAndUploadImage() async {
//     try {
//       print("in cap and up");
//       final directory = await getTemporaryDirectory();
//       final imagePath = path.join(directory.path, '${DateTime.now()}.png');
//       await _controller!.takePicture();
//       String downUrl = await _uploadToFirebase(File(imagePath));
//       return downUrl;
//     } catch (e) {
//       print(e);
//       return "cant cap and up";
//     }
//   }

//   Future<String> _uploadToFirebase(File imageFile) async {
//     try {
//       print("in upload");
//       final storageRef = FirebaseStorage.instance.ref();
//       final imagesRef =
//           storageRef.child('images/${path.basename(imageFile.path)}');
//       final uploadTask = await imagesRef.putFile(imageFile);

//       final downloadURL = await imagesRef.getDownloadURL();

//       print('Upload complete and URL stored in Firestore');
//       return downloadURL;
//     } catch (e) {
//       print(e);
//       return "cant upload";
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera View'),
//       ),
//       body: _isCameraInitialized
//           ? CameraPreview(_controller!)
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
