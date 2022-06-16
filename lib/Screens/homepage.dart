import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity/connectivity.dart';
import '../Models/push_notification_model.dart';
import '../Utils/simple_functions.dart';
import '../Widgets/appbar.dart';
import '../Widgets/responsive_ui.dart';
import '../Widgets/text.dart';
import '../helper/shared_preference_helper.dart';
import '../main.dart';
import 'nointernetview.dart';
import 'directory_screen.dart';

class NewApp extends StatefulWidget {
  static const String id = 'NewApp';
  const NewApp({Key? key}) : super(key: key);

  @override
  _NewAppState createState() => _NewAppState();
}

final List<String> imagesList = [];
final _fireStore = FirebaseFirestore.instance;

class _NewAppState extends State<NewApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final FirebaseMessaging _messaging;
  late FirebaseMessaging messaging;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late int _totalNotifications;
  PushNotification? _notificationInfo;
  FirebaseStorage storage = FirebaseStorage.instance;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  PushNotification? notificationInfo;
  late bool large;
  late bool medium;
  late String userName = "";
  late String districtValue = "";
  late String lastMessageNotify = "";
  late bool _isLoggedIn = false;
  late final bool _isUserApproved = false;
  late bool _isTimeForDisplay = false;
  late final bool _isUserDistrict = false;

  late String userApprovedStatusValue = "";
  late String adminApprovedStatusValue = "";
  Color gradientStart = Colors.black45;
  Color gradientEnd = Colors.black;
  Future<String> callAsyncFetch() => Future.delayed(const Duration(seconds: 2), () => "hi");

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }
  }

  final List<Map<String, dynamic>> files = [];

  Future<List<Map<String, dynamic>>> _loadImages() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      print("Working connected");

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
      // print(files[0]["url"]);
      for (int i = 0; i < files.length; i++) {
        // setState(() {
        imagesList.add(files[i]["url"]);
        // });
      }
      print(imagesList);
      return files;
    } else {
      print("Working not connected");
      // NoInternetView().showMyDialog();
      // NoInternetView().showMyDialog();

      showMyDialog(context);
    }
    return files;
  }

  showMyDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        title: Text("No Internet Connection"),
        content: Wrap(
          children: [
            lottieImageView(),
            Text("Please check your Internet Connection settings"),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              "Okay",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  lottieImageView() {
    return Container(
      child: Lottie.asset('assets/images/nointernetconnection .json', repeat: true),
    );
  }

  _getUserLoggedInStatus() {
    SharedPreferenceHelper.getUserTypeData().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
          print("_isLoggedIn------------$_isLoggedIn");
        });
      }
    });
  }

  _getUserEmail() {
    SharedPreferenceHelper.getUserEmail().then((value) async {
      setState(() {
        userName = value;
        _isUserApproved == true;
        _isTimeForDisplay = true;
        print("userName------------$userName");
      });

      if (userName.isNotEmpty) {
        // getUserApprovedStatus(userName).whenComplete(() => {
        //       setState(() {
        //         _isUserApproved == true;
        //       })
        //     });
        //await getAdminStatus(userName);
        /* await getUserApprovedStatus(userName).then((value) => {
      setState(() {
      _isUserDistrict == true;
      })
      });*/
        // _getDistrictValue(userName).then((value) {
        //       setState(() {
        // _isUserDistrict == true;
        // _firebaseMessaging.subscribeToTopic(SimpleFunctions.replaceWhitespacesUsingRegex(districtValue, '_')!);
        // _firebaseMessaging.subscribeToTopic('All');
        //       });
        //     });

        if (_isLoggedIn == true) {
          await FirebaseFirestore.instance.collection('users').doc(userName).get().then((value) => {
                districtValue = value["District"].toString(),
                SharedPreferenceHelper.saveUserDistrict(districtValue),
                _isUserDistrict == true,
                _firebaseMessaging.subscribeToTopic(SimpleFunctions.replaceWhitespacesUsingRegex(districtValue, '_')!),
                _firebaseMessaging.subscribeToTopic('All')
                // print("userApprovedStatusValue ---- $districtValue")
              });
          _getNotificationMessage().whenComplete(() => {
                //showNotification()
                //Timer.periodic(const Duration(minutes: 1), (Timer t) => showNotification())
                /*_isLoggedIn ? showNotification() :
          Fluttertoast.showToast(
              msg: "Admin Don't Have Notification",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey,
              textColor: Colors.white
          )*/
              });
        }
      } else {
        Fluttertoast.showToast(
            msg: "user does not exist: ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
    });
  }

  Future _setTokens() async {
    var token = await FirebaseMessaging.instance.getToken();
    print("Your FCM token is : $token");
    if (_isLoggedIn) {
      FirebaseFirestore.instance.collection('users').doc(userName).update({"token": token.toString()});
    }
  }

  @override
  void initState() {
    // _getUserLoggedInStatus();
    SharedPreferenceHelper.getUserTypeData().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
        _getUserEmail();
      }
    });
    
    _loadImages();
    // _getUserEmail();
    _setTokens();
    //Timer.periodic(const Duration(minutes: 1), (Timer t) => _isLoggedIn ? showNotification() : ""
    /*Fluttertoast.showToast(
        msg: "No Notification",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white
    )*/
    super.initState();
  }

  showUserStatus() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //this means the user must tap a button to exit the Alert Dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You are not Approved by Admin!'),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Ok'),
              onPressed: () {
                SharedPreferenceHelper.clearData();
                Navigator.pushNamed(context, SignInScreen.id);
              },
            ),
            /*MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),*/
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //this means the user must tap a button to exit the Alert Dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure want to Logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: const Text('Ok'),
              onPressed: () {
                SharedPreferenceHelper.clearData();
                Navigator.pushReplacementNamed(context, SignInScreen.id);
                // Navigator.pushNamed(context, SignInScreen.id);
                // Navigator.popAndPushNamed(context, SignInScreen.id);
                // Navigator.restorablePopAndPushNamed(context, SignInScreen.id);
                // Navigator.pushNamedAndRemoveUntil(context, SignInScreen.id, (Route<dynamic> route) => false);
                // Navigator.pushNamed(context, SignInScreen.id);
              },
            ),
          ],
        );
      },
    );
  }

  /* void showNotification() {

    if(_isLoggedIn == true){
      flutterLocalNotificationsPlugin.show(
          0,
          "Sample App",
          "New Message Received",
          lastMessageNotify,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name,
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher')));
    }

  }*/
  Future getUserApprovedStatus(String username) async {
    if (_isLoggedIn == true) {
      await FirebaseFirestore.instance.collection('users').doc(username).get().then((value) => {
            userApprovedStatusValue = value["Status"].toString(),
            setState(() {
              userApprovedStatusValue = value["Status"].toString();
              _isUserApproved == true;
            }),
            print("userApprovedStatusValue ---- $userApprovedStatusValue")
          });
    } else if (_isLoggedIn == false) {
      setState(() {
        userApprovedStatusValue = "Approved";
        _isUserApproved == true;
      });
      print("userApprovedStatusValue ---- $userApprovedStatusValue");
    }
  }

  Future _getDistrictValue(String username) async {
    await FirebaseFirestore.instance.collection('users').doc(username).get().then((value) => {
          districtValue = value["District"].toString(),
          SharedPreferenceHelper.saveUserDistrict(districtValue),
          print("userApprovedStatusValue ---- $districtValue")
        });
  }

  Future _getNotificationMessage() async {
    _firebaseMessaging.subscribeToTopic(SimpleFunctions.replaceWhitespacesUsingRegex(districtValue, '_')!);
    await FirebaseFirestore.instance
        .collection("Messages")
        .doc(SimpleFunctions.replaceWhitespacesUsingRegex(districtValue, '_')!)
        .collection("chats")
        .orderBy("time", descending: false)
        .get()
        .then((value) => {
              setState(() {
                lastMessageNotify = value.docs.last["text"].toString();
              }),
              print("lastMessageNotify----------$lastMessageNotify"),
            });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_isLoggedIn == true) {
      // Your navigation code
      SystemNavigator.pop();
    }
    lastMessageNotify == "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _totalNotifications = 0;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SimpleAppBar(
        text: "",
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                _showMyDialog();
              }),
        ],
      ),
      // appBar: AppBar(
      //     centerTitle: true,
      //     automaticallyImplyLeading: false,
      //     title: const Text(
      //       'Advertisements',
      //       style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      //     ),
      // actions: <Widget>[
      //   IconButton(
      //       icon: const Icon(Icons.logout_outlined),
      //       onPressed: () {
      //         _showMyDialog();
      //       }),
      // ],
      //     backgroundColor: Colors.pinkAccent),
      // body:
      //     /* _isUserApproved ? const Center(child: CircularProgressIndicator()) :*/
      //     userApprovedStatusValue == "Approved"
      //         ? Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               HeaderText(text: 'Advertisements'),
      //               SizedBox(
      //                 height: _height / 40,
      //               ),
      //               carousel(),
      //               _divider(),
      //               _isLoggedIn ? _userView() : _adminView()
      //             ],
      //           )
      //         : _notApprovedText(),
      body: _isLoggedIn
          ? (_isTimeForDisplay
              ? Column(
                children: [
                  HeaderText(text: 'Advertisements'),
                                SizedBox(
                                  height: _height / 40,
                                ),
                                //carousel(),
                                _divider(),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(userName).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) return Text('Error = ${snapshot.error}');
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data!['Status'] == 'Approved') {
                            return _isLoggedIn ? _userView() : _adminView();
                          } else {
                            return _notApprovedText();
                          }
                        }
                        return SizedBox(
                          height: 0,
                        );
                      }),
                ],
              )
              : const Center(
                  child: CircularProgressIndicator(),
                ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(text: 'Advertisements'),
                SizedBox(
                  height: _height / 40,
                ),
                //carousel(),
                _divider(),
                _isLoggedIn ? _userView() : _adminView()
              ],
            ),
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.black,
      height: 20,
      thickness: 0.2,
    );
  }

  Center _notApprovedText() {
    return const Center(
        child: Text(
      "You are not Approved by Admin!",
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    ));
  }

  Expanded _adminView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 8,
            ),
            addAdvButton(),
            const SizedBox(
              height: 8,
            ),
            pendingApprovalButton(),
            const SizedBox(
              height: 8,
            ),
            userManagementButton(),
            const SizedBox(
              height: 8,
            ),
            sendMessageButton(),
          ],
        ),
      ),
    );
  }

  Column _userView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 8,
        ),
        directoryPageButton(),
        const SizedBox(
          height: 8,
        ),
        messageButton(),
      ],
    );
  }


  Widget addAdvButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: _containerTemplate(
        imageLink: 'assets/images/advertisement.jpg',
        title: 'Add Advertisement',
        subTitle: 'View the directory of users',
        onTap: () {

        },
      ),
    );

  }

  Widget pendingApprovalButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: _containerTemplate(
        imageLink: 'assets/images/approval.jpg',
        title: 'Pending Approval',
        subTitle: 'Approve the users',
        onTap: () {
        },
      ),
    );

  }

  Widget userManagementButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: _containerTemplate(
        imageLink: 'assets/images/directory.jpg',
        title: 'Directory',
        subTitle: 'View the directory of users',
        onTap: () {
          Navigator.pushNamed(context, DirectoryPage.id);
        },
      ),
    );

  }

  Widget directoryPageButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: _containerTemplate(
        imageLink: 'assets/images/directory.jpg',
        title: 'Directory',
        subTitle: 'View the directory of users',
        onTap: () {
          Navigator.pushNamed(context, DirectoryPage.id);
        },
      ),
    );

  }

  Widget sendMessageButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: _containerTemplate(
        imageLink: 'assets/images/messages.jpg',
        title: 'Send Message',
        subTitle: 'View messages',
        onTap: () {
          // Navigator.pushNamed(context, SendMessagesPage.id);
        },
      ),
    );

  }

  Widget messageButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: _containerTemplate(
        imageLink: 'assets/images/messages.jpg',
        title: 'Messages',
        subTitle: 'View messages',
        onTap: () {
        },
      ),
    );

  }

  Widget _containerTemplate({
    required String imageLink,
    required String title,
    required String subTitle,
    VoidCallback? onTap,
  }) {
    return Container(
      height: _height / 6,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          // splashFactory: InkSplash.splashFactory,
          onTap: onTap,
          child: Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [gradientStart, gradientEnd],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcATop,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(imageLink),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: Colors.grey.withOpacity(0.6), blurRadius: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
