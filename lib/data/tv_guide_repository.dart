import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/models/program.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/tv_channel.dart';
import 'fav_program_dao.dart';

class TvGuideRepository {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  Future<ChannelSchedule> tvGuideBy(DateTime date, TvChannel channel) async {
    final url =
        '${channel == null ? "http://www.movistarplus.es/guiamovil" : channel.url}/${dateFormat.format(date)}';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var args = {
        'body': utf8.decode(response.bodyBytes),
        'c': channel,
        'date': date
      };
      ChannelSchedule daySchedule = await compute(computeParseHTML, args);
      final favs = Map.fromIterable(await programsDao.readAll(),
          key: (item) => item.id, value: (item) => true);
      daySchedule.programs.forEach((p) => p.fav = favs[p.id] ?? false);
      return daySchedule;
    } else {
      print("error: $url");
      return Future.error(null);
    }
  }

  Future<List<TvChannel>> allChannels() async {
    final url = Uri.http('www.movistarplus.es', 'guiamovil');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return compute(parseChannelsHTML, utf8.decode(response.bodyBytes));
    } else {
      return [];
    }
  }

  Future<ProgramDetail> detailOf(Program p) async {
    final url = p.infoUrl;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var doc = parse(utf8.decode(response.bodyBytes));
      var synopsis = doc
          .querySelector('div.show-content')
          .text
          .replaceAll("Ver más", "")
          .trim();
      var landingImg = doc
              .querySelector('.hero-m div.wrapper > picture')
              ?.querySelector('img')
              ?.attributes['src'] ??
          "";
      var img =
          doc.querySelector('.ee-info .cover img')?.attributes['src'] ?? "";
      var title = doc.querySelector('.title-especial .h-epsilon').text;
      var subtitle = doc.querySelector('.title-especial .h-gamma').text;
      var genre = doc.querySelector('p[itemprop="genre"]').text;
      var rating =
          double.parse(doc.querySelector('div.rating-value span.rating').text);

      final duration = doc
              .querySelector('div.ee-duration .time')
              ?.text
              ?.replaceAll("'", "") ??
          '0';
      var durationSplitted = duration.split(":");
      var parsedDuration = Duration(
          hours: int.parse(durationSplitted[0]),
          minutes: int.parse(durationSplitted[1]));

      return ProgramDetail(
          title: title,
          subtitle: subtitle,
          genre: genre,
          duration: parsedDuration,
          rating: rating,
          synopsis: synopsis,
          landingImgUrl: landingImg,
          imgUrl: img);
    }
  }
}

Future<ChannelSchedule> computeParseHTML(Map<String, dynamic> args) async {
  return parseHTML(args['body'], args['c'], args['date']);
}

Future<ChannelSchedule> parseHTML(
    String body, TvChannel c, DateTime date) async {
  var doc = parse(body);
  // div.ee-info img
  var elements = doc.querySelectorAll('div.container_box');

  TvChannel channel = c == null ? _defaultChannel(doc) : c;

  var programsFutures = elements.map((el) async {
    var moreInfo = el.querySelector('a.j_ficha').attributes['href'];
    var moreInfoUri = Uri.parse(moreInfo);
    var id = moreInfoUri.queryParameters['id'];
    var type = moreInfoUri.queryParameters['type'];

    var moreInfoPage = await http.get(moreInfo);

    var moreInfoDoc = parse(utf8.decode(moreInfoPage.bodyBytes));

    var imgUrl = moreInfoDoc.querySelector('div.ee-info img').attributes['src'];

    var title = el.querySelector('li.title').text.trim();
    var genre = el.querySelector('li.genre').text.trim();
    var time = el.querySelector('li.time').text.trim();

    final duration = moreInfoDoc
            .querySelector('div.ee-duration .time')
            ?.text
            ?.replaceAll("'", "") ??
        '0';
    var durationSplitted = duration.split(":");
    var parsedDuration = Duration(
        hours: int.parse(durationSplitted[0]),
        minutes: int.parse(durationSplitted[1]));

    var isLiveNow =
        moreInfoDoc.querySelector('div.pase')?.text?.contains("ahora") ?? false;

    var timeSplitted = time.split(":");

    RegExp regExp = new RegExp(
      r"\d+",
      caseSensitive: false,
      multiLine: false,
    );

    var progress = 0.0;
    if (isLiveNow) {
      final progressRaw = moreInfoDoc
          .querySelector('div.progress  > div.progress-bar')
          ?.attributes['style'];
      if (regExp.hasMatch(progressRaw)) {
        progress = double.parse(regExp.stringMatch(progressRaw)) / 100;
      }
    }

    var parsedIniTime = TimeOfDay(
        hour: int.parse(timeSplitted[0]), minute: int.parse(timeSplitted[1]));

    var iniHour = int.parse(timeSplitted[0]);
    var iniMinute = int.parse(timeSplitted[1]);

    var dateTimeIni = DateTime(2020, 1, 1, iniHour, iniMinute);
    var endDateTime = dateTimeIni.add(parsedDuration);

    var endTime = TimeOfDay.fromDateTime(endDateTime);

    return new Program(
        title: title,
        channel: channel,
        id: id,
        date: date,
        type: type,
        genre: genre,
        iniTime: parsedIniTime,
        endTime: endTime,
        duration: parsedDuration,
        infoUrl: moreInfo,
        imgUrl: imgUrl,
        isLiveNow: isLiveNow,
        progress: progress,
        fav: false);
  }).toList();

  var programs = await Future.wait(programsFutures);

  return ChannelSchedule(channel, programs);
}

_defaultChannel(Document doc) {
  var it = doc.querySelector('.canales-mov li.active');

  String url = it.querySelector('a').attributes['href'];
  String logoUrl = it.querySelector('img').attributes['src'];
  String name = it.querySelector('img').attributes['title'];

  return TvChannel.name(url, name, logoUrl);
}

List<TvChannel> parseChannelsHTML(String body) {
  var doc = parse(body);
  var elements = doc.querySelectorAll('.canales-mov li');

  return elements.map((it) {
    String url = it.querySelector('a').attributes['href'];
    String logoUrl = it.querySelector('img').attributes['src'];
    String name = it.querySelector('img').attributes['title'];

    return TvChannel.name(url, name, logoUrl);
  }).toList();
}
