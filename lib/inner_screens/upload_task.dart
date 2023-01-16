
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/services/global_methode.dart';
import 'package:work_os/widgets/drawer_widget.dart';

class UploadTask extends StatefulWidget {
  @override
  State<UploadTask> createState() => _UploadTaskState();
}

class _UploadTaskState extends State<UploadTask> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _taskCategoryController = TextEditingController(text: 'Choose Task Category');
  TextEditingController _taskTitleController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _deadlineDateController = TextEditingController(text: 'Choose Task Deadline Date');
  Timestamp? deadlineDateTimeStamp ;
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  bool _isLoading = false;

  void _uploadTask() async
  {
    final taskID = Uuid().v4();
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();
    if(isValid)
    {
      if(_deadlineDateController.text == 'Choose Task Deadline Date'
          || _taskCategoryController.text == 'Choose Task Category')
      {
        return GlobalMethode.showErrorDialog(
          error: 'Please pick everything',
          context: context
        );
      }
      setState(() {
        _isLoading = true;
      });
      try
      {
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).set({
          'taskId': taskID,
          'uploadedBy': _uid,
          'taskTitle': _taskTitleController.text,
          'taskDescription': _taskDescriptionController.text,
          'deadlineDate': _deadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'taskCategory': _taskCategoryController.text,
          'taskComments': [],
          'isDone': false,
          'createdAt': Timestamp.now(),
        });
        await Fluttertoast.showToast(
            msg: "The task has been uploaded",
            toastLength: Toast.LENGTH_LONG,
            //gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            fontSize: 18.0
        );
        _taskTitleController.clear();
        _taskDescriptionController.clear();
        setState(() {
          _taskCategoryController.text = 'Choose Task Category';
          _deadlineDateController.text = 'Choose Task Deadline Date';
        });
      }
      catch(error)
      {

      }
      finally
      {
        setState(() {
          _isLoading = false;
        });
      }
    }
    else
    {
    }
  }

  @override
  void dispose() {
    _taskCategoryController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _deadlineDateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.darkBlue),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'All Field are required',
                      style: TextStyle(
                        color: Constants.darkBlue,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textTitles(label: 'Task Category*'),
                        _textFormField(
                          valueKey: 'TaskCategory',
                          controller: _taskCategoryController,
                          enabled: false,
                          function: ()
                          {
                            _showTaskCategoriesDialog(size:size);
                          },
                          maxLength: 100,
                        ),
                        //
                        _textTitles(label: 'Task Title*'),
                        _textFormField(
                          valueKey: 'TaskTitle',
                          controller: _taskTitleController,
                          enabled: true,
                          function: (){},
                          maxLength: 100,
                        ),
                        //
                        _textTitles(label: 'Task Description*'),
                        _textFormField(
                          valueKey: 'TaskDescription',
                          controller: _taskDescriptionController,
                          enabled: true,
                          function: (){},
                          maxLength: 1000,
                        ),
                        //
                        _textTitles(label: 'Task Deadline Date*'),
                        _textFormField(
                          valueKey: 'TaskDeadline',
                          controller: _deadlineDateController,
                          enabled: false,
                          function: ()
                          {
                            _pickDateDialog();
                          },
                          maxLength: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30.0,
                    ),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : MaterialButton(
                      onPressed:_uploadTask,
                      color: Colors.pink.shade700,
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Upload Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(
                              Icons.upload_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function function,
    required int maxLength,
})
  {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: ()
        {
          function();
        },
        child: TextFormField(
          validator: (value)
          {
            if(value!.isEmpty)
            {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: TextStyle(
            color: Constants.darkBlue,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          maxLines:valueKey == 'TaskDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.pink,
              ),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
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
                  onTap: ()
                  {
                    setState(() {
                      _taskCategoryController.text = Constants.taskCategoryList[index];
                      Navigator.pop(context);
                    });
                  },
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
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _pickDateDialog()async
  {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0),),
      lastDate: DateTime(2100),
    );
    if(picked != null)
    {
      setState(() {
        _deadlineDateController.text =
        '${picked!.day}-${picked!.month}-${picked!.year}';
        deadlineDateTimeStamp = Timestamp
            .fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);
      });
    }
  }
 Widget _textTitles({
  required String label,
})
  {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.pink[800],
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
