part of 'metric_bloc.dart';

@immutable
sealed class MetricState {}

final class MetricInitial extends MetricState {}

// action state
sealed class MetricActionState extends MetricState {}

// loading
final class MetricLoadingState extends MetricState {}

// loaded
final class MetricLoadedState extends MetricState {
  final List<MetricEntity> metricData;

  MetricLoadedState(this.metricData);
}

// error
final class MetricErrorState extends MetricState {}

// navigate to setting page
final class MetricSettingNavigateState extends MetricActionState {}
