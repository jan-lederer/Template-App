import 'package:flutter/material.dart';

import 'app/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TemplateApp());
}

class TemplateApp extends StatelessWidget {
  const TemplateApp({super.key});

  @override
  Widget build(BuildContext context) => const AppShell();
}
