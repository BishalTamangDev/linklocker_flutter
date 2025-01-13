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
    return Drawer(
      width: mediaQuery.size.width / 1.25,
      child: SingleChildScrollView(
        child: Column(
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
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mediaQuery.padding.top * 1.5),
                ],
              ),
            ),

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
