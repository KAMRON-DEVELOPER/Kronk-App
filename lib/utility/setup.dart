import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kronk/models/navbar_adapter.dart';
import 'package:kronk/models/navbar_model.dart';
import 'package:kronk/utility/storage.dart';
import 'package:path_provider/path_provider.dart';
import '../firebase_options.dart';
import '../models/user_adapter.dart';
import '../models/user_model.dart';

Future<String> setup() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Todo: preserve native splash during initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Todo: prepare directory for hive & register adapters & open boxes
  final Directory appMemory = await getApplicationDocumentsDirectory();
  Hive.init(appMemory.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NavbarAdapter());

  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<NavbarModel>('navbarBox');
  await Hive.openBox('settingsBox');

  // Todo: initialize firebase app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final Storage storage = Storage();

  await storage.initializeNavbar();

  // Todo: remove native splash
  FlutterNativeSplash.remove();

  return await storage.getAsyncRoute();
}
