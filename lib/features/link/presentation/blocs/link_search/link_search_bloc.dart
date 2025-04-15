import 'package:bloc/bloc.dart';
import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';
import 'package:linklocker/features/link/domain/usecases/search_link_usecase.dart';
import 'package:meta/meta.dart';

part 'link_search_event.dart';
part 'link_search_state.dart';

class LinkSearchBloc extends Bloc<LinkSearchEvent, LinkSearchState> {
  LinkSearchBloc() : super(LinkSearchInitial()) {
    on<LinkSearchEvent>((event, emit) {});
    on<LinkSearchInitialEvent>(_linkSearchInitialEvent);
    on<LinkSearchSearchEvent>(_linkSearchSearchEvent);
    on<LinkSearchClearEvent>(_linkSearchClearEvent);
  }

  // initial event
  Future<void> _linkSearchInitialEvent(LinkSearchEvent event, Emitter<LinkSearchState> emit) async {
    emit(LinkSearchInitial());
  }

  // search
  Future<void> _linkSearchSearchEvent(LinkSearchSearchEvent event, Emitter<LinkSearchState> emit) async {
    emit(LinkSearchSearchingState());

    final LinkRepositoryImpl linkRepositoryImpl = LinkRepositoryImpl();
    final SearchLinkUseCase searchLinkUseCase = SearchLinkUseCase(linkRepository: linkRepositoryImpl);

    final List<Map<String, dynamic>> links = await searchLinkUseCase.call(event.searchText);

    if (links.isEmpty) {
      emit(LinkSearchEmptyState());
    } else {
      emit(LinkSearchSearchedState(links));
    }
  }

  // clear search
  Future<void> _linkSearchClearEvent(LinkSearchClearEvent event, Emitter<LinkSearchState> emit) async {
    emit(LinkSearchInitial());
  }
}
