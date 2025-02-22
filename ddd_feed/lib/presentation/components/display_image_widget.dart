import 'dart:io';

import 'package:ddd_feed/presentation/res/colors/colors.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;

  // Constructor
  const DisplayImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryContainer;

    return Center(
      child: Stack(
        children: [
          buildImage(color),
          Positioned(
            right: 4,
            top: 10,
            child: buildEditIcon(color),
          )
        ],
      ),
    );
  }

  // Builds Profile Image
  Widget buildImage(Color color) {
    final image = imagePath.contains('https://') ? NetworkImage(imagePath) : FileImage(File(imagePath));

    return CircleAvatar(
      radius: 75,
      backgroundColor: color,
      child: CircleAvatar(backgroundImage: image as ImageProvider, radius: 70),
    );
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(Color color) => buildCircle(all: 8, child: Icon(Icons.edit, color: color, size: 20));

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({required Widget child, required double all}) => ClipOval(child: Container(padding: EdgeInsets.all(all), color: Colors.white, child: child));
}
