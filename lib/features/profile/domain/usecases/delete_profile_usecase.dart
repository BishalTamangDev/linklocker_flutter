import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';

class DeleteProfileUseCase {
  final ProfileRepositoryImpl profileRepository;

  DeleteProfileUseCase(this.profileRepository);

  Future<bool> call() async {
    return await profileRepository.deleteProfile();
  }
}
