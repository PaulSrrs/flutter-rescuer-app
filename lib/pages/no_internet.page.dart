import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// This [StatelessWidget] is a page used to display a lottie animation if the user is not connected to any network.
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            height: size.height * 0.7,
            width: size.width * 0.8,
            child: Lottie.asset('assets/no-internet.json'),
          ),
          const SizedBox(height: 24),
          const Text('You\'re not connected to the internet')
        ])));
  }
}
