part of 'link_add_bloc.dart';

@immutable
sealed class LinkAddState {}

// initial state
final class LinkAddInitial extends LinkAddState {}

// action state
@immutable
sealed class LinkAddActionState extends LinkAddState {}

// loading
final class LinkAddLoadingState extends LinkAddState {}

// loaded
final class LinkAddLoadedState extends LinkAddState {
  final String task;
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  LinkAddLoadedState({required this.task, required this.linkEntity, required this.contacts});
}

// link not found
final class LinkAddLinkNotFoundState extends LinkAddState {}

// adding
final class LinkAddAddingState extends LinkAddState {}

// added
final class LinkAddAddedActionState extends LinkAddActionState {}

// adding
final class LinkAddAddingErrorActionState extends LinkAddActionState {
  final String message;

  LinkAddAddingErrorActionState({required this.message});
}

// updated
final class LinkAddUpdatedActionState extends LinkAddActionState {
  final int linkId;

  LinkAddUpdatedActionState({required this.linkId});
}

// updating error
final class LinkAddUpdatingErrorActionState extends LinkAddActionState {
  final String message;

  LinkAddUpdatingErrorActionState({required this.message});
}

// reset
final class LinkAddResetActionState extends LinkAddActionState {}

// backup
final class LinkAddBackupActionState extends LinkAddActionState {}
