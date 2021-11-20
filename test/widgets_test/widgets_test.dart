import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rescuer_app/blocs/rescue_list.bloc.dart';
import 'package:rescuer_app/client/rescuer_client.dart';
import 'package:rescuer_app/main.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:rescuer_app/widgets/list_card/list_card.widget.dart';
import 'package:rescuer_app/providers/bloc_provider.dart';
import 'package:rescuer_app/services/format_date.service.dart';
import 'package:rescuer_app/widgets/dialog/custom_date_picker.dart';
import 'package:rescuer_app/widgets/dialog/custom_time_picker.dart';
import 'package:rescuer_app/widgets/dialog/dialog.dart';
import 'package:rescuer_app/widgets/error/error.widget.dart';
import 'package:rescuer_app/widgets/inputs/text_input.dart';
import 'package:rescuer_app/widgets/keyboard/dismiss_keyboard.dart';

import '../mocked_test.dart';
import '../mocked_test.mocks.dart';

main() {
  final client = MockRescuerClient();
  final mockedRescueList = [
    RescueInfoData(
        uuid: 'xxxx-xxxx-xxxx-xxxx',
        alertDate: '2012-10-10',
        alertTime: '10:10',
        totalVictim: 42,
        accidentDate: '2012-10-10',
        accidentTime: '10:10',
        resources: '2 cars, 2 SUV',
        place: 'Near to Mont Blanc',
        circumstances: 'A woman fell'),
    RescueInfoData(
        uuid: 'xxxx-xxxx-xxxx-xxxx',
        alertDate: '2012-10-10',
        alertTime: '10:10',
        totalVictim: 12,
        accidentDate: '2012-12-12',
        accidentTime: '12:12',
        resources: '2 helpers, 1 bicycle and 1 car',
        place: 'Far to Mont Blanc',
        circumstances: 'A man fell')
  ];


  testWidgets('No internet test', (WidgetTester tester) async {
    await tester.pumpWidget(
        MyApp(connectivityResult: ConnectivityResult.none, client: client));

    var noInternetText = find.text('You\'re not connected to the internet');
    expect(noInternetText, findsOneWidget);
  });

  testWidgets('Mobile internet test', (WidgetTester tester) async {
    when(client.getRescueList(20, 0)).thenAnswer((_) async {
      return Future.value(
          FetchedData(data: mockedRescueList, errorMessage: null, total: 2));
    });
    await tester.pumpWidget(BlocProvider(
        bloc: RescueListBloc(client: client),
        child: MyApp(
            connectivityResult: ConnectivityResult.mobile, client: client)));

    var noInternetText = find.text('no internet (animation come)');
    expect(noInternetText, findsNothing);
  });

  testWidgets('Mobile with timeout internet test', (WidgetTester tester) async {
    var taped = false;
    await tester.pumpWidget(MaterialApp(
        home: AppErrorWidget(
            error: 'lorem ipsum', callback: () => taped = true)));

    final errorText = find.text('lorem ipsum');
    expect(errorText, findsOneWidget);
    var retryText = find.text('Retry');
    expect(retryText, findsOneWidget);
    var retryBtn = find.byType(TextButton);
    expect(retryBtn, findsOneWidget);
    await tester.tap(retryBtn);
    expect(taped, true);
  });

  testWidgets('Rescue list card generation', (WidgetTester tester) async {
    when(client.getRescueList(10, 0)).thenAnswer((_) async {
      return Future.value(
          FetchedData(data: mockedRescueList, errorMessage: null, total: 2));
    });
    MockRescueInfoData mocked =
        MockRescueInfoData.withMocks(mockUpClient: client);

    final fetched = (await mocked.getRescuesList(10, 0));

    expect(true, fetched.data!.length == 2 && fetched.total == 2);

    await tester
        .pumpWidget(MaterialApp(home: ListCard(rescueInfo: fetched.data![0])));

    var victims = find.text('42 victims expected');
    var date = find.text(
        FormatDateService.formatDate(fetched.data![0].alertDate) +
            " | " +
            fetched.data![0].alertTime);

    expect(victims, findsOneWidget);
    expect(date, findsOneWidget);
  });

  group('dialog', () {
    testWidgets('android classic dialog', (WidgetTester tester) async {
      var taped = 0;
      await tester.pumpWidget(MaterialApp(
          home: AppDialog(
              cancelCallback: () {
                taped = 2;
              },
              isIOS: false,
              content: 'Lorem',
              cancelText: 'cancel',
              title: 'Lorem',
              confirmCallback: () {
                taped = 1;
              },
              confirmText: 'Lorem')));
      final androidDialog = find.byType(AppDialog);
      expect(androidDialog, findsOneWidget);
      final confirmBtn = find.byKey(const Key('confirm'));
      await tester.tap(confirmBtn);
      expect(taped, 1);
      final cancelBtn = find.byKey(const Key('cancel'));
      await tester.tap(cancelBtn);
      expect(taped, 2);
    });

    testWidgets('android date dialog OK', (WidgetTester tester) async {
      Widget buildFrame() {
        return MaterialApp(
          home: Material(
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    child: const Text('X'),
                    onPressed: () async {
                      final d = DateTime.now();
                      final dateNow =
                          "${d.year}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";
                      final dialogResult =
                          await appShowCustomDatePicker(context, false);
                      expect(dateNow, dialogResult);
                    },
                  );
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildFrame());
      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
    });

    testWidgets('android date dialog cancel', (WidgetTester tester) async {
      Widget buildFrame(TextDirection textDirection) {
        return MaterialApp(
          home: Material(
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    child: const Text('X'),
                    onPressed: () async {
                      final dialogResult =
                          await appShowCustomDatePicker(context, false);
                      expect(dialogResult, null);
                    },
                  );
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildFrame(TextDirection.ltr));
      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CANCEL'));
    });

    testWidgets('android time dialog OK', (WidgetTester tester) async {
      Widget buildFrame() {
        return MaterialApp(
          home: Material(
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    child: const Text('X'),
                    onPressed: () async {
                      final d = DateTime.now();
                      final timeNow =
                          "${d.hour.toString().padLeft(2, "0")}:${d.minute.toString().padLeft(2, "0")}";
                      final dialogResult =
                          await appShowCustomTimePicker(context, false);
                      expect(timeNow, dialogResult);
                    },
                  );
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildFrame());
      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
    });

    testWidgets('android date dialog cancel', (WidgetTester tester) async {
      Widget buildFrame(TextDirection textDirection) {
        return MaterialApp(
          home: Material(
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    child: const Text('X'),
                    onPressed: () async {
                      final dialogResult =
                          await appShowCustomTimePicker(context, false);
                      expect(dialogResult, null);
                    },
                  );
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildFrame(TextDirection.ltr));
      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CANCEL'));
    });

    testWidgets('ios classic dialog', (WidgetTester tester) async {
      var taped = 0;
      await tester.pumpWidget(MaterialApp(
          home: AppDialog(
              cancelCallback: () {
                taped = 2;
              },
              isIOS: true,
              content: 'Lorem',
              cancelText: 'cancel',
              title: 'Lorem',
              confirmCallback: () {
                taped = 1;
              },
              confirmText: 'Lorem')));
      final iosDialog = find.byType(CupertinoAlertDialog);
      expect(iosDialog, findsOneWidget);
      final confirmBtn = find.byKey(const Key('confirm'));
      await tester.tap(confirmBtn);
      expect(taped, 1);
      final cancelBtn = find.byKey(const Key('cancel'));
      await tester.tap(cancelBtn);
      expect(taped, 2);
    });

    testWidgets('ios date dialog OK', (WidgetTester tester) async {
      final now = DateTime.now();

      Widget buildFrame() {
        return MaterialApp(
          home: Material(
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    child: const Text('X'),
                    onPressed: () async {
                      final dateNow =
                          "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")}";
                      final dialogResult =
                          await appShowCustomDatePicker(context, true);
                      expect(dateNow, dialogResult);
                    },
                  );
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildFrame());
      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('November')).dx, // TODO change the month
        lessThan(tester.getTopLeft(find.text(now.day.toString())).dx),
      );

      expect(
        tester.getTopLeft(find.text(now.day.toString())).dx,
        lessThan(tester.getTopLeft(find.text(now.year.toString())).dx),
      );
    });

    testWidgets('ios time dialog OK', (WidgetTester tester) async {
      final now = DateTime.now();

      Widget buildFrame() {
        return MaterialApp(
          home: Material(
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    child: const Text('X'),
                    onPressed: () async {
                      final dateNow =
                          "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}";
                      final dialogResult =
                          await appShowCustomTimePicker(context, true);
                      expect(dateNow, dialogResult);
                    },
                  );
                },
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildFrame());
      await tester.tap(find.text('X'));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text(now.hour.toString().padLeft(2, "0"))).dx,
        lessThanOrEqualTo(tester
            .getTopLeft(find.text(now.minute.toString().padLeft(2, "0")))
            .dx),
      );
    });
  });

  testWidgets('app input', (WidgetTester tester) async {
    final _formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
              key: _formKey,
              child: AppInput(
                  controller: TextEditingController(),
                  placeholder: 'Lorem Ipsum',
                  errorMessage: 'ERROR')),
        ),
      ),
    );

    final form = find.byType(Form);
    expect(form, findsOneWidget);
    _formKey.currentState!.validate();
    final input = find.byType(TextField);
    final decoration = (input.evaluate().single.widget as TextField).decoration;
    expect(input, findsOneWidget);
    expect(decoration!.labelText, 'Lorem Ipsum');
  });

  testWidgets('dismiss keyboard', (WidgetTester tester) async {
    await tester.pumpWidget(DismissKeyboard(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(key: const Key('appBar')),
          body: Form(child: TextFormField(key: const Key('field'))),
        ),
      ),
    ));

    final field = find.byKey(const Key('field'));
    await tester.tap(field);
    expect(WidgetsBinding.instance!.window.viewInsets.bottom > 0.0, false);
    final appBar = find.byKey(const Key('appBar'));
    await tester.tap(appBar);
    expect(WidgetsBinding.instance!.window.viewInsets.bottom > 0.0, false);
  });
}
