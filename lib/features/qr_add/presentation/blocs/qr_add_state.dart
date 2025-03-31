part of 'qr_add_bloc.dart';

@immutable
sealed class QrAddState {}

// action state
@immutable
sealed class QrAddActionState extends QrAddState {}

// initial state
final class QrAddInitial extends QrAddState {}

// scanning
final class QrAddScanningState extends QrAddState {}

// invalid qr
final class QrAddInvalidState extends QrAddState {}

// valid qr
final class QrAddValidState extends QrAddState {}

// navigate to add page
final class QrAddNavigateActionState extends QrAddActionState {
  final LinkEntity linkEntity;
  final List<ContactEntity> contacts;

  QrAddNavigateActionState({required this.linkEntity, required this.contacts});
}

// invalid qr action state
final class QrAddInvalidActionState extends QrAddActionState {}
