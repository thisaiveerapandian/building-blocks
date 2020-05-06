import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn();

class SocialSignIn extends StatefulWidget {
  @override
  State createState() => SocialSignInState();
}

class SocialSignInState extends State<SocialSignIn> {
  GoogleSignInAccount _currentUser;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _googleLoginIn() async {
    try {
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser.email);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _facebookLoginIn() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final token = accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        final profile = json.decode(graphResponse.body);
        print(profile);
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<void> facebookLogOut() => facebookSignIn.logOut();

  Future<void> googleLogOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SignInButton(
            Buttons.Google,
            onPressed: () => _googleLoginIn(),
          ),
          SignInButton(
            Buttons.Facebook,
            onPressed: () => _facebookLoginIn(),
          ),
        ],
      );
    else
      return Container();
  }
}
