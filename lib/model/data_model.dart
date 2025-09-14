class DataModel{
  String username;
  String password;
  int role;
  int is_enable;
  int user_id;

  DataModel({required this.username, required this.password, required this.role, required this.is_enable, required this.user_id});

  factory DataModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {'is_enable': int is_enable, 'password': String password, 'role': int role, 'user_id': int user_id, 'username': String username}=>DataModel(username: username, password: password, role: role, is_enable: is_enable, user_id: user_id),
      _=> throw const FormatException('wrong format')
    };
  }
}