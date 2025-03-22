import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

class AddProfileUseCase {
  final ProfileRepositoryImpl profileRepository;
  final ProfileEntity profileEntity;

  const AddProfileUseCase(
      {required this.profileRepository, required this.profileEntity});

  Future<bool> call() async {
    return true;
  }
}
