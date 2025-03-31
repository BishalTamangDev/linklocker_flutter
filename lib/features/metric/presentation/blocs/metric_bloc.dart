import 'package:bloc/bloc.dart';
import 'package:linklocker/features/metric/data/repository_impl/metric_repository_impl.dart';
import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';
import 'package:linklocker/features/metric/domain/usecases/fetch_metric_usecase.dart';
import 'package:meta/meta.dart';

part 'metric_event.dart';
part 'metric_state.dart';

class MetricBloc extends Bloc<MetricEvent, MetricState> {
  MetricBloc() : super(MetricInitial()) {
    on<MetricEvent>((event, emit) {});
    on<MetricFetchEvent>(_metricFetchEvent);
    on<MetricSettingNavigateEvent>(_metricSettingNavigateEvent);
  }

  // fetch metric
  Future<void> _metricFetchEvent(MetricFetchEvent event, Emitter<MetricState> emit) async {
    emit(MetricLoadingState());

    final MetricRepositoryImpl metricRepository = MetricRepositoryImpl();
    final FetchMetricUseCase fetchMetricUseCase = FetchMetricUseCase(metricRepository: metricRepository);

    final response = await fetchMetricUseCase.call();

    response.fold((res) {
      emit(MetricErrorState());
    }, (data) {
      if (data.isEmpty) {
        emit(MetricErrorState());
      } else {
        emit(MetricLoadedState(metricData: data));
      }
    });
  }

  // navigate to setting
  Future<void> _metricSettingNavigateEvent(
    MetricSettingNavigateEvent event,
    Emitter<MetricState> emit,
  ) async {
    emit(MetricSettingNavigateState());
  }
}
