library ez_connectivity;

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EzConnectivity extends StatefulWidget {
  final Widget connected;
  final Widget disconnected;
  final Widget loading;
  const EzConnectivity({
    Key? key,
    required this.connected,
    required this.disconnected,
    required this.loading}) : super(key: key);

  @override
  EzConnectivityState createState() => EzConnectivityState();
}

@visibleForTesting
class EzConnectivityState extends State<EzConnectivity> {
  bool? isConnected;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isConnected = false;
        });
      } else {
        setState(() {
          isConnected = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected == true) {
      return widget.connected;
    } else if (isConnected == false) {
      return widget.disconnected;
    } else {
      return widget.loading;
    }
  }
}
