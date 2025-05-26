import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  late final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1CA4AC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 180,
                    width: 180,
                    child: Image.asset('assets/image/startpage.png'),
                  ),
                ],
              ),
            ),
            Container(
              height: 630,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55),
                  topRight: Radius.circular(55),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1CA4AC),
                        fontSize: 29),
                  ),
                  const Text(
                    'Create a new password',
                    style: TextStyle(color: Color(0xFF1CA4AC)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: TextField(
                      controller: _email,
                      cursorColor: Color(0xFF1CA4AC),
                      decoration: const InputDecoration(
                        hintText: 'enter your email to reset password',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Color(0xFF1CA4AC),
                        ),
                        icon: Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1CA4AC),
                              ),
                            );
                          });
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          icon: const Icon(
                            Icons.check_outlined,
                            color: Colors.green,
                          ),
                          title: const Text('Email Send'),
                          content: const Text(
                            'If the address exists, a reset link is in your inbox',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        barrierDismissible: false,
                      );
                      await Future.delayed(Duration(seconds: 3));
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 37,
                      width: 123,
                      decoration: BoxDecoration(
                          color: Color(0xFF1CA4AC),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Send Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Check your email to reset!!',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
