import 'package:GyroLocationApp/stores/driver/driver_store.dart';
import 'package:GyroLocationApp/utils/routes/routes.dart';
import 'package:GyroLocationApp/widgets/geolocator_widget.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:GyroLocationApp/stores/language/language_store.dart';
import 'package:GyroLocationApp/stores/theme/theme_store.dart';
import 'package:GyroLocationApp/ui/app/const/AppColors.dart';
import 'package:GyroLocationApp/utils/device/device_utils.dart';
import 'package:GyroLocationApp/utils/locale/app_localization.dart';
import 'package:GyroLocationApp/widgets/empty_app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_vendor_screen.dart';

class DriverLocation extends StatefulWidget {


  DriverLocation();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<DriverLocation>{
  //text controllers:-----------------------------------------------------------


  int checkedIndex = 0;


  TextEditingController _phoneController = TextEditingController();
  bool _obscureText = false;
  bool _obscure = false;

  //stores:---------------------------------------------------------------------

  late ThemeStore _themeStore;
  late LanguageStore _languageStore;
  late DriverStore _driverStore;


  //focus node:-----------------------------------------------------------------


  //stores:---------------------------------------------------------------------


  TextEditingController? textController1;
  TextEditingController? textController2;
  late bool passwordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loaded=false;
  String driver_name="";
  late LatLng _position;
  String? driver_number="";
  int navigateFrom=0;

  bool isSwitched = false;
  var textValue = 'Offline';


  late GoogleMapController myController;
  Set<Marker> markers = Set();
  final LatLng _center = const LatLng(23.7806365, 90.4193257);

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }




  addMarkers() async {
    markers.add(
        Marker( //add start location marker
          markerId: MarkerId(driver_name),
          position: _position, //position of marker
          infoWindow: InfoWindow( //popup info
            title: 'Starting Point ',
            snippet: 'Start Marker',
          ),
          icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), //Icon for Marker
        )
    );
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _driverStore= Provider.of<DriverStore>(context);


    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    print("form-argument:::${arguments.length.toString()}");
    if(arguments==null || arguments.length==0){
      _getCurrentLocation();
       User? user = await FirebaseAuth.instance.currentUser;
       driver_number=user?.phoneNumber!;
      print("form:::2");
      // print(user?.phoneNumber!.toString());
     // driver_name=user!.displayName!;
      //_position=arguments['position'];
    }else if (arguments.length==4) {
      print("form:::1");
      navigateFrom=arguments['from'];
      driver_name=arguments['driver_name'];
      driver_number=arguments['mobile_number'];
      _position=arguments['position'];
      addMarkers();

    }else{
      print("form:::3");
      driver_name=arguments['driver_name'];
      driver_number=arguments['mobile_number'];
      _position=arguments['position'];
      addMarkers();

    }



    // if(arguments['position']==null){
    //   print("ok");
    //   _getCurrentLocation();
    // }else{
    //   print("ok-2");
    //   _position=arguments['position'];
    // }




    if(!loaded){
      //getDriverId

      setState(() {
        loaded=true;
      });
    }

  }

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        _driverStore.driverStatus(driver_number, isSwitched);
        textValue = 'Online';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        _driverStore.driverStatus(driver_number, isSwitched);
        textValue = 'Offline';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: _buildBody(),
    );
  }
  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return  Container(
      child: Stack(
        children: [

          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
            ),
          ),
          Visibility(
            visible: navigateFrom==0?true:false,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          isSwitched==true?
                          Text(textValue,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),)
                              :
                          Text(textValue,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                          Switch(
                            value: isSwitched,
                            onChanged: toggleSwitch,

                          )
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: InkWell(
                      onTap: (){
                        _userLogout();
                      },
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(Icons.logout)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }







  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _phoneController.dispose();
    super.dispose();
  }





  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        // isLoading = false;
      });
    });
  }

  _header() {
    return Container(
      child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("My Business Code",style: TextStyle(fontSize: 16.0),),
                SizedBox(height: 2.0,),
                Text("123456",style: TextStyle(fontSize: 20.0,color: Colors.indigo),)
              ],
            ),
            Container(
                height : 50.0,
                width: 50.0,
                child: Icon(Icons.login))
          ],
      ),
    );
  }

  Widget _driverList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemBuilder: (context,i)
    {
      return InkWell(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.vendor_dashboard, (Route<dynamic> route) => false);
              },
              child: Container(
                child: ListTile(
                  title: Text("Naimul Hassan Noor"),
                  subtitle: Text("123456"),
                  trailing: Icon(Icons.map),
                ) ,
              ),
            );
      }),
    );
  }

  void _userLogout() {
    _driverStore.driverLogout(driver_number!);
    Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.login, (Route<dynamic> route) => false,);

  }

  void _getCurrentLocation() async{
    print("get position:");
    GeolocatorWidget.getGeoLocationPosition().then((value) {
      print("current position:$value");
      LatLng newLatlon=LatLng(value.latitude, value.longitude);
      _position=newLatlon;
      addMarkers();
    });
  }

}


