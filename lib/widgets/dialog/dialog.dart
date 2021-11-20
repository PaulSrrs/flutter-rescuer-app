import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This [StatelessWidget] is used to deal with dialog.
/// Depending on the platform, it displays IOS style (Cupertino) or Android style (Material) alert dialog.
class AppDialog extends StatelessWidget {
  final bool isIOS;
  final String title;
  final String content;
  final String confirmText;
  final bool confirmBtnEnableFeedback;
  final String cancelText;
  final VoidCallback confirmCallback;
  final VoidCallback cancelCallback;

  const AppDialog({
    required this.isIOS,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.confirmCallback,
    required this.cancelCallback,
    this.confirmBtnEnableFeedback = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isIOS ?
    AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            key: const Key('cancel'),
            child: Text(cancelText),
            onPressed: () {
              cancelCallback();
            },
          ),
          TextButton(
              key: const Key('confirm'),
              style: ButtonStyle(enableFeedback: confirmBtnEnableFeedback), //remove default sound on Android
              child: Text(confirmText),
              onPressed: () => confirmCallback()
          )
        ]
    ) : CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        CupertinoDialogAction(
          key: const Key('cancel'),
          child: Text(cancelText),
          onPressed: () => cancelCallback(),
        ),
        CupertinoDialogAction(
          key: const Key('confirm'),
          isDefaultAction: true,
          child: Text(confirmText),
          onPressed: () => confirmCallback(),
        ),
      ]
    );
  }
}
