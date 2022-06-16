import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
class NoInternetView {
  NoInternetView();
  showMyDialog() {
    var navigatorKey;
    return showDialog(
        context: navigatorKey.currentContext!,
        builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        title: Text("No Internet Connection"),
        content: Wrap(
          children: [
            lottieImageView(),
            Text("Please check your Internet Connection settings"),
          ],
        ),
        actions: <Widget>[
        ElevatedButton(
        onPressed: () {
      Navigator.of(ctx).pop();
    },
          child: Text("Okay", style: Theme.of(navigatorKey.currentContext!).textTheme.subtitle1!.copyWith(color: Colors.white)),
        ),
        ],
        ),
    );
  }

  lottieImageView() {
    return Container(
      child: Lottie.asset('assets/images/nointernetconnection.json', repeat: true),
    );
  }
}