import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';
import 'package:linklocker/features/profile/domain/repositories/profile_repositories.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<bool> addProfile(ProfileEntity profileEntity) async {
    return true;
  }

  @override
  Future<bool> fetchProfile(ProfileEntity profileEntity) async {
    return true;
  }

  @override
  Future<bool> updateProfile(ProfileEntity profileEntity) async {
    return true;
  }
}
