import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/models/tv_channel.dart';

class Program {
  String id;
  TvChannel channel;
  String genre;
  String title;
  TimeOfDay iniTime;
  TimeOfDay endTime;
  Duration duration;
  String infoUrl;
  String imgUrl;
  bool isLiveNow;
  double progress;
  String type;
  DateTime date;
  bool fav;

  Program({
    @required this.id,
    @required this.channel,
    @required this.type,
    @required this.genre,
    @required this.title,
    @required this.iniTime,
    @required this.endTime,
    @required this.duration,
    @required this.infoUrl,
    @required this.imgUrl,
    @required this.isLiveNow,
    @required this.progress,
    @required this.date,
    this.fav = false,
  });

  Map<String, dynamic> toMap() {
    final dateTime = DateTime.now();
    return {
      'id': this.id,
      'genre': this.genre,
      'title': this.title,
      'ini_time':
          DateTime(dateTime.year, 1, 1, this.iniTime.hour, this.iniTime.minute)
              .toIso8601String(),
      'end_time':
          DateTime(dateTime.year, 1, 1, this.endTime.hour, this.endTime.minute)
              .toIso8601String(),
      'img_url': this.imgUrl,
      'date': this.date.toIso8601String(),
    };
  }

  factory Program.fromMap(Map<String, dynamic> map) {
    return new Program(
      id: map['id'] as String,
      genre: map['genre'] as String,
      title: map['title'] as String,
      iniTime: TimeOfDay.fromDateTime(DateTime.parse(map['ini_time'])),
      endTime: TimeOfDay.fromDateTime(DateTime.parse(map['end_time'])),
      imgUrl: map['img_url'] as String,
      date: DateTime.parse(map['date']),
    );
  }
}

class ProgramDetail {
  String title;
  String subtitle;
  String genre;
  double rating;
  Duration duration;
  String synopsis;
  String landingImgUrl;
  String imgUrl;

  ProgramDetail({
    @required this.title,
    @required this.subtitle,
    @required this.genre,
    @required this.rating,
    @required this.duration,
    @required this.synopsis,
    @required this.landingImgUrl,
    @required this.imgUrl,
  });
}
