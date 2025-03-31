import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';

class SearchLinkUseCase {
  final LinkRepositoryImpl linkRepository;

  SearchLinkUseCase({required this.linkRepository});

  Future<List<Map<String, dynamic>>> call(String searchText) async {
    return await linkRepository.search(searchText);
  }
}
