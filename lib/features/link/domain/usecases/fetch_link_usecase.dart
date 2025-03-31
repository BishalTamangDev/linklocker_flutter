import 'package:dartz/dartz.dart';

import '../../data/repository_impl/link_repository_impl.dart';

class FetchLinkUseCase {
  final LinkRepositoryImpl linkRepository;

  FetchLinkUseCase({required this.linkRepository});

  Future<Either<bool, List<Map<String, dynamic>>>> call(int linkId) async {
    return await linkRepository.fetch(linkId);
  }
}
