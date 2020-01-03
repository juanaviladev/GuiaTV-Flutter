import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guia_tv_flutter/data/fav_program_dao.dart';
import 'package:guia_tv_flutter/data/tv_guide_repository.dart';
import 'package:guia_tv_flutter/models/program.dart';
import 'package:guia_tv_flutter/models/tv_channel.dart';

enum Status { IN_PROGRESS, DONE, FAILED }

class Task<T> {
  T data;
  Status status;

  Task({
    @required this.data,
    @required this.status,
  });
}

class ScheduleViewModel {
  StreamController<List<Program>> _favsController;
  StreamController<Program> _unfavedProgramController;
  StreamController<Task<ChannelSchedule>> _scheduleController;
  StreamController<DateTime> _dateController;

  List<Program> _favs = [];
  ChannelSchedule _schedule;
  TvGuideRepository repository = new TvGuideRepository();
  DateTime _selectedDate;

  TvChannel _selectedChannel;

  ScheduleViewModel() {
    _selectedDate = DateTime.now();
    _unfavedProgramController = StreamController.broadcast();
    _dateController = StreamController.broadcast(onListen: () {
      _dateController.add(_selectedDate);
      //TODO: BehaviourSubject improvement
    });
    _favsController = StreamController.broadcast(onListen: () {
      if (_favs.isEmpty) {
        print("Refreshing");
        _init();
      }
    });
    _scheduleController = StreamController.broadcast();
  }

  Stream<List<Program>> get favs => _favsController.stream;
  Stream<Task<ChannelSchedule>> get schedule => _scheduleController.stream;
  Stream<DateTime> get date => _dateController.stream;
  Stream<Program> get unfaved => _unfavedProgramController.stream;

  void _init() async {
    _favs = await programsDao.readAll();
    _favsController.add(_favs);
  }

  fav(Program fp) async {
    await programsDao.create(fp);
    fp.fav = true;
    _favs.add(fp);
    _favsController.add(_favs);
  }

  /*
  final snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
      // Some code to undo the change.
    },
  ),
);
   */

  unFav(Program fp) async {
    await programsDao.delete(fp.id);
    final i = _favs.indexWhere((p) => p.id == fp.id);
    _favs.removeAt(i);
    _favsController.add(_favs);

    final j = _schedule.programs.indexWhere((p) => p.id == fp.id);
    if (j >= 0) {
      _schedule.programs[j].fav = false;
      print(_schedule.hashCode);
      _scheduleController.add(Task(data: _schedule, status: Status.DONE));
    }

    _unfavedProgramController.add(fp);
  }

  void dispose() {
    _scheduleController.close();
    _favsController.close();
    _unfavedProgramController.close();
    _dateController.close();
  }

  Future<void> refreshSchedule() async {
    print("refresh");
    _scheduleController.add(Task(data: null, status: Status.IN_PROGRESS));
    try {
      final schedule =
          await repository.tvGuideBy(_selectedDate, this._selectedChannel);
      _schedule = schedule;
      _scheduleController.add(Task(data: schedule, status: Status.DONE));
    } catch (e) {
      _scheduleController.add(Task(data: null, status: Status.FAILED));
    }
  }

  void channelSelected(TvChannel c) {
    _selectedChannel = c;
    refreshSchedule();
  }

  void onDateSelected(DateTime currentDate) {
    this._selectedDate = currentDate;
    _dateController.add(_selectedDate);
    refreshSchedule();
  }

  void deleteAll() async {
    await programsDao.deleteAll();
    _schedule.programs
        .where((p) => _favs.indexWhere((f) => f.id == p.id) >= 0)
        .forEach((p) => p.fav = false);
    _favs = [];
    _scheduleController.add(Task(data: _schedule, status: Status.DONE));
    _favsController.add(_favs);
  }
}
