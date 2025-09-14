import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_techm/controller/data_controller.dart';
import 'package:test_techm/model/data_model.dart';

class UserData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Container(child: GridData(),),
    );
  }

  
}

class GridData extends StatelessWidget{

  late Future<List<DataModel>> _userData;
  final dataController= Get.put(DataController());

  @override
  Widget build(BuildContext context){
    _userData=dataController.getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('M&M Test'),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context)=><PopupMenuEntry<String>>[
            PopupMenuItem(value:'Logout',child: TextButton(onPressed:(){
              dataController.deleteToken();
              Get.back();
            }, child: Text('Logout')))
          ])
        ],
      ),
      body: FutureBuilder<List<DataModel>>(future: _userData, builder: (BuildContext context, AsyncSnapshot<List<DataModel>> snapshot)
      {
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else if(snapshot.hasData){
          return SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blueGrey[100]),
                  children: [
                    TableCell(child: Center(child: Text('Username'),)),
                    TableCell(child: Center(child: Text('Password'),)),
                    TableCell(child: Center(child: Text('isAdmin'),)),
                    TableCell(child: Center(child: Text('isActive'),)),
                    TableCell(child: Center(child: Text('Delete'),)),
                  ]
                ),
                ...List.generate(snapshot.data!.length, (index){
                  final item=snapshot.data![index];
                  TextEditingController _controller=new TextEditingController();
                  TextEditingController _passwordController=new TextEditingController();
                  _controller.text=item.username;
                  _passwordController.text=item.password;
                  return TableRow(
                    children: [
                      TableCell(child: TextField(controller: _controller, onChanged:(text){
                        snapshot.data![index].username=text;
                        dataController.updateData(text, "username", item.user_id);
                      })),
                      TableCell(child: TextField(controller: _passwordController, onChanged:(text){
                        snapshot.data![index].password=text;
                        dataController.updateData(text, "password", item.user_id);
                      })),
                      TableCell(child: Switch(value: item.role==1, onChanged: (val){
                        snapshot.data![index].role=val?1:0;
                        dataController.updateData(val, "role", item.user_id);
                      })),
                      TableCell(child: Switch(value: item.is_enable==1, onChanged: (val){
                        snapshot.data![index].is_enable=val?1:0;
                        dataController.updateData(val, "is_enable", item.user_id);
                      })),
                      TableCell(child: IconButton(onPressed: (){
                        dataController.deleteData(item.user_id);
                        snapshot.data?.removeAt(index);
                      }, icon: Icon(Icons.delete)))
                    ]
                  );

                })
              ],
            ),
          );
        }
        else if(snapshot.hasError){
          return Text("Error ${snapshot.error}");
        }
        else{
          return Text("No data");
        }
      },),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _userEntryDialog(context);
      }),
    );
  }

    _userEntryDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Entry'),
          content: SingleChildScrollView(
            child: Form(
                key: dataController.formKey,
                child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder()
                  ),
                  onChanged: (text){
                    dataController.setUsername(text);
                  },
                  validator: (text){
                    if (text == null || text.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                ),
                Padding(padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder()
                  ),
                  onChanged: (text){
                    dataController.setPassword(text);
                  },
                  validator: (text){
                    if (text == null || text.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                ),
                Switch(value: dataController.isAdmin.value, onChanged: (val){
                  dataController.setIsAdmin(val);
                })
              ],
            )),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if(dataController.formKey.currentState!.validate()){

                  dataController.setData();
                }
              },
            ),
          ],
        );
      },
    );
  }
}