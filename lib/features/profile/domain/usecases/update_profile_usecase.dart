import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class UpdateProfileUseCase {
  final ProfileRepositoryImpl profileRepository;
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  const UpdateProfileUseCase({
    required this.profileRepository,
    required this.profileEntity,
    required this.contacts,
  });

  Future<Either<String, bool>> call() async {
    return await profileRepository.updateProfile(
      profileEntity,
      contacts,
    );
  }
}
