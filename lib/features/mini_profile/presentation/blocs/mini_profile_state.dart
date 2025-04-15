part of 'mini_profile_bloc.dart';

@immutable
sealed class MiniProfileState {}

final class MiniProfileInitial extends MiniProfileState {}

// action state
@immutable
sealed class MiniProfileActionState extends MiniProfileState {}

// loading
final class MiniProfileLoadingState extends MiniProfileState {}

// loaded
final class MiniProfileLoadedState extends MiniProfileState {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  MiniProfileLoadedState({
    required this.profileEntity,
    required this.contacts,
  });
}

// profile not set
final class MiniProfileNotSetState extends MiniProfileState {}

// load error
final class MiniProfileErrorState extends MiniProfileState {
  final String message;

  MiniProfileErrorState(this.message);
}

// show qr
final class MiniProfileQrShareState extends MiniProfileActionState {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  MiniProfileQrShareState({
    required this.profileEntity,
    required this.contacts,
  });
}

// navigate to add :: setup
final class MiniProfileAddNavigateState extends MiniProfileActionState {}

// navigate to view
final class MiniProfileViewNavigateState extends MiniProfileActionState {}
