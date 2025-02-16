import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/utility/routes.dart';
import 'package:kronk/utility/setup.dart';

void main() async {
  String initialRoute = await setup();

  assert(() {
    debugInvertOversizedImages = true;
    return true;
  }());

  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'Kronk', initialRoute: initialRoute, onGenerateRoute: (RouteSettings settings) => routes(settings, context));
  }
}
