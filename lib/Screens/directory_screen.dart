import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/enums.dart';
import '../Widgets/appbar.dart';
import '../Widgets/text.dart';


class DirectoryPage extends StatefulWidget {
  static const String id = 'DirectoryPage';
  const DirectoryPage({Key? key}) : super(key: key);

  @override
  _DirectoryPageState createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  bool isLoading = true;
  late String _district, districtDropDown;
  late double _height, _width;
  final List<String> imagesList = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  late StateSetter bottomSheetState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return SizedBox();
  }

}
