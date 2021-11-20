import 'package:flutter/material.dart';

/// This [StatelessWidget] is used to display a centered [CircularProgressIndicator.adaptive] to the screen.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
