import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'controllers/challenges_controller.dart';

import 'screens/home_screen.dart';

void main() => runApp(const ICanDOIt());

class ICanDOIt extends StatelessWidget {
  const ICanDOIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICanDOIt',
      home: ChangeNotifierProvider<ChallengesController>(
        create: (contex) => ChallengesController(),
        child: const Home(),
      ),
    );
  }
}
