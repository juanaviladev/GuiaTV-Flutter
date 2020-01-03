import 'package:guia_tv_flutter/models/program.dart';

class TvChannel {
  String url;
  String name;
  String logoImageUrl;

  TvChannel.name(this.url, this.name, this.logoImageUrl);
}

class ChannelSchedule {
  TvChannel channel;
  List<Program> programs;

  ChannelSchedule(this.channel, this.programs);
}
