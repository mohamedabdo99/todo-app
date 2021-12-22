import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/layouts/cuibt/cuibt.dart';
import 'package:todoapp/layouts/cuibt/states.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget 
{
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCuibt()..createDataBase(),
      child: BlocConsumer<AppCuibt,AppStates>(
        listener:(context,state){
            if(state is AppInsertDataBase){
              Navigator.pop(context);
            }
        } ,
        builder: (context , state)
        {
          // object from AppCuibt inside builder
          AppCuibt cuibt = AppCuibt.get(context);
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: Text(
              cuibt.screenAppBar[cuibt.currentIndex],
            ),
          ),
        body: cuibt.screens[cuibt.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: cuibt.currentIndex,
          onTap: (index) {
              AppCuibt.get(context).changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: "Tasks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: "Done",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined),
              label: "Archived",
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (cuibt.isShownBottomShow) 
            {
              cuibt.insertToDatabase(
                title: titleController.text,
                 time: timeController.text,
                  date: dateController.text,
                  );
              // to add value to dataBase
              // insertToDatabase(
              //   title: titleController.text,
              //   time: timeController.text,
              //   date: dateController.text,
              // ).then((value) 
              // {
              //   Navigator.pop(context);
              //   isShownBottomShow = false;
              // });
            }
            else 
            {
              scaffoldkey.currentState!.showBottomSheet((context) =>
                  Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultTextFiled(
                          label: "title",
                          suffix: Icons.title,
                          controller: titleController,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 10.0,),
                        defaultTextFiled(
                          onTap: () 
                          {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              timeController.text =
                                  value!.format(context).toString();
                            }).catchError((onError) {
    
                            });
                          },
                          label: "Time task",
                          suffix: Icons.access_time,
                          controller: timeController,
                          type: TextInputType.datetime,
                        ),
                        SizedBox(height: 10.0,),
                        defaultTextFiled(
                          onTap: () 
                          {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015),
                             // Be careful of the way of history
                              lastDate: DateTime.parse('2021-09-26'),
                            ).then((value) {
                              dateController.text =
                                  DateFormat.yMMMd().format(value!);
                            });
                          },
                          label: "Date task",
                          suffix: Icons.date_range_rounded,
                          controller: dateController,
                          type: TextInputType.datetime,
                        ),
                      ],
                    ),
                  )).closed.then((value)
                {
                  cuibt.changeBottemShette(false);
              });
              cuibt.changeBottemShette(true);
            }
          },
        ),
      );
        },
         ),
    );
  }
}


