part of 'add_profile_bloc.dart';

@immutable
sealed class AddProfileState {}

// Initial state
final class AddProfileInitial extends AddProfileState {}

// Loading state
final class AddProfileLoadingState extends AddProfileState {}

// Loaded state
final class AddProfileLoadedState extends AddProfileState {
  final String task;
  final ProfileEntity profileEntity;
  final ProfileContactEntity profileContactEntity;

  AddProfileLoadedState({
    required this.task,
    required this.profileEntity,
    required this.profileContactEntity,
  });
}

// loading error
final class AddProfileLoadErrorState extends AddProfileState {
  final String error;

  AddProfileLoadErrorState(this.error);
}

// Profile added state
final class AddProfileAddedState extends AddProfileState {}

// Action states
@immutable
sealed class AddProfileActionState extends AddProfileState {}

// SnackBar Action state
final class AddProfileSnackBarActionState extends AddProfileActionState {
  final String message;

  AddProfileSnackBarActionState(this.message);
}

// navigate to home page
final class AddProfileHomeNavigateActionState extends AddProfileActionState {}

// navigate to view page
final class AddProfileViewNavigateActionState extends AddProfileActionState {}
