import 'package:flutter/material.dart';

import '../core/utils/logger.dart';
import '../flavors.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.i('Building MyHomePage for ${F.title}');
    return Scaffold(
      appBar: AppBar(title: Text(F.title)),
      body: Center(child: Text('Hello ${F.title}')),
    );
  }
}
