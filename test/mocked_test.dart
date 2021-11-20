// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rescuer_app/blocs/rescue_item.bloc.dart';
import 'package:rescuer_app/blocs/rescue_list.bloc.dart';
import 'package:rescuer_app/client/rescuer_client.dart';
import 'package:rescuer_app/models/rescue_info.dart';
import 'package:rescuer_app/services/format_date.service.dart';
import 'package:rescuer_app/services/is_phone_or_tablet.service.dart';
import 'package:rescuer_app/themes/theme_data.dart';
import 'package:rescuer_app/validators/custom_validator.dart';
import 'mocked_test.mocks.dart';
import 'package:http/http.dart' as http;

class MockRescueInfoData {
  RescuerClient mockUpClient;

  MockRescueInfoData() : mockUpClient = RescuerClient(client: MockClient());

  MockRescueInfoData.withMocks({required this.mockUpClient});

  Future<FetchedData<List<RescueInfo>>> getRescuesList(
      int limit, int offset) async {
    final req = await mockUpClient.getRescueList(limit, offset);

    return req;
  }

  Future<bool> getRescuesListSuccess(int limit, int offset) async {
    final req = await mockUpClient.getRescueList(limit, offset);

    return req.data!.length == 2 && req.total == 2;
  }

  Future<bool> getRescuesListFailure(int limit, int offset) async {
    final req = await mockUpClient.getRescueList(limit, offset);

    return req.errorMessage != null && req.total == 0;
  }

  Future<bool> postRescueSuccess(RescueInfoData rescue) async {
    final req = await mockUpClient.postRescueItem(rescue);

    return req.data!.totalVictims == 42 &&
        req.data!.accidentDate == '2012-10-10' &&
        req.data!.accidentTime == '10:10' &&
        req.data!.resources == '2 cars, 2 SUV' &&
        req.data!.place == 'Near to Mont Blanc' &&
        req.data!.circumstances == 'A woman fell';
  }

  Future<bool> getRescueFailure(String uuid) async {
    final req = await mockUpClient.getRescueItem(uuid);

    return req.errorMessage != null && req.total == 0;
  }

  Future<bool> getRescueSuccess(String uuid) async {
    final req = await mockUpClient.getRescueItem(uuid);

    return req.data!.totalVictims == 42 &&
        req.data!.accidentDate == '2012-10-10' &&
        req.data!.accidentTime == '10:10' &&
        req.data!.resources == '2 cars, 2 SUV' &&
        req.data!.place == 'Near to Mont Blanc' &&
        req.data!.circumstances == 'A woman fell';
  }

  Future<bool> postRescueFailure(RescueInfoData rescue) async {
    final req = await mockUpClient.postRescueItem(rescue);

    return req.errorMessage != null && req.total == 0;
  }

  Future<bool> putRescueSuccess(RescueInfoData rescue) async {
    final req = await mockUpClient.putRescueItem(rescue);

    return req.data!.totalVictims == 42 &&
        req.data!.accidentDate == '2012-10-10' &&
        req.data!.accidentTime == '10:10' &&
        req.data!.resources == '2 cars, 2 SUV' &&
        req.data!.place == 'Near to Mont Blanc' &&
        req.data!.circumstances == 'A woman fell';
  }

  Future<bool> putRescueFailure(RescueInfoData rescue) async {
    final req = await mockUpClient.putRescueItem(rescue);

    return req.errorMessage != null && req.total == 0;
  }

  Future<bool> deleteRescueSuccess(String uuid) async {
    final req = await mockUpClient.deleteRescueItem(uuid);

    return req.data!.totalVictims == 42 &&
        req.data!.accidentDate == '2012-10-10' &&
        req.data!.accidentTime == '10:10' &&
        req.data!.resources == '2 cars, 2 SUV' &&
        req.data!.place == 'Near to Mont Blanc' &&
        req.data!.circumstances == 'A woman fell';
  }

  Future<bool> deleteRescueFailure(String uuid) async {
    final req = await mockUpClient.deleteRescueItem(uuid);

    return req.errorMessage != null && req.total == 0;
  }
}

