import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          spacing: 12.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.hourglass_empty_outlined,
              color: Colors.red,
            ),
            Text("No link found!"),
          ],
        ),
      );
}
