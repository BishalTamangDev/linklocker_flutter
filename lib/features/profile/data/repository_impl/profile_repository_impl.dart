import 'package:dartz/dartz.dart';
import 'package:linklocker/data/source/local/local_data_source.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  // add
  @override
  Future<Either<String, bool>> addProfile(
    ProfileEntity profileEntity,
    List<ProfileContactEntity> contacts,
  ) async {
    return await LocalDataSource.getInstance()
        .addProfile(profileEntity, contacts);
  }

  // update
  @override
  Future<Either<String, bool>> updateProfile(
    ProfileEntity profileEntity,
    List<ProfileContactEntity> contacts,
  ) async {
    return await LocalDataSource.getInstance().updateProfile(
      profileEntity,
      contacts,
    );
  }

  // fetch
  @override
  Future<Either<String, Map<String, dynamic>>> fetchProfile() async {
    return await LocalDataSource.getInstance().fetchProfile();
  }

  // delete profile
  @override
  Future<Either<String, bool>> deleteProfile() async {
    return await LocalDataSource.getInstance().deleteProfile();
  }
}
