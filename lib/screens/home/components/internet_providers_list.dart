import 'package:flutter/material.dart';

import '../../../constants.dart';

class InternetProvidersList extends StatelessWidget {
  const InternetProvidersList({super.key});

  // Create a list of internet providers

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Internet Data',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1, // Adjusted ratio for better look
            ),
            itemCount: internetProviders.length,
            itemBuilder: (context, index) {
              final entry = internetProviders.entries.elementAt(index);
              return Material(
                child: InkWell(
                  onTap: () {
                    // Handle the tap

                    Navigator.pushNamed(context, entry.value[1]);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  300], // Placeholder color for background
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12.0),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12.0),
                              ),
                              child: Image.asset(
                                entry.value[0],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(color: Colors.grey, width: .3)),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              entry.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
