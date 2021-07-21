import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //---------------------------------------------------------------
  final _formkey = GlobalKey<FormState>();
  var  _email = '';
  var _password = '';
  var  _username = '';
  bool isLoginPage = true;
  //----------------------------------------------------------------
  startauthentication(){
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(validity)
      {
        _formkey.currentState!.save();
        submitform(_email, _password, _username);
      }

  }
  submitform(String email, String password, String username)async{
    final auth = FirebaseAuth.instance;
    AuthResult authResult;
    try{
      if(isLoginPage)
        {
          authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
        }
      else{
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore.instance.collection('users').document(uid).setData(
            {
              'username':username,
              'email' : email
            });
      }
    }
    catch(err){
      print(err);
    }


  }

  //-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(children: [
        Container(
          padding: EdgeInsets.only(left:10, right: 10, top: 10),
          child: Form(key: _formkey,child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image(
                    image:
                    AssetImage('assets/images/icon.png'),
                  ),
                ),
              ),
              Text(
                "MY TO-DOs.",
                style: GoogleFonts.kanit(fontSize: 45, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              if(!isLoginPage)
                TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('Username'),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Incorrect Username';
                  }
                  return null;
                },
                onSaved: (value){
                  _username = value!;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide()),
                    labelText: "Enter Username",
                    labelStyle: GoogleFonts.roboto()),
              ),

            SizedBox(height: 10),

            TextFormField(
                keyboardType: TextInputType.emailAddress,
                key: ValueKey('email'),
                validator: (value){
                  if(value!.isEmpty || !value.contains('@')){
                    return 'Incorrect Email';
                  }
                  return null;
                },
                onSaved: (value){
                  _email = value!;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide()),
                    labelText: "Enter Email",
                    labelStyle: GoogleFonts.roboto()),
              ),

              SizedBox(height: 10),

              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                key: ValueKey('Password'),
                validator: (value){
                  if(value!.isEmpty || !value.contains('@')){
                    return 'Incorrect Email';
                  }
                  return null;
                },
                onSaved: (value){
                  _password = value!;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide()),
                    labelText: "Enter Password",
                    labelStyle: GoogleFonts.roboto()),
              ),
              SizedBox(height: 35),

              Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(onPressed: (){
                    startauthentication();
                  },
                    child: isLoginPage
                          ? Text('LOG IN',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16, fontWeight: FontWeight.bold),)
                          : Text('SIGN UP',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(

                      primary: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(onPressed: (){
                    setState(() {
                      isLoginPage = !isLoginPage;
                    });
                  },
                    child: isLoginPage
                      ?Text('Not a member?',style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),)
                      :Text('Already have an account?',style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(

                        primary: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  )),





          ],),
          ))
      ],
      ));
  }
}
