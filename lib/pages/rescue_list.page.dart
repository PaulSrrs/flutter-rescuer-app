import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rescuer_app/blocs/rescue_item.bloc.dart';
import 'package:rescuer_app/blocs/rescue_list.bloc.dart';
import 'package:rescuer_app/client/rescuer_client.dart';
import 'package:rescuer_app/constants/colors.dart';
import 'package:rescuer_app/constants/requests_limit.dart';
import 'package:rescuer_app/constants/rescue_method.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rescuer_app/widgets/list_card/list_card.widget.dart';
import 'package:rescuer_app/pages/put_or_post_rescue.page.dart';
import 'package:rescuer_app/pages/rescue_item.page.dart';
import 'package:rescuer_app/providers/bloc_provider.dart';
import 'package:rescuer_app/widgets/dialog/dialog.dart';

/// This [StatefulWidget] is a page used to display a list of rescues (RescueInfo).
/// It receive [postRescueSub] which can be useful to listen to post rescue event.
class RescueList extends StatefulWidget {
  final StreamSubscription<RescueInfoData>? postRescueSub;

  const RescueList({Key? key, required this.postRescueSub}) : super(key: key);

  @override
  _RescueListState createState() => _RescueListState();
}

class _RescueListState extends State<RescueList> {
  late GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late StreamSubscription<RescueInfoData> _getRescueSub;
  late StreamSubscription<RescueInfoData> _putRescueSub;
  late final ScrollController _scrollController = ScrollController();
  final List<RescueInfo> _rescueItems = [];
  late RescueItemBloc _rescueItemBloc;
  bool _isLoading = true;
  late int offset;
  int totalRescues = 0;

  @override
  void initState() {
    super.initState();
    _rescueItemBloc = BlocProvider.of<RescueItemBloc>(context)!;
    _getRescueSub = _rescueItemBloc.getRescueStream.listen((_) {});
    _getRescueSub.pause();
    _putRescueSub = _rescueItemBloc.putRescueStream.listen((_) {});
    _putRescueSub.pause();
    widget.postRescueSub?.onData((rescue) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pop(context);
      listKey.currentState!
          .insertItem(0, duration: const Duration(milliseconds: 500));
      _rescueItems.insert(0, rescue);
    });
    _putRescueSub.onData((rescueEdited) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pop(context);
      for (int i = 0; i < _rescueItems.length; i++) {
        if (_rescueItems[i].uuid == rescueEdited.uuid) {
          setState(() {
            _rescueItems[i] = rescueEdited;
          });
        }
      }
    });
    _scrollController.addListener(handleScrolling);
  }

  @override
  void dispose() {
    print('ispose');
    _getRescueSub.cancel();
    _putRescueSub.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  handleScrolling() async {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      offset = _rescueItems.length;
      if (offset < BlocProvider.of<RescueListBloc>(context)!.total) {
        setState(() => _isLoading = true);
        await BlocProvider.of<RescueListBloc>(context)!
            .getRescueList(rescueListGetLimit, offset);
        totalRescues = BlocProvider.of<RescueListBloc>(context)!.total;
      }
    }
  }

  generateErrorSnackBar(String error) {
    return SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.warning,
    );
  }

  removeFromList(RescueInfo rescueToRemove) async {
    final FetchedData fetched = await BlocProvider.of<RescueItemBloc>(context)!
        .deleteRescue(rescueToRemove.uuid!);
    if (fetched.errorMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(generateErrorSnackBar(fetched.errorMessage!));
    } else {
      final index = _rescueItems.indexOf(rescueToRemove);

      listKey.currentState!.removeItem(
          index, (_, animation) => slideIt(context, index, animation),
          duration: const Duration(milliseconds: 500));
      _rescueItems.removeAt(index);
    }
  }

  insertToList(List<RescueInfo> fetchedRescueList) {
    var index = 0;
    final List<String> actualItems =
        _rescueItems.map((item) => item.uuid!).toList();

    for (final rescue in fetchedRescueList) {
      if (!actualItems.contains(rescue.uuid)) {
        listKey.currentState!.insertItem(_rescueItems.length,
            duration: Duration(milliseconds: 500 + 50 * index));
        _rescueItems.add(rescue);
        ++index;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RescueInfo>>(
        stream: BlocProvider.of<RescueListBloc>(context)!.rescueListStream,
        builder: (context, AsyncSnapshot<List<RescueInfo>> snapshot) {
          if (snapshot.hasData) {
            insertToList(snapshot.data!);
            _isLoading = false;
          } else if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text((snapshot.error! as dynamic)['message']),
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.warning,
            ));
            _isLoading = false;
          }
          return AnimatedList(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            key: listKey,
            initialItemCount: _rescueItems.length + 1,
            itemBuilder: (context, index, animation) {
              if (index >= _rescueItems.length) {
                // Don't trigger if one async loading is already under way
                if (_isLoading) {
                  return const SizedBox(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                    height: 100,
                    width: double.infinity,
                  );
                } else if (_rescueItems.isEmpty) {
                  return const EmptyListWidget();
                } else {
                  return Container();
                }
              }
              return slideIt(context, index, animation);
            },
          );
        });
  }

  Widget slideIt(context, index, animation) {
    if (index > _rescueItems.length - 1) {
      return Container();
    }

    final rescue = _rescueItems[index];

    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      pageBuilder: (_, __, ___) => RescueItemView(
                          rescueInfo: rescue,
                          getRescueSub: _getRescueSub,
                          rescueItemBloc: _rescueItemBloc)));
            },
            child: ListCard(rescueInfo: (rescue)),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.yellow,
              icon: Icons.edit,
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PutOrPostRescuePage(
                            method: RescueMethod.put,
                            uuid: rescue.uuid!,
                            getRescueSub: _getRescueSub,
                            putRescueSub: _putRescueSub,
                            postRescueSub: null,
                            rescueItemBloc: _rescueItemBloc)));
              },
            )
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.remove_circle_outline,
                onTap: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AppDialog(
                                isIOS: Platform.isIOS,
                                title: "Delete rescue item",
                                content:
                                    "Are you sure you want this rescue item",
                                cancelText: "No",
                                confirmText: "Yes",
                                confirmCallback: () async {
                                  Navigator.pop(context);
                                  await removeFromList(rescue);
                                },
                                cancelCallback: () => Navigator.pop(context));
                          })
                    })
          ],
        ));
  }
}

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
            child: Column(children: <Widget>[
          const Icon(Icons.health_and_safety,
              size: 80, color: AppColors.warning),
          const SizedBox(height: 24),
          Text('No rescue listed',
              style: Theme.of(context).textTheme.headline1),
          const SizedBox(height: 12),
          Text(
              'You can add one by clicking on the \'+\' icon at the top right side of your screen.',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center),
          const SizedBox(height: 80),
        ])));
  }
}
