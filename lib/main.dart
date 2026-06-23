import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educam_ai/theme/app_theme.dart';
import 'package:educam_ai/screens/splash_screen.dart';
import 'package:educam_ai/screens/onboarding_screen.dart';
import 'package:educam_ai/screens/role_select_screen.dart';
import 'package:educam_ai/screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: EduCamColors.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const ProviderScope(child: EduCamApp()));
}

class EduCamApp extends StatelessWidget {
  const EduCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCam AI',
      debugShowCheckedModeBanner: false,
      theme: EduCamTheme.lightTheme,
      darkTheme: EduCamTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/role-select':
            return MaterialPageRoute(builder: (_) => const RoleSelectScreen());
          case '/onboarding':
            return MaterialPageRoute(builder: (_) => const OnboardingScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const MainShell());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
