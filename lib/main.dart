import 'package:baarazon_data/language/cubit/language_cubit.dart';
import 'package:baarazon_data/route/route_constants.dart';
import 'package:baarazon_data/route/router.dart';
import 'package:baarazon_data/screens/profile/cubit/cubit/phone_number_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/regions/cubit.dart';
import 'cubits/connectivity/connectivity_cubit.dart';
import 'services/background_sync_service.dart';
import 'utils/seed_local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  bool isFirstLaunch = pref.getBool('isFirstLaunch') ?? true;

  await BackgroundSyncService.initialize();
  await BackgroundSyncService.registerPeriodicSync();

  if (isFirstLaunch) {
    await SeedLocalDb().seedAll();
  }

  runApp(MyApp(
    isFirstLaunch: isFirstLaunch,
  ));
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
        BlocProvider(create: (context) => ConnectivityCubit())
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
