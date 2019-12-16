import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:giffy_dialog/giffy_dialog.dart';

import 'loading.dart';
class Info extends StatefulWidget {
  static String tag = 'detaill-page';
  var lng;
  var lat;


  Info({Key key, this.lng, Key info, this.lat}) : super(key: key);
  @override
  _InfoState createState() => _InfoState(lng, lat);
}

class _InfoState extends State<Info> {
  var lng;
  var lat;
  bool _validateName = false;
  bool _isLoading = false;

  _InfoState(this.lng, this.lat);
  var api = 'http://134.209.170.235/api/general/fetch/address';
  var postAPI = 'http://134.209.170.235/api/customer/post';
  var provinces, districts;
  final String splitter = '__val__';

  var _name = TextEditingController();
  var _surname = TextEditingController();
  var _lane = TextEditingController();

  List<DropdownMenuItem<String>> provinceData = [];
  List<DropdownMenuItem<String>> districtData = [];
  List<DropdownMenuItem<String>> villagesData = [];

  Future<dynamic> getAddressData() async {
    http.Response res = await http.get(Uri.encodeFull(api));
    return jsonDecode(utf8.decode(res.bodyBytes))['payload'];
  }

  Future<dynamic> storeAddressData() async{
    var res = await this.getAddressData();


    setState(() {

      provinces = res['provinces'];
      for(var province in provinces) {
        provinceData.add(
            new DropdownMenuItem<String>(
              value: province['id'].toString() + splitter + province['name'],
              child: new Text(province['name']),
            ));
      }

      districts = res['districts'];

    });

  }

  Future<dynamic> getVillagesData(String id) async {
    var villageUri = 'http://134.209.170.235/api/general/fetch/address/villages/' + id;
    http.Response res = await http.get(Uri.encodeFull(villageUri));
    return jsonDecode(utf8.decode(res.bodyBytes))['payload'];
  }

  Future<dynamic> storeVillagesData(String id) async{

    String _id = getCleanId(id);

    var villages = await this.getVillagesData(_id);


    setState(() {

      villagesData.clear();
      selectedVillage = null;

      for(var village in villages) {
        villagesData.add(
           new DropdownMenuItem<String>(
              value: village['id'].toString() + splitter + village['name'],
              child: new Text(village['name']),
            ));
      }

    });

  }


  var selectedProvince, selectedDistrict, selectedVillage;
  int groupValue;
  String _gender;

  void getGender(int e){
    setState(() {
      if(e == 1){
        groupValue = 1;
        _gender = 'Male';
      }else if(e == 2){
        groupValue = 2;
        _gender = 'Female';
      }
    });
  }

  void setDistrictsOfProvince(String id){
    setState(() {

      String _id = getCleanId(id);

      selectedDistrict = null;
      selectedVillage = null;
      districtData.clear();
      villagesData.clear();

      for(var district in districts) {
        if(district['province_id'].toString() == _id)
          districtData.add(
              new DropdownMenuItem<String>(
                value: district['id'].toString() + splitter + district['name'],
                child: new Text(district['name']),
              ));
      }

    });
  }

  String getCleanId(String id){
    return id.split(splitter)[0];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeAddressData();
    _validateName = false;
  }
  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _lane.dispose();

    super.dispose();
  }


  Future postCustomer(var body) async{
    return await http.post(Uri.encodeFull(postAPI), body: body, headers: {"Accept": "application/json"})
        .then((http.Response res){

      final int statusCode = res.statusCode;
      if(statusCode < 200 || statusCode > 400 || json == null){
        throw new Exception("Error while posting");
      }
      return jsonDecode(res.body);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[600],
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: _isLoading ? new LoadingPage() : Center(
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
                                  groupValue: groupValue,
                                  onChanged: (int e) => getGender(e),
                                  activeColor: Colors.red[600],
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
                                  groupValue: groupValue,
                                  onChanged: (int e) => getGender(e),
                                  activeColor: Colors.red[600],
                                ),
                                Text("ຍິງ", style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "boonhome2",

                                ),)
                              ],
                            )
                          ],
                        ),


                        Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                          child: TextField(
                            controller: _name,
                            decoration: InputDecoration(
                              labelText: 'ຊື່',
                              errorText: _validateName ? 'ກະລຸນາໃສ່ຊື່' : null,
                              labelStyle: TextStyle(
                                fontFamily: "boonhome2",
                                fontSize: 18.0,
                                color: Colors.deepOrange
                              ),

                            ),
                          )
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                            child: TextField(
                              controller: _surname,
                              decoration: InputDecoration(
                                labelText: 'ນາມສະກຸນ',
                                labelStyle: TextStyle(
                                    fontFamily: "boonhome2",
                                    fontSize: 18.0,
                                    color: Colors.deepOrange
                                ),

                              ),
                            )
                        ),

                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0,8.0),
                            child: SearchableDropdown(
                              isExpanded: true,
                              items: provinceData,
                              value: selectedProvince,
                              hint: new Text(
                                  'ເລືອກແຂວງ', style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.deepOrange
                              ),
                              ),

                              searchHint: new Text(
                                'ຄົ້ນຫາແຂວງ',
                                style: new TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                    selectedProvince = value;
                                    setDistrictsOfProvince(value);
                                });
                              },
                            )
                        ),

                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0,8.0),
                            child: SearchableDropdown(
                              isExpanded: true,
                              items: districtData,
                              value: selectedDistrict,
                              hint: new Text(
                                  'ເລືອກເມືອງ',style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange
                              ),
                              ),
                              searchHint: new Text(
                                'ຄົ້ນຫາເມືອງ',
                                style: new TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedDistrict = value;
                                  storeVillagesData(value);
                                });
                              },
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0,8.0),
                            child: SearchableDropdown(
                              isExpanded: true,
                              items: villagesData,
                              value: selectedVillage,
                              hint: new Text(
                                  'ເລືອກບ້ານ', style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.deepOrange
                              ),
                              ),
                              searchHint: new Text(
                                'ຄົ້ນຫາບ້ານ',
                                style: new TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedVillage = value;
                                });
                              },
                            )
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 10),
                            child: TextField(
                              controller: _lane,

                              decoration: InputDecoration(
                                labelText: 'ຮ່ອມ',

                                labelStyle: TextStyle(
                                    fontFamily: "boonhome2",
                                    fontSize: 18.0,
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
                            onPressed: (){
                              if(_name.text.isEmpty){
                                setState(() {
                                  _validateName = true;
                                });
                              }else{
                                setState(() {
                                  _isLoading = true;
                                });
                                postCustomer(
                                    {
                                      'name':_name.text, 'surname':_surname.text,'gender':_gender, 'village_id': getCleanId(selectedVillage), 'lane': _lane.text, 'longitude': lng.toString(), 'latitude':lat.toString()
                                    }
                                ).then((res){
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showDialog(
                                      context: context,builder: (_) => NetworkGiffyDialog(
                                    image: Image.asset("assets/giphy.gif"),
                                    title: Text('ບັນທຶກສໍາເລັດ!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontFamily: 'boonhome2',
                                            fontWeight: FontWeight.w600)),
                                    description:Text('ບັນທຶກສໍາເລັດແລ້ວເດີ.',
                                      textAlign: TextAlign.center,
                                    ),
                                    entryAnimation: EntryAnimation.DEFAULT,
                                    onOkButtonPressed: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    },

                                    onlyOkButton: true,
                                    buttonOkText: Text('ຕົກລົງ', style: TextStyle(
                                      fontFamily: 'boonhome2',
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),),
                                  ) );
                                });
                              }
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
