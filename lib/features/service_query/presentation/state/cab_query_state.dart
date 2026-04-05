import '../../domain/entity/cab_entity.dart';

abstract class CabQueryState {}

class CabQueryInitial extends CabQueryState {}

class CabQueryLoading extends CabQueryState {}

class CabQueryLoaded extends CabQueryState {
  final List<CabEntity> cabs;
  CabQueryLoaded(this.cabs);
}

class CabQueryError extends CabQueryState {
  final String message;
  CabQueryError(this.message);
}
