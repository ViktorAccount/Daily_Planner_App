import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/theme_provider.dart';
import 'view_models/locale_provider.dart';
import 'view_models/font_size_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Auto-generated file


//Initierar Firebase med plattformsspecifika konfigurationer från firebase_options.dart.
// Firebase-autentisering (1 p): Säkerställer att Firebase är initierat, vilket är nödvändigt för autentisering 
//(login_screen.dart, sign_up_screen.dart) och Firestore-integrering.

void main() async {

  // INITIALIZE EVERYTHING
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(     //initlaize base on confic in firebaseoption.dart
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized successfully");
    }
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  // CREATE THE APP

  runApp(MyApp());
}

// Firebase-autentisering (1 p): Säkerställer att Firebase är initierat, vilket är nödvändigt 
//för autentisering (login_screen.dart, sign_up_screen.dart) och Firestore-integrering.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FontSizeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()), // Add LocaleProvider
      ],   //Groups multiple Provider instances, making them available throughout 
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return Consumer<FontSizeProvider>(
            builder: (context, fontSizeProvider, child) {
              return Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                    title: AppLocalizations.of(context)?.appTitle ?? 'Daily Planner',
                    localizationsDelegates: AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,                 
                    locale: localeProvider.locale, // Use the locale from LocaleProvider  //Dynamically sets the app's language using LocaleProvider.
                    theme: ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepOrange,
                        brightness: Brightness.light,
                      ),
                    ),
                    darkTheme: ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepOrange,
                        brightness: Brightness.dark,
                      ),
                    ),
                    themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(            //Hantering av storlektskärmar
                          textScaleFactor: fontSizeProvider.fontSize,    //Dynamically scales text based on user settings in FontSizeProvider. Hn
                        ),                                                
                        child: child!,
                      );
                    },
                    home: AuthWrapper(),   //determine if the user is logged in or nah redierecithm home, or login sc
                  );
                },                         
              );
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<AuthViewModel>().user;

    if (user != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
