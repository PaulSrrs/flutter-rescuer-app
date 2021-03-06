// Mocks generated by Mockito 5.0.16 from annotations
// in rescuer_app/test/mocked_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:convert' as _i6;
import 'dart:typed_data' as _i7;

import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rescuer_app/client/rescuer_client.dart' as _i3;
import 'package:rescuer_app/models/rescue_info.dart' as _i5;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeClient_0 extends _i1.Fake implements _i2.Client {}

class _FakeFetchedData_1<T> extends _i1.Fake implements _i3.FetchedData<T> {}

class _FakeResponse_2 extends _i1.Fake implements _i2.Response {}

class _FakeStreamedResponse_3 extends _i1.Fake implements _i2.StreamedResponse {
}

/// A class which mocks [RescuerClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockRescuerClient extends _i1.Mock implements _i3.RescuerClient {
  MockRescuerClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Client get client => (super.noSuchMethod(Invocation.getter(#client),
      returnValue: _FakeClient_0()) as _i2.Client);
  @override
  set client(_i2.Client? _client) =>
      super.noSuchMethod(Invocation.setter(#client, _client),
          returnValueForMissingStub: null);
  @override
  _i4.Future<_i3.FetchedData<List<_i5.RescueInfo>>> getRescueList(
          int? limit, int? offset) =>
      (super.noSuchMethod(Invocation.method(#getRescueList, [limit, offset]),
              returnValue: Future<_i3.FetchedData<List<_i5.RescueInfo>>>.value(
                  _FakeFetchedData_1<List<_i5.RescueInfo>>()))
          as _i4.Future<_i3.FetchedData<List<_i5.RescueInfo>>>);
  @override
  _i4.Future<_i3.FetchedData<_i5.RescueInfoData>> getRescueItem(String? uuid) =>
      (super.noSuchMethod(Invocation.method(#getRescueItem, [uuid]),
              returnValue: Future<_i3.FetchedData<_i5.RescueInfoData>>.value(
                  _FakeFetchedData_1<_i5.RescueInfoData>()))
          as _i4.Future<_i3.FetchedData<_i5.RescueInfoData>>);
  @override
  _i4.Future<_i3.FetchedData<_i5.RescueInfoData>> postRescueItem(
          _i5.RescueInfoData? rescue) =>
      (super.noSuchMethod(Invocation.method(#postRescueItem, [rescue]),
              returnValue: Future<_i3.FetchedData<_i5.RescueInfoData>>.value(
                  _FakeFetchedData_1<_i5.RescueInfoData>()))
          as _i4.Future<_i3.FetchedData<_i5.RescueInfoData>>);
  @override
  _i4.Future<_i3.FetchedData<_i5.RescueInfoData>> putRescueItem(
          _i5.RescueInfoData? rescue) =>
      (super.noSuchMethod(Invocation.method(#putRescueItem, [rescue]),
              returnValue: Future<_i3.FetchedData<_i5.RescueInfoData>>.value(
                  _FakeFetchedData_1<_i5.RescueInfoData>()))
          as _i4.Future<_i3.FetchedData<_i5.RescueInfoData>>);
  @override
  _i4.Future<_i3.FetchedData<_i5.RescueInfoData>> deleteRescueItem(
          String? uuid) =>
      (super.noSuchMethod(Invocation.method(#deleteRescueItem, [uuid]),
              returnValue: Future<_i3.FetchedData<_i5.RescueInfoData>>.value(
                  _FakeFetchedData_1<_i5.RescueInfoData>()))
          as _i4.Future<_i3.FetchedData<_i5.RescueInfoData>>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i2.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Response> head(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#head, [url], {#headers: headers}),
              returnValue: Future<_i2.Response>.value(_FakeResponse_2()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<_i2.Response> get(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#get, [url], {#headers: headers}),
              returnValue: Future<_i2.Response>.value(_FakeResponse_2()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<_i2.Response> post(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i6.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#post, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i2.Response>.value(_FakeResponse_2()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<_i2.Response> put(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i6.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#put, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i2.Response>.value(_FakeResponse_2()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<_i2.Response> patch(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i6.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#patch, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i2.Response>.value(_FakeResponse_2()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<_i2.Response> delete(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i6.Encoding? encoding}) =>
      (super.noSuchMethod(
              Invocation.method(#delete, [url],
                  {#headers: headers, #body: body, #encoding: encoding}),
              returnValue: Future<_i2.Response>.value(_FakeResponse_2()))
          as _i4.Future<_i2.Response>);
  @override
  _i4.Future<String> read(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(Invocation.method(#read, [url], {#headers: headers}),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
  @override
  _i4.Future<_i7.Uint8List> readBytes(Uri? url,
          {Map<String, String>? headers}) =>
      (super.noSuchMethod(
              Invocation.method(#readBytes, [url], {#headers: headers}),
              returnValue: Future<_i7.Uint8List>.value(_i7.Uint8List(0)))
          as _i4.Future<_i7.Uint8List>);
  @override
  _i4.Future<_i2.StreamedResponse> send(_i2.BaseRequest? request) =>
      (super.noSuchMethod(Invocation.method(#send, [request]),
              returnValue:
                  Future<_i2.StreamedResponse>.value(_FakeStreamedResponse_3()))
          as _i4.Future<_i2.StreamedResponse>);
  @override
  void close() => super.noSuchMethod(Invocation.method(#close, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
