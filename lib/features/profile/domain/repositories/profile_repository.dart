import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  // add profile
  Future<bool> addProfile(
    ProfileEntity profileEntity,
    List<ProfileContactEntity> contacts,
  );

  // update profile
  Future<bool> updateProfile(
    ProfileEntity profileEntity,
    List<ProfileContactEntity> contacts,
  );

  // fetch profile
  Future<Either<bool, List<Map<String, dynamic>>>> fetchProfile();

  // delete profile
  Future<bool> deleteProfile();
}
