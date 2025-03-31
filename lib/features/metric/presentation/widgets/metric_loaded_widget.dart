import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/metric/domain/entities/metric_entity.dart';

import '../../data/models/metric_model.dart';
import 'category_widget.dart';

class MetricLoadedWidget extends StatelessWidget {
  const MetricLoadedWidget({super.key, required this.metrics});

  final List<MetricEntity> metrics;

  @override
  Widget build(BuildContext context) {
    int linkCount = 0;

    for (var metric in metrics) {
      linkCount += metric.count;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            height: 200.0,
            width: 200.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(sections: [
                    PieChartSectionData(value: 1, radius: 10, title: "", color: Theme.of(context).colorScheme.surface),
                  ]),
                ),
                PieChart(
                  PieChartData(
                    sections: [
                      ...metrics.map((metric) {
                        return PieChartSectionData(
                          value: metric.count.toDouble(),
                          radius: 10.0,
                          title: "",
                          color: LinkCategoryEnum.getCategoryFromLabel(metric.title)?.color,
                        );
                      }),
                    ],
                  ),
                ),
                // CircularProgressIndicator(color: Theme.of(context).colorScheme.surface),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32.0),
        ListView.builder(
          shrinkWrap: true,
          itemCount: metrics.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CategoryWidget(metricModel: MetricModel.fromEntity(metrics[index]));
          },
        ),
        Divider(
          height: 6.0,
          color: Theme.of(context).colorScheme.surface,
        ),
        Row(
          children: [
            Expanded(
              child: Text("Total"),
            ),
            Text(
              linkCount.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }
}
