part of 'link_search_bloc.dart';

@immutable
sealed class LinkSearchState {}

// action state
@immutable
sealed class LinkSearchActionState extends LinkSearchState {}

// initial state
final class LinkSearchInitial extends LinkSearchState {}

// searching
final class LinkSearchSearchingState extends LinkSearchState {}

// searched
final class LinkSearchSearchedState extends LinkSearchState {
  final List<Map<String, dynamic>> links;

  LinkSearchSearchedState(this.links);
}

// error state
final class LinkSearchErrorState extends LinkSearchState {}

// not found
final class LinkSearchEmptyState extends LinkSearchState {}

// action states
// navigate to view page
final class LinkSearchViewNavigateActionState extends LinkSearchActionState {}

// shoe contact option
final class LinkSearchCallActionState extends LinkSearchActionState {}

// open dialer
final class LinkSearchContactOptionActionState extends LinkSearchActionState {}
