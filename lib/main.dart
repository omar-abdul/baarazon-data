import 'package:baarazon_data/route/route_constants.dart';
import 'package:baarazon_data/route/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './screens/regions/cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegionCubit()..initialize(),
      child: MaterialApp(
        title: 'Baarazon Data & Exchange',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        onGenerateRoute: generateRoute,
        initialRoute: entryPointRoute,
      ),
    );
  }
}
