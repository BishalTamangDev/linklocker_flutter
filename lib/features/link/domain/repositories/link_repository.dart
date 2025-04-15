import 'package:dartz/dartz.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/entities/link_entity.dart';

abstract class LinkRepository {
  // add link
  Future<bool> add({required LinkEntity linkEntity, required List<ContactEntity> contacts});

  // update link
  Future<bool> update({required LinkEntity linkEntity, required List<ContactEntity> contacts});

  // fetch link
  Future<Either<bool, List<Map<String, dynamic>>>> fetch(int linkId);

  // fetch all link
  Future<Either<bool, List<Map<String, dynamic>>>> fetchAll();

  // search link
  Future<List<Map<String, dynamic>>> search(String searchText);

  // delete link
  Future<bool> delete(int linkId);
}
