class Usuario {
  late int sucess;
  late String message;
  late String token;

  Usuario({required this.sucess, required this.message, required this.token});

  Usuario.fromJson(Map<String, dynamic> json) {
    sucess = json['sucess'];
    message = json['message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sucess'] = this.sucess;
    data['message'] = this.message;
    data['token'] = this.token;
    return data;
  }

  String toString() {
    return 'Usuario(sucess: $sucess, message: $message, token: $token)';
  }
}
