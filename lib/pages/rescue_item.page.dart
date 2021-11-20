import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rescuer_app/blocs/rescue_item.bloc.dart';
import 'package:rescuer_app/constants/colors.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:rescuer_app/widgets/loading/loading.widget.dart';

/// This [StatefulWidget] is a page used to display more information about a rescue. (a RescueInfoData)
/// It receive [rescueInfo], [rescueItemBloc] and [getRescueSub] to deal with rescue info.
class RescueItemView extends StatefulWidget {
  final RescueInfo rescueInfo;
  final StreamSubscription<RescueInfoData> getRescueSub;
  final RescueItemBloc rescueItemBloc;

  const RescueItemView(
      {Key? key,
      required this.rescueInfo,
      required this.getRescueSub,
      required this.rescueItemBloc})
      : super(key: key);

  @override
  _RescueItemViewState createState() => _RescueItemViewState();
}

class _RescueItemViewState extends State<RescueItemView> {
  RescueInfoData? _rescueData;
  dynamic _rescueError;
  final rowItems = [];
  final missingData = const SnackBar(
    content: Text('Some data are missing in this rescue'),
    duration: Duration(seconds: 3),
    backgroundColor: AppColors.warning,
  );

  @override
  void initState() {
    super.initState();
    rowItems.add({
      'title': "Date",
      'desc': widget.rescueInfo.alertDate,
    });
    rowItems.add({
      'title': "Hour",
      'desc': widget.rescueInfo.alertTime,
    });
    rowItems.add({
      'title': "Victims",
      'desc': widget.rescueInfo.totalVictims.toString(),
    });
    widget.getRescueSub.resume();
    widget.getRescueSub.onData((data) {
      setState(() {
        _rescueData = data;
      });
    });
    widget.getRescueSub.onError((error) {
      setState(() {
        _rescueError = error['message'];
      });
    });
    widget.rescueItemBloc.getRescue(widget.rescueInfo.uuid!);
  }

  @override
  void dispose() {
    widget.getRescueSub.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rescue details'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.pop(context, true);
              }),
        ),
        body: SafeArea(
            child: ListView(children: <Widget>[
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blueAccent, Colors.lightBlueAccent])),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 24.0),
                    Hero(
                      tag: widget.rescueInfo.uuid!,
                      child: const Icon(Icons.health_and_safety,
                          size: 80, color: AppColors.warning),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      "Rescue Info",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 22.0),
                        child: Row(children: <Widget>[
                          ...rowItems.map((item) => Expanded(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    item['desc'],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )
                                ],
                              )))
                        ]),
                      ),
                    )
                  ])),
          getBottomView()
        ])));
  }

  Widget getBottomView() {
    if (_rescueData != null) {
      if (_rescueData!.place.isEmpty ||
          _rescueData!.resources.isEmpty ||
          _rescueData!.circumstances.isEmpty) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(missingData);
        });
      }
      return RescueDataView(rescueItemSrc: _rescueData!);
    } else if (_rescueError != null) {
      return Column(children: [SizedBox(height: 64), Text(_rescueError)]);
    } else {
      return Column(children: const [SizedBox(height: 64), LoadingWidget()]);
    }
  }
}

class RescueDataView extends StatelessWidget {
  final RescueInfoData rescueItemSrc;
  final listViewItems = [];

  RescueDataView({Key? key, required this.rescueItemSrc}) : super(key: key) {
    listViewItems.add({
      'icon': Icons.date_range,
      'title': "Accident date",
      'data': rescueItemSrc.accidentDate + ' at ' + rescueItemSrc.accidentTime,
      'error': 'Missing accident date and time'
    });
    listViewItems.add({
      'icon': Icons.map,
      'title': "Place",
      'data': rescueItemSrc.place,
      'error': 'Missing place data'
    });
    listViewItems.add({
      'icon': Icons.search,
      'title': "Circumstances",
      'data': rescueItemSrc.circumstances,
      'error': 'Missing circumstances data'
    });
    listViewItems.add({
      'icon': Icons.directions_car,
      'title': "Resources",
      'data': rescueItemSrc.resources,
      'error': 'Missing resources data'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...listViewItems.map((item) => Card(
            margin: const EdgeInsets.all(10.0),
            elevation: 5.0,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.only(
                  right: 12,
                ),
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(
                  width: 1.0,
                  color: Colors.blueAccent,
                ))),
                child: Icon(
                  item['icon'],
                  color: Colors.blueAccent,
                ),
              ),
              title: Text(
                item['title'],
              ),
              subtitle: Text(
                item['data'] != "" ? item['data'] : item['error'],
              ),
            ),
          ))
    ]);
  }
}
