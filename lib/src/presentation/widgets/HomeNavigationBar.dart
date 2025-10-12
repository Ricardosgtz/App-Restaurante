import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:flutter_application_1/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItem> items;

  const HomeNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ClientHomeBloc>(context);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => bloc.add(ChangeDrawerPage(pageIndex: index)),
      height: 65,
      backgroundColor: Colors.white,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      elevation: 8,
      indicatorColor: AppTheme.primaryColor.withOpacity(0.1),
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.transparent,
      destinations: items.map((item) {
        int index = items.indexOf(item);
        bool isActive = selectedIndex == index;

        return NavigationDestination(
          icon: Icon(
            item.icon,
            color: isActive ? AppTheme.primaryColor : Colors.grey[500],
          ),
          selectedIcon: Icon(
            item.activeIcon,
            color: AppTheme.primaryColor,
          ),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({required this.icon, required this.activeIcon, required this.label});
}
