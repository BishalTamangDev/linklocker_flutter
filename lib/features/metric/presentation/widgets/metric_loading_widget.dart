import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linklocker/features/metric/data/models/metric_model.dart';
import 'package:linklocker/features/metric/presentation/widgets/category_widget.dart';

import '../../../../core/constants/app_constants.dart';

class MetricLoadingWidget extends StatelessWidget {
  const MetricLoadingWidget({super.key});

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
                CircularProgressIndicator(color: Theme.of(context).colorScheme.surface),
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
            final MetricModel metricModel = MetricModel.fromMap({
              'title': LinkCategoryEnum.values[index].label,
              'count': 0,
            });
            return CategoryWidget(metricModel: metricModel, loading: true);
          },
        ),
      ],
    );
  }
}
