import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';

class DeleteLinkUseCase {
  final LinkRepositoryImpl linkRepository;

  DeleteLinkUseCase({required this.linkRepository});

  Future<bool> call(int linkId) async {
    return await linkRepository.delete(linkId);
  }
}
