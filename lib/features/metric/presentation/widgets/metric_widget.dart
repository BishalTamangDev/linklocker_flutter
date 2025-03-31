import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linklocker/features/metric/presentation/blocs/metric_bloc.dart';
import 'package:linklocker/features/metric/presentation/widgets/metric_error_widget.dart';
import 'package:linklocker/features/metric/presentation/widgets/metric_loaded_widget.dart';
import 'package:linklocker/features/metric/presentation/widgets/metric_loading_widget.dart';

class MetricWidget extends StatelessWidget {
  const MetricWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricBloc, MetricState>(
      builder: (context, state) {
        if (state is MetricErrorState) {
          return MetricErrorWidget();
        } else if (state is MetricLoadedState) {
          return MetricLoadedWidget(
            metrics: state.metricData,
          );
        } else {
          return MetricLoadingWidget();
        }
      },
    );

    Column(
      spacing: 32.0,
      children: [
        SizedBox(
          width: 200.0,
          height: 200.0,
          child: PieChart(
            PieChartData(
              sections: [
                // ...snapshot.data!.map(
                //   (chartData) {
                //     double value = double.parse("${chartData['count']}");
                //     double radius = 12.0;
                //
                //     String title = AppFunctions.getCapitalizedWords(chartData['category']);
                //     Color color = AppFunctions.getCategoryColor(chartData['category']);
                //     return PieChartSectionData(
                //       value: value,
                //       radius: radius,
                //       title: title,
                //       color: color,
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
        Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // show category widgets
          ],
        ),
      ],
    );
  }
}
