import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/my_flutter_app_icons.dart';
import 'package:work_os/user_state.dart';
import 'package:work_os/widgets/drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String userID ;

  const ProfileScreen({required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _titleTextStyle = TextStyle(
    fontSize: 22.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  var _contentTextStyle = TextStyle(
    color:Constants.darkBlue,
    fontSize: 16.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool _isLoading = false ;
  String phoneNumber = "" ;
  String email = "";
  String ?name;
  String jop = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isSameUser = false ;

  void getUserData()async
  {
    try
    {
      _isLoading = true ;
      final DocumentSnapshot userDoc = await FirebaseFirestore
          .instance.collection('users')
          .doc(widget.userID)
          .get();
      if(userDoc == null)
      {
        return;
      }
      else
      {
        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          jop = userDoc.get('positionInCompany');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.day}-${joinedDate.month}-${joinedDate.year}';
        });
        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });
      }
    }
    catch(error)
    {
    }
    finally
    {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size ;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(),)
            : Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
          ),
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.all(30.0,),
                shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          name == null ? 'Name here': name!,
                          style: _titleTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '$jop Since joined $joinedAt',
                          style: _contentTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Divider(thickness: 1.0,),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'Contact Info',
                            style: _titleTextStyle,
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: userInfo(title: 'Email:', content: email),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: userInfo(title: 'Phone:', content: phoneNumber),
                      ),
                      _isSameUser ? Container(): SizedBox(
                        height: 15.0,
                      ),
                      _isSameUser ? Container(): Divider(thickness: 1,),
                      SizedBox(
                        height: 20.0,
                      ),
                      _isSameUser ? Container(): Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _contactBy(
                            color: Colors.green,
                            icon: Icons.whatsapp,
                            function: ()
                            {
                              _openWhatsappChat();
                            },
                          ),
                          _contactBy(
                            color: Colors.red,
                            icon: Icons.mail_outline,
                            function: ()
                            {
                              _mailTo();
                            },
                          ),
                          _contactBy(
                            color: Colors.purple,
                            icon: Icons.call_outlined,
                            function: ()
                            {
                              _callPhoneNumber();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      !_isSameUser ? Container(): Divider(thickness: 1,),
                      SizedBox(
                        height: 25.0,
                      ),
                      !_isSameUser ? Container(): Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 30.0,
                          ),
                          child: MaterialButton(
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
                                  Icon(
                                    Icons.logout_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width*0.26,
                    height: size.width*0.26,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 8,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          imageUrl == null
                              ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQanlasPgQjfGGU6anray6qKVVH-ZlTqmuTHw&usqp=CAU'
                              : imageUrl
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _openWhatsappChat()async
  {
    var url = 'https://wa.me/+2$phoneNumber?text=Hello';
    if(await canLaunch(url))
    {
      await launch(url);
    }
    else
    {
      print('error');
      throw('Error occured');
    }
  }

  void _mailTo()async
  {
    var mailUrl = 'mailto:$email' ;
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

  void _callPhoneNumber()async
  {
    var url = 'tel://$phoneNumber';
    if(await canLaunch(url))
    {
      await launch(url);
    }
    else
    {
      throw 'Error occured';
    }
  }

  Widget _contactBy({
  required Color color,
  required Function function,
  required IconData icon,
})
  {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25.0,
      child: CircleAvatar(
        radius: 23.0,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: ()
          {
            function();
          },
        ),
      ),
    );
  }

  Widget userInfo({required String title, required String content})
  {
    return Row(
      children: [
        Text(
          title,
          style: _titleTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            content,
            style: _contentTextStyle,
          ),
        ),
      ],
    ) ;
  }
}
