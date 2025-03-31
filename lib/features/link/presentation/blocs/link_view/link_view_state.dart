part of 'link_view_bloc.dart';

@immutable
sealed class LinkViewState {}

// initial
final class LinkViewInitial extends LinkViewState {}

// action state
@immutable
sealed class LinkViewActionState extends LinkViewState {}

// loading
final class LinkViewLoadingState extends LinkViewState {}

// loaded
final class LinkViewLoadedState extends LinkViewState {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  LinkViewLoadedState({required this.linkEntity, required this.contacts});
}

// link not found
final class LinkViewLinkNotFoundState extends LinkViewState {}

// share contact
final class LinkViewContactShareActionState extends LinkViewActionState {
  final String shareText;

  LinkViewContactShareActionState({required this.shareText});
}

// qr share
final class LinkViewQrShareActionState extends LinkViewActionState {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  LinkViewQrShareActionState({required this.linkEntity, required this.contacts});
}

// open dialer
final class LinkViewOpenDialerActionState extends LinkViewActionState {
  final String contact;

  LinkViewOpenDialerActionState({required this.contact});
}

// deletion failure
final class LinkViewDeletionFailureActionState extends LinkViewActionState {
  final String message;

  LinkViewDeletionFailureActionState({required this.message});
}

// navigate
final class LinkViewDeleteSuccessActionState extends LinkViewActionState {}

// edit
final class LinkViewNavigateToUpdateActionState extends LinkViewActionState {
  final int linkId;

  LinkViewNavigateToUpdateActionState({required this.linkId});
}
