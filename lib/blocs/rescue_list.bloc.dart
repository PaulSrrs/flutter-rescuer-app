import 'dart:async';

import 'package:rescuer_app/client/rescuer_client.dart';
import 'package:rescuer_app/models/bloc.dart';
import 'package:rescuer_app/models/rescue_info.dart';

/// This BLoC (business logic) is used to deal with rescue list.
/// There are one controller, one stream and one method to get a list of rescues.
/// The method is : [getRescueList]
class RescueListBloc implements Bloc {
  final _controller = StreamController<List<RescueInfo>>();
  final RescuerClient client;
  int total = 0;
  Stream<List<RescueInfo>> get rescueListStream => _controller.stream;

  RescueListBloc({required this.client});

  /// Get a list of [RescueInfo].
  /// [getRescueList] needs a [limit] and an [offset] as arguments to determine exactly the requested rescues.
  /// The result is stored in the [FetchedData] class.
  Future<FetchedData> getRescueList(int limit, int offset) async {
    final FetchedData fetched = await client.getRescueList(limit, offset);
    if (fetched.errorMessage == null) {
      total = fetched.total!;
      _controller.sink.add(fetched.data!);
    } else {
      _controller.sink.addError({'message': fetched.errorMessage});
    }
    return fetched;
  }

  @override
  void dispose() {
    _controller.close();
  }
}