
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'services/home_widget_service.dart';
import 'widgets/auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  await HomeWidgetService.initialize();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<User?, TaskProvider>(
          create: (context) => TaskProvider(null),
          update: (context, user, previous) {
            final taskProvider = previous ?? TaskProvider(user);
            taskProvider.updateUser(user);
            return taskProvider;
          },
        ),
      ],
      child: const ToDoApp(),
    ),
  );
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        const Color primarySeedColor = Colors.cyan;

        final TextTheme appTextTheme = TextTheme(
          displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.robotoCondensed(fontSize: 22, fontWeight: FontWeight.w700),
          titleMedium: GoogleFonts.robotoCondensed(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: GoogleFonts.openSans(fontSize: 14),
          labelLarge: GoogleFonts.robotoCondensed(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.8),
        );

        final ThemeData lightTheme = ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarySeedColor,
            brightness: Brightness.light,
          ),
          textTheme: appTextTheme,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.black,
            titleTextStyle: GoogleFonts.oswald(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primarySeedColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          cardTheme: CardThemeData(
            elevation: 8.0,
            shadowColor: Colors.black.withAlpha(25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        );

        final ThemeData darkTheme = ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarySeedColor,
            brightness: Brightness.dark,
          ),
          textTheme: appTextTheme,
           appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            titleTextStyle: GoogleFonts.oswald(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primarySeedColor.withAlpha(150),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
           cardTheme: CardThemeData(
            elevation: 10.0,
            shadowColor: Colors.black.withAlpha(77),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.grey.shade900,
          ),
           inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade800,
          ),
        );

        return MaterialApp(
          title: 'ToDoNote',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const AuthWrapper(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
