import 'package:guia_tv_flutter/models/program.dart';
import 'package:guia_tv_flutter/models/streaming_option.dart';

class TvChannel {
  String url;
  String name;
  String logoImageUrl;
  List<StreamingOption> streamOpts = [];

  TvChannel.name(this.url, this.name, this.logoImageUrl, this.streamOpts);
}

class ChannelSchedule {
  TvChannel channel;
  List<Program> programs;

  ChannelSchedule(this.channel, this.programs);
}
