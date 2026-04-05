import '../../domain/entity/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    required super.id,
    super.userId,
    required super.profileId,
    required super.providerId,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      profileId: json['profile_id'] as String,
      providerId: json['provider_id'] as String,
    );
  }
}
