import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class AddProfileUseCase {
  final ProfileRepositoryImpl profileRepository;

  AddProfileUseCase({required this.profileRepository});

  Future<bool> call(ProfileEntity profileEntity, List<ProfileContactEntity> contacts) async {
    return await profileRepository.addProfile(profileEntity, contacts);
  }
}
