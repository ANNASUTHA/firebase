import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userLoggedInKey = "ISLOGGEDIN";
  static String userTypeDataString = "UserTypeData";
  static String userNameKey = "USERNAMEKEY";
  static String userType = "UserType";
  //static String userTypeData = "UserTypeData";
  static String userEmailKey = "USEREMAILKEY";
  static String district = "district";
  static String userUIDKey = "USERUIDKEY";
  static String userProfilePicKey = "USERPROFILEPICKEY";
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // save data to shared preference
  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return await preference.setBool(userLoggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUserTypeData(bool userTypeData) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return await preference.setBool(userTypeDataString, userTypeData);
  }
  static Future<bool> saveUserName(String userName) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    print(userName);
    return await preference.setString(userNameKey, userName);
  }
  static Future<bool> saveUserType(String userType) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    print(userType);
    return await preference.setString(userType, userType);

  }
  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return await preference.setString(userEmailKey, userEmail);
  }
  static Future<bool> saveUserDistrict(String district) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return await preference.setString(district, district);
  }
  static Future<bool> saveUserUID(String userUID) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return await preference.setString(userUIDKey, userUID);
  }

  static Future<bool> saveUserProfilePic(String profileUrl) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return await preference.setString(userProfilePicKey, profileUrl);
  }

  // get data
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userLoggedInKey) ;
  }
  static Future<bool?> getUserTypeData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(userTypeDataString) ;
  }
  static Future<bool?> getUserLoggedInSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey) ?? "";
  }
  static Future<String> getUsertype() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userType) ?? "";
  }
  static Future<String> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey) ?? "";
  }
  static Future<String> getUserDistrict() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(district) ?? "";
  }
  static Future<bool> getDistrictData(String district) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("district", district);
  }

 /* static Future<bool> setDistrictData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(district);
  }*/
  static Future<String> getUserUID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userUIDKey) ?? "";
  }

  static Future<String> getUserProfilePic() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userProfilePicKey) ?? "";
  }

  // clear all data on sign out
  // Clear all SharedPreference data
  static clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
