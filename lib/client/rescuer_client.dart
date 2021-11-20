import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:rescuer_app/constants/api.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:http/http.dart' as http;

/// This class is used to store client's request result.
/// If there is data, the variable [data] is filled and
/// the variable [total] is filled with the number of items got, posted, put or deleted.
/// If there an error, the variable [errorMessage] is filled.
class FetchedData<T> {
  final T? data;
  final String? errorMessage;
  final int? total;

  FetchedData({required this.data, required this.errorMessage, required this.total});
}

/// This class is used to interact with our local or hosted API.
/// The methods are : [getRescueList], [getRescueItem], [postRescueItem], [putRescueItem] and [deleteRescueItem].
/// Once the request complete, a [FetchedData] templated class is created and returned.
class RescuerClient {
  late http.Client client;

  RescuerClient({required this.client});

  /// Get a list of RescueInfo.
  /// [getRescueList] needs a [limit] and an [offset] as arguments to determine exactly the requested rescues.
  Future<FetchedData<List<RescueInfo>>> getRescueList(int limit, int offset) async {
    getErrorMessageFromCode(int code) {
      switch (code) {
        case 403:
          return "You don't have the permissions.";
        case 404:
          return "These rescues does not exist.";
        case 405:
          return "You can't get theses rescues.";
        case 500:
          return "Internal server error.";
        default:
          return "An error occurred";
      }
    }

    final url = Uri.parse("${RescuerApi.apiUrl}" "${RescuerApi.getRescuesList}" "?limit=$limit&offset=$offset");
    late http.Response response;
    try {
      response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {
      if (e is SocketException) {
        return FetchedData(data: null, errorMessage: "Please verify your internet connection.", total: 0);
      } else if (e is TimeoutException) {
        return FetchedData(data: null, errorMessage: "The server isn't available, please try later.", total: 0);
      }
    }
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<dynamic> decoded = body['results'];
      final rescueList = decoded.map((json) {
        final newRescue = RescueInfo.fromJson(json);
        return newRescue;
      }).toList();
      return FetchedData(data: rescueList, errorMessage: null, total: body['count']);
    } else {
      return FetchedData(data: null, errorMessage: getErrorMessageFromCode(response.statusCode), total: 0);
    }
  }

  /// Get the rescue with the corresponding [String] uuid.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData<RescueInfoData>> getRescueItem(String uuid) async {

    getErrorMessageFromCode(int code) {
      switch (code) {
        case 403:
          return "You don't have the permissions.";
        case 404:
          return "This rescue does not exist.";
        case 405:
          return "You can't get this rescue.";
        case 500:
          return "Internal server error.";
        default:
          return "An error occurred";
      }
    }

    final url = Uri.parse("${RescuerApi.apiUrl}" "${RescuerApi.getRescue}" "$uuid/");
    late http.Response response;

    try {
      response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {
      if (e is SocketException) {
        return FetchedData(data: null, errorMessage: "Please verify your internet connection.", total: 0);
      } else if (e is TimeoutException) {
        return FetchedData(data: null, errorMessage: "The server isn't available, please try later.", total: 0);
      }
    }

    if (response.statusCode == 200) {
      final rescueInfo = RescueInfoData.fromJson(json.decode(response.body));
      return FetchedData(data: rescueInfo, errorMessage: null, total: 1);
    } else {
      return FetchedData(data: null, errorMessage: getErrorMessageFromCode(response.statusCode), total: 1);
    }
  }

