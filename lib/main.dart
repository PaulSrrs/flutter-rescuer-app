import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rescuer_app/blocs/connectivity.bloc.dart';
import 'package:rescuer_app/blocs/rescue_item.bloc.dart';
import 'package:rescuer_app/blocs/rescue_list.bloc.dart';
import 'package:rescuer_app/client/rescuer_client.dart';
import 'package:rescuer_app/pages/main_page.page.dart';
import 'package:rescuer_app/pages/no_internet.page.dart';
import 'package:rescuer_app/providers/bloc_provider.dart';
import 'package:rescuer_app/services/is_phone_or_tablet.service.dart';
import 'package:rescuer_app/themes/theme_data.dart';
import 'package:rescuer_app/widgets/keyboard/dismiss_keyboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

/// This function is used to launch the application.
/// It will ensure that all the widgets are initialized and determine the client used.
/// Then, it will runApp with the [MyApp] page nested in a [BlocProvider] with [RescueListBloc] bloc.
/// The connectivity status will be send to [MyApp].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RescuerClient client = RescuerClient(client: http.Client());

  connectivityBloc.checkConnectivityOnce((connectivity) {
    runApp(BlocProvider(bloc: RescueListBloc(client: client), child: MyApp(connectivityResult: connectivity, client: client)));
  });
}

/// This [StatefulWidget] is the first page of the application.
/// It receives the [connectivityResult] and the [client] used.
/// The [connectivityResult] is used to determine which page will be displayed between [NoInternetPage] and [MainPage].
/// The [client] is used to deal with API requests.
class MyApp extends StatefulWidget {
  final ConnectivityResult connectivityResult;
  final RescuerClient client;

  const MyApp(
      {Key? key, required this.connectivityResult, required this.client})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription connectivitySubscription;
  late ConnectivityResult connectivityResult;

  @override
  void initState() {
    super.initState();
    connectivityResult = widget.connectivityResult;

    connectivitySubscription =
        connectivityBloc.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        connectivitySubscription.cancel();
      }
      if (result != connectivityBloc.connectivityStatus) {
        if (result != ConnectivityResult.none && result != connectivityResult) {
          setState(() {
            connectivityResult = result;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    connectivityBloc.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
        child: MaterialApp(
            title: 'Rescuer App',
            theme: AppThemeData.getTheme(IsPhoneOrTabletService.getDeviceType()),
            home: getFirstDisplayedPage()));
  }

  Widget getFirstDisplayedPage() {
    if (connectivityResult == ConnectivityResult.none) {
      return const NoInternetPage();
    } else {
      return BlocProvider(bloc: RescueItemBloc(client: widget.client), child: const MainPage());
    }
  }
}
