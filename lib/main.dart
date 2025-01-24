import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cubits/regions/cubit.dart';
import 'cubits/connectivity/connectivity_cubit.dart';
import 'language/cubit/language_cubit.dart';
import 'route/route_constants.dart';
import 'route/router.dart';
import 'screens/profile/cubit/cubit/phone_number_cubit.dart';
import 'screens/update_required/update_required_screen.dart';
import 'services/app_version_service.dart';
import 'database/seed_local_db.dart';
import 'services/preferences_service.dart';
import 'cubits/auth/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initial check at startup
  final appVersionService = AppVersionService();
  final versionCheck = await appVersionService.checkVersion();

  if (versionCheck.needsUpdate && versionCheck.forceUpdate) {
    runApp(MaterialApp(
      home: UpdateRequiredScreen(
        appVersion: versionCheck.appVersion!,
        forceUpdate: true,
      ),
    ));
    return;
  }

  // Use the service instead
  final isFirstLaunch = await PreferencesService.isFirstLaunch();

  if (isFirstLaunch) {
    await SeedLocalDb().seedAll();
    await PreferencesService.setFirstLaunch(false);
  }

  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegionCubit()..initialize(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(create: (context) => PhoneNumberCubit()),
        BlocProvider(create: (context) => ConnectivityCubit()),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        builder: FToastBuilder(),
        title: 'Baarazon Data & Exchange',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        onGenerateRoute: generateRoute,
        initialRoute: isFirstLaunch ? onBoardingScreenRoute : loginScreenRoute,
      ),
    );
  }
}
