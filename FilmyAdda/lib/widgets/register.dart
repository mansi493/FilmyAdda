import 'package:flutter/material.dart';
import 'package:flutter_fire_base_register/screens/screen.dart';
import 'package:flutter_fire_base_register/screens/welcome_screen.dart';
import 'package:flutter_fire_base_register/widgets/widget.dart';
import 'package:flutter_fire_base_register/auth/auth.dart';

class Register extends StatefulWidget {
  Register({
    Key? key,
    required this.formKeys,
    required this.textControllers,
    required this.nodes,
  }) : super(key: key);

  final GlobalKey<FormState> formKeys;
  final List<TextEditingController> textControllers;
  final List<FocusNode> nodes;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthServices _serives = AuthServices();

  String? mail;
  String? password;
  bool isRegisterButtonPressed =
      false; // Track if the register button is pressed
  String registerButtonText = 'Register';

  void navigateToWelcomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Image.asset('assets/1.png', width: size.width * 0.5),
            InputWidget(
              formKey: widget.formKeys,
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
                'e-mail',
                'password',
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: size.width * .6,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (!isRegisterButtonPressed) {
                        // Only allow registration if button is not pressed
                        widget.formKeys.currentState!.validate();

                        mail = widget.textControllers[0].text;
                        password = widget.textControllers[1].text;

                        if (mail!.isNotEmpty && password!.isNotEmpty) {
                          setState(() {
                            isRegisterButtonPressed = true;
                            registerButtonText = 'Processing';
                          });

                          await _serives.registerMailPassword(mail, password);

                          setState(() {
                            isRegisterButtonPressed = false;
                            registerButtonText = 'Register';
                          });
                        } else if (mail!.isNotEmpty && password!.isEmpty) {
                          FocusScope.of(context).requestFocus(widget.nodes[1]);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isRegisterButtonPressed
                            ? Colors.green
                            : Colors.blue, // Change color when pressed
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        textColor: Colors.white,
                        child: Text(registerButtonText),
                        onPressed: null, // We handle onPressed in InkWell
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'or',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(
                    width: size.width * .8,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('Sign In'),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
