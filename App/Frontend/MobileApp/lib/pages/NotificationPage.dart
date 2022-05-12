import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/PostModel.dart';
import 'package:flutter_app/models/NotificationModel.dart';
import 'package:flutter_app/utility/GetSize.dart';
import 'package:flutter_app/utility/ThemeManager.dart';
import 'package:flutter_app/widgets/Notifikacija.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AuctionPage.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/kotarica';
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  bool loading = true;
  List<int> listaNotifikacijaJaKupio;
  List<int> listaNotifikacijaKupljenoOdMene;
  SharedPreferences prefs;
  int id = -1;
  var postModel;
  var notificationModel;
  List<int> listaNotifikacija = [];

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id");
    await konekcija();
  }

  konekcija() async {
    postModel = Provider.of<PostModel>(context, listen: false);
    await postModel.initiateSetup();
    notificationModel = Provider.of<NotificationModel>(context, listen: false);
    await notificationModel.initiateSetup();
    listaNotifikacijaJaKupio = await notificationModel.getNotificationListIBought(id);
    listaNotifikacijaKupljenoOdMene = await notificationModel.getNotificationList(id);
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.getSharedPrefs().then((result) {
        setState(() {
          id = prefs.getInt("id");
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? CircularProgressIndicator() : Container(
        color: Themes.LIGHT_BACKGROUND_COLOR,
        child: Column(
          children: [
            for (var item in listaNotifikacijaJaKupio)
              Notifikacija.notifikacija(postModel.getNameById(item), 1,
                  GetSize.getMaxWidth(context), GetSize.getMaxHeight(context)),
            for (var item in listaNotifikacijaJaKupio)
              Notifikacija.notifikacija(postModel.getNameById(item), 0,
                  GetSize.getMaxWidth(context), GetSize.getMaxHeight(context)),
          ],
        ));
  }
}
