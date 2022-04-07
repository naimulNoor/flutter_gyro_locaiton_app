import 'package:GyroLocationApp/stores/driver/driver_store.dart';
import 'package:GyroLocationApp/stores/vendor/vendor_store.dart';
import 'package:GyroLocationApp/utils/routes/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:GyroLocationApp/stores/language/language_store.dart';
import 'package:GyroLocationApp/stores/theme/theme_store.dart';
import 'package:GyroLocationApp/ui/app/const/AppColors.dart';
import 'package:GyroLocationApp/utils/device/device_utils.dart';
import 'package:GyroLocationApp/utils/locale/app_localization.dart';
import 'package:GyroLocationApp/widgets/empty_app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class VendorDashboard extends StatefulWidget {


  VendorDashboard();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VendorDashboard> with TickerProviderStateMixin {
  //text controllers:-----------------------------------------------------------


  int checkedIndex = 0;


  TextEditingController _phoneController = TextEditingController();
  bool _obscureText = false;
  bool _obscure = false;

  //stores:---------------------------------------------------------------------

  late ThemeStore _themeStore;
  late LanguageStore _languageStore;


  //focus node:-----------------------------------------------------------------

  late VendorStore _vendorStore;
  late DriverStore _driverStore;

  //stores:---------------------------------------------------------------------


  TextEditingController? textController1;
  TextEditingController? textController2;
  late bool passwordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loaded = false;
  String inputOtpPin = "";

  String vendor_name = "";
  String vendor_code = "";
  String? vendro_number = "";


  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _vendorStore = Provider.of<VendorStore>(context);
    _driverStore = Provider.of<DriverStore>(context);


    if (!loaded) {
      final arguments = (ModalRoute
          .of(context)
          ?.settings
          .arguments ?? <String, dynamic>{}) as Map;
      print("form-argument:::${arguments.length.toString()}");


      if (arguments.length != 0) {
        vendor_name = arguments['name'];
        vendro_number = arguments['number'];
        vendor_code = arguments['vendor_code'];
      } else {
        _getVendorNumberFromAUth();
        _vendorStore.getVendorInfo(vendro_number!).then((value) {
          print("vendor-data");

          print(value['name'] as String);
          vendor_name = value['name'] as String;
          vendro_number = value['number'] as String;
          vendor_code = value['vendor_code'] as String;
          print(value['vendor_code'] as String);
        });
      }


      setState(() {
        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffE9ECF4),

        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                    child: _header()),
                Expanded(
                  flex:2,
                    child: _driverList())
              ],
            ),
          ),
        ),
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
          )
            ..show(context);
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
              Text("My Business Code", style: TextStyle(fontSize: 16.0),),
              SizedBox(height: 2.0,),
              Text(vendor_code,
                style: TextStyle(fontSize: 20.0, color: Colors.indigo),)
            ],
          ),
          InkWell(
            onTap: () {
              _vendorStore.vendorLogout(vendro_number!);
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login, (Route<dynamic> route) => false,
              );
            },
            child: Container(
                height: 50.0,
                width: 50.0,
                child: Icon(Icons.logout)),
          )
        ],
      ),
    );
  }

  Widget _driverList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: _driverStore.getDriverList(vendor_code),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data?.size==0){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Driver Online",style: TextStyle(color: Colors.blue,fontSize: 20.0),)
                  ],
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, i) {
                    double a = double.parse(
                        snapshot.data?.docs[i].get("driver_lat"));
                    double b = double.parse(
                        snapshot.data?.docs[i].get("driver_lon"));
                    LatLng _currentPosition = LatLng(a, b);
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            Routes.driver_locaiton,
                            arguments:
                            {
                              "from": 1,
                              "position": _currentPosition,
                              "driver_name": snapshot.data?.docs[i].get("driver_name"),
                              "mobile_number": snapshot.data?.docs[i].get("driver_number")
                            }
                        );
                      },
                      child: Container(
                        child: ListTile(
                          title: Text(snapshot.data?.docs[i].get(
                              "driver_name")),
                          subtitle: Text(snapshot.data?.docs[i].get(
                              "driver_number")),
                          trailing: Icon(Icons.map),
                        ),
                      ),
                    );
                  });
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }
      ),
    );
  }

  void _getVendorNumberFromAUth() {
    vendro_number = FirebaseAuth.instance.currentUser?.phoneNumber;
  }
}


