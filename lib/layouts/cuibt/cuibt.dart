import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/layouts/cuibt/states.dart';
import 'package:todoapp/modules/archived_tasks/ArchivedTasks.dart';
import 'package:todoapp/modules/done_tasks/DoneTasks.dart';
import 'package:todoapp/modules/new_tasks/NewTasks.dart';

class AppCuibt extends Cubit<AppStates>
{
  AppCuibt() : super(AppInitialState());
  // to get instance 
  static AppCuibt get(context) => BlocProvider.of(context);


  int currentIndex = 0;
  late Database database;
  List<Map> Newtasks = [];
  List<Map> Donetasks = [];
  List<Map> Archivedtasks = [];
  bool isShownBottomShow = false;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> screenAppBar = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeNavBar());
  }

   void createDataBase() {
    openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (database, version){
        print("Create dataBase");
         database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then((value) {
          print("Create table");
        }).catchError((error) {
          print(" catchError " + error.toString());
        });
      },
      onOpen: (database) {
        getDataBase(database);
        print("Open dataBase");
      },
    ).then((value) 
    {
      database = value;
      emit(AppCreateDataBase());
      
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
     await database.transaction((txn) async 
    {
      txn.rawInsert(
          ' INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "st")'
          ).then((value) 
          {
          print("$value INSERT successfully");
          emit(AppInsertDataBase());
              getDataBase(database);
          }).catchError((error) 
         {
          print(" catchError " + error.toString());
         });
      return null;
    });
  }

  void getDataBase(database) 
  {
    Newtasks = [];
    Donetasks = [];
    Archivedtasks = [];
     database.rawQuery('SELECT * FROM tasks').then((value)
        {
          
          value.forEach((element) { 
            if(element['status']=='st') {
              Newtasks.add(element);
            }
            else if(element['status']=='done') {
              Donetasks.add(element);
            }
            else{
              Archivedtasks.add(element);
            }
          });
          emit(AppGetDataBase());
        });
  }

 void updateDataBase({
    required String status,
    required int id,
  }) async
   {
            database.rawUpdate(
            'UPDATE tasks SET status = ? WHERE id = ?',
            ['$status', id], 
            ).then((value)
            {
              getDataBase(database);
                emit(AppUpdateDataBase());
            });

  }

   void deleteDataBase({
    required int id,
  }) async
   {
            database.rawUpdate(
            'DELETE  FROM  tasks WHERE id = ?',
            [ id], 
            ).then((value)
            {
              getDataBase(database);
              emit(AppDeleteDataBase());
            });

  }

  void changeBottemShette(bool isShow)
  {
      isShownBottomShow = isShow;
      emit(AppChangeBottemShetteState());
  }

}