part of 'all_links_bloc.dart';

@immutable
sealed class AllLinksState {}

// action state
@immutable
sealed class AllLinksActionState extends AllLinksState {}

// initial
final class AllLinksInitial extends AllLinksState {}

// fetching
final class AllLinksFetchingState extends AllLinksState {}

// fetched
final class AllLinksFetchedState extends AllLinksState {
  final List<Map<String, dynamic>> groupedLinks;

  AllLinksFetchedState({required this.groupedLinks});
}

// empty links
final class AllLinksEmptyState extends AllLinksState {}

// error in fetching links
final class AllLinksErrorState extends AllLinksState {}

// call
final class AllLinksCallActionState extends AllLinksActionState {
  final String number;

  AllLinksCallActionState({required this.number});
}

// show number options
final class AllLinksShowContactOptionActionState extends AllLinksActionState {
  final List<ContactEntity> contacts;

  AllLinksShowContactOptionActionState({required this.contacts});
}

// navigate to view page
final class AllLinksViewLinkNavigateActionState extends AllLinksActionState {
  final int linkId;

  AllLinksViewLinkNavigateActionState({required this.linkId});
}
