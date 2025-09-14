class SuccessModel{
  final bool success;
  const SuccessModel({required this.success});

  factory SuccessModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {'success': bool success}=>SuccessModel(success: success),
    _=> throw const FormatException('wrong format')
    };
  }
}