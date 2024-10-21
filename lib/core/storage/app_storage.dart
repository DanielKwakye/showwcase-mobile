import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nanoid/nanoid.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';



class AppStorage {
  /// This will store the user detail in memory anytime user opens the app
  static UserModel? currentUserSession;
  static late String sessionId;

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
// Create storage
  static final storage =  FlutterSecureStorage(aOptions: _getAndroidOptions());

  static const String _authTokenKey = 'authTokenKey';

  static setAuthTokenVal(String value) async => await storage.write(key: _authTokenKey, value: value);

  static Future<String> getAuthTokenVal() async {
    // use token
    // favor's token =
    //return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTI2MTQ4LCJjcmVhdGVkQXQiOjE2OTM4MjY4NjU5ODQsInR5cGUiOiJhdXRoIiwiaWF0IjoxNjkzODI2ODY1fQ.6587ZHCXHmUzskQ8v3hzlLWZDFMgLB4xLLxqYL69Akg' ;
    //    return  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDgxMiwiZW1haWwiOiJmYXZvdXJvbnVAZ21haWwuY29tIiwiY3JlYXRlZEF0IjoxNjkzMzEwODMzMjUyLCJ0eXBlIjoiYXV0aCIsImlhdCI6MTY5MzMxMDgzM30.wfXIjlVi2hlrN57DfqQAsFf3xvPq362zUhQSkwK_llU";
   //return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NywiZW1haWwiOiJjb21tcy5zaG93Y2FzZUBnbWFpbC5jb20iLCJjcmVhdGVkQXQiOjE2ODUwOTcwMTIzODAsInR5cGUiOiJhdXRoIiwiaWF0IjoxNjg1MDk3MDEyfQ.CseS-YS6PBoDrXWKyIRe09oFWkE9M3rqebO6oP1DziQ';
    return await storage.read(key: _authTokenKey) ?? '';
  }

  static Future<void> removeAuthTokenVal() async {
    // use token
    await storage.delete(key: _authTokenKey);
  }


  static Future<void> saveToPref({required String key, required Map<String, dynamic> jsonValue}) async{
    // Write value
    await storage.write(key: key, value: json.encode(jsonValue));
  }

  static Future<Map<String, dynamic>?> getFromPref({required String key}) async {
// Read value
    String? value = await storage.read(key: key);
    if(value != null){
      return json.decode(value);
    }
    return null;
  }

  static remove({required String key}) async {
    // Delete value
    await storage.delete(key: key);
  }


  static refreshSessionId() {
    sessionId = nanoid();
  }


}