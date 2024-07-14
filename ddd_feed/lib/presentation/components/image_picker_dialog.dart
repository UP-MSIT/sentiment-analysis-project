import 'dart:io';

import 'package:ddd_feed/presentation/components/svg_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// describe:
class ImagePickerDialog extends StatefulWidget {
  final ValueChanged<File>? callBack;

  const ImagePickerDialog({Key? key, this.callBack}) : super(key: key);

  @override
  ImagePickerDialogState createState() => ImagePickerDialogState();
}

class ImagePickerDialogState extends State<ImagePickerDialog> {
  final _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        _buildItem('assets/images/ic_picker_camera.svg', 'Take photo', onTap: () {
          Navigator.pop(context);
          getImage(source: ImageSource.camera);
        }),
        const Divider(color: Color(0xffb0b0b0)),
        _buildItem('assets/images/ic_picker_gallery.svg', 'Galley', width: 20, onTap: () {
          Navigator.pop(context);
          getImage();
        }),
        const Divider(color: Color(0xffb0b0b0)),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildItem(String icon, String title, {double? width, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            SvgImageWidget(icon, size: width ?? 24),
            const SizedBox(
              width: 32,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getImage({ImageSource source = ImageSource.gallery}) async {
    final pickedFile = await _picker.pickImage(source: source);
    _image = File(pickedFile?.path ?? '');
    widget.callBack?.call(_image!);
  }
}
