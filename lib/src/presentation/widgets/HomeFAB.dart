import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/config/AppTheme.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'client/shopping_bag'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor, // 🌟 color global
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.shopping_bag_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
