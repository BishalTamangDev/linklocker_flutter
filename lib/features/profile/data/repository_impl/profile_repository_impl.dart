import 'package:dartz/dartz.dart';
import 'package:linklocker/core/data/source/local/local_data_source.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  // add
  @override
  Future<bool> addProfile({required ProfileEntity profileEntity, required List<ProfileContactEntity> contacts}) async {
    return await LocalDataSource.getInstance().addProfile(profileEntity, contacts);
  }

  // update
  @override
  Future<bool> updateProfile({required ProfileEntity profileEntity, required List<ProfileContactEntity> contacts}) async {
    return await LocalDataSource.getInstance().updateProfile(profileEntity, contacts);
  }

  // fetch
  @override
  Future<Either<bool, List<Map<String, dynamic>>>> fetchProfile() async {
    return await LocalDataSource.getInstance().fetchProfile();
  }

  // delete profile
  @override
  Future<bool> deleteProfile() async {
    return await LocalDataSource.getInstance().deleteProfile();
  }
}
