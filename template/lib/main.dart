import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';

import 'src/provider/counter.dart';
import 'src/provider/setting.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  // 사용법: FlutterConfig.get('FABRIC_ID')
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Counter()),
      ChangeNotifierProvider(create: (_) => Setting()),
    ],
    child: const MyApp(),
  ));
}
