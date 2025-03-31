part of 'link_add_bloc.dart';

@immutable
sealed class LinkAddEvent {}

// load && refresh
final class LinkLoadEvent extends LinkAddEvent {
  final String task;
  final int linkId;

  LinkLoadEvent({required this.task, required this.linkId});
}

// add link
final class LinkAddAddEvent extends LinkAddEvent {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  LinkAddAddEvent({required this.linkEntity, required this.contacts});
}

// qr add
final class LinkAddQrDataLoadEvent extends LinkAddEvent {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  LinkAddQrDataLoadEvent({required this.linkEntity, required this.contacts});
}

// update link
final class LinkAddUpdateEvent extends LinkAddEvent {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  LinkAddUpdateEvent({required this.linkEntity, required this.contacts});
}

// reset link
final class LinkAddResetEvent extends LinkAddEvent {}

// backup link
final class LinkAddBackupEvent extends LinkAddEvent {}
