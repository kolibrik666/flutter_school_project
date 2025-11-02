// To parse this JSON data, do
//
//     final earthquakeModel = earthquakeModelFromJson(jsonString);

import 'dart:convert';

EarthquakeModel earthquakeModelFromJson(String str) =>
    EarthquakeModel.fromJson(json.decode(str));

String earthquakeModelToJson(EarthquakeModel data) =>
    json.encode(data.toJson());

class EarthquakeModel {
  String type;
  Metadata metadata;
  List<Feature> features;
  List<double> bbox;

  EarthquakeModel({
    required this.type,
    required this.metadata,
    required this.features,
    required this.bbox,
  });

  factory EarthquakeModel.fromJson(Map<String, dynamic> json) =>
      EarthquakeModel(
        type: json["type"],
        metadata: Metadata.fromJson(json["metadata"]),
        features: List<Feature>.from(
          json["features"].map((x) => Feature.fromJson(x)),
        ),
        bbox: List<double>.from(json["bbox"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
    "type": type,
    "metadata": metadata.toJson(),
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "bbox": List<dynamic>.from(bbox.map((x) => x)),
  };
}

class Feature {
  FeatureType type;
  Properties properties;
  Geometry geometry;
  String id;

  Feature({
    required this.type,
    required this.properties,
    required this.geometry,
    required this.id,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    type: featureTypeValues.map[json["type"]]!,
    properties: Properties.fromJson(json["properties"]),
    geometry: Geometry.fromJson(json["geometry"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": featureTypeValues.reverse[type],
    "properties": properties.toJson(),
    "geometry": geometry.toJson(),
    "id": id,
  };
}

class Geometry {
  GeometryType type;
  List<double> coordinates;

  Geometry({required this.type, required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: geometryTypeValues.map[json["type"]]!,
    coordinates: List<double>.from(
      json["coordinates"].map((x) => x?.toDouble()),
    ),
  );

  Map<String, dynamic> toJson() => {
    "type": geometryTypeValues.reverse[type],
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

enum GeometryType { POINT }

final geometryTypeValues = EnumValues({"Point": GeometryType.POINT});

class Properties {
  double mag;
  String place;
  int time;
  int updated;
  dynamic tz;
  String url;
  String detail;
  int? felt;
  double? cdi;
  double? mmi;
  String? alert;
  Status status;
  int tsunami;
  int sig;
  Net net;
  String code;
  String ids;
  String sources;
  String types;
  int? nst;
  double? dmin;
  double rms;
  double? gap;
  MagType magType;
  PropertiesType type;
  String title;

  Properties({
    required this.mag,
    required this.place,
    required this.time,
    required this.updated,
    required this.tz,
    required this.url,
    required this.detail,
    required this.felt,
    required this.cdi,
    required this.mmi,
    required this.alert,
    required this.status,
    required this.tsunami,
    required this.sig,
    required this.net,
    required this.code,
    required this.ids,
    required this.sources,
    required this.types,
    required this.nst,
    required this.dmin,
    required this.rms,
    required this.gap,
    required this.magType,
    required this.type,
    required this.title,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    mag: json["mag"]?.toDouble(),
    place: json["place"],
    time: json["time"],
    updated: json["updated"],
    tz: json["tz"],
    url: json["url"],
    detail: json["detail"],
    felt: json["felt"],
    cdi: json["cdi"]?.toDouble(),
    mmi: json["mmi"]?.toDouble(),
    alert: json["alert"],
    status: statusValues.map[json["status"]]!,
    tsunami: json["tsunami"],
    sig: json["sig"],
    net: netValues.map[json["net"]]!,
    code: json["code"],
    ids: json["ids"],
    sources: json["sources"],
    types: json["types"],
    nst: json["nst"],
    dmin: json["dmin"]?.toDouble(),
    rms: json["rms"]?.toDouble(),
    gap: json["gap"]?.toDouble(),
    magType: magTypeValues.map[json["magType"]]!,
    type: propertiesTypeValues.map[json["type"]]!,
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "mag": mag,
    "place": place,
    "time": time,
    "updated": updated,
    "tz": tz,
    "url": url,
    "detail": detail,
    "felt": felt,
    "cdi": cdi,
    "mmi": mmi,
    "alert": alert,
    "status": statusValues.reverse[status],
    "tsunami": tsunami,
    "sig": sig,
    "net": netValues.reverse[net],
    "code": code,
    "ids": ids,
    "sources": sources,
    "types": types,
    "nst": nst,
    "dmin": dmin,
    "rms": rms,
    "gap": gap,
    "magType": magTypeValues.reverse[magType],
    "type": propertiesTypeValues.reverse[type],
    "title": title,
  };
}

enum MagType { MAG_TYPE_MD, MB, MD, MH, ML, MWW }

final magTypeValues = EnumValues({
  "Md": MagType.MAG_TYPE_MD,
  "mb": MagType.MB,
  "md": MagType.MD,
  "mh": MagType.MH,
  "ml": MagType.ML,
  "mww": MagType.MWW,
});

enum Net { AK, CI, HV, LD, MB, NC, NM, NN, PR, US, UU, UW }

final netValues = EnumValues({
  "ak": Net.AK,
  "ci": Net.CI,
  "hv": Net.HV,
  "ld": Net.LD,
  "mb": Net.MB,
  "nc": Net.NC,
  "nm": Net.NM,
  "nn": Net.NN,
  "pr": Net.PR,
  "us": Net.US,
  "uu": Net.UU,
  "uw": Net.UW,
});

enum Status { AUTOMATIC, REVIEWED, STATUS_AUTOMATIC, STATUS_REVIEWED }

final statusValues = EnumValues({
  "automatic": Status.AUTOMATIC,
  "reviewed": Status.REVIEWED,
  "AUTOMATIC": Status.STATUS_AUTOMATIC,
  "REVIEWED": Status.STATUS_REVIEWED,
});

enum PropertiesType { EARTHQUAKE, EXPLOSION }

final propertiesTypeValues = EnumValues({
  "earthquake": PropertiesType.EARTHQUAKE,
  "explosion": PropertiesType.EXPLOSION,
});

enum FeatureType { FEATURE }

final featureTypeValues = EnumValues({"Feature": FeatureType.FEATURE});

class Metadata {
  int generated;
  String url;
  String title;
  int status;
  String api;
  int count;

  Metadata({
    required this.generated,
    required this.url,
    required this.title,
    required this.status,
    required this.api,
    required this.count,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    generated: json["generated"],
    url: json["url"],
    title: json["title"],
    status: json["status"],
    api: json["api"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "generated": generated,
    "url": url,
    "title": title,
    "status": status,
    "api": api,
    "count": count,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
