import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_agency_use_case.dart';
import '../../domain/usecases/update_agency_use_case.dart';
import '../../domain/usecases/delete_agency_use_case.dart';
import '../../domain/usecases/add_agency_staff_use_case.dart';
import '../../domain/usecases/update_agency_staff_use_case.dart';
import '../../domain/usecases/remove_agency_staff_use_case.dart';
import 'agencies_list_notifier.dart';

/// Provides the CreateAgencyUseCase instance.
final createAgencyUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agencyRepositoryProvider);
  return CreateAgencyUseCase(repository);
});

/// Provides the UpdateAgencyUseCase instance.
final updateAgencyUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agencyRepositoryProvider);
  return UpdateAgencyUseCase(repository);
});

/// Provides the DeleteAgencyUseCase instance.
final deleteAgencyUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agencyRepositoryProvider);
  return DeleteAgencyUseCase(repository);
});

/// Provides the AddAgencyStaffUseCase instance.
final addAgencyStaffUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agencyRepositoryProvider);
  return AddAgencyStaffUseCase(repository);
});

/// Provides the UpdateAgencyStaffUseCase instance.
final updateAgencyStaffUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agencyRepositoryProvider);
  return UpdateAgencyStaffUseCase(repository);
});

/// Provides the RemoveAgencyStaffUseCase instance.
final removeAgencyStaffUseCaseProvider = Provider((ref) {
  final repository = ref.watch(agencyRepositoryProvider);
  return RemoveAgencyStaffUseCase(repository);
});
