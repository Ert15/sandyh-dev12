import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app2/auth/pages/login.dart';

class RegisterPG extends StatefulWidget {
  const RegisterPG({super.key});

  @override
  State<RegisterPG> createState() => _RegisterPGState();
}

class _RegisterPGState extends State<RegisterPG> {
  bool isButtonEnabled = true;

  final TextEditingController loginController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Регистрация успешна')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      // Сохраняем дополнительные данные в Firestore
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'login': loginController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
        }, SetOptions(merge: true));
      }
      // Регистрация успешна
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ошибка регистрации: неправильный email, номер или пароль',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final numberFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
    // ignore: unused_local_variable
    final lengthFormatter = LengthLimitingTextInputFormatter(11);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 249, 249),
        title: const Text('Регистрация'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ЛОГИН
                  TextField(
                    controller: loginController,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16.0, // Optional: Set font size
                      fontWeight: FontWeight.w300, // Optional: Set font weight
                    ),
                    decoration: InputDecoration(
                      hintText: "Логин",
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
                    controller: phoneController,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16.0, // Optional: Set font size
                      fontWeight: FontWeight.w300, // Optional: Set font weight
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [numberFormatter, lengthFormatter],
                    decoration: InputDecoration(
                      hintText: "Телефон",
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
                    controller: emailController,
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16.0, // Optional: Set font size
                      fontWeight: FontWeight.w300, // Optional: Set font weight
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(195, 195, 195, 1),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      filled: true,
                      border: InputBorder.none,

                      fillColor: const Color.fromRGBO(254, 254, 254, 1),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: const Color.fromRGBO(255, 202, 202, 202),
                  ),

                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      // ПАРОЛЬ
                      TextField(
                        controller: passwordController,
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 16.0, // Optional: Set font size
                          fontWeight:
                              FontWeight.w300, // Optional: Set font weight
                        ),
                        obscureText: isButtonEnabled,
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
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isButtonEnabled = !isButtonEnabled;
                          });
                        },
                        icon: Icon(
                          // ignore: dead_code
                          isButtonEnabled
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 370, left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(210, 49, 49, 1),
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          6,
                        ), // 8 = лёгкое скругление
                      ),
                    ),
                    child: const Text(
                      'Создать аккаунт',
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
