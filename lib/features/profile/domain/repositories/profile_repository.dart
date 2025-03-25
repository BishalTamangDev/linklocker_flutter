import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  // add profile
  Future<Either<String, bool>> addProfile(
    ProfileEntity profileEntity,
    List<ProfileContactEntity> contacts,
  );

  // update profile
  Future<Either<String, bool>> updateProfile(
    ProfileEntity profileEntity,
    List<ProfileContactEntity> contacts,
  );

  // fetch profile
  Future<Either<String, Map<String, dynamic>>> fetchProfile();

  // delete profile
  Future<Either<String, bool>> deleteProfile();
}
