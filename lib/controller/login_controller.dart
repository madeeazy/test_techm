import 'package:aad_oauth/model/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_techm/model/success_model.dart';
import 'package:test_techm/model/login_model.dart';
import 'package:aad_oauth/aad_oauth.dart';

class LoginController extends GetxController{
  GlobalKey<NavigatorState> navigator;
  LoginController(this.navigator);
  var username="".obs;
  var password="".obs;
  var visible=true.obs;
  var formKey=GlobalKey<FormState>();



  void setUsername(String username){
    this.username.value=username;
  }

  void setPassword(String password){
    this.password.value=password;
  }

  void setVisibility(bool visibile){
    this.visible.value=visibile;
  }

  Future<LoginModel> login() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://192.168.0.113:5000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'username': username.value, 'password': password.value}),
    );
    final loginModel=LoginModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    preferences.setString('token', loginModel.token);
    return loginModel;
  }

  Future<SuccessModel> tokenLogin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token=preferences.getString('token');
    final response= await http.get(
      Uri.parse('http://192.168.0.113:5000/tokenLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    return SuccessModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<LoginModel> ssoLogin()async{
    final Config config=Config(tenant: "14601113-d17c-4576-977b-daf2336aece4", clientId: "57002d7e-fafa-480f-aa43-3e7e2635c824", scope: "openid profile offline_access", redirectUri: "http://192.168.0.113:5000/login", navigatorKey: navigator);
    AadOAuth oauth = AadOAuth(config);
    oauth.login();
    final accessToken = await oauth.getAccessToken();
    final response= await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    final Map<String, dynamic> userData = jsonDecode(response.body);
    final String name = userData['displayName'] ?? 'Name Not Available';
    setUsername(name);
    setPassword("");
    return login();
  }


}