import 'package:dartz/dartz.dart';
import 'package:linklocker/core/data/source/local/local_data_source.dart';
import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';
import 'package:linklocker/features/metric/domain/repositories/metric_repository.dart';

class MetricRepositoryImpl implements MetricRepository {
  // fetch metric data
  @override
  Future<Either<bool, List<MetricEntity>>> fetch() async {
    return await LocalDataSource.getInstance().getMetricData();
  }
}
