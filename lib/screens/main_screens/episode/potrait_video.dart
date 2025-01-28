import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zeus/screens/main_screens/episode/player.dart';

class PortraitVideo extends StatelessWidget {
  const PortraitVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.25.sh,
      width: double.infinity,
      color: Colors.black,
      child: Player(isTrailer: false,),
    );
  }
}