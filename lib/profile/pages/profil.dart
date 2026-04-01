import 'package:flutter/material.dart';
import 'package:flutter_app2/auth/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String? login;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // email берём сразу из Auth
      final String? authEmail = user.email;
      final String fallbackLogin =
          user.displayName ??
          (authEmail != null ? authEmail.split('@').first : 'Пользователь');

      setState(() {
        email = authEmail;
        login = fallbackLogin;
      });

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        print('Doc exists: ${doc.exists}');
        print('Doc data: ${doc.data()}');

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final String? loginFromDb = (data['login'] ?? '').toString().trim();
          final String? emailFromDb = (data['email'] ?? '').toString().trim();

          setState(() {
            if (loginFromDb != null && loginFromDb.isNotEmpty) {
              login = loginFromDb;
            }
            if (emailFromDb != null && emailFromDb.isNotEmpty) {
              email = emailFromDb;
            }
          });

          print('Login loaded: $login');
          print('Email loaded: $email');
        }
      } catch (e) {
        print('Firestore error: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ошибка загрузки данных: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(254, 254, 254, 1),
        title: const Text('Профиль'),
      ),
      backgroundColor: const Color.fromRGBO(243, 244, 246, 1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      size: 100,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        login != null && login!.isNotEmpty
                            ? login!
                            : 'Username',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        email ?? 'email@gmail.com',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(146, 146, 146, 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(254, 254, 254, 1),
                        minimumSize: const Size(double.infinity, 64),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ВЫЙТИ',
                          style: TextStyle(
                            color: Color.fromRGBO(236, 58, 77, 1),
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
