import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;
  final List<Widget> navItems;
  final Widget floatingNavItem;

  const CustomBottomNavBar({
    super.key,
    required this.onItemSelected,
    required this.selectedIndex,
    required this.navItems,
    required this.floatingNavItem,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        double maxWidth = constraint.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Bottom Navigation Bar Container
            Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black38,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: navItems,
              ),
            ),

            // Floating Button Positioned on Top of the Navigation Bar
            Positioned(
              top: -30,
              left: (maxWidth / 2) -
                  30, // Adjusting to center the floating button
              child: floatingNavItem,
            ),
          ],
        );
      },
    );
  }
}
