import 'package:guia_tv_flutter/models/streaming_channel.dart';

class Ambit {
  List<StreamingChannel> channels;
  String name;

  Ambit({this.channels, this.name});

  factory Ambit.fromJson(Map<String, dynamic> json) {
    return Ambit(
      channels: json['channels'] != null
          ? (json['channels'] as List)
              .map((i) => StreamingChannel.fromJson(i))
              .toList()
          : null,
      name: json['name'],
    );
  }
}
