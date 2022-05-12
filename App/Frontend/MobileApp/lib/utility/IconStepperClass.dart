import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/RegistrationPage.dart';
import 'package:im_stepper/stepper.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'GetSize.dart';
import 'ThemeManager.dart';

class IconStepperDemo extends StatefulWidget {
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<IconStepperDemo> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.
  int upperBound = 4; // upperBound MUST BE total number of icons minus 1.
  var citiesJSON;
  List<String> lista = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.init();
    });
  }

  Future<void> init() async {
    var temp = await rootBundle.loadString('assets/cities.json');
    citiesJSON = jsonDecode(temp);
    lista.clear();
    for (int i = 0; i < citiesJSON.length; i++) {
      lista.add(citiesJSON[i]['city']);
    }
  }

  var currentText;

  final imeField = TextField(
    controller: RegistrationPage.ime,
    textAlign: TextAlign.center,
    textCapitalization: TextCapitalization.sentences,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'ime',
    ),
  );

  final prezimeField = TextField(
    controller: RegistrationPage.prezime,
    textAlign: TextAlign.center,
    textCapitalization: TextCapitalization.sentences,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'prezime',
    ),
  );

  final emailField = TextField(
    controller: RegistrationPage.email,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'imejl adresa',
    ),
  );

  final sifraField = TextField(
    controller: RegistrationPage.lozinka,
    textAlign: TextAlign.center,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    obscureText: true,
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'lozinka',
    ),
  );

  final dostavaField1 = TextField(
    //controller: RegistrationPage.grad1,
    textAlign: TextAlign.center, // uraditi regex
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'adresa ',
    ),
  );

  final dostavaField2 = TextField(
    controller: RegistrationPage.ulicaBroj1,
    textAlign: TextAlign.center, // uraditi regex
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
      //hintText: 'adresa ',
    ),
  );

  final dostavaField3 = TextField(
    controller: RegistrationPage.postanskiBroj1,
    textAlign: TextAlign.center, // uraditi regex
    keyboardType: TextInputType.phone,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'adresa ',
    ),
  );

  final preuzimanjeField1 = TextField(
    //controller: RegistrationPage.grad2,
    textAlign: TextAlign.center,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'email',
    ),
  );

  final preuzimanjeField2 = TextField(
    controller: RegistrationPage.ulicaBroj2,
    textAlign: TextAlign.center,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
      //hintText: 'email',
    ),
  );

  final preuzimanjeField3 = TextField(
    controller: RegistrationPage.postanskiBroj2,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.phone,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
      //hintText: 'email',
    ),
  );

  final kontaktTelefonField = TextField(
    controller: RegistrationPage.brojTelefona,
    textAlign: TextAlign.center,
    keyboardType: TextInputType.phone,
    style: TextStyle(decorationColor: Colors.white, color: Colors.white),
    decoration: InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
      //hintText: 'kontakt telefon',
    ),
  );

  bool checkError() {
    bool hasError = false;
    String str = "";
    if (activeStep == 0) {
      if (RegistrationPage.ime.text == "") {
        hasError = true;
        str += "Polje za ime korisnika ne sme biti prazno.\n";
      }
      if (RegistrationPage.prezime.text == "") {
        hasError = true;
        str += "Polje za prezime korisnika ne sme biti prazno.\n";
      }
      if (RegistrationPage.brojTelefona.text == "") {
        hasError = true;
        str += "Polje za kontakt telefona korisnika ne sme biti prazno.\n";
      }
      if (!RegistrationPage.ime.text.contains(RegExp(r"^[A-Z]{1}[a-z]+([ ][A-Z]{1}[a-z]+)?"))) {
        hasError = true;
        str +=
        "Polje za ime može sadržati samo slova srpske abecede i razmake.\n";
      }
      if (!RegistrationPage.prezime.text.contains(RegExp(r"^[A-Z]{1}[a-z]+([ ][A-Z]{1}[a-z]+)?"))) {
        hasError = true;
        str +=
        "Polje za prezime može sadržati samo slova srpske abecede i razmake.\n";
      }
      if (!RegistrationPage.brojTelefona.text.contains(RegExp(r"^[0][6][0-9]{7,8}$"))) {
        hasError = true;
        str +=
        "Broj telefona mora biti u formatu 06XXXXXXXX ili 06XXXXXXX.\n";
      }
    }
    if(activeStep == 1){
      if (RegistrationPage.grad1.text == "") {
        hasError = true;
        str += "Polje za mesto korisnika ne sme biti prazno.\n";
      }
      if (RegistrationPage.ulicaBroj1.text == "") {
        hasError = true;
        str += "Polje za ulicu i broj ne sme biti prazno.\n";
      }
      if (RegistrationPage.postanskiBroj1.text.contains(RegExp(r"/^[a-z ,.'-]+$/i"))) {
        hasError = true;
        str +=
        "Polje za ime može sadržati samo slova i razmake.\n";
      }
      if (!RegistrationPage.ulicaBroj1.text.contains(RegExp(r"([0-9]+. )?[A-Za-z0-9. \/]+"))) {
        hasError = true;
        str += "Ukoliko ulica stanovanja nema broj, nije neophodno navesti broj.\n";
        str += "Ukoliko stanujete u kompleksu koji sadrži više stanova, navesti i broj stana.\n";
        str += "Primer: Nikole Pašića 12/2.\n";
      }
    }
    if(activeStep == 2){
      if (RegistrationPage.email.text == "") {
        hasError = true;
        str += "Polje za imejl korisnika ne sme biti prazno.\n";
      }
      if (RegistrationPage.lozinka.text == "") {
        hasError = true;
        str += "Polje za lozinku korisnika ne sme biti prazno.\n";
      }
      if(!RegistrationPage.email.text.contains(RegExp("^[a-z0-9]+(([_.-]?[a-z]))*@([a-z0-9]+([-]?[a-z0-9])*)(.[a-z]{2,})+\$"))){
        hasError = true;
        str +=
        "Imejl mora biti unet u ispravnom formatu primer@gmail.com.\n";
      }
      if(!RegistrationPage.lozinka.text.contains(RegExp("^[A-Za-z0-9]{8,}\$"))){
        hasError = true;
        str += "Lozinka biti dužine bar 8 karaktera.\n";
        str += "Lozinka može sadržati samo slova (velika i/ili mala) i brojeve.\n";
        str += "Lozinka mora sadržati bar jedno slovo.\n";
        str += "Lozinka mora sadržati bar jedan broj.\n";
      }
    }
    if (hasError) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Neispravan unos"),
          content: Text(
            str,
            style: TextStyle(color: Colors.redAccent, height: 1.5),
          ),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Themes.BACKGROUND_COLOR,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("U redu"))
          ],
        ),
      );
    }
    return hasError;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            IconStepper(
              lineLength: 200,
              stepReachedAnimationEffect: Curves.ease,
              activeStepBorderColor: Colors.white,
              activeStepColor: Colors.white,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              lineColor: Colors.white,
              nextButtonIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              previousButtonIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              icons: [
                Icon(
                  Icons.badge,
                  color: Color(0xff59071a),
                ),
                Icon(
                  Icons.contact_mail_rounded,
                  color: Color(0xff59071a),
                ),
                Icon(
                  Icons.alternate_email,
                  color: Color(0xff59071a),
                ),
                Icon(
                  Icons.contact_mail_outlined,
                  color: Color(0xff59071a),
                ),
                Icon(
                  Icons.add_a_photo_rounded,
                  color: Color(0xff59071a),
                ),
              ],

              // activeStep property set to activeStep variable defined above.
              activeStep: activeStep,

              // This ensures step-tapping updates the activeStep.
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            header(),
            Expanded(child: stepperOptionMaker()),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                previousButton(),
                nextButton(),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
/*
  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Color(0xff59071a), onPrimary: Colors.white),
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep++;
          });
        }
      },
      child: Text('Sledeći korak'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Color(0xff59071a), onPrimary: Colors.white),
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Text('Prethodni korak'),
    );
  }*/

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Center(
          child: Text(
            headerText(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ));
  }

  Container nextButton() {
    return Container(
      width: 105,
      child: Material(
        color: Color(0xff59081b),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(3.0),
          child: MaterialButton(
            minWidth: GetSize.getMaxWidth(context) * 0.2,
            //padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            onPressed: () {
              setState(() {
                if(!checkError())
                  activeStep++;
              });
            },
            child: Center(
              child: Text(
                'Nastavi',
                textScaleFactor: 1.1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container backButton() {
    return Container(
      width: 105,
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.all(3.0),
      decoration: new BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Material(
        color: Color(0xff5f968e),
        child: MaterialButton(
          minWidth: GetSize.getMaxWidth(context) * 0.2,
          //padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
          onPressed: () {
            setState(() {
              activeStep--;
            });
          },
          child: Center(
            child: Text(
              'Nazad',
              textScaleFactor: 1.1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool showError = false;

  Widget stepperOptionMaker() {
    TextEditingController helper = new TextEditingController();
    helper.text = RegistrationPage.grad1.text;
    Container mesto1() {
      return Container(
          height: 60.0,
          child: AutoCompleteTextField(
            controller: helper,
            clearOnSubmit: false,
            style: TextStyle(color: Colors.white),
            suggestions: lista,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
              hintText: "Pronađite mesto",
              hintStyle: TextStyle(color: Colors.white, fontSize: 15),
            ),
            itemFilter: (item, query) {
              return item.toLowerCase().contains(query.toLowerCase());
            },
            itemSubmitted: (item) {
              RegistrationPage.grad1.text = item;
              setState(() {
                for (int i = 0; i < citiesJSON.length; i++) {
                  if (citiesJSON[i]['city'] == item) {
                    RegistrationPage.postanskiBroj1.text =
                        citiesJSON[i]['zip'].toString();
                    break;
                  }
                }
              });
            },
            itemBuilder: (context, item) {
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  item,
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
            key: null,
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            onFocusChanged: (hasFocus) {
              var flag = 0;
              if (!hasFocus) {
                for (int i = 0; i < citiesJSON.length; i++) {
                  if (citiesJSON[i]['city'].toLowerCase() ==
                      helper.text.toLowerCase()) {
                    flag = 1;
                    setState(() {
                      RegistrationPage.grad1.text = citiesJSON[i]['city'];
                      helper.text = RegistrationPage.grad1.text;
                      RegistrationPage.postanskiBroj1.text =
                          citiesJSON[i]['zip'].toString();
                    });
                    break;
                  }
                }
                if (flag == 0) {
                  setState(() => helper.text = "");
                }
              }
            },
          ));
    }

    TextEditingController helper2 = new TextEditingController();
    helper2.text = RegistrationPage.grad2.text;
    Container mesto2() {
      return Container(
          height: 60.0,
          child: AutoCompleteTextField(
            controller: helper2,
            clearOnSubmit: false,
            style: TextStyle(color: Colors.white),
            suggestions: lista,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              contentPadding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
              hintText: "Pronađite mesto",
              hintStyle: TextStyle(color: Colors.white, fontSize: 15),
            ),
            itemFilter: (item, query) {
              return item.toLowerCase().contains(query.toLowerCase());
            },
            itemSubmitted: (item) {
              RegistrationPage.grad2.text = item;
              setState(() {
                for (int i = 0; i < citiesJSON.length; i++) {
                  if (citiesJSON[i]['city'] == item) {
                    RegistrationPage.postanskiBroj2.text =
                        citiesJSON[i]['zip'].toString();
                    break;
                  }
                }
              });
            },
            itemBuilder: (context, item) {
              return Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  item,
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
            key: null,
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            onFocusChanged: (hasFocus) {
              var flag = 0;
              if (!hasFocus) {
                for (int i = 0; i < citiesJSON.length; i++) {
                  if (citiesJSON[i]['city'].toLowerCase() ==
                      helper2.text.toLowerCase()) {
                    flag = 1;
                    setState(() {
                      RegistrationPage.grad2.text = citiesJSON[i]['city'];
                      helper2.text = RegistrationPage.grad2.text;
                      RegistrationPage.postanskiBroj2.text =
                          citiesJSON[i]['zip'].toString();
                    });
                    break;
                  }
                }
                if (flag == 0) {
                  setState(() => helper2.text = "");
                }
              }
            },
          ));
    }

    Container mesto() {
      if (activeStep == 1) {
        return mesto1();
      }
      if (activeStep == 3) {
        return mesto2();
      }
    }

    switch (this.activeStep) {
      case 1:
        return Column(
          children: [
            mesto(),
            Text("Mesto",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            dostavaField2,
            Text("Ulica i broj",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            dostavaField3,
            Text("Poštanski broj",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                backButton(),
                nextButton(),
              ]),
            ),
          ],
        );
        break;

      case 2:
        return Column(
          children: [
            emailField,
            Text("Imejl",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            sifraField,
            Text("Lozinka",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                backButton(),
                nextButton(),
              ]),
            ),
          ],
        );
        break;

      case 3:
        return Column(
          children: [
            mesto(),
            Text("Grad",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            preuzimanjeField2,
            Text("Ulica i broj",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            preuzimanjeField3,
            Text("Poštanski broj",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                backButton(),
                nextButton(),
              ]),
            ),
          ],
        );
        break;

      case 4:
        return Column(
          children: [
            // ZA SLIKU
            ConstrainedBox(
              constraints: BoxConstraints.expand(width: 175.00, height: 175.00),
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: RegistrationPage.imageButton,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                backButton(),
                RegistrationPage.getRegistrationButton(),
              ]),
            ),
          ],
        );
        break;

      default:
        return Column(
          children: [
            imeField,
            Text("Ime",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            prezimeField,
            Text("Prezime",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            kontaktTelefonField,
            Text("Mobilni kontakt telefon",
                textScaleFactor: 0.8, style: TextStyle(color: Colors.white)),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                nextButton(),
              ]),
            ),
          ],
        );
    }
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Adresa 1 (obavezno)';

      case 2:
        return 'Korisnički podaci';

      case 3:
        return 'Adresa 2 (opciono)';

      case 4:
        return 'Dodaj sliku';

      default:
        return 'Lični podaci';
    }
  }
}
