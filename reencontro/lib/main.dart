import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reencontro/forgot_password.dart';
import 'package:reencontro/login.dart';
import 'package:reencontro/settings.dart';

import 'firebase_options.dart';
import 'home/screens/home.dart';
import 'services/app_seed_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppSeedService.instance.seedIfNeeded();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFFCF9F8);
    const primary = Color(0xFF003F87);
    const primaryContainer = Color(0xFFD7E2FF);
    const secondary = Color(0xFFA04100);
    const secondaryContainer = Color(0xFFFE6B00);
    const tertiary = Color(0xFF004C17);
    const error = Color(0xFFBA1A1A);
    const outlineVariant = Color(0xFFC2C6D4);
    const onSurfaceVariant = Color(0xFF424752);

    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      error: error,
      onError: Colors.white,
      surface: background,
      onSurface: Color(0xFF1C1B1B),
      primaryContainer: primaryContainer,
      onPrimaryContainer: primary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: Colors.white,
      tertiary: tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF006722),
      onTertiaryContainer: Color(0xFF83FC8E),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      outline: Color(0xFF727784),
      outlineVariant: outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFF313030),
      onInverseSurface: Color(0xFFF3F0EF),
      inversePrimary: Color(0xFFACC7FF),
      surfaceTint: Color(0xFF115CB9),
    );

    return MaterialApp(
      title: 'Reencontro MZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: background,
          foregroundColor: primary,
          elevation: 0,
        ),
        dividerColor: outlineVariant,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: onSurfaceVariant),
          labelStyle: const TextStyle(color: onSurfaceVariant),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: primary, width: 1.4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary, width: 1.4),
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary),
        ),
      ),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/recover-password': (_) => const RecoverPasswordScreen(),
        '/create-volunteer': (_) => const CreateVolunteerScreen(),
        '/home': (_) => const ReencontroHomeScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
      home: const SplashScreen(),
    );
  }
}
