import 'package:flutter_app/models/UserModel.dart';

class ShippingInfoFormatter {
  static String format(User user) {
    String str = "";
    List<String> adresa = user.primaryAddress.split("-");
    str += "Ime: " + user.firstname + " " + user.lastname + "\n";
    if (adresa.first != "||") str += "Adresa: " + adresa.first + "\n";
    if (adresa.length >= 2)
      str += adresa.elementAt(1) + " " + adresa.last + "\n";
    if (user.secondaryAddress != "||")
      str += user.secondaryAddress.length > 0
          ? "Druga adresa: " + user.secondaryAddress + "\n"
          : "";
    str += "Broj telefona: " + user.phone + "\n";
    print(str);
    return str;
  }
}
