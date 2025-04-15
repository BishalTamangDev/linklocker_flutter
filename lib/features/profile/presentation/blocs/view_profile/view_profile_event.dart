part of 'view_profile_bloc.dart';

@immutable
sealed class ViewProfileEvent {}

// fetch profile
final class ViewProfileFetchEvent extends ViewProfileEvent {}

// delete profile
final class ViewProfileDeleteProfileEvent extends ViewProfileEvent {}

// navigate to edit page
final class ViewProfileEditPageNavigateEvent extends ViewProfileEvent {}

// share contact through qr
final class ViewProfileQrEvent extends ViewProfileEvent {
  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  ViewProfileQrEvent({required this.profileEntity, required this.contacts});
}

// share contact
final class ViewProfileContactShareEvent extends ViewProfileEvent {
  final Map<String, dynamic> data;

  ViewProfileContactShareEvent(this.data);
}
