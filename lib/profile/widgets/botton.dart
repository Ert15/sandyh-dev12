import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/auth/bloc/sandyq_list_bloc.dart';
import 'package:flutter_app2/models/searc_user_repository.dart';
import 'package:flutter_app2/profile/pages/like.dart';
import 'package:flutter_app2/profile/pages/tape.dart';
import 'package:flutter_app2/profile/pages/profil.dart';
import 'package:flutter_app2/profile/pages/map.dart';

class Botton extends StatefulWidget {
  const Botton({super.key});

  @override
  State<Botton> createState() => _BottonState();
}

class _BottonState extends State<Botton> {
  var _selectedIndex = 0;
  final PageController _pagescontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SandyqListBloc(postRepository: PostRepository())
            ..add(FetchReasstarans()),
      child: Scaffold(
        body: PageView(
          controller: _pagescontroller,
          onPageChanged: (index) => setState(() => _selectedIndex = index),
          children: [
            Tape(index: _selectedIndex),
            const MapScreen(),
            Like(index: _selectedIndex),
            Profil(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color.fromRGBO(210, 49, 49, 1),
          backgroundColor: Color.fromRGBO(152, 41, 41, 1),
          unselectedItemColor: Color.fromRGBO(0, 0, 0, 1),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pagescontroller.jumpToPage(index);
    });
  }
}
