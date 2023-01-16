import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/inner_screens/task_details.dart';
import 'package:work_os/screens/all_workers.dart';
import 'package:work_os/services/global_methode.dart';

class TaskWidget extends StatefulWidget {
  final String taskTitle ;
  final String taskDescription ;
  final String taskId ;
  final String uploadedBy ;
  final bool isDone ;

  const TaskWidget({
    required this.taskTitle,
    required this.taskDescription,
    required this.taskId,
    required this.uploadedBy,
    required this.isDone,
  });


  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 6.0,
      ),
      child: ListTile(
        onTap:()
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(
                taskId: widget.taskId,
                uploadedBy: widget.uploadedBy,
              ),
            ),
          );
        } ,
        onLongPress: _deleteTask,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        leading: Container(
          padding: EdgeInsets.only(
            right: 12.0,
          ),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1.0,
              ),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20.0,
            child: Image.network(widget.isDone
                ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-pv3gKP0-8TdcR18sOnJooAI8xzOlaAKGHxG6uIC9qo0jctY_8cNTO7Nkm0CeKx_WoKE&usqp=CAU'
                : 'https://cdn-icons-png.flaticon.com/512/3233/3233567.png'),
          ),
        ),
        title: Text(

          widget.taskTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:Constants.darkBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale_outlined,
              color: Colors.pink.shade800,
            ),
            Text(
              widget.taskDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.pink.shade800,
        ),
      ),
    );
  }
  _deleteTask()
  {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          actions: [
            TextButton(
            onPressed:()async
            {
              try
              {
                if(widget.uploadedBy == _uid)
                {
                  await FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(widget.taskId)
                      .delete();
                  await Fluttertoast.showToast(
                      msg: "task has been deleted",
                      toastLength: Toast.LENGTH_LONG,
                      //gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.grey,
                      fontSize: 18.0);
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                }
                else
                {
                  GlobalMethode.showErrorDialog(
                    error: 'you cannot perform this action',
                    context: context,
                  );
                }
              }
              catch(error)
              {
                GlobalMethode.showErrorDialog(
                  error: 'this task can\'t be deleted',
                  context: context
                );
              }
              finally
              {

              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.red,
                  ),
                ),
              ],
            ),
            ),
          ],
        );
      },
    );
  }
}
