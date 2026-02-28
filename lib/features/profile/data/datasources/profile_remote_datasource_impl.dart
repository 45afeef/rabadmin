import 'package:dio/dio.dart';
import 'package:rab_dio/rab_dio.dart';

import '../models/profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final ProfileApi profileApi;

  ProfileRemoteDataSourceImpl(this.profileApi);

  @override
  Future<ProfileModel> createProfile({
    String? userId,
    required String name,
    String? middleName,
    String? lastName,
    DateTime? dateOfBirth,
    String? profilePicture,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    required String primaryPhoneNumber,
    String? secondaryPhoneNumber,
    String? primaryEmail,
    String? secondaryEmail,
    required String createdByUserId,
  }) async {
    try {
      final response = await profileApi.profileCreateProfile(
        profileCreate: ProfileCreate(
          (b) => b
            ..userId = userId
            ..firstName = name
            ..middleName = middleName
            ..lastName = lastName
            ..dateOfBirth = dateOfBirth as Date?
            ..profilePicture = profilePicture
            ..bio = bio
            ..address = address
            ..city = city
            ..state = state
            ..zipCode = zipCode
            ..country = country
            ..primaryPhoneNumber = primaryPhoneNumber
            ..secondaryPhoneNumber = secondaryPhoneNumber
            ..primaryEmail = primaryEmail
            ..secondaryEmail = secondaryEmail
            ..createdByUserId = createdByUserId,
        ),
      );

      if (response.data == null) {
        throw Exception('Failed to create profile');
      }

      final profileJson = standardSerializers.serializeWith(
        ProfilePublic.serializer,
        response.data,
      );

      return ProfileModel.fromJson(profileJson as Map<String, dynamic>);
    } on DioException catch (e) {
      String newMessage = e.response == null
          ? e.message.toString()
          : e.response.toString();
      throw Exception(newMessage);
    } catch (e) {
      rethrow;
    }
  }
}
