import 'package:flutter/material.dart';
import 'package:flutter_radio_button_group/flutter_radio_button_group.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String dropProvince = 'Province';
  String dropDistrict = 'District';
  String dropVillage = 'Village';
  final List<String> provinces = ['Province', 'ສັງທອງ', 'ວັງວຽງ', 'ຫາດຊາຍຟອງ', 'test', 'nottest'];
  final List<String> districts = ['District', 'ສັງທອງ', 'ວັງວຽງ', 'ຫາດຊາຍຟອງ', 'test', 'nottest'];
  final List<String> villages = ['Village', 'ສັງທອງ', 'ວັງວຽງ', 'ຫາດຊາຍຟອງ', 'test', 'nottest'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red[600   ],
                  child: Center(
                    child: Text("ຂໍ້ມູນ", style: TextStyle(
                      color: Colors.white,
                      fontFamily: "boonhome2",
                      fontSize: 30.0
                    )),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 1,
                                  groupValue: 2,

                                ),
                                Text("ຊາຍ", style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "boonhome2",

                                ))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  value: 2,
                                  groupValue: 2,

                                ),
                                Text("ຍິງ", style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "boonhome2",

                                ),)
                              ],
                            )
                          ],
                        ),

//                    Row(
//                      children: <Widget>[
//                        FlutterRadioButtonGroup(
//                          items: [
//                            "Male",
//                            "Female"
//                          ],
//                          onSelected: (String selected){
//                            print($selected)
//                          },
//                        )
//                      ],
//                    ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'ຊື່',
                              labelStyle: TextStyle(
                                fontFamily: "boonhome2",
                                fontSize: 16.0,
                                color: Colors.deepOrange
                              ),

                            ),
                          )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'ນາມສະກຸນ',
                                labelStyle: TextStyle(
                                    fontFamily: "boonhome2",
                                    fontSize: 16.0,
                                    color: Colors.deepOrange
                                ),

                              ),
                            )
                        ),

                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0,8.0),
                            child: SearchableDropdown(
                              isExpanded: true,
                              items: provinces
                                  .map<DropdownMenuItem<String>>((String valued) {
                                return DropdownMenuItem<String>(
                                  value: valued,
                                  child: Text(valued),
                                );
                              }).toList(),
                              value: dropProvince,
                              hint: new Text(
                                  'Select One'
                              ),
                              searchHint: new Text(
                                'Select One',
                                style: new TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  dropProvince = value;
                                });
                              },
                            )
                        ),

                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0,8.0),
                            child: SearchableDropdown(
                              isExpanded: true,
                              items: districts
                                  .map<DropdownMenuItem<String>>((String valued) {
                                return DropdownMenuItem<String>(
                                  value: valued,
                                  child: Text(valued),
                                );
                              }).toList(),
                              value: dropDistrict,
                              hint: new Text(
                                  'Select One'
                              ),
                              searchHint: new Text(
                                'Select One',
                                style: new TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  dropDistrict = value;
                                });
                              },
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0,8.0),
                            child: SearchableDropdown(
                              isExpanded: true,
                              items: villages
                                  .map<DropdownMenuItem<String>>((String valued) {
                                return DropdownMenuItem<String>(
                                  value: valued,
                                  child: Text(valued),
                                );
                              }).toList(),
                              value: dropVillage,
                              hint: new Text(
                                  'Select One'
                              ),
                              searchHint: new Text(
                                'Select One',
                                style: new TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  dropVillage = value;
                                });
                              },
                            )
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 10),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'ຮ່ອມ',
                                labelStyle: TextStyle(
                                    fontFamily: "boonhome2",
                                    fontSize: 16.0,
                                    color: Colors.deepOrange
                                ),

                              ),
                            )
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {

                            },

                            color: Colors.red[600],
                            child: Text('ບັນທຶກ', style: TextStyle(color: Colors.white, fontFamily: 'boonhome2', fontSize: 20.0)),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
