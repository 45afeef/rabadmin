# Agency Feature - Implementation Notes

## Building the Request Models

The remote data source uses `built_value` builder patterns for creating request models. The exact field names and types need to be verified against the rab_dio package.

### Known Issues

1. **AgencyCreate Field Names**: The builder methods might use different field names than expected:
   - Currently using: `name`, `description`
   - Possible alternatives: `agency_name`, `agencyName`, etc.

2. **AgencyStaffCreate Field Names**:
   - Currently using: `user_id`, `role`
   - The role field might be an enum type (`StaffRole`) rather than a String

3. **StaffRole Enum**: The `role` parameter might need to be converted to an enum value

### How to Fix

1. Check the rab_dio package source code for the actual field names
2. Run Flutter analysis to get compile-time hints
3. Update the remote_data_source.dart file with correct field assignments
4. Test with actual API calls

### Alternative Approach

If the built_value builders don't work as expected, consider:

1. Creating wrapper functions that properly build these objects
2. Using JSON serialization directly by creating Map<String, dynamic>
3. Checking if rab_dio provides factory constructors

### Testing

After fixing the field names:

```dart
// Test creating an agency
final newAgency = await agencyRepository.createAgency(
  name: 'Test Agency',
  description: 'Test Description',
);

// Test updating
final updated = await agencyRepository.updateAgency(
  agencyId: newAgency.id,
  name: 'Updated Name',
);

// Test staff operations
final staff = await agencyRepository.addAgencyStaff(
  agencyId: newAgency.id,
  userId: 'user-123',
  role: 'manager',
);
```

## Model Inheritance

The `AgencyDetailModel` extends `AgencyDetail` which extends `Agency`. The `copyWith` method has compatibility issues:

- Parent: `Agency.copyWith() -> Agency`
- Child: `AgencyDetail.copyWith() -> AgencyDetail`  
- Grandchild: `AgencyDetailModel.copyWith() -> AgencyDetailModel`

The type system doesn't allow `AgencyDetailModel.copyWith()` to satisfy the `AgencyDetail.copyWith()` contract when the `staffs` parameter type is `List<AgencyStaffModel>` instead of `List<AgencyStaff>`.

**Solution**: Created `copyWithModel()` method for model-specific operations, and made `copyWith()` work with the parent types by casting.

## Dart/Flutter Version Notes

- Using Dart 3.10.7
- Flutter Riverpod for state management
- Built_value for JSON serialization in rab_dio

## Next Steps

1. Generate or obtain the actual rab_dio source files
2. Update field names in remote_data_source.dart
3. Run full test suite
4. Create sample integration tests
5. Document actual API request/response formats
