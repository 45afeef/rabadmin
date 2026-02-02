// ignore_for_file: file_names
// Integration Test Example
//
// This file demonstrates how to test the agency feature integration
// with the rab_dio API client.
//
// Save as: test/features/agency/integration_test.dart
//
// To run:
// flutter test test/features/agency/integration_test.dart

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:rabadmin/features/agency/data/datasources/agency_remote_data_source.dart';
// import 'package:rabadmin/features/agency/data/models/agency_model.dart';
// import 'package:rabadmin/features/agency/data/repositories/agency_repository_impl.dart';
// import 'package:rabadmin/features/agency/domain/usecases/list_agencies_use_case.dart';
// import 'package:rabadmin/features/agency/domain/usecases/create_agency_use_case.dart';

// void main() {
//   group('Agency Feature Integration Tests', () {
//     late AgencyRemoteDataSource mockDataSource;
//     late AgencyRepositoryImpl repository;

//     setUp(() {
//       mockDataSource = MockAgencyRemoteDataSource();
//       repository = AgencyRepositoryImpl(mockDataSource);
//     });

//     test('should list agencies successfully', () async {
//       // Arrange
//       final mockAgencies = [
//         AgencyModel(
//           id: '1',
//           name: 'Test Agency 1',
//           isActive: true,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//         AgencyModel(
//           id: '2',
//           name: 'Test Agency 2',
//           isActive: true,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//       ];

//       when(mockDataSource.listAgencies()).thenAnswer((_) async => mockAgencies);

//       // Act
//       final result = await repository.listAgencies();

//       // Assert
//       expect(result.length, 2);
//       expect(result[0].name, 'Test Agency 1');
//       verify(mockDataSource.listAgencies()).called(1);
//     });

//     test('should create agency successfully', () async {
//       // Arrange
//       final newAgencyModel = AgencyModel(
//         id: '3',
//         name: 'New Agency',
//         description: 'Test Description',
//         isActive: true,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       when(mockDataSource.createAgency(
//         name: 'New Agency',
//         description: 'Test Description',
//       )).thenAnswer((_) async => newAgencyModel);

//       // Act
//       final result = await repository.createAgency(
//         name: 'New Agency',
//         description: 'Test Description',
//       );

//       // Assert
//       expect(result.id, '3');
//       expect(result.name, 'New Agency');
//     });

//     test('should handle API errors gracefully', () async {
//       // Arrange
//       when(mockDataSource.listAgencies()).thenThrow(Exception('API Error'));

//       // Act & Assert
//       expect(
//         () => repository.listAgencies(),
//         throwsException,
//       );
//     });
//   });
// }

// Mock classes would go here or in a separate mocks.dart file
