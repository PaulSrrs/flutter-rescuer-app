import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rescuer_app/constants/colors.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:rescuer_app/services/format_date.service.dart';

/// This [StatelessWidget] is used to display rescueInfo card to the screen.
/// It receives [rescueInfo] which contains the displayed rescue's information.
class ListCard extends StatelessWidget {
  final RescueInfo rescueInfo;

  const ListCard({Key? key, required this.rescueInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: ListTile(
        leading: Hero(
          tag: rescueInfo.uuid!,
          child: Container(
            padding: const EdgeInsets.only(
              right: 12,
            ),
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(
              width: 1.0,
              color: Color.fromRGBO(209, 224, 224, 1),
            ))),
            child: const Icon(Icons.health_and_safety,
                size: 40, color: AppColors.warning),
          ),
        ),
        title: Text(FormatDateService.formatDate(rescueInfo.alertDate) +
            " | " +
            rescueInfo.alertTime),
        subtitle: Row(
          children: [
            Expanded(
                flex: 1,
                child: _buildSeverityProgressBar(rescueInfo.totalVictims)),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                      rescueInfo.totalVictims.toString() + " victims expected",
                      style: TextStyle(
                          fontSize: Theme.of(context).textTheme.subtitle1!.fontSize)
                  )
              ),
            )
          ],
        ),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
      ),
    );
  }

  Widget _buildSeverityProgressBar(int totalVictim) {
    final severityValue = max(0, min(10, totalVictim)) / 10;
    return LinearProgressIndicator(
        value: severityValue,
        color: Color.lerp(Colors.green, Colors.red[500], severityValue),
        backgroundColor: const Color.fromRGBO(209, 224, 224, 0.6));
  }
}
