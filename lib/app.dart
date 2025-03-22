import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linklocker/config/routes/app_router.dart';
import 'package:linklocker/config/themes/theme_constants.dart';

import 'features/profile/presentation/blocs/add_profile/add_profile_bloc.dart';

class LinkLocker extends StatelessWidget {
  const LinkLocker({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddProfileBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        title: "LinkLocker",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
