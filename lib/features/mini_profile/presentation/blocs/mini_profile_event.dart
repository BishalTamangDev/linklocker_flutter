part of 'mini_profile_bloc.dart';

@immutable
sealed class MiniProfileEvent {}

// load profile
final class MiniProfileFetchEvent extends MiniProfileEvent {}

// qr
final class MiniProfileQrShareEvent extends MiniProfileEvent {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  MiniProfileQrShareEvent({
    required this.profileEntity,
    required this.contacts,
  });
}

// navigate to add page :: setup
final class MiniProfileAddNavigateEvent extends MiniProfileEvent {}

//  navigate to view page
final class MiniProfileViewNavigateEvent extends MiniProfileEvent {}
