import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:pos_mobile/core/services/auth_service.dart";
import 'package:pos_mobile/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  final Dio tDio = Dio();
  DioAdapterMock dioAdapterMock;
  

  setUpAll(() {
    dioAdapterMock = DioAdapterMock();
    tDio.httpClientAdapter = dioAdapterMock;
    setupInjector(test: true, dioMock: tDio);
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  group("auth", () {
    test("User Should Login", () async {
      final AuthService _authService = new AuthService();
      SharedPreferences.setMockInitialValues({});
      final responsepayload = jsonEncode({
        "status": 200,
        "data": {
          "token":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImVtYWlsIjoic3RvcmVAbWVzYW4uY29tIiwiZmlyc3ROYW1lIjoiT3duZXIiLCJsYXN0TmFtZSI6bnVsbCwicGhvbmVOdW1iZXIiOiI2Mjg1NzE1NTY1MzQwIiwicHJvZmlsZVBpY3R1cmUiOm51bGwsInR5cGUiOiJ1c2VyIn0sImlhdCI6MTYxMTI5MTI0NiwiZXhwIjoxNjExMjkyMTQ2fQ.XC0Ky0-CSrSOoAodfHyK3nAjch3zNJkkhknR1LWw5Dg",
          "user": {
            "email": "store@mesan.com",
            "firstName": "Owner",
            "lastName": null,
            "phoneNumber": "6285715565340",
            "profilePicture": null,
            "type": "user"
          },
          "stores": [
            {"id": "6", "storeName": "Sebuah Kaflfe"},
            {"id": "15", "storeName": "Sebsuah Kaflfe"},
            {"id": "16", "storeName": "2"},
            {"id": "5", "storeName": "Sebuah Kaflfe"},
            {"id": "10", "storeName": "Sebuah Kaflfe"},
            {"id": "11", "storeName": "Sebuah Kaflfe"},
            {"id": "12", "storeName": "Sebuah Kaflfe"},
            {"id": "14", "storeName": "Sebuah Kaflfe"},
            {"id": "2", "storeName": "Sebuah Kaflfe"},
            {"id": "3", "storeName": "Sebuah Keee"},
            {"id": "4", "storeName": "Sebuah Kaflfe"}
          ]
        }
      });
      final httpResponse = ResponseBody.fromString(
        responsepayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      Map<String, dynamic> result =
          await _authService.login("store@mesan.com", "vendorpassword");
      expect(result['success'], true);
    });
  });
}
