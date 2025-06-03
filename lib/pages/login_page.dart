import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';  // Import Flushbar
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? error;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final err = await ApiService.login(usernameCtrl.text, passwordCtrl.text);
      
      if (err != null) {
        setState(() {
          error = err;
          isLoading = false;
        });

        Flushbar(
          message: "Login gagal: $error",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.TOP,
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          borderRadius: BorderRadius.circular(12),
          padding: EdgeInsets.all(16),
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          messageColor: Colors.white,
          forwardAnimationCurve: Curves.easeOut,
          reverseAnimationCurve: Curves.easeIn,
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
          animationDuration: Duration(milliseconds: 300),
        ).show(context);
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 120), 
          child: Form(  
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome Back',
                  style: 
                  GoogleFonts.inter(
                    textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ), 
                  )           
                ),
                Text('Log In to your account',
                  style: GoogleFonts.inter(),
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                SizedBox(height: 12),
                Text('Username',
                  style: GoogleFonts.inter(),
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Color(0xffebf2f7),
                    hintStyle: GoogleFonts.inter(
                      textStyle: TextStyle(color: Colors.grey[500]),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none, 
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;  
                  },
                ), 
                SizedBox(height: 12),
                Text('Password',
                  style: GoogleFonts.inter(),
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Color(0xffebf2f7),
                    hintStyle: 
                    GoogleFonts.inter(textStyle: 
                     TextStyle(color: Colors.grey[500]),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none, 
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 40), child:
                  ElevatedButton( 
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF60a5fa),
                      padding: EdgeInsets.symmetric(vertical: 18), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: isLoading ? Text('Loging In...') : Text('Login'),
                  ), 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
