import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'FilterSortControllers.dart';
import 'SliderCena.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => new _FilterState();
}

class _FilterState extends State<Filter> {
  var categoriesJSON;
  var categories = [];
  var subcategories = [];
  var loading = true;
  var postModel;
  var gradovi = [];

  // TEMP KONTROLERI
  var tempKategorija;
  var tempPotkategorija;
  List<DropdownMenuItem<String>> lista= [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.konekcija().then((value) {
        promenaLoadinga();
        tempKategorija = FilterSort.kategorija;
        tempPotkategorija = FilterSort.potkategorija;
      });
    });

  }

  void promenaLoadinga() {
    setState(() {
      loading = false;
    });
  }


  konekcija() async {
    var temp = await rootBundle.loadString('assets/categories.json');
    var citiesJSON = await rootBundle.loadString('assets/cities.json');
    categoriesJSON = jsonDecode(temp);
    categories.clear();
    categories.add("Kategorija");
    for (int i = 1; i <= categoriesJSON.length; i++) {
      categories.add(categoriesJSON["$i"]["Category"]);
    }
    await fillSubcategories();
    var gradoviJSON = await jsonDecode(citiesJSON);
    gradovi.clear();
    gradovi.add("Sve");
    for (int i = 0; i < gradoviJSON.length; i++) {
      gradovi.add(gradoviJSON[i]['city']);
    }
    gradoviDropdownItem();
  }

  fillSubcategories() {
    subcategories.clear();
    subcategories.add("Potkategorija");
    for (int i = 1; i <= categoriesJSON.length; i++) {
      if (categoriesJSON["$i"]["Category"] == tempKategorija) {
        var _lista = categoriesJSON["$i"]["subcategories"];
        for (int j = 0; j < _lista.length; j++) {
          subcategories.add(_lista[j]);
        }
        break;
      }
    }
  }

  List<DropdownMenuItem<String>> gradoviDropdownItem() {
    lista.clear();
    for(var i=0; i<gradovi.length; i++){
      lista.add(
        DropdownMenuItem<String>(
          value: gradovi[i],
          child: Center(
            child: Text(gradovi[i]),
          ),
        ),
      );
    }
    return lista;
  }

  Column kategorije() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4.0),
          child: DropdownButton<String>(
              hint: Text("Kategorija"),
              value: tempKategorija,
              items: [
                for (int i = 0; i < categories.length; i++)
                  DropdownMenuItem<String>(
                      value: categories[i],
                      child: Center(
                        child: Text(categories[i]),
                      )),
              ],
              onChanged: (_value) => {
                setState(() {
                  tempKategorija = _value;
                  fillSubcategories();
                })
              }),
        ),
      ],
    );
  }


  Column mesta() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4.0),
          child: DropdownButton<String>(
              value: FilterSort.grad,
              items: lista,
              onChanged: (String value) {
                setState(() => {FilterSort.grad = value});
              }
          ),
        ),
      ],
    );
  }

  Padding potkategorije() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: DropdownButton<String>(
          hint: Text("Potkategorija"),
          value: tempPotkategorija,
          items: [
            for (int i = 0; i < subcategories.length; i++)
              DropdownMenuItem<String>(
                  value: subcategories[i], child: Text(subcategories[i])),
          ],
          onChanged: (_value) => {
            setState(() {
              tempPotkategorija = _value;
            })
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    konekcija();
    return loading ? Center(child: CircularProgressIndicator()) : AlertDialog(
      title: Text('Filter'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            ListTile(
              title: Text("Izaberite kategorije:"),
              subtitle: Column(children: [kategorije(),potkategorije()]),
            ),
            ListTile(
              title: Text("Oglas/Licitacija"),
              subtitle: DropdownButton(
                  value: FilterSort.tipOglasa,
                  items: <DropdownMenuItem<int>>[
                    new DropdownMenuItem(
                      child: new Text('Sve'),
                      value: 0,
                    ),
                    new DropdownMenuItem(
                      child: new Text('Oglasi'),
                      value: 1,
                    ),
                    new DropdownMenuItem(
                      child: new Text('Licitacije'),
                      value: 2,
                    ),
                  ],
                  onChanged: (int value) {
                    setState(() => {FilterSort.tipOglasa = value});
                  }
              ),
            ),
            ListTile(
              title: Text("Mesto"),
              subtitle: mesta(),
            ),
            ListTile(
              title: Text("Opseg cene"),
              subtitle: SliderCena(),

            ),
            ListTile(
              title: Text("Način plaćanja"),
              subtitle: DropdownButton(
                  value: FilterSort.nacinPlacanja,
                  items: <DropdownMenuItem<int>>[
                    new DropdownMenuItem(
                      child: new Text('Sve'),
                      value: 0,
                    ),
                    new DropdownMenuItem(
                      child: new Text('Pouzećem'),
                      value: 1,
                    ),
                    new DropdownMenuItem(
                      child: new Text('Kriptovalutama'),
                      value: 2,
                    ),
                  ],
                  onChanged: (int value) {
                    setState(() => {FilterSort.nacinPlacanja = value});
                  }
              ),
            ),
            ListTile(
              title: Text("Broj objava na početnoj strani:"),
              subtitle: DropdownButton(
                  value: FilterSort.brojObjavaPoStrani,
                  items: <DropdownMenuItem<int>>[
                    new DropdownMenuItem(
                      child: new Text('5'),
                      value: 5,
                    ),
                    new DropdownMenuItem(
                      child: new Text('10'),
                      value: 10,
                    ),
                    new DropdownMenuItem(
                      child: new Text('15'),
                      value: 15,
                    ),
                    new DropdownMenuItem(
                      child: new Text('20'),
                      value: 20,
                    ),
                  ],
                  onChanged: (int value) {
                    setState(() => {FilterSort.brojObjavaPoStrani = value});
                  }
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Otkaži'),
          onPressed: () {
            Navigator.of(context).pop(0);
          },
        ),
        TextButton(
          child: Text('Filtrirajte'),
          onPressed: () async {
            FilterSort.kategorija = tempKategorija;
            FilterSort.potkategorija = tempPotkategorija;
            RangeValues raspon = SliderCena.getOpseg();
            FilterSort.minPrice = raspon.start;
            FilterSort.maxPrice = raspon.end;
            //FilterSort.minPrice = SliderCena.donjaGranica;
            Navigator.of(context).pop(1);
          },
        ),
      ],
    );
  }
}