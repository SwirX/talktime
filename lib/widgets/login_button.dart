import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String text;
  final Function loginMethod;
  final double borderRadius;
  final double width;
  final Color shadow;

  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.loginMethod,
    this.borderRadius = 50,
    this.width = double.infinity,
    this.shadow = const Color(0x00ffffff),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width,
      margin: const EdgeInsets.only(bottom: 10),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(color),
          elevation: const MaterialStatePropertyAll<double>(25),
          shadowColor: MaterialStatePropertyAll<Color>(shadow),
        ),
        onPressed: () => loginMethod(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
