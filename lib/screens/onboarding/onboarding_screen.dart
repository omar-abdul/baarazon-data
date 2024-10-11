import 'package:baarazon_data/route/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../language/cubit/language_cubit.dart';
import '../regions/cubit.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "What is your Location",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Get everything in your Mind",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    Icons.location_on_outlined,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              Column(
                children: [
                  // Language Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BlocBuilder<LanguageCubit, LanguageState>(
                      builder: (context, state) {
                        return DropdownButtonFormField<Language>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          value: state.language ?? Language.english,
                          onChanged: (Language? newLanguage) {
                            if (newLanguage != null) {
                              context
                                  .read<LanguageCubit>()
                                  .changeLanguage(newLanguage);
                            }
                          },
                          items: Language.values.map((Language language) {
                            return DropdownMenuItem<Language>(
                              value: language,
                              child: Text(language == Language.english
                                  ? 'English'
                                  : 'Somali'),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Region Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BlocBuilder<RegionCubit, RegionState>(
                      builder: (context, state) {
                        return DropdownButtonFormField<Regions>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          value: state.regionName,
                          onChanged: (Regions? newRegion) {
                            if (newRegion != null) {
                              context
                                  .read<RegionCubit>()
                                  .changeRegion(newRegion);
                            }
                          },
                          items: Regions.values.map((Regions region) {
                            return DropdownMenuItem<Regions>(
                              value: region,
                              child: Text(region.displayName),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final navigator = Navigator.of(context);

                          // Handle the submit action
                          final pref = await SharedPreferences.getInstance();
                          await pref.setBool('isFirstLaunch', false);

                          // Use the stored Navigator and Theme
                          navigator.pushReplacementNamed(loginScreenRoute);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12),
                          backgroundColor: Theme.of(context).primaryColor,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: Text(
                          'Submit',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
