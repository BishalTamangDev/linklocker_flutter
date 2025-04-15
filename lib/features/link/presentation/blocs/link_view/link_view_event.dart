part of 'link_view_bloc.dart';

@immutable
sealed class LinkViewEvent {}

// fetch
final class FetchEvent extends LinkViewEvent {
  final int linkId;

  FetchEvent(this.linkId);
}

// contact share
final class ContactShareEvent extends LinkViewEvent {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  ContactShareEvent({required this.linkEntity, required this.contacts});
}

// qr share
final class QrShareEvent extends LinkViewEvent {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  QrShareEvent({required this.linkEntity, required this.contacts});
}

// open dialer
final class DialerEvent extends LinkViewEvent {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  DialerEvent({required this.linkEntity, required this.contacts});
}

// delete
final class DeleteLinkEvent extends LinkViewEvent {
  final int linkId;

  DeleteLinkEvent(this.linkId);
}

// navigate to update page
final class UpdateNavigateEvent extends LinkViewEvent {
  final int linkId;

  UpdateNavigateEvent(this.linkId);
}
