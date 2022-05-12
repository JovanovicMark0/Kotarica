import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'FilterSortControllers.dart';

class SliderCena extends StatefulWidget {
  static RangeValues getOpseg() {
    return SliderCenaState().getRaspon();
  }


  @override
  SliderCenaState createState() => SliderCenaState();
}
class SliderCenaState extends State<SliderCena> {

  static double donjaGranica;// = FilterSort.cheapestItem.toDouble();
  static double gornjaGranica;// = FilterSort.mostExpensiveItem.toDouble();
  TextEditingController _minCena;// = TextEditingController(text: donjaGranica.toInt().toString());
  TextEditingController _maxCena;// = TextEditingController(text: gornjaGranica.toInt().toString());

  @override
  void initState() {
    super.initState();
    gornjaGranica = FilterSort.maxPrice.toDouble();
    donjaGranica = FilterSort.minPrice.toDouble();
    rasponCena = RangeValues(donjaGranica,gornjaGranica);
    _minCena = TextEditingController(text: donjaGranica.toInt().toString());
    _maxCena = TextEditingController(text: gornjaGranica.toInt().toString());
  }
  //_minCena.text = FilterSort.cheapestItem;

  static RangeValues rasponCena;// = RangeValues(FilterSort.cheapestItem.toDouble(),FilterSort.mostExpensiveItem.toDouble());

  RangeValues getRaspon(){return rasponCena;}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 70,
              height: 50,
              child: TextFormField(
                controller: _minCena,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (value){
                  var temp = int.parse(_minCena.text).toDouble();
                  if(temp > gornjaGranica)
                    temp = gornjaGranica;
                  if(temp > FilterSort.cheapestItem)
                    temp = FilterSort.cheapestItem.toDouble();

                  if(temp < FilterSort.cheapestItem)
                    temp = FilterSort.cheapestItem.toDouble();

                  donjaGranica = temp;
                  setState(() {
                    //_minCena.text = temp.toInt().toString();
                    rasponCena = RangeValues(donjaGranica, gornjaGranica);
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.0,right: 5.0),
              child: Text("-", style: TextStyle(fontSize: 20),),
            ),
            SizedBox(
              width: 70,
              height: 50,
              child: TextFormField(
                controller: _maxCena,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (value){
                  var temp = int.parse(_maxCena.text).toDouble();

                  if(temp < donjaGranica)
                    temp = donjaGranica;
                  if(temp > FilterSort.mostExpensiveItem)
                    temp = FilterSort.mostExpensiveItem.toDouble();

                  gornjaGranica = temp;
                  setState(() {
                    //_maxCena.text = temp.toInt().toString();
                    rasponCena = RangeValues(donjaGranica, gornjaGranica);
                  });
                },
              ),
            ),
          ],
        ),
        //SizedBox(height: 10,),
        RangeSlider(
          activeColor: Colors.lightBlue,
          inactiveColor: Colors.lightBlue[200],
          values: rasponCena,
          onChanged: (RangeValues noviRaspon) {
            setState(() {
              rasponCena = noviRaspon;
              donjaGranica = noviRaspon.start.roundToDouble();
              gornjaGranica = noviRaspon.end.roundToDouble();
              _minCena.text = donjaGranica.toInt().toString();
              _maxCena.text = gornjaGranica.toInt().toString();
            });
          },
          min: FilterSort.cheapestItem.toDouble(),
          max: FilterSort.mostExpensiveItem.toDouble(),
        ),
      ],
    );
  }
}