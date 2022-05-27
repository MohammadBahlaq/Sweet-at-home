class User {
  String name;
  String email;
  String phone;
  String Password;

  // Constructor
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.Password,
  });

  /**User copy({
    String? name,
    String? phone,
    String? email,
    String? Password,
  }) =>
      User(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        Password: Password ?? this.Password,
      );**/

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        Password: json['Password'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'Password': Password,
      };
}
