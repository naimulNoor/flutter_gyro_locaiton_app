import 'package:GyroLocationApp/constants/app_theme.dart';
import 'package:GyroLocationApp/constants/strings.dart';
import 'package:GyroLocationApp/data/driver_firestore_repository.dart';
import 'package:GyroLocationApp/data/repository.dart';
import 'package:GyroLocationApp/data/vendor_firestore_repository.dart';
import 'package:GyroLocationApp/di/components/service_locator.dart';
import 'package:GyroLocationApp/stores/driver/driver_store.dart';
import 'package:GyroLocationApp/stores/vendor/vendor_store.dart';
import 'package:GyroLocationApp/ui/login/splash_screen.dart';
import 'package:GyroLocationApp/ui/login/vendor_dashboard.dart';
import 'package:GyroLocationApp/utils/routes/routes.dart';
import 'package:GyroLocationApp/stores/language/language_store.dart';
import 'package:GyroLocationApp/stores/post/post_store.dart';
import 'package:GyroLocationApp/stores/theme/theme_store.dart';
import 'package:GyroLocationApp/stores/user/user_store.dart';
import 'package:GyroLocationApp/ui/home/home.dart';
import 'package:GyroLocationApp/ui/login/login.dart';
import 'package:GyroLocationApp/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../widgets/geolocator_widget.dart';
import 'login/create_vendor_screen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final PostStore _postStore = PostStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final UserStore _userStore = UserStore(getIt<Repository>());
  final VendorStore _vendorStore = VendorStore(getIt<VendorFireStoreRepository>());
  final DriverStore _driverStore = DriverStore(getIt<DriverFireStoreRepository>());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<PostStore>(create: (_) => _postStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
        Provider<VendorStore>(create: (_) => _vendorStore),
        Provider<DriverStore>(create: (_) => _driverStore),
      ],
      child: Observer(
        name: 'global-observer',
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            theme: _themeStore.darkMode ? themeDataDark : themeData,
            routes: Routes.routes,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale!, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}