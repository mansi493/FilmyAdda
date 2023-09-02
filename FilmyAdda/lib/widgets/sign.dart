import 'package:flutter/material.dart';
import 'package:flutter_fire_base_register/auth/auth.dart';
import 'package:flutter_fire_base_register/screens/welcome_screen.dart';
import 'widget.dart';

class SignIn extends StatefulWidget {
  SignIn({
    Key? key,
    required this.formKey,
    required this.textControllers,
    required this.nodes,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final List<TextEditingController> textControllers;
  final List<FocusNode> nodes;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices _services = AuthServices();

  String? mail;
  String? password;
  bool isLoad = true;
  Color buttonColor = Colors.red; // Initial button color
  String signInButtonText = 'Sign In';

  Future<void> signIn(BuildContext context) async {
    widget.formKey.currentState!.validate();

    mail = widget.textControllers[0].text;
    password = widget.textControllers[1].text;

    if (mail!.isNotEmpty && password!.isNotEmpty) {
      setState(() {
        isLoad = false;
        buttonColor = Colors.green; // Change button color when pressed
        signInButtonText = 'Processing';
      });

      final user = await _services.signMailPassword(mail, password);

      setState(() {
        isLoad = true;
        buttonColor = Colors.red; // Reset button color when released
        signInButtonText = 'Sign In';
      });

      if (user == null) {
        // User not found or authentication failed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('User Not Found'),
              content: Text('The email or password you entered is incorrect.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Successful signing
        print('Successful signing');
      }
    } else if (mail!.isNotEmpty && password!.isEmpty) {
      FocusScope.of(context).requestFocus(widget.nodes[1]);
    }
  }

  void logIn(BuildContext context) {
    WelcomeScreen.of(context).jumpLogin();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.2),
            Image.asset(
              'assets/1.png',
              width: size.width * 0.5,
            ),
            InputWidget(
              formKey: widget.formKey,
              editController: widget.textControllers,
              itemCount: widget.textControllers.length,
              nodes: widget.nodes,
              icons: [
                Icons.mail,
                Icons.lock,
              ],
              type: [
                TextInputType.emailAddress,
                TextInputType.visiblePassword,
              ],
              titles: [
                'E-mail',
                'Password',
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: size.width * .8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  primary: buttonColor, // Set button color
                ),
                onPressed: () => signIn(context),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0.0,
                      child: !isLoad
                          ? Container(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox.shrink(),
                    ),
                    Center(child: Text(signInButtonText)),
                  ],
                ),
              ),
            ),
            Text(
              'or',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: size.width * .6,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Register'),
                onPressed: () => logIn(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
