import 'package:flutter/material.dart';
import 'package:flutter_app/services/StorageManager.dart';

class Themes{
  static final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  static final lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.red,
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFE5E5E5),
      accentColor: Colors.red,
      accentIconTheme: IconThemeData(color: Colors.red),
      dividerColor: Colors.white54,
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff59071a),
          foregroundColor: Colors.white)
  );

  static bool isDark = true;
  static ThemeData themeData = lightTheme;

  static ThemeData switchTheme(){
    if(isDark){
      themeData = lightTheme;
    }
    else{
      themeData = darkTheme;
    }
    isDark = !isDark;
    setBackgroundColor();
    setPrimarySwatch();
    setPrimaryColor();
    setAccentColor();
    setAccentIconTheme();
    setDividerColor();
    setTextStyleMain();
    setLightBackgroundColor();
    setDarkBackgroundColor();
    setInverseColorMain();
    setInverseSecondary();
  }

  static Color INVERSE_MAIN = Colors.black;
  static Color INVERSE_SECONDARY = Colors.white;
  static Color BACKGROUND_COLOR = Color(0xff59071a);
  static Color LIGHT_BACKGROUND_COLOR = Color(0xffD5F5E7);
  static Color DARK_BACKGROUND_COLOR = Color(0xff5F968E);
  static Color PRIMARY_SWATCH = Colors.red;
  static Color PRIMARY_COLOR = Colors.red;
  static Color ACCENT_COLOR = Colors.red;
  static IconThemeData ACCENT_ICONTHEME = IconThemeData();
  static Color DIVIDER_COLOR = Colors.red;
  static TextStyle TEXT_STYLE_MAIN = TextStyle();

  static setBackgroundColor(){
    // Glavna kontrast boja
    if(isDark){
      BACKGROUND_COLOR =  Color(0xff59071a);
    }
    else{
      BACKGROUND_COLOR = Colors.black87;
    }
  }

  static setInverseSecondary(){
    if(isDark){
      INVERSE_SECONDARY = Colors.white;
    }
    else{
      INVERSE_SECONDARY = Colors.black;
    }
  }

  static setInverseColorMain(){
    if(isDark){
      INVERSE_MAIN = Colors.black;
    }
    else{
      INVERSE_MAIN = Colors.white;
    }
  }

  static setDarkBackgroundColor(){
    if(isDark){
      DARK_BACKGROUND_COLOR = Color(0xff5F968E);
    }
    else{
      DARK_BACKGROUND_COLOR = Colors.black87;
    }
  }

  static setTextStyleMain(){
    if(isDark){
      TEXT_STYLE_MAIN =  TextStyle(color: Colors.black);
    }
    else{
      TEXT_STYLE_MAIN =  TextStyle(color: Colors.white);
    }
  }

  static setLightBackgroundColor(){
    if(isDark){
      LIGHT_BACKGROUND_COLOR = Color(0xffD5F5E7);
    }
    else{
      LIGHT_BACKGROUND_COLOR = Colors.black54;
    }
  }

  static setPrimarySwatch(){
    if(isDark){
      PRIMARY_SWATCH =  Color(0xff59071a);
    }
    else{
      PRIMARY_SWATCH = Colors.red;
    }
  }

  static setPrimaryColor(){
    if(isDark){
      PRIMARY_COLOR =  Color(0xff59071a);
    }
    else{
      PRIMARY_COLOR = Colors.red;
    }
  }

  static setAccentColor(){
    if(isDark){
      ACCENT_COLOR =  Color(0xff59071a);
    }
    else{
      ACCENT_COLOR = Colors.red;
    }
  }

  static setAccentIconTheme(){
    if(isDark){
      ACCENT_ICONTHEME =  IconThemeData(color: Colors.black);
    }
    else{
      ACCENT_ICONTHEME = IconThemeData(color: Colors.black);
    }
  }

  static setDividerColor(){
    if(isDark){
      DIVIDER_COLOR =  Color(0xff59071a);
    }
    else{
      DIVIDER_COLOR = Colors.red;
    }
  }
}

/*
class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }
}*/
