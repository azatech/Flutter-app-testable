import 'dart:math';

import 'package:drift_app_testble/local/db/app_db.dart';

final _id1 = Random().nextInt(1000);
final _id2 = Random().nextInt(1000);
final _id3 = Random().nextInt(1000);
final _id4 = Random().nextInt(1000);
final _id5 = Random().nextInt(1000);
final _id6 = Random().nextInt(1000);
final _id7 = Random().nextInt(1000);
final _id8 = Random().nextInt(1000);
final _id9 = Random().nextInt(1000);
final _id10 = Random().nextInt(1000);
final _id11 = Random().nextInt(1000);
final _id12 = Random().nextInt(1000);
final _id13 = Random().nextInt(1000);
final _id14 = Random().nextInt(1000);
final _id15 = Random().nextInt(1000);
final _id16 = Random().nextInt(1000);
final _id17 = Random().nextInt(1000);
final _id18 = Random().nextInt(1000);
final _id19 = Random().nextInt(1000);
final _id20 = Random().nextInt(1000);
final _dueDate = DateTime(2024, 12, 12);

final _todo1 = TodoData(id: _id1, title: 'title_1', dueDate: _dueDate);
final _todo2 = TodoData(id: _id2, title: 'title_2', dueDate: _dueDate);
final _todo3 = TodoData(id: _id3, title: 'title_3', dueDate: _dueDate);
final _todo4 = TodoData(id: _id4, title: 'title_4', dueDate: _dueDate);
final _todo5 = TodoData(id: _id5, title: 'title_5', dueDate: _dueDate);
final _todo6 = TodoData(id: _id6, title: 'title_6', dueDate: _dueDate);
final _todo7 = TodoData(id: _id7, title: 'title_7', dueDate: _dueDate);
final _todo8 = TodoData(id: _id8, title: 'title_8', dueDate: _dueDate);
final _todo9 = TodoData(id: _id9, title: 'title_9', dueDate: _dueDate);
final _todo10 = TodoData(id: _id10, title: 'title_10', dueDate: _dueDate);
final _todo11 = TodoData(id: _id11, title: 'title_11', dueDate: _dueDate);
final _todo12 = TodoData(id: _id12, title: 'title_12', dueDate: _dueDate);
final _todo13 = TodoData(id: _id13, title: 'title_13', dueDate: _dueDate);
final _todo14 = TodoData(id: _id14, title: 'title_14', dueDate: _dueDate);
final _todo15 = TodoData(id: _id15, title: 'title_15', dueDate: _dueDate);
final _todo16 = TodoData(id: _id16, title: 'title_16', dueDate: _dueDate);
final _todo17 = TodoData(id: _id17, title: 'title_17', dueDate: _dueDate);
final _todo18 = TodoData(id: _id18, title: 'title_18', dueDate: _dueDate);
final _todo19 = TodoData(id: _id19, title: 'title_19', dueDate: _dueDate);
final _todo20 = TodoData(id: _id20, title: 'title_20', dueDate: _dueDate);

abstract class UnitTodoFactory {
  UnitTodoFactory._();

  static final todo1 = _todo1;
  static final todo2 = _todo2;
  static final todo3 = _todo3;
  static final todo4 = _todo4;
  static final todo5 = _todo5;
  static final todo6 = _todo6;
  static final todo7 = _todo7;
  static final todo8 = _todo8;
  static final todo9 = _todo9;
  static final todo10 = _todo10;
  static final todo11 = _todo11;
  static final todo12 = _todo12;
  static final todo13 = _todo13;
  static final todo14 = _todo14;
  static final todo15 = _todo15;
  static final todo16 = _todo16;
  static final todo17 = _todo17;
  static final todo18 = _todo18;
  static final todo19 = _todo19;
  static final todo20 = _todo20;

  static final fullListTodos = [
    _todo1,
    _todo2,
    _todo3,
    _todo4,
    _todo5,
    _todo6,
    _todo7,
    _todo8,
    _todo9,
    _todo10,
    _todo11,
    _todo12,
    _todo13,
    _todo14,
    _todo15,
    _todo16,
    _todo17,
    _todo18,
    _todo19,
    _todo20
  ];
}
