import '../../../service_providers/domain/entities/stay_provider_entity.dart';

abstract class StayProviderQueryState {}

class StayProviderQueryInitial extends StayProviderQueryState {}

class StayProviderQueryLoading extends StayProviderQueryState {}

class StayProviderQueryLoaded extends StayProviderQueryState {
  final List<StayProviderEntity> providers;
  StayProviderQueryLoaded(this.providers);
}

class StayProviderQueryError extends StayProviderQueryState {
  final String message;
  StayProviderQueryError(this.message);
}
