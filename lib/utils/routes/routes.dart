import 'package:GyroLocationApp/ui/home/home.dart';
import 'package:GyroLocationApp/ui/login/create_vendor_screen.dart';
import 'package:GyroLocationApp/ui/login/driver_location.dart';
import 'package:GyroLocationApp/ui/login/login.dart';
import 'package:GyroLocationApp/ui/login/vendor_dashboard.dart';
import 'package:GyroLocationApp/ui/login/verify_otp_screen.dart';
import 'package:GyroLocationApp/ui/splash/splash.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String vendor_dashboard = '/vendor_dashboard';
  static const String driver_locaiton = '/driver_map';
  static const String verify_otp = '/verify_otp';
  static const String create_profile = '/create_profile';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    vendor_dashboard: (BuildContext context) => VendorDashboard(),
    driver_locaiton: (BuildContext context) => DriverLocation(),
    verify_otp: (BuildContext context) => VerifyOtpScreen(),
    create_profile: (BuildContext context) => CreateVendorScreen(),
  };
}



