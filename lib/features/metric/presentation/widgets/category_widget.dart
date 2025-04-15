import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/metric/data/models/metric_model.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.metricModel, this.loading = false});

  final bool loading;
  final MetricModel metricModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8.0,
          children: [
            Container(color: LinkCategoryEnum.getCategoryFromLabel(metricModel.title)!.color, width: 14, height: 14),
            Expanded(
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  metricModel.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Text(loading ? '-' : metricModel.count.toString()),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
