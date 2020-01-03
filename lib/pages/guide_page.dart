import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/viewmodels/channel_vm.dart';
import 'package:guia_tv_flutter/viewmodels/schedule_vm.dart';
import 'package:intl/intl.dart';

import '../models/program.dart';
import '../models/tv_channel.dart';
import '../widgets/fav_button.dart';
import '../widgets/horizontal_list_view.dart';
import 'detail_page.dart';

class GuidePage extends StatefulWidget {
  final ScheduleViewModel scheduleViewModel;
  final ChannelsViewModel channelsViewModel;

  @override
  _GuidePageState createState() => _GuidePageState();

  const GuidePage({
    @required this.scheduleViewModel,
    @required this.channelsViewModel,
  });
}

class GuidePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ScheduleViewModel scheduleViewModel;

  final DateFormat dateFormat = DateFormat("dd/MM");

  GuidePageAppBar({Key key, this.scheduleViewModel}) : super(key: key);

  Future<DateTime> _selectDate(DateTime initialDate, BuildContext ctx) async {
    DateTime picked = await showDatePicker(
      context: ctx,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    return picked ?? initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: DateTime.now(),
        stream: scheduleViewModel.date,
        builder: (context, AsyncSnapshot<DateTime> snapshot) {
          return AppBar(
            titleSpacing: 4.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.tv),
                    ),
                    Text("Guía TV"),
                  ],
                ),
                Text(dateFormat.format(snapshot.data)),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final currentDate = await _selectDate(snapshot.data, context);
                  scheduleViewModel.onDateSelected(currentDate);
                },
                icon: Icon(Icons.calendar_today),
              )
            ],
          );
        });
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _GuidePageState extends State<GuidePage> {
  @override
  void initState() {
    super.initState();
    widget.scheduleViewModel.unfaved.listen((program) => _onUnfaved(program));
    widget.scheduleViewModel.refreshSchedule();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return RefreshIndicator(
      onRefresh: () => widget.scheduleViewModel.refreshSchedule(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: widget.channelsViewModel.channels,
              builder: (ctx, snap) => AnimatedSwitcher(
                duration: Duration(seconds: 4),
                child: _createHorizontalChannels(ctx, snap),
              ),
            ),
            StreamBuilder(
                stream: widget.scheduleViewModel.schedule,
                builder: (ctx, AsyncSnapshot<Task<ChannelSchedule>> snap) {
                  var view;
                  if (snap.connectionState == ConnectionState.active &&
                      snap.hasData &&
                      snap.data.status == Status.DONE) {
                    var schedule = snap.data.data;
                    var items = schedule.programs;
                    if (items.isNotEmpty) {
                      view = ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (ctx, i) {
                            final item = items[i];
                            return _programItemView(item, schedule.channel);
                          });
                    } else {
                      view = Container(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.longestSide * 0.6
                            : MediaQuery.of(context).size.shortestSide * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                  'res/images/empty_placeholder.png'),
                            ),
                            Flexible(
                              child: Text(
                                "Vaya, parece que no hay nada",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.title,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  } else if (snap.hasData &&
                      snap.data.status == Status.FAILED) {
                    view = Container(
                      height: orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.longestSide * 0.6
                          : MediaQuery.of(context).size.shortestSide * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                Image.asset('res/images/empty_placeholder.png'),
                          ),
                          Flexible(
                            child: Text(
                              "Vaya, parece que no hay nada",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.title,
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    view = Container(
                      height: orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.longestSide * 0.6
                          : MediaQuery.of(context).size.shortestSide * 0.5,
                      child: Center(
                        child: Image(
                          image: AssetImage('res/images/main_spinner.gif'),
                        ),
                      ),
                    );
                  }
                  return AnimatedSwitcher(
                    child: view,
                    duration: Duration(milliseconds: 500),
                  );
                })
          ],
        ),
      ),
    );
  }

  _programItemView(Program item, TvChannel c) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProgramDetailView(p: item)));
      },
      child: SizedBox(
        height: 150,
        child: Card(
          elevation: 4,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          FadeInImage(
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('res/images/image_spinner.gif'),
                            image: NetworkImage(item.imgUrl),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: FavButton(
                              checked: item.fav,
                              color: Colors.white,
                              pressedColor: Colors.redAccent,
                              onPressed: (checked) async {
                                if (checked)
                                  widget.scheduleViewModel.fav(item);
                                else
                                  widget.scheduleViewModel.unFav(item);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            // color: Colors.grey[800],
                            fontWeight: FontWeight.w300,
                            // fontStyle: FontStyle.italic,
                            //  fontFamily: 'Open Sans',
                            fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: item.isLiveNow
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: item.progress,
                                ),
                              )
                            : Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.genre),
                      ),
                      Text(
                          "${item.iniTime.format(context)} - ${item.endTime.format(context)}"),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _isLiveNowDot(item),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 1,
                      child: FadeInImage(
                        fit: BoxFit.fitHeight,
                        height: 50,
                        placeholder: AssetImage('res/images/image_spinner.gif'),
                        image: NetworkImage(c.logoImageUrl),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createHorizontalChannels(
      BuildContext ctx, AsyncSnapshot<List<TvChannel>> snap) {
    if (snap.hasData) {
      return OrientationBuilder(builder: (context, orientation) {
        return Container(
            height: MediaQuery.of(context).size.longestSide *
                (orientation == Orientation.portrait ? 0.1 : 0.2),
            child: HorizontalListView(
                items: snap.data, listener: _onChannelClick));
      });
    } else {
      return Container();
    }
  }

  _isLiveNowDot(Program p) {
    if (p.isLiveNow) {
      return Image(image: AssetImage('res/images/live.gif'));
    } else {
      return Container();
    }
  }

  _onChannelClick(TvChannel c) => widget.scheduleViewModel.channelSelected(c);

  _onUnfaved(Program program) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text("💔 '${program.title}' ha sido eliminado"),
      action: SnackBarAction(
        label: 'Deshacer',
        onPressed: () {
          widget.scheduleViewModel.fav(program);
        },
      ),
    ));
  }
}
