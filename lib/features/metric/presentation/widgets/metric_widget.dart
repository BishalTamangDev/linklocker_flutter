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
        switch (state) {
          case MetricErrorState():
            return const MetricErrorWidget();
          case MetricLoadedState():
            return MetricLoadedWidget(metrics: state.metricData);
          default:
            return const MetricLoadingWidget();
        }
      },
    );
  }
}
