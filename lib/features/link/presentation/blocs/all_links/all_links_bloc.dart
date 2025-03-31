import 'package:bloc/bloc.dart';
import 'package:linklocker/features/link/data/repository_impl/link_repository_impl.dart';
import 'package:linklocker/features/link/domain/entities/contact_entity.dart';
import 'package:linklocker/features/link/domain/usecases/fetch_all_links_usecase.dart';
import 'package:meta/meta.dart';

part 'all_links_event.dart';

part 'all_links_state.dart';

class AllLinksBloc extends Bloc<AllLinksEvent, AllLinksState> {
  AllLinksBloc() : super(AllLinksInitial()) {
    // on<AllLinksEvent>((event, emit) {});
    on<AllLinksFetchEvent>(_allLinksFetchEvent);
  }

  // fetch all links
  Future<void> _allLinksFetchEvent(AllLinksFetchEvent event, Emitter<AllLinksState> emit) async {
    emit(AllLinksFetchingState());

    final LinkRepositoryImpl linkRepository = LinkRepositoryImpl();
    final FetchAllLinksUseCase fetchAllLinksUseCase = FetchAllLinksUseCase(linkRepository: linkRepository);

    final response = await fetchAllLinksUseCase.call();

    response.fold((error) {
      emit(AllLinksErrorState());
    }, (data) {
      if (data.isEmpty) {
        emit(AllLinksEmptyState());
      } else {
        emit(AllLinksFetchedState(groupedLinks: data));
      }
    });
  }
}
