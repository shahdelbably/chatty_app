import 'dart:io';

import 'package:chatty/helper/asset_data.dart';
import 'package:chatty/helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePicker extends StatefulWidget {
  final Function(File) onImageSelected;

  const ProfilePicturePicker({super.key, required this.onImageSelected});

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      widget.onImageSelected(imageFile!);
    }
  }

  ImageProvider getImageProvider() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    } else {
      return const AssetImage(AssetData.placeholder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 85,
          backgroundImage: getImageProvider(),

          backgroundColor: greyColor,
        ),
        Positioned(
          bottom: 7,
          child: GestureDetector(
            onTap: _pickImage,
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor,
              child: Icon(Icons.edit, color: whiteColor, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
