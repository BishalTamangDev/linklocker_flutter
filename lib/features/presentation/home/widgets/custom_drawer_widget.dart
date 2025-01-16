import 'dart:math';
import 'dart:developer' as developer;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/constants/app_functions.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/drawer_category_widget.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({super.key});

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  late Future<List<Map<String, dynamic>>> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = LocalDataSource.getInstance().getCategorizedLinks();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: mediaQuery.size.width / 1.25,
      child: SingleChildScrollView(
        child: Column(
          spacing: 16.0,
          children: [
            const SizedBox(height: 44.0),

            // fl chart
            SizedBox(
              width: mediaQuery.size.width / 2,
              height: mediaQuery.size.width / 2,
              child: FutureBuilder(
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
                                  color: colorScheme.surface,
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
                                    color: colorScheme.surface,
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
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: 1,
                                          radius: 10,
                                          title: "",
                                          color: colorScheme.surface,
                                        )
                                      ],
                                    ),
                                  ),
                                  const Text("Empty!"),
                                ],
                              )
                            :
                            //   actual chart here
                            PieChart(
                                PieChartData(
                                  sections: [
                                    ...snapshot.data!.map(
                                      (chartData) {
                                        double value = double.parse(
                                            "${chartData['count']}");
                                        double radius = 5.0;

                                        if (value > 5) {
                                          radius = (value < 40)
                                              ? double.parse(
                                                  "${chartData['count']}")
                                              : 40.0;
                                        }

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
                              );
                      }
                    }
                  } else {
                    //   loading
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
                                color: colorScheme.surface,
                              )
                            ],
                          ),
                        ),
                        CircularProgressIndicator(
                          color: colorScheme.surface,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 16.0),

            // category index
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: FutureBuilder(
                future: _chartData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Icon(Icons.error);
                    } else {
                      return Column(
                        spacing: 16.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...snapshot.data!.map(
                            (category) => DrawerCategoryWidget(
                              categoryData: {
                                'title': category['category'],
                                'count': category['count'],
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Column(
                      spacing: 16.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...AppConstants.categoryList.map(
                          (category) => DrawerCategoryWidget(
                            categoryData: {
                              'title':
                                  AppFunctions.getCapitalizedWords(category),
                              'count': 0,
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
