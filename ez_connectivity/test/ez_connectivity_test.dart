import 'package:ez_connectivity/ez_connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MockConnectivity implements Connectivity {
  final ConnectivityResult mockedResult;
  MockConnectivity({required this.mockedResult});

  @override
  Future<ConnectivityResult> checkConnectivity() {
    return Future.value(mockedResult);
  }

  @override
  // ignore this override
  Stream<ConnectivityResult> get onConnectivityChanged => throw UnimplementedError();
}

class MockEzConnectivity extends StatefulWidget {
  final Widget connected;
  final Widget disconnected;
  final Widget loading;
  final ConnectivityResult mockedResult;

  const MockEzConnectivity({
    Key? key,
    required this.mockedResult,
    required this.connected,
    required this.disconnected,
    required this.loading}) : super(key: key);

  @override
  EzConnectivityState createState() => EzConnectivityState();
}

class EzConnectivityState extends State<MockEzConnectivity> {
  bool? isConnected;

  @override
  void initState() {
    super.initState();
    MockConnectivity(mockedResult: widget.mockedResult).checkConnectivity().then((result) {
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

void main() {
  testWidgets('Test loading network status', (WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Scaffold(
                body: EzConnectivity(
                    connected: InternetPageWidget(),
                    disconnected: NoInternetPageWidget(),
                    loading: LoadingPageWidget()
                )
            )
        )
    );
    final connectedFinder = find.text('I am currently looking for network status.');

    expect(connectedFinder, findsOneWidget);
  });

  testWidgets('Test connected to a network.', (WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MockEzConnectivity(
                mockedResult: ConnectivityResult.mobile, //ignore this arguments for production, used for test only
                connected: InternetPageWidget(),
                disconnected: NoInternetPageWidget(),
                loading: LoadingPageWidget()
            )
          )
        )
    );
    await tester.pump(const Duration(seconds: 5)); //wait for the future to be satisfied
    final connectedFinder = find.text('I am connected to a network.');

    expect(connectedFinder, findsOneWidget);
  });

  testWidgets('Test not connected to a network.', (WidgetTester tester) async {
    await tester.pumpWidget(
        const MaterialApp(
            home: Scaffold(
                body: MockEzConnectivity(
                    mockedResult: ConnectivityResult.none, //ignore this arguments for production, used for test only
                    connected: InternetPageWidget(),
                    disconnected: NoInternetPageWidget(),
                    loading: LoadingPageWidget()
                )
            )
        )
    );
    await tester.pump(const Duration(seconds: 5)); //wait for the future to be satisfied
    final connectedFinder = find.text('I am not connected to a network.');

    expect(connectedFinder, findsOneWidget);
  });
}

class InternetPageWidget extends StatelessWidget {
  const InternetPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("I am connected to a network.");
  }
}

class NoInternetPageWidget extends StatelessWidget {
  const NoInternetPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("I am not connected to a network.");
  }
}

class LoadingPageWidget extends StatelessWidget {
  const LoadingPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("I am currently looking for network status.");
  }
}