import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:work_os/screens/auth/forget_pass.dart';
import 'package:work_os/screens/auth/register.dart';
import 'package:work_os/services/global_methode.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation ;
  late TextEditingController _emailTextController = TextEditingController();
  late TextEditingController _passwordTextController = TextEditingController();
  bool _obsecureText = true ;
  final _loginFormKey = GlobalKey<FormState>();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance ;
  bool _isLoading = false;

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void _submitFormOnLogin() async
  {
    final isValid = _loginFormKey.currentState!.validate();
    if(isValid)
    {
      setState(() {
        _isLoading = true;
      });
      try
      {
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passwordTextController.text.trim(),
        );
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
                  'Login',
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
                      text: 'Don\'t have an account',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=>Register(),
                          ),
                        );
                      },
                      text: 'Register',
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
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: ()=>
                            FocusScope.of(context)
                                .requestFocus(_passFocusNode),
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
                        focusNode: _passFocusNode,
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
                    ],
                  ),
                ),
                //password

                SizedBox(
                  height: 15.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed:()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)=>ForgetPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                MaterialButton(
                  onPressed:_submitFormOnLogin,
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
                          'login',
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
                          Icons.login,
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
}
