import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImageWidget extends StatelessWidget {
  final String svg;
  final double? width;
  final double? size;
  final double? height;
  final bool allowDrawingOutsideViewBox;

  const SvgImageWidget(
    this.svg, {
    Key? key,
    this.size,
    this.width,
    this.height,
    this.allowDrawingOutsideViewBox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      width: size ?? width,
      height: size ?? height,
      fit: BoxFit.contain,
      color: Theme.of(context).colorScheme.primaryContainer,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    );
  }
}
