import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linklocker/config/routes/app_router.dart';
import 'package:linklocker/config/themes/theme_constants.dart';
import 'package:linklocker/features/link/presentation/blocs/all_links/all_links_bloc.dart';
import 'package:linklocker/features/link/presentation/blocs/link_add/link_add_bloc.dart';
import 'package:linklocker/features/link/presentation/blocs/link_search/link_search_bloc.dart';
import 'package:linklocker/features/link/presentation/blocs/link_view/link_view_bloc.dart';
import 'package:linklocker/features/metric/presentation/blocs/metric_bloc.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/setting/presentation/blocs/setting_bloc.dart';

import 'features/profile/presentation/blocs/add_profile/add_profile_bloc.dart';
import 'features/profile/presentation/blocs/view_profile/view_profile_bloc.dart';

class LinkLocker extends StatelessWidget {
  const LinkLocker({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // all links
        BlocProvider(
          create: (state) => AllLinksBloc()..add(AllLinksFetchEvent()),
        ),

        // add profile bloc
        BlocProvider(
          create: (context) => AddProfileBloc()..add(AddProfileLoadEvent(task: 'add')),
        ),

        // view profile bloc
        BlocProvider(
          create: (context) => ViewProfileBloc()..add(ViewProfileFetchEvent()),
        ),

        // mini profile
        BlocProvider(
          create: (context) => MiniProfileBloc()..add(MiniProfileFetchEvent()),
        ),

        // add link bloc
        BlocProvider(
          create: (context) => LinkAddBloc(),
        ),

        // view link bloc
        BlocProvider(
          create: (context) => LinkViewBloc(),
        ),

        // search
        BlocProvider(
          create: (context) => LinkSearchBloc(),
        ),

        // metric
        BlocProvider(
          create: (context) => MetricBloc()..add(MetricFetchEvent()),
        ),

        // setting
        BlocProvider(
          create: (context) => SettingBloc(),
        ),
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
