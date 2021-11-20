import 'package:flutter/material.dart';

/// This [StatelessWidget] is used to display error. It receives a [error] and a [callback].
/// The [error] is displayed to the screen and the [callback] is called when the used click on the 'Retry' button.
class AppErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback callback;

  const AppErrorWidget({Key? key, required this.error, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(error),
      const SizedBox(height: 24),
      TextButton(onPressed: () => callback(), child: const Text("Retry"))
    ]));
  }
}
