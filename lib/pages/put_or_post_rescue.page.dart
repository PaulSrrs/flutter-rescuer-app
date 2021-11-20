import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rescuer_app/blocs/rescue_item.bloc.dart';
import 'package:rescuer_app/constants/colors.dart';
import 'package:rescuer_app/constants/rescue_method.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:rescuer_app/widgets/dialog/custom_date_picker.dart';
import 'package:rescuer_app/widgets/dialog/custom_time_picker.dart';
import 'package:rescuer_app/widgets/inputs/text_input.dart';
import 'package:rescuer_app/widgets/loading/loading.widget.dart';

/// This [StatefulWidget] is a page used to display a form.
/// It receive some StreamSubscription to deal with BLoC pattern like [getRescueSub], [postRescueSub] or [putRescueSub].
/// Moreover, it receive the [method] which is a [RescueMethod] enum. It can be [RescueMethod.put] or [RescueMethod.post].
/// It also receive a [String] uuid. It's the rescue's uuid to be get to have more information about it.
/// The last field is the [rescueItemBloc] to deal with rescue request.
class PutOrPostRescuePage extends StatefulWidget {
  final RescueMethod method;
  final String uuid;
  final StreamSubscription<RescueInfoData>? getRescueSub;
  final StreamSubscription<RescueInfoData>? postRescueSub;
  final StreamSubscription<RescueInfoData>? putRescueSub;
  final RescueItemBloc rescueItemBloc;

  const PutOrPostRescuePage(
      {Key? key,
      required this.method,
      required this.uuid,
      required this.getRescueSub,
      required this.postRescueSub,
      required this.putRescueSub,
      required this.rescueItemBloc})
      : super(key: key);

  @override
  _PutOrPostRescuePageState createState() => _PutOrPostRescuePageState();
}

class _PutOrPostRescuePageState extends State<PutOrPostRescuePage> {
  final _formKey = GlobalKey<FormState>();
  final accidentDateController = TextEditingController();
  final accidentTimeController = TextEditingController();
  final resourcesController = TextEditingController();
  final placeController = TextEditingController();
  final circumstanceController = TextEditingController();
  final totalVictimController = TextEditingController(text: '0');
  RescueInfoData? _getRescueData;
  dynamic _getRescueError;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.method == RescueMethod.post) {
      final d = DateTime.now();
      accidentDateController.text = "${d.year}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";
      accidentTimeController.text = "${d.hour.toString().padLeft(2, "0")}:${d.minute.toString().padLeft(2, "0")}";
      widget.postRescueSub?.resume();
      widget.postRescueSub?.onError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error['message']),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.warning,
        ));
      });
    } else {
      widget.getRescueSub?.resume();
      widget.getRescueSub?.onData((rescue) {
        accidentDateController.text = rescue.accidentDate;
        accidentTimeController.text = rescue.accidentTime;
        resourcesController.text = rescue.resources;
        placeController.text = rescue.place;
        circumstanceController.text = rescue.circumstances;
        totalVictimController.text = rescue.totalVictims.toString();
        setState(() {
          _getRescueData = rescue;
        });
      });
      widget.getRescueSub?.onError((error) {
        setState(() {
          _getRescueError = error['message'];
        });
      });
      widget.rescueItemBloc.getRescue(widget.uuid);

      widget.putRescueSub?.resume();
      widget.putRescueSub?.onError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error['message']),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.warning,
        ));
      });
    }
  }

  @override
  void dispose() {
    widget.getRescueSub?.pause();
    widget.putRescueSub?.pause();
    widget.postRescueSub?.pause();
    super.dispose();
  }

  postRescue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final rescueToPost = RescueInfoData(
          uuid: '',
          alertDate: '',
          alertTime: '',
          totalVictim: int.parse(totalVictimController.text),
          accidentDate: accidentDateController.text,
          accidentTime: accidentTimeController.text,
          resources: resourcesController.text,
          place: placeController.text,
          circumstances: circumstanceController.text);
      widget.rescueItemBloc.postRescue(rescueToPost);
    }
  }

  putRescue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final rescueToPut = RescueInfoData(
          uuid: widget.uuid,
          alertDate: '',
          alertTime: '',
          totalVictim: int.parse(totalVictimController.text),
          accidentDate: accidentDateController.text,
          accidentTime: accidentTimeController.text,
          resources: resourcesController.text,
          place: placeController.text,
          circumstances: circumstanceController.text);
      widget.rescueItemBloc.putRescue(rescueToPut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.method == RescueMethod.put
                ? 'Edit a rescue'
                : 'Create a rescue')),
        body: _init());
  }

  Widget _init() {
    var deviceWidth = MediaQuery.of(context).size.width;
    if (widget.method == RescueMethod.post || _getRescueData != null) {
      return Container(
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          child: IgnorePointer(
                              child: AppInput(
                                  controller: accidentDateController,
                                  placeholder: 'Accident date',
                                  textCapitalization: TextCapitalization.none,
                                  errorMessage:
                                      "Please enter the date of the accident")),
                          onTap: () async {
                            final date = await appShowCustomDatePicker(context, Platform.isIOS);
                            if (date != null) {
                              accidentDateController.text = date;
                            }
                          }),
                      const SizedBox(height: 24),
                      InkWell(
                          child: IgnorePointer(
                              child: AppInput(
                                  controller: accidentTimeController,
                                  placeholder: 'Accident time',
                                  textCapitalization: TextCapitalization.none,
                                  errorMessage:
                                      "Please enter the time of the accident")),
                          onTap: () async {
                            final date = await appShowCustomTimePicker(context, Platform.isIOS);
                            if (date != null) {
                              accidentTimeController.text = date;
                            }
                          }),
                      const SizedBox(height: 24),
                      AppInput(
                          controller: resourcesController,
                          placeholder: 'Rescue resources',
                          textCapitalization: TextCapitalization.sentences,
                          errorMessage:
                              "Please enter the resources used for the rescue",
                          maxLines: 2),
                      const SizedBox(height: 24),
                      AppInput(
                        controller: placeController,
                        placeholder: 'Rescue place',
                        textCapitalization: TextCapitalization.sentences,
                        errorMessage: "Please enter the place of the rescue",
                      ),
                      const SizedBox(height: 24),
                      AppInput(
                          controller: circumstanceController,
                          placeholder: 'Rescue circumstances',
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 3),
                      const SizedBox(height: 24),
                      AppInput(
                        controller: totalVictimController,
                        placeholder: 'Rescue victim(s)',
                        textInputType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        errorMessage: "Please enter the number of victims",
                      ),
                      const SizedBox(height: 24),
                      SizedBox(width: deviceWidth > 750 ? deviceWidth * 0.5 : deviceWidth, child: _getButtonState())
                    ],
                  ))));
    } else if (_getRescueError != null) {
      return SizedBox(
          height: double.infinity,
          child: Center(child: Text(_getRescueError)));
    } else {
      return const LoadingWidget();
    }
  }

  Widget _getButtonState() {
    if (isLoading) {
      return const Align(child: CircularProgressIndicator(color: AppColors.success));
    } else {
      return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.success),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0))),
        onPressed: () {
          widget.method == RescueMethod.put ? putRescue() : postRescue();
        },
        child: Text(widget.method == RescueMethod.put ? 'Save' : 'Create',
            style: TextStyle(fontSize: Theme.of(context).textTheme.headline6!.fontSize, color: Colors.white))
      );
    }
  }
}
