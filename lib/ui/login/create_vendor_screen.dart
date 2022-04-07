import 'package:GyroLocationApp/stores/driver/driver_store.dart';
import 'package:GyroLocationApp/utils/routes/routes.dart';
import 'package:GyroLocationApp/widgets/geolocator_widget.dart';
import 'package:GyroLocationApp/widgets/progress_indicator_widget.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:GyroLocationApp/models/app/vendor.dart';
import 'package:GyroLocationApp/stores/vendor/vendor_store.dart';
import 'package:GyroLocationApp/ui/app/ui/drivers_ui/create_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:GyroLocationApp/stores/language/language_store.dart';
import 'package:GyroLocationApp/stores/theme/theme_store.dart';
import 'package:GyroLocationApp/ui/app/const/AppColors.dart';
import 'package:GyroLocationApp/utils/device/device_utils.dart';
import 'package:GyroLocationApp/utils/locale/app_localization.dart';
import 'package:GyroLocationApp/widgets/empty_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateVendorScreen extends StatefulWidget {



  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<CreateVendorScreen> with TickerProviderStateMixin{
  //text controllers:-----------------------------------------------------------


  int checkedIndex = 0;


  TextEditingController _phoneController = TextEditingController();
  bool _obscureText = false;
  bool _obscure = false;

  //stores:---------------------------------------------------------------------

  late ThemeStore _themeStore;
  late LanguageStore _languageStore;
  late VendorStore _vendorStore;
  late DriverStore _driverStore;

  //focus node:-----------------------------------------------------------------


  //stores:---------------------------------------------------------------------


  TextEditingController _nameController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  late bool passwordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loaded=false;
  String inputOtpPin="";
  String mobileNumber="";
  String loginType="";
  String codeTitle="Enter Vendor Code";
  String businessCOde="Enter Business Code";
  var _currentPosition=null;
  var _curretnLatlon=null;




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    GeolocatorWidget.getGeoLocationPosition().then((value) {

      print("current position:$value");
      _curretnLatlon=LatLng(value.latitude, value.longitude);
      _currentPosition=value;
      _currentPosition=value;
    });
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    mobileNumber=arguments['mobile'];
    loginType=arguments["login_type"];


    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _vendorStore = Provider.of<VendorStore>(context);
    _driverStore = Provider.of<DriverStore>(context);

    if(!loaded){
      // print("enter verify screen");
      //_authWork();
      setState(() {
        loaded=true;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                // key: _loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 40,),
                        Text('Create Profile',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please Enter Valid Name';
                              }else{
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: 'Enter Full Name',
                                hintText: 'John Smith',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Please Enter Valid Code';
                              }else{
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: loginType=="0"?codeTitle:businessCOde,
                                hintText: '545460',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        MaterialButton(
                          onPressed: (){
                            print(loginType);
                            if(loginType=="0"){
                              _addDriverData();
                            }else{
                              _addVendroData();
                            }

                          }, shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                          minWidth:1,
                          height: 50,
                          color: AppColors.deep_blue,
                          child: Text(
                            'SAVE',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white
                          ),
                          ),
                        ),
                        SizedBox(height: 100,),
                        Observer(
                          builder: (context) {
                            print("loader-vendor:::${_vendorStore.isVendorCreated}");
                            return Visibility(
                              visible: _vendorStore.loading,
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        Observer(
                          builder: (context) {
                            print("loader-vendor:::${_driverStore.isDriverCreated}");
                            return Visibility(
                              visible: _driverStore.loading,
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        Observer(
                          builder: (context) {
                            return  _vendorStore.success
                                ?navigate(context,1)
                                :Container(); //unsecess message
                          },
                        ),
                        Observer(
                          builder: (context) {
                            return  _driverStore.success
                                ?navigate(context,0)
                                :Container(); //unsecess message
                          },
                        ),

                      ],
                    ),
                  )
              ),
            ],
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

  void _addVendroData() {
    print("add vendor");

   _vendorStore.addVendor(_nameController.text,mobileNumber,_codeController.text);

  }

  Widget navigate(BuildContext context,int type) {
    if(type==1){
      Future.delayed(Duration(milliseconds: 0), () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.vendor_dashboard, (Route<dynamic> route) => false,arguments:
        {

            "name":_nameController.text,
            "number":mobileNumber,
            "vendor_code":_codeController.text


        }
        );
      });
    }else{
      Future.delayed(Duration(milliseconds: 0), () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.driver_locaiton, (Route<dynamic> route) => false,arguments:
        {
          "position":_curretnLatlon,
          "driver_name":_nameController.text,
          "mobile_number":mobileNumber

        }
        );
      });
    }


    return Container();
  }

  void _addDriverData() {
    print("add driver-$mobileNumber");
    _driverStore.addDriver(_nameController.text,mobileNumber,_codeController.text,_currentPosition);
  }


}
