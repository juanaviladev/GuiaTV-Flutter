import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guia_tv_flutter/data/tv_guide_repository.dart';
import 'package:guia_tv_flutter/models/program.dart';

import '../models/tv_channel.dart';
import 'video_page.dart';

class ProgramDetailView extends StatelessWidget {
  final Program p;
  final repo = new TvGuideRepository();

  ProgramDetailView({Key key, this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
    return FutureBuilder(
        future: repo.detailOf(p),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          ProgramDetail pd = snap.data;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                // Permite al usuario revelar el app bar si comienza a desplazarse
                // hacia arriba en la lista de elementos
                pinned: true,
                // Mostrar un widget placeholder para visualizar el tamaño de reducción
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(pd.title),
                  background: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: AssetImage('res/images/placeholder.png'),
                    image: NetworkImage(pd.landingImgUrl),
                  ),
                ),
                // Aumentar la altura inicial de la SliverAppBar más de lo normal
              ),
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showDialog(p, p.channel, ctx);
                              },
                              child: Card(
                                child: Stack(
                                  children: [
                                    FadeInImage(
                                      height: 200,
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'res/images/image_spinner.gif'),
                                      image: NetworkImage(pd.imgUrl),
                                    ),
                                    p.isLiveNow &&
                                            p.channel.streamOpts.isNotEmpty
                                        ? Positioned.directional(
                                            end: 0,
                                            bottom: 0,
                                            textDirection: TextDirection.ltr,
                                            child: Image.asset(
                                              'res/images/play.gif',
                                              height: 40,
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 8,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    pd.title,
                                    style: Theme.of(ctx).textTheme.title,
                                  ),
                                  Text(
                                    pd.subtitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(ctx).textTheme.subtitle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.star_border),
                                        Text(pd.rating.toString())
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 24),
                            child: Text(
                              pd.synopsis,
                              style: TextStyle(fontSize: 16),
                            ))
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void _showDialog(Program item, TvChannel c, BuildContext ctx) {
    showDialog(
        context: ctx,
        child: SimpleDialog(
          title: Text("Seleccione un stream: "),
          children: _streamingOptsOf(c, ctx),
        ));
  }

  _streamingOptsOf(TvChannel c, BuildContext ctx) {
    return c.streamOpts.map((opt) {
      return SimpleDialogOption(
        child: Text(opt.format),
        onPressed: () {
          Navigator.of(ctx).push(
              MaterialPageRoute(builder: (context) => VideoPage(url: opt.url)));
        },
      );
    }).toList();
  }
}
