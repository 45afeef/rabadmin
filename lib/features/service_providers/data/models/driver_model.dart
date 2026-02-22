import '../../domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    required super.id,
    required super.userId,
    required super.profileId,
    required super.providerId,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    id: json['id'],
    userId: json['userId'],
    profileId: json['profileId'],
    providerId: json['providerId'],
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'profileId': profileId,
      'providerId': providerId,
    };
  }

  @override
  DriverModel copyWith({
    String? id,
    String? userId,
    String? profileId,
    String? providerId,
  }) {
    return DriverModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      providerId: providerId ?? this.providerId,
    );
  }
}
