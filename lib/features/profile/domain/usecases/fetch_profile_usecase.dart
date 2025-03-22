import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class FetchProfileUseCase {
  final ProfileRepositoryImpl profileRepository;
  final ProfileEntity profileEntity;

  const FetchProfileUseCase(
      {required this.profileRepository, required this.profileEntity});

  Future<bool> call() async {
    return true;
  }
}
