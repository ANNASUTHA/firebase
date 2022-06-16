import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Widgets/button.dart';
import '../Widgets/custom_shape.dart';
import '../Widgets/responsive_ui.dart';
import '../Widgets/textfield.dart';
import '../helper/shared_preference_helper.dart';
import 'directory_screen.dart';
import 'homepage.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'SignInScreen';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}



class _SignInScreenState extends State<SignInScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isHidden = true;
  bool showSpinner = false;
  final bool _isLoading = false;
  late String _email, _password;
  late String email;
  final _auth = FirebaseAuth.instance;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  late bool large;
  late bool checkAdminMail = false;
  late String checkAdminMailValue = "";
  late bool medium;
  late int _isSelected;
  late bool _isLoggedIn = false;
  //late SharedPreferen 1ces localStorage;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  final List<String> imagesList = [];

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await storage.ref('advertisement/').list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      // final FullMetadata fileMeta = await file.getMetadata();

      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        // "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? '',
        // "description": fileMeta.customMetadata?['description'] ?? ''
      });
    });
    for (int i = 0; i < files.length; i++) {
      if (mounted) {
        // setState(() {
          imagesList.add(files[i]["url"]);
        // });
      }
    }
    /*print(imagesList);*/
    return files;
  }

  @override
  void initState() {
    _loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _loadImages();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: const EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              clipShape(),
              /*toggleButton(),*/
              // const SizedBox(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              /* forgetPassTextRow(),*/
              SizedBox(height: _height / 40),
              loginButton(),
              //directoryButton(),
              signUpTextRow(),
              //carousel(),
            ],
          ),
        ),
      ),
    );
  }

  /*Widget toggleButton(){
    return ToggleSwitch(
      minWidth: 180.0,
      cornerRadius: 20.0,
      activeBgColors: const [ [Colors.orange], [Colors.pinkAccent]],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      initialLabelIndex: 0,
      totalSwitches: 2,
      labels: const ['Admin', 'User'],
      radiusStyle: true,
      onToggle: (index) {
        _isSelected = index;
        print('switched to: $index');
      },
    );
 }*/
  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large ? _height / 4 : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    // colors: [Colors.orange, Colors.pinkAccent],
                    colors: [Color(0xff0097D7), Color(0xff3A67B1)]),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large ? _height / 4.5 : (_medium ? _height / 4.25 : _height / 4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    // colors: [Colors.orange, Colors.pinkAccent],
                    colors: [Color(0xff0097D7), Color(0xff3A67B1)]),
              ),
            ),
          ),
        ),
        // Container(
        //   alignment: Alignment.bottomCenter,
        //   margin: EdgeInsets.only(top: _large ? _height / 30 : (_medium ? _height / 25 : _height / 20)),
        //   child: Image.asset(
        //     'assets/images/login.png',
        //     height: _height / 3.5,
        //     width: _width / 3.5,
        //   ),
        // ),
        Center(
          child: Container(
            alignment: Alignment.bottomCenter,
            // margin: EdgeInsets.only(top: _large ? _height / 30 : (_medium ? _height / 25 : _height / 20)),
            margin: EdgeInsets.only(top: _height / 8, bottom: _height / 25),
            width: _width / 4,
            height: _height / 8,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/app_icon.jpg',
                  ),
                ),
                borderRadius: BorderRadius.circular(16)),
            // child: Image.asset(
            //   'assets/images/app_icon.jpg',
            //   // height: _height / 3.5,
            //   // width: _width / 3.5,
            // ),
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: 16),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: _large ? 45 : (_medium ? 50 : 40),
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: 16, bottom: 16),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      // margin: EdgeInsets.only(left: _width / 12.0, right: _width / 12.0, top: _height / 40.0),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            SimpleTextField(
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textEditingController: _emailController,
              onChanged: (value) {
                _email = value;
              },
              textInputAction: TextInputAction.next,
            ),
            // TextFormField(
            //   keyboardType: TextInputType.emailAddress,
            //   focusNode: _emailFocusNode,
            //   controller: _emailController,
            //   textInputAction: TextInputAction.next,
            //   onChanged: (value) {
            //     _email = value;
            //   },
            //   decoration: InputDecoration(
            //     prefixIcon: const Icon(
            //       Icons.alternate_email_outlined,
            //       color: Constant.primaryColor,
            //     ),
            //     hintText: 'Email',
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
            //   ),
            // ),
            SizedBox(height: _height / 50),
            //passwordTextFormField(),
            SimpleTextField(
              labelText: 'Password',
              keyboardType: TextInputType.visiblePassword,
              textEditingController: _passController,
              onChanged: (value) {
                _password = value;
              },
              isPasswordField: true,
              textInputAction: TextInputAction.done,
            ),
            // TextFormField(
            //   keyboardType: TextInputType.text,
            //   focusNode: _passwordFocusNode,
            //   controller: _passController,
            //   textInputAction: TextInputAction.done,
            //   obscureText: _isHidden,
            //   onChanged: (value) {
            //     _password = value;
            //   },
            //   decoration: InputDecoration(
            //     hintText: 'Password',
            //     prefixIcon: const Icon(
            //       Icons.lock,
            //       color: Constant.primaryColor,
            //     ),
            //     suffix: InkWell(
            //       onTap: _togglePasswordView,
            //       child: Icon(_isHidden ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Constant.primaryColor),
            //     ),
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          )
        ],
      ),
    );
  }

  Future getAdmin() async {
    try {
      String Value;
      await FirebaseFirestore.instance.collection('users').doc(_emailController.text).get().then((value) => {
            Value = value["Email"].toString(),
            print("logfin"),
            print(Value),
            setState(() {
              try {
                _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passController.text);

                SharedPreferenceHelper.saveUserLoggedIn(true);
                SharedPreferenceHelper.saveUserEmail(_emailController.text);
                SharedPreferenceHelper.saveUserType("User");
                SharedPreferenceHelper.saveUserTypeData(true);
                Navigator.pushReplacementNamed(context, NewApp.id);
              } catch (e) {
                Fluttertoast.showToast(
                    msg: "You are not a user: ",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white);
                print(e.toString());
              }
            }),
            print("userValue ---- $Value")
          });
    } catch (e) {
      print(e);
      try {
        await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passController.text);
        SharedPreferenceHelper.saveUserLoggedIn(true);
        SharedPreferenceHelper.saveUserEmail(_emailController.text);
        SharedPreferenceHelper.saveUserType("Admin");
        SharedPreferenceHelper.saveUserTypeData(false);
        Navigator.pushReplacementNamed(
          context,
          NewApp.id,
        );
      } catch (e) {
        Fluttertoast.showToast(
            msg: "You are not a user: ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
        print(e.toString());
      }
    }
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PositiveButton(
        title: 'Login',
        onPressed: () {
          getAdmin();
        },
      ),
    );
  }



  Widget carouselOld() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          aspectRatio: 1.6,
        ),
        items: imagesList
            .map(
              (item) => Center(
                child: Image.network(
                  item,
                  fit: BoxFit.fitWidth,
                  height: 260,
                ),
              ),
            )
            .toList(),
      )),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 140.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SignUpScreen.id);
            },
            child: Text(
              "Register",
              style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xff0097D7), fontSize: 16),
            ),
          )
        ],
      ),
    );
  }


}
