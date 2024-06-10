import 'package:template/src/settings/settings_view_provider.dart';
import 'package:template/src/views/axios_view.dart';
import 'package:template/src/views/firebase/todo.dart';
import 'package:template/src/views/google/map.dart';
import 'package:template/src/views/login_signup/login_singup_view.dart';
import 'package:flutter/material.dart';

import 'route_item.dart';
import '../views/sample_item_details_view.dart';

/// Displays a list of SampleItems.
class RouteListView extends StatelessWidget {
  const RouteListView({
    super.key,
    this.items = const [
      RouteItem("샘플 아이템", SampleItemDetailsView.routeName),
      RouteItem("로그인", LoginSingupView.routeName),
      RouteItem("세팅", SettingsViewWithProvider.routeName),
      RouteItem("Axios 테스트", AxiosView.routeName),
      RouteItem("구글맵", MapSampleView.routeName),
      RouteItem("파이어베이스", TodoView.routeName),
    ],
  });

  static const routeName = '/';

  final List<RouteItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라우팅 뷰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(
                  context, SettingsViewWithProvider.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'routeListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.name),
              leading: const CircleAvatar(
                  // Display the Flutter Logo image asset.
                  // foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                  ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  item.route,
                );
              });
        },
      ),
    );
  }
}
