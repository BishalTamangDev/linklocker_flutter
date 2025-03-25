import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class AddProfileUseCase {
  final ProfileRepositoryImpl profileRepository;
  final ProfileEntity profileEntity;
  List<ProfileContactEntity> contacts;

  AddProfileUseCase({
    required this.profileRepository,
    required this.profileEntity,
    required this.contacts,
  });

  Future<Either<String, bool>> call() async {
    return profileRepository.addProfile(
      profileEntity,
      contacts,
    );
  }
}
