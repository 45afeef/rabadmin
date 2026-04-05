import '../../domain/entity/driver_entity.dart';

abstract class DriverQueryState {}

class DriverQueryInitial extends DriverQueryState {}

class DriverQueryLoading extends DriverQueryState {}

class DriverQueryLoaded extends DriverQueryState {
  final List<DriverEntity> drivers;
  DriverQueryLoaded(this.drivers);
}

class DriverQueryError extends DriverQueryState {
  final String message;
  DriverQueryError(this.message);
}
