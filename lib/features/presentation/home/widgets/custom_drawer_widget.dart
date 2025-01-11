import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:linklocker/features/presentation/home/widgets/drawer_category_widget.dart';

import '../../../../config/themes/theme_constants.dart';

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
    _chartData = LocalDataSource.getInstance().getLinks();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Drawer(
      width: mediaQuery.size.width / 1.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              // fl chart
              SizedBox(
                width: mediaQuery.size.width / 1.25,
                child: Column(
                  children: [
                    SizedBox(height: mediaQuery.padding.top * 2),
                    SizedBox(
                      width: mediaQuery.size.width / 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset('assets/images/pie_chart.png'),
                          CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Theme.of(context).canvasColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: mediaQuery.padding.top * 1.5),
                  ],
                ),
              ),

              // data
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  spacing: 16.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...AppConstants.categoryList.map(
                      (category) => DrawerCategoryWidget(categoryData: {
                        'title': category,
                        'count': Random().nextInt(80),
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // bottom
          //   reset database
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
            child: SizedBox(
              width: double.infinity,
              height: 44.0,
              child: OutlinedButton(
                onPressed: () {},
                child: Text(
                  "Reset List",
                  style: textTheme.bodyMedium!.copyWith(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
