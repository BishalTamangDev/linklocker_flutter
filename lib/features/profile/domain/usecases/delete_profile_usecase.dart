import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';

class DeleteProfileUseCase {
  final ProfileRepositoryImpl profileRepository;

  DeleteProfileUseCase({required this.profileRepository});

  Future<Either<String, bool>> call() async {
    return await profileRepository.deleteProfile();
  }
}
