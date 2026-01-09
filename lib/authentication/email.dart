import 'package:flutter/material.dart';
import '../components/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  return emailRegex.hasMatch(email);
}

class _EmailPageState extends State<EmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();

  Future<void> _createUserAndSendVerification(String email) async {
    final auth = FirebaseAuth.instance;

    final tempPassword = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: tempPassword,
      );

      await cred.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception(
          'Email already registered. Please login instead.',
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final field = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    );

    return AuthLayout(
      buttonText: "Send OTP",
      onButtonPressed: () async {
        if (_formKey.currentState!.validate()) {
          final email = emailCtrl.text.trim();

          try {
            await _createUserAndSendVerification(email);

            Navigator.pushNamed(
              context,
              '/otp',
              arguments: emailCtrl.text.trim(),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        }
      },
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Login or Register",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 150,
              child: Center(
                child: Image.asset('assets/icon/email.png'),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Enter your email"),
            const SizedBox(height: 6),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(border: field),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!isValidEmail(value)) {
                  return 'Email is not valid';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}