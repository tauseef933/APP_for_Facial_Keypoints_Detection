import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 110, 21, 110),
      child: const SpinKitDoubleBounce(
        color: Color.fromARGB(255, 116, 35, 255),
        size: 50,
      ),
    );
  }
}
