part of 'link_search_bloc.dart';

@immutable
sealed class LinkSearchEvent {}

// initial event
final class LinkSearchInitialEvent extends LinkSearchEvent {}

// search
final class LinkSearchSearchEvent extends LinkSearchEvent {
  final String searchText;

  LinkSearchSearchEvent({required this.searchText});
}

// clear search
final class LinkSearchClearEvent extends LinkSearchEvent {}
