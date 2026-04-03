import '../../domain/entity/public_stay_unit_entity.dart';

abstract class StayQueryState {}

class StayQueryInitial extends StayQueryState {}

class StayQueryLoading extends StayQueryState {}

class StayQueryLoaded extends StayQueryState {
  final List<PublicStayUnitEntity> units;
  StayQueryLoaded(this.units);
}

class StayQueryError extends StayQueryState {
  final String message;
  StayQueryError(this.message);
}
