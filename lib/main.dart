import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/login/loginscreen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNnaXhtaXhnamhzcHVxYXZxanN1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjk0MzAyOCwiZXhwIjoyMDQ4NTE5MDI4fQ._oP-wclMUlcBxULkChVCXpKnwdHwUo0yVwhbgtj8RIs',
      url: 'https://sgixmixgjhspuqavqjsu.supabase.co');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Loginscreen(),
    );
  }
}
