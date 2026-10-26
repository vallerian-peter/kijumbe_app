import 'package:flutter/material.dart';
import 'kijumbe_home_screen.dart';

class KijumbeDashboard extends StatefulWidget {
  const KijumbeDashboard({super.key});

  @override
  State<KijumbeDashboard> createState() => _KijumbeDashboardState();
}

class _KijumbeDashboardState extends State<KijumbeDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        KijumbeHomeScreen(),
        Visibility(
          visible: false,
          maintainState: true,
          child: Text('Kijumbe Dashboard'),
        ),
      ],
    );
  }
}
