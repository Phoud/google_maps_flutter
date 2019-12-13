import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google/detail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google/detail.dart';
void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: new MyHomePage(),
));

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var newLat, newLng;
  List<Marker> allMarkers = [];
  GoogleMapController _controller;
  static LatLng latLng;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    getLocation();
  }
  void mapCreated(controller){
    setState(() {
      _controller = controller;

    });
  }

  void getCurrentLocation(){
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 18.0,
          tilt: 10.0,
        )
    ));
    setState(() {
      allMarkers.add(Marker(
          markerId:  MarkerId('myMarker'),
          icon: BitmapDescriptor.fromAsset('assets/pin.png'),
          onTap: (){
            print(latLng );
          },
          position: latLng
      ));
    });
  }

  void _updatePosition(CameraPosition _position) {
    setState(() {
      newLat = _position.target.latitude;
      newLng = _position.target.longitude;
    });
    print("Lat is: ${newLat} and Lng is: ${newLng}");
    Marker marker = allMarkers.firstWhere(
            (p) => p.markerId == MarkerId('myMarker'),
        orElse: () => null);

    allMarkers.remove(marker);
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        icon: BitmapDescriptor.fromAsset('assets/pin.png'),
      ),
    );
    setState(() {

    });
  }

  void updateMapType(){
    setState(() {
      if(_currentMapType == MapType.normal){
        setState(() {
          _currentMapType = MapType.satellite;
          print('Satellite');
        });
      }else{
        setState(() {
          _currentMapType = MapType.normal;
          print('normal');
        });
      }
    });
  }

  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();
    GeolocationStatus geolocationStatus =
    await geolocator.checkGeolocationPermissionStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        print('denied');
        break;
      case GeolocationStatus.disabled:
      case GeolocationStatus.restricted:
        print('restricted');
        break;
      case GeolocationStatus.unknown:
        print('unknown');
        break;
      case GeolocationStatus.granted:
        await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position _position) {
          if (_position != null) {
            setState((){
              latLng = LatLng(_position.latitude, _position.longitude,);
              allMarkers.add(Marker(
                  markerId:  MarkerId('myMarker'),
                  position: LatLng(17.9757, 102.6331),
                   icon: BitmapDescriptor.fromAsset("assets/pin.png")

              ));
            });
          }
        });

        break;
    }
  }
  Widget button(Function function, IconData icon) {
    return RaisedButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      color: Colors.red,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }
  void detailPage(){
  setState(() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) =>
    new Info(lng: newLng, lat: newLat)
    ));
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

          GoogleMap(
          onMapCreated: mapCreated,
          mapType: _currentMapType,
          onCameraMove: ((_position) => _updatePosition(_position)),
          initialCameraPosition: CameraPosition(
              target: LatLng(17.9757, 102.6331),
              zoom: 12.0,
              tilt: 60.0

          ),
            markers: Set.from(allMarkers),


        ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[


                    FloatingActionButton(
                      heroTag: "btnmap",
                      onPressed: updateMapType,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      child: Icon(
                        Icons.map
                      ),
                      backgroundColor: Colors.red[600],
                      focusColor: Colors.red[900],
                    ),

                    SizedBox(
                      height: 16.0,
                    ),
                    FloatingActionButton(
                      heroTag: "btnlocation",
                      onPressed: getCurrentLocation,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      child: Icon(
                          Icons.location_searching
                      ),
                      backgroundColor: Colors.red[600],
                      focusColor: Colors.red[900],
                    ),
                  ],
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,15),
              child: Align(
                alignment: Alignment.bottomCenter,

                    child: FloatingActionButton(
                      heroTag: 'btnnext',
                      onPressed: detailPage,
                      child: Icon(
                        Icons.forward
                      ),
                      backgroundColor: Colors.red[600],
                      focusColor: Colors.red[900],
                      hoverColor: Colors.red[900],
                    ),


              ),
            )
          ],

        ),
      ), //
    );
  }
}


