part of 'metric_bloc.dart';

@immutable
sealed class MetricEvent {}

// fetch
final class MetricFetchEvent extends MetricEvent {}

// navigate to setting page
final class MetricSettingNavigateEvent extends MetricEvent {}
