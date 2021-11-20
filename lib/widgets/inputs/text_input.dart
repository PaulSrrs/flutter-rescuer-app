import 'package:flutter/services.dart';
import 'package:rescuer_app/validators/custom_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This [StatelessWidget] is used to have custom stylised input all over the application.
class AppInput extends StatelessWidget {
  const AppInput({
    required this.controller,
    required this.placeholder,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType = TextInputType.text,
    this.errorMessage,
    this.maxLines = 1,
    this.enabled = true,
    this.inputFormatters,
    Key? key
  }) : super(key: key);

  final TextEditingController controller;
  final String placeholder;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final String? errorMessage;
  final int maxLines;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return SizedBox(
        width: deviceWidth > 750 ? deviceWidth * 0.5 : deviceWidth,
        child: TextFormField(
            style: Theme.of(context).textTheme.bodyText1,
            controller: controller,
            textCapitalization: textCapitalization,
            keyboardType: textInputType,
            enabled: enabled,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              labelText: placeholder
            ),
            validator: (value) => errorMessage != null ? CustomValidator.emptyValidator(
                value, errorMessage!) : null,
            maxLines: maxLines)
    );
  }
}
