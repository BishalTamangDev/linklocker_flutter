import 'package:dartz/dartz.dart';
import 'package:linklocker/features/profile/data/repository_impl/profile_repository_impl.dart';

class FetchProfileUseCase {
  final ProfileRepositoryImpl profileRepository;

  const FetchProfileUseCase({required this.profileRepository});

  Future<Either<String, Map<String, dynamic>>> call() async {
    final response = await profileRepository.fetchProfile();
    return response.fold((failure) => Left(failure), (data) => Right(data));
  }
}
