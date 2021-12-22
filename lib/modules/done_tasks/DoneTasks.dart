import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/layouts/cuibt/cuibt.dart';
import 'package:todoapp/layouts/cuibt/states.dart';
import 'package:todoapp/shared/components/components.dart';
class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return BlocConsumer<AppCuibt,AppStates>(
      listener: (context , state){},
      builder: (context , state){
        var taskes = AppCuibt.get(context).Donetasks;
        return ListView.separated(
        itemBuilder: (context ,index) => defultTaskItem(taskes[index],context),
         separatorBuilder: (context, index) => Container(
           width: double.infinity,
           height: 1.0,
           color: Colors.grey[300],
           
         ), 
         // a proplem with get length tasks.length
         itemCount:taskes.length);
      },
    );
  }
}
