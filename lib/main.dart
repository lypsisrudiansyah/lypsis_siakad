import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart'; // Import flutter_i18n
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lypsis_siakad/core/localization/cubit/locale_cubit.dart';
import 'package:lypsis_siakad/core/theme/app_theme.dart';
import 'package:lypsis_siakad/core/widget/contextless/contextless.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lypsis_siakad/core.dart';
import 'package:lypsis_siakad/env.dart';
import 'package:lypsis_siakad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lypsis_siakad/features/auth/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di; // Dependency Injection

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.url, anonKey: Env.anonPublic);
  await di.init(); // Initialize GetIt

  final initialLocale = await LocaleCubit.getInitialLocale(); // Dapatkan locale awal

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit(initialLocale)),
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, currentLocale) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme: RKAppTheme.theme.copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
            debugShowCheckedModeBanner: false,
            locale: currentLocale, // Use locale from Cubit
            localizationsDelegates: [
              FlutterI18nDelegate(
                translationLoader: FileTranslationLoader(basePath: 'assets/flutter_i18n', fallbackFile: 'id'),
                missingTranslationHandler: (key, locale) {
                  pr("--- Missing Key: $key, languageCode: ${locale?.languageCode}");
                },
              ),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('id'), Locale('ko')],
            // builder: FlutterI18n.rootApp, // Essential for flutter_i18n
            home: const SplashPage(),
          );
        },
      ),
    ),
  );
}
