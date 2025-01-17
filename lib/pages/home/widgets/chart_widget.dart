import 'dart:developer' as developer;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linklocker/data/source/local/local_data_source.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_functions.dart';
import 'drawer_category_widget.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late Future<List<Map<String, dynamic>>> _chartData;

  @override
  void initState() {
    _chartData = LocalDataSource.getInstance().getCategorizedLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // fl chart
        FutureBuilder(
          future: _chartData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: 1,
                            radius: 10,
                            title: "",
                            color: Theme.of(context).colorScheme.surface,
                          )
                        ],
                      ),
                    ),
                    Text("An error occurred!"),
                  ],
                );
              } else {
                if (!snapshot.hasData) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: 1,
                              radius: 10,
                              title: "No data found!",
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      const Text("Empty!"),
                    ],
                  );
                } else {
                  developer.log("Chart data :: ${snapshot.data}");

                  bool empty = true;

                  if (snapshot.data != null) {
                    for (var chartData in snapshot.data!) {
                      if (chartData['count'] != 0) {
                        empty = false;
                      }
                    }
                  }

                  return empty
                      ? Column(
                          spacing: 32.0,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 200.0,
                                  width: 200.0,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: 1,
                                          radius: 10,
                                          title: "",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Text("Empty!"),
                              ],
                            ),
                            Column(
                              spacing: 16.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...AppConstants.categoryList.map(
                                  (category) => DrawerCategoryWidget(
                                    categoryData: {
                                      'title': category,
                                      'count': 0,
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      :

                      //   actual chart here
                      Column(
                          spacing: 32.0,
                          children: [
                            SizedBox(
                              width: 200.0,
                              height: 200.0,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    ...snapshot.data!.map(
                                      (chartData) {
                                        double value = double.parse(
                                            "${chartData['count']}");
                                        double radius = 12.0;

                                        String title =
                                            AppFunctions.getCapitalizedWords(
                                                chartData['category']);
                                        Color color =
                                            AppFunctions.getCategoryColor(
                                                chartData['category']);
                                        return PieChartSectionData(
                                          value: value,
                                          radius: radius,
                                          title: title,
                                          color: color,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              spacing: 16.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...snapshot.data!.map(
                                  (chartData) => DrawerCategoryWidget(
                                    categoryData: {
                                      'title': chartData['category'],
                                      'count': chartData['count'],
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                }
              }
            } else {
              //   loading
              return Column(
                spacing: 32.0,
                children: [
                  // loading :: pie chart
                  SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 1,
                                radius: 10,
                                title: "",
                                color: Theme.of(context).colorScheme.surface,
                              )
                            ],
                          ),
                        ),
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    ),
                  ),

                  // loading :: category data
                  Column(
                    spacing: 16.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...AppConstants.categoryList.map(
                        (category) => DrawerCategoryWidget(
                          categoryData: {
                            'title': category,
                            'count': '-',
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}

// Column(
//   spacing: 16.0,
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     ...AppConstants.categoryList.map(
//       (category) => DrawerCategoryWidget(
//         categoryData: {
//           'title':
//               AppFunctions.getCapitalizedWords(category),
//           'count': 0,
//         },
//       ),
//     ),
//   ],
// ),
