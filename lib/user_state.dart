import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_os/screens/auth/login.dart';
import 'package:work_os/screens/tasks_screen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot)
      {
        if(userSnapshot.data == null)
        {
          return Login();
        }
        else if(userSnapshot.hasData)
        {
          return TasksScreen();
        }
        else if(userSnapshot.hasError)
        {
          return Scaffold(
            body: Center(
              child: Text(
                'An error has been occured',
              ),
            ),
          );
        }
        else if(userSnapshot.connectionState == ConnectionState.waiting)
        {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Text(
              'Something went wrong',
            ),
          ),
        );
      }
    );
  }
}
