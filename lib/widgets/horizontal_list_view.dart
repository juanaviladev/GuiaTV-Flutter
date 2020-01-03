import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/models/tv_channel.dart';

typedef ItemClickListener<T> = void Function(T);

class HorizontalListView extends StatefulWidget {
  final List<TvChannel> items;
  final ItemClickListener<TvChannel> listener;

  const HorizontalListView({Key key, this.items, @required this.listener})
      : super(key: key);

  @override
  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) => _createItemView(i));
  }

  _createItemView(int i) {
    var item = widget.items[i];
    return Container(
      padding: EdgeInsets.all(6),
      child: RaisedButton(
        elevation: selectedIndex == i ? 15 : null,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8),
        ),
        color: Colors.white,
        onPressed: () {
          selectedIndex = i;
          widget.listener(item);
          setState(() {});
        },
        child: FadeInImage(
            placeholder: AssetImage('res/images/image_spinner.gif'),
            image: NetworkImage(item.logoImageUrl)),
      ),
    );
  }
}
