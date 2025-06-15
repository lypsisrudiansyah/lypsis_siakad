import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lypsis_siakad/core/localization/cubit/locale_cubit.dart'; // Import LocaleCubit
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

  final initialLocale = await LocaleCubit.getInitialLocale(); // Dapatkan locale awal

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(initialLocale),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget { // Ubah menjadi StatelessWidget
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan locale dari LocaleCubit
    final currentLocale = context.watch<LocaleCubit>().state;

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: RKAppTheme.theme.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      locale: currentLocale, // Gunakan locale dari Cubit
      localizationsDelegates: AppLocalizations.localizationsDelegates, // Gunakan delegates dari AppLocalizations
      supportedLocales: AppLocalizations.supportedLocales, // Gunakan supportedLocales dari AppLocalizations
      
      home: SplashPage(),
    );
  }
}
