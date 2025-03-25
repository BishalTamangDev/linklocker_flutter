import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linklocker/config/routes/app_router.dart';
import 'package:linklocker/config/themes/theme_constants.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';

import 'features/profile/presentation/blocs/add_profile/add_profile_bloc.dart';
import 'features/profile/presentation/blocs/view_profile/view_profile_bloc.dart';

class LinkLocker extends StatelessWidget {
  const LinkLocker({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // add profile bloc
        BlocProvider(
          // create: (context) =>AddProfileBloc()..add(AddProfileLoadEvent(task: 'add')),
          create: (context) =>
              AddProfileBloc()..add(AddProfileLoadEvent(task: 'add')),
        ),

        // view profile bloc
        BlocProvider(
          // create: (context) => ViewProfileBloc()..add(ViewProfileFetchEvent())),
          create: (context) => ViewProfileBloc(),
        ),

        // mini profile
        BlocProvider(
            create: (context) =>
                MiniProfileBloc()..add(MiniProfileFetchEvent())),
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
