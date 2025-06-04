import 'package:curry_puff_master/app.dart';
import 'package:curry_puff_master/core/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize dependencies
  await di.init();
  
  // Run the app
  runApp(const CurryPuffMasterApp());
}