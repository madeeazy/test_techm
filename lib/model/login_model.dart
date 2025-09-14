class LoginModel{
  final bool success;
  final String token;

  const LoginModel({required this.success, required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {'success': bool success, 'token': String token}=>LoginModel(success: success, token: token),
      _=> throw const FormatException('wrong format')
    };
  }
}