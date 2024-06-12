import 'package:template/src/views/firebase/todo.dart';
import 'package:template/src/views/google/map.dart';
import 'package:template/src/views/google/mapLocation.dart';
import 'package:template/src/views/login_signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/setting.dart';
import 'route/route_item_list_view.dart';
import 'settings/settings_view_provider.dart';
import 'views/axios_view.dart';
import 'views/login_signup/login_singup_view.dart';
import 'views/sample_item_details_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      // SettingsController to display the correct theme.
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<Setting>().themeMode,

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case SettingsViewWithProvider.routeName:
                return const SettingsViewWithProvider();
              case SampleItemDetailsView.routeName:
                return const SampleItemDetailsView();
              case LoginSingupView.routeName:
                return const LoginSingupView();
              case AxiosView.routeName:
                return const AxiosView();
              case MapSampleView.routeName:
                return const MapSampleView();
              case MapScreen.routeName:
                return MapScreen();
              case TodoView.routeName:
                return const TodoView();
              case RouteListView.routeName:
              default:
                return const RouteListView();
            }
          },
        );
      },
    );
  }
}
