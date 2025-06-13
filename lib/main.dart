import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:lypsis_siakad/core/theme/app_theme.dart';
import 'package:lypsis_siakad/core/widget/contextless/contextless.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:lypsis_siakad/env.dart';
import 'package:lypsis_siakad/l10n/app_localizations.dart';
import 'package:lypsis_siakad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lypsis_siakad/features/auth/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di; // Dependency Injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.url,
    anonKey: Env.anonPublic,
  );
  await di.init(); // Initialize GetIt
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton<MainAppState>(this);
  }

  List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
    Locale('id'),
  ];

  void changeLocale(Locale locale) {
    setState(() {
      supportedLocales.clear();
      supportedLocales.add(locale);
    });
  }

  String get currentLocale {
    return supportedLocales.isNotEmpty
        ? supportedLocales.first.languageCode
        : 'en';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: RKAppTheme.theme.copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        locale: Locale(currentLocale),
        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
          Locale('id'),
        ],
        home: const SplashPage(), // Changed from LoginView to SplashPage
      ),
    );
  }
}
