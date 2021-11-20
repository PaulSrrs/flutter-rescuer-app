This plugin allows Flutter applications to be able to display a widget depending on the status of the network.

## Platform Support

| Android | Web | Linux | Windows |
| :-----: | :-: | :---: | :-----: |
|   ✔️  |  ✔  |  ✔️|   ✔️  |

## Usage


If you are connected to a network, the 1st widget (connected) will be displayed. <br />
If you are not connected to a network, the 2nd widget (disconnected) will be displayed. <br />
If the application requests for the network status, the 3rd widget (loading) will be displayed. <br />

Sample usage to display a widget:

```dart
import 'package:ez_connectivity/ez_connectivity.dart';

EzConnectivity(
    connected: InternetPageWidget(),
    disconnected: NoInternetPageWidget(),
    loading: LoadingPageWidget()
);
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:ez_connectivity/ez_connectivity.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
        home: Scaffold(
            body: Center(
                child: EzConnectivity(
                    connected: InternetPageWidget(),
                    disconnected: NoInternetPageWidget(),
                    loading: LoadingPageWidget()
                )
            )
        )
    );
  }
}

class InternetPageWidget extends StatelessWidget{
  const InternetPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("I am connected to a network.");
  }
}

class NoInternetPageWidget extends StatelessWidget{
  const NoInternetPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("I am not connected to a network.");
  }
}

class LoadingPageWidget extends StatelessWidget{
  const LoadingPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("I am currently looking for network status.");
  }
}
```