import 'package:flutter/material.dart';
import 'package:test_techm/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:test_techm/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final navigatorKey = GlobalKey<NavigatorState>();
  if(preferences.getString('token')!=null)
    {
      final loginController= Get.put(LoginController(navigatorKey));
      var model = await loginController.tokenLogin();
      if(model.success){
        runApp(UserData());
      }
      else{
        runApp(MyApp());
      }
    }
  else{
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required });
  final navigatorKey = GlobalKey<NavigatorState>();

//need to pass the controller value to login constructor
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Login(title: 'M&M Test', navigator: navigatorKey,),
      navigatorKey: navigatorKey,
      getPages: [
        GetPage(name: "/login", page: ()=> Login(title: 'M&M Test', navigator: navigatorKey,)),
        GetPage(name: "/user_data", page: ()=> UserData())
      ],
    );
  }
}

class Login extends StatelessWidget{
  final String title;
  final GlobalKey<NavigatorState> navigator;
  Login({super.key, required this.title, required this.navigator});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final loginController= Get.put(LoginController(navigator));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(visible: loginController.visible.value,
                child: Form (
                  key: loginController.formKey,
                  child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                          decoration: InputDecoration(
                              labelText: "username",
                              hintText: "Type your username",
                              border: OutlineInputBorder()
                          ),
                          onChanged: (text){
                            loginController.setUsername(text);
                          },
                          validator: (text){
                            if (text == null || text.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          }
                      ),),
                    Padding(padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Type your password",
                            border: OutlineInputBorder()
                        ),
                        onChanged: (text){
                          loginController.setPassword(text);
                        },
                        validator: (text){
                          if (text == null || text.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),),
                    ElevatedButton(onPressed: () async {
                      loginController.setVisibility(false);
                      if(loginController.formKey.currentState!.validate()) {
                        loginController.formKey.currentState!.save();
                        var model = await loginController.login();
                        if(model.success){
                          Get.to(()=>UserData());
                        }
                      }
                      loginController.setVisibility(true);
                    }, child: Text('Login')),
                    ElevatedButton(onPressed: () async{
                      var model = await loginController.ssoLogin();
                      if(model.success){
                        Get.to(()=>UserData());
                      }
                    }, child: Text('SSO Login'))
                  ],
                ),)
            ),
            Visibility(visible: !loginController.visible.value, child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 5.0
            ),
            )
          ],
        ),
      ),
      );;
  }
}
