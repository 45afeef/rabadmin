import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rabadmin/features/auth/data/datasources/auth_local_data_source.dart';

// Import the provider to make it available
import '../../core/providers/providers.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';

/// Initializes the app (Hive, token validation, etc.)
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Initialize Hive
  await Hive.initFlutter();

  // Initialize local data source
  final localDataSource = ref.read(authLocalDataSourceProvider);
  if (localDataSource is HiveAuthLocalDataSource) {
    await localDataSource.init();
  }

  // Validate existing token and restore session
  await ref.read(authControllerProvider.notifier).validateExistingToken();
});
