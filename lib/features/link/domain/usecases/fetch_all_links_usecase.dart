import 'package:dartz/dartz.dart';
import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';

class FetchAllLinksUseCase {
  final LinkRepositoryImpl linkRepository;

  FetchAllLinksUseCase({required this.linkRepository});

  Future<Either<bool, List<Map<String, dynamic>>>> call() async {
    return await linkRepository.fetchAll();
  }
}
