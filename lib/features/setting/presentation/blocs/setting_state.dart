part of 'setting_bloc.dart';

@immutable
sealed class SettingState {}

// action state
@immutable
sealed class SettingActionState extends SettingState {}

// initial state
final class SettingInitial extends SettingState {}

// reset profile
final class SettingResetProfileActionState extends SettingActionState {
  final bool response;

  SettingResetProfileActionState({required this.response});
}

// reset links
final class SettingResetLinkActionState extends SettingActionState {
  final bool response;

  SettingResetLinkActionState({required this.response});
}

// reset everything
final class SettingResetEverythingActionState extends SettingActionState {
  final bool response;

  SettingResetEverythingActionState({required this.response});
}
