import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/pages/favs_page.dart';
import 'package:guia_tv_flutter/pages/guide_page.dart';
import 'package:guia_tv_flutter/viewmodels/channel_vm.dart';
import 'package:guia_tv_flutter/viewmodels/schedule_vm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (ctx) => MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScheduleViewModel scheduleViewModel;
  ChannelsViewModel channelsViewModel;
  int _currentIndex = 0;
  List<PreferredSizeWidget> _appBars;

  @override
  void initState() {
    super.initState();
    channelsViewModel = ChannelsViewModel();
    scheduleViewModel = ScheduleViewModel();
    _appBars = [
      GuidePageAppBar(
        scheduleViewModel: scheduleViewModel,
      ),
      FavsPageAppBar(
        scheduleViewModel: scheduleViewModel,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text("Guía"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text("Favoritos")),
        ],
      ),
      appBar: _appBars[_currentIndex],
      body: SafeArea(
        child: IndexedStack(
          children: [
            GuidePage(
              channelsViewModel: channelsViewModel,
              scheduleViewModel: scheduleViewModel,
            ),
            FavsPage(
              scheduleViewModel: scheduleViewModel,
            )
          ],
          index: _currentIndex,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scheduleViewModel.dispose();
  }
}
