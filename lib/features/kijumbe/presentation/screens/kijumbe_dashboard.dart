import 'package:flutter/material.dart';

class KijumbeDashboard extends StatefulWidget {
  const KijumbeDashboard({super.key});

  @override
  State<KijumbeDashboard> createState() => _KijumbeDashboardState();
}

class _KijumbeDashboardState extends State<KijumbeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Kijumbe Dashboard'),
      ),
    );
  }
}
