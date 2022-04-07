import 'package:GyroLocationApp/utils/routes/routes.dart';
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
import 'package:mobx/mobx.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_vendor_screen.dart';

class VerifyOtpScreen extends StatefulWidget {

 // VerifyOtpScreen(this.number);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VerifyOtpScreen> with TickerProviderStateMixin{
  //text controllers:-----------------------------------------------------------


  int checkedIndex = 0;


  TextEditingController _phoneController = TextEditingController();
  bool _obscureText = false;
  bool _obscure = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //stores:---------------------------------------------------------------------

  late ThemeStore _themeStore;
  late LanguageStore _languageStore;


  //focus node:-----------------------------------------------------------------


  //stores:---------------------------------------------------------------------


  TextEditingController? textController1;
  TextEditingController? textController2;
  late bool passwordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loaded=false;
  String inputOtpPin="";
  String mobileNumber="";
  String loginType="";
  String verificationId="";




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    mobileNumber=arguments['mobile'];
    loginType=arguments["login_type"].toString();
    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);




    if(!loaded){
      // print("enter verify screen");
        _authWork();
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
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffE9ECF4),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                // key: _loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 80,),
                        Center(child: Text('Verify OTP',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),)),
                        SizedBox(height: 20,),
                        Text('Enter 6 Digits Code',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                        ),),
                        SizedBox(height: 10,),
                        Text('Enter the 6 digits code that you received',style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                        ),),
                        Text('on your mobile number',style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey
                        ),),
                        SizedBox(height: 20,),
                        OTPTextField(
                          length:6,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 45,
                          style: TextStyle(
                              fontSize: 15
                          ),
                          textFieldAlignment: MainAxisAlignment.center,
                          keyboardType: TextInputType.number,
                          outlineBorderRadius: 5,
                          fieldStyle: FieldStyle.box,
                          onCompleted: (pin) {
                            print("Completed: " + pin);
                            inputOtpPin=pin;
                          },
                        ),
                        SizedBox(height: 20,),

                        MaterialButton(
                          onPressed: ()async{
                            verifyOtp();
                            },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          minWidth: 1000,
                          height: 50,
                          color: AppColors.deep_blue,
                          child: Text(
                            'VERIFY',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white
                          ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        TextButton(onPressed: (){
                          _authWork();
                        },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline
                              ),
                            )
                        )
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


  Future<void> _loginFirebaseUser(String phone, BuildContext context) async {
    print("on enter");

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 30),
      verificationCompleted: (AuthCredential credential) async{
        print("on verification");
        Navigator.of(context).pop();
        UserCredential result = await _auth.signInWithCredential(credential);
        User? user = result.user;
        print(credential.toString());
        print(user.toString());
        if(user != null){

        }else{
          print("Error");
        }//This callback would gets called when verification is done auto maticlly
      },
      verificationFailed: (FirebaseAuthException exception){
        print(exception.toString());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken){
        this.verificationId=verificationId;
      }
    );



    }

  void _authWork()async {
    DeviceUtils.hideKeyboard(context);
    _loginFirebaseUser(mobileNumber, context);


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

  void _createProfile() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.create_profile, (Route<dynamic> route) => false,arguments:
    {
      "mobile":mobileNumber,
      "login_type":loginType
    }
    );
  }


  verifyOtp() async{
    if(verificationId !=null){
      final AuthCredential authCredential = PhoneAuthProvider.credential(
        smsCode: inputOtpPin,
        verificationId: verificationId,
      );
      try {
        UserCredential result = await _auth.signInWithCredential(authCredential);
        _createProfile();

        if (result!=null){
          print(result.toString());

        }else{
          print("wrong code");

        }
      } on PlatformException catch (e) {
        print(e.toString());
      } on FirebaseAuthException catch(e) {
        print(e.toString());
      }
    }
  }



}
