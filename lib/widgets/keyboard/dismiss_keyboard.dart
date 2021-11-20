import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This [StatelessWidget] is used to permit to the user to close the keyboard when he clicks outside of it.
class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({required this.child, Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null &&
            FocusManager.instance.primaryFocus != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}