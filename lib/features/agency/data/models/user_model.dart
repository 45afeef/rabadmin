class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name'] ?? map['fullName'] ?? map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone_number'] ?? map['phoneNumber'] ?? map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone_number': phone,
  };
}
