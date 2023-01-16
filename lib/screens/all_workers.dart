import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/widgets/all_workers_widget.dart';
import 'package:work_os/widgets/drawer_widget.dart';
import 'package:work_os/widgets/task_widget.dart';

class AllWorkersScreen extends StatefulWidget {
  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'All Workers',
          style: TextStyle(
            color: Colors.pink,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.connectionState == ConnectionState.active)
          {
            if(snapshot.data!.docs.isNotEmpty)
            {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(BuildContext context, int index)
                {
                  return AllWorkersWidget(
                    userID: snapshot.data!.docs[index]['id'],
                    userName: snapshot.data!.docs[index]['name'],
                    userEmail: snapshot.data!.docs[index]['email'],
                    userPhone: snapshot.data!.docs[index]['phoneNumber'],
                    positionInCompany: snapshot.data!.docs[index]['positionInCompany'],
                    userImageUrl: snapshot.data!.docs[index]['userImage'],
                  );
                },
              );
            }
            else
            {
              return Center(child: Text('There is no users'),);
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

}
