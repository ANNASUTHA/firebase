import 'dart:io';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../Utils/simple_functions.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Widgets/button.dart';
import '../Widgets/custom_shape.dart';
import '../Widgets/responsive_ui.dart';
import '../Widgets/textfield.dart';
import '../helper/shared_preference_helper.dart';

enum SingingCharacter { Male, Female }

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}



class _SignUpScreenState extends State<SignUpScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  bool checkBoxValue = false;
  late FirebaseMessaging messaging;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String _email, _password, _fullName, _mobileNumber, _confirmPassword, _shopName, _shopAddress, _gender;
  late int _genderValue;
  late String _trainerLevel = "Trainer Level";
  String dropdownValue = 'Male';
  String districtDropDown = 'Choose';
  bool _isHidden = true;
  bool showSpinner = false;
  int? myVar = 1;
  late String _chosenValue;
  final bool _chosenDist = false;

  SingingCharacter? _character = SingingCharacter.Male;
  String _gendernewValue = "Male";
  bool _isTrainerLevelSelected = true;
  final TrainerLevelNotifier _trainerLevelNotifier = TrainerLevelNotifier();
  List<String>? items = <String>[
    'Prov. Zone Trainer',
    'Zone Trainer',
    'Prov. National Trainer',
    'National Trainer',
    'Author Graduate',
  ];
  File? _image;
  List<firebase_storage.UploadTask> _uploadTasks = [];

  /* int _radioSelected = 1;
  String? _radioVal;*/
  /* bool _value = false;
  int val = -1;*/

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: const EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // const Opacity(opacity: 0.88,child: CustomAppBar()),
                clipShape(),
                /*SizedBox(height: _height/20,),*/
                form(),
                //SingleChildScrollView(child: Container(child: form())),
                acceptTermsTextRow(),
                SizedBox(
                  height: _height / 200,
                ),
                button(),
                //infoTextRow(),
                //socialIconsRow(),
                signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: height * .2 /*_large? _height/4 : (_medium? _height/3 : _height/3.5)*/,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // colors: [Colors.orange, Colors.pinkAccent],
                  colors: [Color(0xff0097D7), Color(0xff3A67B1)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: height * .2 /*_large? _height/4.5 : (_medium? _height/4.25 : _height/4)*/,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // colors: [Colors.orange, Colors.pinkAccent],
                  colors: [Color(0xff0097D7), Color(0xff3A67B1)],
                ),
              ),
            ),
          ),
        ),
        _setProfilePic(),
      ],
    );
  }

  Widget form() {
    return Container(
      // margin: EdgeInsets.only(left: _width / 15.0, right: _width / 15.0, top: _height / 300.0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: <Widget>[
            SimpleTextField(
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textEditingController: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                  return 'Please enter a valid Email';
                }
                return null;
              },
              onChanged: (value) {
                _email = value;
              },
              textInputAction: TextInputAction.next,
            ),
            // TextFormField(
            //   keyboardType: TextInputType.emailAddress,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   focusNode: _emailFocusNode,
            //   controller: emailController,
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return 'Please enter an email';
            //     }
            //     if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
            //       return 'Please enter a valid Email';
            //     }
            //     return null;
            //   },
            //   //validator: (val) => formFieldValidator(val, type: formFieldType.email),
            //   textInputAction: TextInputAction.next,
            //   onChanged: (value) {
            //     _email = value;
            //   },
            //   decoration: InputDecoration(
            //     prefixIcon: const Icon(
            //       Icons.alternate_email,
            //       color: Constant.primaryColor,
            //     ),
            //     hintText: 'Email',
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
            //   ),
            // ),
            SizedBox(height: _height / 100.0),
            SimpleTextField(
              labelText: 'Full Name',
              keyboardType: TextInputType.name,
              // textEditingController: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Name should not be empty';
                } else {
                  return null;
                }
              },
              // validator: (value) {
              //   if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
              //     //allow upper and lower case alphabets and space
              //     return "Enter Correct Name";
              //   } else {
              //     return null;
              //   }
              // },
              onChanged: (value) {
                _fullName = value;
              },
              textInputAction: TextInputAction.next,
            ),
            // TextFormField(
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   validator: (value) {
            //     if (value!.isEmpty || !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
            //       //allow upper and lower case alphabets and space
            //       return "Enter Correct Name";
            //     } else {
            //       return null;
            //     }
            //   },
            //   onChanged: (value) {
            //     _fullName = value;
            //   },
            //   decoration: InputDecoration(
            //     prefixIcon: const Icon(
            //       Icons.person,
            //       color: Constant.primaryColor,
            //     ),
            //     hintText: 'Full Name',
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
            //   ),
            // ),
            SizedBox(height: _height / 100.0),
            _phoneNumberField(),
            SizedBox(height: _height / 100.0),
            _genderView(),
            SizedBox(height: _height / 100.0),
            _passwordField(),
            SizedBox(height: _height / 100.0),
            _confirmPasswordField(),

            SizedBox(height: _height / 100.0),
            _addressField(),
            SizedBox(height: _height / 100.0),
            _trainerLevelDropDown(),
            SizedBox(height: _height / 100.0),
            _preferredTopicsField(),
          ],
        ),
      ),
    );
  }

  Column _trainerLevelDropDown() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // const Padding(
            //   padding: EdgeInsets.only(right: 16),
            //   child: Icon(
            //     Icons.location_on,
            //     color: Constant.primaryColor,
            //   ),
            // ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                underline: SizedBox(),
                isExpanded: true,
                hint: _trainerLevel == ""
                    ? const Text("Select")
                    : Text(
                        _trainerLevel,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Colors.grey.shade500,
                            ),
                      ),
                onChanged: (newValue) {
                  _trainerLevelNotifier.trainerLevelNotifier(false);
                  setState(() {
                    _trainerLevel = newValue!;
                    districtDropDown = newValue;
                  });
                },
                items: items?.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _trainerLevelNotifier.valueNotifier,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: Container(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Trainer Level must not be empty',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _addressField() {
    return SimpleTextField(
      labelText: 'Address',
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          //allow upper and lower case alphabets and space
          return "Enter the Address";
        } else {
          return null;
        }
      },
      onChanged: (value) {
        _shopAddress = value;
      },
      textInputAction: TextInputAction.next,
    );
    // return TextFormField(
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   validator: (value) {
    //     if (value!.isEmpty) {
    //       //allow upper and lower case alphabets and space
    //       return "Enter the Address";
    //     } else {
    //       return null;
    //     }
    //   },
    //   onChanged: (value) {
    //     _shopAddress = value;
    //   },
    //   decoration: InputDecoration(
    //     prefixIcon: const Icon(
    //       Icons.add_location_rounded,
    //       color: Constant.primaryColor,
    //     ),
    //     hintText: 'Address',
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
    //   ),
    // );
  }

  Widget _preferredTopicsField() {
    return SimpleTextField(
      labelText: 'Preferred Topics',
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          //allow upper and lower case alphabets and space
          return "Enter the Preferred Topics";
        } else {
          return null;
        }
      },
      onChanged: (value) {
        _shopName = value;
      },
      maxLines: 4,
      textInputAction: TextInputAction.newline,
    );
    // return TextFormField(
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   validator: (value) {
    //     if (value!.isEmpty) {
    //       //allow upper and lower case alphabets and space
    //       return "Enter the Preferred Topics";
    //     } else {
    //       return null;
    //     }
    //   },
    //   onChanged: (value) {
    //     _shopName = value;
    //   },
    //   decoration: InputDecoration(
    //     prefixIcon: const Icon(
    //       Icons.drive_file_rename_outline,
    //       color: Constant.primaryColor,
    //     ),
    //     hintText: 'Preferred Topics',
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
    //   ),
    //   maxLines: null,
    // );
  }

  Widget _confirmPasswordField() {
    return SimpleTextField(
      labelText: 'Confirm Password',
      keyboardType: TextInputType.visiblePassword,
      isPasswordField: true,
      textEditingController: confirmPasswordController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please re-enter password';
        }
        print(passwordController.text);
        print(confirmPasswordController.text);
        if (passwordController.text != confirmPasswordController.text) {
          return "Password does not match";
        }
        return null;
      },
      onChanged: (value) {
        _confirmPassword = value;
      },
      textInputAction: TextInputAction.next,
    );
    // return TextFormField(
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   controller: confirmPasswordController,
    //   validator: (value) {
    //     if (value!.isEmpty) {
    //       return 'Please re-enter password';
    //     }
    //     print(passwordController.text);
    //     print(confirmPasswordController.text);
    //     if (passwordController.text != confirmPasswordController.text) {
    //       return "Password does not match";
    //     }
    //     return null;
    //   },
    //   /*validator: (val) {
    //           formFieldValidator(val,
    //               type: formFieldType.password,
    //               confirmPass: passwordController.text);
    //           if(val!.isEmpty) {
    //             return 'Empty';
    //           }
    //           if(val != passwordController.text) {
    //             return 'Passwords are not matching';
    //           }
    //           return null;
    //         },*/
    //   onChanged: (value) {
    //     _confirmPassword = value;
    //   },
    //   decoration: InputDecoration(
    //     prefixIcon: const Icon(
    //       Icons.lock,
    //       color: Constant.primaryColor,
    //     ),
    //     hintText: 'Confirm Password',
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
    //   ),
    // );
  }

  Widget _passwordField() {
    return SimpleTextField(
      labelText: 'Password',
      keyboardType: TextInputType.visiblePassword,
      isPasswordField: true,
      textEditingController: passwordController,
      onChanged: (value) {
        _password = value;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _genderView() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.people,
            // color: Constant.primaryColor,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              "Gender",
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Radio<String>(
            value: "Male",
            groupValue: _gendernewValue,
            onChanged: (String? value) {
              setState(() {
                _gendernewValue = value!;
                print(_gendernewValue);
              });
            },
          ),
          Text('Male'),
          Radio<String>(
            value: "Female",
            groupValue: _gendernewValue,
            onChanged: (String? value) {
              setState(() {
                _gendernewValue = value!;
                print(_gendernewValue);
              });
            },
          ),
          Text('Female'),
        ],
      ),
    );
  }

  Widget _phoneNumberField() {
    return SimpleTextField(
      labelText: 'Phone Number',
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)) {
          //  r'^[0-9]{10}$' pattern plain match number with length 10
          return "Enter Correct Phone Number";
        } else {
          return null;
        }
      },
      onChanged: (value) {
        _mobileNumber = value;
      },
      textInputAction: TextInputAction.next,
      maxLength: 10,
    );
    // return TextFormField(
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   inputFormatters: [
    //     LengthLimitingTextInputFormatter(10),
    //   ],
    //   validator: (value) {
    //     if (value!.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(value)) {
    //       //  r'^[0-9]{10}$' pattern plain match number with length 10
    //       return "Enter Correct Phone Number";
    //     } else {
    //       return null;
    //     }
    //   },
    //   onChanged: (value) {
    //     _mobileNumber = value;
    //   },
    //   decoration: InputDecoration(
    //     prefixIcon: const Icon(
    //       Icons.phone,
    //       color: Constant.primaryColor,
    //     ),
    //     hintText: 'Phone Number',
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70.0)),
    //   ),
    // );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 190.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              // activeColor: Colors.orange[200],
              activeColor: Color(0xff3A67B1),
              value: checkBoxValue,
              onChanged: (newValue) {
                setState(() {
                  checkBoxValue = newValue!;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    //!_registerFormKey.currentState!.validate();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PositiveButton(
        title: 'SignUp',
        onPressed: () async {
          FocusScope.of(context).unfocus();
          if (!_registerFormKey.currentState!.validate()) {
            print("successful");
            return;
          }
          if (_trainerLevel == 'Trainer Level') {
            _trainerLevelNotifier.trainerLevelNotifier(true);
            return;
          } else {
            print("UnSuccessfull");
          }
          setState(() {
            showSpinner = true;
          });
          if (!checkBoxValue) {
            Fluttertoast.showToast(
                msg: "Accept Terms and Conditions",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,
                textColor: Colors.white);

            return;
          }
          loadingBox(context, 'Loading...');
          try {
            String? _downloadUrl;
            if (_image != null) {
              // firebase_storage.UploadTask? task = await _uploadFile(_image);
              // task.storage.
              // _downloadUrl = await _downloadLink(task!.snapshot.ref);
              // _downloadUrl = await task!.snapshot.ref.getDownloadURL();
              _downloadUrl = await _uploadFile(_image);
              print('_downloadUrl: $_downloadUrl');
            }

            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
            await FirebaseFirestore.instance.collection('users').doc(_email).set({
              'Email': _email,
              'FullName': _fullName,
              'MobileNumber': _mobileNumber.toString(),
              'Password': _password,
              'Confirm Password': _confirmPassword,
              'Shop Name': _shopName,
              'Shop Address': _shopAddress,
              'UserType': "User",
              'Status': 'Pending',
              'createdAt': DateTime.now().toString(),
              'District': _trainerLevel,
              'Gender': _gendernewValue,
              'imageUrl': _downloadUrl == null || _downloadUrl.isEmpty ? '' : _downloadUrl,
            });
            _firebaseMessaging.subscribeToTopic(SimpleFunctions.replaceWhitespacesUsingRegex(_trainerLevel, '_')!);
            Navigator.pop(context);
            SharedPreferenceHelper.getDistrictData(_trainerLevel);
            Navigator.pushReplacementNamed(context, SignInScreen.id);
            Fluttertoast.showToast(
                msg: "Registered Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,
                textColor: Colors.white);
          } catch (e) {
            Fluttertoast.showToast(
                msg: e.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey,
                textColor: Colors.white);
            print(e.toString());
          }
          setState(() {
            showSpinner = false;
          });
        },
      ),
    );
//         : MaterialButton(
//             disabledColor: Colors.grey,
//             elevation: 0,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//             onPressed: () async {
//               Fluttertoast.showToast(
//                   msg: "Accept Terms and Conditions",
//                   toastLength: Toast.LENGTH_LONG,
//                   gravity: ToastGravity.BOTTOM,
//                   backgroundColor: Colors.grey,
//                   textColor: Colors.white);
//             },
//             textColor: Colors.white,
//             padding: const EdgeInsets.all(0.0),
//             child: Container(
//               alignment: Alignment.center,
// //        height: _height / 20,
//               width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                 gradient: LinearGradient(
//                   colors: <Color>[Colors.grey, Colors.grey],
//                 ),
//               ),
//               padding: const EdgeInsets.all(12.0),
//               child: Text(
//                 'REGISTER',
//                 style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
//               ),
//             ),
//           );
  }

  loadingBox(BuildContext context, String text) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return Dialog(
              insetPadding: EdgeInsets.all(width * 0.15),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: height * 0.1,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: width * 0.05),
                    CircularProgressIndicator(
                      color: Color(0xff3A67B1),
                    ),
                    SizedBox(width: width * 0.1),
                    Text(text, style: TextStyle(fontSize: width * 0.04)),
                  ],
                ),
              ));
        });
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 200.0, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SignInScreen.id);
              //Navigator.of(context).pop(Constant.signIn);
            },
            child: Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xff0097D7), fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  Widget _setProfilePic() {
    return Positioned(
      top: (_height / 5.5) - (_height / 8),
      child: GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: Container(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: _width / 2.5,
                    height: _height / 6,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(_height),
                            child: Image.file(
                              _image!,
                              width: _height / 8,
                              height: _height / 8,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(_height)),
                            width: _height / 8,
                            height: _height / 8,
                            child: ClipOval(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                                size: _height / 15,
                              ),
                            )),
                  ),
                  Positioned(
                    // top: (height / 3.5) - (height / 12),
                    bottom: 0,
                    child: Icon(Icons.edit_attributes_rounded),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.no_photography_rounded),
                  title: const Text('Remove Photo'),
                  onTap: () async {
                    setState(() {
                      _image = null;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () async {
                      await _imgFromGallery();
                      //      firebase_storage.UploadTask? task = await _uploadFile(_image);
                      // // task.storage.
                      // final _downloadUrl = await _downloadLink(task!.snapshot.ref);
                      // print('_downloadUrl: $_downloadUrl');
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    await _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera() async {
    final picker = ImagePicker();
    // PickedFile pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    // PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  /// The user selects a file, and the task is added to the list.
  Future<String?> _uploadFile(File? file) async {
    if (file == null) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('No file was selected'),
      // ));

      return null;
    }

    String fileName = path.basename(file.path);

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('profile/$fileName');

    final metadata =
        firebase_storage.SettableMetadata(contentType: 'image/${path.extension(file.path)}', customMetadata: {'picked-file-path': file.path});

    await ref.putFile(File(file.path), metadata);
    // uploadTask = ref.putFile(File(file.path), metadata);
    var dowurl = await ref.getDownloadURL();
    // return Future.value(uploadTask);
    return dowurl;
  }

  Future<String?> _downloadLink(firebase_storage.Reference ref) async {
    final _profileImageLink = await ref.getDownloadURL();
    return _profileImageLink;
    // await Clipboard.setData(ClipboardData(
    //   text: link,
    // ));

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text(
    //       'Success!\n Copied download URL to Clipboard!',
    //     ),
    //   ),
    // );
  }
}

class TrainerLevelNotifier {
  ValueNotifier<bool> valueNotifier = ValueNotifier(false);

  void trainerLevelNotifier(bool value) {
    valueNotifier.value = value;
  }
}
