import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/inner_screens/profile.dart';
import 'package:work_os/inner_screens/upload_task.dart';
import 'package:work_os/screens/all_workers.dart';
import 'package:work_os/screens/tasks_screen.dart';
import 'package:work_os/user_state.dart';

Constants _constants = Constants();
class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child:Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/2471/2471952.png',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: Text(
                    'Work Os',
                    style: TextStyle(
                      color: Constants.darkBlue,
                      fontStyle: FontStyle.italic,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          _listTile(
            label: 'All Tasks',
            icon: Icons.task_outlined,
            function: ()
            {
              _navigateToAllTasksScreen(context);
            },
          ),
          _listTile(
            label: 'My Account',
            icon: Icons.settings_outlined,
            function: ()
            {
              _navigateToProfileScreen(context);
            },
          ),
          _listTile(
            label: 'Registered Workers',
            icon: Icons.workspaces_outline,
            function: ()
            {
              _navigateToAllWorkersScreen(context);
            },
          ),
          _listTile(
            label: 'Add a task',
            icon: Icons.add_task,
            function: ()
            {
              _navigateToAddTaskScreen(context);
            },
          ),
          Divider(
            thickness: 1,
          ),
          _listTile(
            label: 'Logout',
            icon: Icons.logout_outlined,
            function: ()
            {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToAllTasksScreen(context)
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context)=>TasksScreen(),
      ),
    );
  }

  void _navigateToProfileScreen(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final String uid = user!.uid;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context)=>ProfileScreen(userID: uid,),
      ),
    );
  }

  void _navigateToAllWorkersScreen(context)
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context)=>AllWorkersScreen(),
      ),
    );
  }

  void _navigateToAddTaskScreen(context)
  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=>UploadTask(),
      ),
    );
  }

  void _logout(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance ;
    showDialog(
      context: context,
      builder:(context)
      {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9ym6W4NL97pMQGTvJC-QXrP9fqMXcqXdKSw&usqp=CAU',
                  height: 20.0,
                  width: 20.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:const Text(
                  'Sign out'
                ),
              ),
            ],
          ),
          content: Text(
            'Do you wanna Sign out',
            style: TextStyle(
              color: Constants.darkBlue,
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed:()
              {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed:()
              {
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserState(),
                  ),
                );
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _listTile({
    required String label,
    required Function function,
    required IconData icon,
  })=>ListTile(
    onTap: ()
    {
      function();
    },
    leading: Icon(
      icon,
      color: Constants.darkBlue,
    ),
    title:Text(
      label,
      style: TextStyle(
        color: Constants.darkBlue,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
