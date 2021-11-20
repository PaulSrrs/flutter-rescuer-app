import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This function is used to display IOS style (Cupertino) or Android style (Material) time picker dialog.
Future<String?> appShowCustomTimePicker(BuildContext context, bool isIOS) async {
  DateTime? date;
  final now = DateTime.now();

  if (!isIOS) {
    final TimeOfDay? t = await showTimePicker(
        context: context,
        // It is a must if you provide selectableTimePredicate
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute));
    if (t != null) {
      final now = DateTime.now();
      date = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    }
  } else {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              onDateTimeChanged: (value) {
                date = value;
              },
              minimumDate: DateTime.utc(1970, 1, 1),
              initialDateTime: DateTime.now()
            ),
          );
        });
  }
  if (date != null) {
    return "${date?.hour.toString().padLeft(2, "0")}:${date?.minute.toString().padLeft(2, "0")}";
  } else {
    return null;
  }
}