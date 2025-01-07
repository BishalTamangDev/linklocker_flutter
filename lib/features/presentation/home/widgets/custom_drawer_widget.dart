import 'package:flutter/material.dart';

import '../../../../config/themes/theme_constants.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

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
                      child: Image.asset('assets/images/pie_chart.png'),
                    ),
                    SizedBox(height: mediaQuery.padding.top),
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
                    // family
                    Row(
                      spacing: 12.0,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16.0,
                          width: 16.0,
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Text(
                            "Family",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "100",
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),

                    //   friend
                    Row(
                      spacing: 12.0,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16.0,
                          width: 16.0,
                          color: Colors.green,
                        ),
                        Expanded(
                          child: Text(
                            "Friends",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "54",
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),

                    // teachers
                    Row(
                      spacing: 12.0,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16.0,
                          width: 16.0,
                          color: Colors.orange,
                        ),
                        Expanded(
                          child: Text(
                            "Teachers",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "76",
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),

                    //   others
                    Row(
                      spacing: 12.0,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16.0,
                          width: 16.0,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Text(
                            "Others",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Text(
                            "9",
                            style: textTheme.titleLarge,
                          ),
                        ),
                      ],
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
                child: Text("Reset Contact List"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
