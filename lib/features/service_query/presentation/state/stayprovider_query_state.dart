import '../../domain/entity/public_stay_provider_entity.dart';

abstract class StayProviderQueryState {}

class StayProviderQueryInitial extends StayProviderQueryState {}

class StayProviderQueryLoading extends StayProviderQueryState {}

class StayProviderQueryLoaded extends StayProviderQueryState {
  final List<PublicStayProviderEntity> providers;
  StayProviderQueryLoaded(this.providers);
}

class StayProviderQueryError extends StayProviderQueryState {
  final String message;
  StayProviderQueryError(this.message);
}
