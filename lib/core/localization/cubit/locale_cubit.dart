import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(super.initialLocale);

  static const String _localeKey = 'app_locale_language_code';

  // Muat locale awal dari SharedPreferences atau gunakan default
  static Future<Locale> getInitialLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);
      if (languageCode != null && languageCode.isNotEmpty) {
        return Locale(languageCode);
      }
    } catch (e) {
      // Abaikan error jika SharedPreferences gagal, gunakan default
    }
    return const Locale('id'); // Locale default jika tidak ada yang tersimpan atau error
  }

  void changeLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
    emit(newLocale);
  }
}