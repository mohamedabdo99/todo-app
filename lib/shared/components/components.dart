import 'package:flutter/material.dart';
import 'package:todoapp/layouts/cuibt/cuibt.dart';

Widget defaultTextFiled({
  @required TextEditingController ?controller,
  @required TextInputType ? type ,
  bool  isPassword = false,
  Function? onTap,
  @required String ? label ,
  @required IconData ? suffix,
  IconData? prefix,
  }) => TextFormField(
  controller: controller ,
  keyboardType: type,
  obscureText: isPassword,
  onTap: (){
    onTap!();
  },
  decoration: InputDecoration(
  labelText: label,
  prefixIcon: suffix != null ? Icon(
        prefix,
    ) : null,
    suffixIcon: Icon(
        suffix,
    ),
    border: OutlineInputBorder(),
  ),
);

Widget defultTaskItem(Map model,context) =>  Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
        padding: const EdgeInsets.all(20.0),
  
        child: Row(
  
          children: [
  
            CircleAvatar(
  
              radius: 40.0,
  
              child: Text(
  
                "${model['time']}"
  
              ),
  
            ),
  
            SizedBox(width: 10.0,),
  
            Expanded(
  
              child: Column(
  
                mainAxisSize: MainAxisSize.min,
  
                children: [
  
                  Text(
  
                    "${model['title']}",
  
                    style: TextStyle(
  
                      fontSize: 17.0,
  
                      fontWeight: FontWeight.bold,
  
                    ),
  
                  ),
  
                  Text(
  
                    "${model['date']}",
  
                    style: TextStyle(
  
                      color: Colors.grey,
  
                    ),
  
                  ),
  
                ],
  
              ),
  
            ),
  
            SizedBox(width: 10.0,),
  
            IconButton(
  
              onPressed: ()
  
              {
  
                AppCuibt.get(context)
  
                .updateDataBase(status: 'done', id: model['id'],);
  
              }, 
  
              icon: Icon(
  
                Icons.check_box,
  
              )),
  
            IconButton(
  
              onPressed: ()
  
              {
  
                AppCuibt.get(context)
  
                .updateDataBase(status:'archived', id: model['id'],);
  
              }, 
  
              icon: Icon(
  
                Icons.archive,
  
              )),
  
          ],
  
          ),
  
      ),
  onDismissed:(direction){
    AppCuibt.get(context).deleteDataBase( id: model['id']);
  },
);