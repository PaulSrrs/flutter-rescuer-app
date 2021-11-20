import 'dart:async';
import 'package:rescuer_app/models/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// This BLoC (business logic) is used to deal with Connectivity State of the application.
/// By this BLoC you can get the connectivity status once or listen to it.
class ConnectivityBloc implements Bloc {
  final Stream<ConnectivityResult> _controller = Connectivity().onConnectivityChanged;
  ConnectivityResult? _status;

  ConnectivityResult? get connectivityStatus => _status;

  /// This method permit to get the connectivity status one time and store it.
  checkConnectivityOnce(Function(ConnectivityResult res) fn) async {
    return Connectivity().checkConnectivity().then((result) {
      _status = result;
      fn(result);
    });
  }

  /// This method permit to subscribe to connectivity status change.
  listen(Function(ConnectivityResult res) fn) {
    return _controller.listen((result) {
      fn(result);
      _status = result;
    });
  }

  @override
  void dispose() {
    // nothing to dispose
  }
}

final connectivityBloc = ConnectivityBloc();