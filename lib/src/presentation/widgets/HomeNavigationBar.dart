import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItem> items;
  final Function(int)? onItemSelected;
  final int shoppingBagCount;

  const HomeNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    this.onItemSelected,
    this.shoppingBagCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClientHomeBloc>(context);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if (onItemSelected != null) {
          onItemSelected!(index);
        } else {
          bloc.add(ChangeDrawerPage(pageIndex: index));
        }
      },
      height: 65,
      backgroundColor: Colors.white,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 8,
      indicatorColor: AppTheme.primaryColor.withOpacity(0.1),
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.transparent,
      destinations: items.asMap().entries.map((entry) {
        int index = entry.key;
        NavigationItem item = entry.value;
        bool isActive = selectedIndex == index;
        bool isShoppingBag = index == 1;

        return NavigationDestination(
          icon: isShoppingBag && shoppingBagCount > 0
              ? _buildIconWithBadge(
                  item.icon,
                  isActive ? AppTheme.primaryColor : Colors.grey[500]!,
                  shoppingBagCount,
                )
              : Icon(
                  item.icon,
                  color: isActive ? AppTheme.primaryColor : Colors.grey[500],
                ),
          selectedIcon: isShoppingBag && shoppingBagCount > 0
              ? _buildIconWithBadge(
                  item.activeIcon,
                  AppTheme.primaryColor,
                  shoppingBagCount,
                )
              : Icon(
                  item.activeIcon,
                  color: AppTheme.primaryColor,
                ),
          label: item.label,
        );
      }).toList(),
    );
  }

  /// ✨ Estilo mejorado del badge
  Widget _buildIconWithBadge(IconData icon, Color color, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color),
        if (count > 0)
          Positioned(
            right: -19,
            top: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.95),
                    AppTheme.primaryColor.withOpacity(0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
