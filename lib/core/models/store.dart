import 'package:pos_mobile/core/utils/constants.dart';

class Store {
  final int id;
  int provinceId;
  final String provinceName;
  final String name;
  final String location;
  final String picture;
  final String description;
  final String phone;
  final double latitude;
  final double longitude;
  final double tax;
  final double serviceFee;
  final String openTime;
  final String closeTime;

  Store(
      {this.name,
      this.picture,
      this.phone,
      this.longitude,
      this.tax,
      this.serviceFee,
      this.openTime,
      this.id,
      this.provinceId,
      this.provinceName,
      this.closeTime,
      this.description,
      this.latitude,
      this.location});

  Store.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        provinceId = int.parse(json['provinceId']),
        provinceName = json['provinceName'] != null ? json['provinceName'] : "",
        closeTime = json['storeCloseTime'],
        openTime = json['storeOpenTime'],
        description = json['storeDescription'],
        latitude = double.parse(json['storeLat']),
        longitude = double.parse(json['storeLng']),
        picture = json['storePicture'] != null
            ? BASE_PICTURE_URL + json['storePicture']
            : "",
        serviceFee = json['storeServiceFee'] != null
            ? json['storeServiceFee'].toDouble()
            : 0,
        tax = json['storeTax'] != null ? json['storeTax'].toDouble() : 0,
        phone = json['storePhone'],
        location = json['storeLocation'],
        name = json['storeName'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "provinceId": provinceId,
      "storeCloseTime": closeTime,
      "storeOpenTime": openTime,
      "storeDescription": description,
      "storeLat": latitude,
      "storeLng": longitude,
      "storeServiceFee": serviceFee,
      "storeTax": tax,
      "storePhone": phone,
      "storeLocation": location,
      "storeName": name,
    };
  }
}

class StoreGallery {
  final int id;
  final String path;
  final String type;
  int storeId;

  StoreGallery({this.id, this.path, this.storeId, this.type});

  StoreGallery.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        storeId = json['storeId'],
        path = BASE_URL + json['mediaPath'],
        type = json['mediaType'];

  Map<String, dynamic> toJson() {
    return {"id": id, "storeId": storeId, "mediaType": type};
  }
}
