import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  // add profile
  Future<bool> addProfile(ProfileEntity profileEntity);

  // update profile
  Future<bool> updateProfile(ProfileEntity profileEntity);

  // fetch profile
  Future<bool> fetchProfile(ProfileEntity profileEntity);
}
