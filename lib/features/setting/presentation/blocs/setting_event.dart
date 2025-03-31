part of 'setting_bloc.dart';

@immutable
sealed class SettingEvent {}

// delete profile
final class SettingResetProfileEvent extends SettingEvent {}

// delete all links
final class SettingResetLinkEvent extends SettingEvent {}

// delete everything
final class SettingResetEverythingEvent extends SettingEvent {}
