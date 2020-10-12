import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tribal_repository/RegistrationPage.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
class password extends StatefulWidget {
  final String title = '';
  @override
  State<StatefulWidget> createState() => SignInPageState();
}
var firestoreAmazon = Firestore.instance;

class SignInPageState extends State<password>{

  getdata(String phone) {

  }
  Widget build( BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tribal talent'), backgroundColor: Colors.green,

      ),
      backgroundColor: Colors.white60,
      body:
      ListView(
        children: <Widget>[
          _PhoneSignInSection(),
        ],
      ),
    );

  }

}
class _PhoneSignInSection extends StatefulWidget {


  _PhoneSignInSection();
  @override
  State<StatefulWidget> createState() => _PhoneSignInSectionState();
}

class _PhoneSignInSectionState extends State<_PhoneSignInSection> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;
  DocumentReference docRef = firestoreAmazon.collection('Officials').document('userOfficials');
  List data;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: const Text(''),
          padding:const EdgeInsets.all(16),
          alignment: Alignment.center,
        ),
        TextFormField(
          controller: phoneNumberController,
          decoration: const InputDecoration(
              labelText: 'Phone number (+xxxxxxxxxxxx)'

          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Phone number (+xxxxxxxxxxxx)';
            }
            return null;
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              _verifyPhoneNumber();
            },
            color: Colors.white70,
            child: const Text('Request OTP'),
          ),
        ),
        TextField(
          controller: _smsController,
          decoration: const InputDecoration(labelText: 'Verification code'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              _signInWithPhoneNumber();
            },
            color: Colors.white70,
            child: const Text('Login'),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _message,
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
  void _verifyPhoneNumber() async {
    docRef.get().then((datasnapshot){
      if(datasnapshot.exists) {
        data = datasnapshot.data['phnumbers'];
      }}
    );
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _message =
        'Phone number verification failed. Code: ${authException
            .code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      );
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumberController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    


    setState(() {
      if (user != null) {

          if (data.contains(phoneNumberController.text)) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()));
        }
          else {
            _message = 'not a registered user';
          }
      }
      else {
        _message = 'Sign in failed';
      }
    }
    );
  }
}