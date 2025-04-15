import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class UpdateProfileUseCase {
  final ProfileRepositoryImpl profileRepository;

  const UpdateProfileUseCase({required this.profileRepository});

  Future<bool> call({required ProfileEntity profileEntity, required List<ProfileContactEntity> contacts}) async {
    return await profileRepository.updateProfile(profileEntity: profileEntity, contacts: contacts);
  }
}
