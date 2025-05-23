import 'package:flutter/material.dart';

import '../movel/login.dart';

class WebLogin extends StatefulWidget {
  const WebLogin({super.key});

  @override
  State<WebLogin> createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color(0xFF2E1E82),
              child: Center(
                child: SizedBox(
                  height: 500,
                  width: 500,
                  child: Image.asset(
                    "assets/img/logo.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 3,
            child: Center(
              child: Login(),
            ),
          ),
        ],
      ),
    );
  }
}
