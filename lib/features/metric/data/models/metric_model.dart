import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';

class MetricModel extends MetricEntity {
  MetricModel({required super.title, required super.count});

  // to map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'count': count,
    };
  }

  // from map
  factory MetricModel.fromMap(Map<String, dynamic> map) {
    return MetricModel(
      title: map['title'],
      count: map['count'],
    );
  }

  // from entity
  factory MetricModel.fromEntity(MetricEntity metricEntity) {
    return MetricModel(
      title: metricEntity.title,
      count: metricEntity.count,
    );
  }

  // to entity
  MetricEntity toEntity() {
    return MetricEntity(
      title: title,
      count: count,
    );
  }
}
