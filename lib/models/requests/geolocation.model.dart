class GeolocationModel {
  List<Results>? results;

  GeolocationModel({this.results});

  GeolocationModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }
}

class Results {
  List<Locations>? locations;

  Results({this.locations});

  Results.fromJson(Map<String, dynamic> json) {
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(Locations.fromJson(v));
      });
    }
  }
}

class Locations {
  String? street;
  String? adminArea6;
  String? adminArea6Type;
  String? adminArea5;
  String? adminArea5Type;
  String? adminArea4;
  String? adminArea4Type;
  String? adminArea3;
  String? adminArea3Type;
  String? adminArea1;
  String? adminArea1Type;
  String? postalCode;
  String? geocodeQualityCode;
  String? geocodeQuality;
  String? mapUrl;

  Locations({
    this.street,
    this.adminArea6,
    this.adminArea6Type,
    this.adminArea5,
    this.adminArea5Type,
    this.adminArea4,
    this.adminArea4Type,
    this.adminArea3,
    this.adminArea3Type,
    this.adminArea1,
    this.adminArea1Type,
    this.postalCode,
    this.geocodeQualityCode,
    this.geocodeQuality,
    this.mapUrl,
  });

  Locations.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    adminArea6 = json['adminArea6'];
    adminArea6Type = json['adminArea6Type'];
    adminArea5 = json['adminArea5'];
    adminArea5Type = json['adminArea5Type'];
    adminArea4 = json['adminArea4'];
    adminArea4Type = json['adminArea4Type'];
    adminArea3 = json['adminArea3'];
    adminArea3Type = json['adminArea3Type'];
    adminArea1 = json['adminArea1'];
    adminArea1Type = json['adminArea1Type'];
    postalCode = json['postalCode'];
    geocodeQualityCode = json['geocodeQualityCode'];
    geocodeQuality = json['geocodeQuality'];
    mapUrl = json['mapUrl'];
  }
}
