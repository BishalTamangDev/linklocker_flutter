part of 'view_profile_bloc.dart';

@immutable
sealed class ViewProfileState {}

// action states
@immutable
sealed class ViewProfileActionState extends ViewProfileState {}

// initial state
final class ViewProfileInitial extends ViewProfileState {}

// loading
final class ViewProfileLoadingState extends ViewProfileState {}

// loaded state
final class ViewProfileLoadedState extends ViewProfileState {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  ViewProfileLoadedState({
    required this.profileEntity,
    required this.contacts,
  });
}

// profile not found
final class ViewProfileProfileNotFoundState extends ViewProfileState {}

// share contact through qr
final class ViewProfileQrActionState extends ViewProfileActionState {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  ViewProfileQrActionState({
    required this.profileEntity,
    required this.contacts,
  });
}

// share contact
final class ViewProfileContactShareActionState extends ViewProfileActionState {
  final String shareText;

  ViewProfileContactShareActionState({required this.shareText});
}

// navigate to edit
final class ViewProfileNavigateToEditPageActionState extends ViewProfileActionState {}

// navigate to home page
final class ViewProfileNavigateToHomePageActionState extends ViewProfileActionState {}

// snack bar
final class ViewProfileSnackBarActionState extends ViewProfileActionState {
  final String message;

  ViewProfileSnackBarActionState({required this.message});
}
