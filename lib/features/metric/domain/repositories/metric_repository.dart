import 'package:dartz/dartz.dart';
import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';

abstract class MetricRepository {
  // fetch
  Future<Either<bool, List<MetricEntity>>> fetch();
}
