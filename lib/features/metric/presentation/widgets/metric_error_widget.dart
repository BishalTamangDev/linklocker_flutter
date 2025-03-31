import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/models/metric_model.dart';
import 'category_widget.dart';

class MetricErrorWidget extends StatelessWidget {
  const MetricErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // loading :: pie chart
        Center(
          child: SizedBox(
            height: 200.0,
            width: 200.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: 1, radius: 10, title: "", color: Theme.of(context).colorScheme.surface),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6.0,
                  children: [
                    Icon(Icons.refresh),
                    Text("An Error Occurred!", style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        ),

        // loading :: category data
        ListView.builder(
          shrinkWrap: true,
          itemCount: LinkCategoryEnum.values.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            MetricModel metricModel = MetricModel.fromMap({
              'title': LinkCategoryEnum.values[index].label,
              'color': LinkCategoryEnum.values[index].color,
              'count': '-',
            });
            return CategoryWidget(
              metricModel: metricModel,
              loading: true,
            );
          },
        ),
      ],
    );
  }
}
