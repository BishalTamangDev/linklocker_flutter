part of 'all_links_bloc.dart';

@immutable
sealed class AllLinksEvent {}

// fetched event
class AllLinksFetchEvent extends AllLinksEvent {}

// navigate to view page
class AllLinksViewLinkNavigateEvent extends AllLinksEvent {}

// open dialer
class AllLinksOpenDialerEvent extends AllLinksEvent {
  final List<ContactEntity> contacts;

  AllLinksOpenDialerEvent({required this.contacts});
}
