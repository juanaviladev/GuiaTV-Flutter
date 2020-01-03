import 'country.dart';
import 'license.dart';

class StreamingUrls {
  Map<String, Country> countries;
  String epg_url;
  License license;
  int updated;

  StreamingUrls({this.countries, this.epg_url, this.license, this.updated});

  factory StreamingUrls.fromJson(Map<String, dynamic> json) {
    return StreamingUrls(
      countries: json['countries'] != null
          ? Map.fromIterable(
              (json['countries'] as List).map((i) => Country.fromJson(i)),
              key: (v) => v.name,
              value: (v) => v)
          : null,
      epg_url: json['epg_url'],
      license:
          json['license'] != null ? License.fromJson(json['license']) : null,
      updated: json['updated'],
    );
  }
}
