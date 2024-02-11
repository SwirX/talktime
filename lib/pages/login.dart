// ignore_for_file: sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talktime/services/auth.dart';
import 'package:talktime/widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool pwVisibility = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0090FF), Color(0xFFFF3A00)],
            stops: [0, 1],
            begin: AlignmentDirectional(-0.87, -1),
            end: AlignmentDirectional(0.87, 1),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
                child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: const Text(
                    "TalkTime",
                    style: TextStyle(
                      fontFamily: 'BerlinSans',
                      // color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 570,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 35, 40),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        // color: Color.fromARGB(255, 0, 0, 0),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Welcome Back!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 24),
                            child: Text(
                              "Fill out the information below in order to access your account.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: emailController,
                                autofocus: true,
                                autofillHints: const [AutofillHints.email],
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                    fontFamily: GoogleFonts.getFont("Poppins")
                                        .fontFamily,
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 35, 35, 40),
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF55628b),
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffff5963),
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffff5963),
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xff14181b),
                                ),
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: passwordController,
                                autofocus: false,
                                autofillHints: const [AutofillHints.password],
                                obscureText: !pwVisibility,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 35, 35, 40),
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF55628b),
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffff5963),
                                      width: 0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xff14181b),
                                  suffixIcon: InkWell(
                                    onTap: () => setState(
                                      () => pwVisibility = !pwVisibility,
                                    ),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      pwVisibility
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      color: Colors.grey,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: Container(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  Auth().signInWithEmailAndPassword(
                                      email, password);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xff3c83bf),
                                ),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                            child: Text(
                              "Or",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: LoginButton(
                              text: "Continue With Google",
                              icon: FontAwesomeIcons.google,
                              color: const Color.fromARGB(255, 35, 35, 40),
                              loginMethod: Auth().googleLogin,
                              shadow: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: LoginButton(
                              text: "Continue With Apple",
                              icon: FontAwesomeIcons.apple,
                              color: const Color.fromARGB(255, 35, 35, 40),
                              loginMethod: Auth().signInWithApple,
                              shadow: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 16),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                Navigator.pushNamed(context, "/signup");
                              },
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Don't have an account?",
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text: " Sign Up here",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Color(0xff2e7ec1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xffdcdcff),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                textScaler: MediaQuery.of(context).textScaler
                              ),
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
    );
  }
}
