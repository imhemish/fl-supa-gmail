class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  String? address;
  String? phoneNumber;
  int? age;
  String? additionalInfo;
  final DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.address,
    this.phoneNumber,
    this.age,
    this.additionalInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['display_name'],
      photoUrl: json['photo_url'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      age: json['age'],
      additionalInfo: json['additional_info'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'address': address,
      'phone_number': phoneNumber,
      'age': age,
      'additional_info': additionalInfo,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? address,
    String? phoneNumber,
    int? age,
    String? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}