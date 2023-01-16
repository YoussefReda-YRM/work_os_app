import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/widgets/drawer_widget.dart';
import 'package:work_os/widgets/task_widget.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size ;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // leading: Builder(builder: (context)
        //   {
        //     return IconButton(
        //       icon: Icon(
        //         Icons.menu,
        //         color: Colors.black,
        //       ),
        //       onPressed: ()
        //       {
        //         Scaffold.of(context).openDrawer();
        //       },
        //     );
        //   },
        // ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Tasks',
          style: TextStyle(
            color: Colors.pink,
          ),
        ),
        actions: [
          IconButton(
            onPressed:()
            {
              _showTaskCategoriesDialog(size:size);
            },
            icon: Icon(
              Icons.filter_list_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: Center(child: CircularProgressIndicator()));
          }
          else if(snapshot.connectionState == ConnectionState.active)
          {
            if(snapshot.data!.docs.isNotEmpty)
            {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(BuildContext context, int index)
                {
                  return TaskWidget(
                    taskId: snapshot.data!.docs[index]['taskId'],
                    taskTitle: snapshot.data!.docs[index]['taskTitle'],
                    taskDescription: snapshot.data!.docs[index]['taskDescription'],
                    uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                    isDone: snapshot.data!.docs[index]['isDone'],

                  );
                },

              );
            }
            else
            {
              return Center(child: Text('There is no tasks'),);
            }
          }
          return Center(child: Text(
            'Something went wrong',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,

            ),
          ));
        },)
    );
  }

  _showTaskCategoriesDialog({required size})
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          title: Text(
            'Task Category',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.pink.shade800
            ),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
            shrinkWrap: true,
            itemCount: Constants.taskCategoryList.length,
            itemBuilder:(context, index)
            {
              return InkWell(
                onTap: (){},
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.red.shade200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Constants.taskCategoryList[index],
                        style: TextStyle(
                          color: Constants.darkBlue,
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },),
          ),
          actions: [
            TextButton(
              onPressed:()
              {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed:()
              {
              },
              child: Text('Cancel filter'),
            ),
          ],
        );
      },
    );
  }
}
