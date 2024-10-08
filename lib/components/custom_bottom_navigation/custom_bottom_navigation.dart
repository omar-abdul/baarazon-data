import 'package:baarazon_data/screens/regions/regions_screen.dart';
import 'package:flutter/material.dart';

import '../custom_modal_bottom_sheet.dart';
import 'components/bottom_navigation.dart';

class CustomBtmNavigation extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const CustomBtmNavigation(
      {super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      onItemSelected: onItemSelected,
      selectedIndex: selectedIndex,
      navItems: [
        _buildNavItem(
            icon: _fillOrOutline(Icons.home_filled, Icons.home_outlined, 0),
            index: 0,
            context: context,
            text: "Home"),
        _buildNavItem(
            icon: _fillOrOutline(Icons.signal_wifi_statusbar_4_bar,
                Icons.signal_wifi_statusbar_null, 1),
            index: 1,
            context: context,
            text: "Internet Data"),
        const SizedBox(
          width: 70,
        ),
        _buildNavItem(
            icon: Icons.shopping_cart_checkout_outlined,
            index: 2,
            context: context,
            text: "Orders"),
        _buildNavItem(
            icon: _fillOrOutline(Icons.person, Icons.person_outline, 3),
            index: 3,
            context: context,
            text: "Profile"),
      ],
      floatingNavItem: Material(
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            customModalBottomSheet(context,
                isDismissible: true,
                child: const RegionsScreen()); // Show bottom sheet when pressed
          },
          child: Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor, width: 2),
              // Background color for the hovering button

              boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.grey)],
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 40,
              color: Colors.green[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon,
      required int index,
      required BuildContext context,
      required String text}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                icon, // Placeholder for your svg icon
                size: 30,
                color: selectedIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.black38,
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: selectedIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.black38,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData _fillOrOutline(IconData fillIcon, IconData outlineIcon, int index) {
    return selectedIndex == index ? fillIcon : outlineIcon;
  }
}
