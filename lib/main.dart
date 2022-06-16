import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'Models/push_notification_model.dart';
import 'Screens/directory_screen.dart';
import 'Screens/homepage.dart';
import 'Screens/sign_in_screen.dart';
import 'Screens/sign_up_screen.dart';
import 'Screens/splash_screen.dart';
import 'Utils/constants.dart';
import 'helper/shared_preference_helper.dart';




Future<void> _messageHandler(RemoteMessage message) async {
  //Map<String, String> data = message["data"];
  Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA3jQh9U-Xocxa5QukCAFWgxWu_t7X75wQ',
        appId: '1:791847750329:android:00f2b95453562229926968',
        messagingSenderId: '791847750329',
        projectId: 'sample-app-2df0a',
      ));
  print('background message ${message.notification!.body}');

  //await showNotification(message.toString());
  /*if (message['data'] != null) {
    final data = message['data'];

    final title = data['title'];
    final body = data['message'];

    await showNotification(title, body);
  }
  return Future<void>.value();*/
}
showNotification(String message) {

  flutterLocalNotificationsPlugin.show(
      0,
      "Sample App",
      /*title,*/
      /*"New Message Received",*/
      message,
      NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id, channel.name,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher')));


}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
late final FirebaseMessaging _messaging;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  _messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
// Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  //FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  await SharedPreferenceHelper.getUserLoggedIn();
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging.onMessage;
  final _fireStore = FirebaseFirestore.instance;
  final key = GlobalKey<ScaffoldState>();
  late int _totalNotifications;
  PushNotification? _notificationInfo;
  //late FirebaseMessaging messaging;
  bool _isLoggedIn = false;
  int _counter = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.getToken().then((token){
      print(token);
    });
/*
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );*/
    _firebaseMessaging.subscribeToTopic('Messages');
  }
  // get current user
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token){
      saveTokens(token);
    });
    _firebaseMessaging.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      final snackBar = SnackBar(
        content: Text(event.notification!.title.toString()),
        action: SnackBarAction(label: 'GO', onPressed: () {}),
      );
      key.currentState?.showSnackBar(snackBar);
    });
    //firebaseCloudMessaging_Listeners();
    checkForInitialMessage();
    FirebaseMessaging.instance.subscribeToTopic("Messages");
    _getUserLoggedInStatus();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    //getCurrentUser();
  }
  Future<void> saveTokens(var token) async {
    try {
      await _fireStore.collection('tokens').add({
        'token': token,
      });
    } catch (e) {
      print(e);
    }
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "This is an Flutter Push Notification",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }
  _getUserLoggedInStatus()  {
    SharedPreferenceHelper.getUserLoggedIn().then((value) {
      if(value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sample App',
        theme: ThemeData(
          //primarySwatch: Constant.primaryColor,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Constant.primaryColor,
        ),
        routes: {
          SignInScreen.id :  (context) => const SignInScreen(),
          SignUpScreen.id :  (context) => const SignUpScreen(),
          DirectoryPage.id :  (context) => const DirectoryPage(),
        },
        // home: _isLoggedIn ? const NewApp() : const SignInScreen(),
        home: SplashScreen(),
      ),
    );
  }
}
