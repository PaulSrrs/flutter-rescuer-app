import 'package:flutter/cupertino.dart';

/// This class is used for rescue data management.
/// It will be inherited by [RescueInfo].
/// The aim of this class is to provide an unique uuid for the API (Django - Python).
class RescueResource {
  String? uuid;

  RescueResource({required this.uuid});

  /// This constructor is used to transform a JSON object to a RescueResource instance.
  RescueResource.fromJson(Map<String, dynamic> json) : uuid = json['uuid'];

  /// This method is used to transform a RescueResource instance to a JSON object.
  @protected
  Map<String, dynamic> toJson() {
    return {'uuid': uuid};
  }
}

/// This class is used for rescue data management.
/// It will be inherited by [RescueInfoData].
/// The aim of this class is to provide basic field for rescue like [alertDate], [alertTime] and [totalVictims].
/// This class will be used to display list of rescues.
class RescueInfo extends RescueResource {
  String alertDate;
  String alertTime;
  int totalVictims;

  RescueInfo(
      {required uuid,
        required this.alertDate,
        required this.alertTime,
        required this.totalVictims})
      : super(uuid: uuid);

  /// This constructor is used to transform a JSON object to a [RescueInfo] instance.
  /// The super.fromJson is also called to filled the [RescueResource] field.
  RescueInfo.fromJson(Map<String, dynamic> json) :
    alertDate = json['alert_date'],
    alertTime = json['alert_time'],
    totalVictims = json['total_victims'],
    super.fromJson(json);

  /// This method is used to transform a [RescueInfo] instance to a JSON object.
  /// The super.toJson is also called to transform [RescueResource] field to JSON.
  @override
  Map<String, dynamic> toJson() {
    return {
      'alert_time': alertTime,
      'alert_date': alertDate,
      'total_victims': totalVictims,
      ...super.toJson()
    };
  }
}

/// This class is used for rescue data management.
/// The aim of this class is to provide more fields for rescue like [accidentDate], [accidentTime], [resources], [place] and [circumstances].
/// This class will be used to display detailed info of a rescue, to create one or to modify one.
class RescueInfoData extends RescueInfo {
  String accidentDate;
  String accidentTime;
  String resources;
  String place;
  String circumstances;

  RescueInfoData({
    required uuid,
    required alertDate,
    required alertTime,
    required totalVictim,
    required this.accidentDate,
    required this.accidentTime,
    required this.resources,
    required this.place,
    required this.circumstances,
  }) : super(
      uuid: uuid,
      alertDate: alertDate,
      alertTime: alertTime,
      totalVictims: totalVictim);

  /// This constructor is used to transform a JSON object to a [RescueInfoData] instance.
  /// The super.fromJson is also called to filled the [RescueInfo] field.
  RescueInfoData.fromJson(Map<String, dynamic> json) :
        accidentDate = json['accident_date'],
        accidentTime = json['accident_time'],
        place = json['place'],
        resources = json['resources'],
        circumstances = json['circumstances'],
        super.fromJson(json);

  /// This method is used to transform a [RescueInfoData] instance to a JSON object.
  /// The super.toJson is also called to transform [RescueInfo] field to JSON.
  @override
  Map<String, dynamic> toJson() {
    return {
      'accident_date': accidentDate,
      'accident_time': accidentTime,
      'resources': resources,
      'place': place,
      'circumstances': circumstances,
      'total_victims': totalVictims,
      ...super.toJson()
    };
  }
}
