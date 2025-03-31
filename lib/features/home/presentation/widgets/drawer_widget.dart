import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../metric/presentation/widgets/metric_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            spacing: 16.0,
            children: [
              Expanded(
                child: MetricWidget(),
              ),

              // setting
              SizedBox(
                height: 45.0,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.pop();
                    context.push('/setting');
                  },
                  child: const Text("Setting"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
