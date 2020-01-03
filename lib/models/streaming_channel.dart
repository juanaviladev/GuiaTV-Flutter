import 'streaming_option.dart';

class StreamingChannel {
  String epg_id;
  String logo;
  String name;
  List<StreamingOption> options;
  String resolution;
  String web;

  StreamingChannel(
      {this.epg_id,
      this.logo,
      this.name,
      this.options,
      this.resolution,
      this.web});

  factory StreamingChannel.fromJson(Map<String, dynamic> json) {
    return StreamingChannel(
      epg_id: json['epg_id'],
      logo: json['logo'],
      name: json['name'],
      options: json['options'] != null
          ? (json['options'] as List)
              .map((i) => StreamingOption.fromJson(i))
              .toList()
          : null,
      resolution: json['resolution'],
      web: json['web'],
    );
  }
}
