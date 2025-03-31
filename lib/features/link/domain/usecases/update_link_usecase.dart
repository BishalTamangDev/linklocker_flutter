import '../../data/repository_impl/link_repository_impl.dart';
import '../entities/contact_entity.dart';
import '../entities/link_entity.dart';

class UpdateLinkUseCase {
  final LinkRepositoryImpl linkRepository;

  UpdateLinkUseCase({required this.linkRepository});

  Future<bool> call(
    LinkEntity linkEntity,
    List<ContactEntity> contacts,
  ) async {
    return await linkRepository.update(linkEntity, contacts);
  }
}