@GenerateMocks([RescuerClient, http.Client])
void main() {

  final client = MockRescuerClient();
  final mockedRescue = RescueInfoData(
      uuid: 'xxxx-xxxx-xxxx-xxxx',
      alertDate: '2012-10-10',
      alertTime: '10:10',
      totalVictim: 42,
      accidentDate: '2012-10-10',
      accidentTime: '10:10',
      resources: '2 cars, 2 SUV',
      place: 'Near to Mont Blanc',
      circumstances: 'A woman fell');
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

  group('blocs', () {
    test('rescue get list bloc', () async {
      final rescueItemList = RescueListBloc(client: client);
      final Stream<List<RescueInfo>> stream = rescueItemList.rescueListStream;

      stream.listen((value) {
        expect(value[0].uuid, mockedRescueList[0].uuid);
      }, onError: (e) {
        expect(e!['message'], 'toto');
      });
      when(client.getRescueList(10, 0)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: mockedRescueList, errorMessage: 'toto', total: 2));
      });
      await rescueItemList.getRescueList(10, 0);
      when(client.getRescueList(10, 0)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: mockedRescueList, errorMessage: 'toto', total: 2));
      });
      await rescueItemList.getRescueList(10, 0);
      rescueItemList.dispose();
    });

    test('rescue get item bloc', () async {
      when(client.getRescueItem(mockedRescue.uuid)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: mockedRescue, errorMessage: null, total: 1));
      });
      final bloc = RescueItemBloc(client: client);
      final Stream<RescueInfoData> stream = bloc.getRescueStream;

      stream.listen((value) {
        expect(value.accidentDate, mockedRescue.accidentDate);
      }, onError: (e) {
        expect(e!['message'], 'toto');
      });

      await bloc.getRescue(mockedRescue.uuid!);
      when(client.getRescueItem(mockedRescue.uuid)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: null, errorMessage: 'toto', total: 1));
      });
      await bloc.getRescue(mockedRescue.uuid!);
      bloc.dispose();
    });

    test('rescue post bloc', () async {
      when(client.postRescueItem(mockedRescue)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: mockedRescue, errorMessage: null, total: 1));
      });
      final bloc = RescueItemBloc(client: client);
      final Stream<RescueInfoData> stream = bloc.postRescueStream;

      stream.listen((value) {
        expect(value.accidentDate, mockedRescue.accidentDate);
      }, onError: (e) {
        expect(e!['message'], 'titi');
      });

      await bloc.postRescue(mockedRescue);
      when(client.postRescueItem(mockedRescue)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: null, errorMessage: 'titi', total: 1));
      });
      await bloc.postRescue(mockedRescue);
      bloc.dispose();
    });

    test('rescue put bloc', () async {
      when(client.putRescueItem(mockedRescue)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: mockedRescueList[0], errorMessage: null, total: 1));
      });
      final bloc = RescueItemBloc(client: client);
      final Stream<RescueInfoData> stream = bloc.putRescueStream;

      stream.listen((value) {
        expect(true, value.accidentDate != mockedRescueList[1].accidentDate);
      }, onError: (e) {
        expect(e!['message'], 'tyty');
      });

      await bloc.putRescue(mockedRescue);
      when(client.putRescueItem(mockedRescue)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: null, errorMessage: 'tyty', total: 1));
      });
      await bloc.putRescue(mockedRescue);
      bloc.dispose();
    });

    test('rescue delete bloc', () async {
      when(client.deleteRescueItem(mockedRescue.uuid)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: mockedRescue, errorMessage: null, total: 1));
      });
      final bloc = RescueItemBloc(client: client);
      final Stream<RescueInfoData> stream = bloc.deleteRescueStream;

      stream.listen((value) {
        expect(true, value.accidentDate == mockedRescue.accidentDate);
      }, onError: (e) {
        expect(e!['message'], 'tata');
      });

      await bloc.deleteRescue(mockedRescue.uuid!);
      when(client.deleteRescueItem(mockedRescue.uuid)).thenAnswer((_) async {
        return Future.value(
            FetchedData(data: null, errorMessage: 'tata', total: 1));
      });
      await bloc.deleteRescue(mockedRescue.uuid!);
      bloc.dispose();
    });
  });

  test('custom validators', () {
    final dynamic invalid = CustomValidator.emptyValidator('', 'This field is required');
    expect(invalid, 'This field is required');
    final dynamic valid = CustomValidator.emptyValidator('Lorem', 'This field is required');
    expect(valid, null);
  });

  group('models', () {
    test('rescue item', () async {
      const Map<String, dynamic> json = {
        "uuid": "1dd2e9ee-f69a-4773-8a06-9c9084033813",
        "alert_date": "2021-11-05",
        "alert_time": "23:49",
        "total_victims": 11,
        "accident_date": "2021-11-04",
        "accident_time": "23:48",
        "resources": "res",
        "place": "pla",
        "circumstances": "cir"
      };
      final rescue = RescueInfoData.fromJson(json);

      expect(rescue.uuid, '1dd2e9ee-f69a-4773-8a06-9c9084033813');
      expect(rescue.alertDate, '2021-11-05');
      expect(rescue.alertTime, '23:49');
      expect(rescue.totalVictims, 11);
      expect(rescue.accidentDate, '2021-11-04');
      expect(rescue.accidentTime, '23:48');
      expect(rescue.resources, 'res');
      expect(rescue.place, 'pla');
      expect(rescue.circumstances, 'cir');

      final Map<String, dynamic> backToBackJson = rescue.toJson();

      expect(backToBackJson['uuid'], '1dd2e9ee-f69a-4773-8a06-9c9084033813');
      expect(backToBackJson['alert_date'], '2021-11-05');
      expect(backToBackJson['alert_time'], '23:49');
      expect(backToBackJson['total_victims'], 11);
      expect(backToBackJson['accident_date'], '2021-11-04');
      expect(backToBackJson['accident_time'], '23:48');
      expect(backToBackJson['resources'], 'res');
      expect(backToBackJson['place'], 'pla');
      expect(backToBackJson['circumstances'], 'cir');
    });
  });

  test('Theme', () {
    final phoneTheme = AppThemeData.getTheme(DeviceType.phone);
    final tabletTheme = AppThemeData.getTheme(DeviceType.tablet);

    expect(phoneTheme, isA<ThemeData>());
    expect(tabletTheme, isA<ThemeData>());
    expect(phoneTheme != tabletTheme, true);
  });

  group('Format date', () {
    test('Format date 1st', () {
      final formattedDate = FormatDateService.formatDate("2012-10-01");

      expect("1st October 2012", formattedDate);
    });

    test('Format date 2nd', () {
      final formattedDate = FormatDateService.formatDate("2000-03-02");

      expect("2nd March 2000", formattedDate);
    });

    test('Format date 3rd', () {
      final formattedDate = FormatDateService.formatDate("2007-05-03");

      expect("3rd May 2007", formattedDate);
    });

    test('Format date 4th', () {
      final formattedDate = FormatDateService.formatDate("2021-12-4");

      expect("4th December 2021", formattedDate);
    });

    test('Format date Xth', () {
      final formattedDate = FormatDateService.formatDate("2014-02-27");

      expect("27th February 2014", formattedDate);
    });
  });

}
