import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_app2/auth/pages/register.dart';
// ignore: unused_import
import 'package:flutter_app2/profile/pages/profil.dart';
// ignore: unused_import
import 'package:flutter_app2/profile/pages/tape.dart';

// ignore: unused_import
import 'package:flutter_app2/profile/widgets/botton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Вход успешен
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Вход успешен')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Botton()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка входа: неправильная почта или пароль')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(254, 254, 254, 1),
        title: const Text('Авторизация'),
        centerTitle: true,
      ),
      // ignore: use_full_hex_values_for_flutter_colors
      backgroundColor: const Color.fromRGBO(243, 244, 246, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  TextField(
                    controller: emailController,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16.0, // Optional: Set font size
                      fontWeight: FontWeight.w300, // Optional: Set font weight
                    ),
                    decoration: InputDecoration(
                      hintText: "Почта",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(195, 195, 195, 1),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color.fromRGBO(254, 254, 254, 1),
                    ),
                  ),

                  Divider(
                    height: 0,
                    color: const Color.fromRGBO(255, 202, 202, 202),
                  ),
                  TextField(
                    controller: passwordController,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16.0, // Optional: Set font size
                      fontWeight: FontWeight.w300, // Optional: Set font weight
                    ),
                    decoration: InputDecoration(
                      hintText: "Пароль",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(195, 195, 195, 1),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color.fromRGBO(254, 254, 254, 1),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(210, 49, 49, 1),
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Войти',
                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPG(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(210, 49, 49, 1),
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    child: const Text(
                      'Зарегистрироваться',
                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
