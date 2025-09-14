import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_techm/model/data_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_techm/model/success_model.dart';

class DataController extends GetxController{

  var username="".obs;
  var password="".obs;
  var isAdmin=true.obs;
  var formKey=GlobalKey<FormState>();

  void setUsername(String username){
    this.username.value=username;
  }

  void setPassword(String password){
    this.password.value=password;
  }

  void setIsAdmin(bool isAdmin){
    this.isAdmin.value=isAdmin;
  }

  Future<List<DataModel>> getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token=preferences.getString('token');
    final response = await http.get(
      Uri.parse("http://192.168.0.113:5000/data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      }
    );
    List<dynamic> list=jsonDecode(response.body);

    return list.map((item)=>DataModel.fromJson(item)).toList();;
  }

  Future<SuccessModel> setData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token=preferences.getString('token');
    final response = await http.post(
        Uri.parse("http://192.168.0.113:5000/saveData"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'username': this.username.value, 'password': this.password.value, 'isAdmin': this.isAdmin.value})
    );
    return SuccessModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<SuccessModel> updateData(dynamic value, String key, int id) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token=preferences.getString('token');
    final response = await http.post(
        Uri.parse("http://192.168.0.113:5000/updateData"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'value': value, 'key': key, 'id': id})
    );
    return SuccessModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<SuccessModel> deleteData(int id) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token=preferences.getString('token');
    final response = await http.post(
        Uri.parse("http://192.168.0.113:5000/updateData"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{'id': id})
    );
    return SuccessModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void deleteToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
  }
}