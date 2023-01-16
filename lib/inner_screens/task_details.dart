import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/services/global_methode.dart';
import 'package:work_os/widgets/comments_widget.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String taskId;

  const TaskDetailsScreen({
    required this.uploadedBy,
    required this.taskId,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  var _textStyle = TextStyle(
    color: Constants.darkBlue,
    fontSize: 13.0,
    fontWeight:FontWeight.normal,
  );
  var _titlesStyle = TextStyle(
    color: Constants.darkBlue,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  TextEditingController _commentController = TextEditingController();
  bool isCommenting = false;
  String? authorName;
  String? userImageUrl;
  String? authorPosition;
  String? taskCategory;
  String? taskTitle;
  String? taskDescription;
  bool? _isDone;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  bool? isDeadlineAvailable = false;

  @override
  void initState() {
    super.initState();
    getTaskData();
  }

  void getTaskData()async
  {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();
    if(userDoc == null)
    {
      return;
    }
    else
    {
      setState(() {
        authorName = userDoc.get('name');
        authorPosition = userDoc.get('positionInCompany');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot taskDatabase = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    if(taskDatabase == null)
    {
      return;
    }
    else
    {
      setState(() {
        _isDone = taskDatabase.get('isDone');
        postedDateTimeStamp = taskDatabase.get('createdAt');
        deadlineDateTimeStamp = taskDatabase.get('deadlineDateTimeStamp');
        deadlineDate = taskDatabase.get('deadlineDate');
        taskTitle = taskDatabase.get('taskTitle');
        taskDescription = taskDatabase.get('taskDescription');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.day}-${postDate.month}-${postDate.year}';
      });

      var date = postedDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }


  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextButton(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: TextStyle(
              color: Constants.darkBlue,
              fontStyle: FontStyle.italic,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Text(
              taskTitle == null ? '' : taskTitle!,
              style: TextStyle(
                color: Constants.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Uploaded By',
                            style: TextStyle(
                              color: Constants.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              border:Border.all(
                                width: 3,
                                color: Colors.pink.shade700
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  userImageUrl == null
                                      ? 'https://i.pinimg.com/736x/d7/25/1e/d7251e692ccbbcdad3a8a9d3afeaf8e1--vector-icons-vectors.jpg'
                                      : userImageUrl!
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authorName == null ? '' :authorName!,
                                style:_textStyle,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                authorPosition == null ? '' :authorPosition!,
                                style: _textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upload on:',
                            style: _titlesStyle,
                          ),
                          Text(
                            postedDate == null ? '' : postedDate!,
                            style: TextStyle(
                              color: Constants.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deadline date:',
                            style: _titlesStyle,
                          ),
                          Text(
                            deadlineDate == null ? '' : deadlineDate!,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Center(
                        child: Text(
                          isDeadlineAvailable!
                              ? 'Deadline is not finished yet'
                              : 'Deadline Passed',
                          style: TextStyle(
                            color: isDeadlineAvailable!
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      dividerWidget(),
                      Text(
                        'Done state:',
                        style: _titlesStyle,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed:()
                            {
                              User? user = _auth.currentUser;
                              final _uid = user!.uid;
                              if(_uid == widget.uploadedBy)
                              {
                                try
                                {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .update({'isDone': true});
                                }
                                catch(error)
                                {
                                  GlobalMethode.showErrorDialog(
                                    error: 'Action can\'t be performed',
                                    context: context,
                                  );
                                }
                              }
                              else
                              {
                                GlobalMethode.showErrorDialog(
                                  error: 'you can\'t perform this action',
                                  context: context,
                                );
                              }
                              getTaskData();
                            },
                            child: Text(
                                'Done',
                                style:TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Constants.darkBlue,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                )
                            ),
                          ),
                          Opacity(
                            opacity: _isDone == true ? 1 : 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          TextButton(
                            onPressed:()
                            {
                              User? user = _auth.currentUser;
                              final _uid = user!.uid;
                              if(_uid == widget.uploadedBy)
                              {
                                try
                                {
                                  FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.taskId)
                                      .update({'isDone': false});
                                }
                                catch(error)
                                {
                                  GlobalMethode.showErrorDialog(
                                    error: 'Action can\'t be performed',
                                    context: context,
                                  );
                                }
                              }
                              else
                              {
                                GlobalMethode.showErrorDialog(
                                  error: 'you can\'t perform this action',
                                  context: context,
                                );
                              }
                              getTaskData();
                            },
                            child: Text(
                                'Not done yet',
                                style:TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Constants.darkBlue,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                )
                            ),
                          ),
                          Opacity(
                            opacity: _isDone == false ? 1 : 0,
                            child: Icon(
                              Icons.check_box,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      dividerWidget(),
                      Text(
                        'Task description:',
                        style: _titlesStyle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        taskDescription == null
                            ? ''
                            : taskDescription!,
                        style: _textStyle,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 500,
                        ),
                        child:isCommenting
                            ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: TextField(
                                controller: _commentController,
                                style: TextStyle(
                                  color: Constants.darkBlue,
                                ),
                                maxLength: 200,
                                maxLines: 6,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.pink,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).scaffoldBackgroundColor
                                ),
                              ),
                            ),
                            Flexible(
                              child:Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: MaterialButton(
                                      onPressed:()async
                                      {
                                        if(_commentController.text.length <= 1)
                                        {
                                          GlobalMethode.showErrorDialog(
                                            error: 'Comment can\'t be less than 1 character',
                                            context: context,
                                          );
                                        }
                                        else
                                        {
                                          final _generatedId = Uuid().v4();
                                          await FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(widget.taskId)
                                              .update({
                                            'taskComments' : FieldValue.arrayUnion([
                                              {
                                                'userId': widget.uploadedBy,
                                                'commentId': _generatedId,
                                                'name': authorName,
                                                'userImageUrl': userImageUrl,
                                                'commentBody': _commentController.text,
                                                'time': Timestamp.now(),
                                              }
                                            ]),
                                          });
                                          await Fluttertoast.showToast(
                                              msg: "Your comment has been added",
                                              toastLength: Toast.LENGTH_LONG,
                                              //gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.grey,
                                              fontSize: 18.0);
                                          _commentController.clear();
                                        }
                                        setState(() {

                                        });
                                      },
                                      color: Colors.pink.shade700,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                        child: Text(
                                          'Post',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                  ),
                                  TextButton(
                                    onPressed: ()
                                    {
                                      setState(() {
                                        isCommenting = !isCommenting ;
                                      });
                                    },
                                    child: Text(
                                      'Cancel'
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            :Center(
                          child: MaterialButton(
                            onPressed:()
                            {
                              setState(() {
                                isCommenting = !isCommenting ;
                              });
                            },
                            color: Colors.pink.shade700,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14.0
                              ),
                              child: Text(
                                'Add a Comment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.taskId)
                            .get(),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(child: CircularProgressIndicator());
                          }
                          else
                          {
                            if(snapshot.data == null)
                            {
                              return Center(child: Text('No comment for this task'));
                            }
                          }
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder:(context, index)
                          {
                            return CommentWidget(
                              commentId: snapshot.data!['taskComments'][index]['commentId'],
                              commenterId: snapshot.data!['taskComments'][index]['userId'],
                              commenterName: snapshot.data!['taskComments'][index]['name'],
                              commentBody: snapshot.data!['taskComments'][index]['commentBody'],
                              commenterImageUrl: snapshot.data!['taskComments'][index]['userImageUrl'],
                            );
                          },
                          separatorBuilder: (context, index)
                          {
                            return Divider(thickness:1,);
                          },
                          itemCount: snapshot.data!['taskComments'].length,
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dividerWidget()
  {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Divider(thickness: 1,),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
