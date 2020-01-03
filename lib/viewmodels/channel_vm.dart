import 'dart:async';

import 'package:guia_tv_flutter/data/tv_guide_repository.dart';
import 'package:guia_tv_flutter/models/tv_channel.dart';

class ChannelsViewModel {
  TvGuideRepository repository = new TvGuideRepository();
  List<TvChannel> _channels = [];
  StreamController<List<TvChannel>> _channelsController;

  ChannelsViewModel() {
    _channelsController = StreamController.broadcast(onListen: () {
      if (_channels.isEmpty) {
        _init();
      }
    });
  }

  Stream<List<TvChannel>> get channels => _channelsController.stream;

  void _init() async {
    final channels = await repository.allChannels();
    _channels = channels;
    _channelsController.add(channels);
  }

  void dispose() {
    _channelsController.close();
  }
}
