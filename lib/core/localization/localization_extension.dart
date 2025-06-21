import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart'; // Import library localization Anda

extension LocalizationExtension on BuildContext {
  String translate(String key, {Map<String, String>? params}) {
    // Pastikan Anda memanggil instance FlutterI18n dengan benar
    return FlutterI18n.translate(this, key, translationParams: params);
  }

  String plural(String key, int pluralValue) {
    return FlutterI18n.plural(this, key, pluralValue);
  }

  // Jika Anda juga ingin mengakses locale
  Locale? get currentLocale => Localizations.localeOf(this);
}