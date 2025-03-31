import 'package:dartz/dartz.dart';
import 'package:linklocker/core/data/source/local/local_data_source.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';

import '../../domain/repositories/link_repository.dart';

class LinkRepositoryImpl implements LinkRepository {
  // add link
  @override
  Future<bool> add(LinkEntity linkEntity, List<ContactEntity> contacts) async {
    return await LocalDataSource.getInstance().addLink(linkEntity, contacts);
  }

  // update link
  @override
  Future<bool> update(LinkEntity linkEntity, List<ContactEntity> contacts) async {
    return await LocalDataSource.getInstance().updateLink(linkEntity, contacts);
  }

  // fetch link
  @override
  Future<Either<bool, List<Map<String, dynamic>>>> fetch(int linkId) async {
    return await LocalDataSource.getInstance().fetchCompleteLink(linkId);
  }

  // fetch all links
  @override
  Future<Either<bool, List<Map<String, dynamic>>>> fetchAll() async {
    return await LocalDataSource.getInstance().getGroupedLinks();
  }

  // search link
  @override
  Future<List<Map<String, dynamic>>> search(String searchText) async {
    try {
      int.parse(searchText);
      return await LocalDataSource.getInstance().searchLinkByContact(searchText);
    } catch (e) {
      return await LocalDataSource.getInstance().searchLinkByName(searchText);
    }
  }

  // delete link
  @override
  Future<bool> delete(int linkId) async {
    return await LocalDataSource.getInstance().deleteLink(linkId);
  }
}
