import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/data/tv_guide_repository.dart';
import 'package:guia_tv_flutter/viewmodels/schedule_vm.dart';
import 'package:intl/intl.dart';

import '../models/program.dart';

class FavsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ScheduleViewModel scheduleViewModel;

  const FavsPageAppBar({Key key, this.scheduleViewModel}) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 4.0,
      title: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.favorite,
              ),
            ),
            Text("Favoritos"),
          ],
        ),
      ),
      actions: [
        FlatButton.icon(
            onPressed: () async {
              scheduleViewModel.deleteAll();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            label: Text(
              "Limpiar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.title.fontSize),
            ))
      ],
    );
  }
}

class FavsPage extends StatefulWidget {
  final ScheduleViewModel scheduleViewModel;
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  FavsPage({
    @required this.scheduleViewModel,
  });

  @override
  _FavsPageState createState() => _FavsPageState();
}

class _FavsPageState extends State<FavsPage> {
  TvGuideRepository repository = new TvGuideRepository();

  @override
  void initState() {
    print("initState _FavsPageState()");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.scheduleViewModel.favs,
        builder: (ctx, AsyncSnapshot<List<Program>> snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snap.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('res/images/empty_placeholder.png'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Have you checked any program?",
                      style: Theme.of(context).textTheme.title,
                    ),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (ctx, i) {
              final item = snap.data[i];
              return _programItemView(item);
            },
            itemCount: snap.data.length,
          );
        });
  }

  _programItemView(Program item) {
    return Dismissible(
      onDismissed: (ignored) {
        widget.scheduleViewModel.unFav(item);
      },
      key: ValueKey(item.id),
      child: GestureDetector(
        onTap: () {
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProgramDetailView(p: item)));
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('res/images/image_spinner.gif'),
                            image: NetworkImage(item.imgUrl),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          color: Colors.redAccent,
                          icon: Icon(Icons.favorite),
                          onPressed: () {},
                        ),
                      )
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
                          child: Text(item.genre),
                        ),
                        Text(
                            "${item.iniTime.format(context)} - ${item.endTime.format(context)}"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.dateFormat.format(item.date)}"),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateFavs() {
    setState(() {});
  }
}
