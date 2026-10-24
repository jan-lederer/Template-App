import 'package:flutter/material.dart';

import 'app/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TemplateApp());
}

class TemplateApp extends StatelessWidget {
  const TemplateApp({this.showStartupScreen = true, super.key});

  final bool showStartupScreen;

  @override
  Widget build(BuildContext context) =>
      AppShell(showStartupScreen: showStartupScreen);
}
