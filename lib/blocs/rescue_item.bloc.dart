import 'dart:async';

import 'package:rescuer_app/client/rescuer_client.dart';
import 'package:rescuer_app/models/bloc.dart';
import 'package:rescuer_app/models/rescue_info.dart';

/// This BLoC (business logic) is used to deal with rescue item.
/// There are one controller, one stream and one method for the following REST API request : GET, POST, PUT and DELETE
/// The methods are : [getRescue], [putRescue], [postRescue] and [deleteRescue]
/// [getRescue] and [deleteRescue] juste need a [String] uuid as argument.
/// Whereas [putRescue] and [postRescue] need a [RescueInfoData] rescue as argument.
class RescueItemBloc implements Bloc {
  final RescuerClient client;

  RescueItemBloc({required this.client});

  final _getController = StreamController<RescueInfoData>();
  Stream<RescueInfoData> get getRescueStream => _getController.stream;

  final _postController = StreamController<RescueInfoData>();
  Stream<RescueInfoData> get postRescueStream => _postController.stream;

  final _putController = StreamController<RescueInfoData>();
  Stream<RescueInfoData> get putRescueStream => _putController.stream;

  final _deleteController = StreamController<RescueInfoData>();
  Stream<RescueInfoData> get deleteRescueStream => _deleteController.stream;

  /// Get the rescue with the corresponding [String] uuid.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData> getRescue(String uuid) async {
    final FetchedData fetched = await client.getRescueItem(uuid);

    if (fetched.errorMessage == null) {
      _getController.sink.add(fetched.data!);
    } else {
      _getController.sink.addError({'message': fetched.errorMessage});
    }
    return fetched;
  }

  /// Post a rescue with the [RescueInfoData] rescue information.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData> postRescue(RescueInfoData rescue) async {
    final FetchedData fetched = await client.postRescueItem(rescue);

    if (fetched.errorMessage == null) {
      _postController.sink.add(fetched.data!);
    } else {
      _postController.sink.addError({'message': fetched.errorMessage});
    }
    return fetched;
  }

  /// Put a rescue with the [RescueInfoData] rescue information.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData> putRescue(RescueInfoData rescue) async {
    final FetchedData fetched = await client.putRescueItem(rescue);

    if (fetched.errorMessage == null) {
      _putController.sink.add(fetched.data!);
    } else {
      _putController.sink.addError({'message': fetched.errorMessage});
    }
    return fetched;
  }

  /// Delete the rescue with the corresponding [String] uuid.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData> deleteRescue(String uuid) async {
    final FetchedData fetched = await client.deleteRescueItem(uuid);

    if (fetched.errorMessage == null) {
      _deleteController.sink.add(fetched.data!);
    } else {
      _deleteController.sink.addError({'message': fetched.errorMessage});
    }
    return fetched;
  }

  @override
  void dispose() {
    _getController.close();
    _postController.close();
    _putController.close();
    _deleteController.close();
  }
}
