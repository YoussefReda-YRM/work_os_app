import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/inner_screens/profile.dart';

class AllWorkersWidget extends StatefulWidget {

  final String userID;
  final String userName;
  final String userEmail;
  final String positionInCompany;
  final String userPhone;
  final String userImageUrl;

  const AllWorkersWidget({
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.positionInCompany,
    required this.userPhone,
    required this.userImageUrl,
  });

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context)=>ProfileScreen(userID: widget.userID,),
            ),
          );
        } ,
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
            radius: 20.0, // clock = https://cdn-icons-png.flaticon.com/512/3233/3233567.png
            child: Image.network(widget.userImageUrl == null
                ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&usqp=CAU'
                : widget.userImageUrl),
          ),
        ),
        title: Text(

          widget.userName,
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
              '${widget.positionInCompany}/${widget.userPhone}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon:Icon(
            Icons.mail_outline,
            size: 30,
            color: Colors.pink.shade800,
          ),
          onPressed: _mailTo
        ),
      ),
    );
  }
  void _mailTo()async
  {
    var mailUrl = 'mailto:${widget.userEmail}' ;
    if(await canLaunch(mailUrl))
    {
      await launch(mailUrl);
    }
    else
    {
      print('error');
      throw('Error occured');
    }
  }
}
