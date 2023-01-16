import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work_os/constants/constants.dart';
import 'package:work_os/services/global_methode.dart';
class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation ;
  late TextEditingController _emailTextController = TextEditingController();
  late TextEditingController _passwordTextController = TextEditingController();
  late TextEditingController _positionCPTextController = TextEditingController();
  late TextEditingController _fullNameTextController = TextEditingController();
  late TextEditingController _phoneNumberController = TextEditingController();
  bool _obsecureText = true ;
  final _signUpFormKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _positionCPFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  File? imageFile ;
  final FirebaseAuth _auth = FirebaseAuth.instance ;
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _animationController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

    super.dispose();
  }

  void _submitFormOnRegister() async
  {
    final isValid = _signUpFormKey.currentState!.validate();
    if(isValid)
    {
      if(imageFile == null)
      {
        GlobalMethode.showErrorDialog(
          error: 'please pick an image',
          context: context
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try
      {
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passwordTextController.text.trim(),
        );
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance.ref()
            .child('userImages')
            .child(_uid + '.jpg');
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameTextController.text,
          'email':_emailTextController.text ,
          'userImage': imageUrl,
          'phoneNumber': _phoneNumberController.text,
          'positionInCompany': _positionCPTextController.text,
          'createdAt': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      }
      catch(error)
      {
        setState(() {
          _isLoading = false;
        });
        GlobalMethode.showErrorDialog(
          error:error.toString(),
          context: context,
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    )..addListener(() {
      setState(() {

      });
    })..addStatusListener((animationStatus) {
      if(animationStatus == AnimationStatus.completed)
      {
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size ;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=20&m=557608443&s=170667a&w=0&h=qairLP-jfa9rgF67PxcCTpJfwbM2lM_lredYtiF6hIs=",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Image.asset('assets/images/wallpaper.jpg',fit: BoxFit.fill,),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: ListView(
              children:[
                SizedBox(
                  height:size.height * 0.1,
                ),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      TextSpan(
                        text: '   ',
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()
                        {
                          Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null ;
                        },
                        text: 'Login',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue.shade300,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                // Email
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex:2,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: ()=>
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode),
                              keyboardType: TextInputType.name,
                              controller: _fullNameTextController,
                              validator: (value)
                              {
                                if(value!.isEmpty)
                                {
                                  return 'This Field is missing' ;
                                }
                                else
                                {
                                  return null ;
                                }
                              },
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Full name',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white
                                  ),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width * 0.24,
                                  height: size.width * 0.24,
                                  decoration:BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: imageFile == null
                                        ? Image.network(
                                          'https://i.pinimg.com/736x/d7/25/1e/d7251e692ccbbcdad3a8a9d3afeaf8e1--vector-icons-vectors.jpg',
                                          fit: BoxFit.fill,
                                    ) : Image.file(
                                          imageFile!,
                                          fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: InkWell(
                                  onTap: ()
                                  {
                                    _showImageDialog();
                                  },
                                  child: Container(
                                    decoration:BoxDecoration(
                                      color: Colors.pink,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        imageFile == null
                                            ? Icons.add_a_photo
                                            : Icons.edit_outlined,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=>
                            FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        validator: (value)
                        {
                          if(value!.isEmpty || !value.contains("@"))
                          {
                            return 'Please enter a valid Email address' ;
                          }
                          else
                          {
                            return null ;
                          }
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=>
                            FocusScope.of(context)
                                .requestFocus(_phoneNumberFocusNode),
                        focusNode: _passFocusNode,
                        obscureText: _obsecureText,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordTextController,
                        validator: (value)
                        {
                          if(value!.isEmpty || value.length < 7)
                          {
                            return 'Please enter a valid Password' ;
                          }
                          else
                          {
                            return null ;
                          }
                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: ()
                            {
                              setState((){
                                _obsecureText = !_obsecureText ;
                              });
                            },
                            child: Icon(
                              _obsecureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        focusNode: _phoneNumberFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=>
                            FocusScope.of(context)
                                .requestFocus(_positionCPFocusNode),
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        validator: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'This Field is missing' ;
                          }
                          else
                          {
                            return null ;
                          }
                        },
                        onChanged: (value)
                        {

                        },
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: ()
                        {
                          _showTaskCategoriesDialog(size: size);
                        },
                        child: TextFormField(
                          enabled: false,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: ()=> _submitFormOnRegister(),
                          focusNode: _positionCPFocusNode,
                          keyboardType: TextInputType.name,
                          controller: _positionCPTextController,
                          validator: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'This Field is missing' ;
                            }
                            else
                            {
                              return null ;
                            }
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Position in the company',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.red
                              ),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                _isLoading ?Center(
                  child:Container(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(),
                  ),) :MaterialButton(
                  onPressed:_submitFormOnRegister,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register',
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
                          Icons.person_add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog()
  {
    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        title: Text(
          'Please choose an option',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: ()
              {
                _getFromCamera();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              onTap: ()
              {
                _getFromGallery();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _getFromGallery() async
  {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    Navigator.pop(context);
  }

  void _getFromCamera() async
  {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    Navigator.pop(context);
  }

  void _cropImage(filePath) async
  {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if(croppedImage != null)
    {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _showTaskCategoriesDialog({required size})
  {
    showDialog(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          title: Text(
            'choose your jops',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.pink.shade800
            ),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Constants.jobsList.length,
              itemBuilder:(context, index)
              {
                return InkWell(
                  onTap: ()
                  {
                    setState(() {
                      _positionCPTextController.text = Constants.jobsList[index];
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
                          Constants.jobsList[index],
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
}
