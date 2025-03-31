import 'package:dartz/dartz.dart';
import 'package:linklocker/features/metric/data/repository_impl/metric_repository_impl.dart';
import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';

class FetchMetricUseCase {
  final MetricRepositoryImpl metricRepository;

  FetchMetricUseCase({required this.metricRepository});

  Future<Either<bool, List<MetricEntity>>> call() async {
    return await metricRepository.fetch();
  }
}