  /// Post a rescue with the [RescueInfoData] rescue information.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData<RescueInfoData>> postRescueItem(RescueInfoData rescue) async {
    print(rescue.toJson());
    getErrorMessageFromCode(int code) {
      switch (code) {
        case 403:
          return "You don't have the permissions.";
        case 404:
          return "This rescue does not exist.";
        case 405:
          return "You can't create this rescue.";
        case 500:
          return "Internal server error.";
        default:
          return "An error occurred";
      }
    }
    final url = Uri.parse("${RescuerApi.apiUrl}" "${RescuerApi.postRescue}");
    late http.Response response;
    try {
      response = await http.post(url, headers: {
        'Content-Type': 'application/json',
      }, body: json.encode({
        'total_victims': rescue.totalVictims,
        'accident_date': rescue.accidentDate,
        'accident_time': rescue.accidentTime,
        'resources': rescue.resources,
        'place': rescue.place,
        'circumstances': rescue.circumstances
      }));
    } catch (e) {
      if (e is SocketException) {
        return FetchedData(data: null, errorMessage: "Please verify your internet connection.", total: 0);
      } else if (e is TimeoutException) {
        return FetchedData(data: null, errorMessage: "The server isn't available, please try later.", total: 0);
      }
    }
    if (response.statusCode == 201) {
      final rescuePosted = RescueInfoData.fromJson(json.decode(response.body));
      return FetchedData(data: rescuePosted, errorMessage: null, total: 1);
    } else {
      return FetchedData(data: null, errorMessage: getErrorMessageFromCode(response.statusCode), total: 0);
    }
  }

  /// Put a rescue with the [RescueInfoData] rescue information.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData<RescueInfoData>> putRescueItem(RescueInfoData rescue) async {
    print(rescue.toJson());
    getErrorMessageFromCode(int code) {
      switch (code) {
        case 403:
          return "You don't have the permissions.";
        case 404:
          return "This rescue does not exist.";
        case 405:
          return "You can't modify this rescue.";
        case 500:
          return "Internal server error.";
        default:
          return "An error occurred";
      }
    }
    final url = Uri.parse("${RescuerApi.apiUrl}" "${RescuerApi.putRescue}" "${rescue.uuid}/");
    late http.Response response;
    try {
      response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      }, body: json.encode({
        'total_victims': rescue.totalVictims,
        'accident_date': rescue.accidentDate,
        'accident_time': rescue.accidentTime,
        'resources': rescue.resources,
        'place': rescue.place,
        'circumstances': rescue.circumstances
      }));
    } catch (e) {
      if (e is SocketException) {
        return FetchedData(data: null, errorMessage: "Please verify your internet connection.", total: 0);
      } else if (e is TimeoutException) {
        return FetchedData(data: null, errorMessage: "The server isn't available, please try later.", total: 0);
      }
    }
    if (response.statusCode == 200) {
      final rescuePut = RescueInfoData.fromJson(json.decode(response.body));
      return FetchedData(data: rescuePut, errorMessage: null, total: 1);
    } else {
      return FetchedData(data: null, errorMessage: getErrorMessageFromCode(response.statusCode), total: 0);
    }
  }

  /// Delete the rescue with the corresponding [String] uuid.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData<RescueInfoData>> deleteRescueItem(String uuid) async {

    getErrorMessageFromCode(int code) {
      switch (code) {
        case 403:
          return "You don't have the permissions.";
        case 404:
          return "This rescue does not exist.";
        case 405:
          return "You can't delete this rescue.";
        case 500:
          return "Internal server error.";
        default:
          return "An error occurred";
      }
    }

    final url = Uri.parse("${RescuerApi.apiUrl}" "${RescuerApi.deleteRescue}" "$uuid/");
    late http.Response response;
    try {
      response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });
    } catch (e) {
      if (e is SocketException) {
        return FetchedData(data: null, errorMessage: "Please verify your internet connection.", total: 0);
      } else if (e is TimeoutException) {
        return FetchedData(data: null, errorMessage: "The server isn't available, please try later.", total: 0);
      }
    }
    if (response.statusCode == 200) {
      final rescueDeleted = RescueInfoData.fromJson(json.decode(response.body));
      return FetchedData(data: rescueDeleted, errorMessage: null, total: 0);
    } else {
      return FetchedData(data: null, errorMessage: getErrorMessageFromCode(response.statusCode), total: 0);
    }
  }
}
