import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/app_functions.dart';

class DrawerCategoryWidget extends StatelessWidget {
  const DrawerCategoryWidget({super.key, required this.categoryData});

  final Map<String, dynamic> categoryData;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: AppFunctions.getCategoryColor(categoryData['title']),
        ),
        Expanded(
          child: Text(
            AppFunctions.getCapitalizedWord(categoryData['title']),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            categoryData['count'].toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

//   get colors
  Color getCategoryColor() {
    return Colors.red;
  }
}
