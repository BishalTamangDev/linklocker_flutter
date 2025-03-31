import 'package:dartz/dartz.dart';
import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';

class AddLinkUseCase {
  final LinkRepositoryImpl linkRepository;

  AddLinkUseCase({required this.linkRepository});

  Future<bool> call(LinkEntity linkEntity, List<ContactEntity> contacts) async {
    return await linkRepository.add(linkEntity, contacts);
  }
}
