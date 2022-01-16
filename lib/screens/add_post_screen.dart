import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saaligram/model/user_model.dart';
import 'package:saaligram/resources/auth_methods.dart';
import 'package:saaligram/resources/firestore_method.dart';
import 'package:saaligram/utils/colors.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/utils/utilities.dart';
import 'package:saaligram/widgets/custom_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _image;
  TextEditingController captionController = TextEditingController();
  User? user;
  bool isLoading = false;
  bool readOnly = false;

  void getUserDetail() async {
    user = await AuthMethods().getUserDetails();
  }

  Future _selectImage() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              MediaQuery.of(context).size.width > webScreenSize
                  ? const Padding(padding: EdgeInsets.zero)
                  : SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context);
                        Uint8List image = await pickImage(ImageSource.camera);
                        setState(() {
                          _image = image;
                        });
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.camera),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);

                  Uint8List image = await pickImage(ImageSource.gallery);
                  setState(() {
                    _image = image;
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.photo),
                    SizedBox(
                      width: 10,
                    ),
                    kIsWeb ? Text("Select from computer") : Text("Gallery")
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Row(
                  children: const [
                    Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Cancel")
                  ],
                ),
              ),
            ],
          );
        });
  }

  buildUploadScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset('assets/images/upload_image.svg',
              height: MediaQuery.of(context).size.height * 0.4),
        ),
        CustomButton(
          child: const Text("Add Photo"),
          onPressed: () async {
            await _selectImage();
          },
        ),
      ],
    );
  }

  postImage(String uid, String username, String profileImage) async {
    try {
      setState(() {
        readOnly = true;
        isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          _image!, captionController.text, uid, username, profileImage);
      setState(() {
        isLoading = false;
      });
      if (res == "success") {
        successSnackbar(context: context, value: "Post Successful");
        clearImage();
        readOnly = false;
        captionController.text = "";
      } else {
        errorSnackbar(context: context, value: res);
      }
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  void clearImage() {
    _image = null;
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? buildUploadScreen(context)
        : Padding(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .25)
                : EdgeInsets.zero,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "New Post",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      clearImage();
                      captionController.text = "";
                    });
                  },
                ),
                actions: [
                  isLoading
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: () => postImage(
                              user!.uid, user!.username, user!.photoUrl),
                          icon: const Icon(
                            Icons.check,
                            size: 30,
                          ))
                ],
              ),
              body: Column(
                children: [
                  isLoading
                      ? const LinearProgressIndicator(
                          backgroundColor: primaryColor,
                          color: Colors.white,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            height: 55,
                            width: 55,
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: MemoryImage(_image!),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 65,
                            child: TextField(
                              readOnly: readOnly,
                              controller: captionController,
                              maxLines: 8,
                              decoration: const InputDecoration(
                                  hintText: "Write a caption...",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ]),
                  const Divider(
                    thickness: 0.6,
                  ),
                ],
              ),
            ),
          );
  }
}
