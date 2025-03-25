part of 'add_profile_bloc.dart';

@immutable
sealed class AddProfileEvent {}

// initial
final class AddProfileLoadEvent extends AddProfileEvent {
  final String task;

  AddProfileLoadEvent({required this.task});
}

// add event
final class AddProfileAddEvent extends AddProfileEvent {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  AddProfileAddEvent({
    required this.profileEntity,
    required this.contacts,
  });
}

// update event
final class AddProfileUpdateEvent extends AddProfileEvent {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  AddProfileUpdateEvent({
    required this.profileEntity,
    required this.contacts,
  });
}

// profile added
final class AddProfileAddedEvent extends AddProfileEvent {}

// show snack bar
final class AddProfileSnackBarEvent extends AddProfileEvent {
  final String message;

  AddProfileSnackBarEvent({required this.message});
}
