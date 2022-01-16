import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saaligram/resources/auth_methods.dart';
import 'package:saaligram/responsive/mobile_screen_layout.dart';
import 'package:saaligram/responsive/responsive_layout.dart';
import 'package:saaligram/responsive/web_screen_layout.dart';
import 'package:saaligram/utils/colors.dart';
import 'package:saaligram/utils/global_variable.dart';
import 'package:saaligram/utils/utilities.dart';
import 'package:saaligram/widgets/custom_button.dart';
import 'package:saaligram/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List? avtarImageFile;
  bool isLogin = true;
  bool isLoading = false;
  bool isGoogleLoading = false;
  Future getImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);

    setState(() {
      avtarImageFile = image;
    });
  }

  openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Exit App",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Are you sure, You want to exit?",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 0);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                        Text(
                          "Cancel",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        Text(
                          "Yes",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  void downKeyboard() {
    if (isKeyboardShowing()) {
      closeKeyboard(context);
    }
  }

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods()
        .loginUser(emailController.text, passwordController.text);
    setState(() {
      isLoading = false;
    });
    if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      errorSnackbar(context: context, value: res.toString());
    }
  }

  handleGoogleLogin() async {
    setState(() {
      isGoogleLoading = true;
    });
    String res = await AuthMethods().handleSignIn();
    setState(() {
      isGoogleLoading = false;
    });
    if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: res.toString());
    }
  }

  handleSignUp() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        usernameController.text,
        bioController.text,
        emailController.text,
        passwordController.text,
        avtarImageFile);
    if (res == "success") {
      successSnackbar(
          context: context, value: "Account registered successfully.");
    } else {
      errorSnackbar(context: context, value: res.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => downKeyboard(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: onBackPress,
          child: Scaffold(
            body: Center(
              child: MediaQuery.of(context).size.width > webScreenSize
                  ? webDesignWidget()
                  : SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 1000),
                        child: isLogin ? loginWidget() : signUpWidget(),
                        transitionBuilder: (child, animation) => SizeTransition(
                          sizeFactor: animation,
                          child: child,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget webDesignWidget() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/connect_world.svg",
                    width: MediaQuery.of(context).size.width * .35,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "The last Social Network on internet.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text.rich(TextSpan(text: "This ", children: [
                    TextSpan(
                      text: "saaligram ",
                      style: TextStyle(
                          fontFamily: "signatra",
                          letterSpacing: 1,
                          fontSize: 18),
                    ),
                    TextSpan(text: "app provides you nothing but happiness.")
                  ])),
                  const Text("Thank you for giving your valuable time."),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: isLogin ? loginWidget() : signUpWidget(),
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      alignment: Alignment.center,
      key: const Key("login"),
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
            child: Column(
              children: [
                CustomTextField(
                    prefixIcon: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    label: "Email",
                    isPass: false),
                CustomTextFieldPassword(
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    hintText: "*******",
                    label: "Password"),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                    onPressed: handleLogin,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("SignIn")),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(text: "Don't have an account? ", children: [
                    TextSpan(
                      text: "SignUp",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      thickness: 0.7,
                    )),
                    Text(" or signIn with "),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                loginProvider(
                  icon: isGoogleLoading
                      ? const CircularProgressIndicator(
                          color: white,
                        )
                      : const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                          size: 35,
                        ),
                  context: context,
                  onPressed: () => handleGoogleLogin(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpWidget() {
    return Container(
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
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                      onTap: getImage,
                      child: avtarImageFile == null
                          ? CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 45,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 60,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 50,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).cardColor,
                                radius: 47,
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: MemoryImage(avtarImageFile!),
                                ),
                              ),
                            )),
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
                CustomTextFieldPassword(
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    hintText: "*******",
                    label: "Password"),
                CustomButton(
                    onPressed: handleSignUp,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("SignUp")),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(text: "Already have an account?  ", children: [
                    TextSpan(
                      text: "SignIn",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      thickness: 0.7,
                    )),
                    Text(" or signIn with "),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                loginProvider(
                  icon: isGoogleLoading
                      ? const CircularProgressIndicator(
                          color: white,
                        )
                      : const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                          size: 35,
                        ),
                  context: context,
                  onPressed: () => handleGoogleLogin(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container loginProvider(
      {required BuildContext context,
      required Widget icon,
      required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 3),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: secondaryColor),
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: icon,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
