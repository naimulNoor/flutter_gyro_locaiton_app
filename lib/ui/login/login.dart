import 'package:GyroLocationApp/utils/routes/routes.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:GyroLocationApp/ui/login/verify_otp_screen.dart';
import 'package:flutter/foundation.dart';

import 'package:mobx/mobx.dart';


import 'package:GyroLocationApp/stores/language/language_store.dart';
import 'package:GyroLocationApp/stores/theme/theme_store.dart';
import 'package:GyroLocationApp/ui/app/const/AppColors.dart';
import 'package:GyroLocationApp/utils/device/device_utils.dart';
import 'package:GyroLocationApp/utils/locale/app_localization.dart';
import 'package:GyroLocationApp/widgets/empty_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  //text controllers:-----------------------------------------------------------


  int checkedIndex = 0;

  List cardNames = [
    'Driver',
    'Verdor',
  ];

  TextEditingController _phoneController = TextEditingController();
  bool _obscureText = true;
  bool _obscure = false;

  int currentTap=0;

  //stores:---------------------------------------------------------------------

  late ThemeStore _themeStore;
  late LanguageStore _languageStore;


  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  //stores:---------------------------------------------------------------------


  TextEditingController? textController1;
  TextEditingController? textController2;
  late bool passwordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    passwordVisibility = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);


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
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Form(
            // key: _loginFormKey,
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text('Logo',
                      style:
                      TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 15,),
                  Text("Signup As",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  SizedBox(height: 20,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscure=false;
                            _obscureText = !_obscureText;
                            currentTap =0;
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: _obscureText ? Colors.green : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 40,
                                  color: _obscureText
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Text(
                                  'Driver',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: _obscureText
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 30,),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText=false;
                            _obscure = !_obscure;
                            currentTap=1;
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: _obscure ? Colors.green : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 40,
                                  color: _obscure
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Text(
                                  'Vendor',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: _obscure
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please Enter Valid Info';
                      }else{
                        return null;
                      }
                    },
                    // focusNode: _emailNode,
                    textInputAction: TextInputAction.next,
                    //onEditingComplete: () => FocusScope.of(context).requestFocus(_passNode),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        //labelText: 'Enter username',
                        hintText: "Enter mobile number",
                        enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red,width: 5),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),

                  SizedBox(height: 30,),

                  MaterialButton(
                    onPressed: (){
                    //   Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => VerifyOtpScreen(_phoneController.text)),
                    // );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.verify_otp, (Route<dynamic> route) => false,arguments:
                        {
                          "mobile":_phoneController.text,
                          "login_type":currentTap
                        }
                      );},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: AppColors.deep_blue,
                    child: Text(
                      'NEXT',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    _passwordFocusNode.dispose();
    super.dispose();
  }


}
