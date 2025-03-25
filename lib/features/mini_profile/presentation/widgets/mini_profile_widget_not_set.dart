import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/mini_profile_bloc.dart';

class MiniProfileWidgetNotSet extends StatelessWidget {
  const MiniProfileWidgetNotSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
          bottom: 6.0,
        ),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 12.0),
            Opacity(
              opacity: 0.6,
              child: const Text("You haven't set your profile yet!"),
            ),
            TextButton(
              onPressed: () => context
                  .read<MiniProfileBloc>()
                  .add(MiniProfileAddNavigateEvent()),
              child: const Text("Setup Now"),
            ),
          ],
        ),
      ),
    );
  }
}
