import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saaligram/resources/auth_methods.dart';
import 'package:saaligram/utils/colors.dart';
import 'package:saaligram/utils/firestore_constant.dart';
import 'package:saaligram/utils/utilities.dart';
import 'package:saaligram/widgets/custom_button.dart';
import 'package:saaligram/widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  Uint8List? avtarImageFile;
  String? photoUrl;

  void updateprofile(
      String username, String bio, String email, Uint8List? file) async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().updateUser(username, bio, email, file);
    if (res == "success") {
      Fluttertoast.showToast(msg: "Profile updated");
      Navigator.pop(context, true);
    }
  }

  Future getImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      avtarImageFile = image;
    });
  }

  @override
  void initState() {
    super.initState();
    photoUrl = widget.user[FirestoreConstants.photoUrl];
    usernameController.text = widget.user[FirestoreConstants.username];
    bioController.text = widget.user[FirestoreConstants.bio];
    emailController.text = widget.user[FirestoreConstants.email];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.center,
          key: const Key("SignUp"),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Saaligram",
                  style: TextStyle(
                      fontSize: 50, fontFamily: "signatra", letterSpacing: 2.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: backgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          color: secondaryColor,
                          offset: Offset(0, 5),
                          blurRadius: 10,
                          spreadRadius: 2.0,
                        )
                      ]),
                  child: Column(children: [
                    CupertinoButton(
                      onPressed: getImage,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: getImage,
                            child: avtarImageFile == null
                                ? photoUrl!.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle),
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: white,
                                              shape: BoxShape.circle),
                                          padding: const EdgeInsets.all(3),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Stack(children: [
                                              Image.network(photoUrl!,
                                                  fit: BoxFit.cover,
                                                  width: 100,
                                                  height: 100, errorBuilder:
                                                      (context, error,
                                                          stackTrace) {
                                                return const Icon(
                                                  Icons.account_circle,
                                                  color: primaryColor,
                                                  size: 100,
                                                );
                                              }, loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null &&
                                                                loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null),
                                                  ),
                                                );
                                              }),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                    height: 25,
                                                    width: 100,
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                    child: const Icon(
                                                      Icons.add_a_photo,
                                                      color: Colors.white70,
                                                    )),
                                              )
                                            ]),
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.account_circle,
                                        color: primaryColor,
                                        size: 100,
                                      )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: white, shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(3),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Stack(children: [
                                          Image.memory(avtarImageFile!,
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100),
                                          Positioned(
                                            bottom: 0,
                                            child: Container(
                                                height: 25,
                                                width: 100,
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                child: const Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.white70,
                                                )),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    CustomTextField(
                        prefixIcon: Icons.person,
                        controller: usernameController,
                        hintText: "Username",
                        label: "username",
                        isPass: false),
                    CustomTextField(
                        prefixIcon: Icons.note_alt_sharp,
                        controller: bioController,
                        hintText: "Bio",
                        label: "Bio",
                        isPass: false),
                    CustomTextField(
                        prefixIcon: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        label: "Email",
                        isPass: false),
                    CustomButton(
                        onPressed: () => updateprofile(
                            usernameController.text,
                            bioController.text,
                            emailController.text,
                            avtarImageFile),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Update Profile")),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                ),
              ]),
        ),
      ),
    );
  }
}
