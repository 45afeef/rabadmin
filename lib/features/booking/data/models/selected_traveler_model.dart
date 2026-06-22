import '../../domain/entities/selected_Traveller_entity.dart';

class SelectedTravellerModel {
  final String? travellerId;
  final String? travellerName;
  final String? travellerPhone;

  const SelectedTravellerModel({
    this.travellerId,
    this.travellerName,
    this.travellerPhone,
  });

  factory SelectedTravellerModel.fromJson(Map<String, dynamic> json) {
    return SelectedTravellerModel(
      travellerId: json['traveller_id'],
      travellerName: json['traveller_name'],
      travellerPhone: json['traveller_phone'],
    );
  }

  factory SelectedTravellerModel.fromEntity(SelectedTravellerEntity entity) {
    return SelectedTravellerModel(
      travellerId: entity.travellerId,
      travellerName: entity.travellerName,
      travellerPhone: entity.travellerPhone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'traveller_id': travellerId,
      'traveller_name': travellerName,
      'traveller_phone': travellerPhone,
    };
  }

  SelectedTravellerEntity toEntity() {
    if (travellerId != null) {
      return SelectedTravellerEntity.byId(travellerId!);
    }

    return SelectedTravellerEntity.byGuest(
      name: travellerName!,
      phone: travellerPhone!,
    );
  }
}
