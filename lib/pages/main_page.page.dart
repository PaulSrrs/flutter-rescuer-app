import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rescuer_app/blocs/connectivity.bloc.dart';
import 'package:rescuer_app/blocs/rescue_item.bloc.dart';
import 'package:rescuer_app/blocs/rescue_list.bloc.dart';
import 'package:rescuer_app/constants/colors.dart';
import 'package:rescuer_app/constants/requests_limit.dart';
import 'package:rescuer_app/constants/rescue_method.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:rescuer_app/providers/bloc_provider.dart';
import 'package:rescuer_app/widgets/loading/loading.widget.dart';
import 'package:rescuer_app/pages/put_or_post_rescue.page.dart';
import 'package:rescuer_app/pages/rescue_list.page.dart';
import 'package:rescuer_app/widgets/error/error.widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// This [StatefulWidget] is a page used to display the first page of the application.
/// It can be a page with a [LoadingWidget], a page with an [AppErrorWidget] or the [RescueList] page.
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late StreamSubscription connectivitySubscription;
  List<RescueInfo>? rescueItemsSrc;
  String? errorMessage;
  late StreamSubscription<RescueInfoData> _postSub;
  late RescueItemBloc _rescueItemBloc;

  @override
  void initState() {
    super.initState();
    _rescueItemBloc = BlocProvider.of<RescueItemBloc>(context)!;
    SnackBar internetOn = const SnackBar(
      content: Text('The internet connection has been restored'),
      duration: Duration(seconds: 3),
      backgroundColor: AppColors.success,
    );
    SnackBar internetOff = const SnackBar(
      content: Text('You\'re not connected to the internet'),
      duration: Duration(days: 365),
      backgroundColor: AppColors.warning,
    );

    connectivitySubscription =
        connectivityBloc.listen((ConnectivityResult result) {
      if (result != connectivityBloc.connectivityStatus) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (result == ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(internetOff);
        } else if (connectivityBloc.connectivityStatus ==
            ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(internetOn);
        }
      }
    });
    _postSub = _rescueItemBloc.postRescueStream.listen((_) {});
    _postSub.pause();
    getFirstRescues();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    _postSub.cancel();
    super.dispose();
  }

  getFirstRescues() {
    setState(() {
      errorMessage = null;
    });
    BlocProvider.of<RescueListBloc>(context)!.getRescueList(rescueListGetLimit, 0).then((fetchedData) {
      if (fetchedData.errorMessage != null) {
        setState(() {
          errorMessage = fetchedData.errorMessage;
        });
      } else {
        setState(() {
          rescueItemsSrc = fetchedData.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rescuer App'),
          actions: <Widget>[
            rescueItemsSrc != null ? IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PutOrPostRescuePage(
                            method: RescueMethod.post,
                            uuid: '',
                            getRescueSub: null,
                            putRescueSub: null,
                            postRescueSub: _postSub,
                            rescueItemBloc: _rescueItemBloc),
                      ));
                },
                icon: const Icon(Icons.add, size: 28)) : Container(),
          ],
        ),
        body: initFirstPage());
  }

  Widget initFirstPage() {
    if (rescueItemsSrc != null) {
      return RescueList(postRescueSub: _postSub);
    } else if (errorMessage != null) {
      return AppErrorWidget(
          error: errorMessage!, callback: () => getFirstRescues());
    } else {
      return const LoadingWidget();
    }
  }
}
