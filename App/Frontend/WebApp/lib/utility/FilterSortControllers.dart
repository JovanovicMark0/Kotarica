import 'package:flutter/cupertino.dart';

class FilterSort {
  static String kategorija = "Kategorija";
  static String potkategorija = "Potkategorija";
  static int nacinPlacanja = 0;
  static String grad = "Sve";
  static int tipOglasa = 0; // 0 sve, 1 oglas, 2 licitacija
  static TextEditingController mesto = TextEditingController();
  static TextEditingController pretraga = TextEditingController();
  static TextEditingController opis = TextEditingController();
  static int sort = 0;
  static int brojObjavaPoStrani = 5;

  static int cheapestItem;
  static int mostExpensiveItem;
  static double minPrice;
  static double maxPrice;
}
// SORT
// 0 == prvo najnovije
// 1 == prvo najstarije
// 2 == prvo najjeftinije
// 3 == prvo najskuplje
// 4 == A-Z
// 5 == Z-A

// NACIN PLACANJA

// 0 - Payment.sve
// 1 - Payment.pouzecem
// 2 - Payment.kriptovalute