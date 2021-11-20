import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This function is used to display IOS style (Cupertino) or Android style (Material) date picker dialog.
Future<String?> appShowCustomDatePicker(BuildContext context, bool isIos) async {
  DateTime? date;

  if (!isIos) {
    date = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      firstDate: DateTime.utc(1970, 1, 1),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
  } else {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                date = value;
              },
              minimumDate: DateTime.utc(1970, 1, 1),
              initialDateTime: DateTime.now(),
              maximumDate: DateTime.now(),
            ),
          );
        });
  }
  if (date != null) {
    return "${date?.year}-${date?.month.toString().padLeft(2, "0")}-${date?.day.toString().padLeft(2, "0")}";
  } else {
    return null;
  }
}
