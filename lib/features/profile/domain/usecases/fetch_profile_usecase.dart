import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';

class FetchProfileUseCase {
  final ProfileRepositoryImpl profileRepository;

  const FetchProfileUseCase(this.profileRepository);

  Future<Either<bool, List<Map<String, dynamic>>>> call() async {
    return await profileRepository.fetchProfile();
  }
}
