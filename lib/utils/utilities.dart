import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saaligram/utils/colors.dart';

bool isKeyboardShowing() {
  if (WidgetsBinding.instance != null) {
    return (WidgetsBinding.instance!.window.viewInsets.bottom > 0);
  } else {
    return false;
  }
}

closeKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

pickImage(ImageSource source) async {
  ImagePicker _pickImage = ImagePicker();
  var file = await _pickImage.pickImage(source: source);
  if (file != null) {
    if (kIsWeb) {
      return await file.readAsBytes();
    } else {
      Uint8List xfile = await _cropImage(file);
      return xfile;
    }
  }
  Fluttertoast.showToast(msg: "No Image selected");
}

_cropImage(XFile file) async {
  var cropImage = await ImageCropper.cropImage(
      sourcePath: file.path,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio16x9
      ],
      compressQuality: 50,
      androidUiSettings: const AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: primaryColor,
          toolbarWidgetColor: white,
          activeControlsWidgetColor: secondaryColor,
          initAspectRatio: CropAspectRatioPreset.square,
          showCropGrid: false));

  if (cropImage != null) {
    return cropImage.readAsBytes();
  }
  Fluttertoast.showToast(msg: "No Image Selected");
}

void errorSnackbar({required BuildContext context, required String value}) {
  SnackBar snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.error_outline_rounded,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(value)
      ],
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void successSnackbar({required BuildContext context, required String value}) {
  SnackBar snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.check,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(value)
      ],
    ),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
