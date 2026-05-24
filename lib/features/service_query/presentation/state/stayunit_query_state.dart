import '../../../service_providers/domain/entities/stay_unit_entity.dart';

abstract class UnitQueryState {}

class StayUnitQueryInitial extends UnitQueryState {}

class StayUnitQueryLoading extends UnitQueryState {}

class StayUnitQueryLoaded extends UnitQueryState {
  final List<StayUnitEntity> units;
  StayUnitQueryLoaded(this.units);
}

class StayUnitQueryError extends UnitQueryState {
  final String message;
  StayUnitQueryError(this.message);
}
